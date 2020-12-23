Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8EC2E17AF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgLWDK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgLWCSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA2022248;
        Wed, 23 Dec 2020 02:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689839;
        bh=8d6iZNRaYjIEhKitGugbVnoChNehCkV4MfzVN3jtJO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLreuccmLKja3Sb6j5fZtBQReBmuyUqPO6SOq13ADLQ7U6eQw4ZdhfIF7yQp7LjES
         QCatfyRDvkoIwi2OTpVxqzshMpt9Tfm7ZmGIOdCjVFErg9N/Q5Q3314TOb4YboA+/u
         lgUe5xaV8tvY3fWGMBGTJYQGUBH246/J/x87S64bEO3+9lfCVorjGUU3xx8xjL7BGY
         0np4+FxlEamcCbP+F6uLnypOI+M2f8v0HAIsQ0wcllFHq/HdBegFsD8ag0kbC+xVEu
         8cFK2VPW1drJF7UymYy2Itvwhb+bobzcrSye5zRPGNLWpoq5vQXZlwmNqLbH3MCYVW
         4OhrYQNvcEIrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 040/217] mips: ar7: add missing iounmap() on error in ar7_gpio_init
Date:   Tue, 22 Dec 2020 21:13:29 -0500
Message-Id: <20201223021626.2790791-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 5a5aa912f687204d50455d0db36f94dd8de601c2 ]

Add the missing iounmap() of gpch->regs before return from
ar7_gpio_init() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ar7/gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/ar7/gpio.c b/arch/mips/ar7/gpio.c
index 8b006addd6ba5..ae0e01b9438ff 100644
--- a/arch/mips/ar7/gpio.c
+++ b/arch/mips/ar7/gpio.c
@@ -319,6 +319,7 @@ int __init ar7_gpio_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to add gpiochip\n",
 					gpch->chip.label);
+		iounmap(gpch->regs);
 		return ret;
 	}
 	printk(KERN_INFO "%s: registered %d GPIOs\n",
-- 
2.27.0

