Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF654B17B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbiFNMqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243000AbiFNMqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:46:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9E2511461;
        Tue, 14 Jun 2022 05:46:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A47261650;
        Tue, 14 Jun 2022 05:46:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 70F723F73B;
        Tue, 14 Jun 2022 05:46:31 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, Jchao Sun <sunjunchao2870@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] writeback: Avoid grabbing the wb if the we don't add it to dirty list
Date:   Tue, 14 Jun 2022 13:46:18 +0100
Message-Id: <20220614124618.2830569-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 10e14073107d moved grabbing the wb for an inode early enough,
skipping the checks whether if this inode needs to be really added
to the dirty list (backed by blockdev or unhashed inode). This causes
a crash with kdevtmpfs as below, on an arm64 Juno board, as below:

[    1.446493] printk: console [ttyAMA0] printing thread started
[    1.447195] printk: bootconsole [pl11] printing thread stopped
[    1.467193] Unable to handle kernel paging request at virtual address ffff800871242000
[    1.467793] Mem abort info:
[    1.468093]   ESR = 0x0000000096000005
[    1.468413]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.468741]   SET = 0, FnV = 0
[    1.469093]   EA = 0, S1PTW = 0
[    1.469396]   FSC = 0x05: level 1 translation fault
[    1.470493] Data abort info:
[    1.470793]   ISV = 0, ISS = 0x00000005
[    1.471093]   CM = 0, WnR = 0
[    1.471444] swapper pgtable: 4k pages, 48-bit VAs, 	pgdp=0000000081c10000
[    1.471798] [ffff800871242000] pgd=10000008fffff003,
p4d=10000008fffff003, pud=0000000000000000
[    1.472836] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    1.472918] Modules linked in:
[    1.473085] CPU: 1 PID: 35 Comm: kdevtmpfs Tainted: G T 5.19.0-rc1+ #49
[    1.473246] Hardware name: Foundation-v8A (DT)
[    1.473345] pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT 	-SSBS BTYPE=--)
[    1.473493] pc : locked_inode_to_wb_and_lock_list+0xbc/0x2a4
[    1.473656] lr : locked_inode_to_wb_and_lock_list+0x8c/0x2a4
[    1.473820] sp : ffff80000b77bc10
[    1.473901] x29: ffff80000b77bc10 x28: 0000000000000001 x27: 0000000000000004
[    1.474193] x26: 0000000000000000 x25: ffff000800888600 x24: ffff0008008885e8
[    1.474393] x23: ffff80000848ddd4 x22: ffff80000a754f30 x21: ffff80000a7eaaf0
[    1.474693] x20: ffff000800888150 x19: ffff80000b6a4150 x18: ffff80000ac3ac00
[    1.474917] x17: 0000000070526bee x16: 000000003ac581ee x15: ffff80000ac42660
[    1.475195] x14: 0000000000000000 x13: 0000000000007a60 x12: 0000000000000002
[    1.475428] x11: ffff80000a7eaaf0 x10: 0000000000000004 x9 : 000000008845fe88
[    1.475622] x8 : ffff000800868000 x7 : ffff80000ab98000 x6 : 00000000114514e2
[    1.475893] x5 : 0000000000000000 x4 : 0000000000020019 x3 : 0000000000000001
[    1.476113] x2 : ffff800871242000 x1 : ffff800871242000 x0 : ffff000800868000
[    1.476393] Call trace:
[    1.476493]  locked_inode_to_wb_and_lock_list+0xbc/0x2a4
[    1.476605]  __mark_inode_dirty+0x3d8/0x6e0
[    1.476793]  simple_setattr+0x5c/0x84
[    1.476933]  notify_change+0x3ec/0x470
[    1.477096]  handle_create+0x1b8/0x224
[    1.477193]  devtmpfsd+0x98/0xf8
[    1.477342]  kthread+0x124/0x130
[    1.477512]  ret_from_fork+0x10/0x20
[    1.477670] Code: b9000802 d2800023 d53cd042 8b020021 (f823003f)
[    1.477793] ---[ end trace 0000000000000000 ]---
[    1.478093] note: kdevtmpfs[35] exited with preempt_count 2

The problem was bisected to the above commit and moving the bail check
early solves the problem for me.

Fixes: 10e14073107d ("writeback: Fix inode->i_io_list not be protected by inode->i_lock error")
CC: stable@vger.kernel.org
Cc: Jchao Sun <sunjunchao2870@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 fs/fs-writeback.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 05221366a16d..cf68114af68b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2416,6 +2416,14 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			inode->i_state &= ~I_DIRTY_TIME;
 		inode->i_state |= flags;
 
+		/*
+		 * Only add valid (hashed) inodes to the superblock's
+		 * dirty list.  Add blockdev inodes as well.
+		 */
+		if (!S_ISBLK(inode->i_mode)) {
+			if (inode_unhashed(inode))
+				goto out_unlock_inode;
+		}
 		/*
 		 * Grab inode's wb early because it requires dropping i_lock and we
 		 * need to make sure following checks happen atomically with dirty
@@ -2436,14 +2444,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		if (inode->i_state & I_SYNC_QUEUED)
 			goto out_unlock;
 
-		/*
-		 * Only add valid (hashed) inodes to the superblock's
-		 * dirty list.  Add blockdev inodes as well.
-		 */
-		if (!S_ISBLK(inode->i_mode)) {
-			if (inode_unhashed(inode))
-				goto out_unlock;
-		}
 		if (inode->i_state & I_FREEING)
 			goto out_unlock;
 
-- 
2.35.3

