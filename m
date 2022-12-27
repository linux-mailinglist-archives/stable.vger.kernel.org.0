Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74716656F20
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiL0UjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbiL0Uij (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:38:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C0DE0B1;
        Tue, 27 Dec 2022 12:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5827B811F9;
        Tue, 27 Dec 2022 20:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC03C433F0;
        Tue, 27 Dec 2022 20:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173279;
        bh=qXUGgbWySjSGG14EGfqYMMCGrgyMyDjimdMb81sKayw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpYhuXLlUl+bDsDB5Zi0pPg/6T/g7X+wFJ9/kSebVJux4GRHhvrZrPUOoDUfkIoiS
         lvQKgz97zPhCOGVwr2SS71/1XTrZM3GtMq40wOIQjJnc7khlsOx5IlYrutKK/bsRb6
         STWZIhpMZXz/gHevEguuz30r5kXqn1fHruuZCYhhjEwlSoPA2cTDo4R4qBjXtfGvxT
         UNnHEEZd/ThWL1J3zvoiTnDeq1RJ1YU7rFSaeSpKQ3beskVEw8V/LeYsML3bPpGs1R
         p5TWXPdg2aN+TFCnivfqhOYJmhmAoHLIGAFXmngxJXVF+cFRop2NGPDJ15sn7lYmp+
         olEH3v93D83jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 04/22] fs/ntfs3: Add null pointer check to attr_load_runs_vcn
Date:   Tue, 27 Dec 2022 15:34:14 -0500
Message-Id: <20221227203433.1214255-4-sashal@kernel.org>
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

[ Upstream commit 2681631c29739509eec59cc0b34e977bb04c6cf1 ]

Some metadata files are handled before MFT. This adds a null pointer
check for some corner cases that could lead to NPD while reading these
metadata files for a malformed NTFS image.

[  240.190827] BUG: kernel NULL pointer dereference, address: 0000000000000158
[  240.191583] #PF: supervisor read access in kernel mode
[  240.191956] #PF: error_code(0x0000) - not-present page
[  240.192391] PGD 0 P4D 0
[  240.192897] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  240.193805] CPU: 0 PID: 242 Comm: mount Tainted: G    B             5.19.0+ #17
[  240.194477] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  240.195152] RIP: 0010:ni_find_attr+0xae/0x300
[  240.195679] Code: c8 48 c7 45 88 c0 4e 5e 86 c7 00 f1 f1 f1 f1 c7 40 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 e2 d9f
[  240.196642] RSP: 0018:ffff88800812f690 EFLAGS: 00000286
[  240.197019] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff85ef037a
[  240.197523] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff88e95f60
[  240.197877] RBP: ffff88800812f738 R08: 0000000000000001 R09: fffffbfff11d2bed
[  240.198292] R10: ffffffff88e95f67 R11: fffffbfff11d2bec R12: 0000000000000000
[  240.198647] R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000000
[  240.199410] FS:  00007f233c33be40(0000) GS:ffff888058200000(0000) knlGS:0000000000000000
[  240.199895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  240.200314] CR2: 0000000000000158 CR3: 0000000004d32000 CR4: 00000000000006f0
[  240.200839] Call Trace:
[  240.201104]  <TASK>
[  240.201502]  ? ni_load_mi+0x80/0x80
[  240.202297]  ? ___slab_alloc+0x465/0x830
[  240.202614]  attr_load_runs_vcn+0x8c/0x1a0
[  240.202886]  ? __kasan_slab_alloc+0x32/0x90
[  240.203157]  ? attr_data_write_resident+0x250/0x250
[  240.203543]  mi_read+0x133/0x2c0
[  240.203785]  mi_get+0x70/0x140
[  240.204012]  ni_load_mi_ex+0xfa/0x190
[  240.204346]  ? ni_std5+0x90/0x90
[  240.204588]  ? __kasan_kmalloc+0x88/0xb0
[  240.204859]  ni_enum_attr_ex+0xf1/0x1c0
[  240.205107]  ? ni_fname_type.part.0+0xd0/0xd0
[  240.205600]  ? ntfs_load_attr_list+0xbe/0x300
[  240.205864]  ? ntfs_cmp_names_cpu+0x125/0x180
[  240.206157]  ntfs_iget5+0x56c/0x1870
[  240.206510]  ? ntfs_get_block_bmap+0x70/0x70
[  240.206776]  ? __kasan_kmalloc+0x88/0xb0
[  240.207030]  ? set_blocksize+0x95/0x150
[  240.207545]  ntfs_fill_super+0xb8f/0x1e20
[  240.207839]  ? put_ntfs+0x1d0/0x1d0
[  240.208069]  ? vsprintf+0x20/0x20
[  240.208467]  ? mutex_unlock+0x81/0xd0
[  240.208846]  ? set_blocksize+0x95/0x150
[  240.209221]  get_tree_bdev+0x232/0x370
[  240.209804]  ? put_ntfs+0x1d0/0x1d0
[  240.210519]  ntfs_fs_get_tree+0x15/0x20
[  240.210991]  vfs_get_tree+0x4c/0x130
[  240.211455]  path_mount+0x645/0xfd0
[  240.211806]  ? putname+0x80/0xa0
[  240.212112]  ? finish_automount+0x2e0/0x2e0
[  240.212559]  ? kmem_cache_free+0x110/0x390
[  240.212906]  ? putname+0x80/0xa0
[  240.213329]  do_mount+0xd6/0xf0
[  240.213829]  ? path_mount+0xfd0/0xfd0
[  240.214246]  ? __kasan_check_write+0x14/0x20
[  240.214774]  __x64_sys_mount+0xca/0x110
[  240.215080]  do_syscall_64+0x3b/0x90
[  240.215442]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  240.215811] RIP: 0033:0x7f233b4e948a
[  240.216104] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[  240.217615] RSP: 002b:00007fff02211ec8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  240.218718] RAX: ffffffffffffffda RBX: 0000561cdc35b060 RCX: 00007f233b4e948a
[  240.219556] RDX: 0000561cdc35b260 RSI: 0000561cdc35b2e0 RDI: 0000561cdc363af0
[  240.219975] RBP: 0000000000000000 R08: 0000561cdc35b280 R09: 0000000000000020
[  240.220403] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000561cdc363af0
[  240.220803] R13: 0000561cdc35b260 R14: 0000000000000000 R15: 00000000ffffffff
[  240.221256]  </TASK>
[  240.221567] Modules linked in:
[  240.222028] CR2: 0000000000000158
[  240.223291] ---[ end trace 0000000000000000 ]---
[  240.223669] RIP: 0010:ni_find_attr+0xae/0x300
[  240.224058] Code: c8 48 c7 45 88 c0 4e 5e 86 c7 00 f1 f1 f1 f1 c7 40 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 e2 d9f
[  240.225033] RSP: 0018:ffff88800812f690 EFLAGS: 00000286
[  240.225968] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff85ef037a
[  240.226624] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff88e95f60
[  240.227307] RBP: ffff88800812f738 R08: 0000000000000001 R09: fffffbfff11d2bed
[  240.227816] R10: ffffffff88e95f67 R11: fffffbfff11d2bec R12: 0000000000000000
[  240.228330] R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000000
[  240.228729] FS:  00007f233c33be40(0000) GS:ffff888058200000(0000) knlGS:0000000000000000
[  240.229281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  240.230298] CR2: 0000000000000158 CR3: 0000000004d32000 CR4: 00000000000006f0

Signed-off-by: Edward Lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 43e85c493c05..42af83bcaf13 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1146,6 +1146,11 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	CLST svcn, evcn;
 	u16 ro;
 
+	if (!ni) {
+		/* Is record corrupted? */
+		return -ENOENT;
+	}
+
 	attr = ni_find_attr(ni, NULL, NULL, type, name, name_len, &vcn, NULL);
 	if (!attr) {
 		/* Is record corrupted? */
-- 
2.35.1

