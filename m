Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850411AA349
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503981AbgDONG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897094AbgDOLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F92920737;
        Wed, 15 Apr 2020 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950556;
        bh=Le5r4ZEgqHViB7UDMuTUHMRwchWcpxKe6N8tGPIdKdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twUXnbkxpBhf/riUONtD4bwFwRT9Vt3foYA9D0BJamIKVv6ey8auSuK0AYChUJvM+
         3fNJl0rSEnAG1ZyxE1MZAlyEMSfcEvP+WOFeHWcBCDCaTYGrqJFWdfw/Y+QsheIgF/
         InGmOQuvgz+YeRoaWaFil7ect+j/y62Ys5ZDQyK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.6 062/129] x86/xen: Make the boot CPU idle task reliable
Date:   Wed, 15 Apr 2020 07:33:37 -0400
Message-Id: <20200415113445.11881-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

[ Upstream commit 2f62f36e62daec43aa7b9633ef7f18e042a80bed ]

The unwinder reports the boot CPU idle task's stack on XEN PV as
unreliable, which affects at least live patching. There are two reasons
for this. First, the task does not follow the x86 convention that its
stack starts at the offset right below saved pt_regs. It allows the
unwinder to easily detect the end of the stack and verify it. Second,
startup_xen() function does not store the return address before jumping
to xen_start_kernel() which confuses the unwinder.

Amend both issues by moving the starting point of initial stack in
startup_xen() and storing the return address before the jump, which is
exactly what call instruction does.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-head.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1d0cee3163e41..d63806e1ff7ae 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -35,7 +35,11 @@ SYM_CODE_START(startup_xen)
 	rep __ASM_SIZE(stos)
 
 	mov %_ASM_SI, xen_start_info
-	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
+#ifdef CONFIG_X86_64
+	mov initial_stack(%rip), %rsp
+#else
+	mov pa(initial_stack), %esp
+#endif
 
 #ifdef CONFIG_X86_64
 	/* Set up %gs.
@@ -51,7 +55,7 @@ SYM_CODE_START(startup_xen)
 	wrmsr
 #endif
 
-	jmp xen_start_kernel
+	call xen_start_kernel
 SYM_CODE_END(startup_xen)
 	__FINIT
 #endif
-- 
2.20.1

