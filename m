Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5224E27C733
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgI2LwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgI2LsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB10D21924;
        Tue, 29 Sep 2020 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380089;
        bh=vkG0uq1KuAN193UYlXkNmtNk1BjGgxr3O77ZBm+w4CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6Oz5vv/XQ1SkaWipN91+qFdNXzrVtP2ONE3r5zQmKKg9gvXVju3lZQlmizbFD0It
         W/LVXbTKBW4+zEx3t0ltpO6skvk1G5GNnwDZMsunRg+i0x1M2NQszKI2bZRptfeaTF
         /OQSAChb2BgydsE4dl0DPhCFag03HptOWW/NQNq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Pei Huang <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 63/99] MIPS: Loongson-3: Fix fp register access if MSA enabled
Date:   Tue, 29 Sep 2020 13:01:46 +0200
Message-Id: <20200929105932.832473613@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 01ce6d4d2c8157b076425e3dd8319948652583c5 ]

If MSA is enabled, FPU_REG_WIDTH is 128 rather than 64, then get_fpr64()
/set_fpr64() in the original unaligned instruction emulation code access
the wrong fp registers. This is because the current code doesn't specify
the correct index field, so fix it.

Fixes: f83e4f9896eff614d0f2547a ("MIPS: Loongson-3: Add some unaligned instructions emulation")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Pei Huang <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/cop2-ex.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/mips/loongson64/cop2-ex.c b/arch/mips/loongson64/cop2-ex.c
index f130f62129b86..00055d4b6042f 100644
--- a/arch/mips/loongson64/cop2-ex.c
+++ b/arch/mips/loongson64/cop2-ex.c
@@ -95,10 +95,8 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 			if (res)
 				goto fault;
 
-			set_fpr64(current->thread.fpu.fpr,
-				insn.loongson3_lswc2_format.rt, value);
-			set_fpr64(current->thread.fpu.fpr,
-				insn.loongson3_lswc2_format.rq, value_next);
+			set_fpr64(&current->thread.fpu.fpr[insn.loongson3_lswc2_format.rt], 0, value);
+			set_fpr64(&current->thread.fpu.fpr[insn.loongson3_lswc2_format.rq], 0, value_next);
 			compute_return_epc(regs);
 			own_fpu(1);
 		}
@@ -130,15 +128,13 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 				goto sigbus;
 
 			lose_fpu(1);
-			value_next = get_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lswc2_format.rq);
+			value_next = get_fpr64(&current->thread.fpu.fpr[insn.loongson3_lswc2_format.rq], 0);
 
 			StoreDW(addr + 8, value_next, res);
 			if (res)
 				goto fault;
 
-			value = get_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lswc2_format.rt);
+			value = get_fpr64(&current->thread.fpu.fpr[insn.loongson3_lswc2_format.rt], 0);
 
 			StoreDW(addr, value, res);
 			if (res)
@@ -204,8 +200,7 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 			if (res)
 				goto fault;
 
-			set_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lsdc2_format.rt, value);
+			set_fpr64(&current->thread.fpu.fpr[insn.loongson3_lsdc2_format.rt], 0, value);
 			compute_return_epc(regs);
 			own_fpu(1);
 
@@ -221,8 +216,7 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 			if (res)
 				goto fault;
 
-			set_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lsdc2_format.rt, value);
+			set_fpr64(&current->thread.fpu.fpr[insn.loongson3_lsdc2_format.rt], 0, value);
 			compute_return_epc(regs);
 			own_fpu(1);
 			break;
@@ -286,8 +280,7 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 				goto sigbus;
 
 			lose_fpu(1);
-			value = get_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lsdc2_format.rt);
+			value = get_fpr64(&current->thread.fpu.fpr[insn.loongson3_lsdc2_format.rt], 0);
 
 			StoreW(addr, value, res);
 			if (res)
@@ -305,8 +298,7 @@ static int loongson_cu2_call(struct notifier_block *nfb, unsigned long action,
 				goto sigbus;
 
 			lose_fpu(1);
-			value = get_fpr64(current->thread.fpu.fpr,
-					insn.loongson3_lsdc2_format.rt);
+			value = get_fpr64(&current->thread.fpu.fpr[insn.loongson3_lsdc2_format.rt], 0);
 
 			StoreDW(addr, value, res);
 			if (res)
-- 
2.25.1



