Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDC2651842
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiLTBZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiLTBYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:24:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6910F11A17;
        Mon, 19 Dec 2022 17:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F02BB810FA;
        Tue, 20 Dec 2022 01:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D37C433D2;
        Tue, 20 Dec 2022 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499350;
        bh=aJlILcbht/YEnxfR7Jkxij3uWW+rqVcQU1fJAnSJwA0=;
        h=From:To:Cc:Subject:Date:From;
        b=B/KCIjQkJ+orw0sGRBcKRPbKBxBnqCTGpCQzOL+SEwUt0LyM5rJtdIDB5pcz5eGDw
         yov/amRo8UZIk+oPdhAHVvk7Lsj756ThGL5zjs7PJhlkkHvM3uFum6sg/6758AXGX3
         el2z2TIwbFEYFqOgJFr3UukCDVBS/8ZgNLV1FlBrREmnoGvdoW8vEhxjHpm0U/p/dz
         aVBnDhS1OfpDofYA5FU3VgYAMDry+Qj4s6zX9WlqsOL1Qk/ANHtV4IhwZUf82qvfru
         iSlCHlIAkG+Y85ZFACsAq/ifaD+dDWM8RgiGxj6C6YbBMkiSuMaCtD3CxoNTFeQhy5
         Av1uF0n5AdtRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Ian Kent <raven@themaw.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, muchun.song@linux.dev,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 1/5] hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
Date:   Mon, 19 Dec 2022 20:22:23 -0500
Message-Id: <20221220012227.1222729-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Hawkins Jiawei <yin31149@gmail.com>

[ Upstream commit 26215b7ee923b9251f7bb12c4e5f09dc465d35f2 ]

Syzkaller reports a null-ptr-deref bug as follows:
======================================================
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:hugetlbfs_parse_param+0x1dd/0x8e0 fs/hugetlbfs/inode.c:1380
[...]
Call Trace:
 <TASK>
 vfs_parse_fs_param fs/fs_context.c:148 [inline]
 vfs_parse_fs_param+0x1f9/0x3c0 fs/fs_context.c:129
 vfs_parse_fs_string+0xdb/0x170 fs/fs_context.c:191
 generic_parse_monolithic+0x16f/0x1f0 fs/fs_context.c:231
 do_new_mount fs/namespace.c:3036 [inline]
 path_mount+0x12de/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>
======================================================

According to commit "vfs: parse: deal with zero length string value",
kernel will set the param->string to null pointer in vfs_parse_fs_string()
if fs string has zero length.

Yet the problem is that, hugetlbfs_parse_param() will dereference the
param->string, without checking whether it is a null pointer.  To be more
specific, if hugetlbfs_parse_param() parses an illegal mount parameter,
such as "size=,", kernel will constructs struct fs_parameter with null
pointer in vfs_parse_fs_string(), then passes this struct fs_parameter to
hugetlbfs_parse_param(), which triggers the above null-ptr-deref bug.

This patch solves it by adding sanity check on param->string
in hugetlbfs_parse_param().

Link: https://lkml.kernel.org/r/20221020231609.4810-1-yin31149@gmail.com
Reported-by: syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com
Tested-by: syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com
  Link: https://lore.kernel.org/all/0000000000005ad00405eb7148c6@google.com/
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hawkins Jiawei <yin31149@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7d039ba5ae28..b1d31c78fc9d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1232,7 +1232,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->max_size_opt = memparse(param->string, &rest);
 		ctx->max_val_type = SIZE_STD;
@@ -1242,7 +1242,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_nr_inodes:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->nr_inodes = memparse(param->string, &rest);
 		return 0;
@@ -1258,7 +1258,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_min_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->min_size_opt = memparse(param->string, &rest);
 		ctx->min_val_type = SIZE_STD;
-- 
2.35.1

