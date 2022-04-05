Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D424F339F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbiDEKhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiDEJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BC47484B;
        Tue,  5 Apr 2022 02:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10323CE1C73;
        Tue,  5 Apr 2022 09:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF8CC385A2;
        Tue,  5 Apr 2022 09:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150566;
        bh=wIXbSc5HBKjTS6Guk8ShP/tnI1ddWwUDYHDXGwN+0sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/D8L9WhSCRZToH3vjrJBev8ZIppH0xS7B6NDCy1Tqzz22Q4inMwq9nsTC5KhsxiX
         GEWeZ0kOpI3XaNMfOy8f5jb+LbucCB7ANOrM3pc0WzazbfE8QuheDgjiJGqEZxeic5
         rmAIySUjzENFgURpj0qCt5l5IXX+YbHGhu5ePVSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 101/913] ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
Date:   Tue,  5 Apr 2022 09:19:23 +0200
Message-Id: <20220405070342.855446718@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/pcm.h     |    1 +
 sound/core/pcm.c        |    1 +
 sound/core/pcm_lib.c    |    9 +++++----
 sound/core/pcm_native.c |   39 ++++++++++++++++++++++++++++++++-------
 4 files changed, 39 insertions(+), 11 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -399,6 +399,7 @@ struct snd_pcm_runtime {
 	struct fasync_struct *fasync;
 	bool stop_operating;		/* sync_stop will be called */
 	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -970,6 +970,7 @@ int snd_pcm_attach_substream(struct snd_
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
 	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1905,11 +1905,9 @@ static int wait_for_avail(struct snd_pcm
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
-		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
-		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2203,7 +2201,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
-	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2258,10 +2255,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 			err = -EINVAL;
 			goto _end_unlock;
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
@@ -2291,7 +2293,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
-	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -672,6 +672,24 @@ static int snd_pcm_hw_params_choose(stru
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
@@ -682,14 +700,16 @@ static int snd_pcm_hw_params(struct snd_
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
@@ -807,7 +827,7 @@ static int snd_pcm_hw_params(struct snd_
 			snd_pcm_lib_free_pages(substream);
 	}
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -852,7 +872,9 @@ static int snd_pcm_hw_free(struct snd_pc
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
@@ -871,7 +893,7 @@ static int snd_pcm_hw_free(struct snd_pc
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	cpu_latency_qos_remove_request(&substream->latency_pm_qos_req);
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1356,12 +1378,15 @@ static int snd_pcm_action_nonatomic(cons
 
 	/* Guarantee the group members won't change during non-atomic action */
 	down_read(&snd_pcm_link_rwsem);
-	mutex_lock(&substream->runtime->buffer_mutex);
+	res = snd_pcm_buffer_access_lock(substream->runtime);
+	if (res < 0)
+		goto unlock;
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, false);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
-	mutex_unlock(&substream->runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(substream->runtime);
+ unlock:
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }


