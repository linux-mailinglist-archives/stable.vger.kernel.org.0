Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0118D2A52B7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732112AbgKCUwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732109AbgKCUwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E7E2053B;
        Tue,  3 Nov 2020 20:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436752;
        bh=kbL2i6ClqnBNgUCZXfy2B8qSZM3vFB5Ne8HZ2QbPPNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4qx9uoQd+hMtdA6gm7FfBcLTTPwK8P3M7OEJCWMp/bQXfaapUol4R0CeUOFIPi9T
         TyO2QwRumYj4hPnEEBqTot0fvwmfiNiZ+NbCIA1hX3YLQCWENeyByKXbzExDK1Pe9a
         2kNLaWfjRF7ggJkPQ1BRHSab4M0pQE378QP6/Qjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.9 349/391] drm/ttm: fix eviction valuable range check.
Date:   Tue,  3 Nov 2020 21:36:40 +0100
Message-Id: <20201103203410.688165824@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit fea456d82c19d201c21313864105876deabe148b upstream.

This was adding size to start, but pfn and start are in pages,
so it should be using num_pages.

Not sure this fixes anything in the real world, just noticed it
during refactoring.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20201019222257.1684769-2-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -694,7 +694,7 @@ bool ttm_bo_eviction_valuable(struct ttm
 	/* Don't evict this BO if it's outside of the
 	 * requested placement range
 	 */
-	if (place->fpfn >= (bo->mem.start + bo->mem.size) ||
+	if (place->fpfn >= (bo->mem.start + bo->mem.num_pages) ||
 	    (place->lpfn && place->lpfn <= bo->mem.start))
 		return false;
 


