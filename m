Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7CE4971AA
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 14:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbiAWNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 08:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbiAWNgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 08:36:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ADBC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 05:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC63B80ACC
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 13:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87398C340E2;
        Sun, 23 Jan 2022 13:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642944979;
        bh=xWjEAPdhts+sIkr0MyDRsYBRwefgQlVA/KASBFERFfM=;
        h=Subject:To:Cc:From:Date:From;
        b=QxqZReHMWlBh0ttt2T6lgv9S6D3XMCdeucGGlSAb1aLYPP5yLyHCVwXUsH3MJLUzY
         fecUvmt6yASX+MdF8SjfHQmQa1+GYgl8C7qeCyneczDdZmGq/fnGrOS5aGSI+FNHYx
         3ReEduJC92C2Hwt8PyVIugxm2eXS7UkG9iQBWtoY=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP" failed to apply to 5.10-stable tree
To:     dmatlack@google.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 14:36:16 +0100
Message-ID: <1642944976217120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c8a4742c4abe205ec9daf416c9d42fd6b406e8e Mon Sep 17 00:00:00 2001
From: David Matlack <dmatlack@google.com>
Date: Thu, 13 Jan 2022 23:30:17 +0000
Subject: [PATCH] KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP
 MMU

When the TDP MMU is write-protection GFNs for page table protection (as
opposed to for dirty logging, or due to the HVA not being writable), it
checks if the SPTE is already write-protected and if so skips modifying
the SPTE and the TLB flush.

This behavior is incorrect because it fails to check if the SPTE
is write-protected for page table protection, i.e. fails to check
that MMU-writable is '0'.  If the SPTE was write-protected for dirty
logging but not page table protection, the SPTE could locklessly be made
writable, and vCPUs could still be running with writable mappings cached
in their TLB.

Fix this by only skipping setting the SPTE if the SPTE is already
write-protected *and* MMU-writable is already clear.  Technically,
checking only MMU-writable would suffice; a SPTE cannot be writable
without MMU-writable being set.  But check both to be paranoid and
because it arguably yields more readable code.

Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
Cc: stable@vger.kernel.org
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220113233020.3986005-2-dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b1bc816b7c3..bc9e3553fba2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1442,12 +1442,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		if (!is_writable_pte(iter.old_spte))
-			break;
-
 		new_spte = iter.old_spte &
 			~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
 
+		if (new_spte == iter.old_spte)
+			break;
+
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
 	}

