Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED23B8113B
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEFBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:01:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45217 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfHEFBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:01:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 14ACD21903;
        Mon,  5 Aug 2019 01:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5VtnAy
        PbCxPXpEljn7F3jMojpx178nLICmfx0Gl7wAc=; b=unW0B4iLYX4liIGoKjJ3Y3
        MQMZ8suQfF73HHVPGvoHNVk5q2U95yO6L9Hn4FoBbUVa7vAo4A3ovCIREjBUhzTK
        9me16UwMa/t3QXOtpMlfzJclV4DyCBSkdR4vRvtJiZ2p1bOHQyNNQfNSNAEmV+2t
        yp5ZhTNypmA1+mr9KhLalNOyaUxHgSmolHi4dg7TfN7aUQxjvFGqYly+OdS+6hkq
        dClUYMnVXrmWf3md9//P1Am+JO0O3gP3Yx/N6AUk90yh240Uo9AsW4TyDzs3HN3m
        wDcm3EMzghE6w7eEfBJjAuyT7m0T7YWkRar2p0606dufzo1T6rJYSyskRUWRKTeg
        ==
X-ME-Sender: <xms:P7hHXZtutQVwRDAS2B1Lj24JJB77EJqAsE8gaBc0jVvgSgaI0p1b5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:P7hHXXtjgt_3PfEmF-q74PIJGeZb3KWOQl8y8qhWjatKCVp0kzzp1w>
    <xmx:P7hHXed83IcGWawUYj0gdHaRxIKWouDLpe7_jDTxZfRlPkaJqcZdJA>
    <xmx:P7hHXYauVZwjSTdQbAhstsqVATXk5Yte3OLW3V-no2dt3MJlNq3j9w>
    <xmx:QLhHXdox3O4hrPiINTzhNvGKk-8UQT_JqX-F4WbHdkg3lnKwEnrs1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A6DE380086;
        Mon,  5 Aug 2019 01:01:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpiolib: Preserve desc->flags when setting state" failed to apply to 4.14-stable tree
To:     chris.packham@alliedtelesis.co.nz, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:01:49 +0200
Message-ID: <1564981309157220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d95da993383c78f7efd25957ba3af23af4b1c613 Mon Sep 17 00:00:00 2001
From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Mon, 8 Jul 2019 08:35:58 +1200
Subject: [PATCH] gpiolib: Preserve desc->flags when setting state

desc->flags may already have values set by of_gpiochip_add() so make
sure that this isn't undone when setting the initial direction.

Cc: stable@vger.kernel.org
Fixes: 3edfb7bd76bd1cba ("gpiolib: Show correct direction from the beginning")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20190707203558.10993-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index bf05c29b53be..f497003f119c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1394,12 +1394,17 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
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

