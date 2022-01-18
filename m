Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C2E492244
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiARJLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:11:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240613AbiARJLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642497074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5WM6aSgMEUPDUvG4gi53DpH/0+iConiV9ZypXmxT9Rw=;
        b=PisFq5NIbaZdrIub0lyRwlT6vHeUAaoAKDh1MzxRA404INCKs+lu/yxPqWtpK4NndrGTza
        Arh8zeakAJQXVCUJLDFWB4a8geUfWbpdMyB/bJ/JQu+M+BLSGLc/yVOroX/wgFGhpSLx+q
        DNriZOdQI+JrYPoicxvLpLJaxej3vsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-RB33bWRqODqXfEu6oc5J8A-1; Tue, 18 Jan 2022 04:11:09 -0500
X-MC-Unique: RB33bWRqODqXfEu6oc5J8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B168C1853026;
        Tue, 18 Jan 2022 09:11:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 442637B9D9;
        Tue, 18 Jan 2022 09:11:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Wei Wang <wei.w.wang@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH stable] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Date:   Tue, 18 Jan 2022 04:11:07 -0500
Message-Id: <20220118091107.1007603-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

[ upstream commit 9fb12fe5b93b94b9e607509ba461e17f4cc6a264 ]

The fixed counter 3 is used for the Topdown metrics, which hasn't been
enabled for KVM guests. Userspace accessing to it will fail as it's not
included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
which have this counter.

To reproduce it on ICX+ machines, ./state_test reports:
==== Test Assertion Failure ====
lib/x86_64/processor.c:1078: r == nmsrs
pid=4564 tid=4564 - Argument list too long
1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
3  0x00007fbe21ed5f92: ?? ??:0
4  0x000000000040264d: _start at ??:?
 Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)

With this patch, it works well.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Message-Id: <20211217124934.32893-1-wei.w.wang@intel.com>
Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]")
Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a2972fdae82..d490b83d640c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1331,7 +1331,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
-- 
2.31.1

