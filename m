Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA24E32E6
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502106AbfJXMtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40576 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502111AbfJXMtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so1306314wmm.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iH5ScDlNm2VFRLMaaO2Sqe3ThsWOiflSACcQzmSoM8w=;
        b=eZoJfXp+/10GbeXcIEIPwWN9yVSLaInOBHTMOyrydvHnh4CPncPQ3qS7uSZw99Lb88
         D9/2ufoJRjmlFe6iJR0Lc7AoFeq5Dwgx+/OTpczefbbwbVIFsB+1lAVNgCurkteQALoy
         oLwtW+XECd91hkUrEwTfbt9FZOprTUkAACHciDtPvEG/SKyTff6SLn2lQT6VD83kKkbn
         5fRVWYE3IMgHSJw+/bL8iMjkbwE9toGvsTCPvO4LiS2LPJoPpxkCLxwLtls5sGyTRyKv
         JAqIqKdNpPetBRvFohdsKvSEk9O2z2sUszSLDtDLBO2YCzr8bN3iAwxhuNmsLTiV5K7E
         nDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iH5ScDlNm2VFRLMaaO2Sqe3ThsWOiflSACcQzmSoM8w=;
        b=l/0xzVW284b5bCr18W03F1XfPM9pH1sHB1/TDjdKPpI+AliYnFAzutasCHBa4IRyzU
         9lN+hr3BSueiPiId2VzIiLpOyjPGIjU651hOLoaY6DgyABPYgUZANQycphB5nl+6R/tH
         kuZKZrF+NvUjot1t+eGdyHQwyi0eanpYjuoCUj/yXAcR0rekXMX34oWs8B5O0WapYxh8
         g8YH9at7HsKJbJnqNSpTodFtY399HXRrqBraTwL7LEZm2XjrkF73hMKd1tPl9fsVaGVM
         MBHA7yuiRm2WKj+rWZmVwoJybHIhznV2awkNFKrNdMO7q84pb8RQqicL6IsVqwRWUnU8
         hNpg==
X-Gm-Message-State: APjAAAWt4fvMKbIa/tQswpIHXJUw4BojlwHAtzZfMy3fOOW9mdhHtq5D
        Iomw/UXapRQl9LMMJutFW3q5NXUSN0/80FC2
X-Google-Smtp-Source: APXvYqzE6XKosqO/1ix2S8XbFeL1BxjEgOMZP1Hg1xbTeLuaGWgleQaP9bpveP19cPgi8SNHt/qSUw==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr2627016wmi.161.1571921372479;
        Thu, 24 Oct 2019 05:49:32 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:31 -0700 (PDT)
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
        Dave Martin <dave.martin@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 27/48] arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35
Date:   Thu, 24 Oct 2019 14:48:12 +0200
Message-Id: <20191024124833.4158-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 6e616864f21160d8d503523b60a53a29cecc6f24 ]

Update the MIDR encodings for the Cortex-A55 and Cortex-A35

Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c60eb29ea261..ef03243beaae 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -85,6 +85,8 @@
 #define ARM_CPU_PART_CORTEX_A53		0xD03
 #define ARM_CPU_PART_CORTEX_A73		0xD09
 #define ARM_CPU_PART_CORTEX_A75		0xD0A
+#define ARM_CPU_PART_CORTEX_A35		0xD04
+#define ARM_CPU_PART_CORTEX_A55		0xD05
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -108,6 +110,8 @@
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
 #define MIDR_CORTEX_A73 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
 #define MIDR_CORTEX_A75 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
+#define MIDR_CORTEX_A35 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A35)
+#define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.20.1

