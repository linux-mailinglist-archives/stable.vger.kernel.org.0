Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8685911F800
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfLONbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:31:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52147 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:31:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A9B22235F;
        Sun, 15 Dec 2019 08:30:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0rvPPM
        I7RuANtRleoMgDHlx6PpioluOpJHm1aTOKYLA=; b=VaaY3hpzeOGkJ5SAetfVu+
        KVbe19XK5iJMObYhKW68WKUG4FLvwEsl5P8FysbUY+nKMGhGgxCxCb9Q5bsXupeu
        L/SHORRhT0hCQ6ZYZABSJWlGgAjb5S1gyltrmF10zYA3t2V+FE1AgUdBDx04HWll
        UyGxnoE4w6QPjpIF2DVixKq6dYezOVU6rf/9DNG5n4h6B6w/PxQZDzQKNsl5Fafh
        64GyhokffJ5+/hkEuaDbaa04+N2qGG/nSFUj7/ri9fp2bmL0v5NuVe9yiNpRu8iJ
        EC3QXhWQvq7R4Sf+pgX3VEnAOGKACG6avcqAmUAxMzhRnlpblZaBgzojmBrhLhNA
        ==
X-ME-Sender: <xms:kzX2XTQPuUYE4bAGNuVjgP38GKyKPPwN7RO_tAduHoifh-392M7GbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:kzX2XU9kjQDWsfkJSNpRXkuh0jYGGk6CGIT9dnMdn_aDrMo5F7RvXQ>
    <xmx:kzX2XXK-ldxXG3r-F0MpQ_5BHC8zt-WEiWae-pLOMNR1owG2DqmL-w>
    <xmx:kzX2XQzSzgHoQ8NUhhDUQ2YkDuvpKLYvrXwRSWiAg1g6_UE_aRWELQ>
    <xmx:kzX2Xb7fFIEE43BBHOXJm0Mj1QWZzcuaDFhrQp0n5q3CyIzubkm0gQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99CCD8005C;
        Sun, 15 Dec 2019 08:30:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Fix device node refcount leaks in S3C64xx" failed to apply to 4.4-stable tree
To:     krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:30:57 +0100
Message-ID: <15764166574589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

