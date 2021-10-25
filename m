Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1E843A2F5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhJYTyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236214AbhJYTvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0267C603E7;
        Mon, 25 Oct 2021 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191004;
        bh=Ls5iMNiiy8ccdGmX5ptaYcXXNtG9DkJmgA/GqTQMU6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PywdLXAxx7AEAqvffRbTeC6bLMwg62DxCQ2AkdAY1f4p+sEF9xEqlUtweW9daGs+6
         kq19FU/ikevrJqO6fv/dHGkyfCxqMbTwqWG1Ha0aupTOF73SUv9bXpnUDIIz5Ig9xz
         ahopGAh/YScVtb65m4Iopuf/2/eEzjJjwG/fRpyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 121/169] KVM: SEV-ES: Set guest_state_protected after VMSA update
Date:   Mon, 25 Oct 2021 21:15:02 +0200
Message-Id: <20211025191033.206758084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

commit baa1e5ca172ce7bf9554070139482dd7ea919528 upstream.

The refactoring in commit bb18a6777465 ("KVM: SEV: Acquire
vcpu mutex when updating VMSA") left behind the assignment to
svm->vcpu.arch.guest_state_protected; add it back.

Signed-off-by: Peter Gonda <pgonda@google.com>
[Delta between v2 and v3 of Peter's patch, which had already been
 committed; the commit message is my own. - Paolo]
Fixes: bb18a6777465 ("KVM: SEV: Acquire vcpu mutex when updating VMSA")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -619,7 +619,12 @@ static int __sev_launch_update_vmsa(stru
 	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
 	vmsa.address = __sme_pa(svm->vmsa);
 	vmsa.len = PAGE_SIZE;
-	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+	if (ret)
+	  return ret;
+
+	vcpu->arch.guest_state_protected = true;
+	return 0;
 }
 
 static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)


