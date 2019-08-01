Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB77D736
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHAIU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42881 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731084AbfHAIU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so31902582plb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ws1lkPqBsn87EY7GxNn+AzRrtY/P0vuzwO4T5yjsQK0=;
        b=vibnYP12Yj8WtQhINzxmLEByeOMlswC0F2GsMI8dE21QSoRhhqbMo+P7AxcGVojRUA
         /hT+AkEZH0AS115dCqaaXUuSv0k+4joEOreBP/68Gjb0QidyVKyPg0W89H6SlBkzcfcp
         +cgas23ax3Ib54qSLu3Dip6Am24mT5q2SQImorxH2sBLXwAJweYLO4iBosEvBRd4DZrN
         efKdS/jHbZT1/UT+qeOxf/oohBhdIpK1I7/N7ZoMU/QH/q6/zPpQlJjvHkjPsQK66OCr
         FiBeYSXRrQraypOAvPkKR35SP+Z/gRLeDjKA3IcMFJn1qq0vSD4pyg4aIYuWEK11NbbJ
         rqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ws1lkPqBsn87EY7GxNn+AzRrtY/P0vuzwO4T5yjsQK0=;
        b=Cx4aSfdShRcwo/zTFj0J41yeeP+9IedHu6DHT1dyCEpWfNxiXFgbQUOSpcOI80hcgR
         aQeTpb9VYtoKp6647qX9NAl/4ubCKZcv1+8r2pUi/K+wav0totV94bf9upbcscbNK4pe
         69ZwVuf4Czhh+bljHFnLo7mNKAwef/7KEYurKkvyh45/ShEC3QImkgxRfaSztogsB0X0
         yUwpo9bKz8OlX/pWYL/+CNtUA1qIG9AP4WohbEKNCEfNfcct0QKF/ReSswJye/zrqXkV
         mFxXHNTF8oiMgbp4WDA9Dzif5XqhD0rOgaoNadfoDtrYHLcU3vlSBzgwOgjIzD0FpM6X
         ol2Q==
X-Gm-Message-State: APjAAAXC0JeVmHSjU0bDvAQL3p26y5xULN7p7MEt5120VN5RcmLe5Qrm
        NRAJj3a41CC/b1+9iTDeY6817CRK2ko=
X-Google-Smtp-Source: APXvYqx1oIG3Ac36vr5PTQduzADZMjARqFq2CKsmLOvD+dcJcvRucBlmCQDJEBuv0oww4PyrxKWUqw==
X-Received: by 2002:a17:902:7043:: with SMTP id h3mr97891950plt.10.1564647627732;
        Thu, 01 Aug 2019 01:20:27 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id y194sm47237763pfg.116.2019.08.01.01.20.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:27 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 20/47] ARM: spectre-v1: add array_index_mask_nospec() implementation
Date:   Thu,  1 Aug 2019 13:46:04 +0530
Message-Id: <68b8f200fef6b51b5a140ef541fd4455ef704294.1564646727.git.viresh.kumar@linaro.org>
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

Commit 1d4238c56f9816ce0f9c8dbe42d7f2ad81cb6613 upstream.

Add an implementation of the array_index_mask_nospec() function for
mitigating Spectre variant 1 throughout the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/barrier.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index edd9e633a84b..744d70e1d202 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -108,5 +108,24 @@ do {									\
 #define smp_mb__before_atomic()	smp_mb()
 #define smp_mb__after_atomic()	smp_mb()
 
+#ifdef CONFIG_CPU_SPECTRE
+static inline unsigned long array_index_mask_nospec(unsigned long idx,
+						    unsigned long sz)
+{
+	unsigned long mask;
+
+	asm volatile(
+		"cmp	%1, %2\n"
+	"	sbc	%0, %1, %1\n"
+	CSDB
+	: "=r" (mask)
+	: "r" (idx), "Ir" (sz)
+	: "cc");
+
+	return mask;
+}
+#define array_index_mask_nospec array_index_mask_nospec
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_BARRIER_H */
-- 
2.21.0.rc0.269.g1a574e7a288b

