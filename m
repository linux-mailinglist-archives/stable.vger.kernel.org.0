Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0479A4525F
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfFNDL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:11:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42573 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:11:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id l19so664578pgh.9
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=sNIF4TaqtWZx+SWXbKFuSQaAHyH/3etk8jvo0f9cyStxOLJ7UvQrp3TwDEOw197rwO
         98mN3sbimtbmJkPhi84RBjFB0UN2qrwienlr/AJgSjaPpIAWaX+3frMl5trjF+1LjlC7
         k+5S98Sj+bieeo9G1hY6QVkFVZW1w6gGdz/v0owtlM8lV/YHFr9ZDCWLMyLz6Arljf+h
         zQc27CMZcJzoHdGRaiI2x8pU1bCcsCzzCi4eepW4MYwrdIcpbHUUBM1gMzCjZ8yFVNPi
         D7GLLGrHEi/XtWbRyH7DR9nFwnu6aPy2106vuNB4XahxgkFzg4j79VhVCpyfl8td3Jq4
         3I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+8ZINgorfc9/vHqnYTLmiCH63MmZJ4ah1lcUclNBnY=;
        b=g8faW3pzzh6ysNe7APshV+SMr4wcjxtBa4i9CFwKyWZdE3HltGxErktOOKztoIHB69
         49NblGhnP90uNHp7sNNUBkiDUDWBwR/nlfq0Q8t14hrJ4xJnlwL+QscaY8zP7ZjtdZ/D
         rQ74QgPQJ3EWEwvYgxPMw05p5AgTYqAutEQzOdmdSCx9JPjK4mgwHB3znRzfuyel8EKL
         iz1jGYK4Uigua04N/4zPnETQELSN45djH/Pm8nDVQavWvGYTz7ykHxj8MGmovzaIQOCA
         JoakgC+HutdxaucOlIm/pdPZn+iT1V6JTWfLaZTJNut9aUzRNR0VWMgab0RDm90euZ5M
         SmJQ==
X-Gm-Message-State: APjAAAWbOoS3cxVhp2KCHCn41xNbub8wIPn0OkdY64UsnGOvG5lK4csW
        6+EGKMAdbsW554nDJEChVZU/zg==
X-Google-Smtp-Source: APXvYqyAzgvvDB61N6I95Bv68pRhUXvpbEJUgMHj4bpypTUrI9sTqkH2OWfxMqOd3+IJUx5FEUOrJQ==
X-Received: by 2002:a17:90a:19d:: with SMTP id 29mr8971505pjc.71.1560481916646;
        Thu, 13 Jun 2019 20:11:56 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 12sm1107859pgw.55.2019.06.13.20.11.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:11:56 -0700 (PDT)
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
Subject: [PATCH v4.4 01/45] arm64: barrier: Add CSDB macros to control data-value prediction
Date:   Fri, 14 Jun 2019 08:37:44 +0530
Message-Id: <9cbf3ace67c45ddb00ea1a1567d20f6954fbc15e.1560480942.git.viresh.kumar@linaro.org>
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

