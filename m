Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922CC469EB0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386000AbhLFPnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388714AbhLFPei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:34:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DBFC07E5F3;
        Mon,  6 Dec 2021 07:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBB0B810AC;
        Mon,  6 Dec 2021 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65792C341C2;
        Mon,  6 Dec 2021 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804029;
        bh=kuNp9ksckLFnCMGd4ARqguiLs+L5cN445axbRFPQAqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vElZc2BnvN0cohfJymNPQ6GETOZo7WhwTpeJ8oYf3HH62dpZjbK3ff+VDCO2ULmDM
         rTc4l1XkMRUZn3QhWZHewtOm728nOB58Xr3rXaxEfMc10lT6FrBW0WZ0RpH+CKOcrW
         DqKsSyg+mCm3bdZe+nD9CtGRJvT9oxgY/fyFQPUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/130] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register
Date:   Mon,  6 Dec 2021 15:57:00 +0100
Message-Id: <20211206145603.200409455@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit cb1d220da0faa5ca0deb93449aff953f0c2cce6d ]

If we run the following perf command in an AMD Milan guest:

  perf stat \
  -e cpu/event=0x1d0/ \
  -e cpu/event=0x1c7/ \
  -e cpu/umask=0x1f,event=0x18e/ \
  -e cpu/umask=0x7,event=0x18e/ \
  -e cpu/umask=0x18,event=0x18e/ \
  ./workload

dmesg will report a #GP warning from an unchecked MSR access
error on MSR_F15H_PERF_CTLx.

This is because according to APM (Revision: 4.03) Figure 13-7,
the bits [35:32] of AMD PerfEvtSeln register is a part of the
event select encoding, which extends the EVENT_SELECT field
from 8 bits to 12 bits.

Opportunistically update pmu->reserved_bits for reserved bit 19.

Reported-by: Jim Mattson <jmattson@google.com>
Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20211118130320.95997-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 035da07500e8b..5a5c165a30ed1 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -274,7 +274,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
-	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-- 
2.33.0



