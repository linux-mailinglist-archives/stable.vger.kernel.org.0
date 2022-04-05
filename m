Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63D14F3934
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377714AbiDELaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352798AbiDEKFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F88BC87C;
        Tue,  5 Apr 2022 02:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBA12616DC;
        Tue,  5 Apr 2022 09:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3542C385A3;
        Tue,  5 Apr 2022 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152431;
        bh=hrfyozcs/WLlhiA2+tZKYGqLQASHhpJD8gwcdsqB+ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqV3XAvOsAeJtooPtO49nSLP/EMow/S3Iibtg5ClfnSrSuyKJjCQdw9MfLPkM/gc8
         Im4JLCCw//TNi5aqRDse4PPRFU3UhS6Jwz/3b9uqenNVpy3fb6Tmsl7vNBpKBhreki
         hPUPVpAf1/FNzFOpCoDR6yEuEWO1YOQJIb8KNMB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 773/913] KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU
Date:   Tue,  5 Apr 2022 09:30:35 +0200
Message-Id: <20220405070403.002794639@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 3354ef5a592d219364cf442c2f784ce7ad7629fd upstream.

Explicitly check for present SPTEs when clearing dirty bits in the TDP
MMU.  This isn't strictly required for correctness, as setting the dirty
bit in a defunct SPTE will not change the SPTE from !PRESENT to PRESENT.
However, the guarded MMU_WARN_ON() in spte_ad_need_write_protect() would
complain if anyone actually turned on KVM's MMU debugging.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-3-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1316,6 +1316,9 @@ retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
 		if (spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
 				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;


