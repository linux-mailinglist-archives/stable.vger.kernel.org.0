Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E31F7E93
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfKKSks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbfKKSkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:40:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3AA21655;
        Mon, 11 Nov 2019 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497645;
        bh=5shsiuGVpMOzq5flnd+ZIoIzHgqAS7cOLYrX4/j23uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKjZ3oXbL/ibvl2nsuaudyGtD2xSJdD3XLsD0mrNYpGECQVJiGl/0C/SyIgFRdbJx
         fGGXle0kU6KNs2rbvuhuFzZSDXeZcne4HpVez5fKKZcQMm7D2HsCSXvfQuon0x7b3u
         CJP6JVyutgvbUdpWfbd3tGF81vN1EF3HXLU4OKEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Tristan Madani <tristmd@gmail.com>
Subject: [PATCH 4.19 016/125] ALSA: timer: Fix incorrectly assigned timer instance
Date:   Mon, 11 Nov 2019 19:27:35 +0100
Message-Id: <20191111181441.922397171@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit e7af6307a8a54f0b873960b32b6a644f2d0fbd97 upstream.

The clean up commit 41672c0c24a6 ("ALSA: timer: Simplify error path in
snd_timer_open()") unified the error handling code paths with the
standard goto, but it introduced a subtle bug: the timer instance is
stored in snd_timer_open() incorrectly even if it returns an error.
This may eventually lead to UAF, as spotted by fuzzer.

The culprit is the snd_timer_open() code checks the
SNDRV_TIMER_IFLG_EXCLUSIVE flag with the common variable timeri.
This variable is supposed to be the newly created instance, but we
(ab-)used it for a temporary check before the actual creation of a
timer instance.  After that point, there is another check for the max
number of instances, and it bails out if over the threshold.  Before
the refactoring above, it worked fine because the code returned
directly from that point.  After the refactoring, however, it jumps to
the unified error path that stores the timeri variable in return --
even if it returns an error.  Unfortunately this stored value is kept
in the caller side (snd_timer_user_tselect()) in tu->timeri.  This
causes inconsistency later, as if the timer was successfully
assigned.

In this patch, we fix it by not re-using timeri variable but a
temporary variable for testing the exclusive connection, so timeri
remains NULL at that point.

Fixes: 41672c0c24a6 ("ALSA: timer: Simplify error path in snd_timer_open()")
Reported-and-tested-by: Tristan Madani <tristmd@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191106165547.23518-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/timer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -298,11 +298,11 @@ int snd_timer_open(struct snd_timer_inst
 		goto unlock;
 	}
 	if (!list_empty(&timer->open_list_head)) {
-		timeri = list_entry(timer->open_list_head.next,
+		struct snd_timer_instance *t =
+			list_entry(timer->open_list_head.next,
 				    struct snd_timer_instance, open_list);
-		if (timeri->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
+		if (t->flags & SNDRV_TIMER_IFLG_EXCLUSIVE) {
 			err = -EBUSY;
-			timeri = NULL;
 			goto unlock;
 		}
 	}


