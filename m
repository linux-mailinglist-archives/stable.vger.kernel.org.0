Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05BF560DB
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZDtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfFZDnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:41 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE00C205ED;
        Wed, 26 Jun 2019 03:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520620;
        bh=2mkfzhi/YQ6DnEGVd3mCPmKplmLD7uWXYZALZr9o2io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4i4w7EAqEtRMsDfz4nEwo2BjhQvCNpfrkOgLiViIvX4fZHNIKE1uSjni1DPXMkUg
         /bxrQA+WE9PzRkjeBNszGwGPFRNtJ0+O4g/wuvPKwxDSEuMibkDwMrBjUJsl0foSx9
         of/g1HtFcd0+T1rj+auCYlsakYZyIExHFVuUC0IM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viorel Suman <viorel.suman@nxp.com>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 02/34] ASoC: ak4458: add return value for ak4458_probe
Date:   Tue, 25 Jun 2019 23:43:03 -0400
Message-Id: <20190626034335.23767-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viorel Suman <viorel.suman@nxp.com>

[ Upstream commit a8dee20d792432740509237943700fbcfc230bad ]

AK4458 is probed successfully even if AK4458 is not present - this
is caused by probe function returning no error on i2c access failure.
Return an error on probe if i2c access has failed.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 299ada4dfaa0..58b6ca1de993 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -492,9 +492,10 @@ static void ak4458_power_on(struct ak4458_priv *ak4458)
 	}
 }
 
-static void ak4458_init(struct snd_soc_component *component)
+static int ak4458_init(struct snd_soc_component *component)
 {
 	struct ak4458_priv *ak4458 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	/* External Mute ON */
 	if (ak4458->mute_gpiod)
@@ -502,21 +503,21 @@ static void ak4458_init(struct snd_soc_component *component)
 
 	ak4458_power_on(ak4458);
 
-	snd_soc_component_update_bits(component, AK4458_00_CONTROL1,
+	ret = snd_soc_component_update_bits(component, AK4458_00_CONTROL1,
 			    0x80, 0x80);   /* ACKS bit = 1; 10000000 */
+	if (ret < 0)
+		return ret;
 
-	ak4458_rstn_control(component, 1);
+	return ak4458_rstn_control(component, 1);
 }
 
 static int ak4458_probe(struct snd_soc_component *component)
 {
 	struct ak4458_priv *ak4458 = snd_soc_component_get_drvdata(component);
 
-	ak4458_init(component);
-
 	ak4458->fs = 48000;
 
-	return 0;
+	return ak4458_init(component);
 }
 
 static void ak4458_remove(struct snd_soc_component *component)
-- 
2.20.1

