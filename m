Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90659D96E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348361AbiHWJ0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349772AbiHWJY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F7E90194;
        Tue, 23 Aug 2022 01:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 407F761485;
        Tue, 23 Aug 2022 08:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A09DC433D6;
        Tue, 23 Aug 2022 08:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243675;
        bh=dJICxAXUVqoAvRcs1iEYL7jr+zKhXIpbPrZJ96/wyv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwMCqWcDGnd0eZTKPyV9YfSF0n2lJFSrYWLHsEaXxnPd3Qb1AvXBCrtuKxticN6q2
         ncj/pEFzIz5X9DTzRfEgi/4CveheUZDUmjo10FTPwDt++F5+IHWzqwliqqAklNOZXN
         xI/FH89eGyR3vJEFHbZP3Scsn92/1/VflLqecLTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1ee0910eca9c94f71f25@syzkaller.appspotmail.com,
        syzbot+49b10793b867871ee26f@syzkaller.appspotmail.com,
        syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 352/365] ALSA: timer: Use deferred fasync helper
Date:   Tue, 23 Aug 2022 10:04:13 +0200
Message-Id: <20220823080132.998740514@linuxfoundation.org>
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
index b3214baa8919..e08a37c23add 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -83,7 +83,7 @@ struct snd_timer_user {
 	unsigned int filter;
 	struct timespec64 tstamp;		/* trigger tstamp */
 	wait_queue_head_t qchange_sleep;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	struct mutex ioctl_lock;
 };
 
@@ -1345,7 +1345,7 @@ static void snd_timer_user_interrupt(struct snd_timer_instance *timeri,
 	}
       __wake:
 	spin_unlock(&tu->qlock);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1383,7 +1383,7 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 	spin_lock_irqsave(&tu->qlock, flags);
 	snd_timer_user_append_to_tqueue(tu, &r1);
 	spin_unlock_irqrestore(&tu->qlock, flags);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1453,7 +1453,7 @@ static void snd_timer_user_tinterrupt(struct snd_timer_instance *timeri,
 	spin_unlock(&tu->qlock);
 	if (append == 0)
 		return;
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1521,6 +1521,7 @@ static int snd_timer_user_release(struct inode *inode, struct file *file)
 			snd_timer_instance_free(tu->timeri);
 		}
 		mutex_unlock(&tu->ioctl_lock);
+		snd_fasync_free(tu->fasync);
 		kfree(tu->queue);
 		kfree(tu->tqueue);
 		kfree(tu);
@@ -2135,7 +2136,7 @@ static int snd_timer_user_fasync(int fd, struct file * file, int on)
 	struct snd_timer_user *tu;
 
 	tu = file->private_data;
-	return fasync_helper(fd, file, on, &tu->fasync);
+	return snd_fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
-- 
2.35.1



