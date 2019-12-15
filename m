Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CDE11F7F7
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLON0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:26:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56067 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbfLON0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:26:19 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C10C32223B;
        Sun, 15 Dec 2019 08:26:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=73n8nN
        CHxFw4EOI5zqxnTobvJs37KVMKB/X0Xw5hIN0=; b=oA9Rt0wINoaFfp0BuGa3xt
        tryxRC0WFWsKpB0LMrH82avpa82d9HJwMgxxTDVs9l64VORJ/06Xn0SXwqU0csMU
        RLsB1Lezno11+bgoh77LGIKtS5NFhQWXSZNxZrBjhdJ+q95R9wezYmNy3H3qrHrd
        LXHW2+H8PVnsZGmiAee4pEXTC4y7qqFvtxA7uyUekILEDOT03PGgXB30WZvPkD8P
        aFl2xHEz24kK8HLDg4vuQgbns0oxOmbtcGnWQwfKLUJP4vnAYl/2qG80RhVZZo4H
        mDRR5LOyuIHKI5nKF9fhCEQvHvGsKuSXl2QHsw6F9YdAMIxDrEBBiUYTGohEzSNg
        ==
X-ME-Sender: <xms:ejT2XdwjEx0qWPtrhOPFGLkHLRi_zQf9B20-RjmLENElFRoyxTHaXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:ejT2XX_F04zsp7BGjD-WesS2b-wAjQPTgT8q89t6y_1UXyUvA7ZKFw>
    <xmx:ejT2Xd_jbnkAFedeUy4iveURys1cVJWBV98nstIRH_Tl2Q1C3YpozA>
    <xmx:ejT2Xaf7rWXfyHca3mXwX2RM_bpVHp3UoTedR--BE4XJyso8pUdXag>
    <xmx:ejT2XbObLL22a4eZmbM3cxk0A8Ztr2gsZLZwsY4TtfPYPwdhii0zHQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4853E8005C;
        Sun, 15 Dec 2019 08:26:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Add of_node_put() before return in error" failed to apply to 4.9-stable tree
To:     nishkadg.linux@gmail.com, krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:26:09 +0100
Message-ID: <157641636919588@kroah.com>
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

From 3d2557ab75d4c568c79eefa2e550e0d80348a6bd Mon Sep 17 00:00:00 2001
From: Nishka Dasgupta <nishkadg.linux@gmail.com>
Date: Sun, 4 Aug 2019 21:32:00 +0530
Subject: [PATCH] pinctrl: samsung: Add of_node_put() before return in error
 path

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a return from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put before the return of
exynos_eint_wkup_init() error path.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Fixes: 14c255d35b25 ("pinctrl: exynos: Add irq_chip instance for Exynos7 wakeup interrupts")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index ebc27b06718c..e7f4cbad2c92 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -486,8 +486,10 @@ int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 		if (match) {
 			irq_chip = kmemdup(match->data,
 				sizeof(*irq_chip), GFP_KERNEL);
-			if (!irq_chip)
+			if (!irq_chip) {
+				of_node_put(np);
 				return -ENOMEM;
+			}
 			wkup_np = np;
 			break;
 		}

