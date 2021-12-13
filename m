Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59172472952
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhLMKTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244592AbhLMKRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:17:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D07C0497E6;
        Mon, 13 Dec 2021 01:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CCB3CE0E7D;
        Mon, 13 Dec 2021 09:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47441C34600;
        Mon, 13 Dec 2021 09:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389369;
        bh=mKHCXicf19xPmySre5FDtPftDZOtqQDIyzgkI5JYAGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb/2nlhKQ8wplH3dzX3tf3XYL1oBhcJXcQydQ6Usl24YaBB45t4u0v0idMqcSs6SP
         cRRMOLzQuyo1yXX7O1fBNrKz2lSSf1BdMG0KRJPjtc477i9JigRFcven7AjFb0TcD4
         G2uj0bNLJeGZY5PV+eTn11bTTMjYttNDz1yoK4lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 059/171] KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall
Date:   Mon, 13 Dec 2021 10:29:34 +0100
Message-Id: <20211213092947.065183117@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -98,7 +98,7 @@
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
 #define KVM_REQ_TLB_FLUSH_GUEST \
-	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
+	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \


