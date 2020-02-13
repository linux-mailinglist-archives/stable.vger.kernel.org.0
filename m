Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148C715C73D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgBMQIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgBMPXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:03 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 890A9246A3;
        Thu, 13 Feb 2020 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607382;
        bh=zAjKoPHcC8yws9lUCGARkObdwCjfoIfDcYEYIfznGO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdPs+nwI+s0dc4odgFiOTOyCEX7608ni44XrlW3BjBKSjuBPEgOagxIwHf10hDjvx
         5bx4VpM/Pthts/7KC87MoPnxGnnlINw86C3UqIaO5GZvFcZzE0I7aNhLG2Ooe6zStc
         YYnnHsu1tmGNYieylLqVaK1sFnPq04ACIUwij7Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 63/91] Btrfs: fix assertion failure on fsync with NO_HOLES enabled
Date:   Thu, 13 Feb 2020 07:20:20 -0800
Message-Id: <20200213151846.639832993@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0ccc3876e4b2a1559a4dbe3126dda4459d38a83b ]

Back in commit a89ca6f24ffe4 ("Btrfs: fix fsync after truncate when
no_holes feature is enabled") I added an assertion that is triggered when
an inline extent is found to assert that the length of the (uncompressed)
data the extent represents is the same as the i_size of the inode, since
that is true most of the time I couldn't find or didn't remembered about
any exception at that time. Later on the assertion was expanded twice to
deal with a case of a compressed inline extent representing a range that
matches the sector size followed by an expanding truncate, and another
case where fallocate can update the i_size of the inode without adding
or updating existing extents (if the fallocate range falls entirely within
the first block of the file). These two expansion/fixes of the assertion
were done by commit 7ed586d0a8241 ("Btrfs: fix assertion on fsync of
regular file when using no-holes feature") and commit 6399fb5a0b69a
("Btrfs: fix assertion failure during fsync in no-holes mode").
These however missed the case where an falloc expands the i_size of an
inode to exactly the sector size and inline extent exists, for example:

 $ mkfs.btrfs -f -O no-holes /dev/sdc
 $ mount /dev/sdc /mnt

 $ xfs_io -f -c "pwrite -S 0xab 0 1096" /mnt/foobar
 wrote 1096/1096 bytes at offset 0
 1 KiB, 1 ops; 0.0002 sec (4.448 MiB/sec and 4255.3191 ops/sec)

 $ xfs_io -c "falloc 1096 3000" /mnt/foobar
 $ xfs_io -c "fsync" /mnt/foobar
 Segmentation fault

 $ dmesg
 [701253.602385] assertion failed: len == i_size || (len == fs_info->sectorsize && btrfs_file_extent_compression(leaf, extent) != BTRFS_COMPRESS_NONE) || (len < i_size && i_size < fs_info->sectorsize), file: fs/btrfs/tree-log.c, line: 4727
 [701253.602962] ------------[ cut here ]------------
 [701253.603224] kernel BUG at fs/btrfs/ctree.h:3533!
 [701253.603503] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
 [701253.603774] CPU: 2 PID: 7192 Comm: xfs_io Tainted: G        W         5.0.0-rc8-btrfs-next-45 #1
 [701253.604054] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
 [701253.604650] RIP: 0010:assfail.constprop.23+0x18/0x1a [btrfs]
 (...)
 [701253.605591] RSP: 0018:ffffbb48c186bc48 EFLAGS: 00010286
 [701253.605914] RAX: 00000000000000de RBX: ffff921d0a7afc08 RCX: 0000000000000000
 [701253.606244] RDX: 0000000000000000 RSI: ffff921d36b16868 RDI: ffff921d36b16868
 [701253.606580] RBP: ffffbb48c186bcf0 R08: 0000000000000000 R09: 0000000000000000
 [701253.606913] R10: 0000000000000003 R11: 0000000000000000 R12: ffff921d05d2de18
 [701253.607247] R13: ffff921d03b54000 R14: 0000000000000448 R15: ffff921d059ecf80
 [701253.607769] FS:  00007f14da906700(0000) GS:ffff921d36b00000(0000) knlGS:0000000000000000
 [701253.608163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [701253.608516] CR2: 000056087ea9f278 CR3: 00000002268e8001 CR4: 00000000003606e0
 [701253.608880] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [701253.609250] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [701253.609608] Call Trace:
 [701253.609994]  btrfs_log_inode+0xdfb/0xe40 [btrfs]
 [701253.610383]  btrfs_log_inode_parent+0x2be/0xa60 [btrfs]
 [701253.610770]  ? do_raw_spin_unlock+0x49/0xc0
 [701253.611150]  btrfs_log_dentry_safe+0x4a/0x70 [btrfs]
 [701253.611537]  btrfs_sync_file+0x3b2/0x440 [btrfs]
 [701253.612010]  ? do_sysinfo+0xb0/0xf0
 [701253.612552]  do_fsync+0x38/0x60
 [701253.612988]  __x64_sys_fsync+0x10/0x20
 [701253.613360]  do_syscall_64+0x60/0x1b0
 [701253.613733]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 [701253.614103] RIP: 0033:0x7f14da4e66d0
 (...)
 [701253.615250] RSP: 002b:00007fffa670fdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
 [701253.615647] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f14da4e66d0
 [701253.616047] RDX: 000056087ea9c260 RSI: 000056087ea9c260 RDI: 0000000000000003
 [701253.616450] RBP: 0000000000000001 R08: 0000000000000020 R09: 0000000000000010
 [701253.616854] R10: 000000000000009b R11: 0000000000000246 R12: 000056087ea9c260
 [701253.617257] R13: 000056087ea9c240 R14: 0000000000000000 R15: 000056087ea9dd10
 (...)
 [701253.619941] ---[ end trace e088d74f132b6da5 ]---

Updating the assertion again to allow for this particular case would result
in a meaningless assertion, plus there is currently no risk of logging
content that would result in any corruption after a log replay if the size
of the data encoded in an inline extent is greater than the inode's i_size
(which is not currently possibe either with or without compression),
therefore just remove the assertion.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f9c3907bf1591..4320f346b0b98 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4404,13 +4404,8 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 					struct btrfs_file_extent_item);
 
 		if (btrfs_file_extent_type(leaf, extent) ==
-		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(leaf,
-							   path->slots[0],
-							   extent);
-			ASSERT(len == i_size);
+		    BTRFS_FILE_EXTENT_INLINE)
 			return 0;
-		}
 
 		len = btrfs_file_extent_num_bytes(leaf, extent);
 		/* Last extent goes beyond i_size, no need to log a hole. */
-- 
2.20.1



