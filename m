Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34EF12C81A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfL2RvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732002AbfL2RvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CE08206DB;
        Sun, 29 Dec 2019 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641859;
        bh=58dQmQZ1DQTslgkTAVNSyDY3uAJ76+xZwt5XmHuAOnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz7yNvFqxWGEgThYmgrwasFNe2xbpCH3huO7Nr9/Eyz5vH+iisr8xPTpgykPgFQU9
         0S877VmWCFReNSDRJrM4m3SzxQmYWYTNe9IQaZibKqU3Pn5cvKSdIGcg+nuH6ypFot
         qFdHuS8EviY5fHLouGMkjdFkEHZkfmBylf3r1MP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/434] ASoC: SOF: topology: set trigger order for FE DAI link
Date:   Sun, 29 Dec 2019 18:24:47 +0100
Message-Id: <20191229172717.421627816@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 5eee2b3f60065a2530d13f28e771be48b989eb4c ]

Set trigger order for FE DAI links to SND_SOC_DPCM_TRIGGER_POST
to trigger the BE DAI's before the FE DAI's. This prevents the
xruns seen on playback pipelines using the link DMA.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191104224812.3393-3-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 4452594c2e17..fa299e078156 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2828,6 +2828,10 @@ static int sof_link_load(struct snd_soc_component *scomp, int index,
 	if (!link->no_pcm) {
 		link->nonatomic = true;
 
+		/* set trigger order */
+		link->trigger[0] = SND_SOC_DPCM_TRIGGER_POST;
+		link->trigger[1] = SND_SOC_DPCM_TRIGGER_POST;
+
 		/* nothing more to do for FE dai links */
 		return 0;
 	}
-- 
2.20.1



