Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C77F4A57
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390099AbfKHMIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388659AbfKHLkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF2E21D7B;
        Fri,  8 Nov 2019 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213230;
        bh=MoWnjBMIgcXTr4l6Fg4FmwAOxh2SjxrlgINqMqRU38o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJf8uBtTt3qxK693UVH3hFdj9Sikg9krw0+aXmuF4qnflFV0yIZ9yNptN3ghvx9gx
         K6gFXLKday/gSJ/xPsnvQRWK5K0wzaBgBJwmTnkLHmKpMfva3ZK8/hGo/G0R2wTchd
         3+M4vkafnfvop5JyR9/eLD44pwter6iX5ZubSfLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 102/205] ASoC: dapm: Avoid uninitialised variable warning
Date:   Fri,  8 Nov 2019 06:36:09 -0500
Message-Id: <20191108113752.12502-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit fc269c0396448cabe1afd648c0b335669aa347b7 ]

Commit 4a75aae17b2a ("ASoC: dapm: Add support for multi-CODEC
CODEC to CODEC links") adds loops that iterate over multiple
CODECs in snd_soc_dai_link_event. This also introduced a compiler
warning for a potentially uninitialised variable in the case
no CODECs are present. This should never be the case as the
DAI link must by definition contain at least 1 CODEC however
probably best to avoid the compiler warning by initialising ret
to zero.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index ff31d9f9ecd64..7f0b48b363809 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3684,7 +3684,7 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 	struct snd_pcm_hw_params *params = NULL;
 	struct snd_pcm_runtime *runtime = NULL;
 	unsigned int fmt;
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON(!config) ||
 	    WARN_ON(list_empty(&w->edges[SND_SOC_DAPM_DIR_OUT]) ||
-- 
2.20.1

