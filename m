Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FB24527C
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfFNDNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36975 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id 20so680767pgr.4
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fVKkVoGiJxBpY/NXd6uIeAwk4xxuAE9w4l4OvZBARVM=;
        b=tUqDZcoUraxwG46Xeay+MFqyETdSKrFiQ7Gh0/OWx/XXFYMi6UQB+xOalfhkzID3sX
         5kLYRx6UOnuG3TSV43Q3dbf8C/niEWCUP4pE83i6ppenYnk65grSDn3DLBzvyMZvwxMk
         JNG2CjE1GnHwJco6jXQ9E3c5OjRxwJYoaKBcFt4wXZkMN8tvY2UJzZwLfrvYIUmEYcML
         xHYJe5Ztq4pKtE3UW5YQbxpePDrOedXnzsVPaOhH1ax5SWUPQWH7Q180LHhT9TJ9rJ73
         c+Zjq5teYrb3dG7emzzZu0HjNPB+M+j8SFWZvoy3DfyAIPoVpcuyKxppGT/tYyOo/iC1
         JhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fVKkVoGiJxBpY/NXd6uIeAwk4xxuAE9w4l4OvZBARVM=;
        b=i5/W6ja05oX6xGcrzWHVsHlQ2ChIHkLobhULknsSoSUPXM1PEBAl+mQrbkifMTX0SU
         T+pKiBbaW35dlY0UfLdijFKpXitLud2l2HQrdfOPdo8p+Sdbk0yNHiQ57e3HZ9blloMa
         XABwheu1JOlpMrxl8sAaGZX2VTuzuDCqwOJLWwSNMdrUCjybt3C4ZRErN2n8Yn8fA6SJ
         L9i6L899NIM/Q0969CfLfMGaf8k6T7IllQQFCeUYCEX1K3HgwrKEew0LCNsKckt770Z7
         OX9wd/S00LGNhz+FFqKBaeAjr/Kg70rXlWqZhrUkAMXb98/PT8vAPdmRpS5okK+R49hl
         0YyA==
X-Gm-Message-State: APjAAAXv91/d0YvXe7ZgVvmLbm7ZEwv3ieXyIINwWIb7ofX++XEsFhEp
        c8X3oWM+qUk8k1yPxYZUYDjYYw==
X-Google-Smtp-Source: APXvYqxNmsCRWqADtuzG1r9aGg4DCwXXgHLlsrDbSseGecbvZNh2TjzmVpfh7V1Kv2cORUPu5aNPng==
X-Received: by 2002:a65:4c4c:: with SMTP id l12mr31225440pgr.404.1560481988190;
        Thu, 13 Jun 2019 20:13:08 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id r15sm1002341pfh.121.2019.06.13.20.13.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:07 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 28/45] arm64: Branch predictor hardening for Cavium ThunderX2
Date:   Fri, 14 Jun 2019 08:38:11 +0530
Message-Id: <3ec694103e8b96a19e776e3649ed286926978486.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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
index aa9cd47b5c6f..da861bf24780 100644
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

