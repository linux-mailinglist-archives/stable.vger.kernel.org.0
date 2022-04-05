Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546684F32DE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiDEJCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiDEImt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C784215A37;
        Tue,  5 Apr 2022 01:35:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84DD7B81B13;
        Tue,  5 Apr 2022 08:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BFCC385A2;
        Tue,  5 Apr 2022 08:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147724;
        bh=KrpoqmBm+9RVRU5wmQ0UoegreTFKV0nEgPTZhJMf3uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8UxmhbgumshRo4eyY5fNf1sHYsPUXCNGZ3YQczDIpSR+xqyFTjxdlDuZ70A9jwcw
         5wVlz6LoCpCb2YF8tF6xa/PNvb3xTiH7J96K7dn2TpPFv/oCimGOw2jTogPo4uq/GV
         2sJYAbWjRyzPopgbDRR+zpSnCa701IMthh+C3fdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao.yu@oppo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0072/1017] f2fs: fix to do sanity check on .cp_pack_total_block_count
Date:   Tue,  5 Apr 2022 09:16:25 +0200
Message-Id: <20220405070356.328289574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 5b5b4f85b01604389f7a0f11ef180a725bf0e2d4 upstream.

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
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -864,6 +864,7 @@ static struct page *validate_checkpoint(
 	struct page *cp_page_1 = NULL, *cp_page_2 = NULL;
 	struct f2fs_checkpoint *cp_block = NULL;
 	unsigned long long cur_version = 0, pre_version = 0;
+	unsigned int cp_blocks;
 	int err;
 
 	err = get_checkpoint_version(sbi, cp_addr, &cp_block,
@@ -871,15 +872,16 @@ static struct page *validate_checkpoint(
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


