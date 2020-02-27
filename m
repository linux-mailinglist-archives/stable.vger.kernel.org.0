Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E47171EAD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbgB0OGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgB0OGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 432CF20801;
        Thu, 27 Feb 2020 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812378;
        bh=Te41+tNcup87PSvefJ0qm3+DY+RRnetH1azne1ZP7LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxqj7RQzEqhLNZpTiQyyycq5hzxtqUiNTKs7aMqya3IdrWFbeejx4/mpMPVMvnYNB
         6mT7ctxvxjto0lkWp6kisluq7piI7A5nb6i40L7fhKXE4GKziMZF/MbOGB7Vhsmptf
         bywJHycP5c+HBgrvSw7+5eY2dxE2dmEtD+3nBlv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+65c6c92d04304d0a8efc@syzkaller.appspotmail.com,
        syzbot+e60ddfa48717579799dd@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 91/97] ALSA: seq: Avoid concurrent access to queue flags
Date:   Thu, 27 Feb 2020 14:37:39 +0100
Message-Id: <20200227132229.500706144@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit bb51e669fa49feb5904f452b2991b240ef31bc97 upstream.

The queue flags are represented in bit fields and the concurrent
access may result in unexpected results.  Although the current code
should be mostly OK as it's only reading a field while writing other
fields as KCSAN reported, it's safer to cover both with a proper
spinlock protection.

This patch fixes the possible concurrent read by protecting with
q->owner_lock.  Also the queue owner field is protected as well since
it's the field to be protected by the lock itself.

Reported-by: syzbot+65c6c92d04304d0a8efc@syzkaller.appspotmail.com
Reported-by: syzbot+e60ddfa48717579799dd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200214111316.26939-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_queue.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -405,6 +405,7 @@ int snd_seq_queue_check_access(int queue
 int snd_seq_queue_set_owner(int queueid, int client, int locked)
 {
 	struct snd_seq_queue *q = queueptr(queueid);
+	unsigned long flags;
 
 	if (q == NULL)
 		return -EINVAL;
@@ -414,8 +415,10 @@ int snd_seq_queue_set_owner(int queueid,
 		return -EPERM;
 	}
 
+	spin_lock_irqsave(&q->owner_lock, flags);
 	q->locked = locked ? 1 : 0;
 	q->owner = client;
+	spin_unlock_irqrestore(&q->owner_lock, flags);
 	queue_access_unlock(q);
 	queuefree(q);
 
@@ -552,15 +555,17 @@ void snd_seq_queue_client_termination(in
 	unsigned long flags;
 	int i;
 	struct snd_seq_queue *q;
+	bool matched;
 
 	for (i = 0; i < SNDRV_SEQ_MAX_QUEUES; i++) {
 		if ((q = queueptr(i)) == NULL)
 			continue;
 		spin_lock_irqsave(&q->owner_lock, flags);
-		if (q->owner == client)
+		matched = (q->owner == client);
+		if (matched)
 			q->klocked = 1;
 		spin_unlock_irqrestore(&q->owner_lock, flags);
-		if (q->owner == client) {
+		if (matched) {
 			if (q->timer->running)
 				snd_seq_timer_stop(q->timer);
 			snd_seq_timer_reset(q->timer);
@@ -752,6 +757,8 @@ void snd_seq_info_queues_read(struct snd
 	int i, bpm;
 	struct snd_seq_queue *q;
 	struct snd_seq_timer *tmr;
+	bool locked;
+	int owner;
 
 	for (i = 0; i < SNDRV_SEQ_MAX_QUEUES; i++) {
 		if ((q = queueptr(i)) == NULL)
@@ -763,9 +770,14 @@ void snd_seq_info_queues_read(struct snd
 		else
 			bpm = 0;
 
+		spin_lock_irq(&q->owner_lock);
+		locked = q->locked;
+		owner = q->owner;
+		spin_unlock_irq(&q->owner_lock);
+
 		snd_iprintf(buffer, "queue %d: [%s]\n", q->queue, q->name);
-		snd_iprintf(buffer, "owned by client    : %d\n", q->owner);
-		snd_iprintf(buffer, "lock status        : %s\n", q->locked ? "Locked" : "Free");
+		snd_iprintf(buffer, "owned by client    : %d\n", owner);
+		snd_iprintf(buffer, "lock status        : %s\n", locked ? "Locked" : "Free");
 		snd_iprintf(buffer, "queued time events : %d\n", snd_seq_prioq_avail(q->timeq));
 		snd_iprintf(buffer, "queued tick events : %d\n", snd_seq_prioq_avail(q->tickq));
 		snd_iprintf(buffer, "timer state        : %s\n", tmr->running ? "Running" : "Stopped");


