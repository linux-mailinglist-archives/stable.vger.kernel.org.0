Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EC52E6713
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgL1NNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732319AbgL1NNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F20C22583;
        Mon, 28 Dec 2020 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161192;
        bh=Go5O+Ekl76VF6e9p5cmqsmgodlmRJ+kZfPXhZGg325Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8SsbLV0oYQg1Q0MQsoHtKyp6QF6LXppkzZ4Dhfgd3Gl6/8DHDdEVwsvICXxC62nZ
         2bykk4IwHFiVZ2TdmvQNjhx5N255frwlQGAMkznbIpcTCZNxedVr7vCpAxjgpMe0Fv
         +7Z/bBO9d10gRv/2JnbJETkYHxJnf4vXyf3IxjKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/242] pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()
Date:   Mon, 28 Dec 2020 13:48:57 +0100
Message-Id: <20201228124911.201300032@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index fb73dcbb5ef37..68dcf53aaac34 100644
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



