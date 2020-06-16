Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469691FB733
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbgFPPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730404AbgFPPny (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F718214F1;
        Tue, 16 Jun 2020 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322233;
        bh=jxRBAJoYesLcQ4lUzvJzOYBx7xIDXeU3frH7E2O1cAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEHHCsCov4R/cUKD35UFhP/IDwmNzmFG1Ed9gx1dDwWSIQMkw+zQUh0mvcBipxyON
         55iyYtsiJUQj9EFDGDEZr4e0E5LUkpjDFSLgfxKozf627xALoSmYl/WTd7z2foVPJN
         zEzx4Uw+iei3ojy7j8WE9G32cbpT5fU/BEOTMpkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 051/163] ASoC: tlv320adcx140: Fix mic gain registers
Date:   Tue, 16 Jun 2020 17:33:45 +0200
Message-Id: <20200616153109.293589517@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

commit be8499c48f115b912f5747c420f66a5e2c31defe upstream.

Fix the mic gain registers for channels 2-4.
The incorret register was being set as it was touching the CH1 config
registers.

Fixes: 37bde5acf040 ("ASoC: tlv320adcx140: Add the tlv320adcx140 codec driver family")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200427203608.7031-1-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320adcx140.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -511,11 +511,11 @@ static const struct snd_soc_dapm_route a
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


