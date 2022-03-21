Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D094E2C0F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 16:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348272AbiCUPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 11:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350341AbiCUPXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 11:23:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A9E8864;
        Mon, 21 Mar 2022 08:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9683161013;
        Mon, 21 Mar 2022 15:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B33C340E8;
        Mon, 21 Mar 2022 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647876140;
        bh=BmDckR9oVCj0Dpd4A7Tl1cnWlUNuPswQxFdMCV/VB28=;
        h=From:To:Cc:Subject:Date:From;
        b=MVQLwBvoPv739CozYeYWtmsjiElxLsHftJW0CyEqAFU8TDqKf/lZ0pr44OTuhBXku
         UasA+zKlU4VFI+8EB34OUZkR+m9XuD6v7IWgcQX8LSDtmUvGEVp+Vz85Nz9lezM4Lq
         NlKnH5UQdxesNjrkU5yhmAmVgJvQaH3DaEpk9B7muO6TMB+XtFgh9ddla872vCJvCD
         0evxGiuwkFwFvrrgrfL6Y9uYYgH+EAZDFQehNLqbgycTaVYBJFuT8JGM83Bs6JRUXD
         ENQ+rCL/vZvU/b32WEZ9nbsqbyNxywLB1VIUqaQh8iYa1ziKAHNnjn7S3ALVjeb4D1
         c6WqHvhOWMPRQ==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>
Subject: [PATCH] f2fs: fix to do sanity check on .cp_pack_total_block_count
Date:   Mon, 21 Mar 2022 23:22:11 +0800
Message-Id: <20220321152211.5656-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As bughunter reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215709

f2fs may hang when mounting a fuzzed image, the dmesg shows as below:

__filemap_get_folio+0x3a9/0x590
pagecache_get_page+0x18/0x60
__get_meta_page+0x95/0x460 [f2fs]
get_checkpoint_version+0x2a/0x1e0 [f2fs]
validate_checkpoint+0x8e/0x2a0 [f2fs]
f2fs_get_valid_checkpoint+0xd0/0x620 [f2fs]
f2fs_fill_super+0xc01/0x1d40 [f2fs]
mount_bdev+0x18a/0x1c0
f2fs_mount+0x15/0x20 [f2fs]
legacy_get_tree+0x28/0x50
vfs_get_tree+0x27/0xc0
path_mount+0x480/0xaa0
do_mount+0x7c/0xa0
__x64_sys_mount+0x8b/0xe0
do_syscall_64+0x38/0xc0
entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is cp_pack_total_block_count field in checkpoint was fuzzed
to one, as calcuated, two cp pack block locates in the same block address,
so then read latter cp pack block, it will block on the page lock due to
the lock has already held when reading previous cp pack block, fix it by
adding sanity check for cp_pack_total_block_count.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
 fs/f2fs/checkpoint.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 871eee35a32f..aba1b8a1ce66 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -875,6 +875,7 @@ static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
 	struct page *cp_page_1 = NULL, *cp_page_2 = NULL;
 	struct f2fs_checkpoint *cp_block = NULL;
 	unsigned long long cur_version = 0, pre_version = 0;
+	unsigned int cp_blocks;
 	int err;
 
 	err = get_checkpoint_version(sbi, cp_addr, &cp_block,
@@ -882,15 +883,16 @@ static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
 	if (err)
 		return NULL;
 
-	if (le32_to_cpu(cp_block->cp_pack_total_block_count) >
-					sbi->blocks_per_seg) {
+	cp_blocks = le32_to_cpu(cp_block->cp_pack_total_block_count);
+
+	if (cp_blocks > sbi->blocks_per_seg || cp_blocks <= F2FS_CP_PACKS) {
 		f2fs_warn(sbi, "invalid cp_pack_total_block_count:%u",
 			  le32_to_cpu(cp_block->cp_pack_total_block_count));
 		goto invalid_cp;
 	}
 	pre_version = *version;
 
-	cp_addr += le32_to_cpu(cp_block->cp_pack_total_block_count) - 1;
+	cp_addr += cp_blocks - 1;
 	err = get_checkpoint_version(sbi, cp_addr, &cp_block,
 					&cp_page_2, version);
 	if (err)
-- 
2.25.1

