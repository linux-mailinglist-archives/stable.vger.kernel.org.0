Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FD31BFCB9
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgD3OHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgD3Nw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 089DE24965;
        Thu, 30 Apr 2020 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254747;
        bh=nYvNC5mp3p9E42LUYjMDSuncRs7p9od0b/nf87IZNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4tQu3a3ykmzTDTVcJLPFx0KMCKj6hiI2OZKVR+ApH0iNQc04gnFhUhRUvuz1KGSW
         /JsGrVhyYasScJ+SRF09f5hU+MPeoGIyHkORV5jKBTzDqxMRt524itZlcoST7Y9EqX
         gPqHGaF1KIq8TjETN/gFahDIMv2fRic3oXVSMVVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 07/57] ASoC: topology: Check return value of soc_tplg_dai_config
Date:   Thu, 30 Apr 2020 09:51:28 -0400
Message-Id: <20200430135218.20372-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit dd8e871d4e560eeb8d22af82dde91457ad835a63 ]

Function soc_tplg_dai_config can fail, check for and handle possible
failure.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200327204729.397-7-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 22960f5932c7f..2d4a5a3058c41 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2431,7 +2431,7 @@ static int soc_tplg_dai_elems_load(struct soc_tplg *tplg,
 {
 	struct snd_soc_tplg_dai *dai;
 	int count;
-	int i;
+	int i, ret;
 
 	count = le32_to_cpu(hdr->count);
 
@@ -2446,7 +2446,12 @@ static int soc_tplg_dai_elems_load(struct soc_tplg *tplg,
 			return -EINVAL;
 		}
 
-		soc_tplg_dai_config(tplg, dai);
+		ret = soc_tplg_dai_config(tplg, dai);
+		if (ret < 0) {
+			dev_err(tplg->dev, "ASoC: failed to configure DAI\n");
+			return ret;
+		}
+
 		tplg->pos += (sizeof(*dai) + le32_to_cpu(dai->priv.size));
 	}
 
-- 
2.20.1

