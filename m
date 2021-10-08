Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A942426950
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbhJHLgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241753AbhJHLeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B3B611BD;
        Fri,  8 Oct 2021 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692682;
        bh=UTIksFZ/MVVulgMzv7PvbTx6m1WaAdVQ2Bym5ITvEpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN++Ivr//lPUTnNOdYwudVfxIQx6JkqgeOZ5t5qSsunNsFQNadJQWojdjUnL8dJqg
         0I9u7wGoJVFYPdBMHt9UlON49jCxJfinoJe2SRz2giBigXZMPaPM+N6U8M85BCwGup
         TUYLM4uLiGOQA1D7t3RkXa2zOM3EWxqJITTC6lXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fares Mehanna <faresx@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/29] kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
Date:   Fri,  8 Oct 2021 13:28:13 +0200
Message-Id: <20211008112717.844426362@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fares Mehanna <faresx@amazon.de>

[ Upstream commit e1fc1553cd78292ab3521c94c9dd6e3e70e606a1 ]

Intel PMU MSRs is in msrs_to_save_all[], so add AMD PMU MSRs to have a
consistent behavior between Intel and AMD when using KVM_GET_MSRS,
KVM_SET_MSRS or KVM_GET_MSR_INDEX_LIST.

We have to add legacy and new MSRs to handle guests running without
X86_FEATURE_PERFCTR_CORE.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
Message-Id: <20210915133951.22389-1-faresx@amazon.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c031d256028..997e32729919 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1250,6 +1250,13 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
+	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
+	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
+	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
+	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
+	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
-- 
2.33.0



