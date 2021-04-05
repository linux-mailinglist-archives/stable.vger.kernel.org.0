Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB693354474
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbhDEQFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242191AbhDEQFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B90613CF;
        Mon,  5 Apr 2021 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638697;
        bh=QTHRy0qn11avl2j/plu94sJH14RZCJpjJZGTvzB4E+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUxS5UWn4yuzexH6xZz1oj/OYMUWqdMQ/TYx8KLMEBCQl1OiqBAhxWGcoH1BGclnW
         K2AziRLWl8b0DoCkUF+J97w+o0HNiCV8dCQN4+kodKiU4xkFsjF/4QDN3JC7HiAAeI
         bRBqhal8Qohyw2Dyhjg4MEvCwaDJKT8Suwh92nfT61MLdXxtnBiZ0rKj1Ok5KoqsVB
         YHGzqWeLXieZn6CuOSYvj4c+I331FIQje7Q7YOvFoXkPqGnVoM2ospI8jxfK432VOc
         O8MtaoMmGBFBp7Czwg768rMd2DCgjI2wfAbtCgL77R8pTlC6JtfrggGmHiqM8ZXsRo
         ZXE35wliuZ1Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zihao Yu <yuzihao@ict.ac.cn>, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 21/22] riscv,entry: fix misaligned base for excp_vect_table
Date:   Mon,  5 Apr 2021 12:04:30 -0400
Message-Id: <20210405160432.268374-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
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

