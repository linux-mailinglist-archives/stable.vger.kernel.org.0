Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC75417FD2
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 07:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343628AbhIYFSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 01:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhIYFSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 01:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB6176127A;
        Sat, 25 Sep 2021 05:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632547028;
        bh=dTWWEEku3Bu2EIy1EXAkhLeT4qw1irEelkTYP/6N8i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uawpFkzY+arW26+J7Jtlm8z+jK4X7ZP8BRm7l8iOpBrvDceWt2q91g1LyisSX0mhF
         5WVhZJwVYzbEPBegPG2WvWzdfT90scqgEOHhv3LVQda0FdrVJXkIJ0RJQZJbsIOQkK
         VrXdZC4vL9qpkP/hNS3uVioWg5N8LnkyQIt2kyzH+9KnWbxXmGZR/y0vwMSHJkio7w
         TIbpHPY4DsN1PuEL5mliPuMSL455rF4R1G4/DysZJ5v/Twzrib89WIclnGpFqDDVrE
         JuDoSp+PEOWkNRK+zVNAgWJ5tw/QgK4Df5cmpY3CErMQIpoSrCVKvW+roHqIg/yHqY
         KMXqA4+WHEPVQ==
From:   guoren@kernel.org
To:     guoren@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH V2 2/2] csky: Fixup regs.sr broken in ptrace
Date:   Sat, 25 Sep 2021 13:16:47 +0800
Message-Id: <20210925051647.1162829-2-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925051647.1162829-1-guoren@kernel.org>
References: <20210925051647.1162829-1-guoren@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

gpr_get() return the entire pt_regs (include sr) to userspace, if we
don't restore the C bit in gpr_set, it may break the ALU result in
that context. So the C flag bit is part of gpr context, that's why
riscv totally remove the C bit in the ISA. That makes sr reg clear
from userspace to supervisor privilege.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
---
 arch/csky/kernel/ptrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/csky/kernel/ptrace.c b/arch/csky/kernel/ptrace.c
index 0105ac81b432..1a5f54e0d272 100644
--- a/arch/csky/kernel/ptrace.c
+++ b/arch/csky/kernel/ptrace.c
@@ -99,7 +99,8 @@ static int gpr_set(struct task_struct *target,
 	if (ret)
 		return ret;
 
-	regs.sr = task_pt_regs(target)->sr;
+	/* BIT(0) of regs.sr is Condition Code/Carry bit */
+	regs.sr = (regs.sr & BIT(0)) | (task_pt_regs(target)->sr & ~BIT(0));
 #ifdef CONFIG_CPU_HAS_HILO
 	regs.dcsr = task_pt_regs(target)->dcsr;
 #endif
-- 
2.25.1

