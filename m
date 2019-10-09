Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546EDD0A91
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfJIJKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:10:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46258 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfJIJKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:10:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so1807749wrv.13
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 02:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCrmgHAYyN01zImuc4jM3+YjfFk8WqaqST+K93RrRPI=;
        b=aHPpp37gGvNg0nvaZ/nYY6FA+Sj6SjnkUMtVql8ZZ9qQPbLPfpm9io6flZlZaeuKb0
         Vtu0C44AW+EqajGTv61u3/g3nd6TklwAgeadO+Eqsty9SEBdIL61px9U2FAbNQ9vss/1
         YJeXnhwgOxO5W5CIzWWbfOukwRiicYxO7rL0mYPjUW3211HaSMoPH5A8c/qPvxq2sFM7
         asjt8UxJe1wsOWIUK5oaPZGDNLzvXg9dtlPuWW83i1sOmMumxyZDBItMBzZo33pr++75
         +lAh+UVBT6ouCaAWhx/jOwy7CQuv9qO5XHoDATg40TkiMxa7hDfAYm7PmhzE6xJ4Fs9d
         PXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCrmgHAYyN01zImuc4jM3+YjfFk8WqaqST+K93RrRPI=;
        b=kHRcbGuEQmYPK4Nj4uStEBR4gNDVKNwtL91O2VbSRJCpwSGCSI82ZtKB6tvrbZhYU2
         wUoj5N46QoSHuioq02s7hlKGX3dq9lSe4hNXb+9SGW6UfgYe9U7efXo2uRxpkHsUNnDJ
         3GY2IbwALu6aLT8svzUed+03HACD6bqBNEoRkbILAbLvpVhBI3mnFHFYu+B9wdgA/vuH
         C9N5JHcx8jMJ8fsK57d1t+4i9rE1qLvO1AWVxV46/v2ThJWI43UpTGCJrtEHrpzl4EBh
         8Qx955FYYPnIBauMxAWPWIBEXT8pgWnNWtfZhgDVHnRiNYAj1Tr4AFC9JShdfmMJOzoH
         wHsA==
X-Gm-Message-State: APjAAAUxIZFzlE/u5TP8OCl5ckRyB24lhSNZCgVk4Eztvcwg4lFEZwKW
        t5cBrGyPNG5M9R53bJSrseCl9bsnOfp5cRO7
X-Google-Smtp-Source: APXvYqxpC3+GkEllmO9m5q20onMePeHudgFz896maHlLzGhOqZ9naSN8fNaOtt2tPZ6VeRvJwThZkg==
X-Received: by 2002:a5d:4a87:: with SMTP id o7mr2078466wrq.374.1570612241004;
        Wed, 09 Oct 2019 02:10:41 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ed77:413c:ec9e:7229])
        by smtp.gmail.com with ESMTPSA id b15sm1309183wmb.28.2019.10.09.02.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:10:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-4.19] arm64: Use firmware to detect CPUs that are not affected by Spectre-v2
Date:   Wed,  9 Oct 2019 11:10:23 +0200
Message-Id: <20191009091023.19336-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
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
index a9ad932160cc..c623b58a7e2b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -198,22 +198,36 @@ static int detect_harden_bp_fw(void)
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

