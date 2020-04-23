Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9C1B67FC
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgDWXL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:11:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50156 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728530AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvb-0004n6-0u; Fri, 24 Apr 2020 00:06:43 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvW-00E6wt-PO; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 24 Apr 2020 00:06:54 +0100
Message-ID: <lsq.1587683028.369919197@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 187/245] ALSA: seq: Fix racy access for queue timer
 in proc read
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60adcfde92fa40fcb2dbf7cc52f9b096e0cd109a upstream.

snd_seq_info_timer_read() reads the information of the timer assigned
for each queue, but it's done in a racy way which may lead to UAF as
spotted by syzkaller.

This patch applies the missing q->timer_mutex lock while accessing the
timer object as well as a slight code change to adapt the standard
coding style.

Reported-by: syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200115203733.26530-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/seq/seq_timer.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -484,15 +484,19 @@ void snd_seq_info_timer_read(struct snd_
 		q = queueptr(idx);
 		if (q == NULL)
 			continue;
-		if ((tmr = q->timer) == NULL ||
-		    (ti = tmr->timeri) == NULL) {
-			queuefree(q);
-			continue;
-		}
+		mutex_lock(&q->timer_mutex);
+		tmr = q->timer;
+		if (!tmr)
+			goto unlock;
+		ti = tmr->timeri;
+		if (!ti)
+			goto unlock;
 		snd_iprintf(buffer, "Timer for queue %i : %s\n", q->queue, ti->timer->name);
 		resolution = snd_timer_resolution(ti) * tmr->ticks;
 		snd_iprintf(buffer, "  Period time : %lu.%09lu\n", resolution / 1000000000, resolution % 1000000000);
 		snd_iprintf(buffer, "  Skew : %u / %u\n", tmr->skew, tmr->skew_base);
+unlock:
+		mutex_unlock(&q->timer_mutex);
 		queuefree(q);
  	}
 }

