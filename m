Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6219920A
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731123AbgCaJGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbgCaJGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D127A208E0;
        Tue, 31 Mar 2020 09:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645572;
        bh=Op9x9fk8WH1ceKJCatqOiO699VelXceIrN1eqoxYmkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0QUXvKI5bAixpeFOpYer/AvOzv3wFIznkfhHni48rUEDxFcc1PdP5mlKOzda4n/N
         4YyA3TW35CQy/toQgJQPWwuFgxII5HGTVkhgYo+EsLxlKSl8B+Vte/6IyzhrX59YDN
         254TWHFhq5/CKHrB7SU8pomLp3HjXFsE5qmCqIjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 094/170] KVM: SVM: Issue WBINVD after deactivating an SEV guest
Date:   Tue, 31 Mar 2020 10:58:28 +0200
Message-Id: <20200331085434.233242373@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 2e2409afe5f0c284c7dfe5504058e8d115806a7d upstream.

Currently, CLFLUSH is used to flush SEV guest memory before the guest is
terminated (or a memory hotplug region is removed). However, CLFLUSH is
not enough to ensure that SEV guest tagged data is flushed from the cache.

With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
original WBINVD was removed. This then exposed crashes at random times
because of a cache flush race with a page that had both a hypervisor and
a guest tag in the cache.

Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
svm_unregister_enc_region() function to ensure hotplug memory is flushed
when removed. The DF_FLUSH can still be avoided at this point.

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1920,14 +1920,6 @@ static void sev_clflush_pages(struct pag
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
-	/*
-	 * The guest may change the memory encryption attribute from C=0 -> C=1
-	 * or vice versa for this memory range. Lets make sure caches are
-	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
-	 */
-	sev_clflush_pages(region->pages, region->npages);
-
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
@@ -1958,6 +1950,13 @@ static void sev_vm_destroy(struct kvm *k
 	mutex_lock(&kvm->lock);
 
 	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
+	/*
 	 * if userspace was terminated before unregistering the memory regions
 	 * then lets unpin all the registered memory.
 	 */
@@ -7212,6 +7211,13 @@ static int svm_unregister_enc_region(str
 		goto failed;
 	}
 
+	/*
+	 * Ensure that all guest tagged cache entries are flushed before
+	 * releasing the pages back to the system for use. CLFLUSH will
+	 * not do this, so issue a WBINVD.
+	 */
+	wbinvd_on_all_cpus();
+
 	__unregister_enc_region_locked(kvm, region);
 
 	mutex_unlock(&kvm->lock);


