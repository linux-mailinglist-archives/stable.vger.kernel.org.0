Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9BB3B638B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhF1O5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236292AbhF1OzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56EB661CC8;
        Mon, 28 Jun 2021 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891062;
        bh=k4ETqQidyKYLqCCAdgwmoyRKn0CqsQdv3vZ9EGY7Flk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB2tBHXa/CUopmDXmRSPpqANGWA4BernZZxJ6bCTdOofg0wd/NVIWnDhFJk+RJz4k
         iVnqoAX6fXZ6XX9xfLQA6hufnZCYY9yR7C0jJviF0Xj9KFjYdmrMLzk6Zp0WHWFC8e
         XrQuhtb09+8ukoSdjjTCbEPntwae5+9titxVdkUBbmh7qx5FBs08oGE2YN0yeBQCVq
         7UMtakMYVxMXq2ALrd16iVWmN0ULSJaBbSQIMBFn135hdFJRjfAiNbb4BpMJrABlnz
         VFN2zOW2ymPGR0LMqtmmNgHk4hRXrjEgy7GqlE4gl3Wc1uTVQs4bndW+zx+U1QH8mT
         jpnYpjooiIX2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 85/88] pinctrl: stm32: fix the reported number of GPIO lines per bank
Date:   Mon, 28 Jun 2021 10:36:25 -0400
Message-Id: <20210628143628.33342-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index 072bd11074c6..b38e82a868df 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -956,7 +956,7 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 	struct resource res;
 	struct reset_control *rstc;
 	int npins = STM32_GPIO_PINS_PER_BANK;
-	int bank_nr, err;
+	int bank_nr, err, i = 0;
 
 	rstc = of_reset_control_get_exclusive(np, NULL);
 	if (!IS_ERR(rstc))
@@ -985,9 +985,14 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 
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

