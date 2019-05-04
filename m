Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B846138E3
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfEDK1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfEDK1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E071B20859;
        Sat,  4 May 2019 10:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965653;
        bh=wFZarfcDgNI7qhNyVlSgudZx3UqdoujzUUIR5OvFHI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rybvaAuBx/dKz4hAGnm2GFyjvMtK16udlumHPGHw7ORRPkTkq1zFkS8vM72LG+yYO
         bS+uO1UH/CvM7THaGDAPVRxl/HJSE0OKgFAt0E86HbXnHfPic2OEoL6E42f2xUzb1A
         F+y1mrjPcwBmyfFCEluIegcQD0RMSzwF1533y6QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Becherer <simon@becherer.de>,
        Gabriele Balducci <balducci@units.it>,
        Antti Antinoja <reader@fennosys.fi>,
        Takashi Iwai <tiwai@suse.com>, Jiri Slaby <jslaby@suse.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Iakov Karpov <srid@rkmail.ru>
Subject: [PATCH 4.19 20/23] KVM: x86: Whitelist port 0x7e for pre-incrementing %rip
Date:   Sat,  4 May 2019 12:25:22 +0200
Message-Id: <20190504102452.182919984@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 8764ed55c9705e426d889ff16c26f398bba70b9b upstream.

KVM's recent bug fix to update %rip after emulating I/O broke userspace
that relied on the previous behavior of incrementing %rip prior to
exiting to userspace.  When running a Windows XP guest on AMD hardware,
Qemu may patch "OUT 0x7E" instructions in reaction to the OUT itself.
Because KVM's old behavior was to increment %rip before exiting to
userspace to handle the I/O, Qemu manually adjusted %rip to account for
the OUT instruction.

Arguably this is a userspace bug as KVM requires userspace to re-enter
the kernel to complete instruction emulation before taking any other
actions.  That being said, this is a bit of a grey area and breaking
userspace that has worked for many years is bad.

Pre-increment %rip on OUT to port 0x7e before exiting to userspace to
hack around the issue.

Fixes: 45def77ebf79e ("KVM: x86: update %rip after emulating IO")
Reported-by: Simon Becherer <simon@becherer.de>
Reported-and-tested-by: Iakov Karpov <srid@rkmail.ru>
Reported-by: Gabriele Balducci <balducci@units.it>
Reported-by: Antti Antinoja <reader@fennosys.fi>
Cc: stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/uapi/asm/kvm.h |    1 +
 arch/x86/kvm/x86.c              |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -378,6 +378,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
 #define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6328,6 +6328,12 @@ int kvm_emulate_instruction_from_buffer(
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
 
+static int complete_fast_pio_out_port_0x7e(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pio.count = 0;
+	return 1;
+}
+
 static int complete_fast_pio_out(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pio.count = 0;
@@ -6344,12 +6350,23 @@ static int kvm_fast_pio_out(struct kvm_v
 	unsigned long val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
 					    size, port, &val, 1);
+	if (ret)
+		return ret;
 
-	if (!ret) {
+	/*
+	 * Workaround userspace that relies on old KVM behavior of %rip being
+	 * incremented prior to exiting to userspace to handle "OUT 0x7e".
+	 */
+	if (port == 0x7e &&
+	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_OUT_7E_INC_RIP)) {
+		vcpu->arch.complete_userspace_io =
+			complete_fast_pio_out_port_0x7e;
+		kvm_skip_emulated_instruction(vcpu);
+	} else {
 		vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
 		vcpu->arch.complete_userspace_io = complete_fast_pio_out;
 	}
-	return ret;
+	return 0;
 }
 
 static int complete_fast_pio_in(struct kvm_vcpu *vcpu)


