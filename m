Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3A259D758
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbiHWJZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346369AbiHWJYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53EF9019A;
        Tue, 23 Aug 2022 01:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5A6B81C1B;
        Tue, 23 Aug 2022 08:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D5C433D7;
        Tue, 23 Aug 2022 08:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243678;
        bh=BWjidRQ+edWUR4aH7drez7StIMEyzcJyA/RtL4QAKXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaeCGs2OXk/8avndwVV/HgzjRsy1ZuS4sp3oWw8bQBBNjO847CQDfE1ExPGoYj5k0
         GaGu25whOtxyL2q4VdnEjLUSskvrzoNcbnwcMl0N3HSSU797xQkqFtotgsP4QD7/Jt
         XldaoiSGob7OUIYGMdkOzlqC8JK0z9RDpcZ13ydg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com,
        syzbot+669c9abf11a6a011dd09@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 353/365] ALSA: pcm: Use deferred fasync helper
Date:   Tue, 23 Aug 2022 10:04:14 +0200
Message-Id: <20220823080133.039157499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 96b097091c66df4f6fbf5cbff21df6cc02a2f055 ]

For avoiding the potential deadlock via kill_fasync() call, use the
new fasync helpers to defer the invocation from timer API.  Note that
it's merely a workaround.

Reported-by: syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com
Reported-by: syzbot+669c9abf11a6a011dd09@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220728125945.29533-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/pcm.h     | 2 +-
 sound/core/pcm.c        | 1 +
 sound/core/pcm_lib.c    | 2 +-
 sound/core/pcm_native.c | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 6b99310b5b88..6987110843f0 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -399,7 +399,7 @@ struct snd_pcm_runtime {
 	snd_pcm_uframes_t twake; 	/* do transfer (!poll) wakeup if non-zero */
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	bool stop_operating;		/* sync_stop will be called */
 	struct mutex buffer_mutex;	/* protect for buffer changes */
 	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 977d54320a5c..c917ac84a7e5 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1005,6 +1005,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 		substream->runtime = NULL;
 	}
 	mutex_destroy(&runtime->buffer_mutex);
+	snd_fasync_free(runtime->fasync);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 1fc7c50ffa62..40751e5aff09 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1822,7 +1822,7 @@ void snd_pcm_period_elapsed_under_stream_lock(struct snd_pcm_substream *substrea
 		snd_timer_interrupt(substream->timer, 1);
 #endif
  _end:
-	kill_fasync(&runtime->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(runtime->fasync, SIGIO, POLL_IN);
 }
 EXPORT_SYMBOL(snd_pcm_period_elapsed_under_stream_lock);
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 4adaee62ef33..16fcf57c6f03 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3945,7 +3945,7 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	runtime = substream->runtime;
 	if (runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
-	return fasync_helper(fd, file, on, &runtime->fasync);
+	return snd_fasync_helper(fd, file, on, &runtime->fasync);
 }
 
 /*
-- 
2.35.1



