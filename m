Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FF6409651
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242055AbhIMOvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346880AbhIMOrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C229D63238;
        Mon, 13 Sep 2021 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541552;
        bh=7zhm6z9PER+mHquvNpuD0o99JMDLVCnd3Wg15sAQvjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMfSDusficP/qwJny/cvWUnaQoPPmE68nidqlhCeoQnBZxIyzzWnl3ztj8RoTDmEn
         AFLXMKOw75yg5AyHEWiYn+oB7CpXtyxZgZGCchfH9/y6QLVS17pZAniugpTssaHJuo
         f7hc2G0fg/sWX3LUF19HSSBWX/AuEYBybCx3PL9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 315/334] KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation
Date:   Mon, 13 Sep 2021 15:16:09 +0200
Message-Id: <20210913131124.080023738@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
@@ -6368,6 +6368,9 @@ static void vmx_handle_exit_irqoff(struc
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->emulation_required)
+		return;
+
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)


