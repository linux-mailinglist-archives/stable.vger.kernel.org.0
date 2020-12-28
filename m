Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ADA2E656C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390592AbgL1QBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387686AbgL1NcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1342421D94;
        Mon, 28 Dec 2020 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162287;
        bh=Lnk/iVq27h4ROwe+OEDj5l41yCPtSdaHVoqU8ElfOac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKjuWnLvq9HlEq+Esnde9KB/5ZnBKZnqDag8MiVWvEZOrUBm6CsYQ62+ngl6h5BOI
         3UK5q8L2Ha9+mQtj++rSSLR8ShL0kFDWTJ0Va0aLP3e2Y22oBJ+NUR1FctDRWkorEH
         eUaaIj90WiGWuzTq7Yp4LbK7AsIUMT2TBK0XJ9o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 221/346] x86/kprobes: Restore BTF if the single-stepping is cancelled
Date:   Mon, 28 Dec 2020 13:49:00 +0100
Message-Id: <20201228124930.462175957@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 07e290244ca94..dfc3ab44bc5d3 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1041,6 +1041,11 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
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



