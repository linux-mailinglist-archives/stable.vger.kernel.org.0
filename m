Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C306C5218D0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiEJNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245159AbiEJNif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE75A25A79D;
        Tue, 10 May 2022 06:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC8E6175F;
        Tue, 10 May 2022 13:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59331C385A6;
        Tue, 10 May 2022 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189257;
        bh=QtB4FLTGl2FYMU5SExiHr2416mWxcRNtxJ+kWgPShxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWzTqvOlBSIy6Mp+UWNT1sE1eupUYViMRbDVZKHAbHj5+IdzHyJVnb4LM8n+avqtz
         AE0zctqABM6OQmua5yEwPGi1LSzZZs4N+dklhqZB2KSErzYGzgtowHOzw5icgLibSt
         BOADeVcmKXz8NoMhxol4mrSWnYpaeiCQFVetOvjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/70] KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs
Date:   Tue, 10 May 2022 15:08:21 +0200
Message-Id: <20220510130734.682827151@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 9191b8f0745e63edf519e4a54a4aaae1d3d46fbd ]

WARN and bail if KVM attempts to free a root that isn't backed by a shadow
page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
will be valid but won't be backed by a shadow page.  It's all too easy to
blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
crashing KVM and possibly the kernel.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99ea1ec12ffe..70ef5b542681 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3140,6 +3140,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	if (WARN_ON(!sp))
+		return;
 
 	if (kvm_mmu_put_root(kvm, sp)) {
 		if (sp->tdp_mmu_page)
-- 
2.35.1



