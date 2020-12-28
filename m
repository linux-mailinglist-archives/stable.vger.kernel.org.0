Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DBA2E660C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbgL1NZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388913AbgL1NZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F35E2072C;
        Mon, 28 Dec 2020 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161918;
        bh=V/6JNkaSfVK6TfVI1895ZxL0BT9b7+WoGm6BJcSfgi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvikxRpEmKDEhzLMtqmXVT7985mWGc551mfYiinD1vzZS/cLxT6llRn7+kmCCsZPA
         I/uzSzyRTQM2sV+9Oqvrxf9YYjRvS8/ylvRQYau3b8sVsl/aIEbvsppy54cTEAJgGB
         +1OpwC6cXH814dSX3e5530MoFWLw60JdcWSrlvMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/346] ASoC: pcm: DRAIN support reactivation
Date:   Mon, 28 Dec 2020 13:47:18 +0100
Message-Id: <20201228124925.546595955@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 4c22b80f61540ea99d9b4af0127315338755f05b ]

soc-pcm's dpcm_fe_dai_do_trigger() supported DRAIN commnad up to kernel
v5.4 where explicit switch(cmd) has been introduced which takes into
account all SNDRV_PCM_TRIGGER_xxx but SNDRV_PCM_TRIGGER_DRAIN. Update
switch statement to reactive support for it.

As DRAIN is somewhat unique by lacking negative/stop counterpart, bring
behaviour of dpcm_fe_dai_do_trigger() for said command back to its
pre-v5.4 state by adding it to START/RESUME/PAUSE_RELEASE group.

Fixes: acbf27746ecf ("ASoC: pcm: update FE/BE trigger order based on the command")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20201026100129.8216-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index a0d1ce0edaf9a..af14304645ce8 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2390,6 +2390,7 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 		case SNDRV_PCM_TRIGGER_START:
 		case SNDRV_PCM_TRIGGER_RESUME:
 		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		case SNDRV_PCM_TRIGGER_DRAIN:
 			ret = dpcm_dai_trigger_fe_be(substream, cmd, true);
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
@@ -2407,6 +2408,7 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 		case SNDRV_PCM_TRIGGER_START:
 		case SNDRV_PCM_TRIGGER_RESUME:
 		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		case SNDRV_PCM_TRIGGER_DRAIN:
 			ret = dpcm_dai_trigger_fe_be(substream, cmd, false);
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
-- 
2.27.0



