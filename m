Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C1564F5D0
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLQANA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiLQAMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E8D13CEC;
        Fri, 16 Dec 2022 16:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF70B81E56;
        Sat, 17 Dec 2022 00:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7129FC433EF;
        Sat, 17 Dec 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235856;
        bh=EG+e9gZtWBtSxd40PAuJyMF+fz0eBwH1KLEtrXDgJ8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IR+F2bYdblhvglt4e6TMMKPGQ/Zu7djvxwj7vmeZ+jDClajtsACujBcl1xzTpwSa4
         XNN3BEi4hc6cDjXchOm1Z7MJaGPekP5VBoSj0GPEKxWmWVFGkKWDAdyFdzGW8x6fxc
         XZvz+l65Q8XADFx/VczL1hpYwcBPVLiw6MtzmX3qpYp2F2i2gYNorQpdeub5jP6AdI
         wRsbyH73Kr9+TrqGvMlKoClujA7avsON6UscjmyokNO9Sp0gy2exyjArWI1wQJuHmo
         hY+55nqIneH/PSrzgU679pk4aTyHw3CbuuM35mw5IhAi/Iq2gTeZqi1nZ7qBCFJ/0Z
         DBSW9AqZJn08Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Shixin <liushixin2@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.15 5/5] binfmt_misc: fix shift-out-of-bounds in check_special_flags
Date:   Fri, 16 Dec 2022 19:10:38 -0500
Message-Id: <20221217001038.41355-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217001038.41355-1-sashal@kernel.org>
References: <20221217001038.41355-1-sashal@kernel.org>
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
index e1eae7ea823a..bb202ad369d5 100644
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

