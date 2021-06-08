Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2783A0020
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhFHSkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235034AbhFHSi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C093F61406;
        Tue,  8 Jun 2021 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177209;
        bh=0F9K0CUqK2VMd7A4DDsHuctUE+bP9NpzxPeBU/UiFi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3TvUqe3ITNhy/RKzX/qBRWXGun/hLj3drYr+xcAjlZiMrdpTiuRo7PqDw26LcWM6
         VO/tu8ouChqaiDRb61EUQsm5QcEnWk/OwwxZJi3oCJIGpu2196OPv7o4xNRZqvC5Pa
         JThkUQTK5UuyLMwkijynoSX02AMoWzApzD12MvmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d102fa5b35335a7e544e@syzkaller.appspotmail.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 26/58] ALSA: timer: Fix master timer notification
Date:   Tue,  8 Jun 2021 20:27:07 +0200
Message-Id: <20210608175933.149165609@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9c1fe96bded935369f8340c2ac2e9e189f697d5d upstream.

snd_timer_notify1() calls the notification to each slave for a master
event, but it passes a wrong event number.  It should be +10 offset,
corresponding to SNDRV_TIMER_EVENT_MXXX, but it's incorrectly with
+100 offset.  Casually this was spotted by UBSAN check via syzkaller.

Reported-by: syzbot+d102fa5b35335a7e544e@syzkaller.appspotmail.com
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000e5560e05c3bd1d63@google.com
Link: https://lore.kernel.org/r/20210602113823.23777-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -500,9 +500,10 @@ static void snd_timer_notify1(struct snd
 		return;
 	if (timer->hw.flags & SNDRV_TIMER_HW_SLAVE)
 		return;
+	event += 10; /* convert to SNDRV_TIMER_EVENT_MXXX */
 	list_for_each_entry(ts, &ti->slave_active_head, active_list)
 		if (ts->ccallback)
-			ts->ccallback(ts, event + 100, &tstamp, resolution);
+			ts->ccallback(ts, event, &tstamp, resolution);
 }
 
 /* start/continue a master timer */


