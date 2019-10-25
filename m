Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B3AE531F
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfJYSHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46934 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731503AbfJYSFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:45 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xy-0008Oi-Sd; Fri, 25 Oct 2019 19:05:38 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001kn-Dn; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        syzbot+97aae04ce27e39cbfca9@syzkaller.appspotmail.com,
        syzbot+4c595632b98bb8ffcc66@syzkaller.appspotmail.com
Date:   Fri, 25 Oct 2019 19:03:42 +0100
Message-ID: <lsq.1572026582.796070921@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 41/47] ALSA: seq: Break too long mutex context in the
 write loop
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/seq/seq_clientmgr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1014,7 +1014,7 @@ static ssize_t snd_seq_write(struct file
 {
 	struct snd_seq_client *client = file->private_data;
 	int written = 0, len;
-	int err;
+	int err, handled;
 	struct snd_seq_event event;
 
 	if (!(snd_seq_file_flags(file) & SNDRV_SEQ_LFLG_OUTPUT))
@@ -1027,6 +1027,8 @@ static ssize_t snd_seq_write(struct file
 	if (!client->accept_output || client->pool == NULL)
 		return -ENXIO;
 
+ repeat:
+	handled = 0;
 	/* allocate the pool now if the pool is not allocated yet */ 
 	mutex_lock(&client->ioctl_mutex);
 	if (client->pool->size > 0 && !snd_seq_write_pool_allocated(client)) {
@@ -1086,12 +1088,19 @@ static ssize_t snd_seq_write(struct file
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

