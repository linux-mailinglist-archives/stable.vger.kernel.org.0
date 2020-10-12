Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4A28AD96
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 07:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgJLF0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 01:26:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgJLF0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 01:26:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09C5P1OA165312;
        Mon, 12 Oct 2020 05:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=N3JXaHd4ZNPF7pM7AW5jhSXgQZWaM2NIxfViX0SmQx8=;
 b=lvZXjxNKFsZgqbvZj0uij0AaGSrUekdR8skIxavf9kDNzem4X0HGlmtUFvYsIz0ME93N
 wuIxTPmWRy224ykV6nyTbIGxh4RliZjXDJ+U/Xbp3Itf5MUJwH1bXy9id8bKD5kPqMhl
 eRwOILpgLJXcoqF5fwAwFNG9cu4bpcooJyA2U9kWLjYnvVXqjSQatKD9ZVpQR5NehnV9
 bl7eYmsWPe9r5s/bK2uxR6FTzK3k8pi81SyjmXD/xthRMW24uTV6QZUYkD8582lj/5y8
 RPX9iECcdk83yLvNqP95lHYsnb1qMj7VCRoEwEDlt8B/ASGy3Auq1kNYQXh34JsTerMD 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkb93g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 05:26:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09C5PQRG086693;
        Mon, 12 Oct 2020 05:26:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by081b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 05:26:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09C5Qjop003652;
        Mon, 12 Oct 2020 05:26:45 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Oct 2020 22:26:44 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: [PATCH v2 add prerequisite-patch-id] btrfs: fix devid 0 without a replace item by failing the mount
Date:   Mon, 12 Oct 2020 13:26:36 +0800
Message-Id: <818ed3e0e42f309c5cda280ac38747c5544730ea.1602479935.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006131223.ZARmb7ib7FFlQegUxNdnbR-oDUA2bmOQwLzVeGJw3Kw@z>
References: <20201006131223.ZARmb7ib7FFlQegUxNdnbR-oDUA2bmOQwLzVeGJw3Kw@z>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9771 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010120047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9771 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010120047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If there is a BTRFS_DEV_REPLACE_DEVID without a replace item, then
it means some device is trying to attack or may be corrupted. Fail the
mount so that the user can remove the attacking or fix the corrupted
device.

As of now if BTRFS_DEV_REPLACE_DEVID is present without the replace
item, in __btrfs_free_extra_devids() we determine that there is an
extra device, and free those extra devices but continue to mount the
device.
However, we were wrong in keeping tack of the rw_devices so the syzbot
testcase failed as below [1].

[1]
WARNING: CPU: 1 PID: 3612 at fs/btrfs/volumes.c:1166 close_fs_devices.part.0+0x607/0x800 fs/btrfs/volumes.c:1166
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 3612 Comm: syz-executor.2 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:close_fs_devices.part.0+0x607/0x800 fs/btrfs/volumes.c:1166
Code: 0f b6 04 02 84 c0 74 02 7e 33 48 8b 44 24 18 c6 80 30 01 00 00 00 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 99 ce 6a fe <0f> 0b e9 71 ff ff ff e8 8d ce 6a fe 0f 0b e9 20 ff ff ff e8 d1 d5
RSP: 0018:ffffc900091777e0 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffffffffffffffff RCX: ffffc9000c8b7000
RDX: 0000000000040000 RSI: ffffffff83097f47 RDI: 0000000000000007
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff8880988a187f
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88809593a130
R13: ffff88809593a1ec R14: ffff8880988a1908 R15: ffff88809593a050
 close_fs_devices fs/btrfs/volumes.c:1193 [inline]
 btrfs_close_devices+0x95/0x1f0 fs/btrfs/volumes.c:1179
 open_ctree+0x4984/0x4a2d fs/btrfs/disk-io.c:3434
 btrfs_fill_super fs/btrfs/super.c:1316 [inline]
 btrfs_mount_root.cold+0x14/0x165 fs/btrfs/super.c:1672

The fix here is, when we determine that there isn't a replace item
then fail the mount if there is a replace target device (devid 0).

Reported-by: syzbot+4cfe71a4da060be47502@syzkaller.appspotmail.com
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Depends on the patches
 btrfs: drop never met condition of disk_total_bytes == 0
 btrfs: fix btrfs_find_device unused arg seed
If these patches aren't integrated yet, then please add the last arg in
the function btrfs_find_device(). Any value is fine as it doesn't care.

fstest case will follow.

v2: changed title
    old: btrfs: fix rw_devices count in __btrfs_free_extra_devids

    In btrfs_init_dev_replace() try to match the presence of replace_item
    to the BTRFS_DEV_REPLACE_DEVID device. If fails then fail the
    mount. So drop the similar check in __btrfs_free_extra_devids().

 fs/btrfs/dev-replace.c | 26 ++++++++++++++++++++++++--
 fs/btrfs/volumes.c     | 26 +++++++-------------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9340d03661cd..e2b7ae386224 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -91,6 +91,17 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 	ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
 	if (ret) {
 no_valid_dev_replace_entry_found:
+		/*
+		 * We don't have a replace item or it's corrupted.
+		 * If there is a replace target, fail the mount.
+		 */
+		if (btrfs_find_device(fs_info->fs_devices,
+				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+			btrfs_err(fs_info,
+			"found replace target device without a replace item");
+			ret = -EIO;
+			goto out;
+		}
 		ret = 0;
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
@@ -143,8 +154,19 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED:
-		dev_replace->srcdev = NULL;
-		dev_replace->tgtdev = NULL;
+		/*
+		 * We don't have an active replace item but if there is a
+		 * replace target, fail the mount.
+		 */
+		if (btrfs_find_device(fs_info->fs_devices,
+				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+			btrfs_err(fs_info,
+			"replace devid present without an active replace item");
+			ret = -EIO;
+		} else {
+			dev_replace->srcdev = NULL;
+			dev_replace->tgtdev = NULL;
+		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88655d60a94..0c6049f9ace3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1056,22 +1056,13 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 			continue;
 		}
 
-		if (device->devid == BTRFS_DEV_REPLACE_DEVID) {
-			/*
-			 * In the first step, keep the device which has
-			 * the correct fsid and the devid that is used
-			 * for the dev_replace procedure.
-			 * In the second step, the dev_replace state is
-			 * read from the device tree and it is known
-			 * whether the procedure is really active or
-			 * not, which means whether this device is
-			 * used or whether it should be removed.
-			 */
-			if (step == 0 || test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-						  &device->dev_state)) {
-				continue;
-			}
-		}
+		/*
+		 * We have already validated the presence of BTRFS_DEV_REPLACE_DEVID,
+		 * in btrfs_init_dev_replace() so just continue.
+		 */
+		if (device->devid == BTRFS_DEV_REPLACE_DEVID)
+			continue;
+
 		if (device->bdev) {
 			blkdev_put(device->bdev, device->mode);
 			device->bdev = NULL;
@@ -1080,9 +1071,6 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 		if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 			list_del_init(&device->dev_alloc_list);
 			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-				      &device->dev_state))
-				fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;

base-commit: 1fd4033dd011a3525bacddf37ab9eac425d25c4f
prerequisite-patch-id: 0d3416ab45d924135a9095c3d9c68646f7c5e476
prerequisite-patch-id: 51a2e9b4b78bf808279307d03436a33063d42130
-- 
2.25.1

