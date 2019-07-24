Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6724173E9C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389593AbfGXU0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389547AbfGXTh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B067217D4;
        Wed, 24 Jul 2019 19:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997078;
        bh=NULSpw87td665LpMtn15sdnpqlluzsCv6UgNIvgnJ1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjPXPOwsjhA1S5suoBYtS7BAHsLq82QaMrkCnqUMO/iKrXlM5VrTIHux06uf4DYBZ
         YWcB2t2/k2b7IkPlafI6Ik9dTGH1sSG7lfoZODI0j84WTqamZ7g7dFdx8izRiIJdru
         xrzgGUNAKmWUl6y3TSuJCuTc5I0WOkQaZyp1CE30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+97aae04ce27e39cbfca9@syzkaller.appspotmail.com,
        syzbot+4c595632b98bb8ffcc66@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 314/413] ALSA: seq: Break too long mutex context in the write loop
Date:   Wed, 24 Jul 2019 21:20:05 +0200
Message-Id: <20190724191758.288107387@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ede34f397ddb063b145b9e7d79c6026f819ded13 upstream.

The fix for the racy writes and ioctls to sequencer widened the
application of client->ioctl_mutex to the whole write loop.  Although
it does unlock/relock for the lengthy operation like the event dup,
the loop keeps the ioctl_mutex for the whole time in other
situations.  This may take quite long time if the user-space would
give a huge buffer, and this is a likely cause of some weird behavior
spotted by syzcaller fuzzer.

This patch puts a simple workaround, just adding a mutex break in the
loop when a large number of events have been processed.  This
shouldn't hit any performance drop because the threshold is set high
enough for usual operations.

Fixes: 7bd800915677 ("ALSA: seq: More protection for concurrent write and ioctl races")
Reported-by: syzbot+97aae04ce27e39cbfca9@syzkaller.appspotmail.com
Reported-by: syzbot+4c595632b98bb8ffcc66@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_clientmgr.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1021,7 +1021,7 @@ static ssize_t snd_seq_write(struct file
 {
 	struct snd_seq_client *client = file->private_data;
 	int written = 0, len;
-	int err;
+	int err, handled;
 	struct snd_seq_event event;
 
 	if (!(snd_seq_file_flags(file) & SNDRV_SEQ_LFLG_OUTPUT))
@@ -1034,6 +1034,8 @@ static ssize_t snd_seq_write(struct file
 	if (!client->accept_output || client->pool == NULL)
 		return -ENXIO;
 
+ repeat:
+	handled = 0;
 	/* allocate the pool now if the pool is not allocated yet */ 
 	mutex_lock(&client->ioctl_mutex);
 	if (client->pool->size > 0 && !snd_seq_write_pool_allocated(client)) {
@@ -1093,12 +1095,19 @@ static ssize_t snd_seq_write(struct file
 						   0, 0, &client->ioctl_mutex);
 		if (err < 0)
 			break;
+		handled++;
 
 	__skip_event:
 		/* Update pointers and counts */
 		count -= len;
 		buf += len;
 		written += len;
+
+		/* let's have a coffee break if too many events are queued */
+		if (++handled >= 200) {
+			mutex_unlock(&client->ioctl_mutex);
+			goto repeat;
+		}
 	}
 
  out:


