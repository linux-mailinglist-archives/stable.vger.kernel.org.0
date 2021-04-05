Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81DA3544A0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhDEQFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242241AbhDEQFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCFE613E4;
        Mon,  5 Apr 2021 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638713;
        bh=wZezF9NjlRxzyY2KSa8U5LwaxrCQeO5jCSc2/VBDak0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgSjY/xdS4924KFoXOaQCRGXukbLcCGb0mMIpoPuZUnTzwqk432cv1nnuVfvv3hRF
         F8dWXxLe1duM6kqOwSmp5m2CWwT7XPeatATncWkRyfAEOlJ6I241K737wEb57/3T5y
         i0qUsX8iYhZS5X+wpo4P9oUT4PqtvkswMovCCX2I38O95bR8Gq3IRz+0PfKuWMYfOF
         sFp4YMp74hoYOO8j2iAC1KwcTgonJWnYh9HdMejVx7j1sgaELKY9txK6YVM7/P9Jl6
         4xhKYlt5BydKlGXGFZjHqJc3X5Wxt0vtYRyCftwt2Ufi3JBprwFkJLLxDUFPDDjPH1
         SKBszstgntfQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zihao Yu <yuzihao@ict.ac.cn>, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 12/13] riscv,entry: fix misaligned base for excp_vect_table
Date:   Mon,  5 Apr 2021 12:04:57 -0400
Message-Id: <20210405160459.268794-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160459.268794-1-sashal@kernel.org>
References: <20210405160459.268794-1-sashal@kernel.org>
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
index 8ca479831142..9c87ae77ad5d 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -387,6 +387,7 @@ ENTRY(__switch_to)
 ENDPROC(__switch_to)
 
 	.section ".rodata"
+	.align LGREG
 	/* Exception vector table */
 ENTRY(excp_vect_table)
 	RISCV_PTR do_trap_insn_misaligned
-- 
2.30.2

