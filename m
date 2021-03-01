Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900313288C5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhCARnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234679AbhCARkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5178F64FCC;
        Mon,  1 Mar 2021 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617781;
        bh=IoDlXR13y3z7TVK36+phQctcKx7CvYfUgr45wnZof/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzBN6FCIEErap/ZXPsyPDFQIMZS2R3QogZole3Baar3/bDOsvNndeD3rLnBPy9IVj
         1N1vrMV3HnKqQJv9pz8ogF8OLvC1KxQYP0i25Sh3+YufUBTptAcA9PzzJe51bZxm/Q
         O36mBPSoLK3T7qu5yJoiglR9wccdaSf3lFYWJyTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/340] KVM: PPC: Make the VMX instruction emulation routines static
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161056.383443155@linuxfoundation.org>
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

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 9236f57a9e51c72ce426ccd2e53e123de7196a0f ]

These are only used locally. It fixes these W=1 compile errors :

../arch/powerpc/kvm/powerpc.c:1521:5: error: no previous prototype for ‘kvmppc_get_vmx_dword’ [-Werror=missing-prototypes]
 1521 | int kvmppc_get_vmx_dword(struct kvm_vcpu *vcpu, int index, u64 *val)
      |     ^~~~~~~~~~~~~~~~~~~~
../arch/powerpc/kvm/powerpc.c:1539:5: error: no previous prototype for ‘kvmppc_get_vmx_word’ [-Werror=missing-prototypes]
 1539 | int kvmppc_get_vmx_word(struct kvm_vcpu *vcpu, int index, u64 *val)
      |     ^~~~~~~~~~~~~~~~~~~
../arch/powerpc/kvm/powerpc.c:1557:5: error: no previous prototype for ‘kvmppc_get_vmx_hword’ [-Werror=missing-prototypes]
 1557 | int kvmppc_get_vmx_hword(struct kvm_vcpu *vcpu, int index, u64 *val)
      |     ^~~~~~~~~~~~~~~~~~~~
../arch/powerpc/kvm/powerpc.c:1575:5: error: no previous prototype for ‘kvmppc_get_vmx_byte’ [-Werror=missing-prototypes]
 1575 | int kvmppc_get_vmx_byte(struct kvm_vcpu *vcpu, int index, u64 *val)
      |     ^~~~~~~~~~~~~~~~~~~

Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instruction mmio emulation with analyse_instr() input")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210104143206.695198-19-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3a77bb6434521..e03c064716789 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1513,7 +1513,7 @@ int kvmppc_handle_vmx_load(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	return emulated;
 }
 
-int kvmppc_get_vmx_dword(struct kvm_vcpu *vcpu, int index, u64 *val)
+static int kvmppc_get_vmx_dword(struct kvm_vcpu *vcpu, int index, u64 *val)
 {
 	union kvmppc_one_reg reg;
 	int vmx_offset = 0;
@@ -1531,7 +1531,7 @@ int kvmppc_get_vmx_dword(struct kvm_vcpu *vcpu, int index, u64 *val)
 	return result;
 }
 
-int kvmppc_get_vmx_word(struct kvm_vcpu *vcpu, int index, u64 *val)
+static int kvmppc_get_vmx_word(struct kvm_vcpu *vcpu, int index, u64 *val)
 {
 	union kvmppc_one_reg reg;
 	int vmx_offset = 0;
@@ -1549,7 +1549,7 @@ int kvmppc_get_vmx_word(struct kvm_vcpu *vcpu, int index, u64 *val)
 	return result;
 }
 
-int kvmppc_get_vmx_hword(struct kvm_vcpu *vcpu, int index, u64 *val)
+static int kvmppc_get_vmx_hword(struct kvm_vcpu *vcpu, int index, u64 *val)
 {
 	union kvmppc_one_reg reg;
 	int vmx_offset = 0;
@@ -1567,7 +1567,7 @@ int kvmppc_get_vmx_hword(struct kvm_vcpu *vcpu, int index, u64 *val)
 	return result;
 }
 
-int kvmppc_get_vmx_byte(struct kvm_vcpu *vcpu, int index, u64 *val)
+static int kvmppc_get_vmx_byte(struct kvm_vcpu *vcpu, int index, u64 *val)
 {
 	union kvmppc_one_reg reg;
 	int vmx_offset = 0;
-- 
2.27.0



