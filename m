Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253004A2F93
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347906AbiA2Mxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:53:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36830 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350355AbiA2Mxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:53:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ABA560BA0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F7FC340E5;
        Sat, 29 Jan 2022 12:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643460814;
        bh=IEaEjPHNari/oP6ipRDcU6vlUD8Dm+fZVyo8kItp89U=;
        h=Subject:To:Cc:From:Date:From;
        b=HnNp3t0le4iYqQwv9xYI7Ge+R4EjwtpVDeWRDfI+DFrxf0le+XiHvyr999U1TODz9
         dpDoWHAfMr0BDqPzWDUItxml/WKb163wGR5YaPnVWEr8w8p+ztLTvksw9zCCVGSv1f
         xY4p7bqOKvSDKrPIcZdbCxkRWkgy0tWEaHMT1C6s=
Subject: FAILED: patch "[PATCH] KVM: SVM: Don't intercept #GP for SEV guests" failed to apply to 5.10-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, liam.merwick@oracle.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:53:31 +0100
Message-ID: <164346081123333@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b0be065b7563ac708aaa9f69dd4941c80b3446d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Jan 2022 01:07:13 +0000
Subject: [PATCH] KVM: SVM: Don't intercept #GP for SEV guests

Never intercept #GP for SEV guests as reading SEV guest private memory
will return cyphertext, i.e. emulating on #GP can't work as intended.

Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37eb3168e0ea..defc91a8c04c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -312,7 +312,11 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
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
@@ -1010,9 +1014,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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

