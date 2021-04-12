Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BBB35CD98
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbhDLQha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245024AbhDLQdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C61C761382;
        Mon, 12 Apr 2021 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244801;
        bh=T2hsz0iNzxTpVAnJMcYS+cEgpIMXBXsh1fhOrLclxag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+d1KDgLhSz3/B5bbyAog+1Pr+BaUpviL2JZztNOgcpXwaXH7TkeIt0NsSYjqOTnk
         mCfTdgdGJgpZruTu7+fG/g8MNwVgEuMn74DiP5FJTu2ewvVtThiZdGv6Stmbq8MuIS
         UGgzjIOhQigPD+5z6GtwS3pK3Xqt7L3fRFOs4+pzr89qtnt3e+KIhgo2NfSx324OmR
         KBmypP7VZJT2WNqIBE6fwCO3myRNA/GriG/Pf6eOPFLtJj4MPQtDoi7i9Nq09i2ifd
         YAC+FE8m2R2Em0xJJTk20WJT0PaXpc5RXSF2gAih/8J2R+vm+Jh/Rr5LIz2l0rE35d
         7kKVgrZSpgG/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 08/25] ASoC: fsl_esai: Fix TDM slot setup for I2S mode
Date:   Mon, 12 Apr 2021 12:26:13 -0400
Message-Id: <20210412162630.315526-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit e7a48c710defa0e0fef54d42b7d9e4ab596e2761 ]

When using the driver in I2S TDM mode, the fsl_esai_startup()
function rewrites the number of slots previously set by the
fsl_esai_set_dai_tdm_slot() function to 2.
To fix this, let's use the saved slot count value or, if TDM
is not used and the number of slots is not set, the driver will use
the default value (2), which is set by fsl_esai_probe().

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210402081405.9892-1-shc_work@mail.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_esai.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 6152ae24772b..3ac87f7843f6 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -494,11 +494,13 @@ static int fsl_esai_startup(struct snd_pcm_substream *substream,
 				   ESAI_SAICR_SYNC, esai_priv->synchronous ?
 				   ESAI_SAICR_SYNC : 0);
 
-		/* Set a default slot number -- 2 */
+		/* Set slots count */
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_TCCR,
-				   ESAI_xCCR_xDC_MASK, ESAI_xCCR_xDC(2));
+				   ESAI_xCCR_xDC_MASK,
+				   ESAI_xCCR_xDC(esai_priv->slots));
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_RCCR,
-				   ESAI_xCCR_xDC_MASK, ESAI_xCCR_xDC(2));
+				   ESAI_xCCR_xDC_MASK,
+				   ESAI_xCCR_xDC(esai_priv->slots));
 	}
 
 	return 0;
-- 
2.30.2

