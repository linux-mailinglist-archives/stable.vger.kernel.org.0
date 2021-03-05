Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323E832E6BC
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhCEKvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:51:25 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:61570 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229615AbhCEKvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 05:51:24 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.69.177;
Received: from build.alporthouse.com (unverified [78.156.69.177]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 24023334-1500050 
        for multiple; Fri, 05 Mar 2021 10:51:16 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] dma-buf: Fix confusion of dynamic dma-buf vs dynamic attachment
Date:   Fri,  5 Mar 2021 10:51:14 +0000
Message-Id: <20210305105114.26338-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c545781e1c55 ("dma-buf: doc polish for pin/unpin") disagrees with
the introduction of dynamism in commit: bb42df4662a4 ("dma-buf: add
dynamic DMA-buf handling v15") resulting in warning spew on
importing dma-buf. Silence the warning from the latter by only pinning
the attachment if the attachment rather than the dmabuf is to be
dynamic.

Fixes: bb42df4662a4 ("dma-buf: add dynamic DMA-buf handling v15")
Fixes: c545781e1c55 ("dma-buf: doc polish for pin/unpin")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v5.7+
---
 drivers/dma-buf/dma-buf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f264b70c383e..09f5ae458515 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -758,8 +758,8 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	    dma_buf_is_dynamic(dmabuf)) {
 		struct sg_table *sgt;
 
-		if (dma_buf_is_dynamic(attach->dmabuf)) {
-			dma_resv_lock(attach->dmabuf->resv, NULL);
+		if (dma_buf_attachment_is_dynamic(attach)) {
+			dma_resv_lock(dmabuf->resv, NULL);
 			ret = dma_buf_pin(attach);
 			if (ret)
 				goto err_unlock;
@@ -772,8 +772,9 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 			ret = PTR_ERR(sgt);
 			goto err_unpin;
 		}
-		if (dma_buf_is_dynamic(attach->dmabuf))
-			dma_resv_unlock(attach->dmabuf->resv);
+		if (dma_buf_attachment_is_dynamic(attach))
+			dma_resv_unlock(dmabuf->resv);
+
 		attach->sgt = sgt;
 		attach->dir = DMA_BIDIRECTIONAL;
 	}
-- 
2.20.1

