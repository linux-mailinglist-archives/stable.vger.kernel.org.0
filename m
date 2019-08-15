Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B07A8E5B3
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 09:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfHOHqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 03:46:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54116 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHOHqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 03:46:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id 10so519239wmp.3;
        Thu, 15 Aug 2019 00:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=rkW7J4us2wcg8bjWK7lkRGJB3dDndu6H2q1x50ew6oQ=;
        b=mEH6ZuhEu6yFarO3VDilQMa9XyC1+A49PnkX4edc04GEU6SJc3soZ5GZuZOYJX/uga
         II44mKnolNeiXF87zZbL4vGOskKrlz0q4PEJhLd6BS+WQM6abl2BI8PSeE5fWyO9jlXw
         g/9WBLjFHYqekAOpoi6jAaG/HeTWoWaR01qBEZzqd3fYVBlaOveHuVblKB6n/vqnx3Yx
         Lme/3C4QwErFBZqA1Cs2SYxYNl7WjJsPvK+kfMZcFbq+ae3aUuABineWLqyPDXgaANgP
         IsHED5ocFcuvRDFGiKI0hJLQajgXkuxQ5NfEIKnnjqNGCn+s9UvWA0yV8qHiXFR8YW5I
         AN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=rkW7J4us2wcg8bjWK7lkRGJB3dDndu6H2q1x50ew6oQ=;
        b=AKIqLNqQw7czvsu2nFJCcIqgyjFKPZxu/75qQM5Oy8v4MCV4DZb+WdYzrNKULu66Ys
         AFCOneVT3P7a9pFvvpcXCFfVdIL9gu6MFAHo5mNwxRMgzy32tFqt7xyDCxDoeaDYFgYv
         P6xp5Iv4MdnkjaUQU1dtQjmTN9AWGsEzis2pCT7SSUFlISw9b/dZoXSlmnxFiOLxf5kZ
         3JiEUl2A+JHSi/awOoAm+OubHrMG6itymL96ChbMgO0EMqL0d0iD+UDlkVVFPHyzMplX
         OJekgfhu7IWlnJsZukLmsN2Sm2lvWCmEPD5AwpMMtrgGjO+itbsGZvGIUSIL1q+CYTi9
         u1mw==
X-Gm-Message-State: APjAAAVuvpfFn6h/nEIMGqdPYN+poObir683IJB8UoNW75BuUdsDLDo5
        Fyg2lVqGZiQ8xM0QntW2UOueHTRr
X-Google-Smtp-Source: APXvYqxymmS0GKrgkdyJOCRe8wdDwDozO5XtrGBowc+cVXMQQKh1aP+fDBlhuy3PyTrxrIB//ES6fg==
X-Received: by 2002:a1c:cb0b:: with SMTP id b11mr1398279wmg.95.1565855171497;
        Thu, 15 Aug 2019 00:46:11 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 91sm6084837wrp.3.2019.08.15.00.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 00:46:11 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
Date:   Thu, 15 Aug 2019 09:46:09 +0200
Message-Id: <1565855169-29491-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 4e103134b862314dc2f2f18f2fb0ab972adc3f5f.
Alex Williamson reported regressions with device assignment with
this patch.  Even though the bug is probably elsewhere and still
latent, this is needed to fix the regression.

Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
Reported-by: Alex Willamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8190a195623a..d14656c5407b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5656,38 +5656,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	struct kvm_mmu_page *sp;
-	LIST_HEAD(invalid_list);
-	unsigned long i;
-	bool flush;
-	gfn_t gfn;
-
-	spin_lock(&kvm->mmu_lock);
-
-	if (list_empty(&kvm->arch.active_mmu_pages))
-		goto out_unlock;
-
-	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, false);
-
-	for (i = 0; i < slot->npages; i++) {
-		gfn = slot->base_gfn + i;
-
-		for_each_valid_sp(kvm, sp, gfn) {
-			if (sp->gfn != gfn)
-				continue;
-
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		}
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-			flush = false;
-			cond_resched_lock(&kvm->mmu_lock);
-		}
-	}
-	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-
-out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_invalidate_zap_all_pages(kvm);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
1.8.3.1

