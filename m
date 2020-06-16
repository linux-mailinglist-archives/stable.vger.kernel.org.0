Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF17A1FB9DC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgFPPrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732303AbgFPPrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A4021508;
        Tue, 16 Jun 2020 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322432;
        bh=c+0XdW9O/ZwTbnxHuQHU04UXfdF/gypjdKt3Avss+hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHM4P+h3ohZcdhF4ayiJVjjkz4z5hU9veFnlWrv0KrQO671eK2xUQa0YpX2XTLTAO
         Ajrvnw7r7SMjI68I8Dc0KfKb43OaplLLLi1u9nfiajdNRD5exihaPBk22zNhy4s5Tp
         qWxvH9mV15XLSUX6Ot3LaFFQeJJmTItpTy4Me3Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.7 130/163] KVM: nVMX: Consult only the "basic" exit reason when routing nested exit
Date:   Tue, 16 Jun 2020 17:35:04 +0200
Message-Id: <20200616153113.040756753@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 2ebac8bb3c2d35f5135466490fc8eeaf3f3e2d37 upstream.

Consult only the basic exit reason, i.e. bits 15:0 of vmcs.EXIT_REASON,
when determining whether a nested VM-Exit should be reflected into L1 or
handled by KVM in L0.

For better or worse, the switch statement in nested_vmx_exit_reflected()
currently defaults to "true", i.e. reflects any nested VM-Exit without
dedicated logic.  Because the case statements only contain the basic
exit reason, any VM-Exit with modifier bits set will be reflected to L1,
even if KVM intended to handle it in L0.

Practically speaking, this only affects EXIT_REASON_MCE_DURING_VMENTRY,
i.e. a #MC that occurs on nested VM-Enter would be incorrectly routed to
L1, as "failed VM-Entry" is the only modifier that KVM can currently
encounter.  The SMM modifiers will never be generated as KVM doesn't
support/employ a SMI Transfer Monitor.  Ditto for "exit from enclave",
as KVM doesn't yet support virtualizing SGX, i.e. it's impossible to
enter an enclave in a KVM guest (L1 or L2).

Fixes: 644d711aa0e1 ("KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit")
Cc: Jim Mattson <jmattson@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200227174430.26371-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5577,7 +5577,7 @@ bool nested_vmx_exit_reflected(struct kv
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
 
-	switch (exit_reason) {
+	switch ((u16)exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		if (is_nmi(intr_info))
 			return false;


