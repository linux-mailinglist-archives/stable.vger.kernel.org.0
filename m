Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD015F153
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgBNSBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbgBNP4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27942468A;
        Fri, 14 Feb 2020 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695769;
        bh=J12BU6v6skinvk/5A45oPZq3RlG0T1+MQhN1yxEUabk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv9rPVjmDjoiKqXIE5xky5ey4+I/LevhhqDAn9AGzxXs3EaFTUMdMuEMx85R5QoJx
         6gfJXFqb13HmyZxGA7FW1GDSvEcPI8KEhw/R0KjrXb0BSi2BMO5KXWcOdq/cakBqMI
         VAS7/7k6bPOVkemFkaOnKdTBb/HJq52Ahen11kp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Burton <paulburton@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 335/542] ASoC: txx9: Remove unused rtd variable
Date:   Fri, 14 Feb 2020 10:45:27 -0500
Message-Id: <20200214154854.6746-335-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@kernel.org>

[ Upstream commit ec0f6a4c4a987aa20b2e77e0db2ae555276e45e6 ]

Commit a857e073ffc6 ("ASoC: txx9: txx9aclc: remove snd_pcm_ops") removed
the last use of the rtd variable but didn't remove its definition,
leading to the following warning/error for MIPS rbtx49xx_defconfig
builds:

sound/soc/txx9/txx9aclc.c: In function 'txx9aclc_pcm_hw_params':
sound/soc/txx9/txx9aclc.c:54:30: error: unused variable 'rtd'
    [-Werror=unused-variable]
  struct snd_soc_pcm_runtime *rtd = snd_pcm_substream_chip(substream);
                              ^~~

Resolve this by removing the unused variable.

Signed-off-by: Paul Burton <paulburton@kernel.org>
Fixes: a857e073ffc6 ("ASoC: txx9: txx9aclc: remove snd_pcm_ops")
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Link: https://lore.kernel.org/r/20200109191422.334516-1-paulburton@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/txx9/txx9aclc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 33c78d33e5a1d..9a55926ebf07b 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -51,7 +51,6 @@ static int txx9aclc_pcm_hw_params(struct snd_soc_component *component,
 				  struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params *params)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct txx9aclc_dmadata *dmadata = runtime->private_data;
 	int ret;
-- 
2.20.1

