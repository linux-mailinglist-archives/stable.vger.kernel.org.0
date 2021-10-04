Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861D0420FB7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbhJDNha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhJDNfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA3B461BAA;
        Mon,  4 Oct 2021 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353366;
        bh=HSo0HeoTq6932krhI7dspLP/+JlyL66tOuDir8PxY7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO4t4BjCqebfSnyNCwtvPA42rP4Pvi+m4OnhCAkddvLXF4YuLKkLBvoaX05K3oM+F
         SRC70qkdBOOlDBxTl5TPoDXhkn8826GbQsSILsFh35+SJUm9PObUQ7fAszdZiVLB+3
         UvLoOxwc2Qx3shlJwn2eAhEy0f0WJ412LH2SVllo=
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
Subject: [PATCH 5.14 058/172] KVM: SEV: Allow some commands for mirror VM
Date:   Mon,  4 Oct 2021 14:51:48 +0200
Message-Id: <20211004125046.868220573@linuxfoundation.org>
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

commit 5b92b6ca92b65bef811048c481e4446f4828500a upstream.

A mirrored SEV-ES VM will need to call KVM_SEV_LAUNCH_UPDATE_VMSA to
setup its vCPUs and have them measured, and their VMSAs encrypted. Without
this change, it is impossible to have mirror VMs as part of SEV-ES VMs.

Also allow the guest status check and debugging commands since they do
not change any guest state.

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
Message-Id: <20210921150345.2221634-3-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1509,6 +1509,20 @@ static int sev_receive_finish(struct kvm
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static bool cmd_allowed_from_miror(u32 cmd_id)
+{
+	/*
+	 * Allow mirrors VM to call KVM_SEV_LAUNCH_UPDATE_VMSA to enable SEV-ES
+	 * active mirror VMs. Also allow the debugging and status commands.
+	 */
+	if (cmd_id == KVM_SEV_LAUNCH_UPDATE_VMSA ||
+	    cmd_id == KVM_SEV_GUEST_STATUS || cmd_id == KVM_SEV_DBG_DECRYPT ||
+	    cmd_id == KVM_SEV_DBG_ENCRYPT)
+		return true;
+
+	return false;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1525,8 +1539,9 @@ int svm_mem_enc_op(struct kvm *kvm, void
 
 	mutex_lock(&kvm->lock);
 
-	/* enc_context_owner handles all memory enc operations */
-	if (is_mirroring_enc_context(kvm)) {
+	/* Only the enc_context_owner handles some memory enc operations. */
+	if (is_mirroring_enc_context(kvm) &&
+	    !cmd_allowed_from_miror(sev_cmd.id)) {
 		r = -EINVAL;
 		goto out;
 	}


