Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EB5D65AF
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbfJNO5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:57:53 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48327 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732606AbfJNO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:57:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D2BAF90D;
        Mon, 14 Oct 2019 10:57:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8iy93k
        +y0G9l0SqsoYY6orz6sJubmb16uGwzVI8v2IE=; b=o0io8Cn10f+eV4Dv2Qe9RG
        6Fr04y1vMiGHzRjTjmXG+DLpdgVPAKwMRJYa3aABPtr+H5mdOKrE84/5QeutMjQh
        hL3iXSVu/Q2lU2nh06uZaosftFhiJZ5whXkGz0Fc1ig9Y8GtBNYA4iTCXbuh4LtW
        tUIN+CAWtFcHzFzX0SJdVJT4VUtxzp4oM4jZklpTRUqfZfPdOoaD5bvDF+QRRcm6
        NlSkm2KLwAjBLUiQuuzD3XlcUns6GDBtEJpGc5qewcqnWBCH9Mn75BcT5rLOu9Dc
        UqscGgatkDJL+itaZdcrTBOu+Cq+dzA7g2P6kOEgRfIKSawQmkUIiMSHLDmwKZuA
        ==
X-ME-Sender: <xms:74ykXTcSna1sj5vlVBQMJJ9PUy5kpl8V4JHEssBYwQ1X49XUSfx5Kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:74ykXXExx__Xl5bAHlRbDRU2VSDhBH8rZhMv4yA7p_qcGsaRRRPANg>
    <xmx:74ykXVkHPRyreRnBQS3tLPTckNxR0wh0ymobpdmd370LiRe1FPFcWQ>
    <xmx:74ykXWN0tGk7_56tXvmnsMaWOry5NRBQ7Mou23bxCvYWGgk4X-8E7g>
    <xmx:74ykXVpWc8NXayTwwY1VJJnsv2P2w-eao5lMu5u3BlHmqsvbcs-lFg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C76CA80063;
        Mon, 14 Oct 2019 10:57:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpiolib: don't clear FLAG_IS_OUT when emulating" failed to apply to 5.3-stable tree
To:     bgolaszewski@baylibre.com, warthog618@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:57:49 +0200
Message-ID: <1571065069127205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e735244e2cf068f98b6384681a38993e0517a838 Mon Sep 17 00:00:00 2001
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Tue, 1 Oct 2019 11:44:53 +0200
Subject: [PATCH] gpiolib: don't clear FLAG_IS_OUT when emulating
 open-drain/open-source

When emulating open-drain/open-source by not actively driving the output
lines - we're simply changing their mode to input. This is wrong as it
will then make it impossible to change the value of such line - it's now
considered to actually be in input mode. If we want to still use the
direction_input() callback for simplicity then we need to set FLAG_IS_OUT
manually in gpiod_direction_output() and not clear it in
gpio_set_open_drain_value_commit() and
gpio_set_open_source_value_commit().

Fixes: c663e5f56737 ("gpio: support native single-ended hardware drivers")
Cc: stable@vger.kernel.org
Reported-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index bdbc1649eafa..5833e4f380d6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3070,8 +3070,10 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open drain by not actively driving the line high */
-		if (value)
-			return gpiod_direction_input(desc);
+		if (value) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	}
 	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags)) {
 		ret = gpio_set_config(gc, gpio_chip_hwgpio(desc),
@@ -3079,8 +3081,10 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 		if (!ret)
 			goto set_output_value;
 		/* Emulate open source by not actively driving the line low */
-		if (!value)
-			return gpiod_direction_input(desc);
+		if (!value) {
+			ret = gpiod_direction_input(desc);
+			goto set_output_flag;
+		}
 	} else {
 		gpio_set_config(gc, gpio_chip_hwgpio(desc),
 				PIN_CONFIG_DRIVE_PUSH_PULL);
@@ -3088,6 +3092,17 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 
 set_output_value:
 	return gpiod_direction_output_raw_commit(desc, value);
+
+set_output_flag:
+	/*
+	 * When emulating open-source or open-drain functionalities by not
+	 * actively driving the line (setting mode to input) we still need to
+	 * set the IS_OUT flag or otherwise we won't be able to set the line
+	 * value anymore.
+	 */
+	if (ret == 0)
+		set_bit(FLAG_IS_OUT, &desc->flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(gpiod_direction_output);
 
@@ -3448,8 +3463,6 @@ static void gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
 
 	if (value) {
 		ret = chip->direction_input(chip, offset);
-		if (!ret)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		ret = chip->direction_output(chip, offset, 0);
 		if (!ret)
@@ -3479,8 +3492,6 @@ static void gpio_set_open_source_value_commit(struct gpio_desc *desc, bool value
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
 		ret = chip->direction_input(chip, offset);
-		if (!ret)
-			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
 	trace_gpio_direction(desc_to_gpio(desc), !value, ret);
 	if (ret < 0)

