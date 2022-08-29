Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ABD5A4A2B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiH2Leg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiH2Ld0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2633B1CF;
        Mon, 29 Aug 2022 04:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C09FB80EFD;
        Mon, 29 Aug 2022 11:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44D0C433C1;
        Mon, 29 Aug 2022 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771949;
        bh=MxbjKBSd536T0KBxBEW8a5zFrhtcNCt1W0Z+VVvMzc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrJQ3vB8Jhjt9OIanA2mTRORQWkXEZCJIizAwIhUXWnZFrgukjVC4/93YxjmiDtnp
         VFVYTsUK9ar+CycYPSFqpUcWQsPlTbhsCPdb0pJ9jTiWZfRfwZ19TojTedMDsFpv4R
         6P5F7QC3Pyal4B3xMnPghmWdBHP9i69TkWVRdGbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 149/158] arm64/sme: Dont flush SVE register state when allocating SME storage
Date:   Mon, 29 Aug 2022 12:59:59 +0200
Message-Id: <20220829105815.354075797@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

commit 826a4fdd2ada9e5923c58bdd168f31a42e958ffc upstream.

Currently when taking a SME access trap we allocate storage for the SVE
register state in order to be able to handle storage of streaming mode SVE.
Due to the original usage in a purely SVE context the SVE register state
allocation this also flushes the register state for SVE if storage was
already allocated but in the SME context this is not desirable. For a SME
access trap to be taken the task must not be in streaming mode so either
there already is SVE register state present for regular SVE mode which would
be corrupted or the task does not have TIF_SVE and the flush is redundant.

Fix this by adding a flag to sve_alloc() indicating if we are in a SVE
context and need to flush the state. Freshly allocated storage is always
zeroed either way.

Fixes: 8bd7f91c03d8 ("arm64/sme: Implement traps and syscall handling for SME")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220817182324.638214-4-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h |    4 ++--
 arch/arm64/kernel/fpsimd.c      |   10 ++++++----
 arch/arm64/kernel/ptrace.c      |    6 +++---
 arch/arm64/kernel/signal.c      |    2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -153,7 +153,7 @@ struct vl_info {
 
 #ifdef CONFIG_ARM64_SVE
 
-extern void sve_alloc(struct task_struct *task);
+extern void sve_alloc(struct task_struct *task, bool flush);
 extern void fpsimd_release_task(struct task_struct *task);
 extern void fpsimd_sync_to_sve(struct task_struct *task);
 extern void fpsimd_force_sync_to_sve(struct task_struct *task);
@@ -256,7 +256,7 @@ size_t sve_state_size(struct task_struct
 
 #else /* ! CONFIG_ARM64_SVE */
 
-static inline void sve_alloc(struct task_struct *task) { }
+static inline void sve_alloc(struct task_struct *task, bool flush) { }
 static inline void fpsimd_release_task(struct task_struct *task) { }
 static inline void sve_sync_to_fpsimd(struct task_struct *task) { }
 static inline void sve_sync_from_fpsimd_zeropad(struct task_struct *task) { }
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -716,10 +716,12 @@ size_t sve_state_size(struct task_struct
  * do_sve_acc() case, there is no ABI requirement to hide stale data
  * written previously be task.
  */
-void sve_alloc(struct task_struct *task)
+void sve_alloc(struct task_struct *task, bool flush)
 {
 	if (task->thread.sve_state) {
-		memset(task->thread.sve_state, 0, sve_state_size(task));
+		if (flush)
+			memset(task->thread.sve_state, 0,
+			       sve_state_size(task));
 		return;
 	}
 
@@ -1389,7 +1391,7 @@ void do_sve_acc(unsigned long esr, struc
 		return;
 	}
 
-	sve_alloc(current);
+	sve_alloc(current, true);
 	if (!current->thread.sve_state) {
 		force_sig(SIGKILL);
 		return;
@@ -1440,7 +1442,7 @@ void do_sme_acc(unsigned long esr, struc
 		return;
 	}
 
-	sve_alloc(current);
+	sve_alloc(current, false);
 	sme_alloc(current);
 	if (!current->thread.sve_state || !current->thread.za_state) {
 		force_sig(SIGKILL);
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -882,7 +882,7 @@ static int sve_set_common(struct task_st
 		 * state and ensure there's storage.
 		 */
 		if (target->thread.svcr != old_svcr)
-			sve_alloc(target);
+			sve_alloc(target, true);
 	}
 
 	/* Registers: FPSIMD-only case */
@@ -912,7 +912,7 @@ static int sve_set_common(struct task_st
 		goto out;
 	}
 
-	sve_alloc(target);
+	sve_alloc(target, true);
 	if (!target->thread.sve_state) {
 		ret = -ENOMEM;
 		clear_tsk_thread_flag(target, TIF_SVE);
@@ -1082,7 +1082,7 @@ static int za_set(struct task_struct *ta
 
 	/* Ensure there is some SVE storage for streaming mode */
 	if (!target->thread.sve_state) {
-		sve_alloc(target);
+		sve_alloc(target, false);
 		if (!target->thread.sve_state) {
 			clear_thread_flag(TIF_SME);
 			ret = -ENOMEM;
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -307,7 +307,7 @@ static int restore_sve_fpsimd_context(st
 	fpsimd_flush_task_state(current);
 	/* From now, fpsimd_thread_switch() won't touch thread.sve_state */
 
-	sve_alloc(current);
+	sve_alloc(current, true);
 	if (!current->thread.sve_state) {
 		clear_thread_flag(TIF_SVE);
 		return -ENOMEM;


