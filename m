Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3446AF1AB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjCGSq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbjCGSpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B4B8639;
        Tue,  7 Mar 2023 10:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 359A061522;
        Tue,  7 Mar 2023 18:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B84DC433D2;
        Tue,  7 Mar 2023 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214122;
        bh=Wd27njoz4huAr8le8GYUdZSLpoaLwk2ozr28eL5dNaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgacd6dUsZ7q8NKmir9ruzeCY/ZYmC6ej9aQvGJTVJXvgCL7JZe8IiMR6xvDh+LHn
         Y7HUCIlgp5MKE2zTWPrTiGg7xzX6kDcq7ZMmyzgROgTGaBc8Btakg3qOU0UkEAqtVq
         FKHiOrQJL55avEUmPJYNRU1vPKbTTAcsnSS57t6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 6.1 728/885] KVM: SVM: hyper-v: placate modpost section mismatch error
Date:   Tue,  7 Mar 2023 18:01:02 +0100
Message-Id: <20230307170033.615893897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b upstream.

modpost reports section mismatch errors/warnings:
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)

This "(unknown) (section: .init.data)" all refer to svm_x86_ops.

Tag svm_hv_hardware_setup() with __init to fix a modpost warning as the
non-stub implementation accesses __initdata (svm_x86_ops), i.e. would
generate a use-after-free if svm_hv_hardware_setup() were actually invoked
post-init.  The helper is only called from svm_hardware_setup(), which is
also __init, i.e. lack of __init is benign other than the modpost warning.

Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineeth Pillai <viremana@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20230222073315.9081-1-rdunlap@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm_onhyperv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -28,7 +28,7 @@ static inline void svm_hv_init_vmcb(stru
 		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
@@ -85,7 +85,7 @@ static inline void svm_hv_init_vmcb(stru
 {
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 }
 


