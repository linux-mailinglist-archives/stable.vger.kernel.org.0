Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B288F1B41D5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgDVKGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgDVKGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642922076C;
        Wed, 22 Apr 2020 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549998;
        bh=ply7STCKTzRLwCtHHPvJalCJ1SwVkJNKXSg6UOLgnCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvM1Q7p28g/eibymqrt35s/M2MQ9v4ngn0H/aUKsTc1kL5LE+S/4efSvT6vAkYKzz
         GmAreD3FtFgqV/qgBymYxa3RCXr3tJpkBt82G4G89a7FcpRKhRXCjLDTaoO6hVcwT6
         0BBihtWdLw1xki4sUnMGgpeCuwdAOOQ5TMWV0vOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Timur Tabi <timur@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 091/125] Revert "gpio: set up initial state from .get_direction()"
Date:   Wed, 22 Apr 2020 11:56:48 +0200
Message-Id: <20200422095047.685351272@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timur Tabi <timur@codeaurora.org>

[ Upstream commit 1ca2a92b2a99323f666f1b669b7484df4bda05e4 ]

This reverts commit 72d3200061776264941be1b5a9bb8e926b3b30a5.

We cannot blindly query the direction of all GPIOs when the pins are
first registered.  The get_direction callback normally triggers a
read/write to hardware, but we shouldn't be touching the hardware for
an individual GPIO until after it's been properly claimed.

Signed-off-by: Timur Tabi <timur@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1232,31 +1232,14 @@ int gpiochip_add_data(struct gpio_chip *
 		struct gpio_desc *desc = &gdev->descs[i];
 
 		desc->gdev = gdev;
-		/*
-		 * REVISIT: most hardware initializes GPIOs as inputs
-		 * (often with pullups enabled) so power usage is
-		 * minimized. Linux code should set the gpio direction
-		 * first thing; but until it does, and in case
-		 * chip->get_direction is not set, we may expose the
-		 * wrong direction in sysfs.
-		 */
-
-		if (chip->get_direction) {
-			/*
-			 * If we have .get_direction, set up the initial
-			 * direction flag from the hardware.
-			 */
-			int dir = chip->get_direction(chip, i);
 
-			if (!dir)
-				set_bit(FLAG_IS_OUT, &desc->flags);
-		} else if (!chip->direction_input) {
-			/*
-			 * If the chip lacks the .direction_input callback
-			 * we logically assume all lines are outputs.
-			 */
-			set_bit(FLAG_IS_OUT, &desc->flags);
-		}
+		/* REVISIT: most hardware initializes GPIOs as inputs (often
+		 * with pullups enabled) so power usage is minimized. Linux
+		 * code should set the gpio direction first thing; but until
+		 * it does, and in case chip->get_direction is not set, we may
+		 * expose the wrong direction in sysfs.
+		 */
+		desc->flags = !chip->direction_input ? (1 << FLAG_IS_OUT) : 0;
 	}
 
 #ifdef CONFIG_PINCTRL


