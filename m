Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4FB21817
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEQMXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:23:00 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46329 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728193AbfEQMXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:23:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D17C446A;
        Fri, 17 May 2019 08:22:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z+wB8B
        o2eWDfx31fxNFlyYOC8Lx7NuTIzNpQvy3rcHw=; b=qOVYWccRIm0iQXuB68p9ml
        qoS8BqmnFLYKHddZDZRkzPUlK30XQaj5+d95qCIrhIslRjcUoEYecFb7S2O0n9cN
        /ieejgl7voI0JEle/o2dmZtvSCgEjwbisB1IjOS2Jq9U7f+ZtIPJx9Ifx4BCRSDY
        /Toyv7sEnVvuAs2WO4HV2Qp+tM5Vyrcf+rC2kLb2bVNieJTGll7qwcEXQ8onLMXi
        1HPP6+8mkIqGjdpNrYGrTzxWK9mBRhT/BGolV0hXE1/PwZXjgPTUqM2a4FFcZqYW
        RdN2YKh9OrREConYSX4G3iV3MVNB69lyFok2IljQL/Y1PPS9lOwNkOdgdBSwaMSQ
        ==
X-ME-Sender: <xms:oafeXHvxQD8j1IPSp7oY4AZhC9sY3cg2piyZ7K6r08NL5t0bDLiqug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:oafeXMn19EjiinQ8WLa--ox1BMnEBrnGfyjtyNIX-QNNaKZbYyPCGw>
    <xmx:oafeXHz7r1EenxRWKfyRfv0IdrNGCKBIF3jz8s5mQS8rXOJ1MLjexA>
    <xmx:oafeXAwYEQUrUyKMFVuGzulNMTX6qf2BvKXYID_JsHUGHhfVPFPOvQ>
    <xmx:oqfeXHf9oV4uofo7G9mAUxg7EvpZHG7XpAEAKiH7NcGoHF1r5Pqyww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7ABF58005B;
        Fri, 17 May 2019 08:22:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] power: supply: axp288_charger: Fix unchecked return value" failed to apply to 4.4-stable tree
To:     gustavo@embeddedor.com, hdegoede@redhat.com,
        sebastian.reichel@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:22:55 +0200
Message-ID: <1558095775165218@kroah.com>
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

From c3422ad5f84a66739ec6a37251ca27638c85b6be Mon Sep 17 00:00:00 2001
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 18 Mar 2019 11:14:39 -0500
Subject: [PATCH] power: supply: axp288_charger: Fix unchecked return value

Currently there is no check on platform_get_irq() return value
in case it fails, hence never actually reporting any errors and
causing unexpected behavior when using such value as argument
for function regmap_irq_get_virq().

Fix this by adding a proper check, a message reporting any errors
and returning *pirq*

Addresses-Coverity-ID: 1443940 ("Improper use of negative value")
Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index f8c6da9277b3..00b961890a38 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -833,6 +833,10 @@ static int axp288_charger_probe(struct platform_device *pdev)
 	/* Register charger interrupts */
 	for (i = 0; i < CHRG_INTR_END; i++) {
 		pirq = platform_get_irq(info->pdev, i);
+		if (pirq < 0) {
+			dev_err(&pdev->dev, "Failed to get IRQ: %d\n", pirq);
+			return pirq;
+		}
 		info->irq[i] = regmap_irq_get_virq(info->regmap_irqc, pirq);
 		if (info->irq[i] < 0) {
 			dev_warn(&info->pdev->dev,

