Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8F464F5E0
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiLQANs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiLQAM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41384A5BE;
        Fri, 16 Dec 2022 16:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C95C622D8;
        Sat, 17 Dec 2022 00:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4DCC433F0;
        Sat, 17 Dec 2022 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235874;
        bh=F1JA5kgwiRUQgQMgSFHXyA042OntNyRNiUZKAZHDIBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcVE87skmLJ/8K5m2q/zAfV1SeLcjb9CZaIVztnVwZmyAlkxe67FcocHAdctwfMnr
         PdmwAbsSjzMjXKMNPyb9QllYS5yo+dAXwbfWZOlYIw1WLK+/FfLqBetZAhsnfsrS67
         5fK3OO8DImPQwbtyUNBSGfiI8FgCxT3n6pX5CfONLJ4TAMb6jLIjPu+OWKPMKX2vTU
         Biin2cjBeD/zrcXzmGWHciVXyw3D0DcBp/CJnkaCiCZpNeteTMk1UxmmhK+ZHEp6gC
         xtKg9f0THgxyMp1XwDPB+MTcCMzMrQ0hEpezUBhhw3f35tG2VTkfoSZBlFWolc1YZ1
         9LAaa2GfAn7gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Shixin <liushixin2@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.10 5/5] binfmt_misc: fix shift-out-of-bounds in check_special_flags
Date:   Fri, 16 Dec 2022 19:10:57 -0500
Message-Id: <20221217001058.41426-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001058.41426-1-sashal@kernel.org>
References: <20221217001058.41426-1-sashal@kernel.org>
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
index 11b5bf241955..ce0047feea72 100644
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

