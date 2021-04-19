Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9FB364391
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbhDSNVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239887AbhDSNRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:17:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 529F2613D5;
        Mon, 19 Apr 2021 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838065;
        bh=JoSR1JmAXLHjSDwAvnHt+5pIu1kPY4eYIQXc4w8Eo1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiXZdWm7YGhhNWKYdl1tXlFsckMjLQ+IGuepxxK/9ib5Stds9nprucpGnGSFKOeUi
         V3f3GL6Vmb8PUxCXpSFcfqRjBG6MGKkabk/D9AEbq8fzvPrjffXyd/LE/H58nn862z
         L5upR6tN8xnvlaMV+SaTCD6LquQD/RNeBA07ePnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fabian@ritter-vogt.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/103] Input: nspire-keypad - enable interrupts only when opened
Date:   Mon, 19 Apr 2021 15:05:14 +0200
Message-Id: <20210419130527.901551223@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit 69d5ff3e9e51e23d5d81bf48480aa5671be67a71 ]

The driver registers an interrupt handler in _probe, but didn't configure
them until later when the _open function is called. In between, the keypad
can fire an IRQ due to touchpad activity, which the handler ignores. This
causes the kernel to disable the interrupt, blocking the keypad from
working.

Fix this by disabling interrupts before registering the handler.
Additionally, disable them in _close, so that they're only enabled while
open.

Fixes: fc4f31461892 ("Input: add TI-Nspire keypad support")
Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/3383725.iizBOSrK1V@linux-e202.suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/nspire-keypad.c | 56 ++++++++++++++------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/input/keyboard/nspire-keypad.c b/drivers/input/keyboard/nspire-keypad.c
index 63d5e488137d..e9fa1423f136 100644
--- a/drivers/input/keyboard/nspire-keypad.c
+++ b/drivers/input/keyboard/nspire-keypad.c
@@ -93,9 +93,15 @@ static irqreturn_t nspire_keypad_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int nspire_keypad_chip_init(struct nspire_keypad *keypad)
+static int nspire_keypad_open(struct input_dev *input)
 {
+	struct nspire_keypad *keypad = input_get_drvdata(input);
 	unsigned long val = 0, cycles_per_us, delay_cycles, row_delay_cycles;
+	int error;
+
+	error = clk_prepare_enable(keypad->clk);
+	if (error)
+		return error;
 
 	cycles_per_us = (clk_get_rate(keypad->clk) / 1000000);
 	if (cycles_per_us == 0)
@@ -121,30 +127,6 @@ static int nspire_keypad_chip_init(struct nspire_keypad *keypad)
 	keypad->int_mask = 1 << 1;
 	writel(keypad->int_mask, keypad->reg_base + KEYPAD_INTMSK);
 
-	/* Disable GPIO interrupts to prevent hanging on touchpad */
-	/* Possibly used to detect touchpad events */
-	writel(0, keypad->reg_base + KEYPAD_UNKNOWN_INT);
-	/* Acknowledge existing interrupts */
-	writel(~0, keypad->reg_base + KEYPAD_UNKNOWN_INT_STS);
-
-	return 0;
-}
-
-static int nspire_keypad_open(struct input_dev *input)
-{
-	struct nspire_keypad *keypad = input_get_drvdata(input);
-	int error;
-
-	error = clk_prepare_enable(keypad->clk);
-	if (error)
-		return error;
-
-	error = nspire_keypad_chip_init(keypad);
-	if (error) {
-		clk_disable_unprepare(keypad->clk);
-		return error;
-	}
-
 	return 0;
 }
 
@@ -152,6 +134,11 @@ static void nspire_keypad_close(struct input_dev *input)
 {
 	struct nspire_keypad *keypad = input_get_drvdata(input);
 
+	/* Disable interrupts */
+	writel(0, keypad->reg_base + KEYPAD_INTMSK);
+	/* Acknowledge existing interrupts */
+	writel(~0, keypad->reg_base + KEYPAD_INT);
+
 	clk_disable_unprepare(keypad->clk);
 }
 
@@ -210,6 +197,25 @@ static int nspire_keypad_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	error = clk_prepare_enable(keypad->clk);
+	if (error) {
+		dev_err(&pdev->dev, "failed to enable clock\n");
+		return error;
+	}
+
+	/* Disable interrupts */
+	writel(0, keypad->reg_base + KEYPAD_INTMSK);
+	/* Acknowledge existing interrupts */
+	writel(~0, keypad->reg_base + KEYPAD_INT);
+
+	/* Disable GPIO interrupts to prevent hanging on touchpad */
+	/* Possibly used to detect touchpad events */
+	writel(0, keypad->reg_base + KEYPAD_UNKNOWN_INT);
+	/* Acknowledge existing GPIO interrupts */
+	writel(~0, keypad->reg_base + KEYPAD_UNKNOWN_INT_STS);
+
+	clk_disable_unprepare(keypad->clk);
+
 	input_set_drvdata(input, keypad);
 
 	input->id.bustype = BUS_HOST;
-- 
2.30.2



