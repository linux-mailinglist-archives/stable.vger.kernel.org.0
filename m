Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02F4F2AC6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbiDEJNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244856AbiDEIwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00AA21E16;
        Tue,  5 Apr 2022 01:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498FAB81BAE;
        Tue,  5 Apr 2022 08:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B2BC385A1;
        Tue,  5 Apr 2022 08:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148295;
        bh=Cwzp/O5/1WLd58KY+lzv4pGkzzMutxSQTKFNfRU7/pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElKIpk4OaDfSlmR67U19I+bS1qutu+KSNqtNBIPVF20+CRxLExk4MdkCLORjKgqxv
         baWw7UhPIz1hrtfbKacarpxPJuhXNioxpyOM89jMcZZjRpsesIK6jSpPn7cEXHzNUQ
         urgcCdejdhbFOH8f3lyZ1Mc0+ersjCilt8lBijq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0267/1017] f2fs: fix missing free nid in f2fs_handle_failed_inode
Date:   Tue,  5 Apr 2022 09:19:40 +0200
Message-Id: <20220405070402.189591645@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 2fef99b8372c1ae3d8445ab570e888b5a358dbe9 ]

This patch fixes xfstests/generic/475 failure.

[  293.680694] F2FS-fs (dm-1): May loss orphan inode, run fsck to fix.
[  293.685358] Buffer I/O error on dev dm-1, logical block 8388592, async page read
[  293.691527] Buffer I/O error on dev dm-1, logical block 8388592, async page read
[  293.691764] sh (7615): drop_caches: 3
[  293.691819] sh (7616): drop_caches: 3
[  293.694017] Buffer I/O error on dev dm-1, logical block 1, async page read
[  293.695659] sh (7618): drop_caches: 3
[  293.696979] sh (7617): drop_caches: 3
[  293.700290] sh (7623): drop_caches: 3
[  293.708621] sh (7626): drop_caches: 3
[  293.711386] sh (7628): drop_caches: 3
[  293.711825] sh (7627): drop_caches: 3
[  293.716738] sh (7630): drop_caches: 3
[  293.719613] sh (7632): drop_caches: 3
[  293.720971] sh (7633): drop_caches: 3
[  293.727741] sh (7634): drop_caches: 3
[  293.730783] sh (7636): drop_caches: 3
[  293.732681] sh (7635): drop_caches: 3
[  293.732988] sh (7637): drop_caches: 3
[  293.738836] sh (7639): drop_caches: 3
[  293.740568] sh (7641): drop_caches: 3
[  293.743053] sh (7640): drop_caches: 3
[  293.821889] ------------[ cut here ]------------
[  293.824654] kernel BUG at fs/f2fs/node.c:3334!
[  293.826226] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  293.828713] CPU: 0 PID: 7653 Comm: umount Tainted: G           OE     5.17.0-rc1-custom #1
[  293.830946] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[  293.832526] RIP: 0010:f2fs_destroy_node_manager+0x33f/0x350 [f2fs]
[  293.833905] Code: e8 d6 3d f9 f9 48 8b 45 d0 65 48 2b 04 25 28 00 00 00 75 1a 48 81 c4 28 03 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b
[  293.837783] RSP: 0018:ffffb04ec31e7a20 EFLAGS: 00010202
[  293.839062] RAX: 0000000000000001 RBX: ffff9df947db2eb8 RCX: 0000000080aa0072
[  293.840666] RDX: 0000000000000000 RSI: ffffe86c0432a140 RDI: ffffffffc0b72a21
[  293.842261] RBP: ffffb04ec31e7d70 R08: ffff9df94ca85780 R09: 0000000080aa0072
[  293.843909] R10: ffff9df94ca85700 R11: ffff9df94e1ccf58 R12: ffff9df947db2e00
[  293.845594] R13: ffff9df947db2ed0 R14: ffff9df947db2eb8 R15: ffff9df947db2eb8
[  293.847855] FS:  00007f5a97379800(0000) GS:ffff9dfa77c00000(0000) knlGS:0000000000000000
[  293.850647] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  293.852940] CR2: 00007f5a97528730 CR3: 000000010bc76005 CR4: 0000000000370ef0
[  293.854680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  293.856423] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  293.858380] Call Trace:
[  293.859302]  <TASK>
[  293.860311]  ? ttwu_do_wakeup+0x1c/0x170
[  293.861800]  ? ttwu_do_activate+0x6d/0xb0
[  293.863057]  ? _raw_spin_unlock_irqrestore+0x29/0x40
[  293.864411]  ? try_to_wake_up+0x9d/0x5e0
[  293.865618]  ? debug_smp_processor_id+0x17/0x20
[  293.866934]  ? debug_smp_processor_id+0x17/0x20
[  293.868223]  ? free_unref_page+0xbf/0x120
[  293.869470]  ? __free_slab+0xcb/0x1c0
[  293.870614]  ? preempt_count_add+0x7a/0xc0
[  293.871811]  ? __slab_free+0xa0/0x2d0
[  293.872918]  ? __wake_up_common_lock+0x8a/0xc0
[  293.874186]  ? __slab_free+0xa0/0x2d0
[  293.875305]  ? free_inode_nonrcu+0x20/0x20
[  293.876466]  ? free_inode_nonrcu+0x20/0x20
[  293.877650]  ? debug_smp_processor_id+0x17/0x20
[  293.878949]  ? call_rcu+0x11a/0x240
[  293.880060]  ? f2fs_destroy_stats+0x59/0x60 [f2fs]
[  293.881437]  ? kfree+0x1fe/0x230
[  293.882674]  f2fs_put_super+0x160/0x390 [f2fs]
[  293.883978]  generic_shutdown_super+0x7a/0x120
[  293.885274]  kill_block_super+0x27/0x50
[  293.886496]  kill_f2fs_super+0x7f/0x100 [f2fs]
[  293.887806]  deactivate_locked_super+0x35/0xa0
[  293.889271]  deactivate_super+0x40/0x50
[  293.890513]  cleanup_mnt+0x139/0x190
[  293.891689]  __cleanup_mnt+0x12/0x20
[  293.892850]  task_work_run+0x64/0xa0
[  293.894035]  exit_to_user_mode_prepare+0x1b7/0x1c0
[  293.895409]  syscall_exit_to_user_mode+0x27/0x50
[  293.896872]  do_syscall_64+0x48/0xc0
[  293.898090]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  293.899517] RIP: 0033:0x7f5a975cd25b

Fixes: 7735730d39d7 ("f2fs: fix to propagate error from __get_meta_page()")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 1db7823d5a13..5a10f98dbbc3 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -876,6 +876,7 @@ void f2fs_handle_failed_inode(struct inode *inode)
 	err = f2fs_get_node_info(sbi, inode->i_ino, &ni);
 	if (err) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		set_inode_flag(inode, FI_FREE_NID);
 		f2fs_warn(sbi, "May loss orphan inode, run fsck to fix.");
 		goto out;
 	}
-- 
2.34.1



