Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE29344265
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhCVMlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232030AbhCVMji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9773619A7;
        Mon, 22 Mar 2021 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416701;
        bh=de7KSPCn/vKHgnF74A4g8ZAF6SNVlFjTZPvpLoyD3rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htWC4IxUIs+P88FaS5Ix/YYNw8c0TrEvs7UBAkA+chGzWhMwCJujOb7wC2h1Q2Ebe
         ebzkEqDT4QCBRmfBhcdbmC+QmQoae+IkhTsfCA4lSSaKot+emj0Hqr0VXs1ZXOZhOv
         QjpW4kA2rDCx0dXd0Cm0DawVrl6zR8mzVJzx9TP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/157] powerpc/sstep: Fix darn emulation
Date:   Mon, 22 Mar 2021 13:27:24 +0100
Message-Id: <20210322121936.545824464@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit 22b89ba178dd0a66a26699ead014a3e73ff8e044 ]

Commit 8813ff49607e ("powerpc/sstep: Check instruction validity
against ISA version before emulation") introduced a proper way to skip
unknown instructions. This makes sure that the same is used for the
darn instruction when the range selection bits have a reserved value.

Fixes: a23987ef267a ("powerpc: sstep: Add support for darn instruction")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210204080744.135785-2-sandipan@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 0f228ee11ca4..a2e067f68dee 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1853,7 +1853,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 				goto compute_done;
 			}
 
-			return -1;
+			goto unknown_opcode;
 #ifdef __powerpc64__
 		case 777:	/* modsd */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-- 
2.30.1



