Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2904C3D6165
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhGZPbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237839AbhGZP3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC0E260F94;
        Mon, 26 Jul 2021 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315732;
        bh=2v9pGKzvhZa6vei/18H16pUxoJeFxIjVETAkJ7gHoKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/S/Uz0BLjbHxElFHxJb+spHIBsc09a66e6kc1AA6MrnJqd4oJ2X8xv82BSjHhtzv
         rOTBQxDYC0XB0a87XM5h0UbQnnjnR0rYNO7ZUE/Q9hBkY9y8iRSMn5gRqCg82yuN6+
         9O6l3IwLlcM3xv9pmCkIegSbdqYioUzjOD5Rr4vg=
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
Subject: [PATCH 5.13 045/223] KVM: SVM: Fix sev_pin_memory() error checks in SEV migration utilities
Date:   Mon, 26 Jul 2021 17:37:17 +0200
Message-Id: <20210726153847.734214853@linuxfoundation.org>
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

[ Upstream commit c7a1b2b678c54ac19320daf525038d0e2e43ca7c ]

Use IS_ERR() instead of checking for a NULL pointer when querying for
sev_pin_memory() failures.  sev_pin_memory() always returns an error code
cast to a pointer, or a valid pointer; it never returns NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Steve Rutherford <srutherford@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210506175826.2166383-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3dc3e2897804..02d60d7f903d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1271,8 +1271,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
 				    PAGE_SIZE, &n, 0);
-	if (!guest_page)
-		return -EFAULT;
+	if (IS_ERR(guest_page))
+		return PTR_ERR(guest_page);
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
@@ -1463,11 +1463,12 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.trans_len = params.trans_len;
 
 	/* Pin guest memory */
-	ret = -EFAULT;
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
 				    PAGE_SIZE, &n, 0);
-	if (!guest_page)
+	if (IS_ERR(guest_page)) {
+		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
+	}
 
 	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
-- 
2.30.2



