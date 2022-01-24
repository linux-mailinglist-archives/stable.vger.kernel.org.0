Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D867498865
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiAXSdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXSdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:33:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F084C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:33:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s13-20020a17090a5d0d00b001b4f4299cf9so11184443pji.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Jnwu+woDxcibOo/+wn55NaxxHfm1r1qBmOUjR9zyXTY=;
        b=g/oj857SheeQ1doPp7kxZCMBJk8ewEKfui2UNrGtfj7aC1Ck0wwwQfc43vo97bSY8T
         fuglPZgULJjJhPMLndYcxcMSaqByWsHHhpJw0PLtYfjI2II/RtShSaNl96Nv6OhoTlLF
         8Zeydmcq3sb4VfLZgSIya95IzbYTPDIq9070rbqX7MrediEjQVZ3xcoECOfT9I7Xg89A
         iPQCrTCfGseSf/iE8WrrlfkhGO19ZUTtA83OrPOSN3aVQSkWqtLdaIZR1S0HyFBjYQhB
         +0FLltADWp32hVFIoe2WJx3AmXSOTbVhVMwS8H4bOW7tveDjjpioh/yWzXWraUzwzZJa
         ZheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Jnwu+woDxcibOo/+wn55NaxxHfm1r1qBmOUjR9zyXTY=;
        b=j/2A/8bFBwsY3vHK26niN8ld4FmVap2WP7QAkrvMGk+XQ0mZmbgurRvq9T+ecUxTE0
         /sz+eN31j9GRs13/sYQaSQIJ3cNoh5AgFPH/m5PqZkoBCTOMaxtN66B+shm1jts9VB8m
         37WeaV6n09klcay77efDfyVsHSxclMNN3ucFKmAwFFG4jnDYJ6qsx5KkDRnSBHhEcuAU
         ImzgTeEwY0mNPSfQ8Z6a3Q1mJHYUyWEvjaMNS4AQ/9xDzQK5q0KoJl6xT1SiTwZHzxsJ
         MC4uzgsOCURFrEVilvRwQo4AQakNzPs0WvBx/qibIw3dlwCULZ8RreebieBE1o80FkFl
         ePxA==
X-Gm-Message-State: AOAM5303Y654vR0yFED6vFN4i6ayV3fh/9vDWmSUUOO2onxG7o5Tjwje
        WkpKpGgSaMm3am5V42y9+wC8xVPWSL4JR5IQ/fxwT/Iyx3xkmryg+HbHXQUUhcPYML4rdKBX7Qt
        SKGiVD2QXaUntpWbv3XjUhWKX6w+A0S8U11iFlxERa353qj/KuI29e9e3CHscHLyOaZ0=
X-Google-Smtp-Source: ABdhPJwJgN3fFXTM50dJcwLziTJGr1fDNn/VaCah7SFjzJROQ894PtJwSTglOYYJDGSMQnQCsaxp4lWdF55VRA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:9a0a:b0:149:7da0:af27 with SMTP
 id v10-20020a1709029a0a00b001497da0af27mr15309287plp.49.1643049185330; Mon,
 24 Jan 2022 10:33:05 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:33:02 +0000
Message-Id: <20220124183302.263017-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 5.10] KVM: x86/mmu: Fix write-protection of PTs mapped by the
 TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, pbonzini@redhat.com, seanjc@google.com,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f2ddf663e72e..7e08efb06839 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1130,12 +1130,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
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

base-commit: fd187a4925578f8743d4f266c821c7544d3cddae
-- 
2.35.0.rc0.227.g00780c9af4-goog

