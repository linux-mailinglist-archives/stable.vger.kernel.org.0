Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F91566645
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfGLFaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44307 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:30 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so4188243plr.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkWh8S1DsW6tSZCYoLWe69ClR5UVvKugQ1/Th9fCzhU=;
        b=SMwR+6pdVG1+jVLkxuQVbtP/+BVTEx6rGEByEY4qdeK029SHABdRrCTMiXb+4nre45
         h8O859XSPNC1NRkmJg2+4GipJ9ze5HOA/R6idJQ+Pt7C/gT7400+oVGtmwIU7nb7ULsX
         Oj54EVb6tOLF1SlsBurQ5iK3J3FAGqldb9vJuYmTP1R4tXxxxiXMf8TsxhbeUBNW3N0J
         UeWGq6ZtKrNGNghl5q2gRSIQzgEYpgWnrZ7JrGf/e5RvYg1+EE5//gzM/tZ9I+IV8fEQ
         OSKDS5JI3fNrLgVpfcqmN9DeAephhosWwadHtDNS6bmi0higyU99JwprNFVc7BjMjVJ9
         0F+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkWh8S1DsW6tSZCYoLWe69ClR5UVvKugQ1/Th9fCzhU=;
        b=k1E8Qwb6lZsNIlx7G/t96LoVxQaB6fXQZkvecmARxwsqJGJBYX8fCGkKLAQ3f/c12J
         euTQ2xpuGYYpmnoO8GKDu+wkvcBBddc5igPXEDLrDUtQLMaFaOGaYJcVqEQgTyzK7v1j
         IcvIDJLaD3yDB7pbl3GxBIfwL3/4VyTXVjkq3orb69ptKBrkN4mCLWKMpkdMO9ySHAP9
         G+464sh2zShX/ruVJE1YDixjqEk8RC5r8j3b1kDCiT1pXvXF3eTb775WLvgOK0VKJMy3
         BhgAWUhny0E6KHx+KdqV83PXNcEiF8FPP5Oyele9c56ocDqgBQ9+YwpsFJaXOezSwcF/
         lLDw==
X-Gm-Message-State: APjAAAXq7ZkzzCjIJQMiKLPcqObyN/Un5hcUnpjNkGuf0SNehkAC59Sj
        MblQf2IOkIkuX7d50ifHAZ4nn2lpMnM=
X-Google-Smtp-Source: APXvYqwRenMg8VtbpqXdjHaBLDPx/1GaF/9bujmKaumpC/Ey9xVpZHK0cPZvCTDJ4FIQxxoez1R/jw==
X-Received: by 2002:a17:902:9307:: with SMTP id bc7mr8879363plb.183.1562909429452;
        Thu, 11 Jul 2019 22:30:29 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 14sm6731541pgp.37.2019.07.11.22.30.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:28 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 33/43] arm64: Branch predictor hardening for Cavium ThunderX2
Date:   Fri, 12 Jul 2019 10:58:21 +0530
Message-Id: <ba3f93fd7b5b88cc90c6fc201cb9bd64d754d57e.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

