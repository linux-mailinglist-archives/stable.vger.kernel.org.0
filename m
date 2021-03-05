Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C33332E95F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCEMc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhCEMcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD5B65029;
        Fri,  5 Mar 2021 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947520;
        bh=PJyvEExXLhKyW+Mwpwkr7mvrqXgOQxMqBnjn9yIbJHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjTQ/8qH28z8jjZtIpZr1uNlAsjsUvuGB4u7Do0uRcE2N42DRqFMVf+/OE73aNANH
         tcAF3i0Bh7PuZR28nfffrrO9cyYvNSyC4qdG1wpk0umUosk8w3LwlzZhd9uPtlxBwr
         5mCWEp86OSaNMS/lNHxgw3AXvyPUoMUCOy0gfDZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH 5.10 093/102] powerpc/sstep: Fix incorrect return from analyze_instr()
Date:   Fri,  5 Mar 2021 13:21:52 +0100
Message-Id: <20210305120907.855387479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>

commit 718aae916fa6619c57c348beaedd675835cf1aa1 upstream.

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
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1382,6 +1382,11 @@ int analyse_instr(struct instruction_op
 
 #ifdef __powerpc64__
 	case 4:
+		/*
+		 * There are very many instructions with this primary opcode
+		 * introduced in the ISA as early as v2.03. However, the ones
+		 * we currently emulate were all introduced with ISA 3.0
+		 */
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
 			goto unknown_opcode;
 
@@ -1409,7 +1414,7 @@ int analyse_instr(struct instruction_op
 		 * There are other instructions from ISA 3.0 with the same
 		 * primary opcode which do not have emulation support yet.
 		 */
-		return -1;
+		goto unknown_opcode;
 #endif
 
 	case 7:		/* mulli */


