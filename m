Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7AB860B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406754AbfISWWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404958AbfISWWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21EC21924;
        Thu, 19 Sep 2019 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931724;
        bh=8BTfjg4RNnB4XrZjNOTvCz6Gtu4UnMZH+r+BDGHfquI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nM6minULzke+XowmMgGG13m5mvkRU0j2unFgN4ZfCEEzcTNcp9fnNAw1hD3ZOIAqE
         5PsqDqPSYlxEsAPIQwIjBZTicTd2QnnG1Y5z93SrU6bZs0ZYDWAoLDWcvr1DfblV+v
         wOoaNFiiZR5r/27BUY34DsSyWTkfVsK3Kk3HwQfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 17/56] KVM: nVMX: handle page fault in vmread
Date:   Fri, 20 Sep 2019 00:03:58 +0200
Message-Id: <20190919214752.927023617@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit f7eea636c3d505fe6f1d1066234f1aaf7171b681 upstream.

The implementation of vmread to memory is still incomplete, as it
lacks the ability to do vmread to I/O memory just like vmptrst.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7247,6 +7247,7 @@ static int handle_vmread(struct kvm_vcpu
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gva_t gva = 0;
+	struct x86_exception e;
 
 	if (!nested_vmx_check_permission(vcpu) ||
 	    !nested_vmx_check_vmcs12(vcpu))
@@ -7273,8 +7274,10 @@ static int handle_vmread(struct kvm_vcpu
 				vmx_instruction_info, true, &gva))
 			return 1;
 		/* _system ok, as nested_vmx_check_permission verified cpl=0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value,
-					    (is_long_mode(vcpu) ? 8 : 4), NULL);
+		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+						(is_long_mode(vcpu) ? 8 : 4),
+						NULL))
+			kvm_inject_page_fault(vcpu, &e);
 	}
 
 	nested_vmx_succeed(vcpu);


