Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A907755EBB2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiF1SDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiF1SCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:02:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439C412AF1;
        Tue, 28 Jun 2022 11:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1255B81F54;
        Tue, 28 Jun 2022 18:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEA3C341CD;
        Tue, 28 Jun 2022 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656439356;
        bh=GR876I8rEMy3+cSMMcgWtmkjJqJdaRQUGxBaXCHKijw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5E3xqsNFLFa9RA+FXXfRpu1eLUqtZ6L9oZTVNu/oiUCYqUWXOrK1x3VQRZfMlJQk
         NOZZXZ8V5f6tSFfG+n9oeXfiLBwWHNVXX6AXuCa/KhFqHwtka0b0m+qYdAXNagGRcJ
         Uzvkfx2nhx4RzxBZgapxyA1g4UdHrgGADFQstyRmDHXKSca9X6xrSz5eqHeh+U61R6
         2kJbYomgdmj1vV2oyrLkhwb7ABP6hOgEG8vmx6O7mmFCaOlY5sexgPZZJDq/2q/F1p
         mmQSibOUgtvBFo3/S+7uEsKP/0HGWHZ53FZwSiOYzkmnlh9Ue5ekjK3RkpqfL4IYBO
         7g0ogU7bqFOHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 3/3] KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()
Date:   Tue, 28 Jun 2022 14:02:28 -0400
Message-Id: <20220628180230.621228-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628180230.621228-1-sashal@kernel.org>
References: <20220628180230.621228-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

[ Upstream commit ebdec859faa8cfbfef9f6c1f83d79dd6c8f4ab8c ]

Adding the accounting flag when allocating pages within the SEV function,
since these memory pages should belong to individual VM.

No functional change intended.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20220623171858.2083637-1-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4a4dc105552e..86f3096f042f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -832,7 +832,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 
 	/* If source buffer is not aligned then use an intermediate buffer */
 	if (!IS_ALIGNED((unsigned long)vaddr, 16)) {
-		src_tpage = alloc_page(GFP_KERNEL);
+		src_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!src_tpage)
 			return -ENOMEM;
 
@@ -853,7 +853,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED((unsigned long)dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
 		int dst_offset;
 
-		dst_tpage = alloc_page(GFP_KERNEL);
+		dst_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!dst_tpage) {
 			ret = -ENOMEM;
 			goto e_free;
-- 
2.35.1

