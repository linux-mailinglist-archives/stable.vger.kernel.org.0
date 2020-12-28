Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EB22E6736
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgL1NMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731979AbgL1NMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:12:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A9720728;
        Mon, 28 Dec 2020 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161117;
        bh=c4B3fO1OtDoA3nScQPDsP5CUgnB+CtrDeTI9K8bCwjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElcEqNXiHUVHM/KCv8e5oKOynpDo9m7kOvk4pHmnyIPB8VqUetYbhKGde6mAafRqm
         yZ8+QtTvhEzpEx1JsTnJ+rBvTyGI4ApuWKmQuMbLCWUX5f5zh72lvatVhQIuscFG7k
         tv0g18X5rg8TKMPC76RTGRAzCHcF3Y+UJ/nQyOOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/242] ASoC: pcm: DRAIN support reactivation
Date:   Mon, 28 Dec 2020 13:48:02 +0100
Message-Id: <20201228124908.478135413@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index fd4b71729eedd..e995e96ab9030 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2172,6 +2172,7 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 		case SNDRV_PCM_TRIGGER_START:
 		case SNDRV_PCM_TRIGGER_RESUME:
 		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		case SNDRV_PCM_TRIGGER_DRAIN:
 			ret = dpcm_dai_trigger_fe_be(substream, cmd, true);
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
@@ -2189,6 +2190,7 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 		case SNDRV_PCM_TRIGGER_START:
 		case SNDRV_PCM_TRIGGER_RESUME:
 		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		case SNDRV_PCM_TRIGGER_DRAIN:
 			ret = dpcm_dai_trigger_fe_be(substream, cmd, false);
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
-- 
2.27.0



