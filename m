Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B920829B97F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802544AbgJ0Pt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801322AbgJ0Pjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCD722283;
        Tue, 27 Oct 2020 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813195;
        bh=l+7lP0F0wdTvCbQc4wJdHciWUhoJ18wvmiVZwKr6otQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4RjZNDpe0Sm3j5Fx28xEYQSO8JsVmqf0bimTqqXPj7vWs59NMNBcQira88Z6cuYK
         Mv2MMYeBfkUIdD0/ZRDUbhFwfjxHGK/mn3EhAzzXfixYiF/3lt9btLQnEfAS3jhU2F
         4Dk35ENWWVWt3RtAH3WK6KNTJG2EhXicjPkJYVCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 442/757] powerpc/watchpoint: Add hw_len wherever missing
Date:   Tue, 27 Oct 2020 14:51:32 +0100
Message-Id: <20201027135511.272276657@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 58da5984d2ea6d95f3f9d9e8dd9f7e1b0dddfb3c ]

There are couple of places where we set len but not hw_len. For
ptrace/perf watchpoints, when CONFIG_HAVE_HW_BREAKPOINT=Y, hw_len
will be calculated and set internally while parsing watchpoint.
But when CONFIG_HAVE_HW_BREAKPOINT=N, we need to manually set
'hw_len'. Similarly for xmon as well, hw_len needs to be set
directly.

Fixes: b57aeab811db ("powerpc/watchpoint: Fix length calculation for unaligned target")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902042945.129369-7-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/ptrace/ptrace-noadv.c | 1 +
 arch/powerpc/xmon/xmon.c                  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/ptrace/ptrace-noadv.c b/arch/powerpc/kernel/ptrace/ptrace-noadv.c
index 697c7e4b5877f..8bd8d8de5c40b 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-noadv.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-noadv.c
@@ -219,6 +219,7 @@ long ppc_set_hwdebug(struct task_struct *child, struct ppc_hw_breakpoint *bp_inf
 	brk.address = ALIGN_DOWN(bp_info->addr, HW_BREAKPOINT_SIZE);
 	brk.type = HW_BRK_TYPE_TRANSLATE;
 	brk.len = DABR_MAX_LEN;
+	brk.hw_len = DABR_MAX_LEN;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
 		brk.type |= HW_BRK_TYPE_READ;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index df7bca00f5ec9..55c43a6c91112 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -969,6 +969,7 @@ static void insert_cpu_bpts(void)
 			brk.address = dabr[i].address;
 			brk.type = (dabr[i].enabled & HW_BRK_TYPE_DABR) | HW_BRK_TYPE_PRIV_ALL;
 			brk.len = 8;
+			brk.hw_len = 8;
 			__set_breakpoint(i, &brk);
 		}
 	}
-- 
2.25.1



