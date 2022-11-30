Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D7863DBF6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiK3Rba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiK3Rb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA252ED60
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E48DB81C4E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96076C433C1;
        Wed, 30 Nov 2022 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829486;
        bh=sb0O27rx+UFypwzpoVK8uBtsexSG/VXxinJZXvp1aOo=;
        h=Subject:To:Cc:From:Date:From;
        b=CHt+1QMRyWzCulSCutrSDlZX/Pw+o/9/v7PqtmCEsjhsl/SCp5Xtj9sHOU/5orCif
         B0v0LhO0cXv2XdJhPOG8b60Jx0p1RG/hUbjAGULvPGPS0GcUBhklm3QhaTDjPlCZsH
         +glDgLy+y2o+OZaBbtDLfGiPejnHvvTUUBTZl1Cc=
Subject: FAILED: patch "[PATCH] btrfs: qgroup: fix sleep from invalid context bug in" failed to apply to 6.0-stable tree
To:     chenxiaosong2@huawei.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:31:23 +0100
Message-ID: <1669829483218231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f7e942b5bb35 ("btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()")
e562a8bdf652 ("btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7e942b5bb35d8e3af54053d19a6bf04143a3955 Mon Sep 17 00:00:00 2001
From: ChenXiaoSong <chenxiaosong2@huawei.com>
Date: Wed, 16 Nov 2022 22:23:54 +0800
Subject: [PATCH] btrfs: qgroup: fix sleep from invalid context bug in
 btrfs_qgroup_inherit()

Syzkaller reported BUG as follows:

  BUG: sleeping function called from invalid context at
       include/linux/sched/mm.h:274
  Call Trace:
   <TASK>
   dump_stack_lvl+0xcd/0x134
   __might_resched.cold+0x222/0x26b
   kmem_cache_alloc+0x2e7/0x3c0
   update_qgroup_limit_item+0xe1/0x390
   btrfs_qgroup_inherit+0x147b/0x1ee0
   create_subvol+0x4eb/0x1710
   btrfs_mksubvol+0xfe5/0x13f0
   __btrfs_ioctl_snap_create+0x2b0/0x430
   btrfs_ioctl_snap_create_v2+0x25a/0x520
   btrfs_ioctl+0x2a1c/0x5ce0
   __x64_sys_ioctl+0x193/0x200
   do_syscall_64+0x35/0x80

Fix this by calling qgroup_dirty() on @dstqgroup, and update limit item in
btrfs_run_qgroups() later outside of the spinlock context.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9334c3157c22..b74105a10f16 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2951,14 +2951,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, dstgroup);
-		if (ret) {
-			qgroup_mark_inconsistent(fs_info);
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {

