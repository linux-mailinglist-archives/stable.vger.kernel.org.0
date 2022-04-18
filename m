Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD852505016
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiDRMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbiDRMU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:20:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CF11ADBB;
        Mon, 18 Apr 2022 05:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E67D2B80ED6;
        Mon, 18 Apr 2022 12:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D032C385A1;
        Mon, 18 Apr 2022 12:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284226;
        bh=qVN6vq0v0XbjTnTFSonsejvNIbXjBNage/2sxKH6Vxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/jtwd4Rn4Wprmmauvfp6FY2o+qSxufSovVcHbeUIl/dkWTo6PV8iIJYTFO2cNGfa
         80XSROLl4yR/Vnbc0bGdB6xWZTobDCMFcmu5EcuYXBcFXijylyObkCSmuxBcZFCELi
         CG/SzdkgPb5GImOUxFUKxSxl/Bg6pkwyXGbbPQdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 014/219] btrfs: release correct delalloc amount in direct IO write path
Date:   Mon, 18 Apr 2022 14:09:43 +0200
Message-Id: <20220418121203.889815204@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 6d82ad13c4110e73c7b0392f00534a1502a1b520 upstream.

Running generic/406 causes the following WARNING in btrfs_destroy_inode()
which tells there are outstanding extents left.

In btrfs_get_blocks_direct_write(), we reserve a temporary outstanding
extents with btrfs_delalloc_reserve_metadata() (or indirectly from
btrfs_delalloc_reserve_space(()). We then release the outstanding extents
with btrfs_delalloc_release_extents(). However, the "len" can be modified
in the COW case, which releases fewer outstanding extents than expected.

Fix it by calling btrfs_delalloc_release_extents() for the original length.

To reproduce the warning, the filesystem should be 1 GiB.  It's
triggering a short-write, due to not being able to allocate a large
extent and instead allocating a smaller one.

  WARNING: CPU: 0 PID: 757 at fs/btrfs/inode.c:8848 btrfs_destroy_inode+0x1e6/0x210 [btrfs]
  Modules linked in: btrfs blake2b_generic xor lzo_compress
  lzo_decompress raid6_pq zstd zstd_decompress zstd_compress xxhash zram
  zsmalloc
  CPU: 0 PID: 757 Comm: umount Not tainted 5.17.0-rc8+ #101
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS d55cb5a 04/01/2014
  RIP: 0010:btrfs_destroy_inode+0x1e6/0x210 [btrfs]
  RSP: 0018:ffffc9000327bda8 EFLAGS: 00010206
  RAX: 0000000000000000 RBX: ffff888100548b78 RCX: 0000000000000000
  RDX: 0000000000026900 RSI: 0000000000000000 RDI: ffff888100548b78
  RBP: ffff888100548940 R08: 0000000000000000 R09: ffff88810b48aba8
  R10: 0000000000000001 R11: ffff8881004eb240 R12: ffff88810b48a800
  R13: ffff88810b48ec08 R14: ffff88810b48ed00 R15: ffff888100490c68
  FS:  00007f8549ea0b80(0000) GS:ffff888237c00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f854a09e733 CR3: 000000010a2e9003 CR4: 0000000000370eb0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   destroy_inode+0x33/0x70
   dispose_list+0x43/0x60
   evict_inodes+0x161/0x1b0
   generic_shutdown_super+0x2d/0x110
   kill_anon_super+0xf/0x20
   btrfs_kill_super+0xd/0x20 [btrfs]
   deactivate_locked_super+0x27/0x90
   cleanup_mnt+0x12c/0x180
   task_work_run+0x54/0x80
   exit_to_user_mode_prepare+0x152/0x160
   syscall_exit_to_user_mode+0x12/0x30
   do_syscall_64+0x42/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   RIP: 0033:0x7f854a000fb7

Fixes: f0bfa76a11e9 ("btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range")
CC: stable@vger.kernel.org # 5.17
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7423,6 +7423,7 @@ static int btrfs_get_blocks_direct_write
 	u64 block_start, orig_start, orig_block_len, ram_bytes;
 	bool can_nocow = false;
 	bool space_reserved = false;
+	u64 prev_len;
 	int ret = 0;
 
 	/*
@@ -7450,6 +7451,7 @@ static int btrfs_get_blocks_direct_write
 			can_nocow = true;
 	}
 
+	prev_len = len;
 	if (can_nocow) {
 		struct extent_map *em2;
 
@@ -7479,8 +7481,6 @@ static int btrfs_get_blocks_direct_write
 			goto out;
 		}
 	} else {
-		const u64 prev_len = len;
-
 		/* Our caller expects us to free the input extent map. */
 		free_extent_map(em);
 		*map = NULL;
@@ -7511,7 +7511,7 @@ static int btrfs_get_blocks_direct_write
 	 * We have created our ordered extent, so we can now release our reservation
 	 * for an outstanding extent.
 	 */
-	btrfs_delalloc_release_extents(BTRFS_I(inode), len);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prev_len);
 
 	/*
 	 * Need to update the i_size under the extent lock so buffered


