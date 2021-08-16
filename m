Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959C13ED4E3
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbhHPNGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237012AbhHPNFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E1263290;
        Mon, 16 Aug 2021 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119107;
        bh=b4geYltxWGY/PJ0BsEKqfz62uhw0LBHjKqpHoviU7go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny2loTuF0AJrdMrbxERxrKMixY32PLsAJxH3LmaXq2fnu8QQsCeDvT+gtCcqXtJtQ
         ju8xmVON8QrTqg1syJInKer0yZXrRKZBzMoG9jMP+RUPtWgL0apGG7Je5BfubmUi7d
         82xxRpZcMuG+Y3SneBP0GggK/kSMz3jxtEknyK10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/62] ASoC: cs42l42: Correct definition of ADC Volume control
Date:   Mon, 16 Aug 2021 15:01:44 +0200
Message-Id: <20210816125428.608146277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5faf8877137a..5c6d288a92ab 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -403,7 +403,7 @@ static const struct regmap_config cs42l42_regmap = {
 	.use_single_write = true,
 };
 
-static DECLARE_TLV_DB_SCALE(adc_tlv, -9600, 100, false);
+static DECLARE_TLV_DB_SCALE(adc_tlv, -9700, 100, true);
 static DECLARE_TLV_DB_SCALE(mixer_tlv, -6300, 100, true);
 
 static const char * const cs42l42_hpf_freq_text[] = {
@@ -442,8 +442,7 @@ static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
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



