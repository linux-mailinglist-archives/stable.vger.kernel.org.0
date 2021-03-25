Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF3348FC7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhCYL3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhCYL1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC61A61A5A;
        Thu, 25 Mar 2021 11:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671627;
        bh=1hF+lIPUhTu/RHqigdxN3BYvmstTkCfm8UYLgtUPiXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiOOIYC2TsL8DWAfG/Emm3GahT08sI4e7DBYqdl90NfS1NniImk0N6AzKYeiZkGQO
         P9rSk67fc94K8souScVEQDN83kKe3Yj/3mw67vouOMPdaNwfJgg4wTmPtJufIZt8Pe
         T3kqVufCmlVHXyjqGq6Hc5VXgKKoAWqFJgU9/K9yTWIPMVl9kedqCneuicLk5AnvEj
         8hnzVHxU/fKUyR6MPNwGSe3JUXq2yPOLthH6zjXCNHFbeFkOdkTUFEbNPjhSf4CFeP
         TCMGeUOw1PiSabHUANnmidSW8CLET21hlk1nBoqi0wSzdgE/c/gNS15w6n95UZqt9a
         ezzqV1LtKqu+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 12/24] ASoC: cs42l42: Fix mixer volume control
Date:   Thu, 25 Mar 2021 07:26:38 -0400
Message-Id: <20210325112651.1927828-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 72d904763ae6a8576e7ad034f9da4f0e3c44bf24 ]

The minimum value is 0x3f (-63dB), which also is mute

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210305173442.195740-4-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 26ca5acf0136..95930018a1a4 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -401,7 +401,7 @@ static const struct regmap_config cs42l42_regmap = {
 };
 
 static DECLARE_TLV_DB_SCALE(adc_tlv, -9600, 100, false);
-static DECLARE_TLV_DB_SCALE(mixer_tlv, -6200, 100, false);
+static DECLARE_TLV_DB_SCALE(mixer_tlv, -6300, 100, true);
 
 static const char * const cs42l42_hpf_freq_text[] = {
 	"1.86Hz", "120Hz", "235Hz", "466Hz"
@@ -458,7 +458,7 @@ static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 				CS42L42_DAC_HPF_EN_SHIFT, true, false),
 	SOC_DOUBLE_R_TLV("Mixer Volume", CS42L42_MIXER_CHA_VOL,
 			 CS42L42_MIXER_CHB_VOL, CS42L42_MIXER_CH_VOL_SHIFT,
-				0x3e, 1, mixer_tlv)
+				0x3f, 1, mixer_tlv)
 };
 
 static int cs42l42_hpdrv_evt(struct snd_soc_dapm_widget *w,
-- 
2.30.1

