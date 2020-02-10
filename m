Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2161C15772E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgBJMlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbgBJMlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:14 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9FC21569;
        Mon, 10 Feb 2020 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338474;
        bh=ROBgPv5K8IOy3Rm+x9pw+cjWf2B51cdvq0ZBfwoVUJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/H6K2HnDMZs8TY6i6Gxk6c4WdvvZ+geSzd4q1xBTrBCyCqYGxPGjLyKiaLE4h1wl
         spZtnOPJ/jtNQAy0tu1G1rPqeUJl8nuYxm3gEzCAp1ewjWH/1Us2t1OPGAEz+1ZdXN
         lNz/YLqOSQU/AoC4siKfQHZNkLGrYO8ph1dwCtW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 241/367] KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
Date:   Mon, 10 Feb 2020 04:32:34 -0800
Message-Id: <20200210122446.425754469@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -1806,10 +1806,12 @@ static struct kvm_vcpu *kvmppc_core_vcpu
 
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


