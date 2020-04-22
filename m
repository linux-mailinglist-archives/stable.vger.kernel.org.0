Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC91B4308
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDVLUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgDVLUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:05 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2195FC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:05 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so1899152wma.4
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rG8NefQITkcFodUASgLVxmZcYdKDQhtnZoRraZbfXxk=;
        b=DJ81VQVwYDGYmxX4iVajRi+BdKr3byau71b2x2oho4cjr5dMBmOMyU3zGu3jRr0Ogs
         s9S3rzfvjuYErJOQI6XSH4Bou9ecpBnEFoYfF0h7Wpejh6Dg/6JfK1N3UCsbE05NVxhO
         bMosaPcY5j74foNZuaIFRTF0R0N3g9zV/WnTrAkVtPf5FBKseo4PIHLxx3KhXZUoIX4V
         dv7/tzVZdsDB3U+5MVilC8tbH/5kyGldWPLbXYWX8SoItM2SDC0eV2sgsPxQXr3x/2/T
         EnWXIITxk/11cB7xLrNqFqWr6UzTIuM+n8ivhroFAamCXxPUFtkC94UPXHJbeet9Lk5s
         ccvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rG8NefQITkcFodUASgLVxmZcYdKDQhtnZoRraZbfXxk=;
        b=fsulLOcH5e83fmjIuP15ZYXZwTbELtHub7D/ihhhl6IK0t2Yis4CvmJ8DZD2QXERsC
         7ID2f3FQLfyHaVH1QWv7ncJFesy+fOA6mhJijeleQ/LmtWDVHVA6CS3gZ3499PgDvH4a
         9psD3xQOK/88gJa3G/5/rhStBaISdxLlMwevV14VWRhG09kmVLtCg+4ZEbqKFi8K3zej
         luLWF5WZ3Bs+3dJqMLJO+TrY+a1SstWCJEwuZ7zQhIYL7pVUjqkSDObB5L88cOwNRdh+
         3uwy9zFJ7/edg7BJaGvYZQGGiOvLg1xkLaWgNtOIu7kNstBVkeXx0roCeCRPRFQyx9dc
         C+QA==
X-Gm-Message-State: AGi0Pua0eSVu+nTBpt79oxdUf71JRqcPGq2VBvIk6muUuBjAh1Non1iX
        spRNB1YlPsWAJ6x0YB0hAR6+hYqy+yI=
X-Google-Smtp-Source: APiQypLr2To6KohkyA0sjKRCex1Sr2yJ53ahB3+R8pZ7m52AlpXYFVLrLwIh3qsEY3Cq8suSXGwF+Q==
X-Received: by 2002:a05:600c:4096:: with SMTP id k22mr9293469wmh.99.1587554403642;
        Wed, 22 Apr 2020 04:20:03 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Arun KS <arunks@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 03/21] arm64: Fix size of __early_cpu_boot_status
Date:   Wed, 22 Apr 2020 12:19:39 +0100
Message-Id: <20200422111957.569589-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 3b10b93959607..aba534959377b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -650,7 +650,7 @@ ENTRY(__boot_cpu_mode)
  * with MMU turned off.
  */
 ENTRY(__early_cpu_boot_status)
-	.long 	0
+	.quad 	0
 
 	.popsection
 
-- 
2.25.1

