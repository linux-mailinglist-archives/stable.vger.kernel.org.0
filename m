Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EACB1D86C2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgERS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729645AbgERRnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:43:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9A9207C4;
        Mon, 18 May 2020 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823831;
        bh=QIKMjtwTJQ+GASKxHYDiRjpIjenb5FKuaNAqFegCf6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP0TP4eYcp0ayp14jXKSOWyuYoTe3kvm0FGY4CbAUg2ftSTqmbP1OJ1Mq24V10z3i
         OtkdhEigj5NvpdOhujG7+effDcrR8lzsoFAc1apjsDNvOwOfVxvKl36vK+0gmd3j8F
         gg6TUZwiv24Ovi6ucWY/YR1N98HRgSa5ywsaygdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Shijie Luo <luoshijie1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/90] ext4: add cond_resched() to ext4_protect_reserved_inode
Date:   Mon, 18 May 2020 19:36:04 +0200
Message-Id: <20200518173456.533046245@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index d31d93ee5e76f..45c7b0f9a8e3f 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -152,6 +152,7 @@ static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
 		return PTR_ERR(inode);
 	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 	while (i < num) {
+		cond_resched();
 		map.m_lblk = i;
 		map.m_len = num - i;
 		n = ext4_map_blocks(NULL, inode, &map, 0);
-- 
2.20.1



