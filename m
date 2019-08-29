Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC980A18B9
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfH2LfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38983 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfH2LfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so1447141pgi.6
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=nr9Gk8pFzTEB0x/gTQjg70ogkUAAe3PHOryfDr3XdOw9hGozLABdCRERUdlFdyM7+w
         XHQw4yTqjOc8IyDdh+/0FqzVT4e1ygwvvGGySH8M6jc170I3CFooffLknoEUesluak5N
         cxL5uYIwuadRSsXimRlPBaq/8VvZLJsE1kbwhTrwzDOZqRlUVflQjLZfJfNNwvA1UvUV
         /0dbHEI2+EGV0WVYNpHt3fXS1ewsXIvWvbUYjW0AFggyhIJSNlYHsFFRF4jIhgR4nxda
         yIWg7uib71hLdizQQgudJGAhAGNeIYZX+h063Xjs2s6Jkw5Kxyc575C0eeCvUpZxCEt1
         B5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNlfncScxDREAT7VjTEXAFzdaeKYbTqQ4JYCBMZ7gaA=;
        b=dgHmuL2lX84wQdTAO4AztqqoC5c+/PgRYoxF4MBXgKN0SqqFXoVz8eO6uv9Jr/KRnl
         Cu2YUgbmMO8ESdAtvDv6VYJCNJ2Dtii1cub+Y89F40g5YDtvUNwM2i2oCH9u3YIsUUYv
         4UkIkhQ1ZJ2xWZkaO6Hq87uY4yqGHNRtQY9mIpmG6SkuO2kFrHgv8apH/WnQQ3nHLDl5
         ZxbNE023IFmAOXUIBX21kt/Z14g1oJuOleM+6KqUsy/O2QKZSpGyoGQ1e+cgqtlaRfwU
         8w5CUbcGLEaaWA9Q8bUZGacXOg9scQ2M0OwCHjiHJlFUddT3BJaZJozab+VDqkboC7fP
         waOA==
X-Gm-Message-State: APjAAAWREuNUYcu+X1QvIegzcec/l9zStCl3z9vMTVNWno+a9AN+9Drk
        CuAkkc9vay9AzQUV1Ac9gpHemAFfkbc=
X-Google-Smtp-Source: APXvYqxaRmbjVog/4nw9seikvSB7LtDuhZkYKTDMv2tEWPXr5U+mLgf1hoaM7vkP2NpyY98Km++xqQ==
X-Received: by 2002:a63:c03:: with SMTP id b3mr8067964pgl.23.1567078510622;
        Thu, 29 Aug 2019 04:35:10 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id n10sm2183349pgv.67.2019.08.29.04.35.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:10 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 07/44] arm64: uaccess: Prevent speculative use of the current addr_limit
Date:   Thu, 29 Aug 2019 17:03:52 +0530
Message-Id: <dbe69b13f77052abf5d342b2775b1ebdbcce241a.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit c2f0ad4fc089cff81cef6a13d04b399980ecbfcc upstream.

A mispredicted conditional call to set_fs could result in the wrong
addr_limit being forwarded under speculation to a subsequent access_ok
check, potentially forming part of a spectre-v1 attack using uaccess
routines.

This patch prevents this forwarding from taking place, but putting heavy
barriers in set_fs after writing the addr_limit.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/uaccess.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 75363d723262..fc11c50af558 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -62,6 +62,13 @@ extern int fixup_exception(struct pt_regs *regs);
 static inline void set_fs(mm_segment_t fs)
 {
 	current_thread_info()->addr_limit = fs;
+
+	/*
+	 * Prevent a mispredicted conditional call to set_fs from forwarding
+	 * the wrong address limit to access_ok under speculation.
+	 */
+	dsb(nsh);
+	isb();
 }
 
 #define segment_eq(a, b)	((a) == (b))
-- 
2.21.0.rc0.269.g1a574e7a288b

