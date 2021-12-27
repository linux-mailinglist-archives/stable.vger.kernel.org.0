Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4CF4803BE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhL0TFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39380 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbhL0TEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9DA061167;
        Mon, 27 Dec 2021 19:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF57C36AEB;
        Mon, 27 Dec 2021 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631849;
        bh=/nQrN0FXgdsX6Q6P3JVEqCU9UTngUmRgVqifX+Y7/SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOuigBzPYhBA/FDEL9YFssd/zSQe0wHzOdg9JMpGU6HANCCoVeIWoiipbPYUPEaIU
         auWSZVlTDs/X1Fqs/I9MhkWgQZzQJDeSNAsKQCw26olaPyPBfivvl09cKfAYqQkR7n
         hwSjBmZwNrD62V1CKR2P8muhPxHjdCIGcL5f15k0OO7LhGCT3aEMukN8+IkTWAKhjZ
         rD3ocYFAztAR+y8hCstsavSaBvhbGzuN64ACzGbx5bNGiyGZIc596lpjiEaNCUCzk4
         lplTeC5bV3tbqxEqQrqVzpFnSJGdqefeNfTv3E3olPFbMHcYkd5lgcTBmkRFWhxtAd
         yQbza4OXUfBBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, yebin10@huawei.com,
        kuninori.morimoto.gx@renesas.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 10/26] ASoC: tas2770: Fix setting of high sample rates
Date:   Mon, 27 Dec 2021 14:03:11 -0500
Message-Id: <20211227190327.1042326-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik@protonmail.com>

[ Upstream commit 80d5be1a057e05f01d66e986cfd34d71845e5190 ]

Although the codec advertises support for 176.4 and 192 ksps, without
this fix setting those sample rates fails with EINVAL at hw_params time.

Signed-off-by: Martin Povišer <povik@protonmail.com>
Link: https://lore.kernel.org/r/20211206224529.74656-1-povik@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 172e79cbe0daf..6549e7fef3e32 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -291,11 +291,11 @@ static int tas2770_set_samplerate(struct tas2770_priv *tas2770, int samplerate)
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_88_2_96KHZ;
 		break;
-	case 19200:
+	case 192000:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_48KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;
-	case 17640:
+	case 176400:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;
-- 
2.34.1

