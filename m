Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9408743901E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJYHPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:15:20 -0400
Received: from www.linuxtv.org ([130.149.80.248]:59418 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhJYHPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 03:15:19 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1meuAB-00GpOy-Ue; Mon, 25 Oct 2021 07:12:55 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 19 Oct 2021 07:08:39 +0000
Subject: [git:media_tree/master] media: ite-cir: IR receiver stop working after receive overflow
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Bryan Pass <bryan.pass@gmail.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1meuAB-00GpOy-Ue@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ite-cir: IR receiver stop working after receive overflow
Author:  Sean Young <sean@mess.org>
Date:    Sun Oct 17 13:01:15 2021 +0100

On an Intel NUC6iSYK, no IR is reported after a receive overflow.

When a receiver overflow occurs, this condition is only cleared by
reading the fifo. Make sure we read anything in the fifo.

Fixes: 28c7afb07ccf ("media: ite-cir: check for receive overflow")
Suggested-by: Bryan Pass <bryan.pass@gmail.com>
Tested-by: Bryan Pass <bryan.pass@gmail.com>
Cc: stable@vger.kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/ite-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 5bc23e8c6d91..4f77d4ebacdc 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -242,7 +242,7 @@ static irqreturn_t ite_cir_isr(int irq, void *data)
 	}
 
 	/* check for the receive interrupt */
-	if (iflags & ITE_IRQ_RX_FIFO) {
+	if (iflags & (ITE_IRQ_RX_FIFO | ITE_IRQ_RX_FIFO_OVERRUN)) {
 		/* read the FIFO bytes */
 		rx_bytes = dev->params->get_rx_bytes(dev, rx_buf,
 						    ITE_RX_FIFO_LEN);
