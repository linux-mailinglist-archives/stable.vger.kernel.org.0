Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC0D2E3D9E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441514AbgL1ORy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501901AbgL1ORs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30EB2063A;
        Mon, 28 Dec 2020 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165047;
        bh=tCMV3UkkcwBxvZjvUj6fB2qubsB7ZMZfL2hJfreyivs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTEHg6CvaRz+E7Ic6Spb/6vVcwMHNcsxYBHcEIuMqlvlebQYkbYTKkT7LszXA8OXD
         RT4x6afRY+HcWbQiySqHvZjWBxe4cz8kKkXR1PD/3xCkTcO1BhBNuBRqXvtVxnEL7b
         MNd095yM/E6KyjWu7rUw2C7f+6xtp/D1/qn+U9io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balamuruhan S <bala24@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/717] powerpc/sstep: Emulate prefixed instructions only when CPU_FTR_ARCH_31 is set
Date:   Mon, 28 Dec 2020 13:46:30 +0100
Message-Id: <20201228125039.787158501@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balamuruhan S <bala24@linux.ibm.com>

[ Upstream commit ef6879f8c8053cc3b493f400a06d452d7fb13650 ]

Unconditional emulation of prefixed instructions will allow
emulation of them on Power10 predecessors which might cause
issues. Restrict that.

Fixes: 3920742b92f5 ("powerpc sstep: Add support for prefixed fixed-point arithmetic")
Fixes: 50b80a12e4cc ("powerpc sstep: Add support for prefixed load/stores")
Signed-off-by: Balamuruhan S <bala24@linux.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201011050908.72173-2-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 855457ed09b54..bf2cd3d42125d 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1346,6 +1346,9 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 	switch (opcode) {
 #ifdef __powerpc64__
 	case 1:
+		if (!cpu_has_feature(CPU_FTR_ARCH_31))
+			return -1;
+
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
 		rd = (suffix >> 21) & 0x1f;
@@ -2733,6 +2736,9 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		}
 		break;
 	case 1: /* Prefixed instructions */
+		if (!cpu_has_feature(CPU_FTR_ARCH_31))
+			return -1;
+
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
 		op->update_reg = ra;
-- 
2.27.0



