Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7285299B91
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409659AbgJZXwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409649AbgJZXwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BDD21655;
        Mon, 26 Oct 2020 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756330;
        bh=U4B/0X6tZ+S10/tnV+8pBx5isrKe4N4+lJJrH4AokzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+pJGSPX02MLR8DrxA43zIIHkKrJDMCsobbn0ZYlaGNeWZn0F7hHeJRF5YMOo6EyU
         zRaBfclJvmrWhoew9AZIo/bl6h57RYFoJeWEbXW0Mhv2O4cWMSKLmRhdG+gUDLDwc/
         djQUSy5mGlUP93KOzxkrVjyy1htHjq2vcoTqA4Y0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.8 004/132] powerpc/watchpoint/ptrace: Fix SETHWDEBUG when CONFIG_HAVE_HW_BREAKPOINT=N
Date:   Mon, 26 Oct 2020 19:49:56 -0400
Message-Id: <20201026235205.1023962-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 9b6b7c680cc20971444d9f836e49fc98848bcd0a ]

When kernel is compiled with CONFIG_HAVE_HW_BREAKPOINT=N, user can
still create watchpoint using PPC_PTRACE_SETHWDEBUG, with limited
functionalities. But, such watchpoints are never firing because of
the missing privilege settings. Fix that.

It's safe to set HW_BRK_TYPE_PRIV_ALL because we don't really leak
any kernel address in signal info. Setting HW_BRK_TYPE_PRIV_ALL will
also help to find scenarios when kernel accesses user memory.

Reported-by: Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>
Suggested-by: Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902042945.129369-4-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/ptrace/ptrace-noadv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/ptrace/ptrace-noadv.c b/arch/powerpc/kernel/ptrace/ptrace-noadv.c
index 697c7e4b5877f..57a0ab822334f 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-noadv.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-noadv.c
@@ -217,7 +217,7 @@ long ppc_set_hwdebug(struct task_struct *child, struct ppc_hw_breakpoint *bp_inf
 		return -EIO;
 
 	brk.address = ALIGN_DOWN(bp_info->addr, HW_BREAKPOINT_SIZE);
-	brk.type = HW_BRK_TYPE_TRANSLATE;
+	brk.type = HW_BRK_TYPE_TRANSLATE | HW_BRK_TYPE_PRIV_ALL;
 	brk.len = DABR_MAX_LEN;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
 		brk.type |= HW_BRK_TYPE_READ;
-- 
2.25.1

