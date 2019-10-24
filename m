Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F61E32FE
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfJXMuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:50:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54124 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:50:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id n7so1871770wmc.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1TXdc1CmrZ/ckjcWcEzqehZfZHfUvN6n3zMEabAraTw=;
        b=ur0hIhaHS4BdmbKFtzUR2LVNQtiRKeeeOyey48YVQHGZaNkzjCCNc6ogOitBuVa6sZ
         h4usvwExHTmRxgVBoDUbugA/PQ8Y/wPazr1oYiuqEc7RgqfsX9luMhY1MB622WL3Z90w
         MvE54UbJ8K+27pZf0KcfPeLAWbzwDrlVbVjFXg3qj61pBkxjS1L1cViidemP5+Q1Anel
         suuunUYdWqVXBOzk5IV3bVEFG+aiOq7uhFxxGKm0VHmCa+jzYx1rtQEsUXgmU8hZO7ur
         AomqugCQe5pQZhmIoqzT5bhWWwcMQY3kXftvCHT5QE3Zwy4HvDR0vtWygYxHPXLdo1RN
         wFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1TXdc1CmrZ/ckjcWcEzqehZfZHfUvN6n3zMEabAraTw=;
        b=C0IqUrvLHglAHHNqwaH29ENkLGr2axeSoPtnkCH5hxg/JWFcB5aj3Z7AvzJsxUQmDe
         oPxt+y6emozQ06yv5Uclh2/yqGuuY+5qFeVNv1Vvy1HlKBq7U0AtnyzwPTISIFBHqZ8Z
         ldohp+2qbZMcvee5TsHPSDUi4o8un3tnvVhGBW+4FCrfIxRVm7+gP9YH81/ySslx1ca/
         NE1rkndLe67Sqya6mKr/An4AG27qRnujx8p6hGCXxs8FKM8SpQjnlB/HE9q6Bit09MHR
         IrzXPff8jKwikU4b1miHJMjOfAprRQ1EigSwvHKTUSR1dtDMakcMs5YVnt7RS61pOu2A
         jM2w==
X-Gm-Message-State: APjAAAXfVOKsqL4KEmqqB3gcrG/rYBvEGneUXkSKpZmyYfpdJ8nk777b
        DBRM0LVe/Vo5VuYH4SMxrSSBcz8bgUZve6EO
X-Google-Smtp-Source: APXvYqwS/tObi9zvlpZYOJ7EjaINw6uHItwqALfs5px5Ru7Ai4g9mBoxznjB3+H28c6+8bHpXOub9g==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr2628724wmi.161.1571921401695;
        Thu, 24 Oct 2019 05:50:01 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:50:00 -0700 (PDT)
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
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 47/48] arm64: Use firmware to detect CPUs that are not affected by Spectre-v2
Date:   Thu, 24 Oct 2019 14:48:32 +0200
Message-Id: <20191024124833.4158-48-ard.biesheuvel@linaro.org>
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

[ Upstream commit 517953c2c47f9c00a002f588ac856a5bc70cede3 ]

The SMCCC ARCH_WORKAROUND_1 service can indicate that although the
firmware knows about the Spectre-v2 mitigation, this particular
CPU is not vulnerable, and it is thus not necessary to call
the firmware on this CPU.

Let's use this information to our benefit.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 32 ++++++++++++++------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 55526738ccbc..ca718250d5bd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -190,22 +190,36 @@ static int detect_harden_bp_fw(void)
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		if ((int)res.a0 < 0)
+		switch ((int)res.a0) {
+		case 1:
+			/* Firmware says we're just fine */
+			return 0;
+		case 0:
+			cb = call_hvc_arch_workaround_1;
+			/* This is a guest, no need to patch KVM vectors */
+			smccc_start = NULL;
+			smccc_end = NULL;
+			break;
+		default:
 			return -1;
-		cb = call_hvc_arch_workaround_1;
-		/* This is a guest, no need to patch KVM vectors */
-		smccc_start = NULL;
-		smccc_end = NULL;
+		}
 		break;
 
 	case PSCI_CONDUIT_SMC:
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		if ((int)res.a0 < 0)
+		switch ((int)res.a0) {
+		case 1:
+			/* Firmware says we're just fine */
+			return 0;
+		case 0:
+			cb = call_smc_arch_workaround_1;
+			smccc_start = __smccc_workaround_1_smc_start;
+			smccc_end = __smccc_workaround_1_smc_end;
+			break;
+		default:
 			return -1;
-		cb = call_smc_arch_workaround_1;
-		smccc_start = __smccc_workaround_1_smc_start;
-		smccc_end = __smccc_workaround_1_smc_end;
+		}
 		break;
 
 	default:
-- 
2.20.1

