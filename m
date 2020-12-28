Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4821C2E645B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391179AbgL1Nie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391460AbgL1Nib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CBD21D94;
        Mon, 28 Dec 2020 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162695;
        bh=ibitAx/TqGr5tKS3rwIEAbmfpBvzBzaEFxioBppa8bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU6i+5gOS7PUptXWX0Ui/3m0gdBOwXuUhXxy/NjZgCXpF1s6bLsepin2A3Kda1to/
         yxUAZjmrcr+OJ/PNxMy08k7z6pDK+H9UOPdVKwZ1lVEbceNnsD+yYQrtrInvPPSQiR
         ZSZxXTHtXTf+vioZoFkKUSR/5Jz676oeDxEIyTBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/453] gpio: zynq: fix reference leak in zynq_gpio functions
Date:   Mon, 28 Dec 2020 13:44:07 +0100
Message-Id: <20201228124937.788163322@linuxfoundation.org>
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

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 7f57b295f990c0fa07f96d51ca1c82c52dbf79cc ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to putting operation will result in a
reference leak here.

A new function pm_runtime_resume_and_get is introduced in
[0] to keep usage counter balanced. So We fix the reference
leak by replacing it with new funtion.

[0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")

Fixes: c2df3de0d07e ("gpio: zynq: properly support runtime PM for GPIO used as interrupts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index 7835aad6d1628..88b04d8a7fa7d 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -556,7 +556,7 @@ static int zynq_gpio_irq_reqres(struct irq_data *d)
 	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
 	int ret;
 
-	ret = pm_runtime_get_sync(chip->parent);
+	ret = pm_runtime_resume_and_get(chip->parent);
 	if (ret < 0)
 		return ret;
 
@@ -884,7 +884,7 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		goto err_pm_dis;
 
-- 
2.27.0



