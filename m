Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431FE3060D5
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 17:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhA0QSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 11:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbhA0QQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 11:16:16 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEDEC0613D6
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:15:28 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id i82so2728251yba.18
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=9Xv60zVJdPCczqkiRxegMesI9/uXHmAEZHHrmplL1fM=;
        b=cVjd1wyoIvpXTMR4bPebeDTtMe139pQg6Wa7VaGTxksODku3ExYKVjBYZ6K0bOKjzI
         bvqP6vAWovpeMRFmcg+7WffIPRoHkZKhTNX+c8fQfIcYjuLInGCZkojObUExOqjK/wJ1
         VMG1DUU0CYg28ug47YripMY+WUH5knRtVZfKW3/oIhNtL3AD0+Iv2gtrPxQvBMoFsfUq
         xuaooUZCrVsbefjPisTntTed6/5heZKc0JX/iEuJOvh9rK8QCUIPslHTGkRZwwLARad0
         OI0oS3+VxNZXD4dajHNoYAlhPZaIYcE0AEVBvoVtxEUXYV2gsfqofKmfNIlG0JEkcvod
         LuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=9Xv60zVJdPCczqkiRxegMesI9/uXHmAEZHHrmplL1fM=;
        b=oyj3aMxlNussWlCrqIX5p7JpjpxlV8zEj94szQBS1WO5vYtHXxsHWxuvB0oJXUWoLM
         Afx8+YXz12Tj89wK6i9Lf/Kz1GxlIWKsVpFyGKBVDRENORDmbhTB5+rPwlLLfX8T9PeW
         nDL/U0sxlHHWPGI9wMysspwVchsaDVrwZQ2IsZU/3rdB3K2w/yB4is/kP3MJ4zNcb4Na
         De38w0FOdkpZctaCUb/Z/9O59bFnmRQvUUqM+dvLHQ3KMtDo4BfiCdeE7dRWEX1FPATh
         o4EUlZ5sOK95Xw2hMm7k/Zj0XnGf6GTuJyhmsbxN8TzezoHhV+Mg9IQYTtHwJ8qLMF6T
         AKhg==
X-Gm-Message-State: AOAM532bySFcDuJ2cxOQGNxLLsJz7m95IxtXD34O7KdMlCPMJkLWXm1n
        yUVQA9GRfLnMK7iTIqiefEkMk6TwMnc=
X-Google-Smtp-Source: ABdhPJxOVxm2ehXpuCNpDGvZJ1wvSjsZNmmaqdqSiL7GiFVkCM8pySxbBDfTAkaDvqqyjKZCrZsktPlhq8o=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:f20b:: with SMTP id i11mr17672537ybe.273.1611764127400;
 Wed, 27 Jan 2021 08:15:27 -0800 (PST)
Date:   Wed, 27 Jan 2021 08:15:24 -0800
Message-Id: <20210127161524.2832400-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH V2] Fix unsynchronized access to sev members through svm_register_enc_region
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
 arch/x86/kvm/svm/sev.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c8ffdbc81709..b80e9bf0a31b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -342,6 +342,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long first, last;
 	int ret;
 
+	lockdep_assert_held(&kvm->lock);
+
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
@@ -1119,12 +1121,20 @@ int svm_register_enc_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
+	mutex_lock(&kvm->lock);
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
+		mutex_unlock(&kvm->lock);
 		goto e_free;
 	}
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
@@ -1133,13 +1143,6 @@ int svm_register_enc_region(struct kvm *kvm,
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
2.30.0.280.ga3ce27912f-goog

