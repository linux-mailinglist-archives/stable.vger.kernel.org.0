Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B988E66651
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfGLFar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34463 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFar (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so4216651plt.1
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=rbBb9SC7giz0oauYvdP9cYHAqoGTPD+ykkopvCPSbIgttQxtYQqn1F6B5rA5OjrbOf
         MOKCdYW04llywRPGqJfvEeh4VcYLl/+4Ru/hdae+vjnPM0Uuiuryp5dNor6Mx9/RykRk
         GcmAEq29koH5jLv1c1LQTyqkDgH46WVu30cCdcE2YJLHSXjx9FUwtVjqTRvKB5UqbxaK
         xQGQvV+NE6OdjeTjcJxJAv19LEEVjuHp3lKY/t6Dj3nFj6ARNGu/5tp09Z5HmUjEJY0f
         hyWya3YF02NzZU6T23Q4MHmEjDyyq45W8aEu2vmZIcEosQ2QD0Nl0IP2BkclGU/e/7hE
         OHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=XIfPQmCBWxj4CS7rXvIyMa6VjWKnVf/u059etTIub2yr0HS+H+USdyK6VE7WtImUjd
         VVrya3q1+rcVqAD7G/8shKNAOHVdOPzRw8alCPBfvGuw1wRdkxdDuJCJAu9wjo4S4ZRK
         1t9d4adgK1iQTaIHeSyfugVlpG50l6QXmMLr0TE47W5bsuAf0amw/3zNoTfdEJRAixsE
         LvCUa2mjsadraZyTU+U0bAGdK+m6zAIeZkIzFS7JKv2Gl19r43dhWchjfy7sNcxQixtP
         K6i4xCb2CAIWbOj+G6we/l20AvNFP6uQVe4IBLM//eIDuuRoxHAX1P/XFdIRr69SuRYD
         BQtA==
X-Gm-Message-State: APjAAAUwoa8dgXJCtRa5u6qys4skLOYM5tlb3ou6q4QxB8hJPC39VSiG
        rl2G4WEfsdVipa4Umlrl0pXwuXjihHM=
X-Google-Smtp-Source: APXvYqzQUr91c7RMVVSjz4gI1vWy+u6byT52DlkWRpIc8d/4BmB+KBzszkR1LOCHuFRYN4uI2KTgjg==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr9134247plc.2.1562909446241;
        Thu, 11 Jul 2019 22:30:46 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id b3sm11909341pfp.65.2019.07.11.22.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:45 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 39/43] arm/arm64: smccc: Make function identifiers an unsigned quantity
Date:   Fri, 12 Jul 2019 10:58:27 +0530
Message-Id: <22d449cd63d5d718d3aec3e55b4805c03592b265.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit ded4c39e93f3b72968fdb79baba27f3b83dad34c upstream.

Function identifiers are a 32bit, unsigned quantity. But we never
tell so to the compiler, resulting in the following:

 4ac:   b26187e0        mov     x0, #0xffffffff80000001

We thus rely on the firmware narrowing it for us, which is not
always a reasonable expectation.

Cc: stable@vger.kernel.org
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/arm-smccc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 1f02e4045a9e..4c45fd75db5d 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -16,6 +16,7 @@
 
 #include <linux/linkage.h>
 #include <linux/types.h>
+#include <uapi/linux/const.h>
 
 /*
  * This file provides common defines for ARM SMC Calling Convention as
@@ -23,8 +24,8 @@
  * http://infocenter.arm.com/help/topic/com.arm.doc.den0028a/index.html
  */
 
-#define ARM_SMCCC_STD_CALL		0
-#define ARM_SMCCC_FAST_CALL		1
+#define ARM_SMCCC_STD_CALL	        _AC(0,U)
+#define ARM_SMCCC_FAST_CALL	        _AC(1,U)
 #define ARM_SMCCC_TYPE_SHIFT		31
 
 #define ARM_SMCCC_SMC_32		0
-- 
2.21.0.rc0.269.g1a574e7a288b

