Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB426A36BE
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjB0CEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjB0CEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:04:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499F614487;
        Sun, 26 Feb 2023 18:03:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30FEF60C4B;
        Mon, 27 Feb 2023 02:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BF5C4339B;
        Mon, 27 Feb 2023 02:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463377;
        bh=MlICvfNlkt/04BgB922RhkwmhiqwArFoMZV1CyQ2w1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNAQ+0KaiVPQyod+w7wcl61ShCFZ/FiCQUYEBw1HDmXQAap+rJZbY5xUuJsDfrzu/
         WwoQpzVkMJJMaV+SN5iUAUEmZpqzRVOU/XhQ25i5BsOjzZcbvYKE2FZNBQ5u/YoXhb
         qqUq0blkOi8ZhMF7EdR40OtFx1HsCVYFS3cvPE+xtbWgJdvIyNfel6CAe1kyhY64dC
         a7kBvBAr8WYCeZt1UUnwY0IprZNPoaWf8WHSr9PwsXM9nlBKjtsWt1gmQdyBZrSt7O
         HBNeTk1l22bd0N4T5nX7MyuhGO1Unf/uKTkoutmKlM3djMR9cFoJN7qOzlhlHwrC05
         48VQdnSJ6xttA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=EA=B0=95=EC=8B=A0=ED=98=95?= <s47.kang@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vkoul@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 34/60] ASoC: soc-compress: Reposition and add pcm_mutex
Date:   Sun, 26 Feb 2023 21:00:19 -0500
Message-Id: <20230227020045.1045105-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 강신형 <s47.kang@samsung.com>

[ Upstream commit aa9ff6a4955fdba02b54fbc4386db876603703b7 ]

If panic_on_warn is set and compress stream(DPCM) is started,
then kernel panic occurred because card->pcm_mutex isn't held appropriately.
In the following functions, warning were issued at this line
"snd_soc_dpcm_mutex_assert_held".

static int dpcm_be_connect(struct snd_soc_pcm_runtime *fe,
		struct snd_soc_pcm_runtime *be, int stream)
{
	...
	snd_soc_dpcm_mutex_assert_held(fe);
	...
}

void dpcm_be_disconnect(struct snd_soc_pcm_runtime *fe, int stream)
{
	...
	snd_soc_dpcm_mutex_assert_held(fe);
	...
}

void snd_soc_runtime_action(struct snd_soc_pcm_runtime *rtd,
			    int stream, int action)
{
	...
	snd_soc_dpcm_mutex_assert_held(rtd);
	...
}

int dpcm_dapm_stream_event(struct snd_soc_pcm_runtime *fe, int dir,
	int event)
{
	...
	snd_soc_dpcm_mutex_assert_held(fe);
	...
}

These functions are called by soc_compr_set_params_fe, soc_compr_open_fe
and soc_compr_free_fe
without pcm_mutex locking. And this is call stack.

[  414.527841][ T2179] pc : dpcm_process_paths+0x5a4/0x750
[  414.527848][ T2179] lr : dpcm_process_paths+0x37c/0x750
[  414.527945][ T2179] Call trace:
[  414.527949][ T2179]  dpcm_process_paths+0x5a4/0x750
[  414.527955][ T2179]  soc_compr_open_fe+0xb0/0x2cc
[  414.527972][ T2179]  snd_compr_open+0x180/0x248
[  414.527981][ T2179]  snd_open+0x15c/0x194
[  414.528003][ T2179]  chrdev_open+0x1b0/0x220
[  414.528023][ T2179]  do_dentry_open+0x30c/0x594
[  414.528045][ T2179]  vfs_open+0x34/0x44
[  414.528053][ T2179]  path_openat+0x914/0xb08
[  414.528062][ T2179]  do_filp_open+0xc0/0x170
[  414.528068][ T2179]  do_sys_openat2+0x94/0x18c
[  414.528076][ T2179]  __arm64_sys_openat+0x78/0xa4
[  414.528084][ T2179]  invoke_syscall+0x48/0x10c
[  414.528094][ T2179]  el0_svc_common+0xbc/0x104
[  414.528099][ T2179]  do_el0_svc+0x34/0xd8
[  414.528103][ T2179]  el0_svc+0x34/0xc4
[  414.528125][ T2179]  el0t_64_sync_handler+0x8c/0xfc
[  414.528133][ T2179]  el0t_64_sync+0x1a0/0x1a4
[  414.528142][ T2179] Kernel panic - not syncing: panic_on_warn set ...

So, I reposition and add pcm_mutex to resolve lockdep error.

Signed-off-by: Shinhyung Kang <s47.kang@samsung.com>
Link: https://lore.kernel.org/r/016401d90ac4$7b6848c0$7238da40$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 870f13e1d389c..7bce5088b4554 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -149,6 +149,8 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	if (ret < 0)
 		goto be_err;
 
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
+
 	/* calculate valid and active FE <-> BE dpcms */
 	dpcm_process_paths(fe, stream, &list, 1);
 	fe->dpcm[stream].runtime = fe_substream->runtime;
@@ -184,7 +186,6 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_OPEN;
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
 
-	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_activate(fe, stream);
 	mutex_unlock(&fe->card->pcm_mutex);
 
@@ -215,7 +216,6 @@ static int soc_compr_free_fe(struct snd_compr_stream *cstream)
 
 	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_deactivate(fe, stream);
-	mutex_unlock(&fe->card->pcm_mutex);
 
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
 
@@ -234,6 +234,8 @@ static int soc_compr_free_fe(struct snd_compr_stream *cstream)
 
 	dpcm_be_disconnect(fe, stream);
 
+	mutex_unlock(&fe->card->pcm_mutex);
+
 	fe->dpcm[stream].runtime = NULL;
 
 	snd_soc_link_compr_shutdown(cstream, 0);
@@ -409,8 +411,9 @@ static int soc_compr_set_params_fe(struct snd_compr_stream *cstream,
 	ret = snd_soc_link_compr_set_params(cstream);
 	if (ret < 0)
 		goto out;
-
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	dpcm_dapm_stream_event(fe, stream, SND_SOC_DAPM_STREAM_START);
+	mutex_unlock(&fe->card->pcm_mutex);
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_PREPARE;
 
 out:
-- 
2.39.0

