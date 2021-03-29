Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A704834C7E9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhC2ISa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhC2IRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2EA6044F;
        Mon, 29 Mar 2021 08:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005870;
        bh=7UBMc4X3Jzz8xGANcBroRUpjrifXZzex4w0Bq7V40Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiHO+hZaOxj2hMBclhiMURuxcJq0efZyWQ4qt28HrIKBLvWZ9ZlOBEHGf2Yafrz8d
         tCV3ygaJy0RFwzfVSJNzFLaPJ4zIEQVV1tIb0J5FCnotLDgO0f0yQ6dBfe/rD5UDfN
         S9Xiqu5ATj42Gsfo/R/1KSHeDRIO3W1Jk3553XaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Gardner <rob.gardner@oracle.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/221] sparc64: Fix opcode filtering in handling of no fault loads
Date:   Mon, 29 Mar 2021 09:56:06 +0200
Message-Id: <20210329075630.336945600@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Gardner <rob.gardner@oracle.com>

[ Upstream commit e5e8b80d352ec999d2bba3ea584f541c83f4ca3f ]

is_no_fault_exception() has two bugs which were discovered via random
opcode testing with stress-ng. Both are caused by improper filtering
of opcodes.

The first bug can be triggered by a floating point store with a no-fault
ASI, for instance "sta %f0, [%g0] #ASI_PNF", opcode C1A01040.

The code first tests op3[5] (0x1000000), which denotes a floating
point instruction, and then tests op3[2] (0x200000), which denotes a
store instruction. But these bits are not mutually exclusive, and the
above mentioned opcode has both bits set. The intent is to filter out
stores, so the test for stores must be done first in order to have
any effect.

The second bug can be triggered by a floating point load with one of
the invalid ASI values 0x8e or 0x8f, which pass this check in
is_no_fault_exception():
     if ((asi & 0xf2) == ASI_PNF)

An example instruction is "ldqa [%l7 + %o7] #ASI 0x8f, %f38",
opcode CF95D1EF. Asi values greater than 0x8b (ASI_SNFL) are fatal
in handle_ldf_stq(), and is_no_fault_exception() must not allow these
invalid asi values to make it that far.

In both of these cases, handle_ldf_stq() reacts by calling
sun4v_data_access_exception() or spitfire_data_access_exception(),
which call is_no_fault_exception() and results in an infinite
recursion.

Signed-off-by: Rob Gardner <rob.gardner@oracle.com>
Tested-by: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/traps_64.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index d92e5eaa4c1d..a850dccd78ea 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -275,14 +275,13 @@ bool is_no_fault_exception(struct pt_regs *regs)
 			asi = (regs->tstate >> 24); /* saved %asi       */
 		else
 			asi = (insn >> 5);	    /* immediate asi    */
-		if ((asi & 0xf2) == ASI_PNF) {
-			if (insn & 0x1000000) {     /* op3[5:4]=3       */
-				handle_ldf_stq(insn, regs);
-				return true;
-			} else if (insn & 0x200000) { /* op3[2], stores */
+		if ((asi & 0xf6) == ASI_PNF) {
+			if (insn & 0x200000)        /* op3[2], stores   */
 				return false;
-			}
-			handle_ld_nf(insn, regs);
+			if (insn & 0x1000000)       /* op3[5:4]=3 (fp)  */
+				handle_ldf_stq(insn, regs);
+			else
+				handle_ld_nf(insn, regs);
 			return true;
 		}
 	}
-- 
2.30.1



