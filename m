Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF1D65B5
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbfJNO6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 10:58:16 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52969 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732566AbfJNO6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 10:58:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 83AFD907;
        Mon, 14 Oct 2019 10:58:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 10:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Yth8VP
        Q2oIncHLbiGRVQT5cQ0hm+4oteYWz3TkYmTP4=; b=SlayYIjw2VdCD1kP7qh1Ru
        AlXB40D6TnOorJNfFTbXtjjwQ2BUeTzJXHJEOc3WHIyR8AG1zSwzg/Z/xxauXTCS
        SqS9MMeIhGC5Q6J49gZQ54bvNu0dWKv/iDIXyzEald2To2LhextMFuCk/OSw3Tqk
        drBZQ61erZf1P/LKtkmBab3Vw/I0C7D8msPozP8nXJmIQ0EiNZaQmQ3BP7L+4wgT
        mt9M8J6Si9LUdAx6+clyTDs6en7fAsFlaTnwKjA9p+apIEd1qSW/K6JFqh1/J6yh
        dSboSOirBEKUEvQ+pEj5t/Ra9dtYwYpw0yMXNmmHgnNuboJ3rTeGTUMGg/iB/bMg
        ==
X-ME-Sender: <xms:Bo2kXccP-c8ZybKn_Fdj-6Bygjp9BB71Be0hwXUpB_HRU1JoHSQIzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:Bo2kXWp5dQ00IfTAyZpXMWhpjJke-Nhaihf4oUpL8iyHQdUBJWvcxA>
    <xmx:Bo2kXTIYZ63-JrwMXW6mkkQRVK8OGKM-rReymQjbz0fffacd-LSanA>
    <xmx:Bo2kXWBgKiLfB0cBPEnWq2MMocB3qN_EC23YBOyPnaxLVZ_ImSWHzg>
    <xmx:B42kXSJSiitEnxMJLL47v1_59SX5x42NsrIEpsBT2y335TGC7qrlUw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85C6580063;
        Mon, 14 Oct 2019 10:58:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpio: fix getting nonexclusive gpiods from DT" failed to apply to 5.3-stable tree
To:     m.felsch@pengutronix.de, bgolaszewski@baylibre.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 16:58:13 +0200
Message-ID: <15710650933218@kroah.com>
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

From be7ae45cfea97e787234e00e1a9eb341acacd84e Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Tue, 1 Oct 2019 11:49:21 +0200
Subject: [PATCH] gpio: fix getting nonexclusive gpiods from DT

Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
Currently the gpiolib uses the wrong flags variable for the check. We
need to check the gpiod_flags instead of the of_gpio_flags else we
return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
gpiod's.

Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
Cc: stable@vger.kernel.org
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
[Bartosz: the function was moved to gpiolib-of.c so updated the patch]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 1eea2c6c2e1d..80ea49f570f4 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -317,7 +317,7 @@ struct gpio_desc *gpiod_get_from_of_node(struct device_node *node,
 	transitory = flags & OF_GPIO_TRANSITORY;
 
 	ret = gpiod_request(desc, label);
-	if (ret == -EBUSY && (flags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
+	if (ret == -EBUSY && (dflags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
 		return desc;
 	if (ret)
 		return ERR_PTR(ret);

