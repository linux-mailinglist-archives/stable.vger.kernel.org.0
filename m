Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7D26A75A
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgIOOln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB9122264;
        Tue, 15 Sep 2020 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180290;
        bh=gNYG3l4Uosa98MY3NbW9h8s52BgNzrxNf1xRR/0kgrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkrH2SFFX+lKgJOjjP6YJgS3b3l5GUmwc0ab0TJivqDmtaYoItXlDeIxWdQ1DWynS
         Pyul2H8IYi9CkkBU0IVd+XbEWE73guv3IpHJTUjjBFqZfQXvHsTfaa2/Gt/SvOkl74
         7u2X9goWziohxGJdQ9nPcHPKaJ6KJVcgLr8pBHhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.8 157/177] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
Date:   Tue, 15 Sep 2020 16:13:48 +0200
Message-Id: <20200915140701.215952201@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit f6f6195b888c28a0b59ceb0562daff92a2be86c3 upstream.

When kvm_mmu_get_page() gets a page with unsynced children, the spt
pagetable is unsynchronized with the guest pagetable. But the
guest might not issue a "flush" operation on it when the pagetable
entry is changed from zero or other cases. The hypervisor has the
responsibility to synchronize the pagetables.

KVM behaved as above for many years, But commit 8c8560b83390
("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes")
inadvertently included a line of code to change it without giving any
reason in the changelog. It is clear that the commit's intention was to
change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT, so we don't
needlessly flush other contexts; however, one of the hunks changed
a nearby KVM_REQ_MMU_SYNC instead.  This patch changes it back.

Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20200902135421.31158-1-jiangshanlai@gmail.com>
fixes: 8c8560b83390 ("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2521,7 +2521,7 @@ static struct kvm_mmu_page *kvm_mmu_get_
 		}
 
 		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 
 		__clear_sp_write_flooding_count(sp);
 		trace_kvm_mmu_get_page(sp, false);


