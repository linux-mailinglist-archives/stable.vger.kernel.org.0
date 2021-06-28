Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D111B3B62E0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhF1OuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236280AbhF1OrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 057C461D1B;
        Mon, 28 Jun 2021 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890879;
        bh=Gv3gxczTyAMNtTNk1rnU87eFT0Px8Z7jDPvLke/K7uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVbaxy/QCqULT/4vYLeJMpN+JMpjhB4ktYKEgseyq5AvQ4hUI5eZGmQBIy0f2iJq5
         V2NEGSeTGEiwIG4ba7pkDxaJSlT7XwragHGjPrwARq4Bk4DO7L9nIYm9GG7xex7isk
         vvjHRjb2lDxd00GcuBBE96bO2ODmQB9FkrJ9E2lw0aiKSJkDBeZG/HaAxKdjf6atjK
         I+5g6HcdE1UzlFHO451ZTZtOMMZb2pSzxI2yFzgQIJC8LUJ+Trffc1ca1/oxRz6o9/
         WU0rW/+PIjJysO6dCyS13dxEX78ioCCYaDVTKHIy6iEw6VnGCx1duX2LZHEryQt/uf
         9KilGzYrAYH+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/109] pinctrl: stm32: fix the reported number of GPIO lines per bank
Date:   Mon, 28 Jun 2021 10:33:02 -0400
Message-Id: <20210628143305.32978-107-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@foss.st.com>

[ Upstream commit 67e2996f72c71ebe4ac2fcbcf77e54479bb7aa11 ]

Each GPIO bank supports a variable number of lines which is usually 16, but
is less in some cases : this is specified by the last argument of the
"gpio-ranges" bank node property.
Report to the framework, the actual number of lines, so the libgpiod
gpioinfo command lists the actually existing GPIO lines.

Fixes: 1dc9d289154b ("pinctrl: stm32: add possibility to use gpio-ranges to declare bank range")
Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
Link: https://lore.kernel.org/r/20210617144629.2557693-1-fabien.dessenne@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 14dfbbd6c1c3..4e17728f2937 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -978,7 +978,7 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 	struct resource res;
 	struct reset_control *rstc;
 	int npins = STM32_GPIO_PINS_PER_BANK;
-	int bank_nr, err;
+	int bank_nr, err, i = 0;
 
 	rstc = of_reset_control_get_exclusive(np, NULL);
 	if (!IS_ERR(rstc))
@@ -1007,9 +1007,14 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 
 	of_property_read_string(np, "st,bank-name", &bank->gpio_chip.label);
 
-	if (!of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, 0, &args)) {
+	if (!of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, i, &args)) {
 		bank_nr = args.args[1] / STM32_GPIO_PINS_PER_BANK;
 		bank->gpio_chip.base = args.args[1];
+
+		npins = args.args[2];
+		while (!of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3,
+							 ++i, &args))
+			npins += args.args[2];
 	} else {
 		bank_nr = pctl->nbanks;
 		bank->gpio_chip.base = bank_nr * STM32_GPIO_PINS_PER_BANK;
-- 
2.30.2

