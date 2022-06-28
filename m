Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3643955CED4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244436AbiF1C0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243613AbiF1CYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:24:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E51324966;
        Mon, 27 Jun 2022 19:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE232B81C00;
        Tue, 28 Jun 2022 02:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121C2C34115;
        Tue, 28 Jun 2022 02:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382996;
        bh=tWZ9EunSuGCCxl4UhxUmXpJelRVkeuq3GF+P6mU2hRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grVnVqMTu6z/6XrdVupCZSpULLlqbIwEgpQnblRPa7KkecN7g/PEjsy82j+ot5a70
         5aKUTG90bTZzVq6F96S56Vrekx1yZWZGPZvFWeBUJWmwbRIsmQPVuCh+rP0QaoUDjM
         hVYjh5HkbJzfKFBYEZmQde7aEr2CRDXr3UvOEMnuLujk8fPFYsUn/dJpQh/DNFZULk
         /qmEmxq+yxpapFV4KvCiZUheKdiFZLWDrITqqlHtna00q7GgGUelrzHbDAYNEX0zYE
         WWjSzzRb0LHSdcpnNsutdwlEuJfOd8W3LuYhxLJHbwFV3cfUjPFdk7MfkS824Q6VHZ
         UX4DKw4W7r+0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, nizhen@uniontech.com,
        gushengxian@yulong.com, jiasheng@iscas.ac.cn,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 12/34] ALSA: x86: intel_hdmi_audio: use pm_runtime_resume_and_get()
Date:   Mon, 27 Jun 2022 22:22:19 -0400
Message-Id: <20220628022241.595835-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bb30b453fedac277d66220431fd7063d9ddc10d8 ]

The current code does not check for errors and does not release the
reference on errors.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220616222910.136854-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 2c150bce30bb..bb0a03e14fed 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1067,7 +1067,9 @@ static int had_pcm_open(struct snd_pcm_substream *substream)
 	intelhaddata = snd_pcm_substream_chip(substream);
 	runtime = substream->runtime;
 
-	pm_runtime_get_sync(intelhaddata->dev);
+	retval = pm_runtime_resume_and_get(intelhaddata->dev);
+	if (retval < 0)
+		return retval;
 
 	/* set the runtime hw parameter with local snd_pcm_hardware struct */
 	runtime->hw = had_pcm_hardware;
@@ -1564,8 +1566,12 @@ static void had_audio_wq(struct work_struct *work)
 		container_of(work, struct snd_intelhad, hdmi_audio_wq);
 	struct intel_hdmi_lpe_audio_pdata *pdata = ctx->dev->platform_data;
 	struct intel_hdmi_lpe_audio_port_pdata *ppdata = &pdata->port[ctx->port];
+	int ret;
+
+	ret = pm_runtime_resume_and_get(ctx->dev);
+	if (ret < 0)
+		return;
 
-	pm_runtime_get_sync(ctx->dev);
 	mutex_lock(&ctx->mutex);
 	if (ppdata->pipe < 0) {
 		dev_dbg(ctx->dev, "%s: Event: HAD_NOTIFY_HOT_UNPLUG : port = %d\n",
-- 
2.35.1

