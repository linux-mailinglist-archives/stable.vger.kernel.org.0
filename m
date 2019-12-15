Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE0911F7F9
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfLON0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:26:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39915 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbfLON0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:26:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B4BB221E9;
        Sun, 15 Dec 2019 08:26:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:26:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hm3Jah
        asczg5aWyvUpRjpQ1NkMtnvw32rc8rBT9h/sc=; b=v7xRmpcUsDMzoPtL8SvtQ2
        zETpKFDNZ0uUl9OhrncYSkiNEUuWDt57mKblhuwdFwsTI4Q4erYDzGHJrNPl+oje
        7wbAQ/MIpkCAUQ8p2QQYQLYmxE0gr1odIrojvBg02ZeHogmp9PURu8bSAcTRbW43
        7QMH0UEQBtxOPbkJXuF+uqrqV7qHDGsapAtwe1h3tE98emjMFpZPbqaqBtOT7ot2
        rGtbmiy+fCJr20L/OESo9VpCThOzlLiHbIJCkGaI0egIfULRUe/D9LRyGgbdwCAg
        aix0nlGdhNXKcGjX2Bz9WQYDsyoJcEciI04w5L85DAp0tV0K9MphooD9KmJTh1iw
        ==
X-ME-Sender: <xms:lTT2XbBayKSIZRWaS28Lej_bPTnB1oj0XVPUJY8FKvfkSGSOB5sofA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:lTT2XSTGe6arVMcksA1BPQmFugA9Xjs2zLlnfPg6C5ySStwyHKTq5Q>
    <xmx:lTT2XffkrCU1AnzhcijzJjLhgRiMPX5MLW076tfzqLVs-AJe1z82OA>
    <xmx:lTT2XVr9petSztjlyD8Ue-Qa2FOplmasyt4NCJelFNH4M_wsO8MV6w>
    <xmx:lTT2XTgwo1PMHzgIn7fpy-B7k-gqk8Ht54Ac_IwdSz18fk7FfpFP5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03F768005A;
        Sun, 15 Dec 2019 08:26:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Fix device node refcount leaks in Exynos" failed to apply to 4.9-stable tree
To:     krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:26:35 +0100
Message-ID: <157641639518039@kroah.com>
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

From 5c7f48dd14e892e3e920dd6bbbd52df79e1b3b41 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 5 Aug 2019 18:27:07 +0200
Subject: [PATCH] pinctrl: samsung: Fix device node refcount leaks in Exynos
 wakeup controller init

In exynos_eint_wkup_init() the for_each_child_of_node() loop is used
with a break to find a matching child node.  Although each iteration of
for_each_child_of_node puts the previous node, but early exit from loop
misses it.  This leads to leak of device node.

Cc: <stable@vger.kernel.org>
Fixes: 43b169db1841 ("pinctrl: add exynos4210 specific extensions for samsung pinctrl driver")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index e7f4cbad2c92..0599f5127b01 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -506,6 +506,7 @@ int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 				bank->nr_pins, &exynos_eint_irqd_ops, bank);
 		if (!bank->irq_domain) {
 			dev_err(dev, "wkup irq domain add failed\n");
+			of_node_put(wkup_np);
 			return -ENXIO;
 		}
 
@@ -520,8 +521,10 @@ int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 		weint_data = devm_kcalloc(dev,
 					  bank->nr_pins, sizeof(*weint_data),
 					  GFP_KERNEL);
-		if (!weint_data)
+		if (!weint_data) {
+			of_node_put(wkup_np);
 			return -ENOMEM;
+		}
 
 		for (idx = 0; idx < bank->nr_pins; ++idx) {
 			irq = irq_of_parse_and_map(bank->of_node, idx);
@@ -538,10 +541,13 @@ int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 		}
 	}
 
-	if (!muxed_banks)
+	if (!muxed_banks) {
+		of_node_put(wkup_np);
 		return 0;
+	}
 
 	irq = irq_of_parse_and_map(wkup_np, 0);
+	of_node_put(wkup_np);
 	if (!irq) {
 		dev_err(dev, "irq number for muxed EINTs not found\n");
 		return 0;

