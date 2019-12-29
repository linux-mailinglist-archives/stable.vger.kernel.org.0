Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E04C12C870
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbfL2Ryw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732283AbfL2Ryw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0686720718;
        Sun, 29 Dec 2019 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642091;
        bh=r4drbKus9o7E4e65lWGg21h6B6VQGYU7jpaonTNlv+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+9YLcbi30Sjzwmxn1NJqSlI0u3/MuycboTUNm9pU9eTBSWrW8vhjm7TXp6rFyHLt
         jQ3seTGmN7cDmAMT4WoIXs0m8tc9Hg4YI/KK/tY/T0FqjBL/PpTBMa8fy4k1hfMCT6
         Yd5diClLELPrvNPPEwCbgdVbEgLbVsbTCndDv8uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 339/434] ASoC: soc-pcm: check symmetry before hw_params
Date:   Sun, 29 Dec 2019 18:26:32 +0100
Message-Id: <20191229172724.486261658@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 5cca59516de5df9de6bdecb328dd55fb5bcccb41 ]

This reverts commit 957ce0c6b8a1f (ASoC: soc-pcm: check symmetry after
hw_params).

That commit cause soc_pcm_params_symmetry can't take effect.
cpu_dai->rate, cpu_dai->channels and cpu_dai->sample_bits
are updated in the middle of soc_pcm_hw_params, so move
soc_pcm_params_symmetry to the end of soc_pcm_hw_params is
not a good solution, for judgement of symmetry in the function
is always true.

FIXME:
According to the comments of that commit, I think the case
described in the commit should disable symmetric_rates
in Back-End, rather than changing the position of
soc_pcm_params_symmetry.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1573555602-5403-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index cdce96a3051b..a6e96cf1d8ff 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -877,6 +877,11 @@ static int soc_pcm_hw_params(struct snd_pcm_substream *substream,
 	int i, ret = 0;
 
 	mutex_lock_nested(&rtd->card->pcm_mutex, rtd->card->pcm_subclass);
+
+	ret = soc_pcm_params_symmetry(substream, params);
+	if (ret)
+		goto out;
+
 	if (rtd->dai_link->ops->hw_params) {
 		ret = rtd->dai_link->ops->hw_params(substream, params);
 		if (ret < 0) {
@@ -958,9 +963,6 @@ static int soc_pcm_hw_params(struct snd_pcm_substream *substream,
 	}
 	component = NULL;
 
-	ret = soc_pcm_params_symmetry(substream, params);
-        if (ret)
-		goto component_err;
 out:
 	mutex_unlock(&rtd->card->pcm_mutex);
 	return ret;
-- 
2.20.1



