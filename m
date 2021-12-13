Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F4C472B46
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 12:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhLMLZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 06:25:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235464AbhLMLZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 06:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639394722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MjRcoCyY5PH9ZdTSsY1tkuIprpWWOIhRjLNdMeQeEGo=;
        b=VUsPKAuKL9L+fLkwg/NkqtICukKbeiAy03O/SXAfidk/SZSnwHjCndeYVq/XoOqMrdHEAd
        xvoSEB0X9OaGgIPnkX4KxdRzKQcO/WHWlXTrilzBxw/4yl/YMTAJXlggM4mfvtTbx3OXe7
        cV5kdrNYIa+UdV4oLCGNHFZd0sBFiG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-ajcxGUn4OqKa1oqVWHpm_Q-1; Mon, 13 Dec 2021 06:25:18 -0500
X-MC-Unique: ajcxGUn4OqKa1oqVWHpm_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC451801962;
        Mon, 13 Dec 2021 11:25:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01AAE5E272;
        Mon, 13 Dec 2021 11:25:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, ignat@cloudflare.com, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team@cloudflare.com, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: allow kvm_tdp_mmu_zap_invalidated_roots with write-locked mmu_lock
Date:   Mon, 13 Dec 2021 06:25:13 -0500
Message-Id: <20211213112514.78552-2-pbonzini@redhat.com>
In-Reply-To: <20211213112514.78552-1-pbonzini@redhat.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Zapping within a write-side critical section is more efficient, so it is
desirable if we know that no vCPU is running (such as within the .release
MMU notifier callback).  Prepare for reusing kvm_tdp_mmu_zap_invalidated_roots
in such scenarios.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 17 +++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a3bcdd3cfe7..6fe4ab8fc0ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5695,7 +5695,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_zap_invalidated_roots(kvm);
+		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1db8496259ad..f2dd5c97bbc2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -821,14 +821,18 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  * only has to do a trivial amount of work. Since the roots are invalid,
  * no new SPTEs should be created under them.
  */
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
 {
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	lockdep_assert_held_read(&kvm->mmu_lock);
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
+	/*
+	 * rcu_read_lock is only needed for shared == true, but we
+	 * always take it for simplicity.
+	 */
 	rcu_read_lock();
 
 	root = next_invalidated_root(kvm, NULL);
@@ -838,13 +842,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
+		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, shared);
 
-		/*
-		 * Put the reference acquired in
-		 * kvm_tdp_mmu_invalidate_roots
-		 */
-		kvm_tdp_mmu_put_root(kvm, root, true);
+		/* Put the reference acquired in kvm_tdp_mmu_invalidate_roots.  */
+		kvm_tdp_mmu_put_root(kvm, root, shared);
 
 		root = next_root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..24809f4ed090 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -46,7 +46,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-- 
2.31.1


