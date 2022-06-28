Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1971255EBD8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiF1SDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiF1SCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:02:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797D513CC2;
        Tue, 28 Jun 2022 11:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 420C3B81F55;
        Tue, 28 Jun 2022 18:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8101CC341C8;
        Tue, 28 Jun 2022 18:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656439347;
        bh=jrzryAyM0iHSiSlBurldiYfX3CAAw6Hd79gKtg2cGBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDirxLIW5TXMFJlHxn2Dm+t/IrGdaHqchEb9dm7AxQU1DqMYAanrb772v/az8EN8Q
         6QmGnzotOzqP7KNidW2qOOH0Pzt2kx6h0c4TOD/9YzMQZAI28djn1oapr+iK3oS75T
         N61qwihh6aapbbRJwliLJF5W4QX4ePye0h4TDjhePiltcoHgYpQqhkaF63OEvcC/Fp
         OvK2mH6wzh+Qnm1UuEvcP7nvCe68d7CFPHCdjUGJM4SHcaRNc7sf8mOkjHZ4wYSLMc
         s9LsHqz7BFSZOJDJBfseyxW7Y0UB0B4eLnVr1V4VIkg4ybDoGLYoD6Xn60EV+CkUS/
         P687kPeS17Kgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.18 3/3] KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()
Date:   Tue, 28 Jun 2022 14:02:17 -0400
Message-Id: <20220628180220.621172-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628180220.621172-1-sashal@kernel.org>
References: <20220628180220.621172-1-sashal@kernel.org>
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
index 4b7d490c0b63..f20f8295fa09 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -844,7 +844,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 
 	/* If source buffer is not aligned then use an intermediate buffer */
 	if (!IS_ALIGNED((unsigned long)vaddr, 16)) {
-		src_tpage = alloc_page(GFP_KERNEL);
+		src_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!src_tpage)
 			return -ENOMEM;
 
@@ -865,7 +865,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED((unsigned long)dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
 		int dst_offset;
 
-		dst_tpage = alloc_page(GFP_KERNEL);
+		dst_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!dst_tpage) {
 			ret = -ENOMEM;
 			goto e_free;
-- 
2.35.1

