Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3212B272882
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgIUOki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgIUOkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E93235F8;
        Mon, 21 Sep 2020 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699236;
        bh=qBx7cPjzZCuHyLGD9yeEbvIMCmbuJNrA95mv/2qo/iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZjWdDGJWZP5Rohh2aDLgYrdQ93W5+kTKA8uYQbrR6uL0/D5cURGzxA1INMz72nFk
         plmtY000IeQQ4Jzx+YV0IndeCYRSgkROsb3lXTPCP9cbYmhlWSGrnd8ID5HXyLI83b
         0KS3Txi5nqVzg03Ha/Jz+s3SzLu37btGV/UwZbdQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Guo Ren <guoren@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 07/20] RISC-V: Take text_mutex in ftrace_init_nop()
Date:   Mon, 21 Sep 2020 10:40:14 -0400
Message-Id: <20200921144027.2135390-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
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
index ace8a6e2d11d3..845002cc2e571 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -66,6 +66,13 @@ do {									\
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
 
 #endif /* _ASM_RISCV_FTRACE_H */
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 2ff63d0cbb500..99e12faa54986 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -97,6 +97,25 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
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

