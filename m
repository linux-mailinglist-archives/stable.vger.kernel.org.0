Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1393743A4D8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhJYUlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhJYUk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 16:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E32A60ED4;
        Mon, 25 Oct 2021 20:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635194315;
        bh=wUhL0x2aexsAtp47exfBlqa4vzkZgflzQGbKET8do1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpB1CSCv0ZdRJ0PXgOB+4VQlzLN+RTVHvzvWci7tqA6Q0x61k+kzYHozetHDTCg1P
         emC6JWqz+HOPpmjU5rxdW14BLEqcwbxTATUmfLVPWP6DdYMvH48ErE+ir6xGMkj/jf
         XR7r839V1bGtFy023ecNeV1/GlQnGMqgiC3duPQSx+yjZ05xn7WazhrIC3AReWi7NN
         C7yU43LKUXl5ePAh7AuzOC9070mPUtoSciQCYcFRYRxAEywDzEfln1k3oe3DZnWJzZ
         7fq+CpwRvbTiBrERD5v59g3N5ow0P/RWYcPE55t3uvpB0BxDKRYDjhj/BcFlhBGLse
         02V3/PDyOdLxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 4/5] KVM: SEV-ES: Set guest_state_protected after VMSA update
Date:   Mon, 25 Oct 2021 16:38:26 -0400
Message-Id: <20211025203828.1404503-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025203828.1404503-1-sashal@kernel.org>
References: <20211025203828.1404503-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit baa1e5ca172ce7bf9554070139482dd7ea919528 ]

The refactoring in commit bb18a6777465 ("KVM: SEV: Acquire
vcpu mutex when updating VMSA") left behind the assignment to
svm->vcpu.arch.guest_state_protected; add it back.

Signed-off-by: Peter Gonda <pgonda@google.com>
[Delta between v2 and v3 of Peter's patch, which had already been
 committed; the commit message is my own. - Paolo]
Fixes: bb18a6777465 ("KVM: SEV: Acquire vcpu mutex when updating VMSA")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cb166bde449b..50dabccd664e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -619,7 +619,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
-- 
2.33.0

