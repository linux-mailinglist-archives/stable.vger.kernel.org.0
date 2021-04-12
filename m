Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0B435CBF7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbhDLQ0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243687AbhDLQYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EAE961360;
        Mon, 12 Apr 2021 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244668;
        bh=LT19Tsj7rRQqwqIRqGo+4VMJMhxCyuV1B6R8L5c5T+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1RAGiKfH6tb5O292OFNW9GExhmINOxvbTQBkgIO0vWfXl5W4osb80fE3vd788jBg
         nh93of2deR3Wj1ikRWzHe18FBWq5GsmDQ0RxK66iukJ9j/RF3D+F7Lx3xz0lN4pJaf
         5Nn71jlW5biT+NIJltbiFkz3t9Q359WdPpxWa70NdrmyEvBCPvDm9+nmtG3h7pf5gb
         qBSF/1cGFa5Ymsw89jrtG9fEOAuChRLt+FmNhPtjKU8m7HuIv/R2RyQ43y4Kdmam3X
         dND+DmeuRzplYoWp4/tedRGKYkYeBMwldPAAp41e1DbhWSke6Qyw7pohFWqjdG1rRD
         gRQIXKgnBIJJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 21/46] ASoC: fsl_esai: Fix TDM slot setup for I2S mode
Date:   Mon, 12 Apr 2021 12:23:36 -0400
Message-Id: <20210412162401.314035-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index 39637ca78cdb..9f5f217a9607 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -524,11 +524,13 @@ static int fsl_esai_startup(struct snd_pcm_substream *substream,
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

