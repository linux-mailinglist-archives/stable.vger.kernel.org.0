Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BDB2475E3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbgHQT3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbgHQPcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AC8F22CBE;
        Mon, 17 Aug 2020 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678324;
        bh=GkcRN+bMz+7K9z0kn8bWe7OlGo50pYckHJVciOJpBO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5ZkLk7+S85OaDD/jUiUdzKnuP58cSEzscd2gM8v9JLOpA8H5tkJHnALPGFPGAF1k
         h99TAHQwnQntLb5QPaRBDR0PBXfTGE7rUOMLWwnjNAn1s/IZvmndEMmzP7gzZVGe7/
         Mwah7ApN6Y7pdfuRYIfw9NZFBkDtAuNPIpNksRe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 295/464] powerpc/watchpoint: Fix DAWR exception for CACHEOP
Date:   Mon, 17 Aug 2020 17:14:08 +0200
Message-Id: <20200817143847.889929337@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit f3c832f1350bcf1e6906113ee3168066f4235dbe ]

'ea' returned by analyse_instr() needs to be aligned down to cache
block size for CACHEOP instructions. analyse_instr() does not set
size for CACHEOP, thus size also needs to be calculated manually.

Fixes: 27985b2a640e ("powerpc/watchpoint: Don't ignore extraneous exceptions blindly")
Fixes: 74c6881019b7 ("powerpc/watchpoint: Prepare handler to handle more than one watchpoint")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200723090813.303838-4-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index a971e22aea819..c55e67bab2710 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -538,7 +538,12 @@ static bool check_dawrx_constraints(struct pt_regs *regs, int type,
 	if (OP_IS_LOAD(type) && !(info->type & HW_BRK_TYPE_READ))
 		return false;
 
-	if (OP_IS_STORE(type) && !(info->type & HW_BRK_TYPE_WRITE))
+	/*
+	 * The Cache Management instructions other than dcbz never
+	 * cause a match. i.e. if type is CACHEOP, the instruction
+	 * is dcbz, and dcbz is treated as Store.
+	 */
+	if ((OP_IS_STORE(type) || type == CACHEOP) && !(info->type & HW_BRK_TYPE_WRITE))
 		return false;
 
 	if (is_kernel_addr(regs->nip) && !(info->type & HW_BRK_TYPE_KERNEL))
@@ -601,6 +606,15 @@ static bool check_constraints(struct pt_regs *regs, struct ppc_inst instr,
 	return false;
 }
 
+static int cache_op_size(void)
+{
+#ifdef __powerpc64__
+	return ppc64_caches.l1d.block_size;
+#else
+	return L1_CACHE_BYTES;
+#endif
+}
+
 static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
 			     int *type, int *size, unsigned long *ea)
 {
@@ -616,7 +630,12 @@ static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
 	if (!(regs->msr & MSR_64BIT))
 		*ea &= 0xffffffffUL;
 #endif
+
 	*size = GETSIZE(op.type);
+	if (*type == CACHEOP) {
+		*size = cache_op_size();
+		*ea &= ~(*size - 1);
+	}
 }
 
 static bool is_larx_stcx_instr(int type)
-- 
2.25.1



