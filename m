Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5726524709F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390377AbgHQSMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388403AbgHQQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EFEC21744;
        Mon, 17 Aug 2020 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680439;
        bh=HTbYPPiLX1D+TeX1/625p9jUsugtMD+BGLOZNajy31g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk9ieZvFFkq/gKaeio7XD33YfFBs0AE0VOBZqdmKJUjJvLDNP7QW4p8ZcJnKVs8CH
         HN6ET9HuLfALApEYIjF9qFcvqqpKDYF5mesaoTaKhrsDpomsKJsygqaTl9Dqrw66zu
         PLhaH9KnVBX91KZeaVEII1VcfjvVouMYBZvcVuRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/270] ASoC: meson: axg-tdm-interface: fix link fmt setup
Date:   Mon, 17 Aug 2020 17:16:28 +0200
Message-Id: <20200817143805.127377483@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 6878ba91ce84f7a07887a0615af70f969508839f ]

The .set_fmt() callback of the axg tdm interface incorrectly
test the content of SND_SOC_DAIFMT_MASTER_MASK as if it was a
bitfield, which it is not.

Implement the test correctly.

Fixes: d60e4f1e4be5 ("ASoC: meson: add tdm interface driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200729154456.1983396-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdm-interface.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/sound/soc/meson/axg-tdm-interface.c b/sound/soc/meson/axg-tdm-interface.c
index d51f3344be7c6..e25336f739123 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -119,18 +119,25 @@ static int axg_tdm_iface_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 {
 	struct axg_tdm_iface *iface = snd_soc_dai_get_drvdata(dai);
 
-	/* These modes are not supported */
-	if (fmt & (SND_SOC_DAIFMT_CBS_CFM | SND_SOC_DAIFMT_CBM_CFS)) {
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		if (!iface->mclk) {
+			dev_err(dai->dev, "cpu clock master: mclk missing\n");
+			return -ENODEV;
+		}
+		break;
+
+	case SND_SOC_DAIFMT_CBM_CFM:
+		break;
+
+	case SND_SOC_DAIFMT_CBS_CFM:
+	case SND_SOC_DAIFMT_CBM_CFS:
 		dev_err(dai->dev, "only CBS_CFS and CBM_CFM are supported\n");
+		/* Fall-through */
+	default:
 		return -EINVAL;
 	}
 
-	/* If the TDM interface is the clock master, it requires mclk */
-	if (!iface->mclk && (fmt & SND_SOC_DAIFMT_CBS_CFS)) {
-		dev_err(dai->dev, "cpu clock master: mclk missing\n");
-		return -ENODEV;
-	}
-
 	iface->fmt = fmt;
 	return 0;
 }
@@ -319,7 +326,8 @@ static int axg_tdm_iface_hw_params(struct snd_pcm_substream *substream,
 	if (ret)
 		return ret;
 
-	if (iface->fmt & SND_SOC_DAIFMT_CBS_CFS) {
+	if ((iface->fmt & SND_SOC_DAIFMT_MASTER_MASK) ==
+	    SND_SOC_DAIFMT_CBS_CFS) {
 		ret = axg_tdm_iface_set_sclk(dai, params);
 		if (ret)
 			return ret;
-- 
2.25.1



