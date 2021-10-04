Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB8420F4C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhJDNds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236873AbhJDNbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67BA4619E9;
        Mon,  4 Oct 2021 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353256;
        bh=NC8HZAlr1M0y90qa5JDrm8ws99TMSgsm6w3N1CJm7HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWeRcMqV1S4YXl7P0b24wKycC4hXtoHBX71SP5OTgYwH+PVVr+NXS4fBO9yG/aaCC
         TKlQtxH4XoouLWVqNDZI8GCw87jFV8qrRw8D/l6ffIoI+NQrGIuBcVECVaEMDN7298
         MQBxOnbKa3jtxt8DFzyy4mQmG1YzTMXke/Uhc7zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Subject: [PATCH 5.14 055/172] KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES
Date:   Mon,  4 Oct 2021 14:51:45 +0200
Message-Id: <20211004125046.774748468@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

commit f43c887cb7cb5b66c4167d40a4209027f5fdb5ce upstream.

For mirroring SEV-ES the mirror VM will need more then just the ASID.
The FD and the handle are required to all the mirror to call psp
commands. The mirror VM will need to call KVM_SEV_LAUNCH_UPDATE_VMSA to
setup its vCPUs' VMSAs for SEV-ES.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steve Rutherford <srutherford@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context", 2021-04-21)
Message-Id: <20210921150345.2221634-2-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1716,8 +1716,7 @@ int svm_vm_copy_asid_from(struct kvm *kv
 {
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
-	struct kvm_sev_info *mirror_sev;
-	unsigned int asid;
+	struct kvm_sev_info source_sev, *mirror_sev;
 	int ret;
 
 	source_kvm_file = fget(source_fd);
@@ -1740,7 +1739,8 @@ int svm_vm_copy_asid_from(struct kvm *kv
 		goto e_source_unlock;
 	}
 
-	asid = to_kvm_svm(source_kvm)->sev_info.asid;
+	memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
+	       sizeof(source_sev));
 
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
@@ -1760,8 +1760,16 @@ int svm_vm_copy_asid_from(struct kvm *kv
 	/* Set enc_context_owner and copy its encryption context over */
 	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
-	mirror_sev->asid = asid;
 	mirror_sev->active = true;
+	mirror_sev->asid = source_sev.asid;
+	mirror_sev->fd = source_sev.fd;
+	mirror_sev->es_active = source_sev.es_active;
+	mirror_sev->handle = source_sev.handle;
+	/*
+	 * Do not copy ap_jump_table. Since the mirror does not share the same
+	 * KVM contexts as the original, and they may have different
+	 * memory-views.
+	 */
 
 	mutex_unlock(&kvm->lock);
 	return 0;


