Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09322504CC
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHXRHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgHXQiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21CB522D07;
        Mon, 24 Aug 2020 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287068;
        bh=CtpDcw7Xz3xGfoI5xMxPaRSRG9egXstILFOZLWd7Px8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O94k4w113bpqJkz4b054qDkoy2Wv2O/L9nPg9x6AMbmlsnxbr1rzdQ5c5pglscwed
         sdTH4DVeMU54VDZ/+qveJH1jMx8hT0tJ5ICZ48T27fF8wJV4lgfTYdEnQ09qs0F4hX
         uwQNKPLEUgRdoQOQ1M5HK7opEbgD5a/NVuiL2lXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 53/54] arm64: Move handling of erratum 1418040 into C code
Date:   Mon, 24 Aug 2020 12:36:32 -0400
Message-Id: <20200824163634.606093-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d49f7d7376d0c0daf8680984a37bd07581ac7d38 ]

Instead of dealing with erratum 1418040 on each entry and exit,
let's move the handling to __switch_to() instead, which has
several advantages:

- It can be applied when it matters (switching between 32 and 64
  bit tasks).
- It is written in C (yay!)
- It can rely on static keys rather than alternatives

Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200731173824.107480-2-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/process.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 56be4cbf771f6..a81c9ca17b871 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -500,6 +500,39 @@ static void entry_task_switch(struct task_struct *next)
 	__this_cpu_write(__entry_task, next);
 }
 
+/*
+ * ARM erratum 1418040 handling, affecting the 32bit view of CNTVCT.
+ * Assuming the virtual counter is enabled at the beginning of times:
+ *
+ * - disable access when switching from a 64bit task to a 32bit task
+ * - enable access when switching from a 32bit task to a 64bit task
+ */
+static void erratum_1418040_thread_switch(struct task_struct *prev,
+					  struct task_struct *next)
+{
+	bool prev32, next32;
+	u64 val;
+
+	if (!(IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040) &&
+	      cpus_have_const_cap(ARM64_WORKAROUND_1418040)))
+		return;
+
+	prev32 = is_compat_thread(task_thread_info(prev));
+	next32 = is_compat_thread(task_thread_info(next));
+
+	if (prev32 == next32)
+		return;
+
+	val = read_sysreg(cntkctl_el1);
+
+	if (!next32)
+		val |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+	else
+		val &= ~ARCH_TIMER_USR_VCT_ACCESS_EN;
+
+	write_sysreg(val, cntkctl_el1);
+}
+
 /*
  * Thread switching.
  */
@@ -515,6 +548,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	entry_task_switch(next);
 	uao_thread_switch(next);
 	ssbs_thread_switch(next);
+	erratum_1418040_thread_switch(prev, next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.25.1

