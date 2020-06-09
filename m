Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3309D1F2E70
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgFIAlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFHXMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32BFE20B80;
        Mon,  8 Jun 2020 23:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657959;
        bh=WFAZUWkWukHSvivn5zk3iCQoreXeBfc6lYnZhfIig64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icM1NZGS9FduG5lGbwGcXEkn3hVkRDQYwomLi7FbO4zlUJoqtev1BAnQnzptN59/2
         0m83U3sB91OUQ1jPjR55On6UIdSf1p2qjEUT/bv4Ku08FZmG0bnsl1LVrzA+PBUiQ6
         aDLyAz6yFNOhPDGMn8NhjA70t2FRZB7Zlz+jkpUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 024/606] ALSA: rawmidi: Fix racy buffer resize under concurrent accesses
Date:   Mon,  8 Jun 2020 19:02:29 -0400
Message-Id: <20200608231211.3363633-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c1f6e3c818dd734c30f6a7eeebf232ba2cf3181d upstream.

The rawmidi core allows user to resize the runtime buffer via ioctl,
and this may lead to UAF when performed during concurrent reads or
writes: the read/write functions unlock the runtime lock temporarily
during copying form/to user-space, and that's the race window.

This patch fixes the hole by introducing a reference counter for the
runtime buffer read/write access and returns -EBUSY error when the
resize is performed concurrently against read/write.

Note that the ref count field is a simple integer instead of
refcount_t here, since the all contexts accessing the buffer is
basically protected with a spinlock, hence we need no expensive atomic
ops.  Also, note that this busy check is needed only against read /
write functions, and not in receive/transmit callbacks; the race can
happen only at the spinlock hole mentioned in the above, while the
whole function is protected for receive / transmit callbacks.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAFcO6XMWpUVK_yzzCpp8_XP7+=oUpQvuBeCbMffEDkpe8jWrfg@mail.gmail.com
Link: https://lore.kernel.org/r/s5heerw3r5z.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/rawmidi.h |  1 +
 sound/core/rawmidi.c    | 31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index a36b7227a15a..334842daa904 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -61,6 +61,7 @@ struct snd_rawmidi_runtime {
 	size_t avail_min;	/* min avail for wakeup */
 	size_t avail;		/* max used buffer for wakeup */
 	size_t xruns;		/* over/underruns counter */
+	int buffer_ref;		/* buffer reference count */
 	/* misc */
 	spinlock_t lock;
 	wait_queue_head_t sleep;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 20dd08e1f675..2a688b711a9a 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -120,6 +120,17 @@ static void snd_rawmidi_input_event_work(struct work_struct *work)
 		runtime->event(runtime->substream);
 }
 
+/* buffer refcount management: call with runtime->lock held */
+static inline void snd_rawmidi_buffer_ref(struct snd_rawmidi_runtime *runtime)
+{
+	runtime->buffer_ref++;
+}
+
+static inline void snd_rawmidi_buffer_unref(struct snd_rawmidi_runtime *runtime)
+{
+	runtime->buffer_ref--;
+}
+
 static int snd_rawmidi_runtime_create(struct snd_rawmidi_substream *substream)
 {
 	struct snd_rawmidi_runtime *runtime;
@@ -669,6 +680,11 @@ static int resize_runtime_buffer(struct snd_rawmidi_runtime *runtime,
 		if (!newbuf)
 			return -ENOMEM;
 		spin_lock_irq(&runtime->lock);
+		if (runtime->buffer_ref) {
+			spin_unlock_irq(&runtime->lock);
+			kvfree(newbuf);
+			return -EBUSY;
+		}
 		oldbuf = runtime->buffer;
 		runtime->buffer = newbuf;
 		runtime->buffer_size = params->buffer_size;
@@ -1019,8 +1035,10 @@ static long snd_rawmidi_kernel_read1(struct snd_rawmidi_substream *substream,
 	long result = 0, count1;
 	struct snd_rawmidi_runtime *runtime = substream->runtime;
 	unsigned long appl_ptr;
+	int err = 0;
 
 	spin_lock_irqsave(&runtime->lock, flags);
+	snd_rawmidi_buffer_ref(runtime);
 	while (count > 0 && runtime->avail) {
 		count1 = runtime->buffer_size - runtime->appl_ptr;
 		if (count1 > count)
@@ -1039,16 +1057,19 @@ static long snd_rawmidi_kernel_read1(struct snd_rawmidi_substream *substream,
 		if (userbuf) {
 			spin_unlock_irqrestore(&runtime->lock, flags);
 			if (copy_to_user(userbuf + result,
-					 runtime->buffer + appl_ptr, count1)) {
-				return result > 0 ? result : -EFAULT;
-			}
+					 runtime->buffer + appl_ptr, count1))
+				err = -EFAULT;
 			spin_lock_irqsave(&runtime->lock, flags);
+			if (err)
+				goto out;
 		}
 		result += count1;
 		count -= count1;
 	}
+ out:
+	snd_rawmidi_buffer_unref(runtime);
 	spin_unlock_irqrestore(&runtime->lock, flags);
-	return result;
+	return result > 0 ? result : err;
 }
 
 long snd_rawmidi_kernel_read(struct snd_rawmidi_substream *substream,
@@ -1342,6 +1363,7 @@ static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
 			return -EAGAIN;
 		}
 	}
+	snd_rawmidi_buffer_ref(runtime);
 	while (count > 0 && runtime->avail > 0) {
 		count1 = runtime->buffer_size - runtime->appl_ptr;
 		if (count1 > count)
@@ -1373,6 +1395,7 @@ static long snd_rawmidi_kernel_write1(struct snd_rawmidi_substream *substream,
 	}
       __end:
 	count1 = runtime->avail < runtime->buffer_size;
+	snd_rawmidi_buffer_unref(runtime);
 	spin_unlock_irqrestore(&runtime->lock, flags);
 	if (count1)
 		snd_rawmidi_output_trigger(substream, 1);
-- 
2.25.1

