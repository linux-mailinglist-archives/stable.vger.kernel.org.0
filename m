Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7F2E64DB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbgL1Nhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389289AbgL1Nhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64DE7207B2;
        Mon, 28 Dec 2020 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162652;
        bh=uYJPl85wZNYWbbo2rWvP6IE0yRcKMeEN/aITiqENJpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NStpEkydBCim+KzQY4OYGtqIiKS7gNwmMeB8G0N6H3vjS1aYswv8twkxFpRFTghnU
         Grmqwg9SO3qL8kQbMBJmC179yHZDu4Bm0W6FAWWITQ+bVXZXAsE/12CETSafpUm4TK
         xS8x57yB2jXIR3YYiwn8En9sHzQmiSAzToppECCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/453] Revert "gpio: eic-sprd: Use devm_platform_ioremap_resource()"
Date:   Mon, 28 Dec 2020 13:44:22 +0100
Message-Id: <20201228124938.517230346@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang7@gmail.com>

[ Upstream commit 4ed7d7dd4890bb8120a3e77c16191a695fdfcc5a ]

This reverts commit 0f5cb8cc27a266c81e6523b436479802e9aafc9e.

This commit will cause below warnings, since our EIC controller can support
differnt banks on different Spreadtrum SoCs, and each bank has its own base
address, we will get invalid resource warning if the bank number is less than
SPRD_EIC_MAX_BANK on some Spreadtrum SoCs.

So we should not use devm_platform_ioremap_resource() here to remove the
warnings.

[    1.118508] sprd-eic 40210000.gpio: invalid resource
[    1.118535] sprd-eic 40210000.gpio: invalid resource
[    1.119034] sprd-eic 40210080.gpio: invalid resource
[    1.119055] sprd-eic 40210080.gpio: invalid resource
[    1.119462] sprd-eic 402100a0.gpio: invalid resource
[    1.119482] sprd-eic 402100a0.gpio: invalid resource
[    1.119893] sprd-eic 402100c0.gpio: invalid resource
[    1.119913] sprd-eic 402100c0.gpio: invalid resource

Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/8d3579f4b49bb675dc805035960f24852898be28.1585734060.git.baolin.wang7@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-eic-sprd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-eic-sprd.c b/drivers/gpio/gpio-eic-sprd.c
index bb287f35cf408..8c97577740100 100644
--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -569,6 +569,7 @@ static int sprd_eic_probe(struct platform_device *pdev)
 	const struct sprd_eic_variant_data *pdata;
 	struct gpio_irq_chip *irq;
 	struct sprd_eic *sprd_eic;
+	struct resource *res;
 	int ret, i;
 
 	pdata = of_device_get_match_data(&pdev->dev);
@@ -595,9 +596,13 @@ static int sprd_eic_probe(struct platform_device *pdev)
 		 * have one bank EIC, thus base[1] and base[2] can be
 		 * optional.
 		 */
-		sprd_eic->base[i] = devm_platform_ioremap_resource(pdev, i);
-		if (IS_ERR(sprd_eic->base[i]))
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res)
 			continue;
+
+		sprd_eic->base[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(sprd_eic->base[i]))
+			return PTR_ERR(sprd_eic->base[i]);
 	}
 
 	sprd_eic->chip.label = sprd_eic_label_name[sprd_eic->type];
-- 
2.27.0



