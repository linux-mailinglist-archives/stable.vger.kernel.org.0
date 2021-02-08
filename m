Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4243137E2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhBHPcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233845AbhBHP2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815C464F24;
        Mon,  8 Feb 2021 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797380;
        bh=B3P5vINbAH+EgV1UE2nZenvUeBS/tjObfCMxGbhtdHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccXBFz6nJhUy85E59id7eRzY2x9WxUR5ojgPUQDdamA52qYHyWkSKHJ8+Erlm1m7k
         HBoz7+J4hXl/s8XHM2+Rr6nNL5hOc7rUcov7wu08G9rA+WL9gImjnq7SrSSww7MnV+
         qZxrwcnu/4R9uNVC7qZzKFLkgcsbZ8EILkUIE7xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 089/120] KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs
Date:   Mon,  8 Feb 2021 16:01:16 +0100
Message-Id: <20210208145821.941981549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

commit 87aa9ec939ec7277b730786e19c161c9194cc8ca upstream.

There is a bug in the TDP MMU function to zap SPTEs which could be
replaced with a larger mapping which prevents the function from doing
anything. Fix this by correctly zapping the last level SPTEs.

Cc: stable@vger.kernel.org
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-11-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1037,8 +1037,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct k
 }
 
 /*
- * Clear non-leaf entries (and free associated page tables) which could
- * be replaced by large mappings, for GFNs within the slot.
+ * Clear leaf entries which could be replaced by large mappings, for
+ * GFNs within the slot.
  */
 static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
@@ -1050,7 +1050,7 @@ static void zap_collapsible_spte_range(s
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
-		    is_last_spte(iter.old_spte, iter.level))
+		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
 		pfn = spte_to_pfn(iter.old_spte);


