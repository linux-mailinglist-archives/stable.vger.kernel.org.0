Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5712E3B6C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406220AbgL1Ntv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406216AbgL1Ntu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783F52064B;
        Mon, 28 Dec 2020 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163350;
        bh=8EGLseDchkl6v2bDPaXrx+vIuUkblSXJmmhu5YI6sFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6I+Zg9mDUNCQhyBRIQOKCoZ89tD/oLOGSR2FzNh6kC7aD55uugdtIclHTroP/1ON
         FyvJsxeUCwPCNrf5GrNbywEAFhmnchYMOKq/4n8uX8p210rc1csgipAgyUbKOq6dxJ
         TWAPj0dpZUavo4fuGvQDwTpEz1Wzd3TGAShms7ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 255/453] x86/kprobes: Restore BTF if the single-stepping is cancelled
Date:   Mon, 28 Dec 2020 13:48:11 +0100
Message-Id: <20201228124949.498448870@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 78ff2733ff352175eb7f4418a34654346e1b6cd2 ]

Fix to restore BTF if single-stepping causes a page fault and
it is cancelled.

Usually the BTF flag was restored when the single stepping is done
(in resume_execution()). However, if a page fault happens on the
single stepping instruction, the fault handler is invoked and
the single stepping is cancelled. Thus, the BTF flag is not
restored.

Fixes: 1ecc798c6764 ("x86: debugctlmsr kprobes")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/160389546985.106936.12727996109376240993.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 62c39baea39e3..5294018535d0c 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1019,6 +1019,11 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * So clear it by resetting the current kprobe:
 		 */
 		regs->flags &= ~X86_EFLAGS_TF;
+		/*
+		 * Since the single step (trap) has been cancelled,
+		 * we need to restore BTF here.
+		 */
+		restore_btf();
 
 		/*
 		 * If the TF flag was set before the kprobe hit,
-- 
2.27.0



