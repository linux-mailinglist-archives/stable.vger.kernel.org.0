Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDCC549579
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352868AbiFMLUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353487AbiFMLTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6193B039;
        Mon, 13 Jun 2022 03:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81BC6B80EA7;
        Mon, 13 Jun 2022 10:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F4EC34114;
        Mon, 13 Jun 2022 10:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116876;
        bh=iNqspggipeUsbiMfTH6H+Ij0XcKQnipbgyxVjleXhoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crpbkRfp39h5GBuyAcR8iIT8zY/4HaK/h6L7y64/9jewDN7B173Wpyk5aI4WeR4kC
         F9v0ToVGRjHMxXBdiZKxoUU1g+L/6FSCnlplkFhWHqDdVizArYFJG0oc6Eu+uyoWNn
         6b4zgIOH0tVcOxbWa1qYfCt7lox+HOqsMpxnhsvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 209/411] f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()
Date:   Mon, 13 Jun 2022 12:08:02 +0200
Message-Id: <20220613094934.924107208@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Chao Yu <chao@kernel.org>

commit 4d17e6fe9293d57081ffdc11e1cf313e25e8fd9e upstream.

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215897

I have encountered a bug in F2FS file system in kernel v5.17.

The kernel should enable CONFIG_KASAN=y and CONFIG_KASAN_INLINE=y. You can
reproduce the bug by running the following commands:

The kernel message is shown below:

kernel BUG at fs/f2fs/f2fs.h:2511!
Call Trace:
 f2fs_remove_inode_page+0x2a2/0x830
 f2fs_evict_inode+0x9b7/0x1510
 evict+0x282/0x4e0
 do_unlinkat+0x33a/0x540
 __x64_sys_unlinkat+0x8e/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is: .total_valid_block_count or .total_valid_node_count
could fuzzed to zero, then once dec_valid_node_count() was called, it
will cause BUG_ON(), this patch fixes to print warning info and set
SBI_NEED_FSCK into CP instead of panic.

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2100,11 +2100,17 @@ static inline void dec_valid_node_count(
 {
 	spin_lock(&sbi->stat_lock);
 
-	f2fs_bug_on(sbi, !sbi->total_valid_block_count);
-	f2fs_bug_on(sbi, !sbi->total_valid_node_count);
+	if (unlikely(!sbi->total_valid_block_count ||
+			!sbi->total_valid_node_count)) {
+		f2fs_warn(sbi, "dec_valid_node_count: inconsistent block counts, total_valid_block:%u, total_valid_node:%u",
+			  sbi->total_valid_block_count,
+			  sbi->total_valid_node_count);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+	} else {
+		sbi->total_valid_block_count--;
+		sbi->total_valid_node_count--;
+	}
 
-	sbi->total_valid_node_count--;
-	sbi->total_valid_block_count--;
 	if (sbi->reserved_blocks &&
 		sbi->current_reserved_blocks < sbi->reserved_blocks)
 		sbi->current_reserved_blocks++;


