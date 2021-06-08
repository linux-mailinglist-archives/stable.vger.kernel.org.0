Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96043A023B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhFHTCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237213AbhFHTAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDFE6162E;
        Tue,  8 Jun 2021 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177808;
        bh=wIPv2GZY4Cpx/p3MX5n+ZRapTROsVz1th+wUTzZ2C6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB6DFIOjb0W34bKSG2IijJ+qynNPKZM4bi3nKw6rUSqpkkiWhcbmd8zny9mS3wC2W
         2fnwL/RhzTSKY7tcj9qfqphS/YPj5GnW6abTT8UMpY4/uEEz8p6d56treFQUXHr0zh
         TDljcXzfvxj65DfNLHKDcSgNiAzrUczdhNFgpgF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 106/137] ext4: fix accessing uninit percpu counter variable with fast_commit
Date:   Tue,  8 Jun 2021 20:27:26 +0200
Message-Id: <20210608175945.971481903@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit b45f189a19b38e01676628db79cd3eeb1333516e upstream.

When running generic/527 with fast_commit configuration, the following
issue is seen on Power.  With fast_commit, during ext4_fc_replay()
(which can be called from ext4_fill_super()), if inode eviction
happens then it can access an uninitialized percpu counter variable.

This patch adds the check before accessing the counters in
ext4_free_inode() path.

[  321.165371] run fstests generic/527 at 2021-04-29 08:38:43
[  323.027786] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: block_validity. Quota mode: none.
[  323.618772] BUG: Unable to handle kernel data access on read at 0x1fbd80000
[  323.619767] Faulting instruction address: 0xc000000000bae78c
cpu 0x1: Vector: 300 (Data Access) at [c000000010706ef0]
    pc: c000000000bae78c: percpu_counter_add_batch+0x3c/0x100
    lr: c0000000006d0bb0: ext4_free_inode+0x780/0xb90
    pid   = 5593, comm = mount
	ext4_free_inode+0x780/0xb90
	ext4_evict_inode+0xa8c/0xc60
	evict+0xfc/0x1e0
	ext4_fc_replay+0xc50/0x20f0
	do_one_pass+0xfe0/0x1350
	jbd2_journal_recover+0x184/0x2e0
	jbd2_journal_load+0x1c0/0x4a0
	ext4_fill_super+0x2458/0x4200
	mount_bdev+0x1dc/0x290
	ext4_mount+0x28/0x40
	legacy_get_tree+0x4c/0xa0
	vfs_get_tree+0x4c/0x120
	path_mount+0xcf8/0xd70
	do_mount+0x80/0xd0
	sys_mount+0x3fc/0x490
	system_call_exception+0x384/0x3d0
	system_call_common+0xec/0x278

Cc: stable@kernel.org
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/6cceb9a75c54bef8fa9696c1b08c8df5ff6169e2.1619692410.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -322,14 +322,16 @@ void ext4_free_inode(handle_t *handle, s
 	if (is_directory) {
 		count = ext4_used_dirs_count(sb, gdp) - 1;
 		ext4_used_dirs_set(sb, gdp, count);
-		percpu_counter_dec(&sbi->s_dirs_counter);
+		if (percpu_counter_initialized(&sbi->s_dirs_counter))
+			percpu_counter_dec(&sbi->s_dirs_counter);
 	}
 	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
 				   EXT4_INODES_PER_GROUP(sb) / 8);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
-	percpu_counter_inc(&sbi->s_freeinodes_counter);
+	if (percpu_counter_initialized(&sbi->s_freeinodes_counter))
+		percpu_counter_inc(&sbi->s_freeinodes_counter);
 	if (sbi->s_log_groups_per_flex) {
 		struct flex_groups *fg;
 


