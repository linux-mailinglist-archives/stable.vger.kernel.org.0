Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4B3ED4C2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhHPNFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237059AbhHPNFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC6061A7A;
        Mon, 16 Aug 2021 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119077;
        bh=QLywhIFywpWEbX+dsv5bULDj7Qr/eK9d1Tt5jUC5M00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xsg20tCAHBYu57Ce18hcvzvx5ej66n4XD04w4qoKX8r3cyJNW78FHspiwZh3JDVg9
         7YWwQifcppyqpNfWxZkw7O8y431zFwZNwfpZ5b9kGeWIf0WfHrahFhUT77cHADMj7E
         Wafq/nHwshn7BMhWuiar6RwfJV4CqcLBiZh03cbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/62] ASoC: cs42l42: Remove duplicate control for WNF filter frequency
Date:   Mon, 16 Aug 2021 15:01:47 +0200
Message-Id: <20210816125428.707073382@linuxfoundation.org>
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
index 032ec4bd060b..eb37f88f8233 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -423,15 +423,6 @@ static SOC_ENUM_SINGLE_DECL(cs42l42_wnf3_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
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
@@ -449,7 +440,6 @@ static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 				CS42L42_ADC_HPF_EN_SHIFT, true, false),
 	SOC_ENUM("HPF Corner Freq", cs42l42_hpf_freq_enum),
 	SOC_ENUM("WNF 3dB Freq", cs42l42_wnf3_freq_enum),
-	SOC_ENUM("WNF 05dB Freq", cs42l42_wnf05_freq_enum),
 
 	/* DAC Volume and Filter Controls */
 	SOC_SINGLE("DACA Invert Switch", CS42L42_DAC_CTL1,
-- 
2.30.2



