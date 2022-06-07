Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4760054222D
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385879AbiFHBPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1840083AbiFHAEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:04:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5655A6FA33;
        Tue,  7 Jun 2022 12:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1327B618EC;
        Tue,  7 Jun 2022 19:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B53C385A5;
        Tue,  7 Jun 2022 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629488;
        bh=nq6ivhsF8LEWQhXdFUAKW1Cj0mLljzuni6/4am2Ui/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGMyMz/SUZnEpvbnvEKsHm8zlXkBvyuBv9zc3rEWZCBOl5gtjogSOBVPxnTtIKIYe
         lSPOdY+HzVOkLpWXdU3lKInaiqgNPmKW/R+PHy/cyqWdxCSUi8SET3nbW3w9anq3/U
         h0Rw6LB0mdImEcBFk84uW0M9eXdC0M/oNJR9In4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 708/879] f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()
Date:   Tue,  7 Jun 2022 19:03:46 +0200
Message-Id: <20220607165023.405500059@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -2605,11 +2605,17 @@ static inline void dec_valid_node_count(
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


