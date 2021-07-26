Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506BE3D5F8E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhGZPSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237533AbhGZPQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE53D6056C;
        Mon, 26 Jul 2021 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314989;
        bh=tiFFVu6cjKJ+hbq+PXJmlBpBZ4swHxEAWrxiHdbUY5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=we3brTP4DGNtT0HEC+WA1ZFzDYwUtmDCIa1/wnX3OfLlx1mns2NzOXQxq+51PqYGx
         vG7fTwNh/asEcDSfEhjPTa0BGzAd5pAVkfvSL0djy6IlTggF/A9N70cX94fkAEi2HH
         4elefsgVxvTC6lgcD9QAQPxtqa/1Ry99Qg6fL9fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/108] KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
Date:   Mon, 26 Jul 2021 17:38:45 +0200
Message-Id: <20210726153833.101099140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index 9011857c0434..bba358f13471 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2306,8 +2306,10 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP;
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



