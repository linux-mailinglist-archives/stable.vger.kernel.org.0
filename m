Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9499317B0DD
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgCEVte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:49:34 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48780 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCEVte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 16:49:34 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j9yLB-004Dps-EQ; Thu, 05 Mar 2020 21:47:37 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 05 Mar 2020 21:47:30 +0000
Subject: [git:media_tree/master] media: ti-vpe: cal: fix disable_irqs to only the intended target
To:     linuxtv-commits@linuxtv.org
Cc:     Benoit Parrot <bparrot@ti.com>, stable <stable@vger.kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j9yLB-004Dps-EQ@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ti-vpe: cal: fix disable_irqs to only the intended target
Author:  Benoit Parrot <bparrot@ti.com>
Date:    Mon Mar 2 14:56:52 2020 +0100

disable_irqs() was mistakenly disabling all interrupts when called.
This cause all port stream to stop even if only stopping one of them.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/ti-vpe/cal.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

---

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 6e009e479be3..6d4cbb8782ed 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -722,16 +722,16 @@ static void enable_irqs(struct cal_ctx *ctx)
 
 static void disable_irqs(struct cal_ctx *ctx)
 {
+	u32 val;
+
 	/* Disable IRQ_WDMA_END 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_CLR(2),
-			CAL_HL_IRQ_CLEAR,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	val = 0;
+	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(2), val);
 	/* Disable IRQ_WDMA_START 0/1 */
-	reg_write_field(ctx->dev,
-			CAL_HL_IRQENABLE_CLR(3),
-			CAL_HL_IRQ_CLEAR,
-			CAL_HL_IRQ_MASK(ctx->csi2_port));
+	val = 0;
+	set_field(&val, CAL_HL_IRQ_CLEAR, CAL_HL_IRQ_MASK(ctx->csi2_port));
+	reg_write(ctx->dev, CAL_HL_IRQENABLE_CLR(3), val);
 	/* Todo: Add VC_IRQ and CSI2_COMPLEXIO_IRQ handling */
 	reg_write(ctx->dev, CAL_CSI2_VC_IRQENABLE(1), 0);
 }
