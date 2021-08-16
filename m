Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044613ED88E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhHPODi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:03:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236822AbhHPOD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iFJ3MDxFhfMHNqGYtE18omfSdS7OGGUx4KQVnZGWyvE=;
        b=ZmdRgOby1HoGMZStIv71jjZ0ijM0nIE2Mn50Q9SlE5cqCRb3xX7RVbBDJFn5zI+MLS7NKJ
        GJSCgp/1G2OCQt2MG879GNf/+Q0K6ncB+m//YPjXRRsk8CGNhwUGCn8Rpef1cEf+MWMko2
        Wcp/p5nPRvhhgO100FnWHsJ4EcHhQMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-DL0CUimAPWavEvgAHlI5lw-1; Mon, 16 Aug 2021 10:02:55 -0400
X-MC-Unique: DL0CUimAPWavEvgAHlI5lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F26D4C7400;
        Mon, 16 Aug 2021 14:02:54 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.192.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 848275C23A;
        Mon, 16 Aug 2021 14:02:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4.14.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
Date:   Mon, 16 Aug 2021 16:02:36 +0200
Message-Id: <20210816140240.11399-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
	The above upstream SHA1 is still on its way to Linus

 arch/x86/kvm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0dfd0af61a29..439aecbbdd1e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -389,6 +389,9 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_dr = h->intercept_dr | g->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
 	c->intercept = h->intercept | g->intercept;
+
+	c->intercept |= (1ULL << INTERCEPT_VMLOAD);
+	c->intercept |= (1ULL << INTERCEPT_VMSAVE);
 }
 
 static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
-- 
2.26.3

