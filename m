Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A87935442E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242089AbhDEQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242078AbhDEQEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 603EB613CD;
        Mon,  5 Apr 2021 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638670;
        bh=QTHRy0qn11avl2j/plu94sJH14RZCJpjJZGTvzB4E+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFXSpUgut1XaJfC371dIaXArrWjxCzVmeDQHi77xBuxL6vak7wugpbg9xlNOyDlo+
         YNyiG8JtCldqTtndZqMStfjXbx3vjaw73LyXmIH2S400MkupwSiI0Xz9u4wFqQtonq
         7WrVphEeMuOrNl06MFuOJ1UCk3CtE8pKbjPeFRFznfyM16ugjLGLpYfPHuKxMMTW1O
         W6gpIF32XifQzEZSc3NtrmD96cEsNEUv5PhGAf8F+9YAoMxkyw6JVAITUmb8BlONZZ
         5XVMjRWvGiYZOpC/tTDzjs+Yx8V733/iEy+KraiPy7+h4/wCqhK6cDjB/iQTBRPQfB
         B7yEp1b/LMOSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zihao Yu <yuzihao@ict.ac.cn>, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 21/22] riscv,entry: fix misaligned base for excp_vect_table
Date:   Mon,  5 Apr 2021 12:04:04 -0400
Message-Id: <20210405160406.268132-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zihao Yu <yuzihao@ict.ac.cn>

[ Upstream commit ac8d0b901f0033b783156ab2dc1a0e73ec42409b ]

In RV64, the size of each entry in excp_vect_table is 8 bytes. If the
base of the table is not 8-byte aligned, loading an entry in the table
will raise a misaligned exception. Although such exception will be
handled by opensbi/bbl, this still causes performance degradation.

Signed-off-by: Zihao Yu <yuzihao@ict.ac.cn>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 744f3209c48d..76274a4a1d8e 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -447,6 +447,7 @@ ENDPROC(__switch_to)
 #endif
 
 	.section ".rodata"
+	.align LGREG
 	/* Exception vector table */
 ENTRY(excp_vect_table)
 	RISCV_PTR do_trap_insn_misaligned
-- 
2.30.2

