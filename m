Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E211D865C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgERRor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbgERRoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80F020715;
        Mon, 18 May 2020 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823883;
        bh=typIq0/seAP8Czi1rdqH4ZdtGRHRMXR+6Z2dgm9bv+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BsQYLEEswHdjuPmgitsSZ0w2VlwNV+qA4cOxcNfaIllPGSsQmYTEED3IzFVPxgg+
         zPP2YPvebZZQGRI2aIwklc4ozGOQgaz1dpCKxVcCxtijrh04tf5p694zEFIcdlcMc7
         tgemK46UDvzl038POsmDyFIr9cyj/MOSqui9BGnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 75/90] ALSA: rawmidi: Fix racy buffer resize under concurrent accesses
Date:   Mon, 18 May 2020 19:36:53 +0200
Message-Id: <20200518173506.527439760@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 include/sound/rawmidi.h |    1 +
 sound/core/rawmidi.c    |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -76,6 +76,7 @@ struct snd_rawmidi_runtime {
 	size_t avail_min;	/* min avail for wakeup */
 	size_t avail;		/* max used buffer for wakeup */
 	size_t xruns;		/* over/underruns counter */
+	int buffer_ref;		/* buffer reference count */
 	/* misc */
 	spinlock_t lock;
 	wait_queue_head_t sleep;
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -108,6 +108,17 @@ static void snd_rawmidi_input_event_work
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
@@ -654,6 +665,11 @@ int snd_rawmidi_output_params(struct snd
 		if (!newbuf)
 			return -ENOMEM;
 		spin_lock_irq(&runtime->lock);
+		if (runtime->buffer_ref) {
+			spin_unlock_irq(&runtime->lock);
+			kfree(newbuf);
+			return -EBUSY;
+		}
 		oldbuf = runtime->buffer;
 		runtime->buffer = newbuf;
 		runtime->buffer_size = params->buffer_size;
@@ -962,8 +978,10 @@ static long snd_rawmidi_kernel_read1(str
 	long result = 0, count1;
 	struct snd_rawmidi_runtime *runtime = substream->runtime;
 	unsigned long appl_ptr;
+	int err = 0;
 
 	spin_lock_irqsave(&runtime->lock, flags);
+	snd_rawmidi_buffer_ref(runtime);
 	while (count > 0 && runtime->avail) {
 		count1 = runtime->buffer_size - runtime->appl_ptr;
 		if (count1 > count)
@@ -982,16 +1000,19 @@ static long snd_rawmidi_kernel_read1(str
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
@@ -1262,6 +1283,7 @@ static long snd_rawmidi_kernel_write1(st
 			return -EAGAIN;
 		}
 	}
+	snd_rawmidi_buffer_ref(runtime);
 	while (count > 0 && runtime->avail > 0) {
 		count1 = runtime->buffer_size - runtime->appl_ptr;
 		if (count1 > count)
@@ -1293,6 +1315,7 @@ static long snd_rawmidi_kernel_write1(st
 	}
       __end:
 	count1 = runtime->avail < runtime->buffer_size;
+	snd_rawmidi_buffer_unref(runtime);
 	spin_unlock_irqrestore(&runtime->lock, flags);
 	if (count1)
 		snd_rawmidi_output_trigger(substream, 1);


