Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B13D60A8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhGZPXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237586AbhGZPXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E06E60EB2;
        Mon, 26 Jul 2021 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315439;
        bh=1POvb3q8sXkM5MUEqr3DtHZxdsmMcT+D4Rk9QP51dZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOymTWMiJNNU9CyXBgeRPXcey8d3aEKmHL905W20DUl3gsTcHbvOuQxWVVBqEdwTy
         90kMJ0MWeb+m3g4+OJ41nk1QYst5+rGrVhKt0fD4nbY4vwpApnUGuOqw9eVGuRC9Cv
         lToflRQend8NuCFI3i5XHjLhe1a2qHXijtENs2GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/167] KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
Date:   Mon, 26 Jul 2021 17:38:23 +0200
Message-Id: <20210726153841.750285864@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit bd31ecf44b8e18ccb1e5f6b50f85de6922a60de3 ]

When running CPU_FTR_P9_TM_HV_ASSIST, HFSCR[TM] is set for the guest
even if the host has CONFIG_TRANSACTIONAL_MEM=n, which causes it to be
unprepared to handle guest exits while transactional.

Normal guests don't have a problem because the HTM capability will not
be advertised, but a rogue or buggy one could crash the host.

Fixes: 4bb3c7a0208f ("KVM: PPC: Book3S HV: Work around transactional memory bugs in POWER9")
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210716024310.164448-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2325b7a6e95f..bd7350a608d4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2366,8 +2366,10 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP | HFSCR_PREFIX;
 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 		if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 			vcpu->arch.hfscr |= HFSCR_TM;
+#endif
 	}
 	if (cpu_has_feature(CPU_FTR_TM_COMP))
 		vcpu->arch.hfscr |= HFSCR_TM;
-- 
2.30.2



