Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFB61AC26D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895696AbgDPN2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895679AbgDPN2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE569206E9;
        Thu, 16 Apr 2020 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043688;
        bh=klwZoOuNPCfhdbzMWgDKw96yntXOh3QGWA0AoC+8d5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yE+XBKdY33HKOL0zTj/dtdIR3Oi9mfEhExQ3k37ISuodpO0HdM7fn3vdL/c6OIftf
         9s3dB7zGBO8JaTQRg7jl76rFSYSWXuROf8p/m475qr/TdWQ2t95TJHoGt3XXl0tfdA
         ac8+DjTFzyVjxFAv122AkwQiGvWf2tbuEoHRCtLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 059/146] media: ti-vpe: cal: fix disable_irqs to only the intended target
Date:   Thu, 16 Apr 2020 15:23:20 +0200
Message-Id: <20200416131250.971337378@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

commit 1db56284b9da9056093681f28db48a09a243274b upstream.

disable_irqs() was mistakenly disabling all interrupts when called.
This cause all port stream to stop even if only stopping one of them.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/ti-vpe/cal.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -541,16 +541,16 @@ static void enable_irqs(struct cal_ctx *
 
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


