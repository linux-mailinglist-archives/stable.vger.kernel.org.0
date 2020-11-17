Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D202B63AD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgKQNkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732867AbgKQNkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60D22467A;
        Tue, 17 Nov 2020 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620431;
        bh=1DprEkkkSvNwKH9YWYfQlQGrP9PEyOsDTXjY2VSJs4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfiztDDMW8eFLaW8C77rsqciD330fA76WLDtMT4nQUDHUdJjuKq3eah4/yuHuEvWk
         IkjrAD0tchGRy/c4QEUttjxB1U3XzEYvvbrOtTvhuqVDvQuV+PhpuqZUY/pa1KUC9T
         73KozWNhZby2Hvw0/shaumqHLkdo2f0Xigwczv5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 189/255] btrfs: fix min reserved size calculation in merge_reloc_root
Date:   Tue, 17 Nov 2020 14:05:29 +0100
Message-Id: <20201117122148.124389712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit fca3a45d08782a2bb85e048fb8e3128b1388d7b7 upstream.

The minimum reserve size was adjusted to take into account the height of
the tree we are merging, however we can have a root with a level == 0.
What we want is root_level + 1 to get the number of nodes we may have to
cow.  This fixes the enospc_debug warning pops with btrfs/101.

Nikolay: this fixes failures on btrfs/060 btrfs/062 btrfs/063 and
btrfs/195 That I was seeing, the call trace was:

  [ 3680.515564] ------------[ cut here ]------------
  [ 3680.515566] BTRFS: block rsv returned -28
  [ 3680.515585] WARNING: CPU: 2 PID: 8339 at fs/btrfs/block-rsv.c:521 btrfs_use_block_rsv+0x162/0x180
  [ 3680.515587] Modules linked in:
  [ 3680.515591] CPU: 2 PID: 8339 Comm: btrfs Tainted: G        W         5.9.0-rc8-default #95
  [ 3680.515593] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
  [ 3680.515595] RIP: 0010:btrfs_use_block_rsv+0x162/0x180
  [ 3680.515600] RSP: 0018:ffffa01ac9753910 EFLAGS: 00010282
  [ 3680.515602] RAX: 0000000000000000 RBX: ffff984b34200000 RCX: 0000000000000027
  [ 3680.515604] RDX: 0000000000000027 RSI: 0000000000000000 RDI: ffff984b3bd19e28
  [ 3680.515606] RBP: 0000000000004000 R08: ffff984b3bd19e20 R09: 0000000000000001
  [ 3680.515608] R10: 0000000000000004 R11: 0000000000000046 R12: ffff984b264fdc00
  [ 3680.515609] R13: ffff984b13149000 R14: 00000000ffffffe4 R15: ffff984b34200000
  [ 3680.515613] FS:  00007f4e2912b8c0(0000) GS:ffff984b3bd00000(0000) knlGS:0000000000000000
  [ 3680.515615] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 3680.515617] CR2: 00007fab87122150 CR3: 0000000118e42000 CR4: 00000000000006e0
  [ 3680.515620] Call Trace:
  [ 3680.515627]  btrfs_alloc_tree_block+0x8b/0x340
  [ 3680.515633]  ? __lock_acquire+0x51a/0xac0
  [ 3680.515646]  alloc_tree_block_no_bg_flush+0x4f/0x60
  [ 3680.515651]  __btrfs_cow_block+0x14e/0x7e0
  [ 3680.515662]  btrfs_cow_block+0x144/0x2c0
  [ 3680.515670]  merge_reloc_root+0x4d4/0x610
  [ 3680.515675]  ? btrfs_lookup_fs_root+0x78/0x90
  [ 3680.515686]  merge_reloc_roots+0xee/0x280
  [ 3680.515695]  relocate_block_group+0x2ce/0x5e0
  [ 3680.515704]  btrfs_relocate_block_group+0x16e/0x310
  [ 3680.515711]  btrfs_relocate_chunk+0x38/0xf0
  [ 3680.515716]  btrfs_shrink_device+0x200/0x560
  [ 3680.515728]  btrfs_rm_device+0x1ae/0x6a6
  [ 3680.515744]  ? _copy_from_user+0x6e/0xb0
  [ 3680.515750]  btrfs_ioctl+0x1afe/0x28c0
  [ 3680.515755]  ? find_held_lock+0x2b/0x80
  [ 3680.515760]  ? do_user_addr_fault+0x1f8/0x418
  [ 3680.515773]  ? __x64_sys_ioctl+0x77/0xb0
  [ 3680.515775]  __x64_sys_ioctl+0x77/0xb0
  [ 3680.515781]  do_syscall_64+0x31/0x70
  [ 3680.515785]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: Nikolay Borisov <nborisov@suse.com>
Fixes: 44d354abf33e ("btrfs: relocation: review the call sites which can be interrupted by signal")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1646,6 +1646,7 @@ static noinline_for_stack int merge_relo
 	struct btrfs_root_item *root_item;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	int reserve_level;
 	int level;
 	int max_level;
 	int replaced = 0;
@@ -1694,7 +1695,8 @@ static noinline_for_stack int merge_relo
 	 * Thus the needed metadata size is at most root_level * nodesize,
 	 * and * 2 since we have two trees to COW.
 	 */
-	min_reserved = fs_info->nodesize * btrfs_root_level(root_item) * 2;
+	reserve_level = max_t(int, 1, btrfs_root_level(root_item));
+	min_reserved = fs_info->nodesize * reserve_level * 2;
 	memset(&next_key, 0, sizeof(next_key));
 
 	while (1) {


