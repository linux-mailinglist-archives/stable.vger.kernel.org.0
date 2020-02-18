Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BC816317C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgBRUA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgBRUA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F7F24125;
        Tue, 18 Feb 2020 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056058;
        bh=T7Znictz8uszRcna2Ble6ulXQf1EOt7QtMr5jx/vG/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKJIIK952e+pJHxOmVsHNF0+nmXZTQMCZM7LxQQL4FMcgDOfI8LbPN+FFGwH+KdNK
         Ola+3jyJrBVdpYpB2Q9uGzfDbbPi0HLgfBcRucA4g5uFONaJPaUSd3wpRg7dmFl+x1
         xFZXh9jmNEn6jqtEOEI6MOz3oVJcKPB2SAPKK8K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Shijie Luo <luoshijie1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.5 19/80] ext4: add cond_resched() to ext4_protect_reserved_inode
Date:   Tue, 18 Feb 2020 20:54:40 +0100
Message-Id: <20200218190434.099136416@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/block_validity.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -207,6 +207,7 @@ static int ext4_protect_reserved_inode(s
 		return PTR_ERR(inode);
 	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 	while (i < num) {
+		cond_resched();
 		map.m_lblk = i;
 		map.m_len = num - i;
 		n = ext4_map_blocks(NULL, inode, &map, 0);


