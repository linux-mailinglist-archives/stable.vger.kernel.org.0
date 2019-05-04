Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E221390B
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfEDK0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfEDK03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865D62084A;
        Sat,  4 May 2019 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965588;
        bh=VYeaM02WOFZmDAkP9Bx9OXLSTfvKcsMXVnWcxFAVXtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmD0Q0nlLiK62RHuOcRUVvPDg+8pbfL4E8v7lmSWyyAs8IvFQbOADmR2kaYxrvnKM
         8xlkcFdBXALD251Wei0LU+ALvW9FIrJccUrK2PAvIDcFgVp3fq8QqeTSu2hPcfz5+U
         rDjU4qrKvb9c5M9oPsa+6aGjkrF7Ke8ESk2AIeAE=
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
Subject: [PATCH 5.0 28/32] KVM: x86: Whitelist port 0x7e for pre-incrementing %rip
Date:   Sat,  4 May 2019 12:25:13 +0200
Message-Id: <20190504102453.345374945@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
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
@@ -381,6 +381,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
 #define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6536,6 +6536,12 @@ int kvm_emulate_instruction_from_buffer(
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
@@ -6552,12 +6558,23 @@ static int kvm_fast_pio_out(struct kvm_v
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


