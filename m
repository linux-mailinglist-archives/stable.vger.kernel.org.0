Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1655BCA514
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391796AbfJCQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391792AbfJCQat (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:30:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C52A120830;
        Thu,  3 Oct 2019 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120249;
        bh=0NklFi5BNWNDgAY2+lWD5jgqXv5IH1+D0pno6Bub/tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwNBM5I5R6eUH2zrpFT+S0T3Cf6qsNI7qq62EWrNFZ4ZFHW+4pnM6fskdkl8WBXJh
         0s2O3j0lvQ0kVgEOL8Gbnm12po2nT2Q1DOdIAk8quOpPneM0Xw2kkvUDTiC+nTxgPl
         LADTicJGnGVxknOzuIEdpd4RicDQuk6KvxdP+KuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Daniel Drake <drake@endlessm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 151/313] ASoC: es8316: fix headphone mixer volume table
Date:   Thu,  3 Oct 2019 17:52:09 +0200
Message-Id: <20191003154547.796863595@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <katsuhiro@katsuster.net>

[ Upstream commit f972d02fee2496024cfd6f59021c9d89d54922a6 ]

This patch fix setting table of Headphone mixer volume.
Current code uses 4 ... 7 values but these values are prohibited.

Correct settings are the following:
  0000 -12dB
  0001 -10.5dB
  0010 -9dB
  0011 -7.5dB
  0100 -6dB
  1000 -4.5dB
  1001 -3dB
  1010 -1.5dB
  1011 0dB

Signed-off-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Reviewed-by: Daniel Drake <drake@endlessm.com>
Link: https://lore.kernel.org/r/20190826153900.25969-1-katsuhiro@katsuster.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 6db002cc20582..96d04896193f2 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -51,7 +51,10 @@ static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(adc_vol_tlv, -9600, 50, 1);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_max_gain_tlv, -650, 150, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_min_gain_tlv, -1200, 150, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_target_tlv, -1650, 150, 0);
-static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(hpmixer_gain_tlv, -1200, 150, 0);
+static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(hpmixer_gain_tlv,
+	0, 4, TLV_DB_SCALE_ITEM(-1200, 150, 0),
+	8, 11, TLV_DB_SCALE_ITEM(-450, 150, 0),
+);
 
 static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(adc_pga_gain_tlv,
 	0, 0, TLV_DB_SCALE_ITEM(-350, 0, 0),
@@ -89,7 +92,7 @@ static const struct snd_kcontrol_new es8316_snd_controls[] = {
 	SOC_DOUBLE_TLV("Headphone Playback Volume", ES8316_CPHP_ICAL_VOL,
 		       4, 0, 3, 1, hpout_vol_tlv),
 	SOC_DOUBLE_TLV("Headphone Mixer Volume", ES8316_HPMIX_VOL,
-		       0, 4, 7, 0, hpmixer_gain_tlv),
+		       0, 4, 11, 0, hpmixer_gain_tlv),
 
 	SOC_ENUM("Playback Polarity", dacpol),
 	SOC_DOUBLE_R_TLV("DAC Playback Volume", ES8316_DAC_VOLL,
-- 
2.20.1



