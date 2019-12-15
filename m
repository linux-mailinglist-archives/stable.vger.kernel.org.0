Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AF11F801
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfLONbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:31:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47263 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:31:08 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 02DA221C7D;
        Sun, 15 Dec 2019 08:31:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=trcxfb
        14wCpDP0cdoZivNOfgpLccm2VKXCiDL6ZEtBc=; b=eeGJFkJnxx6b/aofWUMldR
        f7lABPVzRvTWysmuxti7Jzf1ziiFx+l4qWLaFuKLOez0L/lpL3c7HFEFV4TwAo3x
        eCU421yzbAReNwjT7AAzqIxbZzFIg/C4hKaLINAiUvzXuuq0hKsFjt9PozJJXiCw
        UMAGt/66nTeNFp3J625avRj7EfyzStt9KHOOvSvNSN7bxl8loWBZbw9p9C0GQ5fl
        ZigVuCbUZj8NYuLhqFl39tfxe7UHcMRC0EEImF4HnT0mWGO9Ck3P1Zc9VJcoGe17
        WB08h45gKJloPyrLrEHtf0V10QnKBMwWwG/ExE/U8ziHSf64URsUWxH7SAtVyatQ
        ==
X-ME-Sender: <xms:mjX2XRGmXRK4LFqcKLZI5HN2fzfIcn3ztSnpE4HTxjhQioh4fNMiGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:mjX2XeuDHNCYjeIezkXUdfFsg9VuMaNxU6nG_rgwAGX5hC0QeJe4hg>
    <xmx:mjX2XdaShEKh50Spy_B4t7TTdXKksGsX1-_GXxshNMAnPjmYt8McYg>
    <xmx:mjX2XbrShXdnXTjwMzZUMgZJl4w0ROh33KNLXUwmvYDQh2PakCkPnA>
    <xmx:mjX2XbFhe_7wj7lB_eA9dgShy5a8aArLcusj1UK-B7bSnDEoMwJEWw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E08E80060;
        Sun, 15 Dec 2019 08:31:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Fix device node refcount leaks in S3C64xx" failed to apply to 4.9-stable tree
To:     krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:30:57 +0100
Message-ID: <1576416657206164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7f028caadf6c37580d0f59c6c094ed09afc04062 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 5 Aug 2019 18:27:09 +0200
Subject: [PATCH] pinctrl: samsung: Fix device node refcount leaks in S3C64xx
 wakeup controller init

In s3c64xx_eint_eint0_init() the for_each_child_of_node() loop is used
with a break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: 61dd72613177 ("pinctrl: Add pinctrl-s3c64xx driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

diff --git a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
index c399f0932af5..f97f8179f2b1 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -704,8 +704,10 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 		return -ENODEV;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
+	if (!data) {
+		of_node_put(eint0_np);
 		return -ENOMEM;
+	}
 	data->drvdata = d;
 
 	for (i = 0; i < NUM_EINT0_IRQ; ++i) {
@@ -714,6 +716,7 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 		irq = irq_of_parse_and_map(eint0_np, i);
 		if (!irq) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
+			of_node_put(eint0_np);
 			return -ENXIO;
 		}
 
@@ -721,6 +724,7 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 						 s3c64xx_eint0_handlers[i],
 						 data);
 	}
+	of_node_put(eint0_np);
 
 	bank = d->pin_banks;
 	for (i = 0; i < d->nr_banks; ++i, ++bank) {

