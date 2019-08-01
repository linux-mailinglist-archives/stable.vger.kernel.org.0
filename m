Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0947D73F
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfHAIUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35221 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbfHAIUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so31862393plp.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=38pdn6yMPIMVV02QHWSD6x84Nqpn4d6LkQlpQyJb38o=;
        b=hpj8rFpqrv5qQhzotiE9gMdgzeeBBY56JsYcX7mov2k4sLQED6mYGWck9/YlmIsNte
         CvgNOeTzEU/dOYJodtSCB/QqdhAWuKaWfHbSDifhT7uswu3+TXhLyYcJMnYSklDo2R65
         naU69OUI9lfGVslVSxJiiwfCNGn62aCu3lwlJIh7Tf55NYlFiUfpB+YQzce5TrXsjSLr
         q74/ypxEdtW3UDTY+0ssOk3V4RqaK1kmHYGv+j9E0+masU4wpX5nCLSroLSz1wwvgmZt
         PJaWq6BASd5p7zAoOmB4CddaIgIFG2/7658BQH6TXT/Y8J+l1bk9aXHhozn7zAhQmTsX
         swMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=38pdn6yMPIMVV02QHWSD6x84Nqpn4d6LkQlpQyJb38o=;
        b=X341xygyN0299gbw6v3YP8P+SiGKL9s2lMPAv9W/QhU2oZ3yTX90h9vzIz82u0Q7xa
         AXPKLaa1fh+UtweUpPqNt4lJtBBIzQLLhvA0Bf9YZ1ojDyKUcST5Jciq0oQmNrw4AH6O
         3rS5CecaQzEdBbOf0NJq2Aj7QmE2Thq5+L+jAS3u1c/O6twwzBzVzHV5yTGcvYwxz/mw
         A/D0Ts2RnE3KVkxhndcchXmh+8WDDG8RC6oyVgkyeaie6OQn/2mcg0SUUPsN6hADLbrX
         ZaQrCm8gzD6KIaDIYq5cUK/fYlx305kB9H4jtsu52o/GRXje3l5SvEzbe6f41tCuqhyk
         Au8w==
X-Gm-Message-State: APjAAAXG48P+7opvEVtJpz3RYVVaVkYCOTdK66zA6iqwRqapyoEZJ9QQ
        W46T5gzWGGSbVS3SIz8PQYt9DZzwYdY=
X-Google-Smtp-Source: APXvYqzFqEhG8iSDqc8c1Fwl0FFlxIe0jTCk/Jowo/7z3bJOap5hms2k/E0l9VfM/kV7WHN07BlFyg==
X-Received: by 2002:a17:902:2a69:: with SMTP id i96mr123097817plb.108.1564647643267;
        Thu, 01 Aug 2019 01:20:43 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id t7sm67895102pfh.101.2019.08.01.01.20.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:42 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 26/47] ARM: spectre-v1: use get_user() for __get_user()
Date:   Thu,  1 Aug 2019 13:46:10 +0530
Message-Id: <092598d625ced1af31bac019a567319e189cb1ea.1564646727.git.viresh.kumar@linaro.org>
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

Commit b1cd0a14806321721aae45f5446ed83a3647c914 upstream.

Fixing __get_user() for spectre variant 1 is not sane: we would have to
add address space bounds checking in order to validate that the location
should be accessed, and then zero the address if found to be invalid.

Since __get_user() is supposed to avoid the bounds check, and this is
exactly what get_user() does, there's no point having two different
implementations that are doing the same thing.  So, when the Spectre
workarounds are required, make __get_user() an alias of get_user().

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/uaccess.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 968b50063431..ecd159b45f12 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -314,6 +314,15 @@ static inline void set_fs(mm_segment_t fs)
 #define user_addr_max() \
 	(segment_eq(get_fs(), KERNEL_DS) ? ~0UL : get_fs())
 
+#ifdef CONFIG_CPU_SPECTRE
+/*
+ * When mitigating Spectre variant 1, it is not worth fixing the non-
+ * verifying accessors, because we need to add verification of the
+ * address space there.  Force these to use the standard get_user()
+ * version instead.
+ */
+#define __get_user(x, ptr) get_user(x, ptr)
+#else
 /*
  * The "__xxx" versions of the user access functions do not verify the
  * address space - it must have been done previously with a separate
@@ -330,12 +339,6 @@ static inline void set_fs(mm_segment_t fs)
 	__gu_err;							\
 })
 
-#define __get_user_error(x, ptr, err)					\
-({									\
-	__get_user_err((x), (ptr), err);				\
-	(void) 0;							\
-})
-
 #define __get_user_err(x, ptr, err)					\
 do {									\
 	unsigned long __gu_addr = (unsigned long)(ptr);			\
@@ -395,6 +398,7 @@ do {									\
 
 #define __get_user_asm_word(x, addr, err)			\
 	__get_user_asm(x, addr, err, ldr)
+#endif
 
 #define __put_user(x, ptr)						\
 ({									\
-- 
2.21.0.rc0.269.g1a574e7a288b

