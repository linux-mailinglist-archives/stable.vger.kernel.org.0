Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD037490DD8
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiAQRGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiAQREA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3D8FB81131;
        Mon, 17 Jan 2022 17:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71824C36AE3;
        Mon, 17 Jan 2022 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439038;
        bh=e21FpSYim1ygMkk92DWrzZG+FchegcpQRTza2xVC53M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpyWIZVGKcKRNKAC2ld8SEpiN6QY20kRLT8kFVfaSmZG/S6WaxSIAshcToFusNluS
         UrVy5sD1wSKHjyw6+9tg0zQpyhxxre2npKkdbXZbO1kfvmBj2/Df1w38YLLJU9Te08
         ub6zdpODf46l8XkpugpHhE5n6x1blcLHTKxXm9mr4sqgdGiZanBi+WW2CMNfEabwDl
         lx09VgxCYLn/8gEt+g7OH7ImS7WsskKrvzQFZQU355EmNWXXnZ0Vt/Y3UkFVRfZuVc
         MsmtztB51wLN3jVlcYst19tBPey/HPkCIJsNvQ9JHZvLEH3nkxWOP9mNFYILsiJOTx
         q0bMVl6zgkTMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        paulus@ozlabs.org, ravi.bangoria@linux.ibm.com,
        bharata@linux.ibm.com, nathan@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 14/34] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
Date:   Mon, 17 Jan 2022 12:03:04 -0500
Message-Id: <20220117170326.1471712-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 792020907b11c6f9246c21977cab3bad985ae4b6 ]

H_COPY_TOFROM_GUEST is an hcall for an upper level VM to access its nested
VMs memory. The userspace can trigger WARN_ON_ONCE(!(gfp & __GFP_NOWARN))
in __alloc_pages() by constructing a tiny VM which only does
H_COPY_TOFROM_GUEST with a too big GPR9 (number of bytes to copy).

This silences the warning by adding __GFP_NOWARN.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210901084550.1658699-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index a5f1ae892ba68..d0b6c8c16c48a 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -510,7 +510,7 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 	if (eaddr & (0xFFFUL << 52))
 		return H_PARAMETER;
 
-	buf = kzalloc(n, GFP_KERNEL);
+	buf = kzalloc(n, GFP_KERNEL | __GFP_NOWARN);
 	if (!buf)
 		return H_NO_MEM;
 
-- 
2.34.1

