Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE45A0689
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiHYBlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbiHYBko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B39C23C;
        Wed, 24 Aug 2022 18:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D62CD61A2D;
        Thu, 25 Aug 2022 01:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBAEC433C1;
        Thu, 25 Aug 2022 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391512;
        bh=51+dbsOrzG1DgFLUJjl+5h+eWXlCUo0Yw9U8muEZ8CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYZC+4/pLy5ZecqN6NaYnniiVfeDTnXIOrHmjmB0naEcuHgyCkgDWctLKDBDHub01
         Hjhfll0YjS10fWoPzWjlGnji5C0Jsxh0yIFlSm+Gba8D8tMyj5pj17mTIdGsk4MOOK
         9hOyCLMSiWx8sp4mgW0yiRKT+TtUEi7+UTdP2dHRrFw7wCaa+7GXgw8Pjw6NoSnZhV
         Y1SFdO5zkWpdq0tVo3WHYyPCETqpjRf/2OEHUYSqqHHnM25D7egrZs6EIUCiooPe4t
         zTPQNn19GBq9L+FgQSylto27jiM5uiMqcdgc31nlBQS1uz5bOD1RI6LujIpyOATuLe
         zwUWrflIa5i7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Jihong <yangjihong1@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.15 20/20] ftrace: Fix NULL pointer dereference in is_ftrace_trampoline when ftrace is dead
Date:   Wed, 24 Aug 2022 21:37:12 -0400
Message-Id: <20220825013713.22656-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013713.22656-1-sashal@kernel.org>
References: <20220825013713.22656-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit c3b0f72e805f0801f05fa2aa52011c4bfc694c44 ]

ftrace_startup does not remove ops from ftrace_ops_list when
ftrace_startup_enable fails:

register_ftrace_function
  ftrace_startup
    __register_ftrace_function
      ...
      add_ftrace_ops(&ftrace_ops_list, ops)
      ...
    ...
    ftrace_startup_enable // if ftrace failed to modify, ftrace_disabled is set to 1
    ...
  return 0 // ops is in the ftrace_ops_list.

When ftrace_disabled = 1, unregister_ftrace_function simply returns without doing anything:
unregister_ftrace_function
  ftrace_shutdown
    if (unlikely(ftrace_disabled))
            return -ENODEV;  // return here, __unregister_ftrace_function is not executed,
                             // as a result, ops is still in the ftrace_ops_list
    __unregister_ftrace_function
    ...

If ops is dynamically allocated, it will be free later, in this case,
is_ftrace_trampoline accesses NULL pointer:

is_ftrace_trampoline
  ftrace_ops_trampoline
    do_for_each_ftrace_op(op, ftrace_ops_list) // OOPS! op may be NULL!

Syzkaller reports as follows:
[ 1203.506103] BUG: kernel NULL pointer dereference, address: 000000000000010b
[ 1203.508039] #PF: supervisor read access in kernel mode
[ 1203.508798] #PF: error_code(0x0000) - not-present page
[ 1203.509558] PGD 800000011660b067 P4D 800000011660b067 PUD 130fb8067 PMD 0
[ 1203.510560] Oops: 0000 [#1] SMP KASAN PTI
[ 1203.511189] CPU: 6 PID: 29532 Comm: syz-executor.2 Tainted: G    B   W         5.10.0 #8
[ 1203.512324] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[ 1203.513895] RIP: 0010:is_ftrace_trampoline+0x26/0xb0
[ 1203.514644] Code: ff eb d3 90 41 55 41 54 49 89 fc 55 53 e8 f2 00 fd ff 48 8b 1d 3b 35 5d 03 e8 e6 00 fd ff 48 8d bb 90 00 00 00 e8 2a 81 26 00 <48> 8b ab 90 00 00 00 48 85 ed 74 1d e8 c9 00 fd ff 48 8d bb 98 00
[ 1203.518838] RSP: 0018:ffffc900012cf960 EFLAGS: 00010246
[ 1203.520092] RAX: 0000000000000000 RBX: 000000000000007b RCX: ffffffff8a331866
[ 1203.521469] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 000000000000010b
[ 1203.522583] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8df18b07
[ 1203.523550] R10: fffffbfff1be3160 R11: 0000000000000001 R12: 0000000000478399
[ 1203.524596] R13: 0000000000000000 R14: ffff888145088000 R15: 0000000000000008
[ 1203.525634] FS:  00007f429f5f4700(0000) GS:ffff8881daf00000(0000) knlGS:0000000000000000
[ 1203.526801] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1203.527626] CR2: 000000000000010b CR3: 0000000170e1e001 CR4: 00000000003706e0
[ 1203.528611] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1203.529605] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Therefore, when ftrace_startup_enable fails, we need to rollback registration
process and remove ops from ftrace_ops_list.

Link: https://lkml.kernel.org/r/20220818032659.56209-1-yangjihong1@huawei.com

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e215a9c96971..e10cf1b54812 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2901,6 +2901,16 @@ int ftrace_startup(struct ftrace_ops *ops, int command)
 
 	ftrace_startup_enable(command);
 
+	/*
+	 * If ftrace is in an undefined state, we just remove ops from list
+	 * to prevent the NULL pointer, instead of totally rolling it back and
+	 * free trampoline, because those actions could cause further damage.
+	 */
+	if (unlikely(ftrace_disabled)) {
+		__unregister_ftrace_function(ops);
+		return -ENODEV;
+	}
+
 	ops->flags &= ~FTRACE_OPS_FL_ADDING;
 
 	return 0;
-- 
2.35.1

