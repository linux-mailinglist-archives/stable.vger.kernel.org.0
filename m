Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59AD54A5D0
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353194AbiFNCTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354602AbiFNCT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:19:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7523ED3B;
        Mon, 13 Jun 2022 19:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A88E9B8169E;
        Tue, 14 Jun 2022 02:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268D2C34114;
        Tue, 14 Jun 2022 02:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172594;
        bh=R/DU5ussio9VSKRaz4p16oSabeAx7muJAL9aw2UUGzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=p3kv65/sGCfvp+lWIhyNs7qXEUFpLRnA9eTBye/+FDomA/o9MrI3aU8kHC3aT/aq4
         oyMv9o+6R/qXovf/cOclFpKaBgAiezt8lRYjH4Q6NKdbs5pRUXyTxbbfImuKcAvVuM
         vEnMO4gScWyN3CNmqfKYgG4lu+KxWTy+Ez4u+7O3w9N5liI70vU1+s2p7Ev9HwM3TA
         g6YCrFK3ZepB0uR5T1MEaP13XBeuUA3cwQSB7JSNrPRY770ZJob/Z/bnIOL3CM7n2W
         nsQqLBVhnMl9FyBTz+qke1KhZtUpgYO4kEsoImAmO4Y6kRyAunfSQ4RTF6DsLoJgxK
         wCvlWNJBCE2Fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     He Ying <heying24@huawei.com>, Wanming Hu <huwanming@huaweil.com>,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 01/18] powerpc/kasan: Silence KASAN warnings in __get_wchan()
Date:   Mon, 13 Jun 2022 22:09:24 -0400
Message-Id: <20220614020941.1100702-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: He Ying <heying24@huawei.com>

[ Upstream commit a1b29ba2f2c171b9bea73be993bfdf0a62d37d15 ]

The following KASAN warning was reported in our kernel.

  BUG: KASAN: stack-out-of-bounds in get_wchan+0x188/0x250
  Read of size 4 at addr d216f958 by task ps/14437

  CPU: 3 PID: 14437 Comm: ps Tainted: G           O      5.10.0 #1
  Call Trace:
  [daa63858] [c0654348] dump_stack+0x9c/0xe4 (unreliable)
  [daa63888] [c035cf0c] print_address_description.constprop.3+0x8c/0x570
  [daa63908] [c035d6bc] kasan_report+0x1ac/0x218
  [daa63948] [c00496e8] get_wchan+0x188/0x250
  [daa63978] [c0461ec8] do_task_stat+0xce8/0xe60
  [daa63b98] [c0455ac8] proc_single_show+0x98/0x170
  [daa63bc8] [c03cab8c] seq_read_iter+0x1ec/0x900
  [daa63c38] [c03cb47c] seq_read+0x1dc/0x290
  [daa63d68] [c037fc94] vfs_read+0x164/0x510
  [daa63ea8] [c03808e4] ksys_read+0x144/0x1d0
  [daa63f38] [c005b1dc] ret_from_syscall+0x0/0x38
  --- interrupt: c00 at 0x8fa8f4
      LR = 0x8fa8cc

  The buggy address belongs to the page:
  page:98ebcdd2 refcount:0 mapcount:0 mapping:00000000 index:0x2 pfn:0x1216f
  flags: 0x0()
  raw: 00000000 00000000 01010122 00000000 00000002 00000000 ffffffff 00000000
  raw: 00000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   d216f800: 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00 00 00 00
   d216f880: f2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >d216f900: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00
                                            ^
   d216f980: f2 f2 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 00 00
   d216fa00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

After looking into this issue, I find the buggy address belongs
to the task stack region. It seems KASAN has something wrong.
I look into the code of __get_wchan in x86 architecture and
find the same issue has been resolved by the commit
f7d27c35ddff ("x86/mm, kasan: Silence KASAN warnings in get_wchan()").
The solution could be applied to powerpc architecture too.

As Andrey Ryabinin said, get_wchan() is racy by design, it may
access volatile stack of running task, thus it may access
redzone in a stack frame and cause KASAN to warn about this.

Use READ_ONCE_NOCHECK() to silence these warnings.

Reported-by: Wanming Hu <huwanming@huaweil.com>
Signed-off-by: He Ying <heying24@huawei.com>
Signed-off-by: Chen Jingwen <chenjingwen6@huawei.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220121014418.155675-1-heying24@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 02b69a68139c..56c33285b1df 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2017,12 +2017,12 @@ unsigned long get_wchan(struct task_struct *p)
 		return 0;
 
 	do {
-		sp = *(unsigned long *)sp;
+		sp = READ_ONCE_NOCHECK(*(unsigned long *)sp);
 		if (!validate_sp(sp, p, STACK_FRAME_OVERHEAD) ||
 		    p->state == TASK_RUNNING)
 			return 0;
 		if (count > 0) {
-			ip = ((unsigned long *)sp)[STACK_FRAME_LR_SAVE];
+			ip = READ_ONCE_NOCHECK(((unsigned long *)sp)[STACK_FRAME_LR_SAVE]);
 			if (!in_sched_functions(ip))
 				return ip;
 		}
-- 
2.35.1

