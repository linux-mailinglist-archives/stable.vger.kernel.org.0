Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F313490D01
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiAQRA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241454AbiAQQ75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75524C06173E;
        Mon, 17 Jan 2022 08:59:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1639460EDB;
        Mon, 17 Jan 2022 16:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E74C36AEC;
        Mon, 17 Jan 2022 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438796;
        bh=vCWM391mahdHAJjL6H0oEHOo3B7sCwqL6vruq8eQ2u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXff+/pw8VO7IZrrkg27mR8fXIqxDuzZ3jNlUetMKS8fvf8x8ECGBEhH4nYuNsxeO
         lUL9HRDrdTXVex9yj/nT7VQcruXBS2AgMWLj46Hw/G+V3Acpgl8SbgIkWY6U1bC9Kq
         5I7ujLEsE5oejZ4qkpTiIBL4gCJRnClyHHKmwlpc/z24dhykVtdPXCK6tDjC1rkt9i
         cPVbJpSKKwZM+TC/FUBkeJSYGGBRAiYTiZV1SN5liqk9xipWR+ay26coTXZ3c2V3vY
         fD82q2B6sdr6m6E+fdinIzJPJrNJVrzEI91gJ3YZOq/FOqzgwRS6PwP2NwdZB9+g4I
         K/IYlOd6+LdNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Zqiang <qiang.zhang1211@gmail.com>,
        syzbot+bb950e68b400ab4f65f8@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 25/52] ALSA: seq: Set upper limit of processed events
Date:   Mon, 17 Jan 2022 11:58:26 -0500
Message-Id: <20220117165853.1470420-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d6c02dea976c8..bc933104c3eea 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -235,12 +235,15 @@ struct snd_seq_queue *snd_seq_queue_find_name(char *name)
 
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
@@ -263,6 +266,8 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
+		if (++processed >= MAX_CELL_PROCESSES_IN_QUEUE)
+			goto out; /* the rest processed at the next batch */
 	}
 
 	/* Process time queue... */
@@ -272,14 +277,19 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
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

