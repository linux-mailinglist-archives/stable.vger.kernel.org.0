Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A742F7BFD
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbhAOMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbhAOMaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610282339D;
        Fri, 15 Jan 2021 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713790;
        bh=M/Np2hVMHaodeD4WUD77jlADoSgNJFwgu4YWU5+LLWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC8TSVesoLwTIwdBoLKfx8DnI7Mv0V6z3onbTUXrGXTtdsuudDNmZgB2APcOuRtxy
         aguVN6YWO9DxXWvaPJQ+nxESCoHoXxC3qTl3V04iJwYFd6rL8t7R+p/mUKwYiA+i5A
         hO0hZhy/Q12v6roOFNzB1H6qJ+6vS6PAM5AKcSZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/18] powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at
Date:   Fri, 15 Jan 2021 13:27:35 +0100
Message-Id: <20210115121955.470805129@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
References: <20210115121955.112329537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit d85be8a49e733dcd23674aa6202870d54bf5600d ]

The placeholder for instruction selection should use the second
argument's operand, which is %1, not %0. This could generate incorrect
assembly code if the memory addressing of operand %0 is a different
form from that of operand %1.

Also remove the %Un placeholder because having %Un placeholders
for two operands which are based on the same local var (ptep) doesn't
make much sense. By the way, it doesn't change the current behaviour
because "<>" constraint is missing for the associated "=m".

[chleroy: revised commit log iaw segher's comments and removed %U0]

Fixes: 9bf2b5cdc5fe ("powerpc: Fixes for CONFIG_PTE_64BIT for SMP support")
Cc: <stable@vger.kernel.org> # v2.6.28+
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/96354bd77977a6a933fe9020da57629007fdb920.1603358942.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -149,9 +149,9 @@ static inline void __set_pte_at(struct m
 		flush_hash_entry(mm, ptep, addr);
 #endif
 	__asm__ __volatile__("\
-		stw%U0%X0 %2,%0\n\
+		stw%X0 %2,%0\n\
 		eieio\n\
-		stw%U0%X0 %L2,%1"
+		stw%X1 %L2,%1"
 	: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 	: "r" (pte) : "memory");
 


