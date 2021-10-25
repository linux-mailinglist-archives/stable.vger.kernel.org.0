Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59E43A301
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhJYTzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237333AbhJYTwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F4F36112D;
        Mon, 25 Oct 2021 19:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191026;
        bh=+nCuYCAGzKAFX1CyeujOj1khmu5TCUt2LzxFOYDqaU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSwGAsSWE335srUurXl8OtTiiOHOqHY6GVAjXGPxFkFVW7SzHIeeheEKdWpP/Qwxn
         VE2PhAGqMvbPaleSFGOKZHvvFsG2KDOXxL2wSIbjrPhyB0Pmd24FgQz5eILb/P6r1v
         qXyJfB9jBNw+pcYFGS4GD4LDTFzxlBCvRvX7RWiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 108/169] KVM: SEV-ES: keep INS functions together
Date:   Mon, 25 Oct 2021 21:14:49 +0200
Message-Id: <20211025191031.770175381@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 4fa4b38dae6fc6a3695695add8c18fa8b6a05a1a upstream.

Make the diff a little nicer when we actually get to fixing
the bug.  No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12320,15 +12320,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
-static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
-{
-	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
-	       vcpu->arch.pio.count * vcpu->arch.pio.size);
-	vcpu->arch.pio.count = 0;
-
-	return 1;
-}
-
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 			   unsigned int port, unsigned int count)
 {
@@ -12344,6 +12335,15 @@ static int kvm_sev_es_outs(struct kvm_vc
 	return 0;
 }
 
+static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+{
+	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
+	       vcpu->arch.pio.count * vcpu->arch.pio.size);
+	vcpu->arch.pio.count = 0;
+
+	return 1;
+}
+
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			  unsigned int port, unsigned int count)
 {


