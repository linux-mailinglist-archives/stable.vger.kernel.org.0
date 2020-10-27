Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8F29B817
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799434AbgJ0Pb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799427AbgJ0Pb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB4B2225E;
        Tue, 27 Oct 2020 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812686;
        bh=N55eTGIP4hmpzZvez7ZTvlcsYxPK72y/ETkSGxhh8o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dq2L8a3dzfXRZBPwfXB9T3CZz7un/mybzDEsc2b4nuk7yin3szlXHWGkJQUFL1E2x
         6+lw8OxBrpsk9dw0WmtlCu6sGF4VcT2LQ44UETfQxtPZy9V1ld0sjJq8VyUHX6OxAW
         c4TKnPlybT2TvQE9eDzndc5kGoyZ49To8g7m5A+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 295/757] ASoC: tas2770: Fix error handling with update_bits
Date:   Tue, 27 Oct 2020 14:49:05 +0100
Message-Id: <20201027135504.403224494@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit cadab0aefcbadf488b16caf2770430e69f4d7839 ]

snd_soc_update_bits returns a 1 when the bit was successfully updated,
returns a 0 is no update was needed and a negative if the call failed.
The code is currently failing the case of a successful update by just
checking for a non-zero number. Modify these checks and return the error
code only if there is a negative.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-7-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 52 ++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index bdfdad5f4f644..15cdd8b11a67a 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -140,23 +140,18 @@ static int tas2770_dac_event(struct snd_soc_dapm_widget *w,
 			TAS2770_PWR_CTRL,
 			TAS2770_PWR_CTRL_MASK,
 			TAS2770_PWR_CTRL_MUTE);
-		if (ret)
-			goto end;
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_PWR_CTRL,
 			TAS2770_PWR_CTRL_MASK,
 			TAS2770_PWR_CTRL_SHUTDOWN);
-		if (ret)
-			goto end;
 		break;
 	default:
 		dev_err(tas2770->dev, "Not supported evevt\n");
 		return -EINVAL;
 	}
 
-end:
 	if (ret < 0)
 		return ret;
 
@@ -248,6 +243,9 @@ static int tas2770_set_bitwidth(struct tas2770_priv *tas2770, int bitwidth)
 		return -EINVAL;
 	}
 
+	if (ret < 0)
+		return ret;
+
 	tas2770->channel_size = bitwidth;
 
 	ret = snd_soc_component_update_bits(component,
@@ -256,16 +254,15 @@ static int tas2770_set_bitwidth(struct tas2770_priv *tas2770, int bitwidth)
 		TAS2770_TDM_CFG_REG5_50_MASK,
 		TAS2770_TDM_CFG_REG5_VSNS_ENABLE |
 		tas2770->v_sense_slot);
-	if (ret)
-		goto end;
+	if (ret < 0)
+		return ret;
+
 	ret = snd_soc_component_update_bits(component,
 		TAS2770_TDM_CFG_REG6,
 		TAS2770_TDM_CFG_REG6_ISNS_MASK |
 		TAS2770_TDM_CFG_REG6_50_MASK,
 		TAS2770_TDM_CFG_REG6_ISNS_ENABLE |
 		tas2770->i_sense_slot);
-
-end:
 	if (ret < 0)
 		return ret;
 
@@ -283,36 +280,35 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_48KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
 			TAS2770_TDM_CFG_REG0_31_44_1_48KHZ);
-		if (ret)
-			goto end;
 		break;
 	case 44100:
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_44_1KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
 			TAS2770_TDM_CFG_REG0_31_44_1_48KHZ);
-		if (ret)
-			goto end;
 		break;
 	case 96000:
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_48KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
@@ -323,8 +319,9 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_44_1KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
@@ -335,22 +332,22 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_48KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
 			TAS2770_TDM_CFG_REG0_31_176_4_192KHZ);
-		if (ret)
-			goto end;
 		break;
 	case 17640:
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_SMP_MASK,
 			TAS2770_TDM_CFG_REG0_SMP_44_1KHZ);
-		if (ret)
-			goto end;
+		if (ret < 0)
+			return ret;
+
 		ret = snd_soc_component_update_bits(component,
 			TAS2770_TDM_CFG_REG0,
 			TAS2770_TDM_CFG_REG0_31_MASK,
@@ -360,7 +357,6 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 		ret = -EINVAL;
 	}
 
-end:
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1



