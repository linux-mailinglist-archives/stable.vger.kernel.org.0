Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B47411F7FA
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfLON0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:26:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47555 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbfLON0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:26:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 33E29221E9;
        Sun, 15 Dec 2019 08:26:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=necsaN
        ikNCMeKw/2a85DKMQvUH4qT6UFrbvvL5RQYHc=; b=I9jAl1zX6NhAea8pmSx+hR
        SVrhcTvEJkA5nmcswk/W688+CVkDJ9L7+dlgicUGb9C17FSexGGt9pAkkftKBJFv
        jcSJ63vhs8p6bjDahvOOtV1eXfOncmPbGmzmBCtFYauxhLUgvS648qBmhi3E+Xkx
        s01eRzOtMWaHO812IjpFF9yJ336KaODy+JjJSMscbHRjPK0pz58AGiMymY9Y93/3
        MZByu2/tl5xUpe66tmx14CMLmoq5AJ+EM7mkvATuAwvj2sMM0O0MrKHEi6k8ETN7
        uzp5sXi7192Lg9r4nD3ed4dsUluiJPIW7MT2WRF6ic4hmE/Yd36TdpGGNIL3zu6A
        ==
X-ME-Sender: <xms:lzT2XSxqZTcPY6pwYd-2HMslFfmJfxl0AkNSAVQzhXsNUB_fNa3Zsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:lzT2Xflt81nsVrOsdV6O11AFdmSX7yN5O99oAJReg1_yy-lDhYrK7w>
    <xmx:lzT2XY-NLuwGR4ysORKbhqrmeiiBa396xDIY37kE6k2IDFBt97udZw>
    <xmx:lzT2XbNnkI89HME-DVdGEXjBWNrEp28Q5mLcNjmj7LbbcWBpbzdPRA>
    <xmx:lzT2XTD94kBVA9IfgYGJZepo7z9BnGqhPL8osiS7yV0ExZL5Mobvjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C117730600D4;
        Sun, 15 Dec 2019 08:26:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Fix device node refcount leaks in Exynos" failed to apply to 4.4-stable tree
To:     krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:26:36 +0100
Message-ID: <157641639659113@kroah.com>
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

