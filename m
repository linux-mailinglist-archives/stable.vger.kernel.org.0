Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D41EAD53
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgFASoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730997AbgFASKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3082068D;
        Mon,  1 Jun 2020 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035030;
        bh=6s+RsgL4xCdQ+h6Wu8W/hQMwwgmM8A5E+6SPxAFengk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEXE8C1bPisQ9rMMDlOHTrNzK3AFPP7RUxpUeLkNcFW8bnJSpgwwQ0LxxX0Zg132N
         A7G7wsEuICvfv3hJLhELhqV7zQ3aJjPUq0bdHfzmWmI/+9TglNkSk9bx+OsWt3xS4C
         GLQ8caP1/YzobcYdTLJ2YAeKLx/1dKQfJF+QrzBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/142] gpio: fix locking open drain IRQ lines
Date:   Mon,  1 Jun 2020 19:54:22 +0200
Message-Id: <20200601174048.752157963@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
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
index a8cf55eb54d8..abdf448b11a3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3894,7 +3894,9 @@ int gpiochip_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 		}
 	}
 
-	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
+	/* To be valid for IRQ the line needs to be input or open drain */
+	if (test_bit(FLAG_IS_OUT, &desc->flags) &&
+	    !test_bit(FLAG_OPEN_DRAIN, &desc->flags)) {
 		chip_err(chip,
 			 "%s: tried to flag a GPIO set as output for IRQ\n",
 			 __func__);
@@ -3957,7 +3959,12 @@ void gpiochip_enable_irq(struct gpio_chip *chip, unsigned int offset)
 
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



