Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00441D22E9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbfJJIhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbfJJIhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:37:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED6B21920;
        Thu, 10 Oct 2019 08:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696674;
        bh=0vEp+pto73ui4iufkpSih4LKtUo9sm4+NgqimC6b7ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7/YV3AxbZxdCZawUJYF9y028BI51l61CMsZwWIHGCY1JfDPfURYvvH93GCDFhB6r
         1d5VTHkIWj7vlfZM4U/Z8ZNiHX4yhT1j+7jSloXPoTtVFTsXIsre8cP6ovpCd/8EUN
         wvAv2E29tM8+R+e9ncsfqh1BqnIsT4thdXrMpcWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 012/148] KVM: PPC: Book3S HV: Dont push XIVE context when not using XIVE device
Date:   Thu, 10 Oct 2019 10:34:33 +0200
Message-Id: <20191010083611.845109137@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

commit 8d4ba9c931bc384bcc6889a43915aaaf19d3e499 upstream.

At present, when running a guest on POWER9 using HV KVM but not using
an in-kernel interrupt controller (XICS or XIVE), for example if QEMU
is run with the kernel_irqchip=off option, the guest entry code goes
ahead and tries to load the guest context into the XIVE hardware, even
though no context has been set up.

To fix this, we check that the "CAM word" is non-zero before pushing
it to the hardware.  The CAM word is initialized to a non-zero value
in kvmppc_xive_connect_vcpu() and kvmppc_xive_native_connect_vcpu(),
and is now cleared in kvmppc_xive_{,native_}cleanup_vcpu.

Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.12+
Reported-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190813100100.GC9567@blackberry
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2 ++
 arch/powerpc/kvm/book3s_xive.c          |   11 ++++++++++-
 arch/powerpc/kvm/book3s_xive_native.c   |    3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -942,6 +942,8 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_3
 	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
 	li	r9, TM_QW1_OS
 	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
+	cmpwi	r8, 0
+	beq	no_xive
 	li	r7, TM_QW1_OS + TM_WORD2
 	mfmsr	r0
 	andi.	r0, r0, MSR_DR		/* in real mode? */
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -67,8 +67,14 @@ void kvmppc_xive_push_vcpu(struct kvm_vc
 	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
 	u64 pq;
 
-	if (!tima)
+	/*
+	 * Nothing to do if the platform doesn't have a XIVE
+	 * or this vCPU doesn't have its own XIVE context
+	 * (e.g. because it's not using an in-kernel interrupt controller).
+	 */
+	if (!tima || !vcpu->arch.xive_cam_word)
 		return;
+
 	eieio();
 	__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
 	__raw_writel(vcpu->arch.xive_cam_word, tima + TM_QW1_OS + TM_WORD2);
@@ -1146,6 +1152,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		struct xive_q *q = &xc->queues[i];
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -81,6 +81,9 @@ void kvmppc_xive_native_cleanup_vcpu(str
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		kvmppc_xive_native_cleanup_queue(vcpu, i);


