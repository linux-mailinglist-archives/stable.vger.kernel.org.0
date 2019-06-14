Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18894692F
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfFNUan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfFNUan (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:43 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2F22184D;
        Fri, 14 Jun 2019 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544242;
        bh=2IeCWttRuelhrNLMfaIzHeLvwBBwnVANEz3e89O26I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIdoLbL1lx052OWt3CtQLc5xpvdhkvnrRms744vN2twmpJGCbx+NF1kSd4LXKeIRs
         wqHXJrnmxDKt0ywDjo4kExCwWA3JWsnUqbtaDbrUrSEZ3yRGDUwiB59AfEwYDEVW6u
         1RgrEJm7IP5hszT9UeBrjkTDV/cWssNMHl41m+pg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Paul Burton <paul.burton@mips.com>, ralf@linux-mips.org,
        jhogan@kernel.org, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 07/18] MIPS: uprobes: remove set but not used variable 'epc'
Date:   Fri, 14 Jun 2019 16:30:23 -0400
Message-Id: <20190614203037.27910-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203037.27910-1-sashal@kernel.org>
References: <20190614203037.27910-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit f532beeeff0c0a3586cc15538bc52d249eb19e7c ]

Fixes gcc '-Wunused-but-set-variable' warning:

arch/mips/kernel/uprobes.c: In function 'arch_uprobe_pre_xol':
arch/mips/kernel/uprobes.c:115:17: warning: variable 'epc' set but not used [-Wunused-but-set-variable]

It's never used since introduction in
commit 40e084a506eb ("MIPS: Add uprobes support.")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: <ralf@linux-mips.org>
Cc: <jhogan@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-mips@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/uprobes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/kernel/uprobes.c b/arch/mips/kernel/uprobes.c
index dbb917403131..ec951dde0999 100644
--- a/arch/mips/kernel/uprobes.c
+++ b/arch/mips/kernel/uprobes.c
@@ -111,9 +111,6 @@ int arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs)
 	 */
 	aup->resume_epc = regs->cp0_epc + 4;
 	if (insn_has_delay_slot((union mips_instruction) aup->insn[0])) {
-		unsigned long epc;
-
-		epc = regs->cp0_epc;
 		__compute_return_epc_for_insn(regs,
 			(union mips_instruction) aup->insn[0]);
 		aup->resume_epc = regs->cp0_epc;
-- 
2.20.1

