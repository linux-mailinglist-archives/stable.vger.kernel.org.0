Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12537C30A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhELPRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhELPOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CEB61936;
        Wed, 12 May 2021 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831865;
        bh=ZBZrFIMMTAS0Z29VpA6ZJ3SVZS1WWcBPWIm10i6yAWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctO9APsk9/7JuuZE7/S1ivd0niDiyfF5otoTWDYWTLzk0+f277c8i0SlvqMxJb02J
         Kx4CEnpl9LBBGvYxvYusRJ9Hlo/QlQmNqsOqEo2jdGtJAqOxGcEoGYiyGEHIqyQaIs
         ngqm63ASgMItCzWwgetttJTCPXEpZO8iwpe7aEYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gang He <ghe@suse.com>,
        Heming Zhao <heming.zhao@suse.com>, Song Liu <song@kernel.org>
Subject: [PATCH 5.10 047/530] md-cluster: fix use-after-free issue when removing rdev
Date:   Wed, 12 May 2021 16:42:37 +0200
Message-Id: <20210512144821.292553783@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heming Zhao <heming.zhao@suse.com>

commit f7c7a2f9a23e5b6e0f5251f29648d0238bb7757e upstream.

md_kick_rdev_from_array will remove rdev, so we should
use rdev_for_each_safe to search list.

How to trigger:

env: Two nodes on kvm-qemu x86_64 VMs (2C2G with 2 iscsi luns).

```
node2=192.168.0.3

for i in {1..20}; do
    echo ==== $i `date` ====;

    mdadm -Ss && ssh ${node2} "mdadm -Ss"
    wipefs -a /dev/sda /dev/sdb

    mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
       /dev/sdb --assume-clean
    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
    mdadm --wait /dev/md0
    ssh ${node2} "mdadm --wait /dev/md0"

    mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
    sleep 1
done
```

Crash stack:

```
stack segment: 0000 [#1] SMP
... ...
RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
... ...
RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 raid1d+0x5c/0xd40 [raid1]
 ? finish_task_switch+0x75/0x2a0
 ? lock_timer_base+0x67/0x80
 ? try_to_del_timer_sync+0x4d/0x80
 ? del_timer_sync+0x41/0x50
 ? schedule_timeout+0x254/0x2d0
 ? md_start_sync+0xe0/0xe0 [md_mod]
 ? md_thread+0x127/0x160 [md_mod]
 md_thread+0x127/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 kthread+0x10d/0x130
 ? kthread_park+0xa0/0xa0
 ret_from_fork+0x1f/0x40
```

Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new reload code")
Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from cluster environment")
Cc: stable@vger.kernel.org
Reviewed-by: Gang He <ghe@suse.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9267,11 +9267,11 @@ void md_check_recovery(struct mddev *mdd
 		}
 
 		if (mddev_is_clustered(mddev)) {
-			struct md_rdev *rdev;
+			struct md_rdev *rdev, *tmp;
 			/* kick the device if another node issued a
 			 * remove disk.
 			 */
-			rdev_for_each(rdev, mddev) {
+			rdev_for_each_safe(rdev, tmp, mddev) {
 				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
@@ -9588,7 +9588,7 @@ err_wq:
 static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
-	struct md_rdev *rdev2;
+	struct md_rdev *rdev2, *tmp;
 	int role, ret;
 	char b[BDEVNAME_SIZE];
 
@@ -9605,7 +9605,7 @@ static void check_sb_changes(struct mdde
 	}
 
 	/* Check for change of roles in the active devices */
-	rdev_for_each(rdev2, mddev) {
+	rdev_for_each_safe(rdev2, tmp, mddev) {
 		if (test_bit(Faulty, &rdev2->flags))
 			continue;
 


