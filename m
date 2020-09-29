Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E4B27C7E5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgI2L5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730441AbgI2Ln2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35564207F7;
        Tue, 29 Sep 2020 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379807;
        bh=GmXUaK7KDx5Au+pQK6GEf2o0wJ5SeLpezqoStuF2LQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIDaQ4Lt1jU8yFTiSpvylu2vz4rJcIwe4m7xkrR68mS119nU+Oc6hG+f0414MoLOs
         9Nf1JcxNA/k4ZKMz8RgTK+KacS0QUkPx+h1zqCm0MoG/cEEnFoqdVqfT1zIuzz3Hrs
         fQJPrWjUblPVGLLTTpsSkJoRsB+Ne+wZ02MCKdzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Guo Ren <guoren@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 327/388] RISC-V: Take text_mutex in ftrace_init_nop()
Date:   Tue, 29 Sep 2020 13:00:58 +0200
Message-Id: <20200929110026.291447676@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



