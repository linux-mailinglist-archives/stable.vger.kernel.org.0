Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920AF355921
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhDFQ0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 12:26:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbhDFQ0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 12:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617726354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P7jEwhs3YhOUrc296WlQw+XsxeekSJAI8Ujivs9g9oE=;
        b=T9T2e1COY+9z8FeWseITXuevS+NHC1FE+VX1UhrlO5+6VuoTSgJ1vrRwZXO5oEV48E+urx
        KyucaSaI8wYSt7q9KTtAyKNo0tGc5SuHhoZmLrSMqHZLcUrkhZZpPIAmzGyd+dlg28ph/b
        IcDzUbONdY+1RvqCzZlC6EfKoUn60wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-v_K6orFjMZOwmJxfQNqNzQ-1; Tue, 06 Apr 2021 12:25:52 -0400
X-MC-Unique: v_K6orFjMZOwmJxfQNqNzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE7E51005D4F;
        Tue,  6 Apr 2021 16:25:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 768F25D9DC;
        Tue,  6 Apr 2021 16:25:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to kvm_tdp_mmu_zap_sp
Date:   Tue,  6 Apr 2021 12:25:50 -0400
Message-Id: <20210406162550.3732490-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
will skip the TLB flush, which is wrong.  There are two ways to fix
it:

- since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
  the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
  use "flush |= ..."

- or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
  to __kvm_tdp_mmu_zap_gfn_range.

This patch does the former to simplify application to stable kernels.

Cc: seanjc@google.com
Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
Cc: <stable@vger.kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 486aa94ecf1d..951dae4e7175 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5906,7 +5906,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
-			flush = kvm_tdp_mmu_zap_sp(kvm, sp);
+			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
-- 
2.26.2

