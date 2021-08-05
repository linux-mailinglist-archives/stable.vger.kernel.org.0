Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D2B3E1349
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbhHEKym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:54:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhHEKyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 06:54:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628160867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNh464kHQ9hh2xtU0nEA+dod0fBOCqP6+88RFXNitZg=;
        b=MV3iticZLBRso9i5m1GClALJcDO7SghSEgm/wPtQGryKwHrbbRxBQ9ZHwa/ssmCwvMxrrw
        fsF6vEysEh17rDIwsCtLHAuvMF+Dfx8LSNebUYd9vlGIWQcYED6wdxChjq1TYBJcxfX70w
        Ir69+KstQfd3inHDBW8ryhbjcIN2cIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-GQ6e45K_NQCjW6LbF9quYg-1; Thu, 05 Aug 2021 06:54:26 -0400
X-MC-Unique: GQ6e45K_NQCjW6LbF9quYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FC318C89CF;
        Thu,  5 Aug 2021 10:54:25 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F62660BF4;
        Thu,  5 Aug 2021 10:54:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] selftests: KVM: avoid failures due to reserved HyperTransport region
Date:   Thu,  5 Aug 2021 06:54:23 -0400
Message-Id: <20210805105423.412878-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Accessing guest physical addresses at 0xFFFD_0000_0000 and above causes
a failure on AMD processors because those addresses are reserved by
HyperTransport (this is not documented).  Avoid selftests failures
by reserving those guest physical addresses.

Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..d995cc9836ee 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -309,6 +309,12 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
 
+#ifdef __x86_64__
+	/* Avoid reserved HyperTransport region on AMD processors.  */
+	if (vm->pa_bits == 48)
+		vm->max_gfn = 0xfffcfffff;
+#endif
+
 	/* Allocate and setup memory for guest. */
 	vm->vpages_mapped = sparsebit_alloc();
 	if (phy_pages != 0)
-- 
2.27.0

