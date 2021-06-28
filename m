Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41653B61C8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhF1Oir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhF1Ogr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:36:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2211A61CAB;
        Mon, 28 Jun 2021 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890639;
        bh=4JTGJ+dweL0v00504jp7U4TEdw8dKTxu+ffHav2ILNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+gPyQRLH6ryh/StTx6M5+68MG+PHRhMb+iwaJzEybnfiy+ZlDM3oCGAudA6x0C9L
         YjFACc3Yw8Pc1ZJ/KjFolCy2TbTvk7s5WUHAXccFWLAew/NDd1Pi28f2DghrC3NzGt
         GnGHq9GBh/+AEMM5SzGqAqEhuOKtZt0I9Mza14j9Hei52M0UFowdBD1+v85QpyCKqb
         OHPOzrD/JkU8bUkNPtmyXH1y+Aakn3zNUHqVmB3WaLMjMaFUWnVAIq0+DR9JB1US4t
         f7R7vIKIN/9jsqgKXs7Ey+0lqOE0GXwtlgz319YVpafUpoZJEThPvtUG0y0dy8jmmH
         AsuuRoAXMb8CA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/71] pinctrl: stm32: fix the reported number of GPIO lines per bank
Date:   Mon, 28 Jun 2021 10:29:32 -0400
Message-Id: <20210628143004.32596-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 2d5e0435af0a..bac1d040baca 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1153,7 +1153,7 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 	struct resource res;
 	struct reset_control *rstc;
 	int npins = STM32_GPIO_PINS_PER_BANK;
-	int bank_nr, err;
+	int bank_nr, err, i = 0;
 
 	rstc = of_reset_control_get_exclusive(np, NULL);
 	if (!IS_ERR(rstc))
@@ -1182,9 +1182,14 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 
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

