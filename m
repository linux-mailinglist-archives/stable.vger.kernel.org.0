Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA35E32EA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502113AbfJXMtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40587 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502111AbfJXMtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so1306612wmm.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bn5xGW9Dm+/jGdh0DNWtC1DwAKZpmDxLKIpavICJQ1s=;
        b=oe1GlQKt6KtQTGHoVB8cc+TILiFRP9d2PBW2WSP7Kb5JCdxAatdxlpODmWS7YOqk7M
         bHBUgOdoY8vyPuLxvQdXYzAk2+A/6IiLO77CagWWP4BHNwy1oEOmkd+1nP3Y6LmBF1ih
         VJWetC4Ray2bkqszc1o+e4CQ/ZkDtJT259CCyGi+kyG2aHd7XGfZoNVJVFsP9I9ebKdh
         NzDC9kFmOB9PL9BL7yAz1e6zmB8fwtpt7RAYLzTcdcPzgvtRU8slLls3NK6eJ6t/wzB6
         h1XD1A9l7/1Y/cmqDH1IBrMwSGD4IZ3LQqa7uBty2x4LuB9qLyFh+r4lz6bAQPtltsuY
         zTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bn5xGW9Dm+/jGdh0DNWtC1DwAKZpmDxLKIpavICJQ1s=;
        b=E06laOQpXBDqnWQ7+Id24dXRSOsEQH5JUcp152X9oLiqSVzhOAcLzRtRIxyO+/7v00
         BBFuklL/SaHZbSc/MQM0xZbZlTM23VHW8O+PRwUMSkO7GXSFBNWOU6jgugaqLs8yxuUd
         8tsBSMbv3Z+5++YLmpzR7vFweU/DUHQ/pdk46SFEwKbVjH9aFNqbyzdFYxsRxBhnzKGQ
         wRvaJf+vrLq8zZnkui3U1AONV8dswsFPhTOIhZO4OqJmAR8sed/Nxroc+WoVNBx5vgwx
         FqkHU3ZNZA+4zCgaWBxZFzuO8aZhrII99X6bqCqDWq+7O1js8nx/gDG/Tjo17PNZkReC
         zZjg==
X-Gm-Message-State: APjAAAW0Nag5DGFYD535YKoQS19i08d1jKyGjwh/3NY86F2HhTcgKfEF
        voa79fRBQ4eDqzLAS3Cf1Ap1I2hSXRbZ0XuP
X-Google-Smtp-Source: APXvYqyEzjLfdKPovXVQcZnwTVa0Sodmu88Z462Qb8ejWed3XzbluHMNlmyE7ol0u9rQBtGB8+mEJA==
X-Received: by 2002:a05:600c:2943:: with SMTP id n3mr4633489wmd.11.1571921378242;
        Thu, 24 Oct 2019 05:49:38 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 31/48] arm64: Get rid of __smccc_workaround_1_hvc_*
Date:   Thu, 24 Oct 2019 14:48:16 +0200
Message-Id: <20191024124833.4158-32-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 22765f30dbaf1118c6ff0fcb8b99c9f2b4d396d5 ]

The very existence of __smccc_workaround_1_hvc_* is a thinko, as
KVM will never use a HVC call to perform the branch prediction
invalidation. Even as a nested hypervisor, it would use an SMC
instruction.

Let's get rid of it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/bpi.S        | 12 ++----------
 arch/arm64/kernel/cpu_errata.c |  9 +++------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 0af46cfdbbf3..4cae34e5a24e 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -56,21 +56,13 @@ ENTRY(__bp_harden_hyp_vecs_start)
 ENTRY(__bp_harden_hyp_vecs_end)
 
 
-.macro smccc_workaround_1 inst
+ENTRY(__smccc_workaround_1_smc_start)
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
 	stp	x0, x1, [sp, #(8 * 2)]
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
-	\inst	#0
+	smc	#0
 	ldp	x2, x3, [sp, #(8 * 0)]
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
-.endm
-
-ENTRY(__smccc_workaround_1_smc_start)
-	smccc_workaround_1	smc
 ENTRY(__smccc_workaround_1_smc_end)
-
-ENTRY(__smccc_workaround_1_hvc_start)
-	smccc_workaround_1	hvc
-ENTRY(__smccc_workaround_1_hvc_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 4204b668df7a..6e565d8d4f71 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -85,8 +85,6 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 #ifdef CONFIG_KVM
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
-extern char __smccc_workaround_1_hvc_start[];
-extern char __smccc_workaround_1_hvc_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -131,8 +129,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 #else
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
-#define __smccc_workaround_1_hvc_start		NULL
-#define __smccc_workaround_1_hvc_end		NULL
 
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
@@ -206,8 +202,9 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 		if ((int)res.a0 < 0)
 			return;
 		cb = call_hvc_arch_workaround_1;
-		smccc_start = __smccc_workaround_1_hvc_start;
-		smccc_end = __smccc_workaround_1_hvc_end;
+		/* This is a guest, no need to patch KVM vectors */
+		smccc_start = NULL;
+		smccc_end = NULL;
 		break;
 
 	case PSCI_CONDUIT_SMC:
-- 
2.20.1

