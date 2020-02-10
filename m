Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691FB157BA1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgBJNbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgBJMgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:02 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E116221739;
        Mon, 10 Feb 2020 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338162;
        bh=7bEOyghHbIRBEb5+E7PN/iuLtBrvwo3acDPTelhVGt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+tVutS4gEESbwPFraeEPESfPQV2itjCfwN5D/IR4ITpnvhIohQo79L4rIJyOPMnf
         pPTUYPuA5qUea6gsbmpm2HfGD18ETak5M7eqthXhQ+Qv/O486S2ADCeY90IcsC/TeR
         ty0KhfOwIdbjir+ogRpUrBKhykzQu1jL0rt4I6ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 137/195] KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
Date:   Mon, 10 Feb 2020 04:33:15 -0800
Message-Id: <20200210122318.716850829@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit cb10bf9194f4d2c5d830eddca861f7ca0fecdbb4 upstream.

Explicitly free the shared page if kvmppc_mmu_init() fails during
kvmppc_core_vcpu_create(), as the page is freed only in
kvmppc_core_vcpu_free(), which is not reached via kvm_vcpu_uninit().

Fixes: 96bc451a15329 ("KVM: PPC: Introduce shared page")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_pr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1772,10 +1772,12 @@ static struct kvm_vcpu *kvmppc_core_vcpu
 
 	err = kvmppc_mmu_init(vcpu);
 	if (err < 0)
-		goto uninit_vcpu;
+		goto free_shared_page;
 
 	return vcpu;
 
+free_shared_page:
+	free_page((unsigned long)vcpu->arch.shared);
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
 free_shadow_vcpu:


