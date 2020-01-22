Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4694144F4C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbgAVJga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbgAVJga (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF2924125;
        Wed, 22 Jan 2020 09:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685789;
        bh=kkBMsYslEkYNPYzHKXDUibNKOCy004q3kA+dqlieGVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEZs6+tU9N3dziENzKlX7wDfUGGmKrK8Gg32ZUqw7E5o01OWoM1ne7+1DqwBk+zyh
         AriutTUYRHmW6gj8qVsOaHXHR1LyPsK0tM6INI9YXssTZvkOokSelTjdl+gnBLr/Ww
         YoK5atPf4txtlWuKFu27Q3uZ/xYDuEOlQ1RN9vKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 53/97] ALSA: seq: Fix racy access for queue timer in proc read
Date:   Wed, 22 Jan 2020 10:28:57 +0100
Message-Id: <20200122092804.995472662@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 60adcfde92fa40fcb2dbf7cc52f9b096e0cd109a upstream.

snd_seq_info_timer_read() reads the information of the timer assigned
for each queue, but it's done in a racy way which may lead to UAF as
spotted by syzkaller.

This patch applies the missing q->timer_mutex lock while accessing the
timer object as well as a slight code change to adapt the standard
coding style.

Reported-by: syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200115203733.26530-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_timer.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -479,15 +479,19 @@ void snd_seq_info_timer_read(struct snd_
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


