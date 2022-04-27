Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA0351205B
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbiD0P6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240781AbiD0P6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:58:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF8D703F2;
        Wed, 27 Apr 2022 08:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D84B82882;
        Wed, 27 Apr 2022 15:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FCBC385A9;
        Wed, 27 Apr 2022 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074866;
        bh=nUJi9NwEDMOL67VoABYsDkTRVFz/HZFRchVBClMPDao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FO8wjeKqIeLNCkvcW1HW+gCjEQQ6pj7pYtPzJrBAdd8N1PIttU7bj30SIIUkzbzzL
         Ph7J/bHDsMCUr+kuOTkEQ4D3ONAeFEH47LCISBDMTNHFdCPrTM7YF2vvEcNxZUs4uZ
         YiFcAcyQTVgW/kwFZNKgD9bmPieXFxUwgUVlWgzxlV61vs2iBmRM1uQU9+L8P88qs+
         3bLOXlZQCx1zAweuvQ8TEK8xpSaWOmnry0pMT5J99VbSyT68B1ieNvr+rSvv0gI5T1
         Vysomu2GJwyFBg+VBBdQxdpz/IacM0ikOdwAi+8JEGsLYQkIeyCaH2/OpdCeHYWdXm
         amPH9MtEUK8Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 6/7] KVM: SEV: Allow SEV intra-host migration of VM with mirrors
Date:   Wed, 27 Apr 2022 11:54:02 -0400
Message-Id: <20220427155408.19352-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
References: <20220427155408.19352-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit b2125513dfc0dd0ec5a9605138a3c356592cfb73 ]

For SEV-ES VMs with mirrors to be intra-host migrated they need to be
able to migrate with the mirror. This is due to that fact that all VMSAs
need to be added into the VM with LAUNCH_UPDATE_VMSA before
lAUNCH_FINISH. Allowing migration with mirrors allows users of SEV-ES to
keep the mirror VMs VMSAs during migration.

Adds a list of mirror VMs for the original VM iterate through during its
migration. During the iteration the owner pointers can be updated from
the source to the destination. This fixes the ASID leaking issue which
caused the blocking of migration of VMs with mirrors.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20220211193634.3183388-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c                        | 57 ++++++++++++-------
 arch/x86/kvm/svm/svm.h                        |  3 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 47 ++++++++++-----
 3 files changed, 73 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fef975852582..553d6dbf19a2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -258,6 +258,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	INIT_LIST_HEAD(&sev->regions_list);
+	INIT_LIST_HEAD(&sev->mirror_vms);
 
 	return 0;
 
@@ -1623,9 +1624,12 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 	}
 }
 
-static void sev_migrate_from(struct kvm_sev_info *dst,
-			      struct kvm_sev_info *src)
+static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
+	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
+	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_sev_info *mirror;
+
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
@@ -1639,6 +1643,30 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	src->enc_context_owner = NULL;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
+
+	/*
+	 * If this VM has mirrors, "transfer" each mirror's refcount of the
+	 * source to the destination (this KVM).  The caller holds a reference
+	 * to the source, so there's no danger of use-after-free.
+	 */
+	list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
+	list_for_each_entry(mirror, &dst->mirror_vms, mirror_entry) {
+		kvm_get_kvm(dst_kvm);
+		kvm_put_kvm(src_kvm);
+		mirror->enc_context_owner = dst_kvm;
+	}
+
+	/*
+	 * If this VM is a mirror, remove the old mirror from the owners list
+	 * and add the new mirror to the list.
+	 */
+	if (is_mirroring_enc_context(dst_kvm)) {
+		struct kvm_sev_info *owner_sev_info =
+			&to_kvm_svm(dst->enc_context_owner)->sev_info;
+
+		list_del(&src->mirror_entry);
+		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
+	}
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
@@ -1708,15 +1736,6 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 
 	src_sev = &to_kvm_svm(source_kvm)->sev_info;
 
-	/*
-	 * VMs mirroring src's encryption context rely on it to keep the
-	 * ASID allocated, but below we are clearing src_sev->asid.
-	 */
-	if (src_sev->num_mirrored_vms) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	dst_sev->misc_cg = get_current_misc_cg();
 	cg_cleanup_sev = dst_sev;
 	if (dst_sev->misc_cg != src_sev->misc_cg) {
@@ -1738,7 +1757,8 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 		if (ret)
 			goto out_source_vcpu;
 	}
-	sev_migrate_from(dst_sev, src_sev);
+
+	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
 	cg_cleanup_sev = src_sev;
 	ret = 0;
@@ -2008,10 +2028,10 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	 */
 	source_sev = &to_kvm_svm(source_kvm)->sev_info;
 	kvm_get_kvm(source_kvm);
-	source_sev->num_mirrored_vms++;
+	mirror_sev = &to_kvm_svm(kvm)->sev_info;
+	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
-	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
 	mirror_sev->active = true;
 	mirror_sev->asid = source_sev->asid;
@@ -2019,6 +2039,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->es_active = source_sev->es_active;
 	mirror_sev->handle = source_sev->handle;
 	INIT_LIST_HEAD(&mirror_sev->regions_list);
+	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
 	ret = 0;
 
 	/*
@@ -2041,19 +2062,17 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
-	WARN_ON(sev->num_mirrored_vms);
-
 	if (!sev_guest(kvm))
 		return;
 
+	WARN_ON(!list_empty(&sev->mirror_vms));
+
 	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
 	if (is_mirroring_enc_context(kvm)) {
 		struct kvm *owner_kvm = sev->enc_context_owner;
-		struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
 
 		mutex_lock(&owner_kvm->lock);
-		if (!WARN_ON(!owner_sev->num_mirrored_vms))
-			owner_sev->num_mirrored_vms--;
+		list_del(&sev->mirror_entry);
 		mutex_unlock(&owner_kvm->lock);
 		kvm_put_kvm(owner_kvm);
 		return;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 86bcfed6599e..831bca1fdc29 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -81,7 +81,8 @@ struct kvm_sev_info {
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
-	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
+	struct list_head mirror_vms; /* List of VMs mirroring */
+	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 };
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 80056bbbb003..2e5a42cb470b 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -341,35 +341,54 @@ static void test_sev_mirror_parameters(void)
 
 static void test_sev_move_copy(void)
 {
-	struct kvm_vm *dst_vm, *sev_vm, *mirror_vm, *dst_mirror_vm;
-	int ret;
+	struct kvm_vm *dst_vm, *dst2_vm, *dst3_vm, *sev_vm, *mirror_vm,
+		      *dst_mirror_vm, *dst2_mirror_vm, *dst3_mirror_vm;
 
 	sev_vm = sev_vm_create(/* es= */ false);
 	dst_vm = aux_vm_create(true);
+	dst2_vm = aux_vm_create(true);
+	dst3_vm = aux_vm_create(true);
 	mirror_vm = aux_vm_create(false);
 	dst_mirror_vm = aux_vm_create(false);
+	dst2_mirror_vm = aux_vm_create(false);
+	dst3_mirror_vm = aux_vm_create(false);
 
 	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
-	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
-	TEST_ASSERT(ret == -1 && errno == EBUSY,
-		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
-		    errno);
 
-	/* The mirror itself can be migrated.  */
 	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
-	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
-	TEST_ASSERT(ret == -1 && errno == EBUSY,
-		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
-		    errno);
+	sev_migrate_from(dst_vm->fd, sev_vm->fd);
+
+	sev_migrate_from(dst2_vm->fd, dst_vm->fd);
+	sev_migrate_from(dst2_mirror_vm->fd, dst_mirror_vm->fd);
+
+	sev_migrate_from(dst3_mirror_vm->fd, dst2_mirror_vm->fd);
+	sev_migrate_from(dst3_vm->fd, dst2_vm->fd);
+
+	kvm_vm_free(dst_vm);
+	kvm_vm_free(sev_vm);
+	kvm_vm_free(dst2_vm);
+	kvm_vm_free(dst3_vm);
+	kvm_vm_free(mirror_vm);
+	kvm_vm_free(dst_mirror_vm);
+	kvm_vm_free(dst2_mirror_vm);
+	kvm_vm_free(dst3_mirror_vm);
 
 	/*
-	 * mirror_vm is not a mirror anymore, dst_mirror_vm is.  Thus,
-	 * the owner can be copied as soon as dst_mirror_vm is gone.
+	 * Run similar test be destroy mirrors before mirrored VMs to ensure
+	 * destruction is done safely.
 	 */
-	kvm_vm_free(dst_mirror_vm);
+	sev_vm = sev_vm_create(/* es= */ false);
+	dst_vm = aux_vm_create(true);
+	mirror_vm = aux_vm_create(false);
+	dst_mirror_vm = aux_vm_create(false);
+
+	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
+
+	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
 	sev_migrate_from(dst_vm->fd, sev_vm->fd);
 
 	kvm_vm_free(mirror_vm);
+	kvm_vm_free(dst_mirror_vm);
 	kvm_vm_free(dst_vm);
 	kvm_vm_free(sev_vm);
 }
-- 
2.35.1

