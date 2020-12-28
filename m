Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743AF2E3787
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgL1M4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgL1M4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62EE322583;
        Mon, 28 Dec 2020 12:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160173;
        bh=GF3KQyN3rtuUpoa7lKZkvuJXX0pYjjNIGaempjK5EbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqH8UICke3rXJkgBIkXhttKEGcil0TxFnZfV5wUWaxuFaXuAlg26IhNU1JwRjSKdo
         7jy9dKrpYqboFCnOuiXedfOopsESZ5wsiC9atif1zDvjhmXR1JAOxOmi1d84R9Z39W
         bonBx6Vg2s+PD1yvSGE57A/5C8+Uyg04GZBnANrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 064/132] pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()
Date:   Mon, 28 Dec 2020 13:49:08 +0100
Message-Id: <20201228124849.550392242@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 89cce2b3f247a434ee174ab6803698041df98014 ]

if of_find_device_by_node() succeed, pinctrl_falcon_probe() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: e316cb2b16bb ("OF: pinctrl: MIPS: lantiq: adds support for FALCON SoC")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20201119011219.2248232-1-yukuai3@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-falcon.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 0b0fc2eb48e0b..adcdb0585d398 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -438,24 +438,28 @@ static int pinctrl_falcon_probe(struct platform_device *pdev)
 
 	/* load and remap the pad resources of the different banks */
 	for_each_compatible_node(np, NULL, "lantiq,pad-falcon") {
-		struct platform_device *ppdev = of_find_device_by_node(np);
 		const __be32 *bank = of_get_property(np, "lantiq,bank", NULL);
 		struct resource res;
+		struct platform_device *ppdev;
 		u32 avail;
 		int pins;
 
 		if (!of_device_is_available(np))
 			continue;
 
-		if (!ppdev) {
-			dev_err(&pdev->dev, "failed to find pad pdev\n");
-			continue;
-		}
 		if (!bank || *bank >= PORTS)
 			continue;
 		if (of_address_to_resource(np, 0, &res))
 			continue;
+
+		ppdev = of_find_device_by_node(np);
+		if (!ppdev) {
+			dev_err(&pdev->dev, "failed to find pad pdev\n");
+			continue;
+		}
+
 		falcon_info.clk[*bank] = clk_get(&ppdev->dev, NULL);
+		put_device(&ppdev->dev);
 		if (IS_ERR(falcon_info.clk[*bank])) {
 			dev_err(&ppdev->dev, "failed to get clock\n");
 			return PTR_ERR(falcon_info.clk[*bank]);
-- 
2.27.0



