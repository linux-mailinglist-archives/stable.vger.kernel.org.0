Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAA31EFAD
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhBRTVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhBRSma (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 13:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613673662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xkv4a0vVqkxWE+KTiUndwxwK5nqHjhjL33RCnSzbN+g=;
        b=cAHqGXQ/YjBYtBhpr+GR2ZkywUDqVORR0Y+1T5yQwfa4J8febNWJExvGNrPvmXvOegg63n
        6P+Kzx/YNGjqWMVfF81Sgkvdfi+wjwkQTT0seoMqLZsZQ9yOu4uHxhvr2a7IjcUD08XBYh
        eyND2VJgLZGpxVBOHraJW2tvSAurRts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-VMvTpPzIO9qoXdQ5eIK9WA-1; Thu, 18 Feb 2021 13:41:00 -0500
X-MC-Unique: VMvTpPzIO9qoXdQ5eIK9WA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0050018449E1;
        Thu, 18 Feb 2021 18:40:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B046F1042989;
        Thu, 18 Feb 2021 18:40:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>
Subject: [PATCH] KVM: SEV: fix double locking due to incorrect backport
Date:   Thu, 18 Feb 2021 13:40:58 -0500
Message-Id: <20210218184058.1420763-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix an incorrect line in the 5.4.y and 4.19.y backports of commit
19a23da53932bc ("Fix unsynchronized access to sev members through
svm_register_enc_region"), first applied to 5.4.98 and 4.19.176.

Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
Reported-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # 5.4.x
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 296b0d7570d0..1da558f28aa5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7104,7 +7104,6 @@ static int svm_register_enc_region(struct kvm *kvm,
 	region->uaddr = range->addr;
 	region->size = range->size;
 
-	mutex_lock(&kvm->lock);
 	list_add_tail(&region->list, &sev->regions_list);
 	mutex_unlock(&kvm->lock);
 
-- 
2.26.2

