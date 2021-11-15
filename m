Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9A4512DB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbhKOTkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245123AbhKOTTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC9FF61548;
        Mon, 15 Nov 2021 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000935;
        bh=wgs3ryOIYyCrgX18rcyiaiIq+LEIF9X17Uww4D7C1Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swuma+wnZnae2WDOWqetEdSkMzEtziQ2le4g/rDeTVqwoa4ByXS3SMHNI+wm31WaQ
         REtxtoiNQzm1/GOMONzMUdgq6M0R+0ofgAs2ewBQuKvL2JAJ77n0PqRDVBCbiGj8SU
         A6bnrJ0e+bs0qLMxssJ3GuI+EBaOK/UeJDyc3FiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.14 847/849] pinctrl: amd: Add irq field data
Date:   Mon, 15 Nov 2021 18:05:30 +0100
Message-Id: <20211115165448.905940856@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 7e6f8d6f4a42ef9b693ff1b49267c546931d4619 upstream.

pinctrl_amd use gpiochip_get_data() to get their local state containers
back from the gpiochip passed as amd_gpio chip data.

Hence added irq field data to get directly using amd_gpio chip data.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20210831120613.1514899-2-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    9 ++++-----
 drivers/pinctrl/pinctrl-amd.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -932,7 +932,6 @@ static struct pinctrl_desc amd_pinctrl_d
 static int amd_gpio_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	int irq_base;
 	struct resource *res;
 	struct amd_gpio *gpio_dev;
 	struct gpio_irq_chip *girq;
@@ -955,9 +954,9 @@ static int amd_gpio_probe(struct platfor
 	if (!gpio_dev->base)
 		return -ENOMEM;
 
-	irq_base = platform_get_irq(pdev, 0);
-	if (irq_base < 0)
-		return irq_base;
+	gpio_dev->irq = platform_get_irq(pdev, 0);
+	if (gpio_dev->irq < 0)
+		return gpio_dev->irq;
 
 #ifdef CONFIG_PM_SLEEP
 	gpio_dev->saved_regs = devm_kcalloc(&pdev->dev, amd_pinctrl_desc.npins,
@@ -1020,7 +1019,7 @@ static int amd_gpio_probe(struct platfor
 		goto out2;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler,
+	ret = devm_request_irq(&pdev->dev, gpio_dev->irq, amd_gpio_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, gpio_dev);
 	if (ret)
 		goto out2;
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -98,6 +98,7 @@ struct amd_gpio {
 	struct resource         *res;
 	struct platform_device  *pdev;
 	u32			*saved_regs;
+	int			irq;
 };
 
 /*  KERNCZ configuration*/


