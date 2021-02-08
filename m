Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8905F313A0E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 17:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhBHQu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 11:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbhBHQt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 11:49:56 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01851C061793
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 08:48:45 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p19so7731156plr.22
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 08:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=CWLS3iCdl7avu6UrS/4a9Q7lCozs1sxuZ+Q+3TdBAr4=;
        b=MkS/AQpsy4KJi2RAXDyDVdKnFaGcb8SW96N1xaxNIG/R8e6YcwlBQ9vh0t51rhuofi
         i2vBYteTnMD+u7upnr9YfcoJu3W8ZaYEvYWAQArs9ud8ocrYGqh9b6UKHfUE0aTX2nd+
         X7EQW1I5ERB5Wy2/NAVTjwKHNbol9Y4O97ag3nwYL6j0+jshBjpP0zCchaUV1eomWmUm
         gU1ntF6fsqDAWh40hku88WgSOyoCs6I8fVL/b22dS+pJLvCZ9gVrCi5QEWlnU2rpV7Hk
         yDcUZ0z49g+Fy7AdPfB8khbpopSxyhugyzcqDYjYRFCRfOSB3i2a3ZzHLoQinzIaMpVG
         n3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=CWLS3iCdl7avu6UrS/4a9Q7lCozs1sxuZ+Q+3TdBAr4=;
        b=WPBDb427FUZIb6z3yYOdMllLAxz1aNteYiyNw/uEiAYPTSu5A0YM69uGNPspb8US1d
         if/RUCKa7fRDxqN9W6CLNcewjkZSSVILkOLI5dYhBw+aWzBNv+3gqmuP7Fzo28wQGjXF
         Jj4iQZBcrfDuD1bXhHvKZcGHNVFsXfee5i5EMJ29zBnTR19NoZFIRnVnkDceKPrXO53p
         BpaDXKLdTgIE5l8nbMr1ukcnoed3ggpFblMKV1KlFlQAZyaSPuwgx1s5bOsAVZnI/twG
         vxiVeMp7Sl6xhHNINtGRR8rZQ+4XiWdKJDsCXu117Oy/i7kb2kt9i7A2udCJyH8WSmnD
         5xjw==
X-Gm-Message-State: AOAM530x4QmEfl1t4RVHlL8BeVEVoICvxuKT7DGliCyO2swWcnRN3Vin
        DvSVUy6at74E4g/IFXSCq/Lw2HMZIo4nWUUYWAPL/uN6ayarUmBlTVoCTXhCZIadV5/lAzgjE6r
        Jf7y1P1yJNyMRBD/Aj+wg62ZMbbcUcjtQGonHINxuOxy9w/eq7zOU4uNpZSjcRA==
X-Google-Smtp-Source: ABdhPJzsbIldQf/8UDs4hDwDDcUOVrtcG212tLSgbSxhCz6lTXYVMBAf80R68i/GgR8Gx2bdiBy8lRKlNSg=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:588:a801:402d:d5e5])
 (user=pgonda job=sendgmr) by 2002:a17:902:9009:b029:dc:52a6:575 with SMTP id
 a9-20020a1709029009b02900dc52a60575mr16415595plp.57.1612802924247; Mon, 08
 Feb 2021 08:48:44 -0800 (PST)
Date:   Mon,  8 Feb 2021 08:48:40 -0800
Message-Id: <20210208164840.769333-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH for 4.19] Fix unsynchronized access to sev members through svm_register_enc_region
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

