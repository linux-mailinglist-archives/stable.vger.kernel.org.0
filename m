Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C36147264E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhLMJuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:50:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33718 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbhLMJsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:48:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03B69B80D1F;
        Mon, 13 Dec 2021 09:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD2BC00446;
        Mon, 13 Dec 2021 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388889;
        bh=DL2KAsAXH0kNhRFxNijFLl/ttY2ZlaVeockTmqaVeZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSWadre8Tv41hcyQdOsdgpFa+noxb79x1TgY6f/t9Qxez91EajYQEImO2kSA8juGy
         fETxpgrEcWLvn5v4JFh8KH7uBD5cizYCxGcqh5yVqYSFr4JqQdQewg6kjhG8l/CVyY
         ng3nlwSntZ/r9nVefS99EzGGbIjsnmlsAcXO7Q9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 043/132] KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall
Date:   Mon, 13 Dec 2021 10:29:44 +0100
Message-Id: <20211213092940.600722432@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 1ebfaa11ebb5b603a3c3f54b2e84fcf1030f5a14 upstream.

Prior to commit 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use
tlb_flush_guest()"), kvm_hv_flush_tlb() was using 'KVM_REQ_TLB_FLUSH |
KVM_REQUEST_NO_WAKEUP' when making a request to flush TLBs on other vCPUs
and KVM_REQ_TLB_FLUSH is/was defined as:

 (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)

so KVM_REQUEST_WAIT was lost. Hyper-V TLFS, however, requires that
"This call guarantees that by the time control returns back to the
caller, the observable effects of all flushes on the specified virtual
processors have occurred." and without KVM_REQUEST_WAIT there's a small
chance that the vCPU making the TLB flush will resume running before
all IPIs get delivered to other vCPUs and a stale mapping can get read
there.

Fix the issue by adding KVM_REQUEST_WAIT flag to KVM_REQ_TLB_FLUSH_GUEST:
kvm_hv_flush_tlb() is the sole caller which uses it for
kvm_make_all_cpus_request()/kvm_make_vcpus_request_mask() where
KVM_REQUEST_WAIT makes a difference.

Cc: stable@kernel.org
Fixes: 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211209102937.584397-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -85,7 +85,7 @@
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
 #define KVM_REQ_TLB_FLUSH_GUEST \
-	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
+	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 


