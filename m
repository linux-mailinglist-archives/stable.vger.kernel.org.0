Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD7237CEED
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345201AbhELRHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244772AbhELQvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB2D61D69;
        Wed, 12 May 2021 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836275;
        bh=uxTgwmuAjklKrY+YBjaoLQuaLOCj/LEwHs0XYrayVcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1T8g+QpJjBnDYBUNt4EM3Dp0Ehzpe1vc+H4zP1ZfhGq00BmVsh2+WQIwPyCxtH0X
         M1k9/99bTcWE9gw0MLVLTFPcyEOqiaZ7oHzdNwDQnzW4yoR6wyZCBqX66+Cq9bBxKJ
         nsB2icIng+RoVZ9m6N7Ulg6lC4fW0/NufU61Um1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 646/677] KVM: SVM: Zero out the VMCB array used to track SEV ASID association
Date:   Wed, 12 May 2021 16:51:32 +0200
Message-Id: <20210512144858.828419120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3b1902b87bf11f1c6a84368470dc13da6f3da3bd ]

Zero out the array of VMCB pointers so that pre_sev_run() won't see
garbage when querying the array to detect when an SEV ASID is being
associated with a new VMCB.  In practice, reading random values is all
but guaranteed to be benign as a false negative (which is extremely
unlikely on its own) can only happen on CPU0 on the first VMRUN and would
only cause KVM to skip the ASID flush.  For anything bad to happen, a
previous instance of KVM would have to exit without flushing the ASID,
_and_ KVM would have to not flush the ASID at any time while building the
new SEV guest.

Cc: Borislav Petkov <bp@suse.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422021125.3417167-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9c260c73f334..d5620361eae7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -564,9 +564,8 @@ static int svm_cpu_init(int cpu)
 	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
-		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
-					      sizeof(void *),
-					      GFP_KERNEL);
+		sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *),
+					GFP_KERNEL);
 		if (!sd->sev_vmcbs)
 			goto free_save_area;
 	}
-- 
2.30.2



