Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E18106A2D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKVKc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfKVKcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:32:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FB82082F;
        Fri, 22 Nov 2019 10:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418745;
        bh=B6jxOLBd/9zLkLYcoyos7p5ppKFoQ1iXiFOWPgY7BhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08mn1FOG2F8rygIaglGgsQ2cpNuNgv/E+2w7FndyyULxIa/kqSHrR5CIPsFma2z7V
         oq9867p6bQBiXOXBvq5C3flaq/ick2VhQXwSUtB/BgWfssO+iLZYUjLHdaYrhL5I2o
         qwK5vJJX3Jzql9iICa3hwtuZSwJRBh6Gseplmo8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 038/159] signal: Properly deliver SIGSEGV from x86 uprobes
Date:   Fri, 22 Nov 2019 11:27:09 +0100
Message-Id: <20191122100734.245850658@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 4a63c1ffd384ebdce40aac9c997dab68379137be ]

For userspace to tell the difference between an random signal
and an exception, the exception must include siginfo information.

Using SEND_SIG_FORCED for SIGSEGV is thus wrong, and it will result in
userspace seeing si_code == SI_USER (like a random signal) instead of
si_code == SI_KERNEL or a more specific si_code as all exceptions
deliver.

Therefore replace force_sig_info(SIGSEGV, SEND_SIG_FORCE, current)
with force_sig(SIG_SEGV, current) which gets this right and is shorter
and easier to type.

Fixes: 791eca10107f ("uretprobes/x86: Hijack return address")
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 178d63cac321b..60b12c14cf6fb 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -983,7 +983,7 @@ arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs
 		pr_err("uprobe: return address clobbered: pid=%d, %%sp=%#lx, "
 			"%%ip=%#lx\n", current->pid, regs->sp, regs->ip);
 
-		force_sig_info(SIGSEGV, SEND_SIG_FORCED, current);
+		force_sig(SIGSEGV, current);
 	}
 
 	return -1;
-- 
2.20.1



