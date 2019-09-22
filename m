Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D89BA84E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfIVTCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395399AbfIVTCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:02:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E6221BE5;
        Sun, 22 Sep 2019 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178925;
        bh=ajS824LenRlv1kgE8cKvjNmdtuc51nUxbHZHmDxrsXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKQJ40a89Uj4iNW4es61h5fg29BxC/VUv8rbjLFt69IJEtxjgx2Wpx+UiC0MWTgi7
         mZYBr5kIDIgmNgInSphIjX/C67MRaaNCAhtVh9xgQO+Ph0LkGHTZVspVyDNw47OF8j
         V3KSJC9v57DXpIIewP4qxpGR8U+EXzJUl3Kfn4I8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Arthur She <arthur.she@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 39/44] ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set
Date:   Sun, 22 Sep 2019 15:00:57 -0400
Message-Id: <20190922190103.4906-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 2ec42f3147e1610716f184b02e65d7f493eed925 ]

Some tools use the snd_pcm_info_get_name() to try to identify PCMs or for
other purposes.

Currently it is left empty with the dmaengine-pcm, in this case copy the
pcm->id string as pcm->name.

For example IGT is using this to find the HDMI PCM for testing audio on it.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reported-by: Arthur She <arthur.she@linaro.org>
Link: https://lore.kernel.org/r/20190906055524.7393-1-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 6fd1906af3873..fe65754c2e504 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -301,6 +301,12 @@ static int dmaengine_pcm_new(struct snd_soc_pcm_runtime *rtd)
 
 		if (!dmaengine_pcm_can_report_residue(dev, pcm->chan[i]))
 			pcm->flags |= SND_DMAENGINE_PCM_FLAG_NO_RESIDUE;
+
+		if (rtd->pcm->streams[i].pcm->name[0] == '\0') {
+			strncpy(rtd->pcm->streams[i].pcm->name,
+				rtd->pcm->streams[i].pcm->id,
+				sizeof(rtd->pcm->streams[i].pcm->name));
+		}
 	}
 
 	return 0;
-- 
2.20.1

