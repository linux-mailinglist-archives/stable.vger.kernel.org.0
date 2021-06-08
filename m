Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B67439FFF4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFHShs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhFHSfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A3A3613D3;
        Tue,  8 Jun 2021 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177152;
        bh=O5BdJl3WeIOn6QpxB+u21wKOHY+i9erEeapxL+UVtGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1PdAhxVDYOLRgEGXXjdMNVzSikMS7K1C1GUfGTXXy+g1hOWvWpE8sWz235AloA7a
         /Zy83sQn1KTCzl/01EIwVpr43Ok2Bjx04G/6UiAwuKxDbrYFrxy2+2Yw5RRQe0HRhg
         PdH3hTl8SEhD3nlDaRusisevfAPbHUsLAyk0xD2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d102fa5b35335a7e544e@syzkaller.appspotmail.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 19/47] ALSA: timer: Fix master timer notification
Date:   Tue,  8 Jun 2021 20:27:02 +0200
Message-Id: <20210608175931.108778852@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
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
@@ -490,9 +490,10 @@ static void snd_timer_notify1(struct snd
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


