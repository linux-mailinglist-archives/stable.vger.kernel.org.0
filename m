Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A58C65EC0F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbjAENFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbjAENFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159F55A884
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A783961A10
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB497C433EF;
        Thu,  5 Jan 2023 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923933;
        bh=vMndOG5sdgeg8DD+EqgRVsExZdtKN+MFV/3z5NYiEF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtM/Ymxom6gaVNL98yyCFepS29IEdCCKSLnJYpty5Oofb6ubUwDm5WMBWLZG6w5Sh
         Mqi0e07I9ZeR4EZkR8eG/b3G1dpFxnAsXx2z+UfwO+wOB0ddgDkKTd2hQsU3UmPtAU
         YFHzhksnzjfjhN5TJwwwz90j5dfQLm69FSpmDTY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 179/251] binfmt_misc: fix shift-out-of-bounds in check_special_flags
Date:   Thu,  5 Jan 2023 13:55:16 +0100
Message-Id: <20230105125342.987382933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index 2bda9245cabe..558e4007131e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -42,10 +42,10 @@ static LIST_HEAD(entries);
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



