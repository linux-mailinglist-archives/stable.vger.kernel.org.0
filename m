Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F32364376
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbhDSNSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240531AbhDSNQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A801561354;
        Mon, 19 Apr 2021 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838038;
        bh=BoVdH6KrJri0ZVRqOkfW+M41yFN1y391Hopf2LtxxdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/We9hmS0iwdsBoKifT3xRKHx5m8AuaZgDYEOIXlcjCjkB6t6pdSzGWjh9MEm3i6m
         m5K/YizFA94DKnpxnPKtUZ91X3ZGTQModQQ7+VA62ZCSHSn31imcA99DafvmdX2240
         JFo3SHHGGhyzjhhg0suZbQrrWYiTymwmkiQ5LdM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Lee <ryans.lee@maximintegrated.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/103] ASoC: max98373: Changed amp shutdown register as volatile
Date:   Mon, 19 Apr 2021 15:05:31 +0200
Message-Id: <20210419130528.486019705@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Lee <ryans.lee@maximintegrated.com>

[ Upstream commit a23f9099ff1541f15704e96b784d3846d2a4483d ]

0x20FF(amp global enable) register was defined as non-volatile,
but it is not. Overheating, overcurrent can cause amp shutdown
in hardware.
'regmap_write' compare register readback value before writing
to avoid same value writing. 'regmap_read' just read cache
not actual hardware value for the non-volatile register.
When amp is internally shutdown by some reason, next 'AMP ON'
command can be ignored because regmap think amp is already ON.

Signed-off-by: Ryan Lee <ryans.lee@maximintegrated.com>
Link: https://lore.kernel.org/r/20210325033555.29377-1-ryans.lee@maximintegrated.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373-i2c.c | 1 +
 sound/soc/codecs/max98373-sdw.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98373-i2c.c b/sound/soc/codecs/max98373-i2c.c
index 92921e34f948..32b0c1d98365 100644
--- a/sound/soc/codecs/max98373-i2c.c
+++ b/sound/soc/codecs/max98373-i2c.c
@@ -440,6 +440,7 @@ static bool max98373_volatile_reg(struct device *dev, unsigned int reg)
 	case MAX98373_R2054_MEAS_ADC_PVDD_CH_READBACK:
 	case MAX98373_R2055_MEAS_ADC_THERM_CH_READBACK:
 	case MAX98373_R20B6_BDE_CUR_STATE_READBACK:
+	case MAX98373_R20FF_GLOBAL_SHDN:
 	case MAX98373_R21FF_REV_ID:
 		return true;
 	default:
diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index fa589d834f9a..14fd2f9a0bf3 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -214,6 +214,7 @@ static bool max98373_volatile_reg(struct device *dev, unsigned int reg)
 	case MAX98373_R2054_MEAS_ADC_PVDD_CH_READBACK:
 	case MAX98373_R2055_MEAS_ADC_THERM_CH_READBACK:
 	case MAX98373_R20B6_BDE_CUR_STATE_READBACK:
+	case MAX98373_R20FF_GLOBAL_SHDN:
 	case MAX98373_R21FF_REV_ID:
 	/* SoundWire Control Port Registers */
 	case MAX98373_R0040_SCP_INIT_STAT_1 ... MAX98373_R0070_SCP_FRAME_CTLR:
-- 
2.30.2



