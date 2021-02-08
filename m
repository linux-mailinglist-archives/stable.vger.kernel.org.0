Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1179313733
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhBHPVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhBHPPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:15:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADECF64E87;
        Mon,  8 Feb 2021 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797068;
        bh=T+U4VjxvmnnnSs/rMh/18B9t/QKOrQGDp6Zyxma2JlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9xaY+yNsEnnMksYMT5Kr/cPk1LCYGrxwub6QJLsTqFMCGitsNuJVzX+QU7yHQ8Pe
         BmXuaXOxsVZqCvpRKqEf1kcnrkbPgFbIyTptENDy09JlMbbXAYDmE8mHMfuTP1pI9S
         /YMjpUXe9OPpE+Gp1+lX/GWQl3i9JNY5UEolUsbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonny Barker <jonny@jonnybarker.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 46/65] KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode
Date:   Mon,  8 Feb 2021 16:01:18 +0100
Message-Id: <20210208145812.001226891@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 943dea8af21bd896e0d6c30ea221203fb3cd3265 upstream.

Set the emulator context to PROT64 if SYSENTER transitions from 32-bit
userspace (compat mode) to a 64-bit kernel, otherwise the RIP update at
the end of x86_emulate_insn() will incorrectly truncate the new RIP.

Note, this bug is mostly limited to running an Intel virtual CPU model on
an AMD physical CPU, as other combinations of virtual and physical CPUs
do not trigger full emulation.  On Intel CPUs, SYSENTER in compatibility
mode is legal, and unconditionally transitions to 64-bit mode.  On AMD
CPUs, SYSENTER is illegal in compatibility mode and #UDs.  If the vCPU is
AMD, KVM injects a #UD on SYSENTER in compat mode.  If the pCPU is Intel,
SYSENTER will execute natively and not trigger #UD->VM-Exit (ignoring
guest TLB shenanigans).

Fixes: fede8076aab4 ("KVM: x86: handle wrap around 32-bit address space")
Cc: stable@vger.kernel.org
Signed-off-by: Jonny Barker <jonny@jonnybarker.com>
[sean: wrote changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210202165546.2390296-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2890,6 +2890,8 @@ static int em_sysenter(struct x86_emulat
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_ESP, &msr_data);
 	*reg_write(ctxt, VCPU_REGS_RSP) = (efer & EFER_LMA) ? msr_data :
 							      (u32)msr_data;
+	if (efer & EFER_LMA)
+		ctxt->mode = X86EMUL_MODE_PROT64;
 
 	return X86EMUL_CONTINUE;
 }


