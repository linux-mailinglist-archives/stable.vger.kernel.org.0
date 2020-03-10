Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71B17FCEC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgCJM6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729078AbgCJM6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD8E02253D;
        Tue, 10 Mar 2020 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845093;
        bh=5olWCOjINHzGMYVDAMlBexLkun+hzROEE/n9DsBRV1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX2ERByqKiNEASQMb0wmJZks9DlsdMQWxv/QGk4/3FXcgIfqNy3YPOgdD2WDbvMD1
         yUTalkslMycb9hujE9eIT6ZvbT242V5E2wYiaaMjPqrYOGq6ztk5JKD60g5UIUoLZ7
         RLa4MZompZ+fywyH6B1lAk8ioOxlTuBWWD9Q4k6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.5 059/189] binder: prevent UAF for binderfs devices
Date:   Tue, 10 Mar 2020 13:38:16 +0100
Message-Id: <20200310123645.548659561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 2669b8b0c798fbe1a31d49e07aa33233d469ad9b upstream.

On binder_release(), binder_defer_work(proc, BINDER_DEFERRED_RELEASE) is
called which punts the actual cleanup operation to a workqueue. At some
point, binder_deferred_func() will be called which will end up calling
binder_deferred_release() which will retrieve and cleanup the
binder_context attach to this struct binder_proc.

If we trace back where this binder_context is attached to binder_proc we
see that it is set in binder_open() and is taken from the struct
binder_device it is associated with. This obviously assumes that the
struct binder_device that context is attached to is _never_ freed. While
that might be true for devtmpfs binder devices it is most certainly
wrong for binderfs binder devices.

So, assume binder_open() is called on a binderfs binder devices. We now
stash away the struct binder_context associated with that struct
binder_devices:
	proc->context = &binder_dev->context;
	/* binderfs stashes devices in i_private */
	if (is_binderfs_device(nodp)) {
		binder_dev = nodp->i_private;
		info = nodp->i_sb->s_fs_info;
		binder_binderfs_dir_entry_proc = info->proc_log_dir;
	} else {
	.
	.
	.
	proc->context = &binder_dev->context;

Now let's assume that the binderfs instance for that binder devices is
shutdown via umount() and/or the mount namespace associated with it goes
away. As long as there is still an fd open for that binderfs binder
device things are fine. But let's assume we now close the last fd for
that binderfs binder device. Now binder_release() is called and punts to
the workqueue. Assume that the workqueue has quite a bit of stuff to do
and doesn't get to cleaning up the struct binder_proc and the associated
struct binder_context with it for that binderfs binder device right
away. In the meantime, the VFS is killing the super block and is
ultimately calling sb->evict_inode() which means it will call
binderfs_evict_inode() which does:

static void binderfs_evict_inode(struct inode *inode)
{
	struct binder_device *device = inode->i_private;
	struct binderfs_info *info = BINDERFS_I(inode);

	clear_inode(inode);

	if (!S_ISCHR(inode->i_mode) || !device)
		return;

	mutex_lock(&binderfs_minors_mutex);
	--info->device_count;
	ida_free(&binderfs_minors, device->miscdev.minor);
	mutex_unlock(&binderfs_minors_mutex);

	kfree(device->context.name);
	kfree(device);
}

thereby freeing the struct binder_device including struct
binder_context.

Now the workqueue finally has time to get around to cleaning up struct
binder_proc and is now trying to access the associate struct
binder_context. Since it's already freed it will OOPs.

Fix this by holding an additional reference to the inode that is only
released once the workqueue is done cleaning up struct binder_proc. This
is an easy alternative to introducing separate refcounting on struct
binder_device which we can always do later if it becomes necessary.

This is an alternative fix to 51d8a7eca677 ("binder: prevent UAF read in
print_binder_transaction_log_entry()").

Fixes: 3ad20fe393b3 ("binder: implement binderfs")
Fixes: 03e2e07e3814 ("binder: Make transaction_log available in binderfs")
Related : 51d8a7eca677 ("binder: prevent UAF read in print_binder_transaction_log_entry()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c          |    5 ++++-
 drivers/android/binder_internal.h |   13 +++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5219,7 +5219,7 @@ static int binder_open(struct inode *nod
 	proc->default_priority = task_nice(current);
 	/* binderfs stashes devices in i_private */
 	if (is_binderfs_device(nodp)) {
-		binder_dev = nodp->i_private;
+		binder_dev = binderfs_device_get(nodp->i_private);
 		info = nodp->i_sb->s_fs_info;
 		binder_binderfs_dir_entry_proc = info->proc_log_dir;
 	} else {
@@ -5403,6 +5403,7 @@ static int binder_node_release(struct bi
 static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_context *context = proc->context;
+	struct binder_device *device;
 	struct rb_node *n;
 	int threads, nodes, incoming_refs, outgoing_refs, active_transactions;
 
@@ -5482,6 +5483,8 @@ static void binder_deferred_release(stru
 		     outgoing_refs, active_transactions);
 
 	binder_proc_dec_tmpref(proc);
+	device = container_of(proc->context, struct binder_device, context);
+	binderfs_device_put(device);
 }
 
 static void binder_deferred_func(struct work_struct *work)
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -35,6 +35,19 @@ struct binder_device {
 	struct inode *binderfs_inode;
 };
 
+static inline struct binder_device *binderfs_device_get(struct binder_device *dev)
+{
+	if (dev->binderfs_inode)
+		ihold(dev->binderfs_inode);
+	return dev;
+}
+
+static inline void binderfs_device_put(struct binder_device *dev)
+{
+	if (dev->binderfs_inode)
+		iput(dev->binderfs_inode);
+}
+
 /**
  * binderfs_mount_opts - mount options for binderfs
  * @max: maximum number of allocatable binderfs binder devices


