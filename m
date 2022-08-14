Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4659255D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbiHNQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243358AbiHNQkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0956B1E7;
        Sun, 14 Aug 2022 09:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F9C560FD3;
        Sun, 14 Aug 2022 16:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C979C433D6;
        Sun, 14 Aug 2022 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494663;
        bh=rlRyGuTULygd8M/Co4edd8lZ8zKBvxFllGezVHX8gSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dG2bBHPLH1ZBPyU/sLjegPHyJbwCSz5Lo3y/ioh/RYemoYjjyBygrr1jiNwhYQQte
         d9EFAFPxo92WfzQFHfzxkW1Wl4WUJdghatY0UD4U86VaVKYAveqmjmuZMexsh2qwWm
         okFSXgVuFqbpKu/ekth3j/oXWNXtc1pnivyAUGnr6NjXeZf9dZKMZ+B2Lz3QTnmz1S
         A5JfwQSwf8REMeg/kSFdyjhqCM97QcAbKyUMnsY+dr8m20pfqicV/TnJ4jXrveV80i
         KifmT2A7dWcnJBt8fKWC5D7JvPb+5ibaMpywIMevM7JIoZuDgwbKQgOKgI1emYSKUv
         4MoZmjTw5pXlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+1ee0910eca9c94f71f25@syzkaller.appspotmail.com,
        syzbot+49b10793b867871ee26f@syzkaller.appspotmail.com,
        syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, wangwensheng4@huawei.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 5/8] ALSA: timer: Use deferred fasync helper
Date:   Sun, 14 Aug 2022 12:30:38 -0400
Message-Id: <20220814163041.2399552-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814163041.2399552-1-sashal@kernel.org>
References: <20220814163041.2399552-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 95cc637c1afd83fb7dd3d7c8a53710488f4caf9c ]

For avoiding the potential deadlock via kill_fasync() call, use the
new fasync helpers to defer the invocation from PCI API.  Note that
it's merely a workaround.

Reported-by: syzbot+1ee0910eca9c94f71f25@syzkaller.appspotmail.com
Reported-by: syzbot+49b10793b867871ee26f@syzkaller.appspotmail.com
Reported-by: syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220728125945.29533-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 596ba572d6c4..1f5f05e76e59 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -74,7 +74,7 @@ struct snd_timer_user {
 	unsigned int filter;
 	struct timespec tstamp;		/* trigger tstamp */
 	wait_queue_head_t qchange_sleep;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	struct mutex ioctl_lock;
 };
 
@@ -1293,7 +1293,7 @@ static void snd_timer_user_interrupt(struct snd_timer_instance *timeri,
 	}
       __wake:
 	spin_unlock(&tu->qlock);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1330,7 +1330,7 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 	spin_lock_irqsave(&tu->qlock, flags);
 	snd_timer_user_append_to_tqueue(tu, &r1);
 	spin_unlock_irqrestore(&tu->qlock, flags);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1397,7 +1397,7 @@ static void snd_timer_user_tinterrupt(struct snd_timer_instance *timeri,
 	spin_unlock(&tu->qlock);
 	if (append == 0)
 		return;
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1439,6 +1439,7 @@ static int snd_timer_user_release(struct inode *inode, struct file *file)
 		if (tu->timeri)
 			snd_timer_close(tu->timeri);
 		mutex_unlock(&tu->ioctl_lock);
+		snd_fasync_free(tu->fasync);
 		kfree(tu->queue);
 		kfree(tu->tqueue);
 		kfree(tu);
@@ -2026,7 +2027,7 @@ static int snd_timer_user_fasync(int fd, struct file * file, int on)
 	struct snd_timer_user *tu;
 
 	tu = file->private_data;
-	return fasync_helper(fd, file, on, &tu->fasync);
+	return snd_fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
-- 
2.35.1

