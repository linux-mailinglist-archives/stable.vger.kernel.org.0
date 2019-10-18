Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1085DD455
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfJRWEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbfJRWEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06B92245B;
        Fri, 18 Oct 2019 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436275;
        bh=rRwePNsI59KK4BLYIYjRoGLaieBH2kehmZF/8DC2UNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf1vEWmNI0f6IQ4hzZSB9gMTFPl9cxhKaW+SQRpQq9Q+RV3m3lhf9ffikOiAWhR0p
         hLkGFBwGqyCOzmEYF0SWHUf2Fjdgy7TU4c1D1CeQP55uIpIdpnxihcrxXyHH0WSmU7
         Y7FKmhxMqEV7LFeD/WM0vqN6DCt+6bWOC3xpEA5E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 54/89] riscv: Correct the handling of unexpected ebreak in do_trap_break()
Date:   Fri, 18 Oct 2019 18:02:49 -0400
Message-Id: <20191018220324.8165-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit 8bb0daef64e5a92db63ad1d3bbf9e280a7b3612a ]

For the kernel space, all ebreak instructions are determined at compile
time because the kernel space debugging module is currently unsupported.
Hence, it should be treated as a bug if an ebreak instruction which does
not belong to BUG_TRAP_TYPE_WARN or BUG_TRAP_TYPE_BUG is executed in
kernel space. For the userspace, debugging module or user problem may
intentionally insert an ebreak instruction to trigger a SIGTRAP signal.
To approach the above two situations, the do_trap_break() will direct
the BUG_TRAP_TYPE_NONE ebreak exception issued in kernel space to die()
and will send a SIGTRAP to the trapped process only when the ebreak is
in userspace.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[paul.walmsley@sifive.com: fixed checkpatch issue]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 82f42a55451eb..93742df9067fb 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -130,8 +130,6 @@ asmlinkage void do_trap_break(struct pt_regs *regs)
 		type = report_bug(regs->sepc, regs);
 		switch (type) {
 #ifdef CONFIG_GENERIC_BUG
-		case BUG_TRAP_TYPE_NONE:
-			break;
 		case BUG_TRAP_TYPE_WARN:
 			regs->sepc += get_break_insn_length(regs->sepc);
 			return;
@@ -140,8 +138,10 @@ asmlinkage void do_trap_break(struct pt_regs *regs)
 		default:
 			die(regs, "Kernel BUG");
 		}
+	} else {
+		force_sig_fault(SIGTRAP, TRAP_BRKPT,
+				(void __user *)(regs->sepc));
 	}
-	force_sig_fault(SIGTRAP, TRAP_BRKPT, (void __user *)(regs->sepc));
 }
 
 #ifdef CONFIG_GENERIC_BUG
-- 
2.20.1

