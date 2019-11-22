Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56861065C4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfKVFuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfKVFup (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333C92084B;
        Fri, 22 Nov 2019 05:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401844;
        bh=NtarbQ3mMcuCpzgGK4ZA5qZrc+60HUEkX7IGiYZOgdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZuhG71r3JE0TGEMTOFdDO74LrCxziTlJuUZKXIxKJCisxeErIjnGwRWu0BYW7ypj
         GrbVrCVq2zSFVCS9stVUVA2nr5e5F4QtQYap5TgXDkV1s+KfxDOdu0M+lSe2mSVvXK
         Jw8ZlheL7caA8txSh/ajMZSpHYY3a5JLlvCvcDSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrea Righi <righi.andrea@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 083/219] kprobes/x86: Show x86-64 specific blacklisted symbols correctly
Date:   Fri, 22 Nov 2019 00:46:55 -0500
Message-Id: <20191122054911.1750-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit fe6e65615415987629a2dda583b4495677d8c388 ]

Show x86-64 specific blacklisted symbols in debugfs.

Since x86-64 prohibits probing on symbols which are in
entry text, those should be shown.

Tested-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lkml.kernel.org/r/154503488425.26176.17136784384033608516.stgit@devbox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index e83a057564d1b..173e915e11d54 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1140,6 +1140,12 @@ bool arch_within_kprobe_blacklist(unsigned long addr)
 		is_in_entry_trampoline_section;
 }
 
+int __init arch_populate_kprobe_blacklist(void)
+{
+	return kprobe_add_area_blacklist((unsigned long)__entry_text_start,
+					 (unsigned long)__entry_text_end);
+}
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
-- 
2.20.1

