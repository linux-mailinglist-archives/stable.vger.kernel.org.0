Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B318219C9B2
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388669AbgDBTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40068 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgDBTRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id s8so3459511wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rG8NefQITkcFodUASgLVxmZcYdKDQhtnZoRraZbfXxk=;
        b=bvOWUkqP/3jhVGkgj/rXDHu7JjW+UI6zRYqd4XRKiIsRlmTf+S87hj1e+guP3zU5Ry
         G/jnc+pIbuZ+atklusXheOzJygw//1+aS/EJ6yNybmLxDkhDkyIwrN0i3iAzYBCifMdG
         ao5GXY3wfYUB9czkaZkBSwOq/jYESdXb2xDbrBTNqizcoI9MxNkp4flvjg0P1lNcx85b
         lM83bGPAyShrcmO7NurK7vn5aqjCCbFSxMfD0NJyCW6FS4W++uHm5YOr58AtRW6YN1xZ
         Dwb8McP0lSZeN7nisIfFb1+3XDE77qm5UNKJgSwPLL3zpSdiN3/xfiCMY/NVWcGghD6O
         Ujvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rG8NefQITkcFodUASgLVxmZcYdKDQhtnZoRraZbfXxk=;
        b=r1HllT6u/RlEYRkMmwF09PGgobb+QtenXPCKbAWx2/yOwdVZtBfKDHFvAc0MEnGoEh
         36vKWQLZBqJ/ObXk5t58CZXw5i367aH1Zy85xSlN9u5fXmJkb8BxkI7iZm04v6UKpEiB
         j4mWZIr/bJSFXsz+usPH4vbRKGI1gxnUf46x05byhT74YOC90JcrJ6XJ+VUYddeaFHVr
         O+9UBssXv0Z3WO0lPqmOFQU5TRvq1ib/f6PVaOF/NHzCh0FdCCKIXkgh9WZECltKIbex
         MgayM1o1tZhxxHcZEELJtxeEmeh3e2yqXq9KcJdGO35jfm2Duu10NZRK2KSc487sbgFn
         paUA==
X-Gm-Message-State: AGi0PuYwQWzzwRsezthAwmHaLJ0Q+yIS1y/s2nmtBKCLnKH/y69P54aO
        D1w9P/HxJ2rSspAWFXNmEU5yHH3wAuQPyg==
X-Google-Smtp-Source: APiQypLeLCP+MquopneDYoZ7hW9Obp4ulEOIOq4xZtkdXDoZMafvyfM4ZRfIaNL02Hhynq546LrEVQ==
X-Received: by 2002:adf:b31d:: with SMTP id j29mr4897868wrd.218.1585855017101;
        Thu, 02 Apr 2020 12:16:57 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 03/24] arm64: Fix size of __early_cpu_boot_status
Date:   Thu,  2 Apr 2020 20:17:26 +0100
Message-Id: <20200402191747.789097-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

