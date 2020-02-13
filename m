Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20C15C608
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgBMP42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgBMPZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:27 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47ACB2469C;
        Thu, 13 Feb 2020 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607527;
        bh=JFBmRzG9tCU5CB6dXtmryaVPF24jOZixMc1b2NHjwI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vs0Vp59DHZYGWn9qMySa8yO2om1UpGGZtrSg/mngZb1UxixNdnjM6njeZEnVABnYJ
         PYcSzmqzOVZxQ1gX9PR0Fap6WQE9UXCQ3c60g5XP2Hye/AAtaykFqgOWdk3E94C2Qo
         3PlZ663uW1ffpD4bSuOMhqBF29Ugr7q5jP+/WS2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 089/173] KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
Date:   Thu, 13 Feb 2020 07:19:52 -0800
Message-Id: <20200213151955.573534147@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 1a978d9d3e72ddfa40ac60d26301b154247ee0bc upstream.

Call kvm_vcpu_uninit() if vcore creation fails to avoid leaking any
resources allocated by kvm_vcpu_init(), i.e. the vcpu->run page.

Fixes: 371fefd6f2dc4 ("KVM: PPC: Allow book3s_hv guests to use SMT processor modes")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1997,7 +1997,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu
 	mutex_unlock(&kvm->lock);
 
 	if (!vcore)
-		goto free_vcpu;
+		goto uninit_vcpu;
 
 	spin_lock(&vcore->lock);
 	++vcore->num_threads;
@@ -2014,6 +2014,8 @@ static struct kvm_vcpu *kvmppc_core_vcpu
 
 	return vcpu;
 
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 free_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 out:


