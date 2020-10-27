Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF2129B903
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802153AbgJ0Ppq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801075AbgJ0Piv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8589207C4;
        Tue, 27 Oct 2020 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813129;
        bh=EOxjcnxkfOnQzw+ZKufshW0sbOFzDrKBkFhZ2DxW2uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TUqqtu9vi+pvcXxVxwyVq3Jrd4fduN79bN0s+lPk3vCDFmc7Yyr1DIc5XAao/Kpd
         Ojy6e5LxM1RfgT7SpOJJ3j6R+y+Q2deo+u8Zj91FH9j1UsStKZZIhh3lqXZ3DQcywk
         pgayjXn+HjOpFr2wKd8+C4NiOWUTXAwxmQCM5BfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 440/757] powerpc/watchpoint: Fix quadword instruction handling on p10 predecessors
Date:   Tue, 27 Oct 2020 14:51:30 +0100
Message-Id: <20201027135511.177148041@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 4759c11ed20454b7b36db4ec15f7d5aa1519af4a ]

On p10 predecessors, watchpoint with quadword access is compared at
quadword length. If the watch range is doubleword or less than that
in a first half of quadword aligned 16 bytes, and if there is any
unaligned quadword access which will access only the 2nd half, the
handler should consider it as extraneous and emulate/single-step it
before continuing.

Fixes: 74c6881019b7 ("powerpc/watchpoint: Prepare handler to handle more than one watchpoint")
Reported-by: Pedro Miraglia Franco de Carvalho <pedromfc@linux.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200902042945.129369-2-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hw_breakpoint.h |  1 +
 arch/powerpc/kernel/hw_breakpoint.c      | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index db206a7f38e24..9b68eafebf439 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -42,6 +42,7 @@ struct arch_hw_breakpoint {
 #else
 #define HW_BREAKPOINT_SIZE  0x8
 #endif
+#define HW_BREAKPOINT_SIZE_QUADWORD	0x10
 
 #define DABR_MAX_LEN	8
 #define DAWR_MAX_LEN	512
diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 1f4a1efa00744..9f7df1c372330 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -520,9 +520,17 @@ static bool ea_hw_range_overlaps(unsigned long ea, int size,
 				 struct arch_hw_breakpoint *info)
 {
 	unsigned long hw_start_addr, hw_end_addr;
+	unsigned long align_size = HW_BREAKPOINT_SIZE;
 
-	hw_start_addr = ALIGN_DOWN(info->address, HW_BREAKPOINT_SIZE);
-	hw_end_addr = ALIGN(info->address + info->len, HW_BREAKPOINT_SIZE);
+	/*
+	 * On p10 predecessors, quadword is handle differently then
+	 * other instructions.
+	 */
+	if (!cpu_has_feature(CPU_FTR_ARCH_31) && size == 16)
+		align_size = HW_BREAKPOINT_SIZE_QUADWORD;
+
+	hw_start_addr = ALIGN_DOWN(info->address, align_size);
+	hw_end_addr = ALIGN(info->address + info->len, align_size);
 
 	return ((ea < hw_end_addr) && (ea + size > hw_start_addr));
 }
-- 
2.25.1



