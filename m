Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44B13288CD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbhCARor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236134AbhCARkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BB2650BA;
        Mon,  1 Mar 2021 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617787;
        bh=jv0UgwOSbNW4GWVHylTAx9E1tHxvdbWeZO5LpWOvGTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEgY6wcjIHoCKWUEGfB6GU6pfD0HAV8/rqqgrBfzeXnnKlDQ9OYw6eJfIE4HGstQV
         0SpyucpGHg0CaE/0TCZ5m2fBu+7w/XFkB63w7xdJkIo8OBt4jCxYVRLKqwjMbjkpmu
         Br62IhmhpbwKNk4gdDrvYTboWyfFfmFRLG8T+WK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/340] powerpc/sstep: Fix incorrect return from analyze_instr()
Date:   Mon,  1 Mar 2021 17:11:50 +0100
Message-Id: <20210301161056.482379269@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>

[ Upstream commit 718aae916fa6619c57c348beaedd675835cf1aa1 ]

We currently just percolate the return value from analyze_instr()
to the caller of emulate_step(), especially if it is a -1.

For one particular case (opcode = 4) for instructions that aren't
currently emulated, we are returning 'should not be single-stepped'
while we should have returned 0 which says 'did not emulate, may
have to single-step'.

Fixes: 930d6288a26787 ("powerpc: sstep: Add support for maddhd, maddhdu, maddld instructions")
Signed-off-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161157999039.64773.14950289716779364766.stgit@thinktux.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index c077acb983a19..bf3432b10d0af 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1304,6 +1304,11 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 #ifdef __powerpc64__
 	case 4:
+		/*
+		 * There are very many instructions with this primary opcode
+		 * introduced in the ISA as early as v2.03. However, the ones
+		 * we currently emulate were all introduced with ISA 3.0
+		 */
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
 			return -1;
 
@@ -1331,7 +1336,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		 * There are other instructions from ISA 3.0 with the same
 		 * primary opcode which do not have emulation support yet.
 		 */
-		return -1;
+		goto unknown_opcode;
 #endif
 
 	case 7:		/* mulli */
-- 
2.27.0



