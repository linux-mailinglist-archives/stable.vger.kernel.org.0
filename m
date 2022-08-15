Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24F459439D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345774AbiHOVzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349876AbiHOVxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:53:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546F210897A;
        Mon, 15 Aug 2022 12:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CCADB80EA9;
        Mon, 15 Aug 2022 19:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964A3C433C1;
        Mon, 15 Aug 2022 19:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592005;
        bh=Lcd+clCc/BnKPGVAH83s4Z6VpJoQoVhfK0PtjoaGWaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ed7XCcAnGSHsEmli75eRtOFCGS9DWC2WaaoD7v+bXXr877U4SjiQw5+X8JQiuLWDM
         E8FygzZoG/YGZlFZU91t5AVSK0IfQDJRk+RnZe+kd5LFgZQHn+1KtF6iS8/JQ5AjMe
         J6wZxlJYSz4x2+XHpZBp2k1SBojxLDIi0Y8euzpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Young <ruyang@redhat.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH 5.19 0043/1157] KVM: x86: revalidate steal time cache if MSR value changes
Date:   Mon, 15 Aug 2022 19:49:59 +0200
Message-Id: <20220815180441.162057610@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 901d3765fa804ce42812f1d5b1f3de2dfbb26723 upstream.

Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
/ preempted status", 2021-11-11) open coded the previous call to
kvm_map_gfn, but in doing so it dropped the comparison between the cached
guest physical address and the one in the MSR.  This cause an incorrect
cache hit if the guest modifies the steal time address while the memslots
remain the same.  This can happen with kexec, in which case the steal
time data is written at the address used by the old kernel instead of
the old one.

While at it, rename the variable from gfn to gpa since it is a plain
physical address and not a right-shifted one.

Reported-by: Dave Young <ruyang@redhat.com>
Reported-by: Xiaoying Yan  <yiyan@redhat.com>
Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3386,6 +3386,7 @@ static void record_steal_time(struct kvm
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
+	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 	u64 steal;
 	u32 version;
 
@@ -3403,13 +3404,12 @@ static void record_steal_time(struct kvm
 	slots = kvm_memslots(vcpu->kvm);
 
 	if (unlikely(slots->generation != ghc->generation ||
+		     gpa != ghc->gpa ||
 		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
-		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-
 		/* We rely on the fact that it fits in a single page. */
 		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
 		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
 			return;
 	}


