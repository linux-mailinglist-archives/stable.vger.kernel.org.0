Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2F469EBE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356656AbhLFPn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358438AbhLFPiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29860C08EB20;
        Mon,  6 Dec 2021 07:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BABDA6131B;
        Mon,  6 Dec 2021 15:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A5C341C1;
        Mon,  6 Dec 2021 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804248;
        bh=64KKCapY+Rthlc2Y6+adDlTriV4teGL18xS7uo2/qyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDAcmCsjf+h9yHkdSBMPHDfAZjw99XM3JzJXWbOOKl1wY5YWYUhgmuAnZSOXW9PGA
         G6kJjPx55fjEcRDyGkvJuR+0RbdmgzhUuAekxQWdpCR/VmnD581E6UA54Asy8juouh
         urx2GzVBNDNEYwjg8DHlyjzcanpfaeazoJnl/e9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 080/207] KVM: MMU: shadow nested paging does not have PKU
Date:   Mon,  6 Dec 2021 15:55:34 +0100
Message-Id: <20211206145613.016842754@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 28f091bc2f8c23b7eac2402956b692621be7f9f4 upstream.

Initialize the mask for PKU permissions as if CR4.PKE=0, avoiding
incorrect interpretations of the nested hypervisor's page tables.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4852,7 +4852,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	struct kvm_mmu_role_regs regs = {
 		.cr0 = cr0,
-		.cr4 = cr4,
+		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
 	union kvm_mmu_role new_role;
@@ -4916,7 +4916,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_
 	context->direct_map = false;
 
 	update_permission_bitmask(context, true);
-	update_pkru_bitmask(context);
+	context->pkru_mask = 0;
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }


