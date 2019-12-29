Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2772012C519
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbfL2Rdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbfL2Rdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B36F207FD;
        Sun, 29 Dec 2019 17:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640822;
        bh=bdFXMNImFLAsakPoKu5xkzNEpT/ksNyRURldYJryKh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXiAKcp42Q4tVf+axO/1bH7IcTKM+g5hm6OordTRcrpd2pxNOXJ3BV3VIXaqVFqcz
         ReDWHrU8Hhus6oPeVg8JYnBVJvL41XVMHMBmWPjysH1448B/jACEDzFNSmrDxmOOxY
         gefrqtkxnsyHxgiiqd1gq1R/3B49UUaqsKUCDcfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu-Hsuan Hsu <yuhsuan@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/219] ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint
Date:   Sun, 29 Dec 2019 18:19:15 +0100
Message-Id: <20191229162531.671600386@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu-Hsuan Hsu <yuhsuan@chromium.org>

[ Upstream commit e2db787bdcb4f2722ecf410168f0583764634e45 ]

On KBL platform, the microphone is attached to external codec(rt5514)
instead of PCH. However, TDM slot between PCH and codec is 16 bits only.
In order to avoid setting wrong format, we should add a constraint to
force to use 16 bits format forever.

Signed-off-by: Yu-Hsuan Hsu <yuhsuan@chromium.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190923162940.199580-1-yuhsuan@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index b8a03f58ac8c..f36e33a14728 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -423,6 +423,9 @@ static int kabylake_dmic_startup(struct snd_pcm_substream *substream)
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 			dmic_constraints);
 
+	runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
+	snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
+
 	return snd_pcm_hw_constraint_list(substream->runtime, 0,
 			SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
 }
-- 
2.20.1



