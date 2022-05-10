Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22A521B1D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbiEJOI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244421AbiEJOF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AA3980B0;
        Tue, 10 May 2022 06:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 990B061937;
        Tue, 10 May 2022 13:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDC5C385A6;
        Tue, 10 May 2022 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190047;
        bh=9NrCYKuMIeM6+E1m5dJvPZmAeiaDUQmMNN6EQ1MT4B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztsWNtEL2BpIoHP2DDiVNrQjrKGHvNYR3/NbUkfrdqkx0eTNY2vez9w39TvmyyA1c
         pE7UZTOguUvfZevGLDQZLyuRo0660dfLMOLr139qYkRdwMWn2wSnOuVzPq/iVE5QQC
         08nFfjp6jxnm+CVUpk8Bx5FcEjEqoNdk2RSqbn5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hillf Danton <hdanton@sina.com>, kvm@vger.kernel.org,
        Peter Gonda <pgonda@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/140] KVM: SEV: Mark nested locking of vcpu->lock
Date:   Tue, 10 May 2022 15:08:21 +0200
Message-Id: <20220510130744.776874332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit 0c2c7c069285374fc8feacddc0498f8ab7627117 ]

svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
source and target vcpu->locks. Unfortunately there is an 8 subclass
limit, so a new subclass cannot be used for each vCPU. Instead maintain
ownership of the first vcpu's mutex.dep_map using a role specific
subclass: source vs target. Release the other vcpu's mutex.dep_maps.

Fixes: b56639318bb2b ("KVM: SEV: Add support for SEV intra host migration")
Reported-by: John Sperbeck<jsperbeck@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>

Message-Id: <20220502165807.529624-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e5cecd4ad2d4..76e6411d4dde 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1590,24 +1590,51 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	atomic_set_release(&src_sev->migration_in_progress, 0);
 }
 
+/* vCPU mutex subclasses.  */
+enum sev_migration_role {
+	SEV_MIGRATION_SOURCE = 0,
+	SEV_MIGRATION_TARGET,
+	SEV_NR_MIGRATION_ROLES,
+};
 
-static int sev_lock_vcpus_for_migration(struct kvm *kvm)
+static int sev_lock_vcpus_for_migration(struct kvm *kvm,
+					enum sev_migration_role role)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i, j;
+	bool first = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable(&vcpu->mutex))
+		if (mutex_lock_killable_nested(&vcpu->mutex, role))
 			goto out_unlock;
+
+		if (first) {
+			/*
+			 * Reset the role to one that avoids colliding with
+			 * the role used for the first vcpu mutex.
+			 */
+			role = SEV_NR_MIGRATION_ROLES;
+			first = false;
+		} else {
+			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
+		}
 	}
 
 	return 0;
 
 out_unlock:
+
+	first = true;
 	kvm_for_each_vcpu(j, vcpu, kvm) {
 		if (i == j)
 			break;
 
+		if (first)
+			first = false;
+		else
+			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
+
+
 		mutex_unlock(&vcpu->mutex);
 	}
 	return -EINTR;
@@ -1617,8 +1644,15 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	bool first = true;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (first)
+			first = false;
+		else
+			mutex_acquire(&vcpu->mutex.dep_map,
+				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
+
 		mutex_unlock(&vcpu->mutex);
 	}
 }
@@ -1726,10 +1760,10 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 		charged = true;
 	}
 
-	ret = sev_lock_vcpus_for_migration(kvm);
+	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
 	if (ret)
 		goto out_dst_cgroup;
-	ret = sev_lock_vcpus_for_migration(source_kvm);
+	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
 	if (ret)
 		goto out_dst_vcpu;
 
-- 
2.35.1



