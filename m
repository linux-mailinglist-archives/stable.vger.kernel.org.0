Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B804309D6
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 16:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhJQOrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 10:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbhJQOrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 10:47:07 -0400
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3886EC061765;
        Sun, 17 Oct 2021 07:44:56 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 42883C6403; Sun, 17 Oct 2021 15:44:53 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1634481893; bh=H47VU2xt5c1LoPLhqeWJew/dqAzbeQcVCiyw2wMhjgk=;
        h=From:To:Cc:Subject:Date:From;
        b=ZBVKvs42DiSKU3jMQadhea3l7XJJJjmYOpm8Ox/dl4pHXnB9wieJzSA+OdHpvbKgU
         7TM0OzILsul308qUATB0D/lHTYsja6oYZlZb+XFJWYRzrs+tJ2hr8NJqGHADPkRbGf
         HlkZHBAzxW7OCsqQT6STHKppM/JJKBJGCouLwc0Kem/59nYJDLnMJv2uf08ruqmxh2
         UPmDB4uRlwQ5vhCuGF/hHxTi3GNWzgQq/VjCJhZO2/SHO+PYjUUhkT0zLJskyWHbWr
         mL9Ot5VgsRoilDUwG34AJyElO/AMuaOw2hC09pLjR0JtDe5L1CrWM+q2t5xFOFVtlg
         +JEfzuOli/nwg==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     Bryan Pass <bryan.pass@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] media: ite-cir: IR receiver stop working after receive overflow
Date:   Sun, 17 Oct 2021 15:44:53 +0100
Message-Id: <20211017144453.9795-1-sean@mess.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On an Intel NUC6iSYK, no IR is reported after a receive overflow.

When a receiver overflow occurs, this condition is only cleared by
reading the fifo. Make sure we read anything in the fifo.

Fixes: 28c7afb07ccf ("media: ite-cir: check for receive overflow")

Suggested-by: Bryan Pass <bryan.pass@gmail.com>
Tested-by: Bryan Pass <bryan.pass@gmail.com>
Cc: stable@vger.kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ite-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.31.1

