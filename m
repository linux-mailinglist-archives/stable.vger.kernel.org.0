Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBCB3EDA15
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhHPPoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233194AbhHPPoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 11:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gEcIT3BrsKV6yWl8vLCYfg0HOzxnN0El9ObtH3hmHKg=;
        b=QSLTJbp2key45oRJ4Tz/KTwUCbdYtOU4IrSKrO04xULDFcv7GJNPjBBqjNVLlsEkImwAh2
        jDk5YXkbrHxmELE41m3mbeVPU2pTNK7CDLdrLzCTYSoloTNREo4HQWmhAnuSyEr3elHbOL
        fVoGD4EFHc4omTt+yeycaJcgmdFqaFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-WBErmc-XMKKfaBlmlnQKGg-1; Mon, 16 Aug 2021 11:43:31 -0400
X-MC-Unique: WBErmc-XMKKfaBlmlnQKGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EA9D1008065;
        Mon, 16 Aug 2021 15:43:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61AF7100EBB0;
        Mon, 16 Aug 2021 15:43:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.13.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
Date:   Mon, 16 Aug 2021 11:43:28 -0400
Message-Id: <20210816154328.3845839-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ upstream commit c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc ]

If L1 disables VMLOAD/VMSAVE intercepts, and doesn't enable
Virtual VMLOAD/VMSAVE (currently not supported for the nested hypervisor),
then VMLOAD/VMSAVE must operate on the L1 physical memory, which is only
possible by making L0 intercept these instructions.

Failure to do so allowed the nested guest to run VMLOAD/VMSAVE unintercepted,
and thus read/write portions of the host physical memory.

Fixes: 89c8a4984fc9 ("KVM: SVM: Enable Virtual VMLOAD VMSAVE feature")

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7f3b55561ae8..61f418644235 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -149,6 +149,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		c->intercepts[i] |= g->intercepts[i];
+
+	vmcb_set_intercept(c, INTERCEPT_VMLOAD);
+	vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 }
 
 static void copy_vmcb_control_area(struct vmcb_control_area *dst,
-- 
2.27.0

