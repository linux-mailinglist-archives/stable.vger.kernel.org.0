Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88311F44EE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388158AbgFISJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41426 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388174AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pF-Gf; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-006VxJ-38; Tue, 09 Jun 2020 19:05:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        stable@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Jan Kara" <jack@suse.cz>, "Shijie Luo" <luoshijie1@huawei.com>
Date:   Tue, 09 Jun 2020 19:04:44 +0100
Message-ID: <lsq.1591725832.257400743@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 53/61] ext4: add cond_resched() to ext4_protect_reserved_inode
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shijie Luo <luoshijie1@huawei.com>

commit af133ade9a40794a37104ecbcc2827c0ea373a3c upstream.

When journal size is set too big by "mkfs.ext4 -J size=", or when
we mount a crafted image to make journal inode->i_size too big,
the loop, "while (i < num)", holds cpu too long. This could cause
soft lockup.

[  529.357541] Call trace:
[  529.357551]  dump_backtrace+0x0/0x198
[  529.357555]  show_stack+0x24/0x30
[  529.357562]  dump_stack+0xa4/0xcc
[  529.357568]  watchdog_timer_fn+0x300/0x3e8
[  529.357574]  __hrtimer_run_queues+0x114/0x358
[  529.357576]  hrtimer_interrupt+0x104/0x2d8
[  529.357580]  arch_timer_handler_virt+0x38/0x58
[  529.357584]  handle_percpu_devid_irq+0x90/0x248
[  529.357588]  generic_handle_irq+0x34/0x50
[  529.357590]  __handle_domain_irq+0x68/0xc0
[  529.357593]  gic_handle_irq+0x6c/0x150
[  529.357595]  el1_irq+0xb8/0x140
[  529.357599]  __ll_sc_atomic_add_return_acquire+0x14/0x20
[  529.357668]  ext4_map_blocks+0x64/0x5c0 [ext4]
[  529.357693]  ext4_setup_system_zone+0x330/0x458 [ext4]
[  529.357717]  ext4_fill_super+0x2170/0x2ba8 [ext4]
[  529.357722]  mount_bdev+0x1a8/0x1e8
[  529.357746]  ext4_mount+0x44/0x58 [ext4]
[  529.357748]  mount_fs+0x50/0x170
[  529.357752]  vfs_kern_mount.part.9+0x54/0x188
[  529.357755]  do_mount+0x5ac/0xd78
[  529.357758]  ksys_mount+0x9c/0x118
[  529.357760]  __arm64_sys_mount+0x28/0x38
[  529.357764]  el0_svc_common+0x78/0x130
[  529.357766]  el0_svc_handler+0x38/0x78
[  529.357769]  el0_svc+0x8/0xc
[  541.356516] watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [mount:18674]

Link: https://lore.kernel.org/r/20200211011752.29242-1-luoshijie1@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/block_validity.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -153,6 +153,7 @@ static int ext4_protect_reserved_inode(s
 		return PTR_ERR(inode);
 	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 	while (i < num) {
+		cond_resched();
 		map.m_lblk = i;
 		map.m_len = num - i;
 		n = ext4_map_blocks(NULL, inode, &map, 0);

