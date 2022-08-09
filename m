Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C058DE85
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345319AbiHISTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbiHISQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:16:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EDD2CCB8;
        Tue,  9 Aug 2022 11:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F207B817B7;
        Tue,  9 Aug 2022 18:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB92BC433D6;
        Tue,  9 Aug 2022 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068342;
        bh=GR876I8rEMy3+cSMMcgWtmkjJqJdaRQUGxBaXCHKijw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVrRdVwMp7JoEEhKjygRzfFFTWBAswGOOqy4U+U6MfRKTuBKf3DrNvOJbTXIVncyN
         mOya6fDmnMhwd51E8AqbbjrZv6dqu1ajWyLIKWx5AhRIHkmK0dskYBPdsolWcLL+Bj
         4Nt8El5RWCTWxSTBawYTeQTG46dggK2IdvjS0m2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/30] KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()
Date:   Tue,  9 Aug 2022 20:00:40 +0200
Message-Id: <20220809175514.852844143@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



