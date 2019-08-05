Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0D81CEF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfHENX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbfHENXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51C0D2075B;
        Mon,  5 Aug 2019 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011434;
        bh=98Gw3ryYRwW6Hx9FWJo/zpazlqMbKHmNgldd9ahoWuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xerpHe6DSva+7cLKowXgcr4x9PX5N1VKJZwVGYSYet7ft2M9jtaDwuqic/mm10qCh
         BsrHpFO7gmE+l3a8OJLh1loyQu8bTUex+opdcIIAMyCxMNcFd0N2dhA8nfviFNP5uu
         rdTHvaM4378enUtan4h1ExCARRJZIIVEd8fuzmks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.2 087/131] gpiolib: Preserve desc->flags when setting state
Date:   Mon,  5 Aug 2019 15:02:54 +0200
Message-Id: <20190805124957.794130953@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit d95da993383c78f7efd25957ba3af23af4b1c613 upstream.

desc->flags may already have values set by of_gpiochip_add() so make
sure that this isn't undone when setting the initial direction.

Cc: stable@vger.kernel.org
Fixes: 3edfb7bd76bd1cba ("gpiolib: Show correct direction from the beginning")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20190707203558.10993-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1392,12 +1392,17 @@ int gpiochip_add_data_with_key(struct gp
 	for (i = 0; i < chip->ngpio; i++) {
 		struct gpio_desc *desc = &gdev->descs[i];
 
-		if (chip->get_direction && gpiochip_line_is_valid(chip, i))
-			desc->flags = !chip->get_direction(chip, i) ?
-					(1 << FLAG_IS_OUT) : 0;
-		else
-			desc->flags = !chip->direction_input ?
-					(1 << FLAG_IS_OUT) : 0;
+		if (chip->get_direction && gpiochip_line_is_valid(chip, i)) {
+			if (!chip->get_direction(chip, i))
+				set_bit(FLAG_IS_OUT, &desc->flags);
+			else
+				clear_bit(FLAG_IS_OUT, &desc->flags);
+		} else {
+			if (!chip->direction_input)
+				set_bit(FLAG_IS_OUT, &desc->flags);
+			else
+				clear_bit(FLAG_IS_OUT, &desc->flags);
+		}
 	}
 
 	acpi_gpiochip_add(chip);


