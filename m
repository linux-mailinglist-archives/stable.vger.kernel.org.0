Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C823456FCB2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiGKJrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiGKJpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:45:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC305A465;
        Mon, 11 Jul 2022 02:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C87B80E6D;
        Mon, 11 Jul 2022 09:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081A6C34115;
        Mon, 11 Jul 2022 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531363;
        bh=8uvwMb3IGS1bUx9nzsZ+AkD+tb8VskWdxw5l4vTVUAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imq7p3Ez4lSzNn8NqcyyC6UKXCR+1tShUXUrUxNNgJtLuNPf43Fph3yxbakXYe25W
         B3oAyEhwEsV+mybFT89dnrF1g4kgJjjY5iD/pjCDDt7TS5oU5fBd0g+W7ffEpAqWsa
         Fkbx0rBKhF/L9IqU+0vzUaVuzt7Cze5Ysb4rkdx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/230] KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier unmapping
Date:   Mon, 11 Jul 2022 11:05:33 +0200
Message-Id: <20220711090606.260747828@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 7533377215b6ee432c06c5855f6be5d66e694e46 ]

Use the yield-safe variant of the TDP MMU iterator when handling an
unmapping event from the MMU notifier, as most occurences of the event
allow yielding.

Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120015008.3780032-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 853780eb033b..6195f0d219ae 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1100,7 +1100,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush = zap_gfn_range(kvm, root, range->start, range->end,
 				      range->may_block, flush, false);
 
-- 
2.35.1



