Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671386214E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbfGHPPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732236AbfGHPPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 570C92166E;
        Mon,  8 Jul 2019 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598903;
        bh=K/qKOvKa4IfSM1AWI6P//8+67RHLGB7hh6YIp2jELY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVg7Fnfz11ON1GENKmWi2b3S3TX4ZF1eRg7cx47Q/zg4hfdCt5B34iSDhvkcSP91g
         Crz8vwwUpMfgmVjoaFoZjXTyIQK9VvB8r6q4YjG1qiKCyZ6ZiVq4ByOx4aNmh+dHPt
         QBoodKdjIRKaDzKYjRBenTdktvcCKWikWZnRROyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Paul Burton <paul.burton@mips.com>, ralf@linux-mips.org,
        jhogan@kernel.org, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/73] MIPS: uprobes: remove set but not used variable epc
Date:   Mon,  8 Jul 2019 17:12:22 +0200
Message-Id: <20190708150519.510934941@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 4e7b89f2e244..1363d705cc8c 100644
--- a/arch/mips/kernel/uprobes.c
+++ b/arch/mips/kernel/uprobes.c
@@ -164,9 +164,6 @@ int arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs)
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



