Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0A3B6118
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhF1Ob5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234860AbhF1Oaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3652661C8A;
        Mon, 28 Jun 2021 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890417;
        bh=zg7OI1Dk3F/Bn4+tLIiV774mDoUC3mGbqqILpbbh9o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg3RBVYwdo/unO7fyFfwnBZpEVx+TotrAr1VVXday/5qiZYBsxKJ+eu0FvMcuPCnu
         T9vamxsSpEMGNSHKJ9/yluhVeH5F6krafQZMKPZHFhyaZD43207J+4NH4oXJ6LVsaM
         j0Az940uMtW1ibhcULMLwCzITdQ9en28R7rL4mSJ+B2JaA+DiOlCmBxdQFqxs/huXS
         H3jpYOX/+ZkorhTLMfl188FXSxgSCAQltcCydkTvK7wSW55jiFThZGgJsYF7L/lV+g
         f4LqbNGk30ixc7jyk86Us4Dc1HyaR6QIKQYU0f8XDP7tqnpRHR6kdtJU09nXCv5SwP
         GEsaH6aRYmPhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/101] pinctrl: stm32: fix the reported number of GPIO lines per bank
Date:   Mon, 28 Jun 2021 10:25:24 -0400
Message-Id: <20210628142607.32218-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 7d9bdedcd71b..3af4430543dc 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1229,7 +1229,7 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 	struct device *dev = pctl->dev;
 	struct resource res;
 	int npins = STM32_GPIO_PINS_PER_BANK;
-	int bank_nr, err;
+	int bank_nr, err, i = 0;
 
 	if (!IS_ERR(bank->rstc))
 		reset_control_deassert(bank->rstc);
@@ -1251,9 +1251,14 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 
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

