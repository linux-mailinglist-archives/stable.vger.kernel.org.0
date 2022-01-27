Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3EF49E9F0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245176AbiA0SLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245165AbiA0SKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C223FC0613EB;
        Thu, 27 Jan 2022 10:10:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6267061BBE;
        Thu, 27 Jan 2022 18:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B6DC340E4;
        Thu, 27 Jan 2022 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307028;
        bh=opqOAvOwYYBDuTBW3kimmwB19Q6IwQ1e3r2Ikzu3mcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIWDvMHteOnqvyG9e7GRP/+akG35mHTkGKioNQZO40Uzal0kqWUmbIuGalj6uCHAw
         hKMmkKBNK1co85P0NupoP+PqzltJ7zWvLUTgh7odmiqKv8JkYdgKI0hmA1zBzXNMoI
         HIuBbHaTribUOUPhe2NNIk+hCgm9r3ptyaTwwkFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 5/6] KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
Date:   Thu, 27 Jan 2022 19:09:21 +0100
Message-Id: <20220127180258.306175303@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
References: <20220127180258.131170405@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

commit 7c8a4742c4abe205ec9daf416c9d42fd6b406e8e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1130,12 +1130,12 @@ static bool write_protect_gfn(struct kvm
 	bool spte_set = false;
 
 	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
-		if (!is_writable_pte(iter.old_spte))
-			break;
-
 		new_spte = iter.old_spte &
 			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 
+		if (new_spte == iter.old_spte)
+			break;
+
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
 	}


