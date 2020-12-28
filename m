Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6162B2E418B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440177AbgL1PIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:08:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438635AbgL1OIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23EA8206D8;
        Mon, 28 Dec 2020 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164481;
        bh=ZqUsvu8KzQ1vUMlvBPlC52wtDRcvm2/ghO01IpU3amc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBlKzKZgcVsd126u7/Xe2/UfjqZxiByjQzK4xez4Ex3i8bUTOxSpjiWeBMURo2ajz
         vYfSd4PhHJ9/B9yCWeSfMEFONNTDbp1SRz7WDv32PW/CRDrfgvkOl2D4uDiU2l8Q65
         JV8hil4HRDvELtZcb/qU7k28skyeWgCW3eTfpxHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/717] mmc: pxamci: Fix error return code in pxamci_probe
Date:   Mon, 28 Dec 2020 13:43:13 +0100
Message-Id: <20201228125030.309885938@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit d7b819b5d33869d41bdaa427aeb98ae24c57a38b ]

Fix to return the error code from devm_gpiod_get_optional() instaed
of 0 in pxamci_probe().

Fixes: f54005b508b9a9d9c ("mmc: pxa: Use GPIO descriptor for power")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20201121021431.3168506-1-chengzhihao1@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/pxamci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 29f6180a00363..316393c694d7a 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -731,6 +731,7 @@ static int pxamci_probe(struct platform_device *pdev)
 
 		host->power = devm_gpiod_get_optional(dev, "power", GPIOD_OUT_LOW);
 		if (IS_ERR(host->power)) {
+			ret = PTR_ERR(host->power);
 			dev_err(dev, "Failed requesting gpio_power\n");
 			goto out;
 		}
-- 
2.27.0



