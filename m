Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D611101818
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfKSFfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbfKSFfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B61E21783;
        Tue, 19 Nov 2019 05:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141704;
        bh=mzQmq4oJQVKcMHvyvWtxQ3TSswoR90o9R63qzljJswI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNFevKfwBhrEfK+5KOK9rrGcBkY63i4MSMJNVpPh5P8LkjUcq9W4XTjW5V6dpT/Ka
         zUk9yGUL77w7eB+/FdQukLCkf3wq3XCTCoijIfPwNFozHq3wdTMGNxUs6Sg0IMDzP+
         MEFLFLUWbxkoqRGGcLm7snsFJ95fjwU7fD4vJPWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/422] ASoC: rt5682: Fix the boost volume at the begining of playback
Date:   Tue, 19 Nov 2019 06:17:29 +0100
Message-Id: <20191119051415.318432600@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 21e7c430baf7f..7a78bb00f874d 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -68,6 +68,7 @@ struct rt5682_priv {
 
 static const struct reg_sequence patch_list[] = {
 	{0x01c1, 0x1000},
+	{RT5682_DAC_ADC_DIG_VOL1, 0xa020},
 };
 
 static const struct reg_default rt5682_reg[] = {
@@ -1457,6 +1458,8 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_NG2_EN_MASK, RT5682_NG2_EN);
 		snd_soc_component_update_bits(component,
 			RT5682_DEPOP_1, 0x60, 0x60);
+		snd_soc_component_update_bits(component,
+			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0080);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
@@ -1464,6 +1467,8 @@ static int rt5682_hp_event(struct snd_soc_dapm_widget *w,
 			RT5682_DEPOP_1, 0x60, 0x0);
 		snd_soc_component_write(component,
 			RT5682_HP_CTRL_2, 0x0000);
+		snd_soc_component_update_bits(component,
+			RT5682_DAC_ADC_DIG_VOL1, 0x00c0, 0x0000);
 		break;
 
 	default:
-- 
2.20.1



