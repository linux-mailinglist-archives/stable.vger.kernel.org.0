Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8107974631
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfGYFtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391124AbfGYFn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E335522C7D;
        Thu, 25 Jul 2019 05:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033438;
        bh=8t5QVbCM8xFqk4NuKu5dd9sVDoCfed5xoDeOenDTj5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHj03AWuMbCbK5KUtLuBTN2dJDhG6M+NJbUeZuMWvdO6BiOEb/+GhR5bpeb/+EeuA
         w4uQmQ+rawiii5CwfqyuDh437Q6UnNkxJtitxaEJTTip93T90XllvpYPpF6p6j9xgA
         fLu5gr2XG3/8kFIJk/u5dxCNgutUET4PkjzAvWwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+97aae04ce27e39cbfca9@syzkaller.appspotmail.com,
        syzbot+4c595632b98bb8ffcc66@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 206/271] ALSA: seq: Break too long mutex context in the write loop
Date:   Wed, 24 Jul 2019 21:21:15 +0200
Message-Id: <20190724191712.734474221@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
@@ -1004,7 +1004,7 @@ static ssize_t snd_seq_write(struct file
 {
 	struct snd_seq_client *client = file->private_data;
 	int written = 0, len;
-	int err;
+	int err, handled;
 	struct snd_seq_event event;
 
 	if (!(snd_seq_file_flags(file) & SNDRV_SEQ_LFLG_OUTPUT))
@@ -1017,6 +1017,8 @@ static ssize_t snd_seq_write(struct file
 	if (!client->accept_output || client->pool == NULL)
 		return -ENXIO;
 
+ repeat:
+	handled = 0;
 	/* allocate the pool now if the pool is not allocated yet */ 
 	mutex_lock(&client->ioctl_mutex);
 	if (client->pool->size > 0 && !snd_seq_write_pool_allocated(client)) {
@@ -1076,12 +1078,19 @@ static ssize_t snd_seq_write(struct file
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


