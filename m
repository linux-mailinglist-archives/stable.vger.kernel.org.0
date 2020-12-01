Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EE62C9DAE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390986AbgLAJ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388045AbgLAJDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2446C22245;
        Tue,  1 Dec 2020 09:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813362;
        bh=RZ0Yuo35xupoAMfjsdzGM6d++OSlTTNTmyuaKUyK40A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3WVnpxXaPkEhIwpVjiXdxbZsBqhzJ/Q4C/HmbQKyy3h4DXwFQNdV8+PVRlCNeic6
         a+JJEwyLu3kM7zUFjFooz69GubFAMHbY+yUKv3z4LW2m+vCWBVnmY9ENIkV3McmOGW
         rIuwyBFCkn6RGDcUFxQCVMLUETS5YBaLVlbS6//k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 14/98] KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page
Date:   Tue,  1 Dec 2020 09:52:51 +0100
Message-Id: <20201201084654.618075442@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 75b49620267c700f0a07fec7f27f69852db70e46 upstream.

When accessing the ESB page of a source interrupt, the fault handler
will retrieve the page address from the XIVE interrupt 'xive_irq_data'
structure. If the associated KVM XIVE interrupt is not valid, that is
not allocated at the HW level for some reason, the fault handler will
dereference a NULL pointer leading to the oops below :

  WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.c:259 xive_native_esb_fault+0xe4/0x240 [kvm]
  CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-240.el8.ppc64le #1
  NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
  REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        --------- -  -  (4.18.0-240.el8.ppc64le)
  MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER: 00000000
  CFAR: c00000000044b160 IRQMASK: 0
  GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f69617c10
  GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 ffffffffffffffff
  GPR08: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
  GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 0000000000000000
  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c000000001c76f90
  GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0eb98c78
  GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 0000000000000011
  NIP [c00800000e949fac] xive_native_esb_fault+0xe4/0x240 [kvm]
  LR [c00000000044b164] __do_fault+0x64/0x220
  Call Trace:
  [c000001f69617ac0] [0000000137a5dc20] 0x137a5dc20 (unreliable)
  [c000001f69617b50] [c00000000044b164] __do_fault+0x64/0x220
  [c000001f69617b90] [c000000000453838] do_fault+0x218/0x930
  [c000001f69617bf0] [c000000000456f50] __handle_mm_fault+0x350/0xdf0
  [c000001f69617cd0] [c000000000457b1c] handle_mm_fault+0x12c/0x310
  [c000001f69617d10] [c00000000007ef44] __do_page_fault+0x264/0xbb0
  [c000001f69617df0] [c00000000007f8c8] do_page_fault+0x38/0xd0
  [c000001f69617e30] [c00000000000a714] handle_page_fault+0x18/0x38
  Instruction dump:
  40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c2004ac
  7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e89e0018
  ---[ end trace 66c6ff034c53f64f ]---
  xive-kvm: xive_native_esb_fault: accessing invalid ESB page for source 8 !

Fix that by checking the validity of the KVM XIVE interrupt structure.

Fixes: 6520ca64cde7 ("KVM: PPC: Book3S HV: XIVE: Add a mapping for the source ESB pages")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201105134713.656160-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive_native.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -252,6 +252,13 @@ static vm_fault_t xive_native_esb_fault(
 	}
 
 	state = &sb->irq_state[src];
+
+	/* Some sanity checking */
+	if (!state->valid) {
+		pr_devel("%s: source %lx invalid !\n", __func__, irq);
+		return VM_FAULT_SIGBUS;
+	}
+
 	kvmppc_xive_select_irq(state, &hw_num, &xd);
 
 	arch_spin_lock(&sb->lock);


