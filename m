Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF71B5C94
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfIRG1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfIRG1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9730521925;
        Wed, 18 Sep 2019 06:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788067;
        bh=e2SKe0d1r0FnPGDKgUrqxsSyXHcE1lOe8ABJ4w+dG7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2U4Jq5ePWUSTggBIv5o+bg5NkD9BR151A7f4NGyxOzBe6279k6kiIHLa/W99UCsJG
         skD156epGJ6GG2hdRaOPgA9PNhqhdttdct+4i3l0uNZXlrWc0gFd0AaryibxTJxKas
         K66ZJXaH2ySnxycf1CYkXjzYBjUprjugZDS+dhFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 47/85] KVM: nVMX: handle page fault in vmread
Date:   Wed, 18 Sep 2019 08:19:05 +0200
Message-Id: <20190918061235.619611195@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
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
 arch/x86/kvm/vmx/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4411,6 +4411,7 @@ static int handle_vmread(struct kvm_vcpu
 	int len;
 	gva_t gva = 0;
 	struct vmcs12 *vmcs12;
+	struct x86_exception e;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4451,7 +4452,8 @@ static int handle_vmread(struct kvm_vcpu
 				vmx_instruction_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		kvm_write_guest_virt_system(vcpu, gva, &field_value, len, NULL);
+		if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
+			kvm_inject_page_fault(vcpu, &e);
 	}
 
 	return nested_vmx_succeed(vcpu);


