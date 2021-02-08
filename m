Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D4313A11
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 17:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhBHQva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 11:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhBHQuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 11:50:10 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9BFC0617A7
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 08:48:58 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id o14so9683704pfp.16
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 08:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=CWLS3iCdl7avu6UrS/4a9Q7lCozs1sxuZ+Q+3TdBAr4=;
        b=h63zsE4ezN6OCZsuKkcFUpv5B4yvCpCVEuK32I4ib8AUnfahsxf/fPZ7KtlM2O2YHt
         CwUiwX5vUz6lb6ueS7j8/BzB78EcrGvf/HcN0Ikw0iq2ZVYCL2r3jcA5bQpSHTMMR/+z
         EEC12b0bfkYfdrIukt/4St/vkL5K29wqi12l6LG+6hlfmgOrh746Z66PUmosCqxtc1Hp
         fPE+JPm7qf6VJTJawhgpdyHKuWC0NPZzTKy14W2hWLuP8SEJd99gD6LUbIhZjI9wiKul
         NCl+xxl3SMvFn16Iv7jxa9dIoBj5F9457+1yRY/GfRdfjUfA4Ukg7NWoP+QMjNWJBGWg
         mcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=CWLS3iCdl7avu6UrS/4a9Q7lCozs1sxuZ+Q+3TdBAr4=;
        b=SRZ9XmvXR0Hd80NRtrTc3+rq/dT+G4wiRbSPSv6pLs6dSYVIc46bZDm92Lttx1DyUp
         opysT/Ojajb7uw3Oi8RIT5YPTbAWb2iRzAMTcrAn6557kyYCkoMAuced2S1KZ9tuGk/6
         3/xOCreiRDTnzYws69x4+jYxcBuTl2q1J64zCjkfEaTIKYEgWWOdb90OSiF1HxvTp1DE
         GDn2A3fL2+eEy5iBRvIoctK2W+uCQMrStmwb9FJN08lBlUMqK4wwnslSYdVDESfQeEWv
         xfH2Qwtbgj2EzBWY2CUYd0kSXU00hBGG8REk4QXhbGe0oaY+vQWt1yeUNz0uzBIymSAT
         3jfw==
X-Gm-Message-State: AOAM53037u1at6ZfhH05FnfOCSHm7qxb1hnURRNtxOhjAprLjqUdarNE
        YPbnVGT1ajqJl/69puXDnR9bs7oTcUHdkfBxSpol3BqnRbCGpbMtDy7k9LJ7YoScRjh0IUc+Njy
        FZlaEQhid1mLZ2bgiJZ1f5CB3aatd/qf5SnwC0ONA3iYutAZZq8/yS5YWP+UbxQ==
X-Google-Smtp-Source: ABdhPJyrMNiN0ra//SFWELFPtCPbNLOL3F1BSTGyIONMn9Zwnqqz5JsBarlztfEaJUc/8S4FKFvEAwb7Iys=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:588:a801:402d:d5e5])
 (user=pgonda job=sendgmr) by 2002:aa7:91cf:0:b029:1cb:1c6f:b77d with SMTP id
 z15-20020aa791cf0000b02901cb1c6fb77dmr18651925pfa.74.1612802937434; Mon, 08
 Feb 2021 08:48:57 -0800 (PST)
Date:   Mon,  8 Feb 2021 08:48:55 -0800
Message-Id: <20210208164855.772287-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH for 5.4] Fix unsynchronized access to sev members through svm_register_enc_region
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.

Grab kvm->lock before pinning memory when registering an encrypted
region; sev_pin_memory() relies on kvm->lock being held to ensure
correctness when checking and updating the number of pinned pages.

Add a lockdep assertion to help prevent future regressions.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
Signed-off-by: Peter Gonda <pgonda@google.com>

V2
 - Fix up patch description
 - Correct file paths svm.c -> sev.c
 - Add unlock of kvm->lock on sev_pin_memory error

V1
 - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/

Message-Id: <20210127161524.2832400-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2b506904be02..93c89f1ffc5d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	struct page **pages;
 	unsigned long first, last;
 
+	lockdep_assert_held(&kvm->lock);
+
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return NULL;
 
@@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
+	mutex_lock(&kvm->lock);
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
 	if (!region->pages) {
 		ret = -ENOMEM;
+		mutex_unlock(&kvm->lock);
 		goto e_free;
 	}
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	mutex_lock(&kvm->lock);
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
@@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
 	 */
 	sev_clflush_pages(region->pages, region->npages);
 
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	mutex_lock(&kvm->lock);
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	return ret;
 
 e_free:
-- 
2.30.0.478.g8a0d178c01-goog

