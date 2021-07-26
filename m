Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2641A3D61BE
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhGZPcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237813AbhGZP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CC761053;
        Mon, 26 Jul 2021 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315729;
        bh=YBOEP/ovT6gc0p2LMVyx1rHMtDTSsz2N8rHnrXhzq1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvM140XLddlls7NkM0QYGFMN45za4mAG9jCe71gjK5EczaTLTgMM2UcyAjui6R0vC
         SUajyGg8Kxk1SeHTaGTCzjYEaFP6SjMjR8HaRpIAOaHQAMNUws8oUOMBaJaC2tPO7a
         CBQZaNbq7N4WTZMF9o33nvS504b118ZxG9G2fyHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 044/223] KVM: SVM: Return -EFAULT if copy_to_user() for SEV mig packet header fails
Date:   Mon, 26 Jul 2021 17:37:16 +0200
Message-Id: <20210726153847.702458359@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b4a693924aab93f3747465b2261add46c82c3220 ]

Return -EFAULT if copy_to_user() fails; if accessing user memory faults,
copy_to_user() returns the number of bytes remaining, not an error code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Steve Rutherford <srutherford@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210506175826.2166383-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8d36f0c73071..3dc3e2897804 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1309,8 +1309,9 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 	/* Copy packet header to userspace. */
-	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
-				params.hdr_len);
+	if (copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
+			 params.hdr_len))
+		ret = -EFAULT;
 
 e_free_trans_data:
 	kfree(trans_data);
-- 
2.30.2



