Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6F7D71B
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfHAITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44250 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHAITy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so33733652pgl.11
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=VbI6KvBYoAleWdpoNuid44aSrwYNmD6XVjYIU7cCDTWY4VDquc62cFzYoqAjoNU4c6
         nZdCxO4QKpSqcfDfWapRYMgqaUzdTVFD6QEiTM4dIJb0ZM1ABvlyVKKWWtNPpds1G3lU
         4p92/NPa79XeTp/RqJA3evytYoQgQIeWoUDGGWbUFJL5yJfeteKwslbEPL6XJ81zlmu4
         mqBei4tEDuRtTA5ILbqgU4DBk8LIhWRf6SJUr11/UyQJ9nEkk3ZEB73W/A5g/oRFW5pC
         orshzn6ourcm7mrF/MHU430GQUWbheLftyEwlurTTVsAnK2IQGUQJyEuSSSvo2QsVTeB
         QOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAkAWOSid7lK0+CYFipQ6VxUVVXehQyD0WFI7UyGT+o=;
        b=nRKlgGq4L31I9rhd/vrkT2LlzTw2kXxGFbVvj8XzqhJegVLZhhyapkJQLeAiyEfIlh
         nfqeIsphRrwq3ms8F6ScTaKAVKi4kdo+ZYvvVAQ2E4pzpFX+xxA1Plvv4ZLpd2Fu8ZKB
         smX9onBd6CZuDrqGS9fDTm3o1/Bym/xGzwoIXT4QlEu8Ttid7KJLxrNjBsLTTAtkJprd
         FLXnsaOlsn6duQYxsbM58SluvIHX71+Bfsh7S7Y4MsGs05awqnkiDTUnl/OWzts39Cre
         lpFWRjfTqcigzdXKTNc5I1nBJe06FYPbz9z8KlAZTl5OduWgDyhlI+4hfHlc+nd9Glr4
         Rnqw==
X-Gm-Message-State: APjAAAXwX+uCEvpmCATqkqH0USyX9ZHzO2GKqSLqQ4SPwBbuKhMgjHQJ
        pDRqAMu6SprkFd6crg/3x7OWyujiPt0=
X-Google-Smtp-Source: APXvYqyqiLsABmsuD8RnlguGwZ949r9n3nBGRbVHcg6v9Qt8z+FIGNp5TN9mJ/k6FWKJWLIPv1k4Ag==
X-Received: by 2002:a63:5162:: with SMTP id r34mr686278pgl.229.1564647593609;
        Thu, 01 Aug 2019 01:19:53 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u24sm10002220pgk.31.2019.08.01.01.19.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:53 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 07/47] arm/arm64: smccc: Make function identifiers an unsigned quantity
Date:   Thu,  1 Aug 2019 13:45:51 +0530
Message-Id: <eda92cd880a3ec1f3a8aeadc44554c956a6ee007.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
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

