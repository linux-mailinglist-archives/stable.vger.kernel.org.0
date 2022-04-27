Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E49F51208D
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbiD0P7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240605AbiD0P6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:58:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0283D78385;
        Wed, 27 Apr 2022 08:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5F4361B49;
        Wed, 27 Apr 2022 15:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FD7C385AC;
        Wed, 27 Apr 2022 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074874;
        bh=sl9Pb4DXc7gRUL5a3faT/UaiHOw0prFpxyvgZ2bEQhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8yrB8l76l6jqX8Q2FBLgokqrXF26yrz3ERh5gkmRxdGypegGx1CfaLo1ud471PiB
         wynu17fheQ6JsYU9SfwojBquMC67PmckhMi5ILjixZGNR66VvjDQ+dDi1A4aRn+f7c
         l0ycK9n2FsA/dQa1vGm5zQAy68Srt8wUel3KrTuG64lT2LnK+iHiBvUNXdediLwhKO
         NnvZ8OYJpnWZYRnbu0f82yxK+hBUSy0ZGiZdxMimhpLGUr2H5uugT41hkaQeBzDPAq
         pQ2GNQDFz3pZyDGk+OPnbaHIvPTUTg1tWKnG8jiovWi7/3FjRl3j4owitpMgPJWEel
         30ogcDuF1zmcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 6/7] KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs
Date:   Wed, 27 Apr 2022 11:54:26 -0400
Message-Id: <20220427155431.19458-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155431.19458-1-sashal@kernel.org>
References: <20220427155431.19458-1-sashal@kernel.org>
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
index 34e828badc51..806f9d42bcce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3314,6 +3314,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	if (WARN_ON(!sp))
+		return;
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
-- 
2.35.1

