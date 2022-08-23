Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAA459E00A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353231AbiHWKNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353290AbiHWKLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C3C7EFC7;
        Tue, 23 Aug 2022 01:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020376150F;
        Tue, 23 Aug 2022 08:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86F7C433D7;
        Tue, 23 Aug 2022 08:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244984;
        bh=4yS/bWF1VfDmwPHBya2eTtx13bO3K83w8kHuwOh/Kz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpDfJHGI87b7oNLR7eN1Y3y749/p0DgsUdFF8SUzaUNiRkP9aR5K+8t1oNaRPiHLP
         pw6tWpjFgGfQRBs7/9ReIRbDJ84gsgOHlaFzN577Pdc0pNYfLq2pUxEpvXHCx+dYY3
         STbvVZjI/W3RV1ZbqPFEqXfC/9kMqjxF0ikoI8AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1ee0910eca9c94f71f25@syzkaller.appspotmail.com,
        syzbot+49b10793b867871ee26f@syzkaller.appspotmail.com,
        syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 225/229] ALSA: timer: Use deferred fasync helper
Date:   Tue, 23 Aug 2022 10:26:26 +0200
Message-Id: <20220823080101.675000241@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index c333ceb80d5f..720d63574bfb 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -75,7 +75,7 @@ struct snd_timer_user {
 	unsigned int filter;
 	struct timespec tstamp;		/* trigger tstamp */
 	wait_queue_head_t qchange_sleep;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	struct mutex ioctl_lock;
 };
 
@@ -1295,7 +1295,7 @@ static void snd_timer_user_interrupt(struct snd_timer_instance *timeri,
 	}
       __wake:
 	spin_unlock(&tu->qlock);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1332,7 +1332,7 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 	spin_lock_irqsave(&tu->qlock, flags);
 	snd_timer_user_append_to_tqueue(tu, &r1);
 	spin_unlock_irqrestore(&tu->qlock, flags);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1399,7 +1399,7 @@ static void snd_timer_user_tinterrupt(struct snd_timer_instance *timeri,
 	spin_unlock(&tu->qlock);
 	if (append == 0)
 		return;
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1465,6 +1465,7 @@ static int snd_timer_user_release(struct inode *inode, struct file *file)
 		if (tu->timeri)
 			snd_timer_close(tu->timeri);
 		mutex_unlock(&tu->ioctl_lock);
+		snd_fasync_free(tu->fasync);
 		kfree(tu->queue);
 		kfree(tu->tqueue);
 		kfree(tu);
@@ -2017,7 +2018,7 @@ static int snd_timer_user_fasync(int fd, struct file * file, int on)
 	struct snd_timer_user *tu;
 
 	tu = file->private_data;
-	return fasync_helper(fd, file, on, &tu->fasync);
+	return snd_fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
-- 
2.35.1



