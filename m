Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5F119AE4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfLJWE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfLJWE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64F92053B;
        Tue, 10 Dec 2019 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015467;
        bh=RdbXfKf5Rzr0OhOxihP2NlquBOZt0BtHA4HrYjLMuwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J80oV2IHPWRBD+3ZSSaPEmv7x5MopSzzJmdEwXdGKiexCPof7FlAT8JY1cILvB/Xe
         7WU2j36LMI+Qku5Y9cb3mg9s3/sFGrf9aJgRGaabog0SORLMvBb2vkiBTxHrkKWA5k
         j1KULvF+MZErqtr78lY1MmgPAbkBHL7uapxp0uvA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 073/130] pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()
Date:   Tue, 10 Dec 2019 17:02:04 -0500
Message-Id: <20191210220301.13262-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>

[ Upstream commit 10ff58aa3c2e2a093b6ad615a7e3d8bb0dc613e5 ]

The regs pointer in amd_gpio_irq_handler() should have __iomem
on it, so add that to fix the following sparse warnings:

drivers/pinctrl/pinctrl-amd.c:555:14: warning: incorrect type in assignment (different address spaces)
drivers/pinctrl/pinctrl-amd.c:555:14:    expected unsigned int [usertype] *regs
drivers/pinctrl/pinctrl-amd.c:555:14:    got void [noderef] <asn:2> *base
drivers/pinctrl/pinctrl-amd.c:563:34: warning: incorrect type in argument 1 (different address spaces)
drivers/pinctrl/pinctrl-amd.c:563:34:    expected void const volatile [noderef] <asn:2> *addr
drivers/pinctrl/pinctrl-amd.c:563:34:    got unsigned int [usertype] *
drivers/pinctrl/pinctrl-amd.c:580:34: warning: incorrect type in argument 1 (different address spaces)
drivers/pinctrl/pinctrl-amd.c:580:34:    expected void const volatile [noderef] <asn:2> *addr
drivers/pinctrl/pinctrl-amd.c:580:34:    got unsigned int [usertype] *
drivers/pinctrl/pinctrl-amd.c:587:25: warning: incorrect type in argument 2 (different address spaces)
drivers/pinctrl/pinctrl-amd.c:587:25:    expected void volatile [noderef] <asn:2> *addr
drivers/pinctrl/pinctrl-amd.c:587:25:    got unsigned int [usertype] *

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Link: https://lore.kernel.org/r/20191022151154.5986-1-ben.dooks@codethink.co.uk
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index b78f42abff2f8..7385cd81498c4 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -509,7 +509,8 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 	unsigned int i, irqnr;
 	unsigned long flags;
-	u32 *regs, regval;
+	u32 __iomem *regs;
+	u32  regval;
 	u64 status, mask;
 
 	/* Read the wake status */
-- 
2.20.1

