Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845C72E99BE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbhADQDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbhADQDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A56622512;
        Mon,  4 Jan 2021 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776145;
        bh=25NtS8XB5LccoyFX+CjGFcC1swS244ghNyIoz1QgFB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7pNqp4m5eRU0qx6rtrX/UJE/OCmAmsoScBoRkevJKnP/Oq3wZ+WMRqpTiqbMNI/E
         kd3HAURCmBfPefS3Py4BxU0dD954mkDgbxFz6Gn46ih7WVOceF/b4h4LGoTu8JiTE2
         F1oIjsZ5EIburGMTDTEnmNh21OO3YIDz62dPu6KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a23a6f1215c84756577c@syzkaller.appspotmail.com,
        syzbot+3d367d1df1d2b67f5c19@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 34/63] ALSA: rawmidi: Access runtime->avail always in spinlock
Date:   Mon,  4 Jan 2021 16:57:27 +0100
Message-Id: <20210104155710.476222345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 88a06d6fd6b369d88cec46c62db3e2604a2f50d5 upstream.

The runtime->avail field may be accessed concurrently while some
places refer to it without taking the runtime->lock spinlock, as
detected by KCSAN.  Usually this isn't a big problem, but for
consistency and safety, we should take the spinlock at each place
referencing this field.

Reported-by: syzbot+a23a6f1215c84756577c@syzkaller.appspotmail.com
Reported-by: syzbot+3d367d1df1d2b67f5c19@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20201206083527.21163-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/rawmidi.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -95,11 +95,21 @@ static inline unsigned short snd_rawmidi
 	}
 }
 
-static inline int snd_rawmidi_ready(struct snd_rawmidi_substream *substream)
+static inline bool __snd_rawmidi_ready(struct snd_rawmidi_runtime *runtime)
+{
+	return runtime->avail >= runtime->avail_min;
+}
+
+static bool snd_rawmidi_ready(struct snd_rawmidi_substream *substream)
 {
 	struct snd_rawmidi_runtime *runtime = substream->runtime;
+	unsigned long flags;
+	bool ready;
 
-	return runtime->avail >= runtime->avail_min;
+	spin_lock_irqsave(&runtime->lock, flags);
+	ready = __snd_rawmidi_ready(runtime);
+	spin_unlock_irqrestore(&runtime->lock, flags);
+	return ready;
 }
 
 static inline int snd_rawmidi_ready_append(struct snd_rawmidi_substream *substream,
@@ -1019,7 +1029,7 @@ int snd_rawmidi_receive(struct snd_rawmi
 	if (result > 0) {
 		if (runtime->event)
 			schedule_work(&runtime->event_work);
-		else if (snd_rawmidi_ready(substream))
+		else if (__snd_rawmidi_ready(runtime))
 			wake_up(&runtime->sleep);
 	}
 	spin_unlock_irqrestore(&runtime->lock, flags);
@@ -1098,7 +1108,7 @@ static ssize_t snd_rawmidi_read(struct f
 	result = 0;
 	while (count > 0) {
 		spin_lock_irq(&runtime->lock);
-		while (!snd_rawmidi_ready(substream)) {
+		while (!__snd_rawmidi_ready(runtime)) {
 			wait_queue_entry_t wait;
 
 			if ((file->f_flags & O_NONBLOCK) != 0 || result > 0) {
@@ -1115,9 +1125,11 @@ static ssize_t snd_rawmidi_read(struct f
 				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
-			if (!runtime->avail)
-				return result > 0 ? result : -EIO;
 			spin_lock_irq(&runtime->lock);
+			if (!runtime->avail) {
+				spin_unlock_irq(&runtime->lock);
+				return result > 0 ? result : -EIO;
+			}
 		}
 		spin_unlock_irq(&runtime->lock);
 		count1 = snd_rawmidi_kernel_read1(substream,
@@ -1255,7 +1267,7 @@ int __snd_rawmidi_transmit_ack(struct sn
 	runtime->avail += count;
 	substream->bytes += count;
 	if (count > 0) {
-		if (runtime->drain || snd_rawmidi_ready(substream))
+		if (runtime->drain || __snd_rawmidi_ready(runtime))
 			wake_up(&runtime->sleep);
 	}
 	return count;
@@ -1444,9 +1456,11 @@ static ssize_t snd_rawmidi_write(struct
 				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
-			if (!runtime->avail && !timeout)
-				return result > 0 ? result : -EIO;
 			spin_lock_irq(&runtime->lock);
+			if (!runtime->avail && !timeout) {
+				spin_unlock_irq(&runtime->lock);
+				return result > 0 ? result : -EIO;
+			}
 		}
 		spin_unlock_irq(&runtime->lock);
 		count1 = snd_rawmidi_kernel_write1(substream, buf, NULL, count);
@@ -1526,6 +1540,7 @@ static void snd_rawmidi_proc_info_read(s
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *substream;
 	struct snd_rawmidi_runtime *runtime;
+	unsigned long buffer_size, avail, xruns;
 
 	rmidi = entry->private_data;
 	snd_iprintf(buffer, "%s\n\n", rmidi->name);
@@ -1544,13 +1559,16 @@ static void snd_rawmidi_proc_info_read(s
 				    "  Owner PID    : %d\n",
 				    pid_vnr(substream->pid));
 				runtime = substream->runtime;
+				spin_lock_irq(&runtime->lock);
+				buffer_size = runtime->buffer_size;
+				avail = runtime->avail;
+				spin_unlock_irq(&runtime->lock);
 				snd_iprintf(buffer,
 				    "  Mode         : %s\n"
 				    "  Buffer size  : %lu\n"
 				    "  Avail        : %lu\n",
 				    runtime->oss ? "OSS compatible" : "native",
-				    (unsigned long) runtime->buffer_size,
-				    (unsigned long) runtime->avail);
+				    buffer_size, avail);
 			}
 		}
 	}
@@ -1568,13 +1586,16 @@ static void snd_rawmidi_proc_info_read(s
 					    "  Owner PID    : %d\n",
 					    pid_vnr(substream->pid));
 				runtime = substream->runtime;
+				spin_lock_irq(&runtime->lock);
+				buffer_size = runtime->buffer_size;
+				avail = runtime->avail;
+				xruns = runtime->xruns;
+				spin_unlock_irq(&runtime->lock);
 				snd_iprintf(buffer,
 					    "  Buffer size  : %lu\n"
 					    "  Avail        : %lu\n"
 					    "  Overruns     : %lu\n",
-					    (unsigned long) runtime->buffer_size,
-					    (unsigned long) runtime->avail,
-					    (unsigned long) runtime->xruns);
+					    buffer_size, avail, xruns);
 			}
 		}
 	}


