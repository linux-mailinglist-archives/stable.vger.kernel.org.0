Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1EE491E07
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347413AbiARDqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347376AbiARClS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDC2C08C5D7;
        Mon, 17 Jan 2022 18:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE706612C8;
        Tue, 18 Jan 2022 02:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D225C36AF4;
        Tue, 18 Jan 2022 02:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473402;
        bh=XzhNkZxyer8awJv+RVsKsH09udznovulrHjfciVCME4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKID1t2cgl/J6Alu3PFKMKIFSDEZmixC4GSEqEpT9yiCVEueBeRktwl5GNi8eKLhD
         hNDHcvJCqyqf/cB5wMjfb52PtxouygL/tu4nUPRhNRn4ODK3Y136aHeL3NN17FBVdr
         axU1/z6ZWtIRd2uEDHcUZTAY+rTRROYdwRobP5f44+KEwydOWzuzn9tz+wVTXnSAkb
         HsOS+g0Z6qwdAGA1uCUZd16lEXpifkbSQBtWpo53DeZb7uthwT34PgkDR1/mYmy9vP
         8dxcugT2GLJwvJQL/+Oa9O0fO7kYNwD3TtmKfyYpCLaFgw3VVcA8j19b36KuSx1/OU
         a6wQHa9VWctHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 104/188] x86/mce: Allow instrumentation during task work queueing
Date:   Mon, 17 Jan 2022 21:30:28 -0500
Message-Id: <20220118023152.1948105-104-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 4fbce464db81a42f9a57ee242d6150ec7f996415 ]

Fixes

  vmlinux.o: warning: objtool: do_machine_check()+0xdb1: call to queue_task_work() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211208111343.8130-6-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 193204aee8801..c8d121085c8f7 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1454,6 +1454,14 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	if (worst != MCE_AR_SEVERITY && !kill_current_task)
 		goto out;
 
+	/*
+	 * Enable instrumentation around the external facilities like
+	 * task_work_add() (via queue_task_work()), fixup_exception() etc.
+	 * For now, that is. Fixing this properly would need a lot more involved
+	 * reorganization.
+	 */
+	instrumentation_begin();
+
 	/* Fault was in user mode and we need to take some action */
 	if ((m.cs & 3) == 3) {
 		/* If this triggers there is no way to recover. Die hard. */
@@ -1479,6 +1487,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		if (m.kflags & MCE_IN_KERNEL_COPYIN)
 			queue_task_work(&m, msg, kill_current_task);
 	}
+
+	instrumentation_end();
+
 out:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 }
-- 
2.34.1

