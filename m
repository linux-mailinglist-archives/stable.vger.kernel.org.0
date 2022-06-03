Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC2A53CFC1
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345746AbiFCR4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345953AbiFCRza (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C6D65C8;
        Fri,  3 Jun 2022 10:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 748AB612EA;
        Fri,  3 Jun 2022 17:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832D4C385A9;
        Fri,  3 Jun 2022 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278786;
        bh=C5arwU05RqA1ctL2UY79lqz2JT3jbYppZjc/zSBAfIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPhsYbPtOIYj6OEJYNyzqRVlwoocFzio7hpCmr44uknYDPkOGhKUXZ1CFpQUR0I1J
         30i143PlcwabYRPzayzy2chjMGOPqEvgoTF6dH57z+Y6v0nCk+Ae9zNaYEUEO5rrve
         VpcKJrJNuOrzY0eUX30F4ozYPoAbmXAUlC0yTpkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.17 19/75] exfat: check if cluster num is valid
Date:   Fri,  3 Jun 2022 19:43:03 +0200
Message-Id: <20220603173822.293395249@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 64ba4b15e5c045f8b746c6da5fc9be9a6b00b61d upstream.

Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
This was triggered by reproducer calling truncute with size 0,
which causes the following trace:

BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
Read of size 8 at addr ffff888115aa9508 by task syz-executor251/365

Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
 print_address_description+0x81/0x3c0 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
 exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
 exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
 __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
 exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
 exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
 notify_change+0xb76/0xe10 fs/attr.c:336
 do_truncate+0x1ea/0x2d0 fs/open.c:65

Move the is_valid_cluster() helper from fatent.c to a common
header to make it reusable in other *.c files. And add is_valid_cluster()
to validate if cluster number is within valid range in exfat_clear_bitmap()
and exfat_set_bitmap().

Link: https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c   |    8 ++++++--
 fs/exfat/exfat_fs.h |    6 ++++++
 fs/exfat/fatent.c   |    6 ------
 3 files changed, 12 insertions(+), 8 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -148,7 +148,9 @@ int exfat_set_bitmap(struct inode *inode
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return -EINVAL;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
@@ -166,7 +168,9 @@ void exfat_clear_bitmap(struct inode *in
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_mount_options *opts = &sbi->options;
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -380,6 +380,12 @@ static inline int exfat_sector_to_cluste
 		EXFAT_RESERVED_CLUSTERS;
 }
 
+static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
+}
+
 /* super.c */
 int exfat_set_volume_dirty(struct super_block *sb);
 int exfat_clear_volume_dirty(struct super_block *sb);
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -81,12 +81,6 @@ int exfat_ent_set(struct super_block *sb
 	return 0;
 }
 
-static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
-		unsigned int clus)
-{
-	return clus >= EXFAT_FIRST_CLUSTER && clus < sbi->num_clusters;
-}
-
 int exfat_ent_get(struct super_block *sb, unsigned int loc,
 		unsigned int *content)
 {


