Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266CB3ED5E8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhHPNPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239944AbhHPNOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27D1E632A7;
        Mon, 16 Aug 2021 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119500;
        bh=ZZh3SqU3xXEuTh/C6ZLb0SlqeaE/5iH53tHUGy7FjKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8Ds40b9U1wWwRoEJzOavFBcDlLmDIu4hGub0U2pmCU/NYWknZJ9xlkBRcEQeEXSW
         vGb9cgPpk1/QRPE+sYIxvGNvZIVgomtW40TFyd0V9INWNslt8f75nTSju2Fy2Zqacu
         CSWykjTuoIJCq1q/3fF5kkZFv7FQ7JYZN/8cfmFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 050/151] ASoC: cs42l42: Fix inversion of ADC Notch Switch control
Date:   Mon, 16 Aug 2021 15:01:20 +0200
Message-Id: <20210816125445.722854420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 30615bd21b4cc3c3bb5ae8bd70e2a915cc5f75c7 ]

The underlying register field has inverted sense (0 = enabled) so
the control definition must be marked as inverted.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210803160834.9005-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index fe73a5c70bdd..c7fb33a89224 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -436,7 +436,7 @@ static SOC_ENUM_SINGLE_DECL(cs42l42_wnf05_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
 static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 	/* ADC Volume and Filter Controls */
 	SOC_SINGLE("ADC Notch Switch", CS42L42_ADC_CTL,
-				CS42L42_ADC_NOTCH_DIS_SHIFT, true, false),
+				CS42L42_ADC_NOTCH_DIS_SHIFT, true, true),
 	SOC_SINGLE("ADC Weak Force Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_FORCE_WEAK_VCM_SHIFT, true, false),
 	SOC_SINGLE("ADC Invert Switch", CS42L42_ADC_CTL,
-- 
2.30.2



