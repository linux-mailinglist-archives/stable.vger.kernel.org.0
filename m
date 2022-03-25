Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816764E773D
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352759AbiCYP1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377665AbiCYPY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61405E8875;
        Fri, 25 Mar 2022 08:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF3D3B8288D;
        Fri, 25 Mar 2022 15:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54626C340E9;
        Fri, 25 Mar 2022 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221509;
        bh=mR0fqcBHkWZxA5PrGoLCSHcJqMHSyq6GZQ8gGobw534=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAY/V8RhrSueMaeOx8hzxD4y4FZpwADz7YziXK8DJ+elXf49HfxtDuc5eDqCRbo5E
         NvusHm9UFAcUahWDoWHIZ90xnJM9sN13n2CDv2CoRovUQKFNolxbquBofPqx1E5WKW
         N0r289shgtstN3//X97neo9UlPfEPlBNhZcldy80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Jiahui <kirin.say@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 11/39] ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
Date:   Fri, 25 Mar 2022 16:14:26 +0100
Message-Id: <20220325150420.568275837@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 92ee3c60ec9fe64404dc035e7c41277d74aa26cb upstream.

Currently we have neither proper check nor protection against the
concurrent calls of PCM hw_params and hw_free ioctls, which may result
in a UAF.  Since the existing PCM stream lock can't be used for
protecting the whole ioctl operations, we need a new mutex to protect
those racy calls.

This patch introduced a new mutex, runtime->buffer_mutex, and applies
it to both hw_params and hw_free ioctl code paths.  Along with it, the
both functions are slightly modified (the mmap_count check is moved
into the state-check block) for code simplicity.

Reported-by: Hu Jiahui <kirin.say@gmail.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/pcm.h     |    1 
 sound/core/pcm.c        |    2 +
 sound/core/pcm_native.c |   61 ++++++++++++++++++++++++++++++------------------
 3 files changed, 42 insertions(+), 22 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -401,6 +401,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	bool stop_operating;		/* sync_stop will be called */
+	struct mutex buffer_mutex;	/* protect for buffer changes */
 
 	/* -- private section -- */
 	void *private_data;
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -969,6 +969,7 @@ int snd_pcm_attach_substream(struct snd_
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1002,6 +1003,7 @@ void snd_pcm_detach_substream(struct snd
 	} else {
 		substream->runtime = NULL;
 	}
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -685,33 +685,40 @@ static int snd_pcm_hw_params_choose(stru
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err = 0, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	snd_pcm_sync_stop(substream, true);
 
@@ -799,16 +806,21 @@ static int snd_pcm_hw_params(struct snd_
 	if (usecs >= 0)
 		cpu_latency_qos_add_request(&substream->latency_pm_qos_req,
 					    usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
-	if (substream->managed_buffer_alloc)
-		snd_pcm_lib_free_pages(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+		if (substream->managed_buffer_alloc)
+			snd_pcm_lib_free_pages(substream);
+	}
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return err;
 }
 
@@ -848,26 +860,31 @@ static int do_hw_free(struct snd_pcm_sub
 static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime;
-	int result;
+	int result = 0;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	result = do_hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return result;
 }
 


