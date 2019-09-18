Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D02DB5D51
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfIRGUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728700AbfIRGUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756CF218AF;
        Wed, 18 Sep 2019 06:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787641;
        bh=gZ8a0o55VbNtlcpNUMcUSQywJuCz9aqnY0tE686ZAJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmO7R2B9W57+jcCU1mrkkc2cxoFMg1js/FB/FkO3PuZ6SfBUWi0Jl7z7aR5EcHlI9
         JsE2dm9+dPepUfZ0RWjSTrkG9vSHJ5wk1Wlwn/L4hJZv/3eKGOapt2c4ym8KacrzWP
         4HtXTwzSTOro1L5pZORtwefb+IfQOIjhB5KKmdv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 24/45] KVM: nVMX: handle page fault in vmread
Date:   Wed, 18 Sep 2019 08:19:02 +0200
Message-Id: <20190918061225.491402324@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
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
@@ -7996,6 +7996,7 @@ static int handle_vmread(struct kvm_vcpu
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gva_t gva = 0;
+	struct x86_exception e;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -8023,8 +8024,10 @@ static int handle_vmread(struct kvm_vcpu
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


