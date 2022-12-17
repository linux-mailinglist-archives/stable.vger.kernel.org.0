Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB664F5E5
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiLQAOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiLQANS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:13:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042887508B;
        Fri, 16 Dec 2022 16:11:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D31962295;
        Sat, 17 Dec 2022 00:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB94BC433F1;
        Sat, 17 Dec 2022 00:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235880;
        bh=Y7QUCuIeT36PPyWNZwZPgzNoFAeSyVVRpGZ7GZi+7cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5AnnJqNT/qJymgeecCYgyRc3NDLcvncZYXourw3GHb44m29V0ETQ8S0hRv61eBKn
         gMcwyVZbnz2L5sheozfYwDGNuhafidUs2qx7ztNGPMe5acjAUzTE7IRMHBZ+Fs0I1X
         JEEtK4mAUDZYbdCDspX7f3nQIuzgSD5Dg1Qe+m4UeL8ihoJzBCJEBcC+bloUigX56Y
         mlaljeCfyudqk1Qo6zVqEVPKRh91yHPLkoC6KqpkS8LMDX/+z+QPn/pU1C938WMVFM
         rf+6zAmvnO7njkNRkrxp1x04HOH3/bPLaj0xCe/fU30llNK3cEg7m9HYJpSEmNvRN0
         nIJcX8/g60LRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Shixin <liushixin2@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 2/2] binfmt_misc: fix shift-out-of-bounds in check_special_flags
Date:   Fri, 16 Dec 2022 19:11:15 -0500
Message-Id: <20221217001116.41497-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001116.41497-1-sashal@kernel.org>
References: <20221217001116.41497-1-sashal@kernel.org>
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

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 6a46bf558803dd2b959ca7435a5c143efe837217 ]

UBSAN reported a shift-out-of-bounds warning:

 left shift of 1 by 31 places cannot be represented in type 'int'
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:106
  ubsan_epilogue+0xa/0x44 lib/ubsan.c:151
  __ubsan_handle_shift_out_of_bounds+0x1e7/0x208 lib/ubsan.c:322
  check_special_flags fs/binfmt_misc.c:241 [inline]
  create_entry fs/binfmt_misc.c:456 [inline]
  bm_register_write+0x9d3/0xa20 fs/binfmt_misc.c:654
  vfs_write+0x11e/0x580 fs/read_write.c:582
  ksys_write+0xcf/0x120 fs/read_write.c:637
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x34/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x4194e1

Since the type of Node's flags is unsigned long, we should define these
macros with same type too.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102025123.1117184-1-liushixin2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_misc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 056a68292e15..23b563ff0dd7 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -44,10 +44,10 @@ static LIST_HEAD(entries);
 static int enabled = 1;
 
 enum {Enabled, Magic};
-#define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
-#define MISC_FMT_OPEN_BINARY (1 << 30)
-#define MISC_FMT_CREDENTIALS (1 << 29)
-#define MISC_FMT_OPEN_FILE (1 << 28)
+#define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
+#define MISC_FMT_OPEN_BINARY (1UL << 30)
+#define MISC_FMT_CREDENTIALS (1UL << 29)
+#define MISC_FMT_OPEN_FILE (1UL << 28)
 
 typedef struct {
 	struct list_head list;
-- 
2.35.1

