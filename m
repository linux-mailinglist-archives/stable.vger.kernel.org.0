Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161F9498967
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344072AbiAXSzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52714 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343628AbiAXSyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53EEFB81227;
        Mon, 24 Jan 2022 18:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71435C340E5;
        Mon, 24 Jan 2022 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050447;
        bh=1j7mayRmOuGQ+nRLdXsL59wVA+c5vHDalgnqM39ocY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMpDYfUKS0sdYaNKkuwJzC5A3eUSbOcG5E/OtxdCRoenb6lPNcVHefkPT2Oz4rq1V
         n6jUByyUCCJCTlDrCeLao2ORnUsXinVdZUK9WxCGyEVLUFSvGdb99DMu8XwCAHRCY4
         xJbsc5Db4tsSww+WKp2z2OjMnoI//+v0fUoLgjac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang1211@gmail.com>,
        syzbot+bb950e68b400ab4f65f8@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 092/114] ALSA: seq: Set upper limit of processed events
Date:   Mon, 24 Jan 2022 19:43:07 +0100
Message-Id: <20220124183929.951106226@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6fadb494a638d8b8a55864ecc6ac58194f03f327 ]

Currently ALSA sequencer core tries to process the queued events as
much as possible when they become dispatchable.  If applications try
to queue too massive events to be processed at the very same timing,
the sequencer core would still try to process such all events, either
in the interrupt context or via some notifier; in either away, it
might be a cause of RCU stall or such problems.

As a potential workaround for those problems, this patch adds the
upper limit of the amount of events to be processed.  The remaining
events are processed in the next batch, so they won't be lost.

For the time being, it's limited up to 1000 events per queue, which
should be high enough for any normal usages.

Reported-by: Zqiang <qiang.zhang1211@gmail.com>
Reported-by: syzbot+bb950e68b400ab4f65f8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211102033222.3849-1-qiang.zhang1211@gmail.com
Link: https://lore.kernel.org/r/20211207165146.2888-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_queue.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
index ea1aa07962761..b923059a22276 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -257,12 +257,15 @@ struct snd_seq_queue *snd_seq_queue_find_name(char *name)
 
 /* -------------------------------------------------------- */
 
+#define MAX_CELL_PROCESSES_IN_QUEUE	1000
+
 void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 {
 	unsigned long flags;
 	struct snd_seq_event_cell *cell;
 	snd_seq_tick_time_t cur_tick;
 	snd_seq_real_time_t cur_time;
+	int processed = 0;
 
 	if (q == NULL)
 		return;
@@ -285,6 +288,8 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
+		if (++processed >= MAX_CELL_PROCESSES_IN_QUEUE)
+			goto out; /* the rest processed at the next batch */
 	}
 
 	/* Process time queue... */
@@ -294,14 +299,19 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
+		if (++processed >= MAX_CELL_PROCESSES_IN_QUEUE)
+			goto out; /* the rest processed at the next batch */
 	}
 
+ out:
 	/* free lock */
 	spin_lock_irqsave(&q->check_lock, flags);
 	if (q->check_again) {
 		q->check_again = 0;
-		spin_unlock_irqrestore(&q->check_lock, flags);
-		goto __again;
+		if (processed < MAX_CELL_PROCESSES_IN_QUEUE) {
+			spin_unlock_irqrestore(&q->check_lock, flags);
+			goto __again;
+		}
 	}
 	q->check_blocked = 0;
 	spin_unlock_irqrestore(&q->check_lock, flags);
-- 
2.34.1



