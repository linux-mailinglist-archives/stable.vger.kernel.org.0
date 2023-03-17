Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C8E6BF399
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 22:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCQVLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 17:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCQVLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 17:11:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C673733CE3
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 14:11:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 4-20020a250204000000b00b63937e3c7fso3449947ybc.20
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 14:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679087482;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WQhD8cecG2lw7f4ASBIhYK1IsLLuRaNhUnK57Izlu3U=;
        b=jBtf/Lll6PR9MHdfL1x0pC39HEwrPWpmRrFzvqVF7UlMMd8i4/hP1y0+L6fF3THf3P
         wEaKAXmK1cs62qjKoNYfxxab7hni9OYTk8gkip+iurgAgqY3NyHrrBvvcaT7dydF5gWy
         ie+sFGneLF6nLeiRHZ+uFkhtk75zn0Y6NYk5twxcfsURDUqkZ21r29I3ZTeQUf8PIBjU
         crB8+SzXpx0rNLmOqMBhtICD/fLgqeh15WYGeYr9psNhS7slXyvzK/QLjNP4uQQkNPjq
         8j4TzZoDocPQlLCddT9N39T0Z9lXUnBU5NvlzjphFq8V+ZFO6JaLOzcO+SubFV7h54gQ
         BPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679087482;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WQhD8cecG2lw7f4ASBIhYK1IsLLuRaNhUnK57Izlu3U=;
        b=LXECK2AEqDOh2biVDUTZtyQ6JEu3GUD3jR28JdfX4d97y2kJ0OyxV4Yjd5HEtf2s2W
         56Z8mYONNV/i8S2U77eqADU0S538UxTlX5L3PWkbJeZ2n9eAHU/MMnJvbJPodrZnKEdI
         0GBR3kJFSst72KNT9R9tDsPHSWI29cE+/H7QIvQpbYoiWF55ptMxRY2VTLK4ADBkSm4f
         58P6LejN5kv/yDhJ/Aj86vL9f19pXydf1CpqtRYuuOJ+zFB64XFLOrvBiS6CkUuXhqdW
         VCnmd67e/c2qXxPVXBejDGQbRMEyp/Abbkc0OjQQLTGJMIKEiHI41oibdaG8zK0ZAzPv
         17wg==
X-Gm-Message-State: AO0yUKVIUD6MSz3PR4YC3yu8DI69EfrDPLUs3ML2RIbzYWs0derqBVJy
        0bK9e78SEvLcZdA7YEaAd11OTrw8JFpOFw==
X-Google-Smtp-Source: AK7set+SNiTmP2J+IL8lUhNwhFNEIbJIkL/PTyLj01bi/FQZoOtY+P7EHKBhm7n4KUmvvVxo+kVpWzxe0kT5Pg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:120b:b0:b51:2cba:b971 with SMTP
 id s11-20020a056902120b00b00b512cbab971mr567372ybu.10.1679087482088; Fri, 17
 Mar 2023 14:11:22 -0700 (PDT)
Date:   Fri, 17 Mar 2023 14:11:06 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317211106.1234484-1-dmatlack@google.com>
Subject: [PATCH] KVM: RISC-V: Retry fault if vma_lookup() results become invalid
From:   David Matlack <dmatlack@google.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
detect if the results of vma_lookup() (e.g. vma_shift) become stale
before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
VMA could be changed by userspace after vma_lookup() and before KVM
reads the mmu_invalidate_seq, causing KVM to install page table entries
based on a (possibly) no-longer-valid vma_shift.

Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
inducing spurious fault retries).

It's unlikely that any sane userspace currently modifies VMAs in such a
way as to trigger this race. And even with directed testing I was unable
to reproduce it. But a sufficiently motivated host userspace might be
able to exploit this race.

Note KVM/ARM had the same bug and was fixed in a separate, near
identical patch (see Link).

Link: https://lore.kernel.org/kvm/20230313235454.2964067-1-dmatlack@google.com/
Fixes: 9955371cc014 ("RISC-V: KVM: Implement MMU notifiers")
Cc: stable@vger.kernel.org
Signed-off-by: David Matlack <dmatlack@google.com>
---
Note: Compile-tested only.

 arch/riscv/kvm/mmu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 78211aed36fa..46d692995830 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -628,6 +628,13 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
 	unsigned long vma_pagesize, mmu_seq;
 
+	/* We need minimum second+third level pages */
+	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
+	if (ret) {
+		kvm_err("Failed to topup G-stage cache\n");
+		return ret;
+	}
+
 	mmap_read_lock(current->mm);
 
 	vma = vma_lookup(current->mm, hva);
@@ -648,6 +655,15 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 
+	/*
+	 * Read mmu_invalidate_seq so that KVM can detect if the results of
+	 * vma_lookup() or gfn_to_pfn_prot() become stale priort to acquiring
+	 * kvm->mmu_lock.
+	 *
+	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
+	 * with the smp_wmb() in kvm_mmu_invalidate_end().
+	 */
+	mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
 	if (vma_pagesize != PUD_SIZE &&
@@ -657,15 +673,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	/* We need minimum second+third level pages */
-	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
-	if (ret) {
-		kvm_err("Failed to topup G-stage cache\n");
-		return ret;
-	}
-
-	mmu_seq = kvm->mmu_invalidate_seq;
-
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,

base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.40.0.rc2.332.ga46443480c-goog

