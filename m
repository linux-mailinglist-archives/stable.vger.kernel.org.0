Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51637A18DF
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfH2LgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42513 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2LgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so1436683pgb.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkWh8S1DsW6tSZCYoLWe69ClR5UVvKugQ1/Th9fCzhU=;
        b=gwTGiqyd1i0ey/EjaZDRrHjSr8gfQOYUawu8ybrHlGoJXfZFdHdv76ymB94bXuy5C7
         OA8AjmChqVIkkYPWK6ygHXDBNYOYGkoAhRrShHbZeaRHGG53Y1D/k+gLdO/GKe5Q5xfE
         fL+Tsj+BL7rll0SI0ZZBa1dm7YrfAjXR5n4N0rRmfms8qWKXuJ4l+GDnDgwzMOkGo21/
         y+PSskm+p0nA+iofaGta5EIfhGWlzRFkkJkGjknmZA97KV2JxrIxV3u+p2+9xBCbOxn5
         XrrjPAED5EXO56K+jXLwqfrgwwt1csJ5/dIOzzOK3kwWQj9/g9Yg6pmR1pnkdhGs1lSG
         In5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkWh8S1DsW6tSZCYoLWe69ClR5UVvKugQ1/Th9fCzhU=;
        b=IMTYmkLaOaiun3a1MaXfZtAB/Q5aRBVPC+MduXgPVEjdnWWBse8imYx1NLvaD+mslV
         I4iFc1xFsVKU5DLPtABgtsRXgkafBzowPVxinsQ+ug8rffTNI/KuHwNTPpSVsknEY2Ny
         s+PEuSFFTLCWouj6PCGxKqjGbtB80Z5HGRtk/MjQEQux55zYATex9tdPw9ml0rritUUo
         wzmJSZcIVQHTA9GK0PvF4W+mqzXSlyehZ+IyYYmnrFXFxE9nfbhBA0lSNrGfIoW4SIEU
         JM0VH82nGBAMsq2lwzo0ZYag0m3mXPAngKH/cPdVjPsY276QRGuqqmgMYIO9g6kKYuPS
         RFbA==
X-Gm-Message-State: APjAAAXv7kj+7K9dnIstBJhMNFjdzW/ujGnbpooyS7u1TUqpVt0D2rKR
        VsOLPC8L0Iu+di7eyOFPAiQ6BRv1ec4=
X-Google-Smtp-Source: APXvYqzTHRKKxZSvYweM1RXzr/hfakx4PFLfP2Vzugpkk0lBFl/uJ44vEFiMkRPeEiHmbJ30wUPvAQ==
X-Received: by 2002:a17:90a:b303:: with SMTP id d3mr9677868pjr.28.1567078583076;
        Thu, 29 Aug 2019 04:36:23 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id y8sm3422359pfe.146.2019.08.29.04.36.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:22 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 34/44] arm64: Branch predictor hardening for Cavium ThunderX2
Date:   Thu, 29 Aug 2019 17:04:19 +0530
Message-Id: <428a36a4c7d91a280917ec2a65b16ab0cb11bb6b.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayachandran C <jnair@caviumnetworks.com>

commit f3d795d9b360523beca6d13ba64c2c532f601149 upstream.

Use PSCI based mitigation for speculative execution attacks targeting
the branch predictor. We use the same mechanism as the one used for
Cortex-A CPUs, we expect the PSCI version call to have a side effect
of clearing the BTBs.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jayachandran C <jnair@caviumnetworks.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dbd7b944a37e..ff22915a2865 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,6 +234,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
 		.enable = enable_psci_bp_hardening,
 	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+		.enable = enable_psci_bp_hardening,
+	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		.enable = enable_psci_bp_hardening,
+	},
 #endif
 	{
 	}
-- 
2.21.0.rc0.269.g1a574e7a288b

