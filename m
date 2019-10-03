Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75066CA87B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391260AbfJCQ1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391244AbfJCQ1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F41D222C2;
        Thu,  3 Oct 2019 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120044;
        bh=hYUfsW0L/9lk8I7RgCsHnsruaZp2MEdg3A4yuinmzlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tRlihrLh7EdVcwWRQRpMD8qEHrMrBQhh3WVjfq9yUPQOdBoqht2RRcLT1m7hbGpD
         WiOiVT2oVApKsNmhB7kzZvcpQYe1KIX9ZmcMbE7zwjKMETj/l9jBEZbboK8VcD5YMx
         DShLKke+7PPpeRNK+lFcgfYcBu6GyhVGAor1c9x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 039/313] ASoC: sgtl5000: Fix of unmute outputs on probe
Date:   Thu,  3 Oct 2019 17:50:17 +0200
Message-Id: <20191003154537.075912544@linuxfoundation.org>
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

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit 631bc8f0134ae9620d86a96b8c5f9445d91a2dca ]

To enable "zero cross detect" for ADC/HP, change
HP_ZCD_EN/ADC_ZCD_EN bits only instead of writing the whole
CHIP_ANA_CTRL register.

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20190719100524.23300-6-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index a6a4748c97f9d..aad9eca41587e 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1288,6 +1288,7 @@ static int sgtl5000_probe(struct snd_soc_component *component)
 	int ret;
 	u16 reg;
 	struct sgtl5000_priv *sgtl5000 = snd_soc_component_get_drvdata(component);
+	unsigned int zcd_mask = SGTL5000_HP_ZCD_EN | SGTL5000_ADC_ZCD_EN;
 
 	/* power up sgtl5000 */
 	ret = sgtl5000_set_power_regs(component);
@@ -1315,9 +1316,8 @@ static int sgtl5000_probe(struct snd_soc_component *component)
 	       0x1f);
 	snd_soc_component_write(component, SGTL5000_CHIP_PAD_STRENGTH, reg);
 
-	snd_soc_component_write(component, SGTL5000_CHIP_ANA_CTRL,
-			SGTL5000_HP_ZCD_EN |
-			SGTL5000_ADC_ZCD_EN);
+	snd_soc_component_update_bits(component, SGTL5000_CHIP_ANA_CTRL,
+		zcd_mask, zcd_mask);
 
 	snd_soc_component_update_bits(component, SGTL5000_CHIP_MIC_CTRL,
 			SGTL5000_BIAS_R_MASK,
-- 
2.20.1



