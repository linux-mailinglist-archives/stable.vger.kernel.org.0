Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB081CA0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfHENZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731320AbfHENZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E67C20644;
        Mon,  5 Aug 2019 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011551;
        bh=F5nmWI4N3L3upEYEKPWEfR2p0H16olBUXqf9oPpehg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agS+SWwhHadZWRNEWN23iIOihG4/mqofXKFDdAvxHcPkjVVJrSGZHz7NKCHRxP9Hl
         mmMxnFHOmqDdiKfaU2zxQvthemcHs+NCeuSxEGYKWKdDQ2xPwyIOt0HvuJQsBz9KWj
         9N8hu4GenlocGb2NvOI14T9pHKX70Fimhq98NLuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>
Subject: [PATCH 5.2 131/131] drm/i915/gvt: fix incorrect cache entry for guest page mapping
Date:   Mon,  5 Aug 2019 15:03:38 +0200
Message-Id: <20190805125000.899343807@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolin Zhang <xiaolin.zhang@intel.com>

commit 7366aeb77cd840f3edea02c65065d40affaa7f45 upstream.

GPU hang observed during the guest OCL conformance test which is caused
by THP GTT feature used durning the test.

It was observed the same GFN with different size (4K and 2M) requested
from the guest in GVT. So during the guest page dma map stage, it is
required to unmap first with orginal size and then remap again with
requested size.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Cc: stable@vger.kernel.org
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/kvmgt.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1911,6 +1911,18 @@ static int kvmgt_dma_map_guest_page(unsi
 		ret = __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
 		if (ret)
 			goto err_unmap;
+	} else if (entry->size != size) {
+		/* the same gfn with different size: unmap and re-map */
+		gvt_dma_unmap_page(vgpu, gfn, entry->dma_addr, entry->size);
+		__gvt_cache_remove_entry(vgpu, entry);
+
+		ret = gvt_dma_map_page(vgpu, gfn, dma_addr, size);
+		if (ret)
+			goto err_unlock;
+
+		ret = __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
+		if (ret)
+			goto err_unmap;
 	} else {
 		kref_get(&entry->ref);
 		*dma_addr = entry->dma_addr;


