Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BEC7D735
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbfHAIU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42876 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731086AbfHAIU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so31902540plb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=prTlbc1VpFmNDiAv6vpTx2HEDdjE/0SlqakQ6arRd2E=;
        b=pbXyYpmTiStLC+WXk8GWN6yEJYVgh2FpjiErFCzKkXxkB1pBJcEXcc75DiLneqvzzc
         8z79YlSLW/ldIPd5tG1rx3/mCh+xw1q2xLPneNgxxKVYAUQWplhJVnS0kYoFQ3Q1Cwcg
         ttNvgYIMN8Z8jVa4ltnxf0l2xhbpMT01WiYIHKdTFrD5DFGhcGcZBs5vHQZKRK0RfmKb
         91s2s8e3sC3bL+FC0EcF4YmYy7M65uashW3RfI8MeENkxMgDEMLYcby9nU39dNCzp5AP
         KdDPjT/L8DVLyQvnkdjcXKfkfws6lVhxqRQN+ul7L8YkTKojUjQPmd7gR488fo2+aisT
         dIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=prTlbc1VpFmNDiAv6vpTx2HEDdjE/0SlqakQ6arRd2E=;
        b=nyy7zDSeXHmYf45es2Osi/N0RG/nDuJZV/+3EqBUk1iFIMDcIf0Cc3jnUWhO2qAeEh
         kSU2ER6TtwW5+IkYJdw1jYl2Q50hN49/ujvV0/w2sOYZmFIukT9LBS6p028JGGujDv8Z
         LjkrP0OS6g5RoN+KM3R1mw2HUYBwevGv3nHOhIy+VOpfKi9xnG/GJYUov21WjhF/Prdq
         GXTudJmz+drVsSExR299QlgTByLpcoMWSA+ItOfQ5pQvcnbgWQuVmfg8sLuzNwBWp/K5
         8h6RGf/vhoByUTuqieskuSYljRqSD9yNd2d35peVZyzG/LBPr798hgq4LzOlISEZ/1HC
         lq/Q==
X-Gm-Message-State: APjAAAXA5rX6W6WSpUiBOvRxeTRSAiSQcBQY53soeXR1tQa/n4dtPVJO
        4pz5ZIpCls5AMdVhSjzrrIRix0j4YMg=
X-Google-Smtp-Source: APXvYqxgkwMio4dYGApew0KsOZeBgdbSqaR1/0IhQU8wiu2DhH6nWHkofViU7CZGIB6GMjSqXFTZnA==
X-Received: by 2002:a17:902:9f8e:: with SMTP id g14mr78883845plq.67.1564647625311;
        Thu, 01 Aug 2019 01:20:25 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 21sm3764096pjh.25.2019.08.01.01.20.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:24 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 19/47] ARM: spectre-v1: add speculation barrier (csdb) macros
Date:   Thu,  1 Aug 2019 13:46:03 +0530
Message-Id: <980958de54ce29412a4e03e2de197e7ceb34e0a0.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit a78d156587931a2c3b354534aa772febf6c9e855 upstream.

Add assembly and C macros for the new CSDB instruction.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/assembler.h |  8 ++++++++
 arch/arm/include/asm/barrier.h   | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 4a275fba6059..307901f88a1e 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -441,6 +441,14 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.size \name , . - \name
 	.endm
 
+	.macro	csdb
+#ifdef CONFIG_THUMB2_KERNEL
+	.inst.w	0xf3af8014
+#else
+	.inst	0xe320f014
+#endif
+	.endm
+
 	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
 #ifndef CONFIG_CPU_USE_DOMAINS
 	adds	\tmp, \addr, #\size - 1
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 27c1d26b05b5..edd9e633a84b 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -18,6 +18,12 @@
 #define isb(option) __asm__ __volatile__ ("isb " #option : : : "memory")
 #define dsb(option) __asm__ __volatile__ ("dsb " #option : : : "memory")
 #define dmb(option) __asm__ __volatile__ ("dmb " #option : : : "memory")
+#ifdef CONFIG_THUMB2_KERNEL
+#define CSDB	".inst.w 0xf3af8014"
+#else
+#define CSDB	".inst	0xe320f014"
+#endif
+#define csdb() __asm__ __volatile__(CSDB : : : "memory")
 #elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
 #define isb(x) __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
 				    : : "r" (0) : "memory")
@@ -38,6 +44,13 @@
 #define dmb(x) __asm__ __volatile__ ("" : : : "memory")
 #endif
 
+#ifndef CSDB
+#define CSDB
+#endif
+#ifndef csdb
+#define csdb()
+#endif
+
 #ifdef CONFIG_ARM_HEAVY_MB
 extern void (*soc_mb)(void);
 extern void arm_heavy_mb(void);
-- 
2.21.0.rc0.269.g1a574e7a288b

