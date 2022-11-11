Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04341626523
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 00:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKKXGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 18:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiKKXGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 18:06:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE31004D;
        Fri, 11 Nov 2022 15:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45784B8280A;
        Fri, 11 Nov 2022 23:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8F4C433C1;
        Fri, 11 Nov 2022 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668207977;
        bh=I5sTDCJvef0BymL8tvIOiXWjX/FhdAJjwLl+axc0AaA=;
        h=Date:To:From:Subject:From;
        b=cTUlG3RPjGHmaTIsR1ysBYAsLimMH+pYfbDH8rwuWa4ssWr4pg+z+RVUDzrogigzj
         ro6Rbrzt5CVGaWhEoIiWGT457ncrCmB7d32aSFksHdZJ03ii21xuMMj+RuGl/lpWda
         PLpF1COfkbai0aDaw1Je3PNdBU5BxPxgHDyiEUW8=
Date:   Fri, 11 Nov 2022 15:06:17 -0800
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        stable@vger.kernel.org, oberpar@linux.ibm.com,
        ndesaulniers@google.com, nathan@kernel.org, quic_mojha@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-clang-fix-the-buffer-overflow-issue.patch added to mm-hotfixes-unstable branch
Message-Id: <20221111230617.CD8F4C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: gcov: clang: fix the buffer overflow issue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcov-clang-fix-the-buffer-overflow-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-clang-fix-the-buffer-overflow-issue.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mukesh Ojha <quic_mojha@quicinc.com>
Subject: gcov: clang: fix the buffer overflow issue
Date: Thu, 10 Nov 2022 00:31:37 +0530

Currently, in clang version of gcov code when module is getting removed
gcov_info_add() incorrectly adds the sfn_ptr->counter to all the
dst->functions and it result in the kernel panic in below crash report. 
Fix this by properly handling it.

[    8.899094][  T599] Unable to handle kernel write to read-only memory at virtual address ffffff80461cc000
[    8.899100][  T599] Mem abort info:
[    8.899102][  T599]   ESR = 0x9600004f
[    8.899103][  T599]   EC = 0x25: DABT (current EL), IL = 32 bits
[    8.899105][  T599]   SET = 0, FnV = 0
[    8.899107][  T599]   EA = 0, S1PTW = 0
[    8.899108][  T599]   FSC = 0x0f: level 3 permission fault
[    8.899110][  T599] Data abort info:
[    8.899111][  T599]   ISV = 0, ISS = 0x0000004f
[    8.899113][  T599]   CM = 0, WnR = 1
[    8.899114][  T599] swapper pgtable: 4k pages, 39-bit VAs, pgdp=00000000ab8de000
[    8.899116][  T599] [ffffff80461cc000] pgd=18000009ffcde003, p4d=18000009ffcde003, pud=18000009ffcde003, pmd=18000009ffcad003, pte=00600000c61cc787
[    8.899124][  T599] Internal error: Oops: 9600004f [#1] PREEMPT SMP
[    8.899265][  T599] Skip md ftrace buffer dump for: 0x1609e0
....
..,
[    8.899544][  T599] CPU: 7 PID: 599 Comm: modprobe Tainted: G S         OE     5.15.41-android13-8-g38e9b1af6bce #1
[    8.899547][  T599] Hardware name: XXX (DT)
[    8.899549][  T599] pstate: 82400005 (Nzcv daif +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
[    8.899551][  T599] pc : gcov_info_add+0x9c/0xb8
[    8.899557][  T599] lr : gcov_event+0x28c/0x6b8
[    8.899559][  T599] sp : ffffffc00e733b00
[    8.899560][  T599] x29: ffffffc00e733b00 x28: ffffffc00e733d30 x27: ffffffe8dc297470
[    8.899563][  T599] x26: ffffffe8dc297000 x25: ffffffe8dc297000 x24: ffffffe8dc297000
[    8.899566][  T599] x23: ffffffe8dc0a6200 x22: ffffff880f68bf20 x21: 0000000000000000
[    8.899569][  T599] x20: ffffff880f68bf00 x19: ffffff8801babc00 x18: ffffffc00d7f9058
[    8.899572][  T599] x17: 0000000000088793 x16: ffffff80461cbe00 x15: 9100052952800785
[    8.899575][  T599] x14: 0000000000000200 x13: 0000000000000041 x12: 9100052952800785
[    8.899577][  T599] x11: ffffffe8dc297000 x10: ffffffe8dc297000 x9 : ffffff80461cbc80
[    8.899580][  T599] x8 : ffffff8801babe80 x7 : ffffffe8dc2ec000 x6 : ffffffe8dc2ed000
[    8.899583][  T599] x5 : 000000008020001f x4 : fffffffe2006eae0 x3 : 000000008020001f
[    8.899586][  T599] x2 : ffffff8027c49200 x1 : ffffff8801babc20 x0 : ffffff80461cb3a0
[    8.899589][  T599] Call trace:
[    8.899590][  T599]  gcov_info_add+0x9c/0xb8
[    8.899592][  T599]  gcov_module_notifier+0xbc/0x120
[    8.899595][  T599]  blocking_notifier_call_chain+0xa0/0x11c
[    8.899598][  T599]  do_init_module+0x2a8/0x33c
[    8.899600][  T599]  load_module+0x23cc/0x261c
[    8.899602][  T599]  __arm64_sys_finit_module+0x158/0x194
[    8.899604][  T599]  invoke_syscall+0x94/0x2bc
[    8.899607][  T599]  el0_svc_common+0x1d8/0x34c
[    8.899609][  T599]  do_el0_svc+0x40/0x54
[    8.899611][  T599]  el0_svc+0x94/0x2f0
[    8.899613][  T599]  el0t_64_sync_handler+0x88/0xec
[    8.899615][  T599]  el0t_64_sync+0x1b4/0x1b8
[    8.899618][  T599] Code: f905f56c f86e69ec f86e6a0f 8b0c01ec (f82e6a0c)
[    8.899620][  T599] ---[ end trace ed5218e9e5b6e2e6 ]---

Link: https://lkml.kernel.org/r/1668020497-13142-1-git-send-email-quic_mojha@quicinc.com
Fixes: e178a5beb369 ("gcov: clang support")
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/gcov/clang.c~gcov-clang-fix-the-buffer-overflow-issue
+++ a/kernel/gcov/clang.c
@@ -280,6 +280,8 @@ void gcov_info_add(struct gcov_info *dst
 
 		for (i = 0; i < sfn_ptr->num_counters; i++)
 			dfn_ptr->counters[i] += sfn_ptr->counters[i];
+
+		sfn_ptr = list_next_entry(sfn_ptr, head);
 	}
 }
 
_

Patches currently in -mm which might be from quic_mojha@quicinc.com are

gcov-clang-fix-the-buffer-overflow-issue.patch

