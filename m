Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E898113C
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfHEFCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:02:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41663 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfHEFCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:02:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 384E32026A;
        Mon,  5 Aug 2019 01:02:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=45IVzh
        05alr1MDvMAiH3iAzPLFBwFVL3B3JGXwffKNY=; b=xdBNeiGytboeiK3aAdeHzn
        zA8l324jGJJOe5K1ZOxSpeWSnDrg3w3BcwYPoRsFkUkZ2a3zaGX+SoVJADSADjyx
        Pz6UsDnWsQ5n2KBYD+v0WDKA/hWMqZQzz9xHobGGd0nZe+P6kD9s7CFYHu0rotf9
        ZL9E4Nq3MOqUtjA3GCrFhen5wAMDqf87oIgKq1yrsdEePYFw9EcllYZ0K0Yh76ff
        f9s4gVsJjNFOY6TKZ04JEpcBrmR+k6m7zSRIRwER3hNm8JxqkinrW+isGE0p6CQp
        FMqIo2hHHZpoxGqJQaK+/Iv0Y67DGoRKsVz2j8xyn+h9oUheM32y+hH1AZk1+c2Q
        ==
X-ME-Sender: <xms:SLhHXWiUOwAHCBMP1_fz7jg8yu7H_9azY0AnrUPpy__3fGV2ZWyeFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:SLhHXSa_0r5I2gukcL4vqVIHYhgyBw9vBPLrn8BWp5Kl5ROxwECpyA>
    <xmx:SLhHXXeNMO-WGxLDNxFzd8NgDl0qH6uF2YCCqOyn-IV6CZ_dphYAHQ>
    <xmx:SLhHXXBt5IUZL3_01lJPXzaGry-zib91_OW9If7uOFirr-Zt5rUfIw>
    <xmx:SLhHXXaHgSvVqFNF-gLEzufLze-gMC_IPqBXXnN1nVG88f2zmJTBhQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABF84380085;
        Mon,  5 Aug 2019 01:01:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpiolib: Preserve desc->flags when setting state" failed to apply to 4.19-stable tree
To:     chris.packham@alliedtelesis.co.nz, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:01:50 +0200
Message-ID: <15649813101539@kroah.com>
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

