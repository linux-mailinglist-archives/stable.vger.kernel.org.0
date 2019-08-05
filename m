Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70CC81D3E
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfHENTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfHENTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCD720880;
        Mon,  5 Aug 2019 13:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011163;
        bh=MrAJKCv6cNse/W4T69Bzjx0rHgIpjdfdG4O21grCYHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqVvKkyyvTVZ/AkpMnhni2N+VBq28XZMO27XL5kske7gxgDO7R7c3pXXOYzMZuQgq
         tz0jxDZnB7IxTU5nKbz+8+yiPlAWfOB+RsgViDxGf7RKA2hwQKCcVOTCqI4tgnEpQS
         yGQrjo8Qvydl8XbYgIXY5+Z1sKERku2ZzJ+X9gCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>
Subject: [PATCH 4.19 68/74] drm/i915/gvt: fix incorrect cache entry for guest page mapping
Date:   Mon,  5 Aug 2019 15:03:21 +0200
Message-Id: <20190805124941.302293447@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
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
@@ -1748,6 +1748,18 @@ int kvmgt_dma_map_guest_page(unsigned lo
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


