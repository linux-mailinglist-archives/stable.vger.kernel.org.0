Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3935CEED9A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbfKDWIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389799AbfKDWIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:15 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C03C2084D;
        Mon,  4 Nov 2019 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905295;
        bh=d/6zc+tZJQ0l59lFjH5IKUXNkBz2OQ9GKqznhzOEnoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQKQH2l+S5EDi9t+QnEQh4khUtUuLH8aPn6yUqEZRPP1VOPefiq4NIZKgmYh4hFqb
         MCvCsUQSIc7Kf68JNQhIVZFIApEyajy0nyNq4T+R59SFZFygDY0ILHyyDshmsYjgii
         L9AEkZ7L0QQuPMntDO0VUVwxvRMh1aZ58oudHzcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 054/163] riscv: avoid kernel hangs when trapped in BUG()
Date:   Mon,  4 Nov 2019 22:44:04 +0100
Message-Id: <20191104212144.063503330@linuxfoundation.org>
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

[ Upstream commit 8b04825ed205da38754f86f4c07ea8600d8c2a65 ]

When the CONFIG_GENERIC_BUG is disabled by disabling CONFIG_BUG, if a
kernel thread is trapped by BUG(), the whole system will be in the
loop that infinitely handles the ebreak exception instead of entering the
die function. To fix this problem, the do_trap_break() will always call
the die() to deal with the break exception as the type of break is
BUG_TRAP_TYPE_BUG.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 424eb72d56b10..055a937aca70a 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -124,23 +124,23 @@ static inline unsigned long get_break_insn_length(unsigned long pc)
 
 asmlinkage void do_trap_break(struct pt_regs *regs)
 {
-#ifdef CONFIG_GENERIC_BUG
 	if (!user_mode(regs)) {
 		enum bug_trap_type type;
 
 		type = report_bug(regs->sepc, regs);
 		switch (type) {
+#ifdef CONFIG_GENERIC_BUG
 		case BUG_TRAP_TYPE_NONE:
 			break;
 		case BUG_TRAP_TYPE_WARN:
 			regs->sepc += get_break_insn_length(regs->sepc);
 			break;
 		case BUG_TRAP_TYPE_BUG:
+#endif /* CONFIG_GENERIC_BUG */
+		default:
 			die(regs, "Kernel BUG");
 		}
 	}
-#endif /* CONFIG_GENERIC_BUG */
-
 	force_sig_fault(SIGTRAP, TRAP_BRKPT, (void __user *)(regs->sepc));
 }
 
-- 
2.20.1



