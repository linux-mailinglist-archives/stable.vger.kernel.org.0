Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219B548E0E3
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 00:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiAMXa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 18:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiAMXa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 18:30:26 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB88C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:30:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w195-20020a6282cc000000b004bdce57da98so670654pfd.5
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8Xf/e2mla+a2kQPDivDH7OGq00ewbcGCMFDMPzdpwvE=;
        b=IdvTdJ//RODLIZYbXCAcblDVDPO3Qrho5vqIdrnRfdxEhkSqgPN+fMau0HFBAy49gk
         Bs4Yngkk0ivwQ7BgEHMHEl1VOVBQGJorB5K00PGmeXVZNh6cQ2ipzXeS1grRMSGFncyu
         KhmJN5zNkYe42jy68MUxT9XI6uh2+FWRO4TkyU2g0XS791szPZv8TCFdahx7DpvZAdog
         5truukzvpsmiUlR9N6AIGtoPiGHBCxA8ezKDWHBbNvTpWANhmkzAn28KRp/opSVeXE9g
         cUGogyN077teOVBnK5p06NRrOLBA6zz0Cf7BIwo2wdlp+J0iCwhNkCS+ZylZSmi8DpIk
         y/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8Xf/e2mla+a2kQPDivDH7OGq00ewbcGCMFDMPzdpwvE=;
        b=opKl9UgC2Z9rghBYM63IbQS4ELOI0a4mCgz2zrX/0h2yj+vdkuXeK4gQfjZpmguf2A
         StTntHZSCUMcwKdVtyKug24o4bEfBjOmlTbMcS46/0pfsUQWT+3p5tuxXi55GQcUT6YB
         3w47O+pJwx+hL3hSOLokI49MRCx2BxC9KRh9ljdK7xG8MraFcws9+jRP6kQlJOT0ayCg
         JlW5AODFLrARMuiD6n2OloUWSQ4CIbqjpAwznqdCXwsUgBrMTngQ//Ul92kLPodRij1A
         7yOLzONuTQRzWvZ8OQ44RwxmBdZkG8crltkFRjUG7NfDDOSCrBJ4Rb/LrKe1henszpS1
         lXtw==
X-Gm-Message-State: AOAM532Lbrh4AUkva6GB3c7yd3eAiImHkI+SqWmBCAZglGWHHroM8Dns
        CibWr0dcuUnMI/2fNFpD0++SpEV45uOKmw==
X-Google-Smtp-Source: ABdhPJzZN7Dkcmwgib6lrraxadhYhDPs7lxuG3B6gpkIj2hheVI1CS7IDjBgKzZz6GD2xb8Q9IsjsLAZhY6BEw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:af07:: with SMTP id
 w7mr5876042pge.209.1642116626187; Thu, 13 Jan 2022 15:30:26 -0800 (PST)
Date:   Thu, 13 Jan 2022 23:30:17 +0000
In-Reply-To: <20220113233020.3986005-1-dmatlack@google.com>
Message-Id: <20220113233020.3986005-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 1/4] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the TDP MMU is write-protection GFNs for page table protection (as
opposed to for dirty logging, or due to the HVA not being writable), it
checks if the SPTE is already write-protected and if so skips modifying
the SPTE and the TLB flush.

This behavior is incorrect because the SPTE may be write-protected for
dirty logging. This implies that the SPTE could be locklessly be made
writable on the next write access, and that vCPUs could still be running
with writable SPTEs cached in their TLB.

Fix this by only skipping setting the SPTE if the SPTE is already
write-protected *and* MMU-writable is already clear.

Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
Cc: stable@vger.kernel.org
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

