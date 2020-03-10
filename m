Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3545217FD4C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgCJMzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbgCJMzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED49524697;
        Tue, 10 Mar 2020 12:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844911;
        bh=uG6ORTWs4LOH+gNyOH9bc6K2hUnR24KmtyOL7P0js5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7UVOARpLPcHzZ1d7jotA6PRT/4FN8YkcxAc2CEl0CgChP3Be2Qz4rGEiTCNe7XoV
         BiHA+pKQJzsm82kwJpd4RmeZesLGXskeL4drkhVa+ufreHohk6mPBmhmxUt6I9zOao
         TX1LquYnxmY2t+skxTMq/JvpPZv0mV5Vt/TDkdKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Desnes A. Nunes do Rosario" <desnesn@linux.ibm.com>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 165/168] powerpc: fix hardware PMU exception bug on PowerVM compatibility mode systems
Date:   Tue, 10 Mar 2020 13:40:11 +0100
Message-Id: <20200310123652.270406815@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>

commit fc37a1632d40c80c067eb1bc235139f5867a2667 upstream.

PowerVM systems running compatibility mode on a few Power8 revisions are
still vulnerable to the hardware defect that loses PMU exceptions arriving
prior to a context switch.

The software fix for this issue is enabled through the CPU_FTR_PMAO_BUG
cpu_feature bit, nevertheless this bit also needs to be set for PowerVM
compatibility mode systems.

Fixes: 68f2f0d431d9ea4 ("powerpc: Add a cpu feature CPU_FTR_PMAO_BUG")
Signed-off-by: Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
Reviewed-by: Leonardo Bras <leonardo@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200227134715.9715-1-desnesn@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/cputable.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -2193,11 +2193,13 @@ static struct cpu_spec * __init setup_cp
 		 * oprofile_cpu_type already has a value, then we are
 		 * possibly overriding a real PVR with a logical one,
 		 * and, in that case, keep the current value for
-		 * oprofile_cpu_type.
+		 * oprofile_cpu_type. Futhermore, let's ensure that the
+		 * fix for the PMAO bug is enabled on compatibility mode.
 		 */
 		if (old.oprofile_cpu_type != NULL) {
 			t->oprofile_cpu_type = old.oprofile_cpu_type;
 			t->oprofile_type = old.oprofile_type;
+			t->cpu_features |= old.cpu_features & CPU_FTR_PMAO_BUG;
 		}
 	}
 


