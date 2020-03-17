Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216AE188011
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgCQLG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbgCQLF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B5F9206EC;
        Tue, 17 Mar 2020 11:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443156;
        bh=M+Tm6S1nNVAZLoVlTn3WAcu/dg1eJFOwCy6wVFTDmco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4ld6THYFRe7XTJv1PG/MfkTsI3y2S3h/zZjL01kBNxcqUi/9j1UiGaaVKlqciH2V
         YhJizecHtf3jXI/B5Yg867ng7F8DcKqsBhK8nY6RSSBnqWqETK8e6L352zidJUXPyz
         PLHrj44D3guXwPrqC09WtErPhxfiufgP14RUVg1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 078/123] KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs
Date:   Tue, 17 Mar 2020 11:55:05 +0100
Message-Id: <20200317103315.446037688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 95fa10103dabc38be5de8efdfced5e67576ed896 upstream.

When an EVMCS enabled L1 guest on KVM will tries doing enlightened VMEnter
with EVMCS GPA = 0 the host crashes because the

evmcs_gpa != vmx->nested.hv_evmcs_vmptr

condition in nested_vmx_handle_enlightened_vmptrld() will evaluate to
false (as nested.hv_evmcs_vmptr is zeroed after init). The crash will
happen on vmx->nested.hv_evmcs pointer dereference.

Another problematic EVMCS ptr value is '-1' but it only causes host crash
after nested_release_evmcs() invocation. The problem is exactly the same as
with '0', we mistakenly think that the EVMCS pointer hasn't changed and
thus nested.hv_evmcs_vmptr is valid.

Resolve the issue by adding an additional !vmx->nested.hv_evmcs
check to nested_vmx_handle_enlightened_vmptrld(), this way we will
always be trying kvm_vcpu_map() when nested.hv_evmcs is NULL
and this is supposed to catch all invalid EVMCS GPAs.

Also, initialize hv_evmcs_vmptr to '0' in nested_release_evmcs()
to be consistent with initialization where we don't currently
set hv_evmcs_vmptr to '-1'.

Cc: stable@vger.kernel.org
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -223,7 +223,7 @@ static inline void nested_release_evmcs(
 		return;
 
 	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
-	vmx->nested.hv_evmcs_vmptr = -1ull;
+	vmx->nested.hv_evmcs_vmptr = 0;
 	vmx->nested.hv_evmcs = NULL;
 }
 
@@ -1828,7 +1828,8 @@ static int nested_vmx_handle_enlightened
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
 		return 1;
 
-	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
+	if (unlikely(!vmx->nested.hv_evmcs ||
+		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
 		if (!vmx->nested.hv_evmcs)
 			vmx->nested.current_vmptr = -1ull;
 


