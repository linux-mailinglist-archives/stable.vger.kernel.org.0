Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF783A62D7
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhFNLFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234024AbhFNLCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E95561447;
        Mon, 14 Jun 2021 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667455;
        bh=gPtPur8R9bU4BReM8hD8hLm4cefnseJxwoGY+DFyJo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSpBKzfPgBxZRlDbOxkSvFQtq3PW5Cf3Wq43YPaBpB3OMUKKlBuKAmGEFCSmSIWbm
         xT0vqAVmW19Df9/mP/WtYnBuMTXY6tUxQ7iwfbAhKZ5A4cTmqqlhRqFwRYA6WrbiFe
         uMdmhOW4Fe/MBQLE67lBFl4Twq+UcIhUCkjI7Dek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ddc1260a83ed1cbf6fb5@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 045/131] ALSA: seq: Fix race of snd_seq_timer_open()
Date:   Mon, 14 Jun 2021 12:26:46 +0200
Message-Id: <20210614102654.554684925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 83e197a8414c0ba545e7e3916ce05f836f349273 upstream.

The timer instance per queue is exclusive, and snd_seq_timer_open()
should have managed the concurrent accesses.  It looks as if it's
checking the already existing timer instance at the beginning, but
it's not right, because there is no protection, hence any later
concurrent call of snd_seq_timer_open() may override the timer
instance easily.  This may result in UAF, as the leftover timer
instance can keep running while the queue itself gets closed, as
spotted by syzkaller recently.

For avoiding the race, add a proper check at the assignment of
tmr->timeri again, and return -EBUSY if it's been already registered.

Reported-by: syzbot+ddc1260a83ed1cbf6fb5@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000dce34f05c42f110c@google.com
Link: https://lore.kernel.org/r/20210610152059.24633-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_timer.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -297,8 +297,16 @@ int snd_seq_timer_open(struct snd_seq_qu
 		return err;
 	}
 	spin_lock_irq(&tmr->lock);
-	tmr->timeri = t;
+	if (tmr->timeri)
+		err = -EBUSY;
+	else
+		tmr->timeri = t;
 	spin_unlock_irq(&tmr->lock);
+	if (err < 0) {
+		snd_timer_close(t);
+		snd_timer_instance_free(t);
+		return err;
+	}
 	return 0;
 }
 


