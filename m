Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1834869F1
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405037AbfHHTLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405432AbfHHTLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C102189D;
        Thu,  8 Aug 2019 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291470;
        bh=1JmtSuEEbFURk9cb8GNhQDlYrEA99dP6Nu8iiDUHtRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4bEztXGj3Ek6+AbnG82xFIO+68z/Te/7KW6trUePZ1rjEoC5KGtSo3Tz7vUWUdn4
         4UBXiKW9YsDp/Bv22AfVrXIDu8Rx7Uf66JQW1g4Ay830mrurenx/0HUzUhNSQzd+O6
         aLalj0ENSnEyG+fG994S8opyFUW88RwQ8T8vkJOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.14 05/33] arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}
Date:   Thu,  8 Aug 2019 21:05:12 +0200
Message-Id: <20190808190453.833416677@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 147b9635e6347104b91f48ca9dca61eb0fbf2a54 upstream.

If CTR_EL0.{CWG,ERG} are 0b0000 then they must be interpreted to have
their architecturally maximum values, which defeats the use of
FTR_HIGHER_SAFE when sanitising CPU ID registers on heterogeneous
machines.

Introduce FTR_HIGHER_OR_ZERO_SAFE so that these fields effectively
saturate at zero.

Fixes: 3c739b571084 ("arm64: Keep track of CPU feature registers")
Cc: <stable@vger.kernel.org> # 4.4.x-
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    7 ++++---
 arch/arm64/kernel/cpufeature.c      |    8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -44,9 +44,10 @@
  */
 
 enum ftr_type {
-	FTR_EXACT,	/* Use a predefined safe value */
-	FTR_LOWER_SAFE,	/* Smaller value is safe */
-	FTR_HIGHER_SAFE,/* Bigger value is safe */
+	FTR_EXACT,			/* Use a predefined safe value */
+	FTR_LOWER_SAFE,			/* Smaller value is safe */
+	FTR_HIGHER_SAFE,		/* Bigger value is safe */
+	FTR_HIGHER_OR_ZERO_SAFE,	/* Bigger value is safe, but 0 is biggest */
 };
 
 #define FTR_STRICT	true	/* SANITY check strict matching required */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -178,8 +178,8 @@ static const struct arm64_ftr_bits ftr_c
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),		/* RES1 */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, 24, 4, 0),	/* CWG */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, 20, 4, 0),	/* ERG */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMINLINE_SHIFT, 4, 1),
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
@@ -411,6 +411,10 @@ static s64 arm64_ftr_safe_value(const st
 	case FTR_LOWER_SAFE:
 		ret = new < cur ? new : cur;
 		break;
+	case FTR_HIGHER_OR_ZERO_SAFE:
+		if (!cur || !new)
+			break;
+		/* Fallthrough */
 	case FTR_HIGHER_SAFE:
 		ret = new > cur ? new : cur;
 		break;


