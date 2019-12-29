Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2074A12C409
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfL2RZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbfL2RZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:25:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5827921744;
        Sun, 29 Dec 2019 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640346;
        bh=UdwgVejPLAN2IZCVCqScot8vtG7yZfQSDzRq6PQ1Wis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9BSx83m0MaqXnXbjRELG6lmgVgCh1oLvwjsT8CtKmdajmwEG3X2tiR9gQUsMfVML
         MdvxY+V5HbPAaXT6kY/r82dLeU54v885ALUxFgWOCmtaFK0nEXFM3BQ4cDPhl+Dy2N
         IVhkOyo1rKVonkj2zX9ZCA7NI1JJiff37QRUaA/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/161] pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()
Date:   Sun, 29 Dec 2019 18:18:51 +0100
Message-Id: <20191229162424.423636490@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

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
index b78f42abff2f..7385cd81498c 100644
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



