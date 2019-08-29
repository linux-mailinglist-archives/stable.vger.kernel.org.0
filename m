Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85878A18E9
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfH2Lgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43340 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfH2Lgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id k3so1437518pgb.10
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=CWNDmywD9pwBoSyGrr+As4k3fmuk2k2e1Cj+YhyHwoayQ98EB8aWbyk0qtrgFFX8ab
         aVj+ZGKObm0d/C5Z/A/Nz6OT7wBkXe6cOp05PWhqrZRKRBN5Ow4TuLZwJFmEgbTUdKkw
         yrGwA36TGEbFabFc0dbcBZFc47loi7MIMCQuX0/g4yx5KBjLkkRImE7PriTYyeHftjxH
         pIApOewCjuzGA3UkACN5KdDuwCYA23Me5BXxuQajWqAcsrrh7Jt3xFu3gdl8A8T+9p+u
         iA2pL7GWbXmPwfouuSEsj9u73oy0HpXWKLf6BdUCwdTvUKpZVS5mWn8s8ANB8N6HuJGt
         6WHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=ctfimmplnp4EF2ZpopLKw+0hMDEZnQorJOm3QU0q+jgn5BzeXowE+ly7Ol/LbzQzK4
         3hQHwUON0hRJb2dVRsptVCNVETp1KiPhVV1uBu25XbYYT20XFDO4Iz/ATbHxGQuMWd6g
         7cS3MwDRgev/TtDQ3nEA/Km3/GhZbVp6EAXoixjoD2ULwuUSzroXV84DHQ7Zfuq7Q3wV
         0M2MvwY+Xjq8tjhsgIX1CWEpYwmiGyG4wpfpu14bwAM42mjHCpUUbdmLp5JKyZJ2cJQa
         hxvYGgN2DS0lIMWcz5Sb3rM4Qr0ANWuUflM35PZEogxDweB2quaPFFnG6d9bPul+48G8
         ZQkQ==
X-Gm-Message-State: APjAAAUIlsqBV8TILHV10fiU7D9PSBcptuK2o0gRyTKC8YRK5xbVL2P7
        Fh+AVi4SVneu65QDEZZOmjNssjdV4iY=
X-Google-Smtp-Source: APXvYqxhkPjHWExRmZMPUP0tnH5EGbzi8KyI5gBhWNuqMx4+CCW2XNMMvwuLCXKwS3roiihkOldCPg==
X-Received: by 2002:a65:4509:: with SMTP id n9mr7834393pgq.133.1567078598673;
        Thu, 29 Aug 2019 04:36:38 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id p90sm6514025pjp.7.2019.08.29.04.36.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:38 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 40/44] arm/arm64: smccc: Make function identifiers an unsigned quantity
Date:   Thu, 29 Aug 2019 17:04:25 +0530
Message-Id: <9bafd5233bd85eb31c7780a5d1149943da897e23.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
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

