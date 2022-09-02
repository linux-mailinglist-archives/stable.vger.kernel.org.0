Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD7C5AAFDC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiIBMou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiIBMnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931A1EC4EF;
        Fri,  2 Sep 2022 05:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84DB6B82AA0;
        Fri,  2 Sep 2022 12:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D895C433D6;
        Fri,  2 Sep 2022 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121845;
        bh=3zvCWS6sOwZGE2ccYnr97ZJIx0tpowQ+AOrzJspelSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rytm21RkNFQeK4pyCkFaHhrtyzGQNrQkVoDqNcI2cqV+rzAMbuwxXIr8gcVj/EZjq
         ftGg56r3t+9PtT5nfTU5L2H78opto5rgo/QXpdQLn15xI0+mqGijtBOyn1AKj4SwWL
         DrgQCxLCjPIC0YIdrjwW59DIlib45bIX2LqvZrzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/77] btrfs: do not pin logs too early during renames
Date:   Fri,  2 Sep 2022 14:19:12 +0200
Message-Id: <20220902121405.775494630@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit bd54f381a12ac695593271a663d36d14220215b2 ]

During renames we pin the logs of the roots a bit too early, before the
calls to btrfs_insert_inode_ref(). We can pin the logs after those calls,
since those will not change anything in a log tree.

In a scenario where we have multiple and diverse filesystem operations
running in parallel, those calls can take a significant amount of time,
due to lock contention on extent buffers, and delay log commits from other
tasks for longer than necessary.

So just pin logs after calls to btrfs_insert_inode_ref() and right before
the first operation that can update a log tree.

The following script that uses dbench was used for testing:

  $ cat dbench-test.sh
  #!/bin/bash

  DEV=/dev/nvme0n1
  MNT=/mnt/nvme0n1
  MOUNT_OPTIONS="-o ssd"
  MKFS_OPTIONS="-m single -d single"

  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  umount $DEV &> /dev/null
  mkfs.btrfs -f $MKFS_OPTIONS $DEV
  mount $MOUNT_OPTIONS $DEV $MNT

  dbench -D $MNT -t 120 16

  umount $MNT

The tests were run on a machine with 12 cores, 64G of RAN, a NVMe device
and using a non-debug kernel config (Debian's default config).

The results compare a branch without this patch and without the previous
patch in the series, that has the subject:

 "btrfs: eliminate some false positives when checking if inode was logged"

Versus the same branch with these two patches applied.

dbench with 8 clients, results before:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    4391359     0.009   249.745
 Close        3225882     0.001     3.243
 Rename        185953     0.065   240.643
 Unlink        886669     0.049   249.906
 Deltree          112     2.455   217.433
 Mkdir             56     0.002     0.004
 Qpathinfo    3980281     0.004     3.109
 Qfileinfo     697579     0.001     0.187
 Qfsinfo       729780     0.002     2.424
 Sfileinfo     357764     0.004     1.415
 Find         1538861     0.016     4.863
 WriteX       2189666     0.010     3.327
 ReadX        6883443     0.002     0.729
 LockX          14298     0.002     0.073
 UnlockX        14298     0.001     0.042
 Flush         307777     2.447   303.663

Throughput 1149.6 MB/sec  8 clients  8 procs  max_latency=303.666 ms

dbench with 8 clients, results after:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    4269920     0.009   213.532
 Close        3136653     0.001     0.690
 Rename        180805     0.082   213.858
 Unlink        862189     0.050   172.893
 Deltree          112     2.998   218.328
 Mkdir             56     0.002     0.003
 Qpathinfo    3870158     0.004     5.072
 Qfileinfo     678375     0.001     0.194
 Qfsinfo       709604     0.002     0.485
 Sfileinfo     347850     0.004     1.304
 Find         1496310     0.017     5.504
 WriteX       2129613     0.010     2.882
 ReadX        6693066     0.002     1.517
 LockX          13902     0.002     0.075
 UnlockX        13902     0.001     0.055
 Flush         299276     2.511   220.189

Throughput 1187.33 MB/sec  8 clients  8 procs  max_latency=220.194 ms

+3.2% throughput, -31.8% max latency

dbench with 16 clients, results before:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    5978334     0.028   156.507
 Close        4391598     0.001     1.345
 Rename        253136     0.241   155.057
 Unlink       1207220     0.182   257.344
 Deltree          160     6.123    36.277
 Mkdir             80     0.003     0.005
 Qpathinfo    5418817     0.012     6.867
 Qfileinfo     949929     0.001     0.941
 Qfsinfo       993560     0.002     1.386
 Sfileinfo     486904     0.004     2.829
 Find         2095088     0.059     8.164
 WriteX       2982319     0.017     9.029
 ReadX        9371484     0.002     4.052
 LockX          19470     0.002     0.461
 UnlockX        19470     0.001     0.990
 Flush         418936     2.740   347.902

Throughput 1495.31 MB/sec  16 clients  16 procs  max_latency=347.909 ms

dbench with 16 clients, results after:

 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 NTCreateX    5711833     0.029   131.240
 Close        4195897     0.001     1.732
 Rename        241849     0.204   147.831
 Unlink       1153341     0.184   231.322
 Deltree          160     6.086    30.198
 Mkdir             80     0.003     0.021
 Qpathinfo    5177011     0.012     7.150
 Qfileinfo     907768     0.001     0.793
 Qfsinfo       949205     0.002     1.431
 Sfileinfo     465317     0.004     2.454
 Find         2001541     0.058     7.819
 WriteX       2850661     0.017     9.110
 ReadX        8952289     0.002     3.991
 LockX          18596     0.002     0.655
 UnlockX        18596     0.001     0.179
 Flush         400342     2.879   293.607

Throughput 1565.73 MB/sec  16 clients  16 procs  max_latency=293.611 ms

+4.6% throughput, -16.9% max latency

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7755a0362a3ad..20c5db8ef8427 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9751,8 +9751,6 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		btrfs_pin_log_trans(root);
-		root_log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
@@ -9768,8 +9766,6 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		btrfs_pin_log_trans(dest);
-		dest_log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, root,
 					     old_dentry->d_name.name,
 					     old_dentry->d_name.len,
@@ -9797,6 +9793,29 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 				BTRFS_I(new_inode), 1);
 	}
 
+	/*
+	 * Now pin the logs of the roots. We do it to ensure that no other task
+	 * can sync the logs while we are in progress with the rename, because
+	 * that could result in an inconsistency in case any of the inodes that
+	 * are part of this rename operation were logged before.
+	 *
+	 * We pin the logs even if at this precise moment none of the inodes was
+	 * logged before. This is because right after we checked for that, some
+	 * other task fsyncing some other inode not involved with this rename
+	 * operation could log that one of our inodes exists.
+	 *
+	 * We don't need to pin the logs before the above calls to
+	 * btrfs_insert_inode_ref(), since those don't ever need to change a log.
+	 */
+	if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		btrfs_pin_log_trans(root);
+		root_log_pinned = true;
+	}
+	if (new_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		btrfs_pin_log_trans(dest);
+		dest_log_pinned = true;
+	}
+
 	/* src is a subvolume */
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
@@ -10046,8 +10065,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		btrfs_pin_log_trans(root);
-		log_pinned = true;
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
@@ -10071,6 +10088,25 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else {
+		/*
+		 * Now pin the log. We do it to ensure that no other task can
+		 * sync the log while we are in progress with the rename, as
+		 * that could result in an inconsistency in case any of the
+		 * inodes that are part of this rename operation were logged
+		 * before.
+		 *
+		 * We pin the log even if at this precise moment none of the
+		 * inodes was logged before. This is because right after we
+		 * checked for that, some other task fsyncing some other inode
+		 * not involved with this rename operation could log that one of
+		 * our inodes exists.
+		 *
+		 * We don't need to pin the logs before the above call to
+		 * btrfs_insert_inode_ref(), since that does not need to change
+		 * a log.
+		 */
+		btrfs_pin_log_trans(root);
+		log_pinned = true;
 		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
 					BTRFS_I(d_inode(old_dentry)),
 					old_dentry->d_name.name,
-- 
2.35.1



