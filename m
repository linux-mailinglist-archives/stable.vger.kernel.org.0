Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7145311F7F6
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfLON0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:26:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41313 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbfLON0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:26:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A02392222B;
        Sun, 15 Dec 2019 08:26:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VAT+80
        20Zc7HM6p7QuVyyHPCm0ImPQLeKvsj/AZHLsI=; b=Ltl6uZsnpB2bBhYOvc/n1k
        ec2rZNUr93FIMKBryQrUyOg8JpuVBAqNEQNtY3e2FDXIuPiJWNb1mYg4RMmBg0z2
        y1kl3CmaWgo6MKCto9QL4dJefqOa9XrhyzQADrs3KXSjZRjNkgEORT3wzqo/WYgp
        1HYoCwnpUXf24Okl5k8tWq05C8AyIcbxxuxAkiQucQq1Mzann6lxAPlFaJ/q3PMd
        zW6Webvy15bUdfWzyP7paLLQKIyOaJyDBUdwWbB8tavTzK2XG1FTgxPWC1DCifn+
        Yej00EKKJLrJveek75CGNPECNCLXTAHhX95DelBrAMw0ukOlkTgVuJGWYJn58mVA
        ==
X-ME-Sender: <xms:cjT2XST2vr3WPPtrZQ1CoaIsI_ttWuWx3SmMWS7ERE2EMKgeKpsOng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:cjT2XR2F8M7o-ELrRjxZ_Zb1sngjzkc6t1edSUo6oqKUHLkS3Ylmpw>
    <xmx:cjT2XfsWl4Tgdp7u_3w6290MFc0FbHkuQafmO8rQYpqRDSDe2f0JJA>
    <xmx:cjT2XfhFx5oBaxcNJ2gPC7Kl6hYPClUa7Qa58ERjLRUKiQXGm7WGsQ>
    <xmx:cjT2Xc_QjCiUedyRyEOAfkAzZT9LfWbXtgD7Zy6jiyl-EFb96Q0yqA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 392B330600FE;
        Sun, 15 Dec 2019 08:26:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: samsung: Add of_node_put() before return in error" failed to apply to 4.4-stable tree
To:     nishkadg.linux@gmail.com, krzk@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:26:08 +0100
Message-ID: <1576416368215161@kroah.com>
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

