Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7621D490D2E
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbiAQRBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:01:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48360 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbiAQRAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC91B81136;
        Mon, 17 Jan 2022 17:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FA8C36AE7;
        Mon, 17 Jan 2022 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438831;
        bh=L5fMBsQ4GFTUWDax+L1PtBdZ0vB16WfrrFYjYR1GER4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7jI1Ia6bczbyFVopt/bG+gLCDOU+MocDsP74/x54DeZwWES3hD2XVk4Zc8wfeYUc
         sUYzq2upNamnlcSTuvba+oWp6HzEzForKtpulxYS9nernkl4200NQUbkBclnQJhY0J
         9FXhNsbURzU7rgijV6C482VpV0TWTyVUuZWGS/TzC7L0tNDtnq6ywQFoGOXbL1qCzM
         ni3nnwmkoTGSk+2hOcodcsgBDR8RWKElq6n+F36RWRqFEBCOH6inu+IrSPb7z7B2bd
         cUcjjopr+KXpvxBBz6c1GT5xQN0VKLTnuQiEyRAa3jnxiElpDC1HJCLmsYhAQe/IsO
         Q6LIAihaG/tUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        kai.vehmanen@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 38/52] ASoC: SOF: ipc: Add null pointer check for substream->runtime
Date:   Mon, 17 Jan 2022 11:58:39 -0500
Message-Id: <20220117165853.1470420-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>

[ Upstream commit 182b682b9ab1348e07ea1bf9d8f2505cc67f9237 ]

When pcm stream is stopped "substream->runtime" pointer will be set
to NULL by ALSA core. In case host received an ipc msg from firmware
of type IPC_STREAM_POSITION after pcm stream is stopped, there will
be kernel NULL pointer exception in ipc_period_elapsed(). This patch
fixes it by adding NULL pointer check for "substream->runtime".

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211216232422.345164-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index e6c53c6c470e4..ca30c506a0fd6 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -547,7 +547,8 @@ static void ipc_period_elapsed(struct snd_sof_dev *sdev, u32 msg_id)
 
 	if (spcm->pcm.compress)
 		snd_sof_compr_fragment_elapsed(stream->cstream);
-	else if (!stream->substream->runtime->no_period_wakeup)
+	else if (stream->substream->runtime &&
+		 !stream->substream->runtime->no_period_wakeup)
 		/* only inform ALSA for period_wakeup mode */
 		snd_sof_pcm_period_elapsed(stream->substream);
 }
-- 
2.34.1

