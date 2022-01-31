Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A194A44A8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359190AbiAaLb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378745AbiAaL3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6FBC02C307;
        Mon, 31 Jan 2022 03:17:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C257B82A5C;
        Mon, 31 Jan 2022 11:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CB6C340E8;
        Mon, 31 Jan 2022 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627871;
        bh=7v0B2UhaT3PmQ3YNTN9Yu4Y8TPqXyjR/8nRw4Wtp3mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kJvfcSFkeNVpoU+OTLvDG7LYnsOBXru5G/wxGjAJ5BECrLd/Vp2jFS35fLmdypau
         +WcdLZACTmwv+wj60VGY8HvnI3NviyQ3HcjJzlCun6TTnJnd+iP1NvaNdHd1E5HaXu
         njv2TMYpTNtjhcVQKwHoTV+wvrFB/Ga+Ux/lCkcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 050/200] KVM: SVM: Dont intercept #GP for SEV guests
Date:   Mon, 31 Jan 2022 11:55:13 +0100
Message-Id: <20220131105235.246818323@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 0b0be065b7563ac708aaa9f69dd4941c80b3446d upstream.

Never intercept #GP for SEV guests as reading SEV guest private memory
will return cyphertext, i.e. emulating on #GP can't work as intended.

Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -312,7 +312,11 @@ int svm_set_efer(struct kvm_vcpu *vcpu,
 				return ret;
 			}
 
-			if (svm_gp_erratum_intercept)
+			/*
+			 * Never intercept #GP for SEV guests, KVM can't
+			 * decrypt guest memory to workaround the erratum.
+			 */
+			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
 	}
@@ -1238,9 +1242,10 @@ static void init_vmcb(struct kvm_vcpu *v
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
 	 * We intercept those #GP and allow access to them anyway
-	 * as VMware does.
+	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
+	 * decrypt guest memory to decode the faulting instruction.
 	 */
-	if (enable_vmware_backdoor)
+	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
 		set_exception_intercept(svm, GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);


