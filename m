Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FF431683
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhJRKyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhJRKyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 06:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634554356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mxMuVhTXpiGknTe7DXuPL8kxDD5PjBKCi+ZHV2Oflr0=;
        b=htK5wcLEzzKjaNcANtDMlAk3pTUpvNyY9l1rP3i+G8Bme0vTJi8w7jGYSWXr4/DmWBsdHz
        YlIurbTU3DCJsVmXmq6WYnv4wllCJWdwpb3ghEwfk8S360L9t8kVQUTTYqLPPUfqXOGlSN
        ImImnOLZcQvGeaRQPN3y6KGrKyu5JJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-AfcqGGkAMveA0_IaFPmhWg-1; Mon, 18 Oct 2021 06:52:33 -0400
X-MC-Unique: AfcqGGkAMveA0_IaFPmhWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F5F8801FCE;
        Mon, 18 Oct 2021 10:52:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E6F55DF35;
        Mon, 18 Oct 2021 10:52:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] KVM: SEV-ES: reduce ghcb_sa_len to 32 bits
Date:   Mon, 18 Oct 2021 06:52:31 -0400
Message-Id: <20211018105231.517041-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The size of the GHCB scratch area is limited to 16 KiB (GHCB_SCRATCH_AREA_LIMIT),
so there is no need for it to be a u64.  This fixes a build error on 32-bit
systems:

i686-linux-gnu-ld: arch/x86/kvm/svm/sev.o: in function `sev_es_string_io:
sev.c:(.text+0x110f): undefined reference to `__udivdi3'

Cc: stable@vger.kernel.org
Fixes: 019057bd73d1 ("KVM: SEV-ES: fix length of string I/O")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 128a54b1fbf1..5d30db599e10 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -191,7 +191,7 @@ struct vcpu_svm {
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-	u64 ghcb_sa_len;
+	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
 
-- 
2.27.0

