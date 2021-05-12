Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C4E37C73B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhELQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237842AbhELP41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E6061C22;
        Wed, 12 May 2021 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833321;
        bh=pbxRNvpoHwxuzJ4F/O8ly41xlSTcWgUwOr+0zFXP3wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyDveu+V4+smy2NkmdnwODvtPCnJHHRcbaza0yFWQo67/62KGofY28UHC5IOP0P1j
         sHPafUUo+zm73+EZ8Ac0MpcqMBYbSRt+5BXoa/A2wgQzi4CHqUcyU7BTrBaBv7g0X5
         k1IuGgLo0k0Qo/yKj0Ea+rIdy7LHHltOXZVlGYLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 102/601] KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
Date:   Wed, 12 May 2021 16:42:59 +0200
Message-Id: <20210512144831.202722432@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 9fa1521daafb58d878d03d75f6863a11312fae22 upstream.

Set sev->es_active only after the guts of KVM_SEV_ES_INIT succeeds.  If
the command fails, e.g. because SEV is already active or there are no
available ASIDs, then es_active will be left set even though the VM is
not fully SEV-ES capable.

Refactor the code so that "es_active" is passed on the stack instead of
being prematurely shoved into sev_info, both to avoid having to unwind
sev_info and so that it's more obvious what actually consumes es_active
in sev_guest_init() and its helpers.

Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331031936.2495277-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -86,7 +86,7 @@ static bool __sev_recycle_asids(int min_
 	return true;
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(bool es_active)
 {
 	int pos, min_asid, max_asid;
 	bool retry = true;
@@ -97,8 +97,8 @@ static int sev_asid_new(struct kvm_sev_i
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
 	 */
-	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
-	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
+	min_asid = es_active ? 0 : min_sev_asid - 1;
+	max_asid = es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
 	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
 	if (pos >= max_asid) {
@@ -178,13 +178,14 @@ static void sev_unbind_asid(struct kvm *
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	bool es_active = argp->id == KVM_SEV_ES_INIT;
 	int asid, ret;
 
 	ret = -EBUSY;
 	if (unlikely(sev->active))
 		return ret;
 
-	asid = sev_asid_new(sev);
+	asid = sev_asid_new(es_active);
 	if (asid < 0)
 		return ret;
 
@@ -193,6 +194,7 @@ static int sev_guest_init(struct kvm *kv
 		goto e_free;
 
 	sev->active = true;
+	sev->es_active = es_active;
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
@@ -203,16 +205,6 @@ e_free:
 	return ret;
 }
 
-static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
-{
-	if (!sev_es)
-		return -ENOTTY;
-
-	to_kvm_svm(kvm)->sev_info.es_active = true;
-
-	return sev_guest_init(kvm, argp);
-}
-
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	struct sev_data_activate *data;
@@ -1059,12 +1051,15 @@ int svm_mem_enc_op(struct kvm *kvm, void
 	mutex_lock(&kvm->lock);
 
 	switch (sev_cmd.id) {
+	case KVM_SEV_ES_INIT:
+		if (!sev_es) {
+			r = -ENOTTY;
+			goto out;
+		}
+		fallthrough;
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
 		break;
-	case KVM_SEV_ES_INIT:
-		r = sev_es_guest_init(kvm, &sev_cmd);
-		break;
 	case KVM_SEV_LAUNCH_START:
 		r = sev_launch_start(kvm, &sev_cmd);
 		break;


