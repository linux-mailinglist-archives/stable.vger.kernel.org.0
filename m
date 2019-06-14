Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DF45277
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFNDM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38713 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id a186so496066pfa.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=fKikLlZuAQwMsJ7IxdZ8VaTDrZUxIEZ23eNY/ec3KB1TeAkqv+Dd8EAOX2jOAgTmRi
         32CQuw+4/4j3eOkxgcDh29AnCQVRSZrT4BaN6E3Q39lYAZVbENVcOm8XPzsqNDaiE48y
         yjndCGjmzUzdw5d/H8+50cc15w15uQ4VsI8t7/LuLjW0NAtRrsznKOzILwQEVq4JhUjr
         9aQ/PnnP76FkI5bomv330zrABfuEa9DAwt+1oMCGWmv6zTrjBN546hhVvZvAlUFSoBok
         bAHCvf9uNRrp3k106WZTFTQXDvkQwiI/2pA/ej7S7/AIrrelGoVgvs7PId7Mn6OcvKAI
         j6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7dDso9mEizkFlSNIpcQXEVsYMAg+0dXCi9osCif4dQ=;
        b=DUpaEytSelEklmQ+XIR0XSNjmgwVJJdQ7xQy3I2TDrgF4Wyx+zxqSAfE1U9x2pBwHa
         owuz89UNZmwvsHs2nSGbJPoorRwwXNLJmeL+9E+RSmhbkgVN8z0TWWYRWrXxQ8B4lOVK
         DnvYZgnfIVOHLzOnwQid+YNEZ3q/m3r1Tw9+Zgil+n9SrtVUN1A8fDrfKaKmPzblkY/s
         3PPS2F68qpzJiU1EAylS6QW+EY8RlplnDb+7s4VtKVLXB43kAY4KxW1Ki2hBDN/PBDuR
         7T9+YUKBbP0cSIbSNFoGODk+yJ/U8ZsNix+SKLl3BV4hGwVBW9dAqHyc6T0yAc+sKiva
         giBw==
X-Gm-Message-State: APjAAAWL4uYBkKxE8iRSoA4W54VR9M2oRWBCxmcn1P3eJmrrK7NDoChV
        14Pj4qqI/+Q/6abL4HT6QpGOmQ==
X-Google-Smtp-Source: APXvYqxW3zGVG0I9OzIQ9niSlNH61hh4YIpqfv75eHxvSTKVVpPie3Lls43Fy6uold1oh56+3H7abA==
X-Received: by 2002:a63:8249:: with SMTP id w70mr31527593pgd.33.1560481975265;
        Thu, 13 Jun 2019 20:12:55 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 11sm1046028pfo.19.2019.06.13.20.12.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:54 -0700 (PDT)
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
Subject: [PATCH v4.4 23/45] arm64: cputype: Add missing MIDR values for Cortex-A72 and Cortex-A75
Date:   Fri, 14 Jun 2019 08:38:06 +0530
Message-Id: <664f5eab4d993d056ab82bcfaf7037d538ee6095.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit a65d219fe5dc7887fd5ca04c2ac3e9a34feb8dfc upstream.

Hook up MIDR values for the Cortex-A72 and Cortex-A75 CPUs, since they
will soon need MIDR matches for hardening the branch predictor.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Add A73 values as well ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/cputype.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index f43e10cfeda2..2a1f44646048 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -77,14 +77,20 @@
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
 #define ARM_CPU_PART_CORTEX_A57		0xD07
+#define ARM_CPU_PART_CORTEX_A72		0xD08
 #define ARM_CPU_PART_CORTEX_A53		0xD03
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A73		0xD09
+#define ARM_CPU_PART_CORTEX_A75		0xD0A
 
 #define APM_CPU_PART_POTENZA		0x000
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
 
 #define MIDR_CORTEX_A55 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A72 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
+#define MIDR_CORTEX_A73 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
+#define MIDR_CORTEX_A75 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 
 #ifndef __ASSEMBLY__
 
-- 
2.21.0.rc0.269.g1a574e7a288b

