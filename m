Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07A9472B42
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 12:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhLMLZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 06:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232578AbhLMLZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 06:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639394720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NgW2HZbqk/vaW0uvmcY9DBIAYMKjrYwVqr2SxXfM1k4=;
        b=gKY95apqvXQPwIykBAcdiNJYMAhLm1/05lwoqReJWH3YW08vw48eCvZ8bthA+ywy+G3thU
        TYiKJrQb9XCs0auZ9yrdrLsmHj82yB5JZghkr9Hd6224v0uvNRZqhlyPIMmwQg9TsuV33k
        J1aLZpQGK9Kt5hErbdOPb8KFWfWr3gI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-2hzbBmnZM3uE2eCdvOx4TA-1; Mon, 13 Dec 2021 06:25:19 -0500
X-MC-Unique: 2hzbBmnZM3uE2eCdvOx4TA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95334193F568;
        Mon, 13 Dec 2021 11:25:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA6EF5ED25;
        Mon, 13 Dec 2021 11:25:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, ignat@cloudflare.com, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team@cloudflare.com, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: zap invalid roots in kvm_tdp_mmu_zap_all
Date:   Mon, 13 Dec 2021 06:25:14 -0500
Message-Id: <20211213112514.78552-3-pbonzini@redhat.com>
In-Reply-To: <20211213112514.78552-1-pbonzini@redhat.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kvm_tdp_mmu_zap_all is intended to visit all roots and zap their page
tables, which flushes the accessed and dirty bits out to the Linux
"struct page"s.  Missing some of the roots has catastrophic effects,
because kvm_tdp_mmu_zap_all is called when the MMU notifier is being
removed and any PTEs left behind might become dangling by the time
kvm-arch_destroy_vm tears down the roots for good.

Unfortunately that is exactly what kvm_tdp_mmu_zap_all is doing: it
visits all roots via for_each_tdp_mmu_root_yield_safe, which in turn
uses kvm_tdp_mmu_get_root to skip invalid roots.  If the current root is
invalid at the time of kvm_tdp_mmu_zap_all, its page tables will remain
in place but will later be zapped during kvm_arch_destroy_vm.

To fix this, ensure that kvm_tdp_mmu_zap_all goes over all roots,
including the invalid ones.  The easiest way to do so is for
kvm_tdp_mmu_zap_all to do the same as kvm_mmu_zap_all_fast: invalidate
all roots, and then zap the invalid roots.  However, there is no need
to go through tdp_mmu_zap_spte_atomic because there are no running vCPUs.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f2dd5c97bbc2..ce3fafb6c9a7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -779,18 +779,6 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 	return flush;
 }
 
-void kvm_tdp_mmu_zap_all(struct kvm *kvm)
-{
-	bool flush = false;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-}
-
 static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
 						  struct kvm_mmu_page *prev_root)
 {
@@ -888,6 +876,19 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 			root->role.invalid = true;
 }
 
+void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+{
+	/*
+	 * We need to zap all roots, including already-invalid ones.  The
+	 * easiest way is to ensure there's only invalid roots which then,
+	 * for efficiency, we zap while mmu_lock is taken exclusively.
+	 * Since the MMU notifier is being torn down, contention on the
+	 * mmu_lock is not an issue.
+	 */
+	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
-- 
2.31.1

