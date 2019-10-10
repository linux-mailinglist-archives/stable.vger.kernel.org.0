Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24F6D22E6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbfJJIhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbfJJIhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:37:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0066B218AC;
        Thu, 10 Oct 2019 08:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696669;
        bh=y2zbsO5T3/Z2dXmo1sqzHSi55Pv/yML1S45Zkv/rtH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZS4vFKhSPO1xsfQkO58Wb6yS02cr6LAM/82327fXSzOzJCcFhvIx7RYTLuBESec5
         Z611qrxSjoIYIkfiiKZ3WOGkDHkBWuyN1LgaAxtrmEcW7MJpmwodycvgLdn0kiH1OO
         iWz6R47OZtZdpjU8x0qLSqBqbBRp1unxGG0EwPM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.3 010/148] KVM: PPC: Book3S: Enable XIVE native capability only if OPAL has required functions
Date:   Thu, 10 Oct 2019 10:34:31 +0200
Message-Id: <20191010083611.708276260@linuxfoundation.org>
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

commit 2ad7a27deaf6d78545d97ab80874584f6990360e upstream.

There are some POWER9 machines where the OPAL firmware does not support
the OPAL_XIVE_GET_QUEUE_STATE and OPAL_XIVE_SET_QUEUE_STATE calls.
The impact of this is that a guest using XIVE natively will not be able
to be migrated successfully.  On the source side, the get_attr operation
on the KVM native device for the KVM_DEV_XIVE_GRP_EQ_CONFIG attribute
will fail; on the destination side, the set_attr operation for the same
attribute will fail.

This adds tests for the existence of the OPAL get/set queue state
functions, and if they are not supported, the XIVE-native KVM device
is not created and the KVM_CAP_PPC_IRQ_XIVE capability returns false.
Userspace can then either provide a software emulation of XIVE, or
else tell the guest that it does not have a XIVE controller available
to it.

Cc: stable@vger.kernel.org # v5.2+
Fixes: 3fab2d10588e ("KVM: PPC: Book3S HV: XIVE: Activate XIVE exploitation mode")
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/kvm_ppc.h    |    1 +
 arch/powerpc/include/asm/xive.h       |    1 +
 arch/powerpc/kvm/book3s.c             |    8 +++++---
 arch/powerpc/kvm/book3s_xive_native.c |    5 +++++
 arch/powerpc/kvm/powerpc.c            |    3 ++-
 arch/powerpc/sysdev/xive/native.c     |    7 +++++++
 6 files changed, 21 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -598,6 +598,7 @@ extern int kvmppc_xive_native_get_vp(str
 				     union kvmppc_one_reg *val);
 extern int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu,
 				     union kvmppc_one_reg *val);
+extern bool kvmppc_xive_native_supported(void);
 
 #else
 static inline int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -127,6 +127,7 @@ extern int xive_native_get_queue_state(u
 extern int xive_native_set_queue_state(u32 vp_id, uint32_t prio, u32 qtoggle,
 				       u32 qindex);
 extern int xive_native_get_vp_state(u32 vp_id, u64 *out_state);
+extern bool xive_native_has_queue_state_support(void);
 
 #else
 
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1083,9 +1083,11 @@ static int kvmppc_book3s_init(void)
 	if (xics_on_xive()) {
 		kvmppc_xive_init_module();
 		kvm_register_device_ops(&kvm_xive_ops, KVM_DEV_TYPE_XICS);
-		kvmppc_xive_native_init_module();
-		kvm_register_device_ops(&kvm_xive_native_ops,
-					KVM_DEV_TYPE_XIVE);
+		if (kvmppc_xive_native_supported()) {
+			kvmppc_xive_native_init_module();
+			kvm_register_device_ops(&kvm_xive_native_ops,
+						KVM_DEV_TYPE_XIVE);
+		}
 	} else
 #endif
 		kvm_register_device_ops(&kvm_xics_ops, KVM_DEV_TYPE_XICS);
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1171,6 +1171,11 @@ int kvmppc_xive_native_set_vp(struct kvm
 	return 0;
 }
 
+bool kvmppc_xive_native_supported(void)
+{
+	return xive_native_has_queue_state_support();
+}
+
 static int xive_native_debug_show(struct seq_file *m, void *private)
 {
 	struct kvmppc_xive *xive = m->private;
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -561,7 +561,8 @@ int kvm_vm_ioctl_check_extension(struct
 		 * a POWER9 processor) and the PowerNV platform, as
 		 * nested is not yet supported.
 		 */
-		r = xive_enabled() && !!cpu_has_feature(CPU_FTR_HVMODE);
+		r = xive_enabled() && !!cpu_has_feature(CPU_FTR_HVMODE) &&
+			kvmppc_xive_native_supported();
 		break;
 #endif
 
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -811,6 +811,13 @@ int xive_native_set_queue_state(u32 vp_i
 }
 EXPORT_SYMBOL_GPL(xive_native_set_queue_state);
 
+bool xive_native_has_queue_state_support(void)
+{
+	return opal_check_token(OPAL_XIVE_GET_QUEUE_STATE) &&
+		opal_check_token(OPAL_XIVE_SET_QUEUE_STATE);
+}
+EXPORT_SYMBOL_GPL(xive_native_has_queue_state_support);
+
 int xive_native_get_vp_state(u32 vp_id, u64 *out_state)
 {
 	__be64 state;


