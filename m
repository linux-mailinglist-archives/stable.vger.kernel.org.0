Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A01AC2A2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896308AbgDPNau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896303AbgDPNar (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FAD206E9;
        Thu, 16 Apr 2020 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043846;
        bh=hPHzP1cI6xI6P4p/39gIrtLEtm8iXU+X02YekCBI8Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vwg4WqnYf5TI+v93iCet6sQZJuE/1B4GeiKSPbwTjS4JK1BHDXRgSlXvmd5/E9xR
         k160nmPdjMPWVK/C5oYgvd98/ANKmyRJBaNs1rVeJuMEM3hYYvDOToPH8V7ggOAjQf
         4w5EjNvgflbfQgvYtWdFOEkroWaC7U2dZvjoW3uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 084/146] KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
Date:   Thu, 16 Apr 2020 15:23:45 +0200
Message-Id: <20200416131254.309852839@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit d18b2f43b9147c8005ae0844fb445d8cc6a87e31 upstream.

Check the result of __vmalloc() to avoid dereferencing a NULL pointer in
the event that allocation failres.

Fixes: d1e5b0e98ea27 ("kvm: Make VM ioctl do valloc for some archs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/vmx.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1917,6 +1917,10 @@ static void __unregister_enc_region_lock
 static struct kvm *svm_vm_alloc(void)
 {
 	struct kvm_svm *kvm_svm = vzalloc(sizeof(struct kvm_svm));
+
+	if (!kvm_svm)
+		return NULL;
+
 	return &kvm_svm->kvm;
 }
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10986,6 +10986,10 @@ STACK_FRAME_NON_STANDARD(vmx_vcpu_run);
 static struct kvm *vmx_vm_alloc(void)
 {
 	struct kvm_vmx *kvm_vmx = vzalloc(sizeof(struct kvm_vmx));
+
+	if (!kvm_vmx)
+		return NULL;
+
 	return &kvm_vmx->kvm;
 }
 


