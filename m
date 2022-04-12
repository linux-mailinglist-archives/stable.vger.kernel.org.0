Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30464FD48D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiDLHcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353709AbiDLHZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E3327B0C;
        Tue, 12 Apr 2022 00:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74A5560B2B;
        Tue, 12 Apr 2022 07:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FFCC385A1;
        Tue, 12 Apr 2022 07:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747038;
        bh=ZE0SPjc+O4SDdCybQMxqSDYtYnTmByEmCyRM9DcJuWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrJytjOCnsaj+oX/V7JRjW6GOQ6i8lXjFH2PRujuOeccpIb5E4Jyg/bABhJqyJwuP
         8EFIXtbSCtyQeyy4Yi2yDQmUaDTtM1W8uXUqV3Nn372+6rQfVS1Q2JWJ9x5/yOp2ED
         cGsiAhRZEz98JJ/XnMbiefhRvjIPd4yvlrl4Zsdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 221/285] highmem: fix checks in __kmap_local_sched_{in,out}
Date:   Tue, 12 Apr 2022 08:31:18 +0200
Message-Id: <20220412062950.035975238@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 66f133ceab7456c789f70a242991ed1b27ba1c3d upstream.

When CONFIG_DEBUG_KMAP_LOCAL is enabled __kmap_local_sched_{in,out} check
that even slots in the tsk->kmap_ctrl.pteval are unmapped.  The slots are
initialized with 0 value, but the check is done with pte_none.  0 pte
however does not necessarily mean that pte_none will return true.  e.g.
on xtensa it returns false, resulting in the following runtime warnings:

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:627 __kmap_local_sched_out+0x51/0x108
 CPU: 0 PID: 101 Comm: touch Not tainted 5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_out+0x51/0x108
   __schedule+0x71a/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

 WARNING: CPU: 0 PID: 101 at mm/highmem.c:664 __kmap_local_sched_in+0x50/0xe0
 CPU: 0 PID: 101 Comm: touch Tainted: G        W         5.17.0-rc7-00010-gd3a1cdde80d2-dirty #13
 Call Trace:
   dump_stack+0xc/0x40
   __warn+0x8f/0x174
   warn_slowpath_fmt+0x48/0xac
   __kmap_local_sched_in+0x50/0xe0
   finish_task_switch$isra$0+0x1ce/0x2f8
   __schedule+0x86e/0x9c4
   preempt_schedule_irq+0xa0/0xe0
   common_exception_return+0x5c/0x93
   do_wp_page+0x30e/0x330
   handle_mm_fault+0xa70/0xc3c
   do_page_fault+0x1d8/0x3c4
   common_exception+0x7f/0x7f

Fix it by replacing !pte_none(pteval) with pte_val(pteval) != 0.

Link: https://lkml.kernel.org/r/20220403235159.3498065-1-jcmvbkbc@gmail.com
Fixes: 5fbda3ecd14a ("sched: highmem: Store local kmaps in task struct")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -624,7 +624,7 @@ void __kmap_local_sched_out(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
@@ -661,7 +661,7 @@ void __kmap_local_sched_in(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))


