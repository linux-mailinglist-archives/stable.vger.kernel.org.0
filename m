Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B37511E68
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiD0P5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiD0P5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:57:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4D8737BD;
        Wed, 27 Apr 2022 08:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDAC8B82881;
        Wed, 27 Apr 2022 15:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC5BC385AC;
        Wed, 27 Apr 2022 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074861;
        bh=cCZFMNJ7sc4kval9MNFBp8yBF+FZbUz3Tw4iKsgYzLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1ouTdQnremIxFpmyaboRGSRLQKNR1RgfsOhNKdsB4uAdq/5TL+n8+g/i1d5Ci1WP
         H2ajL4W1Wt/tqhIBfy9S5qhDXuWGndnHVGeynn04I4TSVdw2CmkcAI9++va1RC+H7g
         bOiBryLq+l6MqSvqcSBpYFcUO0lcdfRNmkQmEYhP6oph/OMxMD/Tuj1ixPmnLxst6B
         0HWDi8r1JxY8HfbDDXo8hN3zr7tVfY66tSpaVU44WNs3/V6zvKeghoc9e4YYeYLPXL
         bE+e1MOwMg2e1dejpaZiF/yiShfnUak+tPUmNs6sNAY5zWgbROdIFdu9fTfwMH78a6
         0FHKlbAa7+nwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 5/7] KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs
Date:   Wed, 27 Apr 2022 11:54:01 -0400
Message-Id: <20220427155408.19352-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
References: <20220427155408.19352-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 7f009ebb319a..e7cd16e1e0a0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3239,6 +3239,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	if (WARN_ON(!sp))
+		return;
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
-- 
2.35.1

