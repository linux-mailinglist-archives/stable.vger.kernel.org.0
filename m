Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933822E3F45
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504198AbgL1Ob6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504483AbgL1Oba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC7592242A;
        Mon, 28 Dec 2020 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165874;
        bh=GlCSjq9/JfH4N0+stI3AArthQmd4sExbBgv03qsxuYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncwzoPVtTv2ZYgWRbgVOUWLM7zDGXSABb3VafV7U5EtJEyD/lWq1GRBE2XWYtSHCs
         0gmdWtB90ues1LrubCls5UlPL5GS95tivax39h4rZD92IwVzLDjehVwrSwdpcUcbUp
         +HhCI9p9/UVS5tkYU0/5mJWkLSTN44qVk1NdbaAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Heming <heming.zhao@suse.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.10 686/717] md/cluster: fix deadlock when node is doing resync job
Date:   Mon, 28 Dec 2020 13:51:24 +0100
Message-Id: <20201228125053.844351460@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

commit bca5b0658020be90b6b504ca514fd80110204f71 upstream.

md-cluster uses MD_CLUSTER_SEND_LOCK to make node can exclusively send msg.
During sending msg, node can concurrently receive msg from another node.
When node does resync job, grab token_lockres:EX may trigger a deadlock:
```
nodeA                       nodeB
--------------------     --------------------
a.
send METADATA_UPDATED
held token_lockres:EX
                         b.
                         md_do_sync
                          resync_info_update
                            send RESYNCING
                             + set MD_CLUSTER_SEND_LOCK
                             + wait for holding token_lockres:EX

                         c.
                         mdadm /dev/md0 --remove /dev/sdg
                          + held reconfig_mutex
                          + send REMOVE
                             + wait_event(MD_CLUSTER_SEND_LOCK)

                         d.
                         recv_daemon //METADATA_UPDATED from A
                          process_metadata_update
                           + (mddev_trylock(mddev) ||
                              MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD)
                             //this time, both return false forever
```
Explaination:
a. A send METADATA_UPDATED
   This will block another node to send msg

b. B does sync jobs, which will send RESYNCING at intervals.
   This will be block for holding token_lockres:EX lock.

c. B do "mdadm --remove", which will send REMOVE.
   This will be blocked by step <b>: MD_CLUSTER_SEND_LOCK is 1.

d. B recv METADATA_UPDATED msg, which send from A in step <a>.
   This will be blocked by step <c>: holding mddev lock, it makes
   wait_event can't hold mddev lock. (btw,
   MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD keep ZERO in this scenario.)

There is a similar deadlock in commit 0ba959774e93
("md-cluster: use sync way to handle METADATA_UPDATED msg")
In that commit, step c is "update sb". This patch step c is
"mdadm --remove".

For fixing this issue, we can refer the solution of function:
metadata_update_start. Which does the same grab lock_token action.
lock_comm can use the same steps to avoid deadlock. By moving
MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD from lock_token to lock_comm.
It enlarge a little bit window of MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
but it is safe & can break deadlock.

Repro steps (I only triggered 3 times with hundreds tests):

two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB.
```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
 --bitmap-chunk=1M
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mkfs.xfs /dev/md0
mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

test script will hung when executing "mdadm --remove".

```
 # dump stacks by "echo t > /proc/sysrq-trigger"
md0_cluster_rec D    0  5329      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? _cond_resched+0x2d/0x40
 ? schedule+0x4a/0xb0
 ? process_metadata_update.isra.0+0xdb/0x140 [md_cluster]
 ? wait_woken+0x80/0x80
 ? process_recvd_msg+0x113/0x1d0 [md_cluster]
 ? recv_daemon+0x9e/0x120 [md_cluster]
 ? md_thread+0x94/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40

mdadm           D    0  5423      1 0x00004004
Call Trace:
 __schedule+0x1f6/0x560
 ? __schedule+0x1fe/0x560
 ? schedule+0x4a/0xb0
 ? lock_comm.isra.0+0x7b/0xb0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? remove_disk+0x4f/0x90 [md_cluster]
 ? hot_remove_disk+0xb1/0x1b0 [md_mod]
 ? md_ioctl+0x50c/0xba0 [md_mod]
 ? wait_woken+0x80/0x80
 ? blkdev_ioctl+0xa2/0x2a0
 ? block_ioctl+0x39/0x40
 ? ksys_ioctl+0x82/0xc0
 ? __x64_sys_ioctl+0x16/0x20
 ? do_syscall_64+0x5f/0x150
 ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

md0_resync      D    0  5425      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? schedule+0x4a/0xb0
 ? dlm_lock_sync+0xa1/0xd0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? lock_token+0x2d/0x90 [md_cluster]
 ? resync_info_update+0x95/0x100 [md_cluster]
 ? raid1_sync_request+0x7d3/0xa40 [raid1]
 ? md_do_sync.cold+0x737/0xc8f [md_mod]
 ? md_thread+0x94/0x160 [md_mod]
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40
```

At last, thanks for Xiao's solution.

Cc: stable@vger.kernel.org
Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Suggested-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md-cluster.c |   67 +++++++++++++++++++++++++++---------------------
 drivers/md/md.c         |    6 ++--
 2 files changed, 42 insertions(+), 31 deletions(-)

--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -664,9 +664,27 @@ out:
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
  */
-static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
+static int lock_token(struct md_cluster_info *cinfo)
 {
-	int error, set_bit = 0;
+	int error;
+
+	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (error) {
+		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
+				__func__, __LINE__, error);
+	} else {
+		/* Lock the receive sequence */
+		mutex_lock(&cinfo->recv_mutex);
+	}
+	return error;
+}
+
+/* lock_comm()
+ * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
+ */
+static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
+{
+	int rv, set_bit = 0;
 	struct mddev *mddev = cinfo->mddev;
 
 	/*
@@ -677,34 +695,19 @@ static int lock_token(struct md_cluster_
 	 */
 	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 				      &cinfo->state)) {
-		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+		rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 					      &cinfo->state);
-		WARN_ON_ONCE(error);
+		WARN_ON_ONCE(rv);
 		md_wakeup_thread(mddev->thread);
 		set_bit = 1;
 	}
-	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
-	if (set_bit)
-		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 
-	if (error)
-		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
-				__func__, __LINE__, error);
-
-	/* Lock the receive sequence */
-	mutex_lock(&cinfo->recv_mutex);
-	return error;
-}
-
-/* lock_comm()
- * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
- */
-static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
-{
 	wait_event(cinfo->wait,
 		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
-
-	return lock_token(cinfo, mddev_locked);
+	rv = lock_token(cinfo);
+	if (set_bit)
+		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+	return rv;
 }
 
 static void unlock_comm(struct md_cluster_info *cinfo)
@@ -784,9 +787,11 @@ static int sendmsg(struct md_cluster_inf
 {
 	int ret;
 
-	lock_comm(cinfo, mddev_locked);
-	ret = __sendmsg(cinfo, cmsg);
-	unlock_comm(cinfo);
+	ret = lock_comm(cinfo, mddev_locked);
+	if (!ret) {
+		ret = __sendmsg(cinfo, cmsg);
+		unlock_comm(cinfo);
+	}
 	return ret;
 }
 
@@ -1061,7 +1066,7 @@ static int metadata_update_start(struct
 		return 0;
 	}
 
-	ret = lock_token(cinfo, 1);
+	ret = lock_token(cinfo);
 	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 	return ret;
 }
@@ -1255,7 +1260,10 @@ static void update_size(struct mddev *md
 	int raid_slot = -1;
 
 	md_update_sb(mddev, 1);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1)) {
+		pr_err("%s: lock_comm failed\n", __func__);
+		return;
+	}
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(METADATA_UPDATED);
@@ -1407,7 +1415,8 @@ static int add_new_disk(struct mddev *md
 	cmsg.type = cpu_to_le32(NEWDISK);
 	memcpy(cmsg.uuid, uuid, 16);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1))
+		return -EAGAIN;
 	ret = __sendmsg(cinfo, &cmsg);
 	if (ret) {
 		unlock_comm(cinfo);
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6948,8 +6948,10 @@ static int hot_remove_disk(struct mddev
 		goto busy;
 
 kick_rdev:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->remove_disk(mddev, rdev);
+	if (mddev_is_clustered(mddev)) {
+		if (md_cluster_ops->remove_disk(mddev, rdev))
+			goto busy;
+	}
 
 	md_kick_rdev_from_array(rdev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);


