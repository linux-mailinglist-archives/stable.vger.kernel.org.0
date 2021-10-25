Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B643A2F9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhJYTz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237831AbhJYTv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FE761139;
        Mon, 25 Oct 2021 19:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191013;
        bh=R4p8QemGWSKXojyvC/b7XHLWRuHhwn+w1iERzAZ1Xv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCXc8+MbM6h5NEnlw51vkP44jjcYPQbwHBKfdsBsMQij27RsHjbpsLEeCdRcbVE8p
         BaQbEYeuUURgtK9QYVoJ1n4W+FPpKlE0UOSg31WV+QLUPr5CcMKKEPf0GadLw+TfrG
         T7afakRX01QJ2vIq7f7+5SutPQ2WhwO5H8pPyG4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 105/169] KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA
Date:   Mon, 25 Oct 2021 21:14:46 +0200
Message-Id: <20211025191031.442798367@linuxfoundation.org>
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

From: Masahiro Kozuka <masa.koz@kozuka.jp>

commit c8c340a9b4149fe5caa433f3b62463a1c8e07a46 upstream.

Flush the destination page before invoking RECEIVE_UPDATE_DATA, as the
PSP encrypts the data with the guest's key when writing to guest memory.
If the target memory was not previously encrypted, the cache may contain
dirty, unecrypted data that will persist on non-coherent systems.

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Masahiro Kozuka <masa.koz@kozuka.jp>
[sean: converted bug report to changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210914210951.2994260-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1480,6 +1480,13 @@ static int sev_receive_update_data(struc
 		goto e_free_trans;
 	}
 
+	/*
+	 * Flush (on non-coherent CPUs) before RECEIVE_UPDATE_DATA, the PSP
+	 * encrypts the written data with the guest's key, and the cache may
+	 * contain dirty, unencrypted data.
+	 */
+	sev_clflush_pages(guest_page, n);
+
 	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
 	data.guest_address |= sev_me_mask;


