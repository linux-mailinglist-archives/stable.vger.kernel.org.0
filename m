Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6C426902
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbhJHLdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240891AbhJHLcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87B361073;
        Fri,  8 Oct 2021 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692615;
        bh=X7Jx8wRftHR4Xx+n+Ynd+iY4sJtTY0t/te8BqMaAYzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gVXmkLitALpvcJUle28VaCkjAm6m0PaEf9nsWehsd/y7aXHxJcPPtVN6rE2eTH/E
         hlDERs+gjmwKStwKSaK4Wr1X7LsDqQVLPy3hmfmekIveBYF9346uEEliMUYhO+CYIQ
         5repCwXik6KD2Bl4ci5ZxYonbjcWfNRcrR7CTF8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fares Mehanna <faresx@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/16] kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
Date:   Fri,  8 Oct 2021 13:28:03 +0200
Message-Id: <20211008112715.907701710@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
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
index eed058529e4b..dfd70ed34f88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1239,6 +1239,13 @@ static const u32 msrs_to_save_all[] = {
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



