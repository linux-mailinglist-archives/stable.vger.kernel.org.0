Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2723E32FC
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502145AbfJXMuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:50:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33915 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:50:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id t16so20805601wrr.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JZND00YGZlV73vPmNvrrAkkFIFPnyjEpW2QNKg/hB/E=;
        b=ta4cOzGRXQyeHGe+rCtu7LPYjtEoFKLcJHmwBnOcG9e2MEYFiyT1B/uZ9qO6gu5gKh
         QTnPkhWK9jc1OMHadu/vk4RKNt7snIpTYWS9LaCsmOV8A5vDEYY5Y8+D8X2hj6W+6Uf/
         8+6HlyCqMDsS9ASB6xJ5k7VGgRLKOXggmE27nIITUt760anxvOdxE0YU1lTAL0DbQAeU
         JuxCBCgmbjoIEOpoamOafy3OLsCGbzp2DMf2BzHhyFHPKxupE18iLbfrj7dbrNJWN+2O
         5ErtvO3/OgpxQD14hS/ZuBFftIVhVeGWlKd3GFqHrB7jW0M8tZq8FGWHvrwBXQDlX5P7
         YI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JZND00YGZlV73vPmNvrrAkkFIFPnyjEpW2QNKg/hB/E=;
        b=l24dm19ZNxOQVzxaQ9mqtpn2UgSEBIRkv91VRJrP3wyPPSRKU9n+vakCXZ6YSXTwZk
         ZzRa7UWttjM4Bvg00vRoOvrcQpk7Ip4k2faFiF9Kpff40LI3VcnzbT6Rs+QAtrXfW7lT
         Vbp0SQlz1pORsHjo4kLrFLLwRvNVl22iTdBt89NhB1pd+Yinbpmpi3zWohjF5lZJt21G
         MsDvVUMsR9NxPZshdrDbQPf2We2z4WlMf6OX2q2K7hFePnCbGVBeLbdVTwrN6u1Ox2ta
         8HCTxaXf8SIBlLbSHPaTJK4EpyAdBHFesycL6vShW46UpYrpwSeznwM/f6uKj/ks8utx
         0iJA==
X-Gm-Message-State: APjAAAUqCvbJSNkHCID70cHlR7Yfs62NbbP4YHA3YdcLhn6q9dhTa0qo
        x6hqrOdxg0S/HjMCR5x9zsipLMnKY3H+Da7b
X-Google-Smtp-Source: APXvYqxLVhsSkLogGOvXm6LuzAzDty16ztkCUJdMglpyzHjP0V4mjQHUqDkT4YMWE2OAzC2nIQI/Cw==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr3617724wrr.316.1571921398745;
        Thu, 24 Oct 2019 05:49:58 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:57 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 45/48] arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB
Date:   Thu, 24 Oct 2019 14:48:30 +0200
Message-Id: <20191024124833.4158-46-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit eb337cdfcd5dd3b10522c2f34140a73a4c285c30 ]

SSBS provides a relatively cheap mitigation for SSB, but it is still a
mitigation and its presence does not indicate that the CPU is unaffected
by the vulnerability.

Tweak the mitigation logic so that we report the correct string in sysfs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 2898130c3156..55526738ccbc 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -333,15 +333,17 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	/* delay setting __ssb_safe until we get a firmware response */
+	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
+		this_cpu_safe = true;
+
 	if (this_cpu_has_cap(ARM64_SSBS)) {
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		required = false;
 		goto out_printmsg;
 	}
 
-	/* delay setting __ssb_safe until we get a firmware response */
-	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
-		this_cpu_safe = true;
-
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
 		if (!this_cpu_safe)
-- 
2.20.1

