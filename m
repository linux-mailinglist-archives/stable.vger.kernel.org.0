Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB52408A2A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhIML3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238490AbhIML3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE60460F44;
        Mon, 13 Sep 2021 11:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532489;
        bh=kVIhJ/WE4wMC/pny1iBF1D5l9dETUfaiD9L9NPjeULw=;
        h=Subject:To:Cc:From:Date:From;
        b=dH2lOz6Cb0xiz8c7RngKjDsvtQLsCt4/pyJ2p5iWrXT2YDu9cF4vd/JJqyqzylV9c
         HKKkLAImEIOrgosI2PaWUy5oak5sg1TRPi+8UNPOe3QcHvGjNK9PSkVWefzyw2SrT9
         2vjEbqF6yAa52red/hKgghkUJcsz/n++6MhifkX0=
Subject: FAILED: patch "[PATCH] KVM: VMX: avoid running vmx_handle_exit_irqoff in case of" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:28:07 +0200
Message-ID: <16315324877261@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 81b4b56d4f8130bbb99cf4e2b48082e5b4cfccb9 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 26 Aug 2021 12:57:49 +0300
Subject: [PATCH] KVM: VMX: avoid running vmx_handle_exit_irqoff in case of
 emulation

If we are emulating an invalid guest state, we don't have a correct
exit reason, and thus we shouldn't do anything in this function.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210826095750.1650467-2-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 95b5a48c4f2b ("KVM: VMX: Handle NMIs, #MCs and async #PFs in common irqs-disabled fn", 2019-06-18)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..0c2c0d5ae873 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6382,6 +6382,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->emulation_required)
+		return;
+
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)

