Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64661BAFA6
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 22:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgD0Um4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 16:42:56 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54826 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgD0Um4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 16:42:56 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03RKg7ao016845;
        Mon, 27 Apr 2020 15:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588020127;
        bh=lsXYqzJZ87/b6MFwb+B5fUGJvdO4PlNLviGnIO0YnAo=;
        h=From:To:CC:Subject:Date;
        b=noKuBg1NElWkIauG42saatFVPHdxtBT6s7C7V9rBxs1bD2QpLjquLnhOTElNvrbdb
         pz36GfwWTSnnxJoHkFP4+VD97M4nE1PwA19O+niyJZUBTrJG6i+6QjqKGI/t5oUWq3
         HRTL76pFRPgpFPGtefghQpe3rRaUbV1z6SxWENI8=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RKg7Yf070719;
        Mon, 27 Apr 2020 15:42:07 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 27
 Apr 2020 15:42:07 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 27 Apr 2020 15:42:07 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RKg7gb098139;
        Mon, 27 Apr 2020 15:42:07 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.com>
CC:     <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH] ASoC: tlv320adcx140: Fix mic gain registers
Date:   Mon, 27 Apr 2020 15:36:08 -0500
Message-ID: <20200427203608.7031-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the mic gain registers for channels 2-4.
The incorret register was being set as it was touching the CH1 config
registers.

Fixes: 37bde5acf040 ("ASoC: tlv320adcx140: Add the tlv320adcx140 codec driver family")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 sound/soc/codecs/tlv320adcx140.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 38897568ee96..0f713efde046 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -511,11 +511,11 @@ static const struct snd_soc_dapm_route adcx140_audio_map[] = {
 static const struct snd_kcontrol_new adcx140_snd_controls[] = {
 	SOC_SINGLE_TLV("Analog CH1 Mic Gain Volume", ADCX140_CH1_CFG1, 2, 42, 0,
 			adc_tlv),
-	SOC_SINGLE_TLV("Analog CH2 Mic Gain Volume", ADCX140_CH1_CFG2, 2, 42, 0,
+	SOC_SINGLE_TLV("Analog CH2 Mic Gain Volume", ADCX140_CH2_CFG1, 2, 42, 0,
 			adc_tlv),
-	SOC_SINGLE_TLV("Analog CH3 Mic Gain Volume", ADCX140_CH1_CFG3, 2, 42, 0,
+	SOC_SINGLE_TLV("Analog CH3 Mic Gain Volume", ADCX140_CH3_CFG1, 2, 42, 0,
 			adc_tlv),
-	SOC_SINGLE_TLV("Analog CH4 Mic Gain Volume", ADCX140_CH1_CFG4, 2, 42, 0,
+	SOC_SINGLE_TLV("Analog CH4 Mic Gain Volume", ADCX140_CH4_CFG1, 2, 42, 0,
 			adc_tlv),
 
 	SOC_SINGLE_TLV("DRE Threshold", ADCX140_DRE_CFG0, 4, 9, 0,
-- 
2.25.1

