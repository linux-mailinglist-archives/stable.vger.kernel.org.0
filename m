Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D685B5EA380
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiIZL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbiIZLZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:25:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CAF696D3;
        Mon, 26 Sep 2022 03:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E26A3B80926;
        Mon, 26 Sep 2022 10:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310C9C433C1;
        Mon, 26 Sep 2022 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188403;
        bh=W6xISM6vE8TIqe+U5QKuBDbKQWqOaVYmml6Bw3Ll6D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3bld0L053W4MdN/S2HgdG+0GafmjqvpPbLUWNKZBHBowY2BTL+xK0bkern9Ihdw7
         nTTbDwsHkz0OVG0sfVEkTTl1qG+PaN+Gxui5/tA6CrmJSYXO/Clb0dU1l20Gr7FaEW
         +lGxsi/R5IYy8IZSe+kE+pdN8wP3/D/bzzL2HI3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        stable@kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 139/141] ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0
Date:   Mon, 26 Sep 2022 12:12:45 +0200
Message-Id: <20220926100759.499535131@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

commit 29a5b8a137ac8eb410cc823653a29ac0e7b7e1b0 upstream.

When walking through an inode extents, the ext4_ext_binsearch_idx() function
assumes that the extent header has been previously validated.  However, there
are no checks that verify that the number of entries (eh->eh_entries) is
non-zero when depth is > 0.  And this will lead to problems because the
EXT_FIRST_INDEX() and EXT_LAST_INDEX() will return garbage and result in this:

[  135.245946] ------------[ cut here ]------------
[  135.247579] kernel BUG at fs/ext4/extents.c:2258!
[  135.249045] invalid opcode: 0000 [#1] PREEMPT SMP
[  135.250320] CPU: 2 PID: 238 Comm: tmp118 Not tainted 5.19.0-rc8+ #4
[  135.252067] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
[  135.255065] RIP: 0010:ext4_ext_map_blocks+0xc20/0xcb0
[  135.256475] Code:
[  135.261433] RSP: 0018:ffffc900005939f8 EFLAGS: 00010246
[  135.262847] RAX: 0000000000000024 RBX: ffffc90000593b70 RCX: 0000000000000023
[  135.264765] RDX: ffff8880038e5f10 RSI: 0000000000000003 RDI: ffff8880046e922c
[  135.266670] RBP: ffff8880046e9348 R08: 0000000000000001 R09: ffff888002ca580c
[  135.268576] R10: 0000000000002602 R11: 0000000000000000 R12: 0000000000000024
[  135.270477] R13: 0000000000000000 R14: 0000000000000024 R15: 0000000000000000
[  135.272394] FS:  00007fdabdc56740(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[  135.274510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.276075] CR2: 00007ffc26bd4f00 CR3: 0000000006261004 CR4: 0000000000170ea0
[  135.277952] Call Trace:
[  135.278635]  <TASK>
[  135.279247]  ? preempt_count_add+0x6d/0xa0
[  135.280358]  ? percpu_counter_add_batch+0x55/0xb0
[  135.281612]  ? _raw_read_unlock+0x18/0x30
[  135.282704]  ext4_map_blocks+0x294/0x5a0
[  135.283745]  ? xa_load+0x6f/0xa0
[  135.284562]  ext4_mpage_readpages+0x3d6/0x770
[  135.285646]  read_pages+0x67/0x1d0
[  135.286492]  ? folio_add_lru+0x51/0x80
[  135.287441]  page_cache_ra_unbounded+0x124/0x170
[  135.288510]  filemap_get_pages+0x23d/0x5a0
[  135.289457]  ? path_openat+0xa72/0xdd0
[  135.290332]  filemap_read+0xbf/0x300
[  135.291158]  ? _raw_spin_lock_irqsave+0x17/0x40
[  135.292192]  new_sync_read+0x103/0x170
[  135.293014]  vfs_read+0x15d/0x180
[  135.293745]  ksys_read+0xa1/0xe0
[  135.294461]  do_syscall_64+0x3c/0x80
[  135.295284]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

This patch simply adds an extra check in __ext4_ext_check(), verifying that
eh_entries is not 0 when eh_depth is > 0.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215941
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216283
Cc: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20220822094235.2690-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -459,6 +459,10 @@ static int __ext4_ext_check(const char *
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
+	if (unlikely((eh->eh_entries == 0) && (depth > 0))) {
+		error_msg = "eh_entries is 0 but eh_depth is > 0";
+		goto corrupted;
+	}
 	if (!ext4_valid_extent_entries(inode, eh, lblk, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;


