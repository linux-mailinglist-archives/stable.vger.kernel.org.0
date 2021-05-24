Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6765838EFE9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhEXQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234971AbhEXP72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFCA861972;
        Mon, 24 May 2021 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871118;
        bh=ncJtzOT3U+ZWyoeHpWPShHREqEQ2ABrlbIWDbbaSQ5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/A36USY4N/UBSpb2AXzcTQDbHPdfR9h4EKPKrQT6VXgH9aGMAHLl8VQPyM+YZhWi
         VO6h0sSHC8HPm+yVvBnXGpX7DBzWN7n+bkRP3xgbq9Y/OMh6bNts7jM2d3AINFO7Mg
         /Dt2W5Cvol09gDTa3L+VbcQ/bV724uWRekuVgqYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org
Subject: [PATCH 5.12 081/127] dma-buf: fix unintended pin/unpin warnings
Date:   Mon, 24 May 2021 17:26:38 +0200
Message-Id: <20210524152337.591366002@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 7e008b02557ccece4d2c31fb0eaf6243cbc87121 upstream.

DMA-buf internal users call the pin/unpin functions without having a
dynamic attachment. Avoid the warning and backtrace in the logs.

Signed-off-by: Christian König <christian.koenig@amd.com>
Bugs: https://gitlab.freedesktop.org/drm/intel/-/issues/3481
Fixes: c545781e1c55 ("dma-buf: doc polish for pin/unpin")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: stable@kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210517115705.2141-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-buf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -760,7 +760,7 @@ dma_buf_dynamic_attach(struct dma_buf *d
 
 		if (dma_buf_is_dynamic(attach->dmabuf)) {
 			dma_resv_lock(attach->dmabuf->resv, NULL);
-			ret = dma_buf_pin(attach);
+			ret = dmabuf->ops->pin(attach);
 			if (ret)
 				goto err_unlock;
 		}
@@ -786,7 +786,7 @@ err_attach:
 
 err_unpin:
 	if (dma_buf_is_dynamic(attach->dmabuf))
-		dma_buf_unpin(attach);
+		dmabuf->ops->unpin(attach);
 
 err_unlock:
 	if (dma_buf_is_dynamic(attach->dmabuf))
@@ -843,7 +843,7 @@ void dma_buf_detach(struct dma_buf *dmab
 		__unmap_dma_buf(attach, attach->sgt, attach->dir);
 
 		if (dma_buf_is_dynamic(attach->dmabuf)) {
-			dma_buf_unpin(attach);
+			dmabuf->ops->unpin(attach);
 			dma_resv_unlock(attach->dmabuf->resv);
 		}
 	}
@@ -956,7 +956,7 @@ struct sg_table *dma_buf_map_attachment(
 	if (dma_buf_is_dynamic(attach->dmabuf)) {
 		dma_resv_assert_held(attach->dmabuf->resv);
 		if (!IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY)) {
-			r = dma_buf_pin(attach);
+			r = attach->dmabuf->ops->pin(attach);
 			if (r)
 				return ERR_PTR(r);
 		}
@@ -968,7 +968,7 @@ struct sg_table *dma_buf_map_attachment(
 
 	if (IS_ERR(sg_table) && dma_buf_is_dynamic(attach->dmabuf) &&
 	     !IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY))
-		dma_buf_unpin(attach);
+		attach->dmabuf->ops->unpin(attach);
 
 	if (!IS_ERR(sg_table) && attach->dmabuf->ops->cache_sgt_mapping) {
 		attach->sgt = sg_table;


