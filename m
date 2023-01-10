Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89D6648F6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbjAJSQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239026AbjAJSQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5280AB56
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEDC66184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5E5C433EF;
        Tue, 10 Jan 2023 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374456;
        bh=NQRUEcQcuz5S5aSLDrMPMD5BIHVD9Uv8tr+Mu2PXt/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rUAc6eI1oOv/OhuIisqvAIrJJV0GOYIZA0/cxvJrANwcT1v2ti6/FvKKZDsPRRaZ
         v/BYg2tiB+/ZS5haUSS7Kil6HEoxUZ28KwOdk0xPtp6V66CWeyI+2IwB2u8t9voO2m
         mvyqGJqaz5JlHQ1xOh/1Wis0h9BU3nvQaevkJxow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chung-Chiang Cheng <shepjeng@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 007/159] btrfs: fix compat_ro checks against remount
Date:   Tue, 10 Jan 2023 19:02:35 +0100
Message-Id: <20230110180018.533748660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 2ba48b20049b5a76f34a85f853c9496d1b10533a upstream.

[BUG]
Even with commit 81d5d61454c3 ("btrfs: enhance unsupported compat RO
flags handling"), btrfs can still mount a fs with unsupported compat_ro
flags read-only, then remount it RW:

  # btrfs ins dump-super /dev/loop0 | grep compat_ro_flags -A 3
  compat_ro_flags		0x403
			( FREE_SPACE_TREE |
			  FREE_SPACE_TREE_VALID |
			  unknown flag: 0x400 )

  # mount /dev/loop0 /mnt/btrfs
  mount: /mnt/btrfs: wrong fs type, bad option, bad superblock on /dev/loop0, missing codepage or helper program, or other error.
         dmesg(1) may have more information after failed mount system call.
  ^^^ RW mount failed as expected ^^^

  # dmesg -t | tail -n5
  loop0: detected capacity change from 0 to 1048576
  BTRFS: device fsid cb5b82f5-0fdd-4d81-9b4b-78533c324afa devid 1 transid 7 /dev/loop0 scanned by mount (1146)
  BTRFS info (device loop0): using crc32c (crc32c-intel) checksum algorithm
  BTRFS info (device loop0): using free space tree
  BTRFS error (device loop0): cannot mount read-write because of unknown compat_ro features (0x403)
  BTRFS error (device loop0): open_ctree failed

  # mount /dev/loop0 -o ro /mnt/btrfs
  # mount -o remount,rw /mnt/btrfs
  ^^^ RW remount succeeded unexpectedly ^^^

[CAUSE]
Currently we use btrfs_check_features() to check compat_ro flags against
our current mount flags.

That function get reused between open_ctree() and btrfs_remount().

But for btrfs_remount(), the super block we passed in still has the old
mount flags, thus btrfs_check_features() still believes we're mounting
read-only.

[FIX]
Replace the existing @sb argument with @is_rw_mount.

As originally we only use @sb to determine if the mount is RW.

Now it's callers' responsibility to determine if the mount is RW, and
since there are only two callers, the check is pretty simple:

- caller in open_ctree()
  Just pass !sb_rdonly().

- caller in btrfs_remount()
  Pass !(*flags & SB_RDONLY), as our check should be against the new
  flags.

Now we can correctly reject the RW remount:

  # mount /dev/loop0 -o ro /mnt/btrfs
  # mount -o remount,rw /mnt/btrfs
  mount: /mnt/btrfs: mount point not mounted or bad option.
         dmesg(1) may have more information after failed mount system call.
  # dmesg -t | tail -n 1
  BTRFS error (device loop0: state M): cannot mount read-write because of unknown compat_ro features (0x403)

Reported-by: Chung-Chiang Cheng <shepjeng@gmail.com>
Fixes: 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    8 +++++---
 fs/btrfs/disk-io.h |    2 +-
 fs/btrfs/super.c   |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3296,6 +3296,8 @@ out:
 /*
  * Do various sanity and dependency checks of different features.
  *
+ * @is_rw_mount:	If the mount is read-write.
+ *
  * This is the place for less strict checks (like for subpage or artificial
  * feature dependencies).
  *
@@ -3306,7 +3308,7 @@ out:
  * (space cache related) can modify on-disk format like free space tree and
  * screw up certain feature dependencies.
  */
-int btrfs_check_features(struct btrfs_fs_info *fs_info, struct super_block *sb)
+int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 {
 	struct btrfs_super_block *disk_super = fs_info->super_copy;
 	u64 incompat = btrfs_super_incompat_flags(disk_super);
@@ -3345,7 +3347,7 @@ int btrfs_check_features(struct btrfs_fs
 	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE)
 		incompat |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 
-	if (compat_ro_unsupp && !sb_rdonly(sb)) {
+	if (compat_ro_unsupp && is_rw_mount) {
 		btrfs_err(fs_info,
 	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
 		       compat_ro);
@@ -3548,7 +3550,7 @@ int __cold open_ctree(struct super_block
 		goto fail_alloc;
 	}
 
-	ret = btrfs_check_features(fs_info, sb);
+	ret = btrfs_check_features(fs_info, !sb_rdonly(sb));
 	if (ret < 0) {
 		err = ret;
 		goto fail_alloc;
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -50,7 +50,7 @@ int __cold open_ctree(struct super_block
 void __cold close_ctree(struct btrfs_fs_info *fs_info);
 int btrfs_validate_super(struct btrfs_fs_info *fs_info,
 			 struct btrfs_super_block *sb, int mirror_num);
-int btrfs_check_features(struct btrfs_fs_info *fs_info, struct super_block *sb);
+int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount);
 int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev);
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2014,7 +2014,7 @@ static int btrfs_remount(struct super_bl
 	if (ret)
 		goto restore;
 
-	ret = btrfs_check_features(fs_info, sb);
+	ret = btrfs_check_features(fs_info, !(*flags & SB_RDONLY));
 	if (ret < 0)
 		goto restore;
 


