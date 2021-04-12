Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5237535CCB6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244743AbhDLQbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244758AbhDLQ2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4AA6128E;
        Mon, 12 Apr 2021 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244724;
        bh=M8fbSehNGqt/LQzch9K75dWLf5XKFDbFtPsW/hYP+gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMa9Ai6VqZKepGuGAP566iDyO+gY+KceqolNGfbLyMYaLdOVEoqQNjkLvqJXTzC9r
         z2iAtI34J8M3H3QSk/TZCrx+cFDC776mowBpm8Ni5K6DpgXyGhmmwJqSb1zxcJ6Bca
         759VceJpHTRXT3T9sN5tWLqTSC50W2ndskf7LXyQ9ZH8jnlc2QcnnVxJszDW0EHx8T
         sep38UommGOrsNERe963GVGd8XJLCTBEz7VDI2+TzrPkaG6akrrfcQWP/ZR7sQ/b+3
         A+Q/ZAG8dacpg8IsOxV3xdyyjSWefPATy9NElMbkBl2ZhJ6wgOy9A/sOnXI7RfZn7A
         1dzul92jRBasg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 17/39] ASoC: fsl_esai: Fix TDM slot setup for I2S mode
Date:   Mon, 12 Apr 2021 12:24:39 -0400
Message-Id: <20210412162502.314854-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
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
index 84290be778f0..33ade79fa032 100644
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

