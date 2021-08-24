Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D743F6637
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbhHXRVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240593AbhHXRT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D2061AEB;
        Tue, 24 Aug 2021 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824583;
        bh=w0VWTZyZg2y0FV/aw4m4fPcjpy4D997HqAgCMjkkvmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUsMCRB39JaSpm+X47T5rmmdL/Vh18UneOqsHV5nOn0zaldw7xKlwTAAXaPA4C+bS
         /gYlDa46c3SD9+XdqAE/I5AVUENSybUs647Sxtwh6pQOGE25ooj8G0wr2l+9W7QMF0
         SZ+2F1j+c3kx3HRLfaoxcuSUdXUKnkg4VKIIgq2OUwqeM9eZggdoCukQhkL+y+VBG+
         qTGAp87YgGeRZyGc9+JAgRwii61FQOHFoCnOPCibFCwBmMXO4agFbihzy1C/bG2UuU
         mi6uz1jpir4BA2yb4cxk4dODxrMqZZmix/pbYr80T09+rfVocaQPGh6ZKEgDwFnTb1
         K/RqIbbMDDKZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/84] ASoC: cs42l42: Remove duplicate control for WNF filter frequency
Date:   Tue, 24 Aug 2021 13:01:37 -0400
Message-Id: <20210824170250.710392-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 8b353bbeae20e2214c9d9d88bcb2fda4ba145d83 ]

The driver was defining two ALSA controls that both change the same
register field for the wind noise filter corner frequency. The filter
response has two corners, at different frequencies, and the duplicate
controls most likely were an attempt to be able to set the value using
either of the frequencies.

However, having two controls changing the same field can be problematic
and it is unnecessary. Both frequencies are related to each other so
setting one implies exactly what the other would be.

Removing a control affects user-side code, but there is currently no
known use of the removed control so it would be best to remove it now
before it becomes a problem.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210803160834.9005-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index c11e60e9fe4e..fb12fcf88878 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -424,15 +424,6 @@ static SOC_ENUM_SINGLE_DECL(cs42l42_wnf3_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
 			    CS42L42_ADC_WNF_CF_SHIFT,
 			    cs42l42_wnf3_freq_text);
 
-static const char * const cs42l42_wnf05_freq_text[] = {
-	"280Hz", "315Hz", "350Hz", "385Hz",
-	"420Hz", "455Hz", "490Hz", "525Hz"
-};
-
-static SOC_ENUM_SINGLE_DECL(cs42l42_wnf05_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
-			    CS42L42_ADC_WNF_CF_SHIFT,
-			    cs42l42_wnf05_freq_text);
-
 static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 	/* ADC Volume and Filter Controls */
 	SOC_SINGLE("ADC Notch Switch", CS42L42_ADC_CTL,
@@ -450,7 +441,6 @@ static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 				CS42L42_ADC_HPF_EN_SHIFT, true, false),
 	SOC_ENUM("HPF Corner Freq", cs42l42_hpf_freq_enum),
 	SOC_ENUM("WNF 3dB Freq", cs42l42_wnf3_freq_enum),
-	SOC_ENUM("WNF 05dB Freq", cs42l42_wnf05_freq_enum),
 
 	/* DAC Volume and Filter Controls */
 	SOC_SINGLE("DACA Invert Switch", CS42L42_DAC_CTL1,
-- 
2.30.2

