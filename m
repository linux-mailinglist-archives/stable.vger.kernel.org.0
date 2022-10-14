Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA85FEEF8
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJNNvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiJNNvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131DA1BF86F;
        Fri, 14 Oct 2022 06:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B2D561B16;
        Fri, 14 Oct 2022 13:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E469BC433C1;
        Fri, 14 Oct 2022 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755507;
        bh=qdSYfyAPhXkohJ1ehRKmHK8DO1eUirwKvza2n4S6E50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw1KgzJiPDbt7Kz0tmj/1CDfaCcjLUicrslTHDLiWgSc8aDDqYFfvJk4Fs8+BS76t
         SJr3wssu/jK9G+mcbjyXq4T0szXK/AO7a/Nede5/6p7JAEn0ChQ62c6izs6ya447o7
         zLoHgJ+vY75Gxhx021UrST6s7wdA6OcrfM7nd1ZGeGF16dJf748aK91Z5AL0fXhSxY
         THpfwb2VhL8aPaEIkTuuap1sYvn/L2q8+Quw4q+/aPO89UTVqbnVCH6IOlzJh8d4pP
         HAQALI02MCgyQ6r44H9XSW+53wC+tQszN8Bsb2XF1QKwkDn69QJiKVqdsAYmJxom3P
         eqp0EyVYy6UpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 03/11] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails
Date:   Fri, 14 Oct 2022 09:51:29 -0400
Message-Id: <20221014135139.2109024-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135139.2109024-1-sashal@kernel.org>
References: <20221014135139.2109024-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

[ Upstream commit b24ede22538b4d984cbe20532bbcb303692e7f52 ]

If vm_init() fails [which can happen, for instance, if a memory
allocation fails during avic_vm_init()], we need to cleanup some
state in order to avoid resource leaks.

Signed-off-by: Junaid Shahid <junaids@google.com>
Link: https://lore.kernel.org/r/20220729224329.323378-1-junaids@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0c47b41c264..11fbd42100be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12080,6 +12080,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_page_track;
 
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto out_uninit_mmu;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
@@ -12115,8 +12119,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
-	return static_call(kvm_x86_vm_init)(kvm);
+	return 0;
 
+out_uninit_mmu:
+	kvm_mmu_uninit_vm(kvm);
 out_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
-- 
2.35.1

