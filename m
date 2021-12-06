Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2871469F06
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391244AbhLFPpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389700AbhLFPkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172CDC08E6E2;
        Mon,  6 Dec 2021 07:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B33F7B81120;
        Mon,  6 Dec 2021 15:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2769C34900;
        Mon,  6 Dec 2021 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804319;
        bh=CZe+X0xSg6Hf7EMCjg06vea0wqDoXF8CPpJtnhxWFQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luscd2rSqOq6SwGX93MK3S+l9mHLr4WT+3+omi+BRnhuPXXvDsrwf3lol5XJYdoUi
         PODDGhQNn7+DafxTgnGMAQNPSGRrEmvoBZK+1G1TkTXR1p8P0O2Kfu2IZnjMA61Yl4
         M6QaU79llyCQW2G6UvRZQ4bl2nzf0tCVUjN3koM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 072/207] KVM: x86/mmu: Fix TLB flush range when handling disconnected pt
Date:   Mon,  6 Dec 2021 15:55:26 +0100
Message-Id: <20211206145612.726135896@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

commit 574c3c55e969096cea770eda3375ff35ccf91702 upstream.

When recursively clearing out disconnected pts, the range based TLB
flush in handle_removed_tdp_mmu_page uses the wrong starting GFN,
resulting in the flush mostly missing the affected range. Fix this by
using base_gfn for the flush.

In response to feedback from David Matlack on the RFC version of this
patch, also move a few definitions into the for loop in the function to
prevent unintended references to them in the future.

Fixes: a066e61f13cf ("KVM: x86/mmu: Factor out handling of removed page tables")
CC: stable@vger.kernel.org
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20211115211704.2621644-1-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -316,9 +316,6 @@ static void handle_removed_tdp_mmu_page(
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
 	gfn_t base_gfn = sp->gfn;
-	u64 old_child_spte;
-	u64 *sptep;
-	gfn_t gfn;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
@@ -326,8 +323,9 @@ static void handle_removed_tdp_mmu_page(
 	tdp_mmu_unlink_page(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		sptep = rcu_dereference(pt) + i;
-		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
+		u64 *sptep = rcu_dereference(pt) + i;
+		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
+		u64 old_child_spte;
 
 		if (shared) {
 			/*
@@ -373,7 +371,7 @@ static void handle_removed_tdp_mmu_page(
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, gfn,
+	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
 					   KVM_PAGES_PER_HPAGE(level + 1));
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);


