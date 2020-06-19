Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F38200EB8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392034AbgFSPKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391566AbgFSPKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E623E2186A;
        Fri, 19 Jun 2020 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579433;
        bh=LlEmdwwdSR30dYv/6jAzupX03aWWG4GzpIKmnzZutfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8fn4C7h0YZ1KNgbPqlACUn6Re05tFsIn7Dxu0crzKkCw8XRo+gsaLTDavhxuk5oS
         tCkuVSMYH8SBjmrthqzLlIT9jtA3Vwzh9S3A+/pQpB3iTyBz/p4v5106QYBjfl6Pik
         KrnttlB8EJfli9KtsZ70WQ4rW+3T2Z2MT1SvJh5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/261] btrfs: qgroup: mark qgroup inconsistent if were inherting snapshot to a new qgroup
Date:   Fri, 19 Jun 2020 16:32:25 +0200
Message-Id: <20200619141656.276038496@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit cbab8ade585a18c4334b085564d9d046e01a3f70 ]

[BUG]
For the following operation, qgroup is guaranteed to be screwed up due
to snapshot adding to a new qgroup:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt
  # btrfs qgroup en $mnt
  # btrfs subv create $mnt/src
  # xfs_io -f -c "pwrite 0 1m" $mnt/src/file
  # sync
  # btrfs qgroup create 1/0 $mnt/src
  # btrfs subv snapshot -i 1/0 $mnt/src $mnt/snapshot
  # btrfs qgroup show -prce $mnt/src
  qgroupid         rfer         excl     max_rfer     max_excl parent  child
  --------         ----         ----     --------     -------- ------  -----
  0/5          16.00KiB     16.00KiB         none         none ---     ---
  0/257         1.02MiB     16.00KiB         none         none ---     ---
  0/258         1.02MiB     16.00KiB         none         none 1/0     ---
  1/0             0.00B        0.00B         none         none ---     0/258
	        ^^^^^^^^^^^^^^^^^^^^

[CAUSE]
The problem is in btrfs_qgroup_inherit(), we don't have good enough
check to determine if the new relation would break the existing
accounting.

Unlike btrfs_add_qgroup_relation(), which has proper check to determine
if we can do quick update without a rescan, in btrfs_qgroup_inherit() we
can even assign a snapshot to multiple qgroups.

[FIX]
Fix it by manually marking qgroup inconsistent for snapshot inheritance.

For subvolume creation, since all its extents are exclusively owned, we
don't need to rescan.

In theory, we should call relation check like quick_update_accounting()
when doing qgroup inheritance and inform user about qgroup accounting
inconsistency.

But we don't have good mechanism to relay that back to the user in the
snapshot creation context, thus we can only silently mark the qgroup
inconsistent.

Anyway, user shouldn't use qgroup inheritance during snapshot creation,
and should add qgroup relationship after snapshot creation by 'btrfs
qgroup assign', which has a much better UI to inform user about qgroup
inconsistent and kick in rescan automatically.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 590defdf8860..b94f6f99e90d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2636,6 +2636,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *srcgroup;
 	struct btrfs_qgroup *dstgroup;
+	bool need_rescan = false;
 	u32 level_size = 0;
 	u64 nums;
 
@@ -2779,6 +2780,13 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 				goto unlock;
 		}
 		++i_qgroups;
+
+		/*
+		 * If we're doing a snapshot, and adding the snapshot to a new
+		 * qgroup, the numbers are guaranteed to be incorrect.
+		 */
+		if (srcid)
+			need_rescan = true;
 	}
 
 	for (i = 0; i <  inherit->num_ref_copies; ++i, i_qgroups += 2) {
@@ -2798,6 +2806,9 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 
 		dst->rfer = src->rfer - level_size;
 		dst->rfer_cmpr = src->rfer_cmpr - level_size;
+
+		/* Manually tweaking numbers certainly needs a rescan */
+		need_rescan = true;
 	}
 	for (i = 0; i <  inherit->num_excl_copies; ++i, i_qgroups += 2) {
 		struct btrfs_qgroup *src;
@@ -2816,6 +2827,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 
 		dst->excl = src->excl + level_size;
 		dst->excl_cmpr = src->excl_cmpr + level_size;
+		need_rescan = true;
 	}
 
 unlock:
@@ -2823,6 +2835,8 @@ unlock:
 out:
 	if (!committing)
 		mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (need_rescan)
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	return ret;
 }
 
-- 
2.25.1



