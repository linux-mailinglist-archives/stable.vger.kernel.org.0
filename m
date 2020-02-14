Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0315EC75
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391013AbgBNR1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390902AbgBNQIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304F82067D;
        Fri, 14 Feb 2020 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696498;
        bh=cBFPbr8CVvdMgTjBagQOmxmbeGJeF3llcrP0PGr67TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsgzfMGXdhlu7y3udEwlJpOfbWdeo9Mm/nDyPDl1x1sIn7Q6TA45r+nRiHBG3PkRN
         QrxEWtLGf5V2wG/tVebtb5CShYrnxJGiiG5Odxs8H+h8nO0SfDB2g+W4Jm/cCiCrVI
         +hpGo6kGYUrnbHUjXE5Ee6IaadAjHx8Ip9XCvSd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 303/459] ASoC: SOF: Intel: hda-dai: fix compilation warning in pcm_prepare
Date:   Fri, 14 Feb 2020 10:59:13 -0500
Message-Id: <20200214160149.11681-303-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d873997192ddcacb5333575502be2f91ea4b47b8 ]

Fix GCC warning with W=1, previous cleanup did not remove unnecessary
variable.

sound/soc/sof/intel/hda-dai.c: In function ‘hda_link_pcm_prepare’:

sound/soc/sof/intel/hda-dai.c:265:31: warning: variable ‘hda_stream’
set but not used [-Wunused-but-set-variable]
  265 |  struct sof_intel_hda_stream *hda_stream;
      |                               ^~~~~~~~~~

Fixes: a3ebccb52efdf ("ASoC: SOF: Intel: hda: reset link DMA state in prepare")
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200113205620.27285-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 896d21984b735..1923b0c36bcef 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -261,14 +261,11 @@ static int hda_link_pcm_prepare(struct snd_pcm_substream *substream,
 {
 	struct hdac_ext_stream *link_dev =
 				snd_soc_dai_get_dma_data(dai, substream);
-	struct sof_intel_hda_stream *hda_stream;
 	struct snd_sof_dev *sdev =
 				snd_soc_component_get_drvdata(dai->component);
 	struct snd_soc_pcm_runtime *rtd = snd_pcm_substream_chip(substream);
 	int stream = substream->stream;
 
-	hda_stream = hstream_to_sof_hda_stream(link_dev);
-
 	if (link_dev->link_prepared)
 		return 0;
 
-- 
2.20.1

