Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2615466620
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfGLF3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45455 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so4188836plr.12
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=vfEescdrZk7PAf9yh6XRXZTOpIl94QL0p7zhy0G6HKN/L7stQNe0GsU83l1vABWalR
         40VfcXPgBqpZUStl85FVtb6u/dee46kXlWli0J8BZJMc/renFQMKfN3432e0Oms2ll51
         pytAaRdD5CFCthBLyq98D+cP1UBigqqFmAdgmKh1ceFPIVWWHQqCx1KlzrTb2n7DsfU3
         NyK/2R2NVZXGHW7UREDpV2hTAOEJudmW8ho0hO1AB0/3ZNHTvMsiatNstJWM63A2mrWN
         RabQ7GQclnS5EVa/l/thl+giSH96sRyalPlp+7465G1t7yNFinTicVk75JqPNPn9cIaj
         pYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=aoLker4Mpjbz1Iqt4MRYaLqEN3rrjPWZQpH4DXW46k8lDdK0yOWF+KeAKGItnSOdWc
         iSXbfxqeNHeRx9Ye3J9YIxUO/3sCq88l62EcTp0fC3um5nGxxfaiKoAn18upNMCI0Dju
         lqIEecBNZySSjAvhfNxl5c+IIwzRMGsBTWrMVK4i4fIoWaLOEYOyelhoL28Uzj4Fjba1
         Pm0ZBI7ffqFdYGzwcWGRsAd33oiDNFK/QuL8KFAbShgxLrshOaj4J2q0Py5sr/z7INQS
         hz1SGW7egoOBPQPhMavHP6SFdYzhLNDJKnpaHqbVZYBV01RcGA3ieStyT/lit2UJo6ua
         cLKw==
X-Gm-Message-State: APjAAAWzGI55evmwVTwCoZz1WhDCrBrMhbHqEYeV1Uwzvlnco3yyZzre
        fcB7sJlWm8Ztt34az7iOVDg4k/p3s4s=
X-Google-Smtp-Source: APXvYqyzj4WENL7VncImhrhciTIHq1bzE5dqQ/AjbTemgvpK8K9quil1ia29VHn2YGn/rCxJo3TOJQ==
X-Received: by 2002:a17:902:2869:: with SMTP id e96mr8804681plb.203.1562909341172;
        Thu, 11 Jul 2019 22:29:01 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id l31sm13056963pgm.63.2019.07.11.22.29.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:00 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 01/43] arm64: barrier: Add CSDB macros to control data-value prediction
Date:   Fri, 12 Jul 2019 10:57:49 +0530
Message-Id: <fe952d04e88a653363f4ce73a8a7aedd2609c877.1562908074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

