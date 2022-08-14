Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154955924E9
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242458AbiHNQgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242990AbiHNQgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9520941D20;
        Sun, 14 Aug 2022 09:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41715B80B7C;
        Sun, 14 Aug 2022 16:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24579C433C1;
        Sun, 14 Aug 2022 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494495;
        bh=utwjySDW4EArzun52oLQorI+1cEBJiW/BBG0M5KHHJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjIhjDNQ940q9066u3sdC+Df3rO1t9Akq8CAlMCiGLkSvU6pLU4/HvOwVwtP7DdOa
         wnAi0rP3Z2nPQYzIq+pKQKaGPGTVzMnaQEfIY3RLFXulikj3kZqgIwDGQ1owbsN0SV
         9tUJu6nv3mLeKSC1a6amS7Z785iGU4moo6+OhWRVRJqhTHRgkIRHzl6n+E/ktBAOu9
         MbqnVibl4fvpXbv+W5Wi0cCiTgJAB091SqbSO/smvWZJQvLTE5eTXG1p0OhU4xnmnC
         msizMgSR1riRIrNN1Yal7dKakV9FFecAImWb8oWDzmPoxeHIz9ThXxZUo/SyuR1WMr
         hIhIy6aAgjhVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 13/19] ALSA: control: Use deferred fasync helper
Date:   Sun, 14 Aug 2022 12:27:32 -0400
Message-Id: <20220814162739.2398217-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162739.2398217-1-sashal@kernel.org>
References: <20220814162739.2398217-1-sashal@kernel.org>
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

[ Upstream commit 4a971e84a7ae10a38d875cd2d4e487c8d1682ca3 ]

For avoiding the potential deadlock via kill_fasync() call, use the
new fasync helpers to defer the invocation from the control API.  Note
that it's merely a workaround.

Another note: although we haven't received reports about the deadlock
with the control API, the deadlock is still potentially possible, and
it's better to align the behavior with other core APIs (PCM and
timer); so let's move altogether.

Link: https://lore.kernel.org/r/20220728125945.29533-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h | 2 +-
 sound/core/control.c    | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index 77d9fa10812d..41bd72ffd232 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -103,7 +103,7 @@ struct snd_ctl_file {
 	int preferred_subdevice[SND_CTL_SUBDEV_ITEMS];
 	wait_queue_head_t change_sleep;
 	spinlock_t read_lock;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	int subscribed;			/* read interface is activated */
 	struct list_head events;	/* waiting events for read */
 };
diff --git a/sound/core/control.c b/sound/core/control.c
index 3b44378b9dec..732eb515d2f5 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -121,6 +121,7 @@ static int snd_ctl_release(struct inode *inode, struct file *file)
 			if (control->vd[idx].owner == ctl)
 				control->vd[idx].owner = NULL;
 	up_write(&card->controls_rwsem);
+	snd_fasync_free(ctl->fasync);
 	snd_ctl_empty_read_queue(ctl);
 	put_pid(ctl->pid);
 	kfree(ctl);
@@ -175,7 +176,7 @@ void snd_ctl_notify(struct snd_card *card, unsigned int mask,
 	_found:
 		wake_up(&ctl->change_sleep);
 		spin_unlock(&ctl->read_lock);
-		kill_fasync(&ctl->fasync, SIGIO, POLL_IN);
+		snd_kill_fasync(ctl->fasync, SIGIO, POLL_IN);
 	}
 	read_unlock_irqrestore(&card->ctl_files_rwlock, flags);
 }
@@ -1941,7 +1942,7 @@ static int snd_ctl_fasync(int fd, struct file * file, int on)
 	struct snd_ctl_file *ctl;
 
 	ctl = file->private_data;
-	return fasync_helper(fd, file, on, &ctl->fasync);
+	return snd_fasync_helper(fd, file, on, &ctl->fasync);
 }
 
 /* return the preferred subdevice number if already assigned;
@@ -2015,7 +2016,7 @@ static int snd_ctl_dev_disconnect(struct snd_device *device)
 	read_lock_irqsave(&card->ctl_files_rwlock, flags);
 	list_for_each_entry(ctl, &card->ctl_files, list) {
 		wake_up(&ctl->change_sleep);
-		kill_fasync(&ctl->fasync, SIGIO, POLL_ERR);
+		snd_kill_fasync(ctl->fasync, SIGIO, POLL_ERR);
 	}
 	read_unlock_irqrestore(&card->ctl_files_rwlock, flags);
 
-- 
2.35.1

