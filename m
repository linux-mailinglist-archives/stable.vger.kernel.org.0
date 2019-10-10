Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95CAD2B1C
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387664AbfJJNTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:19:50 -0400
Received: from foss.arm.com ([217.140.110.172]:59336 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbfJJNTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 09:19:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2F21337;
        Thu, 10 Oct 2019 06:19:49 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CB26D3F68E;
        Thu, 10 Oct 2019 06:19:48 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com
Subject: [PATCH] arm64: cpufeature: Fix truncating a feature value
Date:   Thu, 10 Oct 2019 14:19:43 +0100
Message-Id: <20191010131943.26822-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010122922.GA720144@kroah.com>
References: <20191010122922.GA720144@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A signed feature value is truncated to turn to an unsigned value
causing bad state in the system wide infrastructure. This affects
the discovery of FP/ASIMD support on arm64. Fix this by making sure
we cast it properly.

This was inadvertently fixed upstream in v4.6 onwards with the following :
commit 28c5dcb22f90113dea ("arm64: Rename cpuid_feature field extract routines")

Cc: stable@vger.kernel.org # v4.4
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 0a66f8241f18..9eb0d8072dd9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -151,8 +151,8 @@ static inline u64 arm64_ftr_mask(struct arm64_ftr_bits *ftrp)
 static inline s64 arm64_ftr_value(struct arm64_ftr_bits *ftrp, u64 val)
 {
 	return ftrp->sign ?
-		cpuid_feature_extract_field_width(val, ftrp->shift, ftrp->width) :
-		cpuid_feature_extract_unsigned_field_width(val, ftrp->shift, ftrp->width);
+		(s64)cpuid_feature_extract_field_width(val, ftrp->shift, ftrp->width) :
+		(s64)cpuid_feature_extract_unsigned_field_width(val, ftrp->shift, ftrp->width);
 }
 
 static inline bool id_aa64mmfr0_mixed_endian_el0(u64 mmfr0)
-- 
2.21.0

