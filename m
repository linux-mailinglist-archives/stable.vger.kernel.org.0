Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FA10BB8B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfK0VNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbfK0VNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C947B2086A;
        Wed, 27 Nov 2019 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889215;
        bh=jgZhuF8duSwxHtm8Ldfjn86FE4kAix6Su0REliUcJSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAzkvdvPYEh7mHru6zyBDaeJ9KAsJaa363F3ss8dK+JT3HJorc1rYq/hYHUR0Ah/S
         Uh9w7uk8aun5YPVyGYcuLnYgMcnOayW8MhaXw2vytrQugpQ3CtcxGi1suQUTWk2HOh
         ugxJ/I/mZ0yvQI9i2ex2TYs7QwQPCLqgw1OyGXVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Popov <alex.popov@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 32/66] media: vivid: Fix wrong locking that causes race conditions on streaming stop
Date:   Wed, 27 Nov 2019 21:32:27 +0100
Message-Id: <20191127202708.288070864@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Popov <alex.popov@linux.com>

commit 6dcd5d7a7a29c1e4b8016a06aed78cd650cd8c27 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vivid/vivid-kthread-cap.c |    8 +++++---
 drivers/media/platform/vivid/vivid-kthread-out.c |    8 +++++---
 drivers/media/platform/vivid/vivid-sdr-cap.c     |    8 +++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -796,7 +796,11 @@ static int vivid_thread_vid_cap(void *da
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
@@ -956,8 +960,6 @@ void vivid_stop_generating_vid_cap(struc
 
 	/* shutdown control thread */
 	vivid_grab_controls(dev, false);
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_vid_cap);
 	dev->kthread_vid_cap = NULL;
-	mutex_lock(&dev->mutex);
 }
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -143,7 +143,11 @@ static int vivid_thread_vid_out(void *da
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
@@ -301,8 +305,6 @@ void vivid_stop_generating_vid_out(struc
 
 	/* shutdown control thread */
 	vivid_grab_controls(dev, false);
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_vid_out);
 	dev->kthread_vid_out = NULL;
-	mutex_lock(&dev->mutex);
 }
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -141,7 +141,11 @@ static int vivid_thread_sdr_cap(void *da
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
@@ -303,10 +307,8 @@ static void sdr_cap_stop_streaming(struc
 	}
 
 	/* shutdown control thread */
-	mutex_unlock(&dev->mutex);
 	kthread_stop(dev->kthread_sdr_cap);
 	dev->kthread_sdr_cap = NULL;
-	mutex_lock(&dev->mutex);
 }
 
 static void sdr_cap_buf_request_complete(struct vb2_buffer *vb)


