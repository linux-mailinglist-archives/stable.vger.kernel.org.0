Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA386B5D1D
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfIRGWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbfIRGWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BAA720678;
        Wed, 18 Sep 2019 06:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787762;
        bh=nZb4bBz24FVv2Uk4ACHwV6zED5w+vr9tyjHM/k0SMn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFp2HMesz8BZOXIt7rOYJMGgym9Q5WKQiiaQdxayDMOTHfCmGGEVMrJI53i/hXAvx
         S87KX/rWcssVyaHAWfCbEZzmy5PWYXHg5defkD7BJZ2RyCfjHqYI78myr0cYe6wlA1
         qIgyR+lNsI5G5nKRq2jMlv3gIfyycGv2/k7WvFjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 24/50] KVM: nVMX: handle page fault in vmread
Date:   Wed, 18 Sep 2019 08:19:07 +0200
Message-Id: <20190918061225.613299767@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
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
@@ -8757,6 +8757,7 @@ static int handle_vmread(struct kvm_vcpu
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
+	struct x86_exception e;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -8798,8 +8799,10 @@ static int handle_vmread(struct kvm_vcpu
 				vmx_instruction_info, true, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value,
-					    (is_long_mode(vcpu) ? 8 : 4), NULL);
+		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+						(is_long_mode(vcpu) ? 8 : 4),
+						NULL))
+			kvm_inject_page_fault(vcpu, &e);
 	}
 
 	nested_vmx_succeed(vcpu);


