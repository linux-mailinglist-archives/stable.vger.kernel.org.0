Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B455656EAC
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiL0Udb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiL0UdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A3AD2ED;
        Tue, 27 Dec 2022 12:32:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BECE961245;
        Tue, 27 Dec 2022 20:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7D5C433F2;
        Tue, 27 Dec 2022 20:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173178;
        bh=uI3kulUoUh8Pq6gM9/f2BFmaOcIBLWHxjsJRH8OZpOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZ9GUzsWkn/T4tRWLcEGuVG7BInYQs8XH+Rc2xxqWPYLCmkHKJA9OYhW9q1FlJAaz
         xeC1/88KdMoRRL1TG/Ia7sK0zQ8lTs8g/Hz/lbPQD5pJGrkzA0Vv23sLyNMvnohdG2
         nuNP/h47+/PQnTNp8JlBW6FCbUWV/IWGksx2etuYVVtKhYRrs7ZiAEeRvekNtwQZom
         wO4jg3mVYZjhESO3VRENjFRj62q3z6QTYJul//pDMDFDhUAcngpVVWqF1yy8U0UqYu
         uysQWWMXti++Df2Lcsx+pcRrPN32RFa7+/OBZl7zkq0RVST2QDBnzyw7lu/shPKdGc
         MgZa086mf9G+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 06/28] fs/ntfs3: Add null pointer check for inode operations
Date:   Tue, 27 Dec 2022 15:32:27 -0500
Message-Id: <20221227203249.1213526-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
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

[ Upstream commit c1ca8ef0262b25493631ecbd9cb8c9893e1481a1 ]

This adds a sanity check for the i_op pointer of the inode which is
returned after reading Root directory MFT record. We should check the
i_op is valid before trying to create the root dentry, otherwise we may
encounter a NPD while mounting a image with a funny Root directory MFT
record.

[  114.484325] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  114.484811] #PF: supervisor read access in kernel mode
[  114.485084] #PF: error_code(0x0000) - not-present page
[  114.485606] PGD 0 P4D 0
[  114.485975] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  114.486570] CPU: 0 PID: 237 Comm: mount Tainted: G    B              6.0.0-rc4 #28
[  114.486977] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  114.488169] RIP: 0010:d_flags_for_inode+0xe0/0x110
[  114.488816] Code: 24 f7 ff 49 83 3e 00 74 41 41 83 cd 02 66 44 89 6b 02 eb 92 48 8d 7b 20 e8 6d 24 f7 ff 4c 8b 73 20 49 8d 7e 08 e8 60 241
[  114.490326] RSP: 0018:ffff8880065e7aa8 EFLAGS: 00000296
[  114.490695] RAX: 0000000000000001 RBX: ffff888008ccd750 RCX: ffffffff84af2aea
[  114.490986] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff87abd020
[  114.491364] RBP: ffff8880065e7ac8 R08: 0000000000000001 R09: fffffbfff0f57a05
[  114.491675] R10: ffffffff87abd027 R11: fffffbfff0f57a04 R12: 0000000000000000
[  114.491954] R13: 0000000000000008 R14: 0000000000000000 R15: ffff888008ccd750
[  114.492397] FS:  00007fdc8a627e40(0000) GS:ffff888058200000(0000) knlGS:0000000000000000
[  114.492797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  114.493150] CR2: 0000000000000008 CR3: 00000000013ba000 CR4: 00000000000006f0
[  114.493671] Call Trace:
[  114.493890]  <TASK>
[  114.494075]  __d_instantiate+0x24/0x1c0
[  114.494505]  d_instantiate.part.0+0x35/0x50
[  114.494754]  d_make_root+0x53/0x80
[  114.494998]  ntfs_fill_super+0x1232/0x1b50
[  114.495260]  ? put_ntfs+0x1d0/0x1d0
[  114.495499]  ? vsprintf+0x20/0x20
[  114.495723]  ? set_blocksize+0x95/0x150
[  114.495964]  get_tree_bdev+0x232/0x370
[  114.496272]  ? put_ntfs+0x1d0/0x1d0
[  114.496502]  ntfs_fs_get_tree+0x15/0x20
[  114.496859]  vfs_get_tree+0x4c/0x130
[  114.497099]  path_mount+0x654/0xfe0
[  114.497507]  ? putname+0x80/0xa0
[  114.497933]  ? finish_automount+0x2e0/0x2e0
[  114.498362]  ? putname+0x80/0xa0
[  114.498571]  ? kmem_cache_free+0x1c4/0x440
[  114.498819]  ? putname+0x80/0xa0
[  114.499069]  do_mount+0xd6/0xf0
[  114.499343]  ? path_mount+0xfe0/0xfe0
[  114.499683]  ? __kasan_check_write+0x14/0x20
[  114.500133]  __x64_sys_mount+0xca/0x110
[  114.500592]  do_syscall_64+0x3b/0x90
[  114.500930]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  114.501294] RIP: 0033:0x7fdc898e948a
[  114.501542] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[  114.502716] RSP: 002b:00007ffd793e58f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  114.503175] RAX: ffffffffffffffda RBX: 0000564b2228f060 RCX: 00007fdc898e948a
[  114.503588] RDX: 0000564b2228f260 RSI: 0000564b2228f2e0 RDI: 0000564b22297ce0
[  114.504925] RBP: 0000000000000000 R08: 0000564b2228f280 R09: 0000000000000020
[  114.505484] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000564b22297ce0
[  114.505823] R13: 0000564b2228f260 R14: 0000000000000000 R15: 00000000ffffffff
[  114.506562]  </TASK>
[  114.506887] Modules linked in:
[  114.507648] CR2: 0000000000000008
[  114.508884] ---[ end trace 0000000000000000 ]---
[  114.509675] RIP: 0010:d_flags_for_inode+0xe0/0x110
[  114.510140] Code: 24 f7 ff 49 83 3e 00 74 41 41 83 cd 02 66 44 89 6b 02 eb 92 48 8d 7b 20 e8 6d 24 f7 ff 4c 8b 73 20 49 8d 7e 08 e8 60 241
[  114.511762] RSP: 0018:ffff8880065e7aa8 EFLAGS: 00000296
[  114.512401] RAX: 0000000000000001 RBX: ffff888008ccd750 RCX: ffffffff84af2aea
[  114.513103] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff87abd020
[  114.513512] RBP: ffff8880065e7ac8 R08: 0000000000000001 R09: fffffbfff0f57a05
[  114.513831] R10: ffffffff87abd027 R11: fffffbfff0f57a04 R12: 0000000000000000
[  114.514757] R13: 0000000000000008 R14: 0000000000000000 R15: ffff888008ccd750
[  114.515411] FS:  00007fdc8a627e40(0000) GS:ffff888058200000(0000) knlGS:0000000000000000
[  114.515794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  114.516208] CR2: 0000000000000008 CR3: 00000000013ba000 CR4: 00000000000006f0

Signed-off-by: Edward Lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 0118c28d8ccb..0c8dd4ff5d7a 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1260,9 +1260,9 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	ref.low = cpu_to_le32(MFT_REC_ROOT);
 	ref.seq = cpu_to_le16(MFT_REC_ROOT);
 	inode = ntfs_iget5(sb, &ref, &NAME_ROOT);
-	if (IS_ERR(inode)) {
+	if (IS_ERR(inode) || !inode->i_op) {
 		ntfs_err(sb, "Failed to load root.");
-		err = PTR_ERR(inode);
+		err = IS_ERR(inode) ? PTR_ERR(inode) : -EINVAL;
 		goto out;
 	}
 
-- 
2.35.1

