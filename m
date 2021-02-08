Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12F83137CC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBHPbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhBHP1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D412964F1D;
        Mon,  8 Feb 2021 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797343;
        bh=Z3NwpbMc3+FIymIKdL8oJDqLuu31Dr0homPLMdONXjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvMpiH69yDeoHwNFKuJuh/o+eXxNenyXbA0UxBt6ZCH6GyAvZTwks4HmGpSynPSbK
         +1TkT5YRpu53+gvUGGw2RuvkzQzHM9UV8m0vIdumI8MR8QhBqV6ThlTw/pCHwwJuVj
         bbYsvyKd/JiBz6jIVx6ZJTJalrv7qFScGi99wdmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, Peter Gonda <pgonda@google.com>
Subject: [PATCH 5.10 077/120] Fix unsynchronized access to sev members through svm_register_enc_region
Date:   Mon,  8 Feb 2021 16:01:04 +0100
Message-Id: <20210208145821.479412648@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

V2
 - Fix up patch description
 - Correct file paths svm.c -> sev.c
 - Add unlock of kvm->lock on sev_pin_memory error

V1
 - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/

Message-Id: <20210127161524.2832400-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -320,6 +320,8 @@ static struct page **sev_pin_memory(stru
 	unsigned long first, last;
 	int ret;
 
+	lockdep_assert_held(&kvm->lock);
+
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
@@ -1001,12 +1003,20 @@ int svm_register_enc_region(struct kvm *
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
@@ -1015,13 +1025,6 @@ int svm_register_enc_region(struct kvm *
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


