Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5577499E5D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452747AbiAXWcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584676AbiAXWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D89C041881;
        Mon, 24 Jan 2022 12:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564CB611C2;
        Mon, 24 Jan 2022 20:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CECAC340E5;
        Mon, 24 Jan 2022 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057568;
        bh=PV3zTcZoEZBIfBNhE05GCrsJQVwhbmMUXbm4kUtn8zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG/h7ez1OU3vlzJLnvHfQH70PrRtUmnD0jHOiULPorwOcKbVXdfkssgvAdLj4GW1Y
         DQyZ19Ka8etfAj9Wo+mhLlmMZ4c+ebzZDgj/VPR3Me5iR96zfTiW4ZgrNJE4MNbAip
         p31Whvr18iKC7cMVw3gFAB0l915hbRVf1P38e2UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 0001/1039] KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
Date:   Mon, 24 Jan 2022 19:29:50 +0100
Message-Id: <20220124184125.179384891@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -1442,12 +1442,12 @@ static bool write_protect_gfn(struct kvm
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


