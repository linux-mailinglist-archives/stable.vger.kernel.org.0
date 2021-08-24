Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03503F66F6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240501AbhHXR3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240236AbhHXR1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF4961B49;
        Tue, 24 Aug 2021 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824705;
        bh=M9fWKhUPS+ZVg1PXcpWyxYRWcVDywd5IoDbjGqunR88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJCmor3/6sii+k1GGDXIfDD1BE0gGFAc1zHXlmqY9xTVLU+9J+mxofMFp3h89CfS/
         aD8yKqV4ieicnjj2rQG2AJTGxGMGYwTFpTxoWUC9Ff99gJe1Hb336Rw1R4w0cvR0kP
         5/KIVOuuAmStolEdJbht7hDId/9Xj+XuIfNZCK1rv3yxdpmncsK/23s25uz6tFpjvF
         PXu1apP+NOousN6PwXF1ZgMOEpg1eW5IWrpuqRVHYHnRrobdllB8dHXlInKy2RuS9F
         HOdtxvanFrLN9mk0YXpuYG5pgFuLBwch2yqIpBaSGOraayFXkjcMu/rkddEV2aSLyr
         42Yvv2sCp/Mug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/64] ASoC: cs42l42: Correct definition of ADC Volume control
Date:   Tue, 24 Aug 2021 13:03:59 -0400
Message-Id: <20210824170457.710623-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ee86f680ff4c9b406d49d4e22ddf10805b8a2137 ]

The ADC volume is a signed 8-bit number with range -97 to +12,
with -97 being mute. Use a SOC_SINGLE_S8_TLV() to define this
and fix the DECLARE_TLV_DB_SCALE() to have the correct start and
mute flag.

Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210729170929.6589-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 39adb2fdd003..1d997b2df477 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -404,7 +404,7 @@ static const struct regmap_config cs42l42_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static DECLARE_TLV_DB_SCALE(adc_tlv, -9600, 100, false);
+static DECLARE_TLV_DB_SCALE(adc_tlv, -9700, 100, true);
 static DECLARE_TLV_DB_SCALE(mixer_tlv, -6300, 100, true);
 
 static const char * const cs42l42_hpf_freq_text[] = {
@@ -443,8 +443,7 @@ static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 				CS42L42_ADC_INV_SHIFT, true, false),
 	SOC_SINGLE("ADC Boost Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_DIG_BOOST_SHIFT, true, false),
-	SOC_SINGLE_SX_TLV("ADC Volume", CS42L42_ADC_VOLUME,
-				CS42L42_ADC_VOL_SHIFT, 0xA0, 0x6C, adc_tlv),
+	SOC_SINGLE_S8_TLV("ADC Volume", CS42L42_ADC_VOLUME, -97, 12, adc_tlv),
 	SOC_SINGLE("ADC WNF Switch", CS42L42_ADC_WNF_HPF_CTL,
 				CS42L42_ADC_WNF_EN_SHIFT, true, false),
 	SOC_SINGLE("ADC HPF Switch", CS42L42_ADC_WNF_HPF_CTL,
-- 
2.30.2

