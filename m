Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B943A61B9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhFNKu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhFNKs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B706145B;
        Mon, 14 Jun 2021 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667077;
        bh=NfkiMjpLjm1upoaebqhjlgKdC7Y0w5nULqzevbB7IeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZ8F3yugEShR3Rmq+KPixfOXW7O/nbbq4lMKEidF5Ag06nN0mgbvYly8pfTJQTO6k
         2Lx3FjOVHmDuM23CKYtqwFlcHJd21eIPQ3snECPb26rgE4ZVfS9sHio2wCBUBkhwyc
         DzMsBYowNozCHGFGErktuu7hasWZOZlaq4teHewQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/84] ASoC: max98088: fix ni clock divider calculation
Date:   Mon, 14 Jun 2021 12:26:40 +0200
Message-Id: <20210614102646.420266910@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 6c9762a78c325107dc37d20ee21002b841679209 ]

The ni1/ni2 ratio formula [1] uses the pclk which is the prescaled mclk.
The max98088 datasheet [2] has no such formula but table-12 equals so
we can assume that it is the same for both devices.

While on it make use of DIV_ROUND_CLOSEST_ULL().

[1] https://datasheets.maximintegrated.com/en/ds/MAX98089.pdf; page 86
[2] https://datasheets.maximintegrated.com/en/ds/MAX98088.pdf; page 82

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20210423135402.32105-1-m.felsch@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98088.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index f031d2caa8b7..fa4cdbfd0b80 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -41,6 +41,7 @@ struct max98088_priv {
 	enum max98088_type devtype;
 	struct max98088_pdata *pdata;
 	struct clk *mclk;
+	unsigned char mclk_prescaler;
 	unsigned int sysclk;
 	struct max98088_cdata dai[2];
 	int eq_textcnt;
@@ -998,13 +999,16 @@ static int max98088_dai1_hw_params(struct snd_pcm_substream *substream,
        /* Configure NI when operating as master */
        if (snd_soc_component_read32(component, M98088_REG_14_DAI1_FORMAT)
                & M98088_DAI_MAS) {
+               unsigned long pclk;
+
                if (max98088->sysclk == 0) {
                        dev_err(component->dev, "Invalid system clock frequency\n");
                        return -EINVAL;
                }
                ni = 65536ULL * (rate < 50000 ? 96ULL : 48ULL)
                                * (unsigned long long int)rate;
-               do_div(ni, (unsigned long long int)max98088->sysclk);
+               pclk = DIV_ROUND_CLOSEST(max98088->sysclk, max98088->mclk_prescaler);
+               ni = DIV_ROUND_CLOSEST_ULL(ni, pclk);
                snd_soc_component_write(component, M98088_REG_12_DAI1_CLKCFG_HI,
                        (ni >> 8) & 0x7F);
                snd_soc_component_write(component, M98088_REG_13_DAI1_CLKCFG_LO,
@@ -1065,13 +1069,16 @@ static int max98088_dai2_hw_params(struct snd_pcm_substream *substream,
        /* Configure NI when operating as master */
        if (snd_soc_component_read32(component, M98088_REG_1C_DAI2_FORMAT)
                & M98088_DAI_MAS) {
+               unsigned long pclk;
+
                if (max98088->sysclk == 0) {
                        dev_err(component->dev, "Invalid system clock frequency\n");
                        return -EINVAL;
                }
                ni = 65536ULL * (rate < 50000 ? 96ULL : 48ULL)
                                * (unsigned long long int)rate;
-               do_div(ni, (unsigned long long int)max98088->sysclk);
+               pclk = DIV_ROUND_CLOSEST(max98088->sysclk, max98088->mclk_prescaler);
+               ni = DIV_ROUND_CLOSEST_ULL(ni, pclk);
                snd_soc_component_write(component, M98088_REG_1A_DAI2_CLKCFG_HI,
                        (ni >> 8) & 0x7F);
                snd_soc_component_write(component, M98088_REG_1B_DAI2_CLKCFG_LO,
@@ -1113,8 +1120,10 @@ static int max98088_dai_set_sysclk(struct snd_soc_dai *dai,
         */
        if ((freq >= 10000000) && (freq < 20000000)) {
                snd_soc_component_write(component, M98088_REG_10_SYS_CLK, 0x10);
+               max98088->mclk_prescaler = 1;
        } else if ((freq >= 20000000) && (freq < 30000000)) {
                snd_soc_component_write(component, M98088_REG_10_SYS_CLK, 0x20);
+               max98088->mclk_prescaler = 2;
        } else {
                dev_err(component->dev, "Invalid master clock frequency\n");
                return -EINVAL;
-- 
2.30.2



