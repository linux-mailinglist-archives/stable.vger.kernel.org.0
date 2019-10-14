Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1065AD65B1
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbfJNO6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:58:02 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50153 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732759AbfJNO6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:58:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E4B5B90C;
        Mon, 14 Oct 2019 10:58:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:58:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ukagvW
        AV1oWZwGrt5bf8/3zlXVCmtzhI8RBR051t91o=; b=OSnLksiDJGxe7e+G9LPKU1
        ynQwJ9lEKIRo8brr8m+uTtRCPmVfMMFVebvYb9U0w/MhZtWQyA/NIwkNvzoU08E0
        crsj+qoPm3hLMOY9c4bEfxnzjbhZYwBpgaC0cx5aJQymkJpAYmVSiYOD2t1hW42X
        7u8k/TqpOiLJYOeK1YcT5lY7lwtqansH/BhSlhI+pYm9FcC05OJF/dj/nMDiyHNb
        t0gEz6yEiJS5xT62Eo0PuMG8qgaXiV6qXa50VGs+zR/F9JIk5Hi029C+/lOCURv7
        6oHGDv0+aGm8VZy7hua57rR2xTuZGqiJKr1498xx7LJ87AuuF62/tmHPvztuyo6g
        ==
X-ME-Sender: <xms:-IykXW26po1kZc8GQGpZdkHwPs19WHZfzNCECAcbC1uFPeaNmrfKgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:-IykXU8h3HSW14gqA_1LfGbMIZdmtWvLWyLiDs8SXv_V4omTRh1ULg>
    <xmx:-IykXb5DRo5RcR7Gm1UNZcSKgBZyWnvjsknHC9p0Dm5oIaabMo__og>
    <xmx:-IykXcv2IKksC0n21_A3Bzv4gLLXDclQyHro13yzuVCKx8N8O2ionQ>
    <xmx:-IykXeU8UpCL_leLyFEq7MhzAIstzoEV2pD93JABrjjUrprqMjBqFQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1196C80064;
        Mon, 14 Oct 2019 10:57:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpiolib: don't clear FLAG_IS_OUT when emulating" failed to apply to 4.19-stable tree
To:     bgolaszewski@baylibre.com, warthog618@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:57:49 +0200
Message-ID: <15710650694043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

