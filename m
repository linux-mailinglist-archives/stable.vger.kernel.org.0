Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59386B45FB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjCJOjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjCJOi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F2A23C5C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:38:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EFF1616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16494C4339C;
        Fri, 10 Mar 2023 14:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459127;
        bh=eR7P7/l56T1G2Ylfayjn3tW6eIxBYUswUi1IVXg8dnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxbSEU+Zpv12XajtViWQDO0rsG3qjvxz4mNse8FY4hf1gremxSUC8YdIsv0cd6Ieh
         O6eefSw73eN4zBqe8PxHZl+oRSC53R6E6uJErhUyGSBlOqC0pBn605pC0NyBfOZE0p
         qkVuiZhx63Pqljcp4zYJFrGBWmDMUyYYLnO2x6Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 216/357] s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler
Date:   Fri, 10 Mar 2023 14:38:25 +0100
Message-Id: <20230310133744.237649794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 42e19e6f04984088b6f9f0507c4c89a8152d9730 upstream.

Recent test_kprobe_missed kprobes kunit test uncovers the following error
(reported when CONFIG_DEBUG_ATOMIC_SLEEP is enabled):

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 662, name: kunit_try_catch
preempt_count: 0, expected: 0
RCU nest depth: 0, expected: 0
no locks held by kunit_try_catch/662.
irq event stamp: 280
hardirqs last  enabled at (279): [<00000003e60a3d42>] __do_pgm_check+0x17a/0x1c0
hardirqs last disabled at (280): [<00000003e3bd774a>] kprobe_exceptions_notify+0x27a/0x318
softirqs last  enabled at (0): [<00000003e3c5c890>] copy_process+0x14a8/0x4c80
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 46 PID: 662 Comm: kunit_try_catch Tainted: G                 N 6.2.0-173644-g44c18d77f0c0 #2
Hardware name: IBM 3931 A01 704 (LPAR)
Call Trace:
 [<00000003e60a3a00>] dump_stack_lvl+0x120/0x198
 [<00000003e3d02e82>] __might_resched+0x60a/0x668
 [<00000003e60b9908>] __mutex_lock+0xc0/0x14e0
 [<00000003e60bad5a>] mutex_lock_nested+0x32/0x40
 [<00000003e3f7b460>] unregister_kprobe+0x30/0xd8
 [<00000003e51b2602>] test_kprobe_missed+0xf2/0x268
 [<00000003e51b5406>] kunit_try_run_case+0x10e/0x290
 [<00000003e51b7dfa>] kunit_generic_run_threadfn_adapter+0x62/0xb8
 [<00000003e3ce30f8>] kthread+0x2d0/0x398
 [<00000003e3b96afa>] __ret_from_fork+0x8a/0xe8
 [<00000003e60ccada>] ret_from_fork+0xa/0x40

The reason for this error report is that kprobes handling code failed
to restore irqs.

The problem is that when kprobe is triggered from another kprobe
post_handler current sequence of enable_singlestep / disable_singlestep
is the following:
enable_singlestep  <- original kprobe (saves kprobe_saved_imask)
enable_singlestep  <- kprobe triggered from post_handler (clobbers kprobe_saved_imask)
disable_singlestep <- kprobe triggered from post_handler (restores kprobe_saved_imask)
disable_singlestep <- original kprobe (restores wrong clobbered kprobe_saved_imask)

There is just one kprobe_ctlblk per cpu and both calls saves and
loads irq mask to kprobe_saved_imask. To fix the problem simply move
resume_execution (which calls disable_singlestep) before calling
post_handler. This also fixes the problem that post_handler is called
with pt_regs which were not yet adjusted after single-stepping.

Cc: stable@vger.kernel.org
Fixes: 4ba069b802c2 ("[S390] add kprobes support.")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/kprobes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -509,12 +509,11 @@ static int post_kprobe_handler(struct pt
 	if (!p)
 		return 0;
 
+	resume_execution(p, regs);
 	if (kcb->kprobe_status != KPROBE_REENTER && p->post_handler) {
 		kcb->kprobe_status = KPROBE_HIT_SSDONE;
 		p->post_handler(p, regs, 0);
 	}
-
-	resume_execution(p, regs);
 	pop_kprobe(kcb);
 	preempt_enable_no_resched();
 


