Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B166AF0F9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjCGShR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjCGSfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:35:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A045ADBE8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DC9C6154D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC91C433EF;
        Tue,  7 Mar 2023 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213639;
        bh=MHvVvHcFFxtRpvQ1ATNLFyUwyZ4h6QIJd3v05fBfveY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrSXEx+xuL0xucAzgQOFJny8GRUUBba9r1vhEhbazOjWiF3xErmfgclfMfIxSHPlw
         8fXctPq5loI/AcXc4KmXqdNg4l8c1ydDyf4D7zUaW+Rk92teI5m9sg/ER/FBJSj+Jw
         x+GfRQn9dhATpk7SkD1wVguDAL2gjPTQ9oUqc1pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 541/885] x86/fpu: Dont set TIF_NEED_FPU_LOAD for PF_IO_WORKER threads
Date:   Tue,  7 Mar 2023 17:57:55 +0100
Message-Id: <20230307170025.996416408@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cb3ea4b7671b7cfbac3ee609976b790aebd0bbda ]

We don't set it on PF_KTHREAD threads as they never return to userspace,
and PF_IO_WORKER threads are identical in that regard. As they keep
running in the kernel until they die, skip setting the FPU flag on them.

More of a cosmetic thing that was found while debugging and
issue and pondering why the FPU flag is set on these threads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/560c844c-f128-555b-40c6-31baff27537f@kernel.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/sched.h | 2 +-
 arch/x86/kernel/fpu/context.h    | 2 +-
 arch/x86/kernel/fpu/core.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu/sched.h b/arch/x86/include/asm/fpu/sched.h
index b2486b2cbc6e0..c2d6cd78ed0c2 100644
--- a/arch/x86/include/asm/fpu/sched.h
+++ b/arch/x86/include/asm/fpu/sched.h
@@ -39,7 +39,7 @@ extern void fpu_flush_thread(void);
 static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
 {
 	if (cpu_feature_enabled(X86_FEATURE_FPU) &&
-	    !(current->flags & PF_KTHREAD)) {
+	    !(current->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		save_fpregs_to_fpstate(old_fpu);
 		/*
 		 * The save operation preserved register state, so the
diff --git a/arch/x86/kernel/fpu/context.h b/arch/x86/kernel/fpu/context.h
index 958accf2ccf07..9fcfa5c4dad79 100644
--- a/arch/x86/kernel/fpu/context.h
+++ b/arch/x86/kernel/fpu/context.h
@@ -57,7 +57,7 @@ static inline void fpregs_restore_userregs(void)
 	struct fpu *fpu = &current->thread.fpu;
 	int cpu = smp_processor_id();
 
-	if (WARN_ON_ONCE(current->flags & PF_KTHREAD))
+	if (WARN_ON_ONCE(current->flags & (PF_KTHREAD | PF_IO_WORKER)))
 		return;
 
 	if (!fpregs_state_valid(fpu, cpu)) {
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index dccce58201b7c..caf33486dc5ee 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -426,7 +426,7 @@ void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 
 	this_cpu_write(in_kernel_fpu, true);
 
-	if (!(current->flags & PF_KTHREAD) &&
+	if (!(current->flags & (PF_KTHREAD | PF_IO_WORKER)) &&
 	    !test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		set_thread_flag(TIF_NEED_FPU_LOAD);
 		save_fpregs_to_fpstate(&current->thread.fpu);
-- 
2.39.2



