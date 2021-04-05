Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D5D354493
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbhDEQFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239173AbhDEQFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47453613E7;
        Mon,  5 Apr 2021 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638725;
        bh=czU1BBx5gFfWn2AkdLFSpb+b7yuGXEGeypDvJmsYFWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLc8mG9PN+/yaBXDrc2t+3g7KW1yXKh17UZU+ERdCfwi7DF/V/NcVIjphzCKfaEB6
         /GzsqUQWkVCyJz93VgQMraYKJU2kZ+IcaefNKxMMEAly4E3MEPqaHHJxHuq/PMmETm
         vajDD0n2ydR2eOVdhFCsEqLFADfouIoUhaQdJNYwTOWAEuI+Cmvcljp3ZKh+93KHo6
         EmU3w4C6+B4yNHvnvcsmvCL+l8LhyxZCFroO+fds+7vZEgBvFcwsoYzqSEAVCgw0sN
         XCNiHWhjOp7yNtW+SgmF1ODucPBK/3r/y/WVZuSxByeLhtTyt50qdBmp0lmWKDz0K8
         QB7yUCTxGUzPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zihao Yu <yuzihao@ict.ac.cn>, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 8/8] riscv,entry: fix misaligned base for excp_vect_table
Date:   Mon,  5 Apr 2021 12:05:15 -0400
Message-Id: <20210405160515.269020-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160515.269020-1-sashal@kernel.org>
References: <20210405160515.269020-1-sashal@kernel.org>
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
index a03821b2656a..d9de22686e27 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -449,6 +449,7 @@ ENDPROC(__fstate_restore)
 
 
 	.section ".rodata"
+	.align LGREG
 	/* Exception vector table */
 ENTRY(excp_vect_table)
 	RISCV_PTR do_trap_insn_misaligned
-- 
2.30.2

