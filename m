Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E637CB54
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbhELQfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241661AbhELQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C3661A2B;
        Wed, 12 May 2021 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834892;
        bh=7BOrECecumwVI4LPQYkbiYqR4Eu7px9PCN1oDcFNZcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmWPLj4it3+Z63qcOCr8NBIyllyjN3lyr1Hmufp1QC+mF2ERqtYezKAkQAZcnkO6x
         t66aEc7eStNjU0s17oy04UTlIWtoZe8lM4459mMEUdrncCwj86ax6RsNHoc78uSTgj
         Jb2gtjSe97e9PpyY9FRmRYbGks9j337+jt/bZyvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 126/677] KVM: arm64: Fully zero the vcpu state on reset
Date:   Wed, 12 May 2021 16:42:52 +0200
Message-Id: <20210512144841.400695015@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 85d703746154cdc6794b6654b587b0b0354c97e9 upstream.

On vcpu reset, we expect all the registers to be brought back
to their initial state, which happens to be a bunch of zeroes.

However, some recent commit broke this, and is now leaving a bunch
of registers (such as the FP state) with whatever was left by the
guest. My bad.

Zero the reset of the state (32bit SPSRs and FPSIMD state).

Cc: stable@vger.kernel.org
Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/reset.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -242,6 +242,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
+	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
+	vcpu->arch.ctxt.spsr_abt = 0;
+	vcpu->arch.ctxt.spsr_und = 0;
+	vcpu->arch.ctxt.spsr_irq = 0;
+	vcpu->arch.ctxt.spsr_fiq = 0;
 	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */


