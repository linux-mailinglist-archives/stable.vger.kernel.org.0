Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129E119C98B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389184AbgDBTNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55665 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389167AbgDBTNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id r16so4613770wmg.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yWp18OzsOskB66rjxomLP3YHpSoLDTDv+zg5SpQOzVQ=;
        b=GxmPTkCzkrqVymk/wCCSj4kInjSGWOzqyTzGJWrrk9ncnSmupnWnUyCIwW9ZUscfqX
         QPUqPGuyUCFlojeQQZqGqHGzEpW3bmoTHMlwvu/RQ+1WQ1ae2FhlQGqqRMVJrKW5pB9E
         9/q119AcINTFFVy4a2Tl1h1vs88KurW0xx45FOA61VbWEd4Xm46kUtP8HKc5EXbupdS3
         7jfpMfYJD/kTMonCswYGCNHE5EwqAQ6/WiA+6T15HGINk5HTrqYj95Jq2tN4w8dq60jE
         f2uALWM0p9ddgfcIdOx95sT1FzRrw7mrLat6O9FPEO6ma0vl628BcfeDbVk9vkL6ovd4
         WmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWp18OzsOskB66rjxomLP3YHpSoLDTDv+zg5SpQOzVQ=;
        b=ePL4RCNjzlSo4PLC78geZ1nodDlQLPUb1K7l/3Qj6dcxWI36sVu8Auw15gUp72qya+
         4aXr6YjVsAJBPkVamrrs/5ltLkZ+JBEUHiR8M0n1D7jrlvrjJjmnK05jjkqiOTnTtboZ
         Bvq4nux59OEbeesX7ruJhlMDOwv7L9FCjfGXU0T+l9kNmjuNwwYuoi8ekBOt4zmQAtnw
         yRjCED61ne0YmhoKwkQBN0QqN6Z+dUxbTGgTPJG/FPQK6Zpms2Z4k9Gul9xpXK69t42H
         NlUHeQQ82yTkSKMdhogK4H1w+1sREDEt2z3RbxhKB34GlaaRS+n8viqgy9izxXV+gld3
         /joA==
X-Gm-Message-State: AGi0PuZuewysbevBFw/ATk/RTTScIGpZFIPpxIcCZSAR0KG1Yi//taGa
        8qYO5/HrO3dPiB/BTn0jOpLU03xTKTtSHg==
X-Google-Smtp-Source: APiQypJkh/lJiUuymMXEQV1eo4Qo/hBxBt4+4jhUz7gPgH4XhMpuszHjS2vJWdn7UxRiVD6limDzog==
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr4904505wmd.56.1585854782315;
        Thu, 02 Apr 2020 12:13:02 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 03/33] arm64: Fix size of __early_cpu_boot_status
Date:   Thu,  2 Apr 2020 20:13:23 +0100
Message-Id: <20200402191353.787836-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun KS <arunks@codeaurora.org>

[ Upstream commit 61cf61d81e326163ce1557ceccfca76e11d0e57c ]

__early_cpu_boot_status is of type long. Use quad
assembler directive to allocate proper size.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Arun KS <arunks@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/head.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 9c00fd2acc2a4..bd24c8aed6120 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -558,7 +558,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 
-- 
2.25.1

