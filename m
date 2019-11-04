Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373F6EEE83
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389498AbfKDWGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389924AbfKDWGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:18 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC23620650;
        Mon,  4 Nov 2019 22:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905178;
        bh=rRwePNsI59KK4BLYIYjRoGLaieBH2kehmZF/8DC2UNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwxgJ9TYiEUwjCkkmNMcCSnUkGX9BMs0WZbsvkD23qvkZAzaos4PNd+t/KsGG2BIV
         NsgJLboC0G5AdxufLBzXXH4XpBvUm2cWXNs3/2RRhOZ7+9MF1QjzvDI87ncwQRMMPL
         mLmsAVGZU45vLgXONiT/DsaIvRgbtFYGgQ2BxSUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 056/163] riscv: Correct the handling of unexpected ebreak in do_trap_break()
Date:   Mon,  4 Nov 2019 22:44:06 +0100
Message-Id: <20191104212144.176069663@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



