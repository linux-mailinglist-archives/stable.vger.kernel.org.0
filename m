Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0935AEBA
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhDJPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234844AbhDJPMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OrBtVD1Y0D9odrfgzq64Weq+qeRKDVw+tz4kVEzyGlo=;
        b=Y5RNHqtsOCFGhkK1xUKROu/yZK2exZeQJc9SWkTpF3S5ttWR2/IekgI/u2WuzM0a7egnuC
        TyxBt1mXTzjpVZLrBvLQQ7o5atA3FOc/muPeIFged9rCHBmQOm1+fwgUf2PSpDlSG+LKhY
        4iEl7cCXu96URhq69txv68mYPyonHYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-F57BZBvePtmA8XJrbBy7VA-1; Sat, 10 Apr 2021 11:12:35 -0400
X-MC-Unique: F57BZBvePtmA8XJrbBy7VA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A6EC107ACF4;
        Sat, 10 Apr 2021 15:12:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEAEC5D9D3;
        Sat, 10 Apr 2021 15:12:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 9/9] KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp
Date:   Sat, 10 Apr 2021 11:12:29 -0400
Message-Id: <20210410151229.4062930-10-pbonzini@redhat.com>
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 315f02c60d9425b38eb8ad7f21b8a35e40db23f9 ]

Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
will skip the TLB flush, which is wrong.  There are two ways to fix
it:

- since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
  the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
  use "flush |= ..."

- or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
  to __kvm_tdp_mmu_zap_gfn_range.  Note that kvm_tdp_mmu_zap_sp will
  neither yield nor flush, so flush would never go from true to
  false.

This patch does the former to simplify application to stable kernels,
and to make it further clearer that kvm_tdp_mmu_zap_sp will not flush.

Cc: seanjc@google.com
Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
Cc: <stable@vger.kernel.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 387dca3f81cd..86cedf32526a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6007,7 +6007,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (sp->tdp_mmu_page) {
-			flush = kvm_tdp_mmu_zap_sp(kvm, sp);
+			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
-- 
2.26.2

