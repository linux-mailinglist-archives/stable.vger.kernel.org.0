Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A1C593B67
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244298AbiHOUOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiHOUJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E745E83F13;
        Mon, 15 Aug 2022 11:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A35B8105C;
        Mon, 15 Aug 2022 18:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D315C433B5;
        Mon, 15 Aug 2022 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589756;
        bh=ykdKXs4qXCQoLzzTkpAnTym0LPHlNozcDOaKd/4WEhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mwq2KFQEUUdbj+L1/uXCiALmqZYwKc/vQbqI9ITomoAPMjuZgaiXvfImSbG2dvSD
         rlLT4Nmk14QHFBwPdeYMOcRypy0qbsB8m5Jxb2EhveeeCTjSwnW+Bh9RdCNH+kHIF6
         GK/sHsOKdpQKjFHNUGzDvr5PG3MCb5UBOLjw3AaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0039/1095] KVM: x86: Tag kvm_mmu_x86_module_init() with __init
Date:   Mon, 15 Aug 2022 19:50:38 +0200
Message-Id: <20220815180431.026391216@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 982bae43f11c37b51d2f1961bb25ef7cac3746fa upstream.

Mark kvm_mmu_x86_module_init() with __init, the entire reason it exists
is to initialize variables when kvm.ko is loaded, i.e. it must never be
called after module initialization.

Fixes: 1d0e84806047 ("KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220803224957.1285926-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu/mmu.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1588,7 +1588,7 @@ static inline int kvm_arch_flush_remote_
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
-void kvm_mmu_x86_module_init(void);
+void __init kvm_mmu_x86_module_init(void);
 int kvm_mmu_vendor_module_init(void);
 void kvm_mmu_vendor_module_exit(void);
 
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6264,7 +6264,7 @@ static int set_nx_huge_pages(const char
  * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
  * its default value of -1 is technically undefined behavior for a boolean.
  */
-void kvm_mmu_x86_module_init(void)
+void __init kvm_mmu_x86_module_init(void)
 {
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());


