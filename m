Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8203B171C6E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388762AbgB0OL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388553AbgB0OL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BAC20578;
        Thu, 27 Feb 2020 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812715;
        bh=z1j6aTnUEqkUTnFIiJsPY/xhbrZ5X1v0IBrmGglsaCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9R1g324OxM98yfapBqhG0laq6KKSqi4oNvZOHxqqU54XaQigwGkVLL4eoWHOpQp3
         Wsb02l6Aj8md8Pwc8qvjTiU/oukZ8iJxU2SClIuiNuKxY0g6gICRhkQp7I4nNEO9Sw
         ELhLHiXTGQdiQ2N8KUiGps0w67+m8qPrg12qr2E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fd5e0eaa1a32999173b2@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 124/135] ALSA: seq: Fix concurrent access to queue current tick/time
Date:   Thu, 27 Feb 2020 14:37:44 +0100
Message-Id: <20200227132247.710648244@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dc7497795e014d84699c3b8809ed6df35352dd74 upstream.

snd_seq_check_queue() passes the current tick and time of the given
queue as a pointer to snd_seq_prioq_cell_out(), but those might be
updated concurrently by the seq timer update.

Fix it by retrieving the current tick and time via the proper helper
functions at first, and pass those values to snd_seq_prioq_cell_out()
later in the loops.

snd_seq_timer_get_cur_time() takes a new argument and adjusts with the
current system time only when it's requested so; this update isn't
needed for snd_seq_check_queue(), as it's called either from the
interrupt handler or right after queuing.

Also, snd_seq_timer_get_cur_tick() is changed to read the value in the
spinlock for the concurrency, too.

Reported-by: syzbot+fd5e0eaa1a32999173b2@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200214111316.26939-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_clientmgr.c |    4 ++--
 sound/core/seq/seq_queue.c     |    9 ++++++---
 sound/core/seq/seq_timer.c     |   13 ++++++++++---
 sound/core/seq/seq_timer.h     |    3 ++-
 4 files changed, 20 insertions(+), 9 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -580,7 +580,7 @@ static int update_timestamp_of_queue(str
 	event->queue = queue;
 	event->flags &= ~SNDRV_SEQ_TIME_STAMP_MASK;
 	if (real_time) {
-		event->time.time = snd_seq_timer_get_cur_time(q->timer);
+		event->time.time = snd_seq_timer_get_cur_time(q->timer, true);
 		event->flags |= SNDRV_SEQ_TIME_STAMP_REAL;
 	} else {
 		event->time.tick = snd_seq_timer_get_cur_tick(q->timer);
@@ -1659,7 +1659,7 @@ static int snd_seq_ioctl_get_queue_statu
 	tmr = queue->timer;
 	status->events = queue->tickq->cells + queue->timeq->cells;
 
-	status->time = snd_seq_timer_get_cur_time(tmr);
+	status->time = snd_seq_timer_get_cur_time(tmr, true);
 	status->tick = snd_seq_timer_get_cur_tick(tmr);
 
 	status->running = tmr->running;
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -238,6 +238,8 @@ void snd_seq_check_queue(struct snd_seq_
 {
 	unsigned long flags;
 	struct snd_seq_event_cell *cell;
+	snd_seq_tick_time_t cur_tick;
+	snd_seq_real_time_t cur_time;
 
 	if (q == NULL)
 		return;
@@ -254,17 +256,18 @@ void snd_seq_check_queue(struct snd_seq_
 
       __again:
 	/* Process tick queue... */
+	cur_tick = snd_seq_timer_get_cur_tick(q->timer);
 	for (;;) {
-		cell = snd_seq_prioq_cell_out(q->tickq,
-					      &q->timer->tick.cur_tick);
+		cell = snd_seq_prioq_cell_out(q->tickq, &cur_tick);
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
 	}
 
 	/* Process time queue... */
+	cur_time = snd_seq_timer_get_cur_time(q->timer, false);
 	for (;;) {
-		cell = snd_seq_prioq_cell_out(q->timeq, &q->timer->cur_time);
+		cell = snd_seq_prioq_cell_out(q->timeq, &cur_time);
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -422,14 +422,15 @@ int snd_seq_timer_continue(struct snd_se
 }
 
 /* return current 'real' time. use timeofday() to get better granularity. */
-snd_seq_real_time_t snd_seq_timer_get_cur_time(struct snd_seq_timer *tmr)
+snd_seq_real_time_t snd_seq_timer_get_cur_time(struct snd_seq_timer *tmr,
+					       bool adjust_ktime)
 {
 	snd_seq_real_time_t cur_time;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tmr->lock, flags);
 	cur_time = tmr->cur_time;
-	if (tmr->running) { 
+	if (adjust_ktime && tmr->running) {
 		struct timespec64 tm;
 
 		ktime_get_ts64(&tm);
@@ -446,7 +447,13 @@ snd_seq_real_time_t snd_seq_timer_get_cu
  high PPQ values) */
 snd_seq_tick_time_t snd_seq_timer_get_cur_tick(struct snd_seq_timer *tmr)
 {
-	return tmr->tick.cur_tick;
+	snd_seq_tick_time_t cur_tick;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tmr->lock, flags);
+	cur_tick = tmr->tick.cur_tick;
+	spin_unlock_irqrestore(&tmr->lock, flags);
+	return cur_tick;
 }
 
 
--- a/sound/core/seq/seq_timer.h
+++ b/sound/core/seq/seq_timer.h
@@ -120,7 +120,8 @@ int snd_seq_timer_set_tempo_ppq(struct s
 int snd_seq_timer_set_position_tick(struct snd_seq_timer *tmr, snd_seq_tick_time_t position);
 int snd_seq_timer_set_position_time(struct snd_seq_timer *tmr, snd_seq_real_time_t position);
 int snd_seq_timer_set_skew(struct snd_seq_timer *tmr, unsigned int skew, unsigned int base);
-snd_seq_real_time_t snd_seq_timer_get_cur_time(struct snd_seq_timer *tmr);
+snd_seq_real_time_t snd_seq_timer_get_cur_time(struct snd_seq_timer *tmr,
+					       bool adjust_ktime);
 snd_seq_tick_time_t snd_seq_timer_get_cur_tick(struct snd_seq_timer *tmr);
 
 extern int seq_default_timer_class;


