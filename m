Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3781A499A62
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346774AbiAXVnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51250 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454382AbiAXVc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E11BA6131F;
        Mon, 24 Jan 2022 21:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5CBC340E4;
        Mon, 24 Jan 2022 21:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059947;
        bh=+IC5SxFlPCTwimrhYxrbf0C6EBpcKCzs3MZ8Q9Z5Lf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrXxvxxMikzF1qW3RXVQ15uB1IAMV+NxeXxnAnNUy1HjKqhIIpZ7hCaTu2O6UG6Ou
         p0ePgVNW59F3mApqOTOqHMBv25fFkx6tcUAXe/KAnnhHimteVjSZdmspBA0SV5jXUr
         Mf5graGyfCmYJjNSrGfwJMp8jURmj7uQcXbGufvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0788/1039] KVM: VMX: Dont unblock vCPU w/ Posted IRQ if IRQs are disabled in guest
Date:   Mon, 24 Jan 2022 19:42:57 +0100
Message-Id: <20220124184151.781814654@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 1831fa44df743a7cdffdf1c12c799bf6f3c12b8c ]

Don't configure the wakeup handler when a vCPU is blocking with IRQs
disabled, in which case any IRQ, posted or otherwise, should not be
recognized and thus should not wake the vCPU.

Fixes: bf9f6ac8d749 ("KVM: Update Posted-Interrupts Descriptor when vCPU is blocked")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009021236.4122790-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 21ea58d25771f..696ad48ab5daa 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -147,7 +147,8 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!vmx_can_use_vtd_pi(vcpu->kvm))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm) ||
+	    vmx_interrupt_blocked(vcpu))
 		return 0;
 
 	WARN_ON(irqs_disabled());
-- 
2.34.1



