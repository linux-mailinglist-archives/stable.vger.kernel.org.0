Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410944998A3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391988AbiAXV22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377063AbiAXVQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5281C09F4B1;
        Mon, 24 Jan 2022 12:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5356060B56;
        Mon, 24 Jan 2022 20:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD0AC340E5;
        Mon, 24 Jan 2022 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055119;
        bh=Z+D5Lb0cITYxKZnNkwCLasS5OuqE492k2Fon+rCWUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+6BCwrCMV8wQLj0ULtNYidvrT+FGyN6LwXNQ/KSGoIFqcVlV3dWJ6oEY1A/yI8AI
         mB/ooylZ6vQd9qbaLgsVYKKE5dJ1fvpMc5sbpJXyb8QAV5+y+V7wZqKxYEkBO9BAB9
         6tNR9lbsyVZaaH/pgbr5BftC9O7BMGfetXm1gtoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 040/846] media: cec: fix a deadlock situation
Date:   Mon, 24 Jan 2022 19:32:37 +0100
Message-Id: <20220124184102.322600608@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit a9e6107616bb8108aa4fc22584a05e69761a91f7 upstream.

The cec_devnode struct has a lock meant to serialize access
to the fields of this struct. This lock is taken during
device node (un)registration and when opening or releasing a
filehandle to the device node. When the last open filehandle
is closed the cec adapter might be disabled by calling the
adap_enable driver callback with the devnode.lock held.

However, if during that callback a message or event arrives
then the driver will call one of the cec_queue_event()
variants in cec-adap.c, and those will take the same devnode.lock
to walk the open filehandle list.

This obviously causes a deadlock.

This is quite easy to reproduce with the cec-gpio driver since that
uses the cec-pin framework which generated lots of events and uses
a kernel thread for the processing, so when adap_enable is called
the thread is still running and can generate events.

But I suspect that it might also happen with other drivers if an
interrupt arrives signaling e.g. a received message before adap_enable
had a chance to disable the interrupts.

This patch adds a new mutex to serialize access to the fhs list.
When adap_enable() is called the devnode.lock mutex is held, but
not devnode.lock_fhs. The event functions in cec-adap.c will now
use devnode.lock_fhs instead of devnode.lock, ensuring that it is
safe to call those functions from the adap_enable callback.

This specific issue only happens if the last open filehandle is closed
and the physical address is invalid. This is not something that
happens during normal operation, but it does happen when monitoring
CEC traffic (e.g. cec-ctl --monitor) with an unconfigured CEC adapter.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>  # for v5.13 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-adap.c |   38 +++++++++++++++++++++-----------------
 drivers/media/cec/core/cec-api.c  |    6 ++++++
 drivers/media/cec/core/cec-core.c |    3 +++
 include/media/cec.h               |   11 +++++++++--
 4 files changed, 39 insertions(+), 19 deletions(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -161,10 +161,10 @@ static void cec_queue_event(struct cec_a
 	u64 ts = ktime_get_ns();
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, ev, ts);
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /* Notify userspace that the CEC pin changed state at the given time. */
@@ -178,11 +178,12 @@ void cec_queue_pin_cec_event(struct cec_
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
-	list_for_each_entry(fh, &adap->devnode.fhs, list)
+	mutex_lock(&adap->devnode.lock_fhs);
+	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower == CEC_MODE_MONITOR_PIN)
 			cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	}
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_cec_event);
 
@@ -195,10 +196,10 @@ void cec_queue_pin_hpd_event(struct cec_
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_hpd_event);
 
@@ -211,10 +212,10 @@ void cec_queue_pin_5v_event(struct cec_a
 	};
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, &ev, ktime_to_ns(ts));
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 EXPORT_SYMBOL_GPL(cec_queue_pin_5v_event);
 
@@ -286,12 +287,12 @@ static void cec_queue_msg_monitor(struct
 	u32 monitor_mode = valid_la ? CEC_MODE_MONITOR :
 				      CEC_MODE_MONITOR_ALL;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower >= monitor_mode)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /*
@@ -302,12 +303,12 @@ static void cec_queue_msg_followers(stru
 {
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.lock);
+	mutex_lock(&adap->devnode.lock_fhs);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower == CEC_MODE_FOLLOWER)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.lock);
+	mutex_unlock(&adap->devnode.lock_fhs);
 }
 
 /* Notify userspace of an adapter state change. */
@@ -1573,6 +1574,7 @@ void __cec_s_phys_addr(struct cec_adapte
 		/* Disabling monitor all mode should always succeed */
 		if (adap->monitor_all_cnt)
 			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
+		/* serialize adap_enable */
 		mutex_lock(&adap->devnode.lock);
 		if (adap->needs_hpd || list_empty(&adap->devnode.fhs)) {
 			WARN_ON(adap->ops->adap_enable(adap, false));
@@ -1584,14 +1586,16 @@ void __cec_s_phys_addr(struct cec_adapte
 			return;
 	}
 
+	/* serialize adap_enable */
 	mutex_lock(&adap->devnode.lock);
 	adap->last_initiator = 0xff;
 	adap->transmit_in_progress = false;
 
-	if ((adap->needs_hpd || list_empty(&adap->devnode.fhs)) &&
-	    adap->ops->adap_enable(adap, true)) {
-		mutex_unlock(&adap->devnode.lock);
-		return;
+	if (adap->needs_hpd || list_empty(&adap->devnode.fhs)) {
+		if (adap->ops->adap_enable(adap, true)) {
+			mutex_unlock(&adap->devnode.lock);
+			return;
+		}
 	}
 
 	if (adap->monitor_all_cnt &&
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -586,6 +586,7 @@ static int cec_open(struct inode *inode,
 		return err;
 	}
 
+	/* serialize adap_enable */
 	mutex_lock(&devnode->lock);
 	if (list_empty(&devnode->fhs) &&
 	    !adap->needs_hpd &&
@@ -624,7 +625,9 @@ static int cec_open(struct inode *inode,
 	}
 #endif
 
+	mutex_lock(&devnode->lock_fhs);
 	list_add(&fh->list, &devnode->fhs);
+	mutex_unlock(&devnode->lock_fhs);
 	mutex_unlock(&devnode->lock);
 
 	return 0;
@@ -653,8 +656,11 @@ static int cec_release(struct inode *ino
 		cec_monitor_all_cnt_dec(adap);
 	mutex_unlock(&adap->lock);
 
+	/* serialize adap_enable */
 	mutex_lock(&devnode->lock);
+	mutex_lock(&devnode->lock_fhs);
 	list_del(&fh->list);
+	mutex_unlock(&devnode->lock_fhs);
 	if (cec_is_registered(adap) && list_empty(&devnode->fhs) &&
 	    !adap->needs_hpd && adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
 		WARN_ON(adap->ops->adap_enable(adap, false));
--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -169,8 +169,10 @@ static void cec_devnode_unregister(struc
 	devnode->registered = false;
 	devnode->unregistered = true;
 
+	mutex_lock(&devnode->lock_fhs);
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
+	mutex_unlock(&devnode->lock_fhs);
 
 	mutex_unlock(&devnode->lock);
 
@@ -272,6 +274,7 @@ struct cec_adapter *cec_allocate_adapter
 
 	/* adap->devnode initialization */
 	INIT_LIST_HEAD(&adap->devnode.fhs);
+	mutex_init(&adap->devnode.lock_fhs);
 	mutex_init(&adap->devnode.lock);
 
 	adap->kthread = kthread_run(cec_thread_func, adap, "cec-%s", name);
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -26,13 +26,17 @@
  * @dev:	cec device
  * @cdev:	cec character device
  * @minor:	device node minor number
+ * @lock:	lock to serialize open/release and registration
  * @registered:	the device was correctly registered
  * @unregistered: the device was unregistered
+ * @lock_fhs:	lock to control access to @fhs
  * @fhs:	the list of open filehandles (cec_fh)
- * @lock:	lock to control access to this structure
  *
  * This structure represents a cec-related device node.
  *
+ * To add or remove filehandles from @fhs the @lock must be taken first,
+ * followed by @lock_fhs. It is safe to access @fhs if either lock is held.
+ *
  * The @parent is a physical device. It must be set by core or device drivers
  * before registering the node.
  */
@@ -43,10 +47,13 @@ struct cec_devnode {
 
 	/* device info */
 	int minor;
+	/* serialize open/release and registration */
+	struct mutex lock;
 	bool registered;
 	bool unregistered;
+	/* protect access to fhs */
+	struct mutex lock_fhs;
 	struct list_head fhs;
-	struct mutex lock;
 };
 
 struct cec_adapter;


