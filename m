Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E6E2E4067
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501945AbgL1OS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501952AbgL1OS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1202245C;
        Mon, 28 Dec 2020 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165085;
        bh=2WvY5f03cvQy4xUZwAWoi107DIC22ZBcmbic3ZzcDHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+yrGuvQ29IxRaXzgGN1DOpfw1rrc8jPGZNm2L5YJPZJWzeMQ7jQchO4aFApoohxJ
         W3mBpendjx5lgv6IyFCQ5ybEtGSD1dvWaCkj3V+F7UtG3fuSDjEIQJQs2QfDbBWSkk
         PF+3MBs7GxvDzjObN57Eb0h12JtkpoaZM4DXucF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/717] x86/kprobes: Restore BTF if the single-stepping is cancelled
Date:   Mon, 28 Dec 2020 13:46:16 +0100
Message-Id: <20201228125039.119863260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 547c7abb39f51..39f7d8c3c064b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -937,6 +937,11 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
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



