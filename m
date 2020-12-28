Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D32E680A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgL1QcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgL1NER (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE0DD22583;
        Mon, 28 Dec 2020 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160616;
        bh=S6MYLTteBd2F4CN61YD9SP2wyUzE9VfO13Em9rb6hzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy59Dwo03RqfDVJr3ELFLIjS5CGYRQh9VmXskiTBLKfTt86MjGoc8DBE2GHEKjq1M
         geof+XM8rZHbEViVqg6EdiEPU6NkScTscVUdr8ycwcl9IhovbcB6lQgAAYVtDFMkEv
         JNaWhc5t7V/lTX27MDxfMVZXnHbY4nP8jAfyOiCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/175] x86/kprobes: Restore BTF if the single-stepping is cancelled
Date:   Mon, 28 Dec 2020 13:49:24 +0100
Message-Id: <20201228124858.632467448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 86aec286e4f22..3da08881a0104 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1018,6 +1018,11 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
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



