Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718CF40902C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244818AbhIMNuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244090AbhIMNrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6196761288;
        Mon, 13 Sep 2021 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539952;
        bh=JJooFV/ryU/2X5VThW6kqQMdFjymF9VBm25fl68WEjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF906Qo/N265eq2EQymJkDQxX/hP75m57Pflb6xe2ETE0tiWQnQbO3D+dFd5EOGus
         fV51nq0Liq8ZXDz6jCN/iyMptw/RNEiAc2BxZfkF0/SRjDGR0kAp/8s7iEv9KCUT6E
         khA4vVyVvumIv425XswL1V60I28UZeJzT3WymaSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 227/236] KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation
Date:   Mon, 13 Sep 2021 15:15:32 +0200
Message-Id: <20210913131108.076522198@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 81b4b56d4f8130bbb99cf4e2b48082e5b4cfccb9 upstream.

If we are emulating an invalid guest state, we don't have a correct
exit reason, and thus we shouldn't do anything in this function.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210826095750.1650467-2-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 95b5a48c4f2b ("KVM: VMX: Handle NMIs, #MCs and async #PFs in common irqs-disabled fn", 2019-06-18)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6396,6 +6396,9 @@ static void vmx_handle_exit_irqoff(struc
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->emulation_required)
+		return;
+
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)


