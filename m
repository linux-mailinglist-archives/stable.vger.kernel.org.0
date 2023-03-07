Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423AA6AEC1C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCGRwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjCGRwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1425EA5907
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C7A8614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE47C433D2;
        Tue,  7 Mar 2023 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211194;
        bh=7CtELBry5mtomORHx/JS1mGjx/8sLFLfdBGQFqYYanw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU4IQKmcGkKeR3YSQ4XU7YyppFOLiJUIP/flUp3M8kHNF6LH5UA8Ijc3la1rDXSgV
         Ci9OHx7xKTdRxQSc1uqLUKLL3UFA+i8bcPIRWpY9JQKla0WLxTy8jWXCVUqSxqwZ36
         0ETvOMrE0KAyMDRCIWYG2qG2AtFA1MbpoGEYmlyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 0783/1001] btrfs: sysfs: update fs features directory asynchronously
Date:   Tue,  7 Mar 2023 17:59:15 +0100
Message-Id: <20230307170055.725859565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit b7625f461da6734a21c38ba6e7558538a116a2e3 upstream.

[BUG]
Since the introduction of per-fs feature sysfs interface
(/sys/fs/btrfs/<UUID>/features/), the content of that directory is never
updated.

Thus for the following case, that directory will not show the new
features like RAID56:

  # mkfs.btrfs -f $dev1 $dev2 $dev3
  # mount $dev1 $mnt
  # btrfs balance start -f -mconvert=raid5 $mnt
  # ls /sys/fs/btrfs/$uuid/features/
  extended_iref  free_space_tree  no_holes  skinny_metadata

While after unmount and mount, we got the correct features:

  # umount $mnt
  # mount $dev1 $mnt
  # ls /sys/fs/btrfs/$uuid/features/
  extended_iref  free_space_tree  no_holes  raid56 skinny_metadata

[CAUSE]
Because we never really try to update the content of per-fs features/
directory.

We had an attempt to update the features directory dynamically in commit
14e46e04958d ("btrfs: synchronize incompat feature bits with sysfs
files"), but unfortunately it get reverted in commit e410e34fad91
("Revert "btrfs: synchronize incompat feature bits with sysfs files"").
The problem in the original patch is, in the context of
btrfs_create_chunk(), we can not afford to update the sysfs group.

The exported but never utilized function, btrfs_sysfs_feature_update()
is the leftover of such attempt.  As even if we go sysfs_update_group(),
new files will need extra memory allocation, and we have no way to
specify the sysfs update to go GFP_NOFS.

[FIX]
This patch will address the old problem by doing asynchronous sysfs
update in the cleaner thread.

This involves the following changes:

- Make __btrfs_(set|clear)_fs_(incompat|compat_ro) helpers to set
  BTRFS_FS_FEATURE_CHANGED flag when needed

- Update btrfs_sysfs_feature_update() to use sysfs_update_group()
  And drop unnecessary arguments.

- Call btrfs_sysfs_feature_update() in cleaner_kthread
  If we have the BTRFS_FS_FEATURE_CHANGED flag set.

- Wake up cleaner_kthread in btrfs_commit_transaction if we have
  BTRFS_FS_FEATURE_CHANGED flag

By this, all the previously dangerous call sites like
btrfs_create_chunk() need no new changes, as above helpers would
have already set the BTRFS_FS_FEATURE_CHANGED flag.

The real work happens at cleaner_kthread, thus we pay the cost of
delaying the update to sysfs directory, but the delayed time should be
small enough that end user can not distinguish though it might get
delayed if the cleaner thread is busy with removing subvolumes or
defrag.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c     |    3 +++
 fs/btrfs/fs.c          |    4 ++++
 fs/btrfs/fs.h          |    6 ++++++
 fs/btrfs/sysfs.c       |   29 ++++++++---------------------
 fs/btrfs/sysfs.h       |    3 +--
 fs/btrfs/transaction.c |    5 +++++
 6 files changed, 27 insertions(+), 23 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1910,6 +1910,9 @@ static int cleaner_kthread(void *arg)
 			goto sleep;
 		}
 
+		if (test_and_clear_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags))
+			btrfs_sysfs_feature_update(fs_info);
+
 		btrfs_run_delayed_iputs(fs_info);
 
 		again = btrfs_clean_one_deleted_snapshot(fs_info);
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -24,6 +24,7 @@ void __btrfs_set_fs_incompat(struct btrf
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -46,6 +47,7 @@ void __btrfs_clear_fs_incompat(struct bt
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -68,6 +70,7 @@ void __btrfs_set_fs_compat_ro(struct btr
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
 
@@ -90,5 +93,6 @@ void __btrfs_clear_fs_compat_ro(struct b
 				name, flag);
 		}
 		spin_unlock(&fs_info->super_lock);
+		set_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags);
 	}
 }
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -125,6 +125,12 @@ enum {
 	 */
 	BTRFS_FS_NO_OVERCOMMIT,
 
+	/*
+	 * Indicate if we have some features changed, this is mostly for
+	 * cleaner thread to update the sysfs interface.
+	 */
+	BTRFS_FS_FEATURE_CHANGED,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -2272,36 +2272,23 @@ void btrfs_sysfs_del_one_qgroup(struct b
  * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
  * values in superblock. Call after any changes to incompat/compat_ro flags
  */
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set)
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_devices *fs_devs;
 	struct kobject *fsid_kobj;
-	u64 __maybe_unused features;
-	int __maybe_unused ret;
+	int ret;
 
 	if (!fs_info)
 		return;
 
-	/*
-	 * See 14e46e04958df74 and e410e34fad913dd, feature bit updates are not
-	 * safe when called from some contexts (eg. balance)
-	 */
-	features = get_features(fs_info, set);
-	ASSERT(bit & supported_feature_masks[set]);
-
-	fs_devs = fs_info->fs_devices;
-	fsid_kobj = &fs_devs->fsid_kobj;
-
+	fsid_kobj = &fs_info->fs_devices->fsid_kobj;
 	if (!fsid_kobj->state_initialized)
 		return;
 
-	/*
-	 * FIXME: this is too heavy to update just one value, ideally we'd like
-	 * to use sysfs_update_group but some refactoring is needed first.
-	 */
-	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
-	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+	ret = sysfs_update_group(fsid_kobj, &btrfs_feature_attr_group);
+	if (ret < 0)
+		btrfs_warn(fs_info,
+			   "failed to update /sys/fs/btrfs/%pU/features: %d",
+			   fs_info->fs_devices->fsid, ret);
 }
 
 int __init btrfs_init_sysfs(void)
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -19,8 +19,7 @@ void btrfs_sysfs_remove_device(struct bt
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_update_sprout_fsid(struct btrfs_fs_devices *fs_devices);
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set);
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info);
 void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action);
 
 int __init btrfs_init_sysfs(void);
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2464,6 +2464,11 @@ int btrfs_commit_transaction(struct btrf
 	wake_up(&fs_info->transaction_wait);
 	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 
+	/* If we have features changed, wake up the cleaner to update sysfs. */
+	if (test_bit(BTRFS_FS_FEATURE_CHANGED, &fs_info->flags) &&
+	    fs_info->cleaner_kthread)
+		wake_up_process(fs_info->cleaner_kthread);
+
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,


