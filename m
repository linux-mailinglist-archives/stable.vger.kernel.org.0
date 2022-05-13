Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF132526413
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355794AbiEMO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380905AbiEMO0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCB75047F;
        Fri, 13 May 2022 07:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7B3B83073;
        Fri, 13 May 2022 14:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0629BC3411A;
        Fri, 13 May 2022 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451941;
        bh=WzIyzFtI25DndcCvGpFXa3XiBHPDlBGo/cqwsDQExEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok7X5iTaIxgz3qhjgLk2dgMVuUAyRmshlVDBeTx0XtQ08aPiodMQ7N/74v9XKZLLv
         GwFitiX0giYc5wIoopRK/Ne1SwWMDS7SH+48UOqL6Ojaz3G6JYFJScNJP3KGfMjipR
         Ys/nzeENTnAzcvXspsx5XaCPZMHBQgPJlsy6Wn9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 12/15] ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
Date:   Fri, 13 May 2022 16:23:34 +0200
Message-Id: <20220513142228.260134097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
References: <20220513142227.897535454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit bc55cfd5718c7c23e5524582e9fa70b4d10f2433 upstream.

syzbot caught a potential deadlock between the PCM
runtime->buffer_mutex and the mm->mmap_lock.  It was brought by the
recent fix to cover the racy read/write and other ioctls, and in that
commit, I overlooked a (hopefully only) corner case that may take the
revert lock, namely, the OSS mmap.  The OSS mmap operation
exceptionally allows to re-configure the parameters inside the OSS
mmap syscall, where mm->mmap_mutex is already held.  Meanwhile, the
copy_from/to_user calls at read/write operations also take the
mm->mmap_lock internally, hence it may lead to a AB/BA deadlock.

A similar problem was already seen in the past and we fixed it with a
refcount (in commit b248371628aa).  The former fix covered only the
call paths with OSS read/write and OSS ioctls, while we need to cover
the concurrent access via both ALSA and OSS APIs now.

This patch addresses the problem above by replacing the buffer_mutex
lock in the read/write operations with a refcount similar as we've
used for OSS.  The new field, runtime->buffer_accessing, keeps the
number of concurrent read/write operations.  Unlike the former
buffer_mutex protection, this protects only around the
copy_from/to_user() calls; the other codes are basically protected by
the PCM stream lock.  The refcount can be a negative, meaning blocked
by the ioctls.  If a negative value is seen, the read/write aborts
with -EBUSY.  In the ioctl side, OTOH, they check this refcount, too,
and set to a negative value for blocking unless it's already being
accessed.

Reported-by: syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com
Fixes: dca947d4d26d ("ALSA: pcm: Fix races among concurrent read/write and buffer changes")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000381a0d05db622a81@google.com
Link: https://lore.kernel.org/r/20220330120903.4738-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/pcm.h     |    1 +
 sound/core/pcm.c        |    1 +
 sound/core/pcm_lib.c    |    9 +++++----
 sound/core/pcm_native.c |   39 ++++++++++++++++++++++++++++++++-------
 4 files changed, 39 insertions(+), 11 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -405,6 +405,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1032,6 +1032,7 @@ int snd_pcm_attach_substream(struct snd_
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
 	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1876,11 +1876,9 @@ static int wait_for_avail(struct snd_pcm
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
-		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
-		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2174,7 +2172,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
-	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2224,10 +2221,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 			snd_pcm_stream_unlock_irq(substream);
 			return -EINVAL;
 		}
+		if (!atomic_inc_unless_negative(&runtime->buffer_accessing)) {
+			err = -EBUSY;
+			goto _end_unlock;
+		}
 		snd_pcm_stream_unlock_irq(substream);
 		err = writer(substream, appl_ofs, data, offset, frames,
 			     transfer);
 		snd_pcm_stream_lock_irq(substream);
+		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
 		err = pcm_accessible_state(runtime);
@@ -2257,7 +2259,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
-	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -666,6 +666,24 @@ static int snd_pcm_hw_params_choose(stru
 	return 0;
 }
 
+/* acquire buffer_mutex; if it's in r/w operation, return -EBUSY, otherwise
+ * block the further r/w operations
+ */
+static int snd_pcm_buffer_access_lock(struct snd_pcm_runtime *runtime)
+{
+	if (!atomic_dec_unless_positive(&runtime->buffer_accessing))
+		return -EBUSY;
+	mutex_lock(&runtime->buffer_mutex);
+	return 0; /* keep buffer_mutex, unlocked by below */
+}
+
+/* release buffer_mutex and clear r/w access flag */
+static void snd_pcm_buffer_access_unlock(struct snd_pcm_runtime *runtime)
+{
+	mutex_unlock(&runtime->buffer_mutex);
+	atomic_inc(&runtime->buffer_accessing);
+}
+
 #if IS_ENABLED(CONFIG_SND_PCM_OSS)
 #define is_oss_stream(substream)	((substream)->oss.oss)
 #else
@@ -676,14 +694,16 @@ static int snd_pcm_hw_params(struct snd_
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err = 0, usecs;
+	int err, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	err = snd_pcm_buffer_access_lock(runtime);
+	if (err < 0)
+		return err;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
@@ -788,7 +808,7 @@ static int snd_pcm_hw_params(struct snd_
 			substream->ops->hw_free(substream);
 	}
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -821,7 +841,9 @@ static int snd_pcm_hw_free(struct snd_pc
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	result = snd_pcm_buffer_access_lock(runtime);
+	if (result < 0)
+		return result;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
@@ -841,7 +863,7 @@ static int snd_pcm_hw_free(struct snd_pc
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1208,12 +1230,15 @@ static int snd_pcm_action_nonatomic(cons
 	int res;
 
 	down_read(&snd_pcm_link_rwsem);
-	mutex_lock(&substream->runtime->buffer_mutex);
+	res = snd_pcm_buffer_access_lock(substream->runtime);
+	if (res < 0)
+		goto unlock;
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
-	mutex_unlock(&substream->runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(substream->runtime);
+ unlock:
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }


