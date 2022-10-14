Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103FA5FEF1C
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJNNx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJNNxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604CC1D0D40;
        Fri, 14 Oct 2022 06:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7ADA61B48;
        Fri, 14 Oct 2022 13:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA3C4347C;
        Fri, 14 Oct 2022 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755550;
        bh=HsDrC9F/fHxc03GfWdKOZly3wd0F/Y4NmNsP1reemDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3++PJn5JklfLUfAcOunPjaVrqaO7vuJIYtDQ3xN7hDHaOmPZ+Epgfyb7dafR+5iJ
         dhrkWxdO2GtgDgoGRK5kR2TnDERqcLVL51gbe9hYwpi0lvWsTQ+7CjDApB7a8PiEw4
         ojLmko7j4GKFteufTsFD0/wV29mh93mvDQZ3GMcxt4o7xSkyu4ihtGBE6CBdsmh8b1
         tLaFd5mVWSffNTflQ+jzoK90Iikji5Ynv3Zv9m7zP6EAtMLD/WgvJjGqN/ikouwaXH
         tuy9Zu8Fl/hB7eMyAf1oAihOZ17cRowTZOy5G17K5E6IIttete9JRx2ajZYMYfcQG1
         WIdNKax2WmxWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 03/10] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init() fails
Date:   Fri, 14 Oct 2022 09:52:14 -0400
Message-Id: <20221014135222.2109334-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135222.2109334-1-sashal@kernel.org>
References: <20221014135222.2109334-1-sashal@kernel.org>
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
index 8c2815151864..8d2211b22ff3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11842,6 +11842,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_page_track;
 
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto out_uninit_mmu;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
@@ -11877,8 +11881,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

