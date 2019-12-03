Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAC111EC0
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfLCXER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfLCWvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF4F2084B;
        Tue,  3 Dec 2019 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413512;
        bh=NtarbQ3mMcuCpzgGK4ZA5qZrc+60HUEkX7IGiYZOgdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5i2NpWvlODP+VLuLtfiVjz1SY8T0qKES/YL4ske8yX+24SY0nPePaPaxS9yqBj8Z
         Z+97UhLg3NQwQnkEGIp6qM2+PyE6jCdn1le+iWSDY6Dn7YqjTOzouub98b92Mqqrts
         49NNenJG+NaR0066zDpYqgLPsvArI9PIMb2sC3jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/321] kprobes/x86: Show x86-64 specific blacklisted symbols correctly
Date:   Tue,  3 Dec 2019 23:33:15 +0100
Message-Id: <20191203223433.864161315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



