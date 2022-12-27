Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDEC656F23
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiL0UjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiL0Uil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:38:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EFCD2F2;
        Tue, 27 Dec 2022 12:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74043B811F8;
        Tue, 27 Dec 2022 20:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDD6C433EF;
        Tue, 27 Dec 2022 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173283;
        bh=eg5F/oNgv6EBTJsPzi7qKJZ6xPDoVQlr8wYArO+coYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4K04wwH4UzEAynfV6FO5KebAuy2g+YdtOJBIhJsoUFLTqYpU6gRgKJcmn/4rxg1q
         Py9Unp4l1H1Ijypd/JQHrrruWd9yVgKHYqXt56HNlYO2Drv1HQlsJBhtGJBw0PuYiG
         XqYYNqSaKiV+RC6dfXhf8kRZSLwMkYtl7IH37QWRv4TugGVVezxwiXMzqaLVzDf5cl
         HSVm0iBMUG5GNmKXJY93EaauAtFo41fD1FAu5xRJyIzKrUHL3TfPy4ayyIfsqxDBPa
         GzLoDmeiwJIrFKKTinMIadKewhTW3mYGQec9tqHtSzNVK756KaPbPFZbLtkaNDX9qT
         +SaYxaBk2U0vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 07/22] fs/ntfs3: Validate attribute name offset
Date:   Tue, 27 Dec 2022 15:34:17 -0500
Message-Id: <20221227203433.1214255-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203433.1214255-1-sashal@kernel.org>
References: <20221227203433.1214255-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Lo <edward.lo@ambergroup.io>

[ Upstream commit 4f1dc7d9756e66f3f876839ea174df2e656b7f79 ]

Although the attribute name length is checked before comparing it to
some common names (e.g., $I30), the offset isn't. This adds a sanity
check for the attribute name offset, guarantee the validity and prevent
possible out-of-bound memory accesses.

[  191.720056] BUG: unable to handle page fault for address: ffffebde00000008
[  191.721060] #PF: supervisor read access in kernel mode
[  191.721586] #PF: error_code(0x0000) - not-present page
[  191.722079] PGD 0 P4D 0
[  191.722571] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  191.723179] CPU: 0 PID: 244 Comm: mount Not tainted 6.0.0-rc4 #28
[  191.723749] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  191.724832] RIP: 0010:kfree+0x56/0x3b0
[  191.725870] Code: 80 48 01 d8 0f 82 65 03 00 00 48 c7 c2 00 00 00 80 48 2b 15 2c 06 dd 01 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 0a 069
[  191.727375] RSP: 0018:ffff8880076f7878 EFLAGS: 00000286
[  191.727897] RAX: ffffebde00000000 RBX: 0000000000000040 RCX: ffffffff8528d5b9
[  191.728531] RDX: 0000777f80000000 RSI: ffffffff8522d49c RDI: 0000000000000040
[  191.729183] RBP: ffff8880076f78a0 R08: 0000000000000000 R09: 0000000000000000
[  191.729628] R10: ffff888008949fd8 R11: ffffed10011293fd R12: 0000000000000040
[  191.730158] R13: ffff888008949f98 R14: ffff888008949ec0 R15: ffff888008949fb0
[  191.730645] FS:  00007f3520cd7e40(0000) GS:ffff88805ba00000(0000) knlGS:0000000000000000
[  191.731328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  191.731667] CR2: ffffebde00000008 CR3: 0000000009704000 CR4: 00000000000006f0
[  191.732568] Call Trace:
[  191.733231]  <TASK>
[  191.733860]  kvfree+0x2c/0x40
[  191.734632]  ni_clear+0x180/0x290
[  191.735085]  ntfs_evict_inode+0x45/0x70
[  191.735495]  evict+0x199/0x280
[  191.735996]  iput.part.0+0x286/0x320
[  191.736438]  iput+0x32/0x50
[  191.736811]  iget_failed+0x23/0x30
[  191.737270]  ntfs_iget5+0x337/0x1890
[  191.737629]  ? ntfs_clear_mft_tail+0x20/0x260
[  191.738201]  ? ntfs_get_block_bmap+0x70/0x70
[  191.738482]  ? ntfs_objid_init+0xf6/0x140
[  191.738779]  ? ntfs_reparse_init+0x140/0x140
[  191.739266]  ntfs_fill_super+0x121b/0x1b50
[  191.739623]  ? put_ntfs+0x1d0/0x1d0
[  191.739984]  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
[  191.740466]  ? put_ntfs+0x1d0/0x1d0
[  191.740787]  ? sb_set_blocksize+0x6a/0x80
[  191.741272]  get_tree_bdev+0x232/0x370
[  191.741829]  ? put_ntfs+0x1d0/0x1d0
[  191.742669]  ntfs_fs_get_tree+0x15/0x20
[  191.743132]  vfs_get_tree+0x4c/0x130
[  191.743457]  path_mount+0x654/0xfe0
[  191.743938]  ? putname+0x80/0xa0
[  191.744271]  ? finish_automount+0x2e0/0x2e0
[  191.744582]  ? putname+0x80/0xa0
[  191.745053]  ? kmem_cache_free+0x1c4/0x440
[  191.745403]  ? putname+0x80/0xa0
[  191.745616]  do_mount+0xd6/0xf0
[  191.745887]  ? path_mount+0xfe0/0xfe0
[  191.746287]  ? __kasan_check_write+0x14/0x20
[  191.746582]  __x64_sys_mount+0xca/0x110
[  191.746850]  do_syscall_64+0x3b/0x90
[  191.747122]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  191.747517] RIP: 0033:0x7f351fee948a
[  191.748332] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[  191.749341] RSP: 002b:00007ffd51cf3af8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  191.749960] RAX: ffffffffffffffda RBX: 000055b903733060 RCX: 00007f351fee948a
[  191.750589] RDX: 000055b903733260 RSI: 000055b9037332e0 RDI: 000055b90373bce0
[  191.751115] RBP: 0000000000000000 R08: 000055b903733280 R09: 0000000000000020
[  191.751537] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 000055b90373bce0
[  191.751946] R13: 000055b903733260 R14: 0000000000000000 R15: 00000000ffffffff
[  191.752519]  </TASK>
[  191.752782] Modules linked in:
[  191.753785] CR2: ffffebde00000008
[  191.754937] ---[ end trace 0000000000000000 ]---
[  191.755429] RIP: 0010:kfree+0x56/0x3b0
[  191.755725] Code: 80 48 01 d8 0f 82 65 03 00 00 48 c7 c2 00 00 00 80 48 2b 15 2c 06 dd 01 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 0a 069
[  191.756744] RSP: 0018:ffff8880076f7878 EFLAGS: 00000286
[  191.757218] RAX: ffffebde00000000 RBX: 0000000000000040 RCX: ffffffff8528d5b9
[  191.757580] RDX: 0000777f80000000 RSI: ffffffff8522d49c RDI: 0000000000000040
[  191.758016] RBP: ffff8880076f78a0 R08: 0000000000000000 R09: 0000000000000000
[  191.758570] R10: ffff888008949fd8 R11: ffffed10011293fd R12: 0000000000000040
[  191.758957] R13: ffff888008949f98 R14: ffff888008949ec0 R15: ffff888008949fb0
[  191.759317] FS:  00007f3520cd7e40(0000) GS:ffff88805ba00000(0000) knlGS:0000000000000000
[  191.759711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  191.760118] CR2: ffffebde00000008 CR3: 0000000009704000 CR4: 00000000000006f0

Signed-off-by: Edward Lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 83d4c9f42d9c..66afa3db753a 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -129,6 +129,9 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	rsize = attr->non_res ? 0 : le32_to_cpu(attr->res.data_size);
 	asize = le32_to_cpu(attr->size);
 
+	if (le16_to_cpu(attr->name_off) + attr->name_len > asize)
+		goto out;
+
 	switch (attr->type) {
 	case ATTR_STD:
 		if (attr->non_res ||
-- 
2.35.1

