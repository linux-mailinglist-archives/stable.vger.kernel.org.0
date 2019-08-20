Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895D5960A7
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfHTNmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730240AbfHTNme (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:34 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3AC2339F;
        Tue, 20 Aug 2019 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308552;
        bh=jo2OaElzij4WqL7QcwC9Oto8b3h1wNr7KwstU2QAYl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2j5LEWvfnO0NlqziH5wrynotvUOby5uXadZyosVQjM4yUXesDtr92Bd6zFDZRl7d3
         Ox2UTQuRvThsbzXYi21t59+J2PetBWDT/2deZ4cMZaEpGQy/JGjpBUf/FI4pKH2EH+
         iug+9cA917Euw9QydjmELgV5uhyBu/CsfmUEIyVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/27] omap-dma/omap_vout_vrfb: fix off-by-one fi value
Date:   Tue, 20 Aug 2019 09:42:02 -0400
Message-Id: <20190820134213.11279-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit d555c34338cae844b207564c482e5a3fb089d25e ]

The OMAP 4 TRM specifies that when using double-index addressing
the address increases by the ES plus the EI value minus 1 within
a frame. When a full frame is transferred, the address increases
by the ES plus the frame index (FI) value minus 1.

The omap-dma code didn't account for the 'minus 1' in the FI register.
To get correct addressing, add 1 to the src_icg value.

This was found when testing a hacked version of the media m2m-deinterlace.c
driver on a Pandaboard.

The only other source that uses this feature is omap_vout_vrfb.c,
and that adds a + 1 when setting the dst_icg. This is a workaround
for the broken omap-dma.c behavior. So remove the workaround at the
same time that we fix omap-dma.c.

I tested the omap_vout driver with a Beagle XM board to check that
the '+ 1' in omap_vout_vrfb.c was indeed a workaround for the omap-dma
bug.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Link: https://lore.kernel.org/r/952e7f51-f208-9333-6f58-b7ed20d2ea0b@xs4all.nl
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/omap-dma.c                    | 4 ++--
 drivers/media/platform/omap/omap_vout_vrfb.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index a4a931ddf6f69..aeb9c29e52554 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1237,7 +1237,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_interleaved(
 	if (src_icg) {
 		d->ccr |= CCR_SRC_AMODE_DBLIDX;
 		d->ei = 1;
-		d->fi = src_icg;
+		d->fi = src_icg + 1;
 	} else if (xt->src_inc) {
 		d->ccr |= CCR_SRC_AMODE_POSTINC;
 		d->fi = 0;
@@ -1252,7 +1252,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_interleaved(
 	if (dst_icg) {
 		d->ccr |= CCR_DST_AMODE_DBLIDX;
 		sg->ei = 1;
-		sg->fi = dst_icg;
+		sg->fi = dst_icg + 1;
 	} else if (xt->dst_inc) {
 		d->ccr |= CCR_DST_AMODE_POSTINC;
 		sg->fi = 0;
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 29e3f5da59c1f..11ec048929e80 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -253,8 +253,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 	 */
 
 	pixsize = vout->bpp * vout->vrfb_bpp;
-	dst_icg = ((MAX_PIXELS_PER_LINE * pixsize) -
-		  (vout->pix.width * vout->bpp)) + 1;
+	dst_icg = MAX_PIXELS_PER_LINE * pixsize - vout->pix.width * vout->bpp;
 
 	xt->src_start = vout->buf_phy_addr[vb->i];
 	xt->dst_start = vout->vrfb_context[vb->i].paddr[0];
-- 
2.20.1

