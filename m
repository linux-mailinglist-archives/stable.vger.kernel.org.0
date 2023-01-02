Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BBE65B088
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjABLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjABLYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:24:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE0F635A
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4941960F37
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AECDC433F0;
        Mon,  2 Jan 2023 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658640;
        bh=6RKKUDx7S9ktjEzAZP5NZcsHRPaa/2vsRvOjrzvgmIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ki532QcHvA9WLxvtO+G/Sy0UJrDRc+0yMZ0Tu6Cee0tDwknjObbRdhQPZM5gVjKlp
         ay2lqdF2cFZL39Vl71zMs9Q69mLpkufmcfezNb7n+DcGZsa1NgzT5Gc2Ce/9FnrccX
         t/D5++SFhhQI3ERltpNn63TAHfeZlDUxm88tg+QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, edward lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/71] fs/ntfs3: Validate BOOT record_size
Date:   Mon,  2 Jan 2023 12:21:40 +0100
Message-Id: <20230102110552.085997529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: edward lo <edward.lo@ambergroup.io>

[ Upstream commit 0b66046266690454dc04e6307bcff4a5605b42a1 ]

When the NTFS BOOT record_size field < 0, it represents a
shift value. However, there is no sanity check on the shift result
and the sbi->record_bits calculation through blksize_bits() assumes
the size always > 256, which could lead to NPD while mounting a
malformed NTFS image.

[  318.675159] BUG: kernel NULL pointer dereference, address: 0000000000000158
[  318.675682] #PF: supervisor read access in kernel mode
[  318.675869] #PF: error_code(0x0000) - not-present page
[  318.676246] PGD 0 P4D 0
[  318.676502] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  318.676934] CPU: 0 PID: 259 Comm: mount Not tainted 5.19.0 #5
[  318.677289] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  318.678136] RIP: 0010:ni_find_attr+0x2d/0x1c0
[  318.678656] Code: 89 ca 4d 89 c7 41 56 41 55 41 54 41 89 cc 55 48 89 fd 53 48 89 d3 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 180
[  318.679848] RSP: 0018:ffffa6c8c0297bd8 EFLAGS: 00000246
[  318.680104] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000080
[  318.680790] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  318.681679] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  318.682577] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000080
[  318.683015] R13: ffff8d5582e68400 R14: 0000000000000100 R15: 0000000000000000
[  318.683618] FS:  00007fd9e1c81e40(0000) GS:ffff8d55fdc00000(0000) knlGS:0000000000000000
[  318.684280] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  318.684651] CR2: 0000000000000158 CR3: 0000000002e1a000 CR4: 00000000000006f0
[  318.685623] Call Trace:
[  318.686607]  <TASK>
[  318.686872]  ? ntfs_alloc_inode+0x1a/0x60
[  318.687235]  attr_load_runs_vcn+0x2b/0xa0
[  318.687468]  mi_read+0xbb/0x250
[  318.687576]  ntfs_iget5+0x114/0xd90
[  318.687750]  ntfs_fill_super+0x588/0x11b0
[  318.687953]  ? put_ntfs+0x130/0x130
[  318.688065]  ? snprintf+0x49/0x70
[  318.688164]  ? put_ntfs+0x130/0x130
[  318.688256]  get_tree_bdev+0x16a/0x260
[  318.688407]  vfs_get_tree+0x20/0xb0
[  318.688519]  path_mount+0x2dc/0x9b0
[  318.688877]  do_mount+0x74/0x90
[  318.689142]  __x64_sys_mount+0x89/0xd0
[  318.689636]  do_syscall_64+0x3b/0x90
[  318.689998]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  318.690318] RIP: 0033:0x7fd9e133c48a
[  318.690687] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[  318.691357] RSP: 002b:00007ffd374406c8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  318.691632] RAX: ffffffffffffffda RBX: 0000564d0b051080 RCX: 00007fd9e133c48a
[  318.691920] RDX: 0000564d0b051280 RSI: 0000564d0b051300 RDI: 0000564d0b0596a0
[  318.692123] RBP: 0000000000000000 R08: 0000564d0b0512a0 R09: 0000000000000020
[  318.692349] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000564d0b0596a0
[  318.692673] R13: 0000564d0b051280 R14: 0000000000000000 R15: 00000000ffffffff
[  318.693007]  </TASK>
[  318.693271] Modules linked in:
[  318.693614] CR2: 0000000000000158
[  318.694446] ---[ end trace 0000000000000000 ]---
[  318.694779] RIP: 0010:ni_find_attr+0x2d/0x1c0
[  318.694952] Code: 89 ca 4d 89 c7 41 56 41 55 41 54 41 89 cc 55 48 89 fd 53 48 89 d3 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 180
[  318.696042] RSP: 0018:ffffa6c8c0297bd8 EFLAGS: 00000246
[  318.696531] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000080
[  318.698114] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  318.699286] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  318.699795] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000080
[  318.700236] R13: ffff8d5582e68400 R14: 0000000000000100 R15: 0000000000000000
[  318.700973] FS:  00007fd9e1c81e40(0000) GS:ffff8d55fdc00000(0000) knlGS:0000000000000000
[  318.701688] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  318.702190] CR2: 0000000000000158 CR3: 0000000002e1a000 CR4: 00000000000006f0
[  318.726510] mount (259) used greatest stack depth: 13320 bytes left

This patch adds a sanity check.

Signed-off-by: edward lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index adc4f73722b7..a0cea3b7526e 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -789,7 +789,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 						 : (u32)boot->record_size
 							   << sbi->cluster_bits;
 
-	if (record_size > MAXIMUM_BYTES_PER_MFT)
+	if (record_size > MAXIMUM_BYTES_PER_MFT || record_size < SECTOR_SIZE)
 		goto out;
 
 	sbi->record_bits = blksize_bits(record_size);
-- 
2.35.1



