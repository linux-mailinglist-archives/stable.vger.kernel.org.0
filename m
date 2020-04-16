Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03911AC7B7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgDPO6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392505AbgDPNzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CEE920732;
        Thu, 16 Apr 2020 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045325;
        bh=JRVBS3sKnILmkEDF8LL8WNz+GxvDMIcn/I95EiCgSu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2humuyGjjcvm6enmfDigBCT+9nUqEGsrL6j5ba38olFu/nY56tqrMjbGe02aZ8aR
         j+C7k9vrMNYtLKCJO391L/fG1fPQ7PqFyg5xpWnCPPX4Rd9pRBaMq5/4pYxJ+BlDBG
         4tS7GS7nZfG24PONo4H57bTfX2WMkFoZ5HVQxtWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.6 087/254] media: ti-vpe: cal: fix disable_irqs to only the intended target
Date:   Thu, 16 Apr 2020 15:22:56 +0200
Message-Id: <20200416131336.803492385@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
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
@@ -722,16 +722,16 @@ static void enable_irqs(struct cal_ctx *
 
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


