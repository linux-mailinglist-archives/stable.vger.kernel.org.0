Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C900F272825
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgIUOlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgIUOlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B0E12389F;
        Mon, 21 Sep 2020 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699262;
        bh=GmXUaK7KDx5Au+pQK6GEf2o0wJ5SeLpezqoStuF2LQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwkNdHhxkr5j4jtYNcAuvzg4sZpIyXh25+lu64E9VlrtxKs++sLFxz8Wwg4JquP7R
         PqhbvUk5vkQsU7ZPDov3gH17HxGO1Tu0GPOBNFaMw9Dq7fvYS9/zw97T0WMcR/eKvG
         HVDnHUpvxJkZwNZ7Sw6+3XR/Auo8fszwdloWVLyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Guo Ren <guoren@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 06/15] RISC-V: Take text_mutex in ftrace_init_nop()
Date:   Mon, 21 Sep 2020 10:40:45 -0400
Message-Id: <20200921144054.2135602-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144054.2135602-1-sashal@kernel.org>
References: <20200921144054.2135602-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit 66d18dbda8469a944dfec6c49d26d5946efba218 ]

Without this we get lockdep failures.  They're spurious failures as SMP isn't
up when ftrace_init_nop() is called.  As far as I can tell the easiest fix is
to just take the lock, which also seems like the safest fix.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/ftrace.h |  7 +++++++
 arch/riscv/kernel/ftrace.c      | 19 +++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index c6dcc5291f972..02fbc175142e2 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -63,4 +63,11 @@ do {									\
  * Let auipc+jalr be the basic *mcount unit*, so we make it 8 bytes here.
  */
 #define MCOUNT_INSN_SIZE 8
+
+#ifndef __ASSEMBLY__
+struct dyn_ftrace;
+int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
+#define ftrace_init_nop ftrace_init_nop
+#endif
+
 #endif
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index c40fdcdeb950a..291c579e12457 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -88,6 +88,25 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	return __ftrace_modify_call(rec->ip, addr, false);
 }
 
+
+/*
+ * This is called early on, and isn't wrapped by
+ * ftrace_arch_code_modify_{prepare,post_process}() and therefor doesn't hold
+ * text_mutex, which triggers a lockdep failure.  SMP isn't running so we could
+ * just directly poke the text, but it's simpler to just take the lock
+ * ourselves.
+ */
+int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
+{
+	int out;
+
+	ftrace_arch_code_modify_prepare();
+	out = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
+	ftrace_arch_code_modify_post_process();
+
+	return out;
+}
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	int ret = __ftrace_modify_call((unsigned long)&ftrace_call,
-- 
2.25.1

