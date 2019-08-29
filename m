Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9364EA18B2
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfH2Le4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:34:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43182 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2Le4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:34:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id k3so1435351pgb.10
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=nCZcANTj/VNAghMCqmhGdelYjpzJSNUODI1MeolRwGX3zV0RZ6cTZyhBDhxf30vbvg
         IkLKsTO09Sw7p8F+QQZ/dyIU6LDSLt14M+i7RWDo+xmqe+7UZrE1gpasqOae5bUnmtnY
         bZYtRNqdELatX3EBN5JSjhvVUEazVL+8ZG4DKfRLhmxrbw+IKn6J/1c6V2cMMkThVNvr
         +HjrmOBBAziBdsZj2nUzXPwD5hES6Ujave3wFaUXCN3sqQeC9opJK2OXRegCxJPNivSv
         CBPquIEQBdQjpnSgkAFjNOyT8/fSEdG1h4P3pvDHVQvjfjJjVzJZVORmthdGiEFBUzA1
         zKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=jb9ZtKbjWVancD5tkfl9SHeWJd7mS4hX5DUoyOio0ulDEbJXSPD8foTCGT3hMbEFSz
         5AwX7vQuE5Q2jl+doWwHpcEFSh0zyhKG4VcBXO8ESUcaunGih0xGIPt2sJVM6vCiS2xw
         WAIGLYMqkHj+Kr5M2fHW1XlvmGyJdfOjgAd1PLZ2wZNALJqXmQfzBl4DD7bLTI0O51LO
         cGfQRpXqFr6n0HbsEqcW0ZlV+S+cA+Zv2cKl4CbS5OpHF90hB2YRiSJ53BL/dJrbJ8GL
         C5nGGkSJl2zEEAYKya4i6D/RB4b1gIjnL3yb6nV7eB82M8/XCCrBR+aeR73oT6yonHGX
         l4qA==
X-Gm-Message-State: APjAAAXbdS4wapjurPOTIcTl1m9rddiOqfVP+OGxPTKEMsfmAdCwif7o
        qyU9icvZztuEA9Bc3YRF9XbprsB93OU=
X-Google-Smtp-Source: APXvYqwVAEkYsaqs2EGjLMxvvx5pOK5LU4zwdYV4A967VszTg1UARgiOFPbnuWKUVg2RyXVB8OHOIQ==
X-Received: by 2002:a62:53c3:: with SMTP id h186mr10792040pfb.178.1567078495033;
        Thu, 29 Aug 2019 04:34:55 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id a13sm2564706pfn.104.2019.08.29.04.34.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:34:54 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 01/44] arm64: barrier: Add CSDB macros to control data-value prediction
Date:   Thu, 29 Aug 2019 17:03:46 +0530
Message-Id: <4ba4e0d015f2e044e3eaf57e1239ae3e12d5a80e.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 669474e772b952b14f4de4845a1558fd4c0414a4 upstream.

For CPUs capable of data value prediction, CSDB waits for any outstanding
predictions to architecturally resolve before allowing speculative execution
to continue. Provide macros to expose it to the arch code.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 7 +++++++
 arch/arm64/include/asm/barrier.h   | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index f68abb17aa4b..683c2875278f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -95,6 +95,13 @@
 	dmb	\opt
 	.endm
 
+/*
+ * Value prediction barrier
+ */
+	.macro	csdb
+	hint	#20
+	.endm
+
 #define USER(l, x...)				\
 9999:	x;					\
 	.section __ex_table,"a";		\
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index f2d2c0bbe21b..574486634c62 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -28,6 +28,8 @@
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 
+#define csdb()		asm volatile("hint #20" : : : "memory")
+
 #define mb()		dsb(sy)
 #define rmb()		dsb(ld)
 #define wmb()		dsb(st)
-- 
2.21.0.rc0.269.g1a574e7a288b

