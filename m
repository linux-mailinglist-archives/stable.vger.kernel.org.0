Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F121EAC31
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbgFASQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731704AbgFASQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D302068D;
        Mon,  1 Jun 2020 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035386;
        bh=bKvLcGlPaU0uNAT8Pe7nY3yv7COxHuhA9Juf7mgh1Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLke+rRmNXd/l4Afgamc9k4bg7kRB0WDIdAW8TEwLH8uMfBhVhlvvna0uYiiiufl/
         LnHzeH62eK0huRSCgHNWAqAZ2C0080NRcDea5mcYDIldpBvtymjcYl06efTDVY0zeZ
         qkogTO0FBKtdo0RjJflcflu3HlMkewnFCdIVcOCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 137/177] gpio: fix locking open drain IRQ lines
Date:   Mon,  1 Jun 2020 19:54:35 +0200
Message-Id: <20200601174059.839010895@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e9bdf7e655b9ee81ee912fae1d59df48ce7311b6 ]

We provided the right semantics on open drain lines being
by definition output but incidentally the irq set up function
would only allow IRQs on lines that were "not output".

Fix the semantics to allow output open drain lines to be used
for IRQs.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Russell King <linux@armlinux.org.uk>
Cc: stable@vger.kernel.org # v5.3+
Link: https://lore.kernel.org/r/20200527140758.162280-1-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 00fb91feba70..2f350e3df965 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4025,7 +4025,9 @@ int gpiochip_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 		}
 	}
 
-	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
+	/* To be valid for IRQ the line needs to be input or open drain */
+	if (test_bit(FLAG_IS_OUT, &desc->flags) &&
+	    !test_bit(FLAG_OPEN_DRAIN, &desc->flags)) {
 		chip_err(chip,
 			 "%s: tried to flag a GPIO set as output for IRQ\n",
 			 __func__);
@@ -4088,7 +4090,12 @@ void gpiochip_enable_irq(struct gpio_chip *chip, unsigned int offset)
 
 	if (!IS_ERR(desc) &&
 	    !WARN_ON(!test_bit(FLAG_USED_AS_IRQ, &desc->flags))) {
-		WARN_ON(test_bit(FLAG_IS_OUT, &desc->flags));
+		/*
+		 * We must not be output when using IRQ UNLESS we are
+		 * open drain.
+		 */
+		WARN_ON(test_bit(FLAG_IS_OUT, &desc->flags) &&
+			!test_bit(FLAG_OPEN_DRAIN, &desc->flags));
 		set_bit(FLAG_IRQ_IS_ENABLED, &desc->flags);
 	}
 }
-- 
2.25.1



