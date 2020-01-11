Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC6D137D27
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgAKJyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgAKJyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:54:21 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88AC92084D;
        Sat, 11 Jan 2020 09:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736460;
        bh=fc5zvJQGEuUlPLtjvla1Ds1e6EI3/cgRQcGu95QaYXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pfot5qxLrWwnD8l8Pkx3zSoaZzukWnMEb5bZdV+eyCnXQoWPmOrZYPPJqKJ2H6/aN
         pJ1bx6trzKQ7YGANLTHEXYjV1aTccsu0lFOzTGv3O06UHlrH9CJq9i2YRI3vq0kdD6
         rtrtUInWJWYN7iDbXcbZep/0F7zkfY4m3GKHsIH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.4 20/59] gpiolib: fix up emulated open drain outputs
Date:   Sat, 11 Jan 2020 10:49:29 +0100
Message-Id: <20200111094842.898040037@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 256efaea1fdc4e38970489197409a26125ee0aaa upstream.

gpiolib has a corner case with open drain outputs that are emulated.
When such outputs are outputting a logic 1, emulation will set the
hardware to input mode, which will cause gpiod_get_direction() to
report that it is in input mode. This is different from the behaviour
with a true open-drain output.

Unify the semantics here.

Cc: <stable@vger.kernel.org>
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -163,6 +163,14 @@ int gpiod_get_direction(struct gpio_desc
 	chip = gpiod_to_chip(desc);
 	offset = gpio_chip_hwgpio(desc);
 
+	/*
+	 * Open drain emulation using input mode may incorrectly report
+	 * input here, fix that up.
+	 */
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags) &&
+	    test_bit(FLAG_IS_OUT, &desc->flags))
+		return 0;
+
 	if (!chip->get_direction)
 		return status;
 


