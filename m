Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F61C9DD7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfJCLyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:54:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44289 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729366AbfJCLyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:54:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B5E721D2B;
        Thu,  3 Oct 2019 07:54:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 07:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZVyw+9
        DY35acrdRGiUuCaDkXyetwLFe1/sc6fr0CuQM=; b=l3DhTwPcuKYT90eU0JX+C2
        AmR1KcYFdx19Li0VvpKlh4WBOo9xUdwt31YHp5muigAz104UtAls8kzdmOBFD2Am
        hTsl++C4TvLYfOqehUnBXTc9PAj4U3qQqc/k0FoQ6B/WiFRf+9t8czO4YgmeLJZm
        Tcrz+9hAIU0XXsJ8sw4NmL897dOyi2XGzLI1YBg2luku6g5pKc3gLXm9WX7WgmjI
        P0uEDg3l5hyNBJJQbO/oYGnxqj7iU9NJFhpg7Jnr0uaETciJyxHZpQ/S2B0aQvKg
        Ufijhh7fchBCY+4nmkRQ6sxWHKCUogKo4fFRM9x2Ww2W+f8E9fIowWgfzy1Ktelg
        ==
X-ME-Sender: <xms:iuGVXQk-tuOTswBxBczBxPr16ofGZVP4pRv2nMNHSt3k9A8O90z8Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:i-GVXQRHDcq9u2UobaqApMFBTL2pOFbt9MM7SHUyTQb2ueGSuSlcLw>
    <xmx:i-GVXUEY47kVUCQ9HebC71t7EyO1K2sZXpLmP83zRItgd3CuFX90GA>
    <xmx:i-GVXagQoP1hOnEt-WIR7wsGzq5afu3QTAthwLKygRiGmOx3fXSNkw>
    <xmx:i-GVXQ1nbyaN1ogsVU7D0SxoNY5hSNPfpNF9YrWaG1ggsVaNJqc2Iw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8018D60057;
        Thu,  3 Oct 2019 07:54:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix race setting up and completing qgroup rescan" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:54:47 +0200
Message-ID: <1570103687153167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 13fc1d271a2e3ab8a02071e711add01fab9271f6 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 24 Sep 2019 10:49:54 +0100
Subject: [PATCH] Btrfs: fix race setting up and completing qgroup rescan
 workers

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
      --- tests/btrfs/171.out     2018-09-16 21:30:48.505104287 +0100
      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/171.out.bad      2019-09-19 02:01:36.938486039 +0100
      @@ -1,2 +1,3 @@
       QA output created by 171
      +ERROR: quota rescan failed: Operation now in progress
       Silence is golden
      ...
      (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/171.out /home/fdmanana/git/hub/xfstests/results//btrfs/171.out.bad'  to see the entire diff)

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

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8d3bd799ac7d..52701c1be109 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3166,9 +3166,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!btrfs_fs_closing(fs_info))
-		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
-
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
@@ -3184,16 +3181,30 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
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
@@ -3204,12 +3215,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
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

