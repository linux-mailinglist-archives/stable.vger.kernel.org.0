Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C894BCA79D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393064AbfJCQz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393194AbfJCQwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3B22054F;
        Thu,  3 Oct 2019 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121534;
        bh=uhbaKLWlkBR1MGVt+PBtDFsl8Khc+T7Mn7gXEEVFRhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUugjxYgv1zk0+NXEE5oy0LCME5lcV6LGE9ypgBuh596nzpFZanLBH55wCDzManQE
         EE3R982KFinpzGeMjkrhhvZO08ZX09auBzUTGo1ZTu9i2AIthSIHqUQqNFpKK4XeVV
         2gITta4JtxBDf5fAp3XO+7dRP1+KUlrvjqyOvTSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 315/344] Btrfs: fix race setting up and completing qgroup rescan workers
Date:   Thu,  3 Oct 2019 17:54:40 +0200
Message-Id: <20191003154610.198983509@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 13fc1d271a2e3ab8a02071e711add01fab9271f6 upstream.

There is a race between setting up a qgroup rescan worker and completing
a qgroup rescan worker that can lead to callers of the qgroup rescan wait
ioctl to either not wait for the rescan worker to complete or to hang
forever due to missing wake ups. The following diagram shows a sequence
of steps that illustrates the race.

        CPU 1                                                         CPU 2                                  CPU 3

 btrfs_ioctl_quota_rescan()
  btrfs_qgroup_rescan()
   qgroup_rescan_init()
    mutex_lock(&fs_info->qgroup_rescan_lock)
    spin_lock(&fs_info->qgroup_lock)

    fs_info->qgroup_flags |=
      BTRFS_QGROUP_STATUS_FLAG_RESCAN

    init_completion(
      &fs_info->qgroup_rescan_completion)

    fs_info->qgroup_rescan_running = true

    mutex_unlock(&fs_info->qgroup_rescan_lock)
    spin_unlock(&fs_info->qgroup_lock)

    btrfs_init_work()
     --> starts the worker

                                                        btrfs_qgroup_rescan_worker()
                                                         mutex_lock(&fs_info->qgroup_rescan_lock)

                                                         fs_info->qgroup_flags &=
                                                           ~BTRFS_QGROUP_STATUS_FLAG_RESCAN

                                                         mutex_unlock(&fs_info->qgroup_rescan_lock)

                                                         starts transaction, updates qgroup status
                                                         item, etc

                                                                                                           btrfs_ioctl_quota_rescan()
                                                                                                            btrfs_qgroup_rescan()
                                                                                                             qgroup_rescan_init()
                                                                                                              mutex_lock(&fs_info->qgroup_rescan_lock)
                                                                                                              spin_lock(&fs_info->qgroup_lock)

                                                                                                              fs_info->qgroup_flags |=
                                                                                                                BTRFS_QGROUP_STATUS_FLAG_RESCAN

                                                                                                              init_completion(
                                                                                                                &fs_info->qgroup_rescan_completion)

                                                                                                              fs_info->qgroup_rescan_running = true

                                                                                                              mutex_unlock(&fs_info->qgroup_rescan_lock)
                                                                                                              spin_unlock(&fs_info->qgroup_lock)

                                                                                                              btrfs_init_work()
                                                                                                               --> starts another worker

                                                         mutex_lock(&fs_info->qgroup_rescan_lock)

                                                         fs_info->qgroup_rescan_running = false

                                                         mutex_unlock(&fs_info->qgroup_rescan_lock)

							 complete_all(&fs_info->qgroup_rescan_completion)

Before the rescan worker started by the task at CPU 3 completes, if
another task calls btrfs_ioctl_quota_rescan(), it will get -EINPROGRESS
because the flag BTRFS_QGROUP_STATUS_FLAG_RESCAN is set at
fs_info->qgroup_flags, which is expected and correct behaviour.

However if other task calls btrfs_ioctl_quota_rescan_wait() before the
rescan worker started by the task at CPU 3 completes, it will return
immediately without waiting for the new rescan worker to complete,
because fs_info->qgroup_rescan_running is set to false by CPU 2.

This race is making test case btrfs/171 (from fstests) to fail often:

  btrfs/171 9s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/171.out.bad)
#      --- tests/btrfs/171.out     2018-09-16 21:30:48.505104287 +0100
#      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/171.out.bad      2019-09-19 02:01:36.938486039 +0100
#      @@ -1,2 +1,3 @@
#       QA output created by 171
#      +ERROR: quota rescan failed: Operation now in progress
#       Silence is golden
#      ...
#      (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/171.out /home/fdmanana/git/hub/xfstests/results//btrfs/171.out.bad'  to see the entire diff)

That is because the test calls the btrfs-progs commands "qgroup quota
rescan -w", "qgroup assign" and "qgroup remove" in a sequence that makes
calls to the rescan start ioctl fail with -EINPROGRESS (note the "btrfs"
commands 'qgroup assign' and 'qgroup remove' often call the rescan start
ioctl after calling the qgroup assign ioctl,
btrfs_ioctl_qgroup_assign()), since previous waits didn't actually wait
for a rescan worker to complete.

Another problem the race can cause is missing wake ups for waiters,
since the call to complete_all() happens outside a critical section and
after clearing the flag BTRFS_QGROUP_STATUS_FLAG_RESCAN. In the sequence
diagram above, if we have a waiter for the first rescan task (executed
by CPU 2), then fs_info->qgroup_rescan_completion.wait is not empty, and
if after the rescan worker clears BTRFS_QGROUP_STATUS_FLAG_RESCAN and
before it calls complete_all() against
fs_info->qgroup_rescan_completion, the task at CPU 3 calls
init_completion() against fs_info->qgroup_rescan_completion which
re-initilizes its wait queue to an empty queue, therefore causing the
rescan worker at CPU 2 to call complete_all() against an empty queue,
never waking up the task waiting for that rescan worker.

Fix this by clearing BTRFS_QGROUP_STATUS_FLAG_RESCAN and setting
fs_info->qgroup_rescan_running to false in the same critical section,
delimited by the mutex fs_info->qgroup_rescan_lock, as well as doing the
call to complete_all() in that same critical section. This gives the
protection needed to avoid rescan wait ioctl callers not waiting for a
running rescan worker and the lost wake ups problem, since setting that
rescan flag and boolean as well as initializing the wait queue is done
already in a critical section delimited by that mutex (at
qgroup_rescan_init()).

Fixes: 57254b6ebce4ce ("Btrfs: add ioctl to wait for qgroup rescan completion")
Fixes: d2c609b834d62f ("btrfs: properly track when rescan worker is running")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3154,9 +3154,6 @@ out:
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!btrfs_fs_closing(fs_info))
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
-
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
@@ -3172,16 +3169,30 @@ out:
 	trans = btrfs_start_transaction(fs_info->quota_root, 1);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
+		trans = NULL;
 		btrfs_err(fs_info,
 			  "fail to start transaction for status update: %d",
 			  err);
-		goto done;
 	}
-	ret = update_qgroup_status_item(trans);
-	if (ret < 0) {
-		err = ret;
-		btrfs_err(fs_info, "fail to update qgroup status: %d", err);
+
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	if (!btrfs_fs_closing(fs_info))
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	if (trans) {
+		ret = update_qgroup_status_item(trans);
+		if (ret < 0) {
+			err = ret;
+			btrfs_err(fs_info, "fail to update qgroup status: %d",
+				  err);
+		}
 	}
+	fs_info->qgroup_rescan_running = false;
+	complete_all(&fs_info->qgroup_rescan_completion);
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
+	if (!trans)
+		return;
+
 	btrfs_end_transaction(trans);
 
 	if (btrfs_fs_closing(fs_info)) {
@@ -3192,12 +3203,6 @@ out:
 	} else {
 		btrfs_err(fs_info, "qgroup scan failed with %d", err);
 	}
-
-done:
-	mutex_lock(&fs_info->qgroup_rescan_lock);
-	fs_info->qgroup_rescan_running = false;
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
-	complete_all(&fs_info->qgroup_rescan_completion);
 }
 
 /*


