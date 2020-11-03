Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F462A5146
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgKCUjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbgKCUi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8F42224E;
        Tue,  3 Nov 2020 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435939;
        bh=fMxB6hGj6jFhsCpoFf+dYfe2BG79DSNMguE+u3OI0gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQNE+1gm9C6qmkZodGoUggdbyNtV0E7OZi8Bj41faBXCBU8TNET6LK7Q5tY3YQiZw
         rp9/qUBk1vHXv7wOsA7feedlFOCph5PuS4v9fVCZfAFGuYFjl1KqUol2uLCBpebHq9
         V449XiPRjCOV+fvaL4wQnTiT3plpvn95AXBEyLTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 047/391] powerpc/watchpoint/ptrace: Fix SETHWDEBUG when CONFIG_HAVE_HW_BREAKPOINT=N
Date:   Tue,  3 Nov 2020 21:31:38 +0100
Message-Id: <20201103203350.730995179@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8bd8d8de5c40b..a570782e954be 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-noadv.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-noadv.c
@@ -217,7 +217,7 @@ long ppc_set_hwdebug(struct task_struct *child, struct ppc_hw_breakpoint *bp_inf
 		return -EIO;
 
 	brk.address = ALIGN_DOWN(bp_info->addr, HW_BREAKPOINT_SIZE);
-	brk.type = HW_BRK_TYPE_TRANSLATE;
+	brk.type = HW_BRK_TYPE_TRANSLATE | HW_BRK_TYPE_PRIV_ALL;
 	brk.len = DABR_MAX_LEN;
 	brk.hw_len = DABR_MAX_LEN;
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
-- 
2.27.0



