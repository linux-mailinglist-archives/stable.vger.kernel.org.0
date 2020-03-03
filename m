Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1888D177F7B
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgCCRvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgCCRvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9591206D5;
        Tue,  3 Mar 2020 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257863;
        bh=16/CDgw9bB9NzOqtiCQpSAhhmpGhnuFWFlGfJzgLz4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyoEX01qtMFl8UdLcuiqof1gYgaYMEW8ZCZ0wrO8KlNxmmjRf1eA0TyHu/3AwVmeX
         bexaqzCJwDkMTtWIc8tnRIcg0hQuAlOyPIxAUlVt+wyuS/Vugp6x8z5Kn6HgfqxCG4
         zcGD5G/8JGOG6izkzLtPHtZwBcMrVyNifxb1QaJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 157/176] KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
Date:   Tue,  3 Mar 2020 18:43:41 +0100
Message-Id: <20200303174322.601602716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit b4b2963616bbd91ebb33148522552e1135de56ae upstream.

The 3rd parameter of kvm_apic_match_dest() is the irq shorthand,
rather than the irq delivery mode.

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1150,7 +1150,7 @@ void kvm_bitmap_or_dest_vcpus(struct kvm
 			if (!kvm_apic_present(vcpu))
 				continue;
 			if (!kvm_apic_match_dest(vcpu, NULL,
-						 irq->delivery_mode,
+						 irq->shorthand,
 						 irq->dest_id,
 						 irq->dest_mode))
 				continue;


