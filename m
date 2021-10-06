Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA1E423C40
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhJFLOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238343AbhJFLOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E318611C5;
        Wed,  6 Oct 2021 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518762;
        bh=0WJwpk70JlUtzeH2V3Gk8E+EDZOjgTE79bmfvCAOkDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBGNaHh9sg38AKkxpuqcdwSuxhXyi7qbwcQRCxSizT2NsNCXFaXRi0TgCuS+ijPsb
         bB8Eof6hj60hAl+3mwqU/hQE3SZ4QB4ivvknVA5tEf01beAEBkJIbUMTWEDlYigNuT
         O62l2Rpcvxz5iIZ0Jr0cbpXIq2rHHuDdoFOvRKrRoWBLY3GuzMLVlZFL2NZT3cVR4E
         OjBSOPVjM+0Ui6yHESI7/CntVJR0v7X/akABnJRS3Ee4RX9X1dHreRiw/NiRYy7ESS
         KBsv/chf9ojiesX/fGBeZaS9BSDOd7Sb9s2LQGJ4bTglTW5fvRjFI0OU88htsSzSPu
         hPPmEssYy8akw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fares Mehanna <faresx@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 5/7] kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
Date:   Wed,  6 Oct 2021 07:12:31 -0400
Message-Id: <20211006111234.264020-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006111234.264020-1-sashal@kernel.org>
References: <20211006111234.264020-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d65da3b5837b..b885063dc393 100644
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

