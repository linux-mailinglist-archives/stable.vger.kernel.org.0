Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D24420F50
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbhJDNdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237081AbhJDNbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F19966321E;
        Mon,  4 Oct 2021 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353259;
        bh=JRoqL4otUIGnStRHpXKpJPWH28/NtpXgHSdIf/lXCvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bp7yNDauNR59ecg6mAFRRR5TlisLaBeu6MNMzLwSLOGCET9DMWDeaxwjsgsEEbjzf
         MojANW3lvaP28XYDT28IYUaAm84/lvJ2pdNznqDZW571z4/YfrrOzTt6n0ZkvKoodT
         4kPQZ6aGLr1WDsSM/0iQDoMCPgDJYrPhQjEDzdrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 056/172] KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA
Date:   Mon,  4 Oct 2021 14:51:46 +0200
Message-Id: <20211004125046.804042551@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 50c038018d6be20361e8a2890262746a4ac5b11f upstream.

Require the target guest page to be writable when pinning memory for
RECEIVE_UPDATE_DATA.  Per the SEV API, the PSP writes to guest memory:

  The result is then encrypted with GCTX.VEK and written to the memory
  pointed to by GUEST_PADDR field.

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210914210951.2994260-2-seanjc@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1465,7 +1465,7 @@ static int sev_receive_update_data(struc
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 0);
+				    PAGE_SIZE, &n, 1);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;


