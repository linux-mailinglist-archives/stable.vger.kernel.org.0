Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B986AEC68
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCGRzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjCGRy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:54:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC504A2F08;
        Tue,  7 Mar 2023 09:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ABD7B8169C;
        Tue,  7 Mar 2023 17:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE8BC433EF;
        Tue,  7 Mar 2023 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211349;
        bh=ch7KaQcbim/15R+s37djgUEAiy602Smc48y+7FjJHC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6TiMBW0ptuB367SMKDd+OnJwqKRrBhmi3ZXBZp7NXuHkW18ap3k56AM5yYuZVhVN
         A0MUFNokHUOJXKihEqXC2BsAt3LprhjXMt6Nv77wobo+wS2i/aejxXW3t9c5broYQw
         xPgycQ2lSd2Ac093KK9WE8+FpZ1nzzLJxVptZbvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 6.2 0834/1001] KVM: SVM: hyper-v: placate modpost section mismatch error
Date:   Tue,  7 Mar 2023 18:00:06 +0100
Message-Id: <20230307170057.987429663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -30,7 +30,7 @@ static inline void svm_hv_init_vmcb(stru
 		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
@@ -84,7 +84,7 @@ static inline void svm_hv_init_vmcb(stru
 {
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 }
 


