Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD4F66E8
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKJCki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfKJCkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8058521848;
        Sun, 10 Nov 2019 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353635;
        bh=tUyb4ZvDNTErODYS3eWyY51LlfThwbwFhqkZafNHPF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEsV7HaU+XUodwJ9eOj44pbkFdJj1QX9VDQJlrnxoaCNjav7afCfap2PldYy0Ybfy
         R3N7be+6sGNrBN8aDVX2v0Eaf/vM/FsmTX2Kg4AuJ6QV+Lh+JxIS3GiaRGeWK0+qT/
         CJZ8ZMi3FOD51Lh7J86tPXnciPO5b67bZnXviH84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 018/191] ASoC: rt5682: Fix the boost volume at the begining of playback
Date:   Sat,  9 Nov 2019 21:37:20 -0500
Message-Id: <20191110024013.29782-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 28b20dde5e1c943ab899549a655ac4935cffccbb ]

This patch fixed the boost volume at the begining of playback
while DAC volume set to lower level.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 6f5dac09ceded..baa00f04288bd 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -68,6 +68,7 @@ struct rt5682_priv {
 
 static const struct reg_sequence patch_list[] = {
 	{0x01c1, 0x1000},
+	{RT5682_DAC_ADC_DIG_VOL1, 0xa020},
 };
 
 static const struct reg_default rt5682_reg[] = {
@@ -1449,6 +1450,8 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_NG2_EN_MASK, RT5682_NG2_EN);
 		snd_soc_component_update_bits(component,
 			RT5682_DEPOP_1, 0x60, 0x60);
+		snd_soc_component_update_bits(component,
+			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0080);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
@@ -1456,6 +1459,8 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_DEPOP_1, 0x60, 0x0);
 		snd_soc_component_write(component,
 			RT5682_HP_CTRL_2, 0x0000);
+		snd_soc_component_update_bits(component,
+			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0000);
 		break;
 
 	default:
-- 
2.20.1

