Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11A6AF0AF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCGSeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCGSdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:33:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515C5B5AB2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47CEDB819D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBDDC433D2;
        Tue,  7 Mar 2023 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213517;
        bh=W0X+bglo/2EJq1DlaNXfa7q21jxRw4oo7JaOBAQ6veU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym4a62Tg0prAUmN4vs9Wn+uGYcvvh6qeQzxtDDgmhRdza2WVYTIk5NSdyAXAa0d/t
         N+EHfjgZuLjZ5nSnwB4CQyRPVZ+KqgEIkVpBqfuiGAtf6EgGAVSsd9JFOOyS5r/BCx
         cEu9AdUWKssVby2Y0p979Oc5ZjqHEnprsysdDVmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 531/885] exit: Detect and fix irq disabled state in oops
Date:   Tue,  7 Mar 2023 17:57:45 +0100
Message-Id: <20230307170025.545378180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 001c28e57187570e4b5aa4492c7a957fb6d65d7b ]

If a task oopses with irqs disabled, this can cause various cascading
problems in the oops path such as sleep-from-invalid warnings, and
potentially worse.

Since commit 0258b5fd7c712 ("coredump: Limit coredumps to a single
thread group"), the unconditional irq enable in coredump_task_exit()
will "fix" the irq state to be enabled early in do_exit(), so currently
this may not be triggerable, but that is coincidental and fragile.

Detect and fix the irqs_disabled() condition in the oops path before
calling do_exit(), similarly to the way in_atomic() is handled.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/lkml/20221004094401.708299-1-npiggin@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/exit.c b/kernel/exit.c
index 15dc2ec80c467..bccfa4218356e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -807,6 +807,8 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
+	WARN_ON(irqs_disabled());
+
 	synchronize_group_exit(tsk, code);
 
 	WARN_ON(tsk->plug);
@@ -938,6 +940,11 @@ void __noreturn make_task_dead(int signr)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	if (unlikely(irqs_disabled())) {
+		pr_info("note: %s[%d] exited with irqs disabled\n",
+			current->comm, task_pid_nr(current));
+		local_irq_enable();
+	}
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
 			current->comm, task_pid_nr(current),
-- 
2.39.2



