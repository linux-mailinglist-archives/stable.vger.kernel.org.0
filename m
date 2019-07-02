Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF75DA96
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGCBSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbfGCBSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 21:18:06 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36A621921;
        Tue,  2 Jul 2019 22:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562107799;
        bh=hu3VYyCB+42lcgWJkkG8PsRkbS2OZCumd1Nzu3T6JsQ=;
        h=Date:From:To:Subject:From;
        b=m8gZVqwF0qCNyECFMArkILluBKLY8DmmHEMS3j0LeL7e56/Ks35SClJQou4P3yAnc
         uCRxzdVJNA3iWgo4PXmVVgJhx5B1dTgkxfrpjYdHPNT6T4iwqk73uay5c9z8YqGyy7
         EDpnsL0AC7gshHb/D+23hZ1iL+TaJy4iU+a03W0s=
Date:   Tue, 02 Jul 2019 15:49:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, hch@lst.de,
        hirofumi@mail.parknet.co.jp
Subject:  +
 fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch added to
 -mm tree
Message-ID: <20190702224959.sBsBg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fat: add nobarrier to workaround the strange behavior of device
has been added to the -mm tree.  Its filename is
     fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: add nobarrier to workaround the strange behavior of device

There was a report of strange behavior of device with recent
blkdev_issue_flush() position change.

The following is simplified usbmon trace:

 4203   9.160230         host -> 1.25.1       USBMS 95 SCSI: Synchronize Cache(10) LUN: 0x00 (LBA: 0x00000000, Len: 0)
 4206   9.164911       1.25.1 -> host         USBMS 77 SCSI: Response LUN: 0x00 (Synchronize Cache(10)) (Good)
 4207   9.323927         host -> 1.25.1       USBMS 95 SCSI: Read(10) LUN: 0x00 (LBA: 0x00279950, Len: 240)
 4212   9.327138       1.25.1 -> host         USBMS 77 SCSI: Response LUN: 0x00 (Read(10)) (Good)

[...]

 7323  10.202167         host -> 1.25.1       USBMS 95 SCSI: Synchronize Cache(10) LUN: 0x00 (LBA: 0x00000000, Len: 0)
 7326  10.432266       1.25.1 -> host         USBMS 77 SCSI: Response LUN: 0x00 (Synchronize Cache(10)) (Good)
 7327  10.769092         host -> 1.25.1       USBMS 95 SCSI: Test Unit Ready LUN: 0x00 
 7330  10.769192       1.25.1 -> host         USBMS 77 SCSI: Response LUN: 0x00 (Test Unit Ready) (Good)
 7335  12.849093         host -> 1.25.1       USBMS 95 SCSI: Test Unit Ready LUN: 0x00 
 7338  12.849206       1.25.1 -> host         USBMS 77 SCSI: Response LUN: 0x00 (Test Unit Ready) (Check Condition)
 7339  12.849209         host -> 1.25.1       USBMS 95 SCSI: Request Sense LUN: 0x00

If "Synchronize Cache" command issued then there is idle time, the device
stop to process further commands, and behave as like no media.  (it
returns NOT_READY [MEDIUM NOT PRESENT] for SENSE command, and this
happened on Kindle) [just a guess, the device is trying to detect the
"safe-unplug" operation of Windows or such?]

To work around those devices and provide flexibility, this adds
"barrier"/"nobarrier" mount options to fat driver.

Link: http://lkml.kernel.org/r/87woh5pyqh.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/file.c  |    8 ++++++--
 fs/fat/inode.c |   22 +++++++++++++++++-----
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/fs/fat/fat.h~fat-add-nobarrier-to-workaround-the-strange-behavior-of-device
+++ a/fs/fat/fat.h
@@ -51,6 +51,7 @@ struct fat_mount_options {
 		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
 		 discard:1,	   /* Issue discard requests on deletions */
+		 barrier:1,	   /* Issue FLUSH command */
 		 dos1xfloppy:1;	   /* Assume default BPB for DOS 1.x floppies */
 };
 
--- a/fs/fat/file.c~fat-add-nobarrier-to-workaround-the-strange-behavior-of-device
+++ a/fs/fat/file.c
@@ -194,17 +194,21 @@ static int fat_file_release(struct inode
 int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int err;
 
 	err = __generic_file_fsync(filp, start, end, datasync);
 	if (err)
 		return err;
 
-	err = sync_mapping_buffers(MSDOS_SB(inode->i_sb)->fat_inode->i_mapping);
+	err = sync_mapping_buffers(sbi->fat_inode->i_mapping);
 	if (err)
 		return err;
 
-	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+	if (sbi->options.barrier)
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+	return err;
 }
 
 
--- a/fs/fat/inode.c~fat-add-nobarrier-to-workaround-the-strange-behavior-of-device
+++ a/fs/fat/inode.c
@@ -1011,6 +1011,8 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",nfs=stale_rw");
 	if (opts->discard)
 		seq_puts(m, ",discard");
+	if (!opts->barrier)
+		seq_puts(m, ",nobarrier");
 	if (opts->dos1xfloppy)
 		seq_puts(m, ",dos1xfloppy");
 
@@ -1026,8 +1028,9 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
-	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err, Opt_dos1xfloppy,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_barrier, Opt_nobarrier,
+	Opt_nfs, Opt_time_offset, Opt_nfs_stale_rw, Opt_nfs_nostale_ro,
+	Opt_err, Opt_dos1xfloppy,
 };
 
 static const match_table_t fat_tokens = {
@@ -1057,6 +1060,8 @@ static const match_table_t fat_tokens =
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
 	{Opt_nfs_stale_rw, "nfs"},
 	{Opt_nfs_stale_rw, "nfs=stale_rw"},
 	{Opt_nfs_nostale_ro, "nfs=nostale_ro"},
@@ -1141,6 +1146,7 @@ static int parse_options(struct super_bl
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
 	opts->tz_set = 0;
+	opts->barrier = 1;
 	opts->nfs = 0;
 	opts->errors = FAT_ERRORS_RO;
 	*debug = 0;
@@ -1264,6 +1270,15 @@ static int parse_options(struct super_bl
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_discard:
+			opts->discard = 1;
+			break;
+		case Opt_barrier:
+			opts->barrier = 1;
+			break;
+		case Opt_nobarrier:
+			opts->barrier = 0;
+			break;
 		case Opt_nfs_stale_rw:
 			opts->nfs = FAT_NFS_STALE_RW;
 			break;
@@ -1327,9 +1342,6 @@ static int parse_options(struct super_bl
 		case Opt_rodir:
 			opts->rodir = 1;
 			break;
-		case Opt_discard:
-			opts->discard = 1;
-			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch

