Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381BDF67CB
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbfKJGms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:48 -0500
Received: from www.linuxtv.org ([130.149.80.248]:55979 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfKJGms (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:48 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvu-00053Q-IA; Sun, 10 Nov 2019 06:42:46 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Fri, 08 Nov 2019 06:38:59 +0000
Subject: [git:media_tree/master] media: vivid: Fix wrong locking that causes race conditions on streaming stop
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Popov <alex.popov@linux.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvu-00053Q-IA@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: vivid: Fix wrong locking that causes race conditions on streaming stop
Author:  Alexander Popov <alex.popov@linux.com>
Date:    Sun Nov 3 23:17:19 2019 +0100

There is the same incorrect approach to locking implemented in
vivid_stop_generating_vid_cap(), vivid_stop_generating_vid_out() and
sdr_cap_stop_streaming().

These functions are called during streaming stopping with vivid_dev.mutex
locked. And they all do the same mistake while stopping their kthreads,
which need to lock this mutex as well. See the example from
vivid_stop_generating_vid_cap():
  /* shutdown control thread */
  vivid_grab_controls(dev, false);
  mutex_unlock(&dev->mutex);
  kthread_stop(dev->kthread_vid_cap);
  dev->kthread_vid_cap = NULL;
  mutex_lock(&dev->mutex);

But when this mutex is unlocked, another vb2_fop_read() can lock it
instead of vivid_thread_vid_cap() and manipulate the buffer queue.
That causes a use-after-free access later.

To fix those issues let's:
  1. avoid unlocking the mutex in vivid_stop_generating_vid_cap(),
vivid_stop_generating_vid_out() and sdr_cap_stop_streaming();
  2. use mutex_trylock() with schedule_timeout_uninterruptible() in
the loops of the vivid kthread handlers.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v3.18 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/vivid/vivid-kthread-cap.c | 8 +++++---
 drivers/media/platform/vivid/vivid-kthread-out.c | 8 +++++---
 drivers/media/platform/vivid/vivid-sdr-cap.c     | 8 +++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

---

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 9f981e8bae6e..01a9d671b947 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -818,7 +818,11 @@ static int vivid_thread_vid_cap(void *data)
 		if (kthread_should_stop())
 			break;
 
-		mutex_lock(&dev->mutex);
+		if (!mutex_trylock(&dev->mutex)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
+
 		cur_jiffies = jiffies;
 		if (dev->cap_seq_resync) {
 			dev->jiffies_vid_cap = cur_jiffies;
@@ -998,8 +1002,6 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 
 	/* shutdown control thread */
 	vivid_grab_controls(dev, false);
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_vid_cap);
 	dev->kthread_vid_cap = NULL;
-	mutex_lock(&dev->mutex);
 }
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index c974235d7de3..6780687978f9 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -166,7 +166,11 @@ static int vivid_thread_vid_out(void *data)
 		if (kthread_should_stop())
 			break;
 
-		mutex_lock(&dev->mutex);
+		if (!mutex_trylock(&dev->mutex)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
+
 		cur_jiffies = jiffies;
 		if (dev->out_seq_resync) {
 			dev->jiffies_vid_out = cur_jiffies;
@@ -344,8 +348,6 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 
 	/* shutdown control thread */
 	vivid_grab_controls(dev, false);
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_vid_out);
 	dev->kthread_vid_out = NULL;
-	mutex_lock(&dev->mutex);
 }
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 9acc709b0740..2b7522e16efc 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -141,7 +141,11 @@ static int vivid_thread_sdr_cap(void *data)
 		if (kthread_should_stop())
 			break;
 
-		mutex_lock(&dev->mutex);
+		if (!mutex_trylock(&dev->mutex)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
+
 		cur_jiffies = jiffies;
 		if (dev->sdr_cap_seq_resync) {
 			dev->jiffies_sdr_cap = cur_jiffies;
@@ -303,10 +307,8 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 	}
 
 	/* shutdown control thread */
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_sdr_cap);
 	dev->kthread_sdr_cap = NULL;
-	mutex_lock(&dev->mutex);
 }
 
 static void sdr_cap_buf_request_complete(struct vb2_buffer *vb)
