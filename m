Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795C3643167
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiLETOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiLETOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:14:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1778623EAC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD188B81204
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19738C43470;
        Mon,  5 Dec 2022 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267652;
        bh=Bls/iyGb9KHoit1BxS1HKo/oL4k91TfJX73iY5ZVIM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArNIKEUV+WWdAUUZTzJOXhWcwG2WiMUiYjb8F06LmJVblJJaQ6bF1wNKnubE2Wit6
         MspvdU80wRrU5BPXEpa/x+/qgvjKE3veqNPwS7m5mmwt5RgafBHlfx22ErnuGD5DAR
         vlpLpW/Ur+ijAenW3alreEVrg9edcwcmSjCx0/cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/62] btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()
Date:   Mon,  5 Dec 2022 20:09:44 +0100
Message-Id: <20221205190759.876055621@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit f7e942b5bb35d8e3af54053d19a6bf04143a3955 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d6795c6fdd66..a13a83ec6202 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1990,14 +1990,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, quota_root, dstgroup);
-		if (ret) {
-			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {
-- 
2.35.1



