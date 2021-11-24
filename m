Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B21645B9E6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhKXMGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242166AbhKXMF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 672326101D;
        Wed, 24 Nov 2021 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755338;
        bh=O/9X8AXq6dYfPZyhzrphCNB0AqXBsPO37+i0IrdeJCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PKZuzTJFQsWQ2vYKAXK69NjrS6VPltrlHbdsir54F9Uij9oHHaQ/eqtzLjJruMdO
         UUfFDnunipzVqmOPi00k2x7JinV4Uh33N5oUljtoJU0/KiacXkND519Z29uwQ14mzf
         RsOkp0etVBSj7JankK6YHrWX3fp+Vskrib6Ocizg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 016/162] ALSA: timer: Unconditionally unlink slave instances, too
Date:   Wed, 24 Nov 2021 12:55:19 +0100
Message-Id: <20211124115658.852148858@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ffdd98277f0a1d15a67a74ae09bee713df4c0dbc upstream.

Like the previous fix (commit c0317c0e8709 "ALSA: timer: Fix
use-after-free problem"), we have to unlink slave timer instances
immediately at snd_timer_stop(), too.  Otherwise it may leave a stale
entry in the list if the slave instance is freed before actually
running.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211105091517.21733-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -566,23 +566,22 @@ static int snd_timer_stop1(struct snd_ti
 static int snd_timer_stop_slave(struct snd_timer_instance *timeri, bool stop)
 {
 	unsigned long flags;
+	bool running;
 
 	spin_lock_irqsave(&slave_active_lock, flags);
-	if (!(timeri->flags & SNDRV_TIMER_IFLG_RUNNING)) {
-		spin_unlock_irqrestore(&slave_active_lock, flags);
-		return -EBUSY;
-	}
+	running = timeri->flags & SNDRV_TIMER_IFLG_RUNNING;
 	timeri->flags &= ~SNDRV_TIMER_IFLG_RUNNING;
 	if (timeri->timer) {
 		spin_lock(&timeri->timer->lock);
 		list_del_init(&timeri->ack_list);
 		list_del_init(&timeri->active_list);
-		snd_timer_notify1(timeri, stop ? SNDRV_TIMER_EVENT_STOP :
-				  SNDRV_TIMER_EVENT_PAUSE);
+		if (running)
+			snd_timer_notify1(timeri, stop ? SNDRV_TIMER_EVENT_STOP :
+					  SNDRV_TIMER_EVENT_PAUSE);
 		spin_unlock(&timeri->timer->lock);
 	}
 	spin_unlock_irqrestore(&slave_active_lock, flags);
-	return 0;
+	return running ? 0 : -EBUSY;
 }
 
 /*


