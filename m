Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F304528A
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfFNDNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:43 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33573 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so386651plo.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=dmFfqE3RSIU4Ho6hkmSADd23EX+tld4u3806oEUalpRrZVS1cmqp5pzecti/qkD7MZ
         9Q3F2qViabRLb87OzNLEHUqavrai4vT1AePqeLFjnkK9PoK0AfUNYJH2+KI7xJBPS6r7
         pCpMcHoGyhyHHrUyjEX+zzBhOGuN+rle9DTQ5CMxtawV8Ggri+/OhRLNOYiPgc1txdxD
         283Mtizasgg7BvjljAVyKErkf04q+T1Mg7+g9U5s1atYL96TtGRaJL5dYuqOaa3CE2St
         bygSaCJMOu8636e0BsJZ7m6fYlBUCXIEHTfkTcduBKpFjhZM03cCN79RPuIq2AqaekHK
         M8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=o7rsh0Zd9Aa7VezmIRPj7we+oUn8cdqEOllpGy3w2ohotwQZCnuUtmG040rYUmDFnI
         HksHtr1oWIL2oBaT4XHq1OOPikq85kzVN2YHODPUQTO4X4RdmOogOvTkAutMjh+cBXaG
         r9IBp/mzj51WDPnoZYfM5q6q25syhMiDvI/WNaHt55JMukf2WV5J2UHDtPAMiMd9+GxG
         JUkp97GbKE1C/huP+7HnNiB8AbihXmLOL8STQ+YgMJ5T0uE1z8CqRaHJlSlGPkDAVxj1
         Nesq568b9q/qVNT5CYHHXBsMnFtoj4LBAPsZIFv6guvCADzUNl5X9lcgW+vLcSOlmUjn
         JRtA==
X-Gm-Message-State: APjAAAUR2NdIz9CXGYfBRytabAtQ4x8JvB/am5Ew3DdIfJbohkOUH+6q
        NxsVHACrxHQNuBxhF9NXCz6Zj1X80BM=
X-Google-Smtp-Source: APXvYqyAyZ6ezMbTYaeyEBCrulKG7P31Vp4EkUjjkKOUpO/xEIqEm4KkSwVqRI5sN5z41GtbmWE4AA==
X-Received: by 2002:a17:902:7c04:: with SMTP id x4mr31949468pll.70.1560482021795;
        Thu, 13 Jun 2019 20:13:41 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id w187sm1079648pfb.4.2019.06.13.20.13.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:41 -0700 (PDT)
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
Subject: [PATCH v4.4 41/45] arm/arm64: smccc: Make function identifiers an unsigned quantity
Date:   Fri, 14 Jun 2019 08:38:24 +0530
Message-Id: <5aeb3eee8907e3b49c19614c5c104f8a598faa95.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

