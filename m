Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06E667703
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbjALOjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239588AbjALOiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:38:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7F65792A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1776202D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14F2C433D2;
        Thu, 12 Jan 2023 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533698;
        bh=YQKS/rpStmGrZKPeSL0eAJmUklWKF0SSZbbLL7gi+k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uodhnLc+6NkPY0lqe3iw2hCAU7euo44q8Kj15eIP4HB0uOzz12D/1v1lYURma3rS7
         RCtDrM45FK0vjhd0DAiGN6tkDh+onf0Tp2xfzov4D+YZmKI1mr41jsNpeEUpV3OzDA
         OU+KL1OYGh3Nz1+D6U5LGZeQg72KmHNyVbWrWmts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+a3e6acd85ded5c16a709@syzkaller.appspotmail.com,
        Hawkins Jiawei <yin31149@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Ian Kent <raven@themaw.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 535/783] hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()
Date:   Thu, 12 Jan 2023 14:54:11 +0100
Message-Id: <20230112135548.999274729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index a2f43f1a85f8..5181e6d4e18c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1261,7 +1261,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->max_size_opt = memparse(param->string, &rest);
 		ctx->max_val_type = SIZE_STD;
@@ -1271,7 +1271,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_nr_inodes:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->nr_inodes = memparse(param->string, &rest);
 		return 0;
@@ -1287,7 +1287,7 @@ static int hugetlbfs_parse_param(struct fs_context *fc, struct fs_parameter *par
 
 	case Opt_min_size:
 		/* memparse() will accept a K/M/G without a digit */
-		if (!isdigit(param->string[0]))
+		if (!param->string || !isdigit(param->string[0]))
 			goto bad_val;
 		ctx->min_size_opt = memparse(param->string, &rest);
 		ctx->min_val_type = SIZE_STD;
-- 
2.35.1



