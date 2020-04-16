Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2939E1AC74B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgDPOwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409326AbgDPN51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B8220732;
        Thu, 16 Apr 2020 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045447;
        bh=AQGos6++wco5y3w2jWqbeTigZBPa3pQryy4NKEsY0sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0n33/7XPlKyHEY/BVL7UpWM9kELuUw1HYG2FTxHsdFR875tz68WEgz2ig8zbYFfuM
         TXc8iNC5/TQ658lEoF9cdAOansAYVBfGy3Y0pS2HbHPpr5dX+VO/UJPOEdkBTwLK90
         vo3Rg0UjKujRQ7hW4B1iYBURNVyJfZGfqidldYpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 136/254] KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
Date:   Thu, 16 Apr 2020 15:23:45 +0200
Message-Id: <20200416131343.504058000@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
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
 arch/x86/kvm/svm.c     |    4 ++++
 arch/x86/kvm/vmx/vmx.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1943,6 +1943,10 @@ static struct kvm *svm_vm_alloc(void)
 	struct kvm_svm *kvm_svm = __vmalloc(sizeof(struct kvm_svm),
 					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
 					    PAGE_KERNEL);
+
+	if (!kvm_svm)
+		return NULL;
+
 	return &kvm_svm->kvm;
 }
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6671,6 +6671,10 @@ static struct kvm *vmx_vm_alloc(void)
 	struct kvm_vmx *kvm_vmx = __vmalloc(sizeof(struct kvm_vmx),
 					    GFP_KERNEL_ACCOUNT | __GFP_ZERO,
 					    PAGE_KERNEL);
+
+	if (!kvm_vmx)
+		return NULL;
+
 	return &kvm_vmx->kvm;
 }
 


