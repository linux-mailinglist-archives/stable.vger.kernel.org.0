Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BBC7D756
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfHAIVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36897 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbfHAIVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so31884245plr.4
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEzBHKM5Yrnew5IgDE9VhKRrkovpTReWWDnzndMpTpo=;
        b=UN9wbT1c5Wx19ZD2dzkTJ0vzKrvZSwdLl/MoPaL7Bf5lgYTUbPsoGyZaiQxXofgkyN
         I9Ta0f5FCBMV/ZPClK1Ut66nIJg9T6CE9kwIi3O+VIixnsW+ZVIAXVzfRpelZyl2PfOV
         UQ2qf49OaqxnZw5UwF+H40gSMu5ka3TK3gzkPxSM+M04VEdd6jvD/ZUnXWE9zqktt1DC
         bfLwxwHqhXAhLi1gls5Aq9+gSGFeuIsSUu5sX/BfT3URFPW1pv/HgNwFqeXUojYz2mMe
         Tmo/OGFIq2GbvVBu0phLhNVYn/62935QkaI/dM2KpSkyMSvZTxnywcgXj/DwrSY7RWKD
         WgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEzBHKM5Yrnew5IgDE9VhKRrkovpTReWWDnzndMpTpo=;
        b=djJ9mpdg8CC7ZD8g6BkMlFtvjBDSJqpafGeIuYuZJluIuoIt6L6S6myo0XF9i4g3cZ
         hb+ciZamXOtRXElM07orJoZLmZ5y3KZlsqNKjFCPjazWbXZOFcZ8yJVnTPQqka3fxfc1
         KEYS2xw7keFUigQvN4UxjEcIefo79KWvMYY0NajZvsJaWB5CrZX774mloIdDSxEc7R8H
         h2m6ql6EdyxHqYHOEZWDghtNr91ixEF7+H3G4mBr79wZ/pBvcbjqJw/4jnzMNGQG0Mvy
         RWMWzNHWx2Fmwmc5XIYTBnjVsLBLGKRkPrZYiFNdsfohV2xmkB3q/TTymut9V7R7f8Q1
         rcsg==
X-Gm-Message-State: APjAAAW9z3dQDTzSx9FSOvfrNhAUO0WkFxhxZ7NVFS20Heb5RjGwu6FY
        1/7xS7HEVclx+2Hvwbo5JHosKpKDAMo=
X-Google-Smtp-Source: APXvYqwb0TOHdBpq4vG3XgGwqBBj/UNlT/qteIlZUZg9wGkRaWIn9Bg0d24y471cMtkOLZx/GzPB8Q==
X-Received: by 2002:a17:902:7c96:: with SMTP id y22mr127080149pll.39.1564647681003;
        Thu, 01 Aug 2019 01:21:21 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id j6sm10632447pjd.19.2019.08.01.01.21.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:20 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 41/47] ARM: clean up per-processor check_bugs method call
Date:   Thu,  1 Aug 2019 13:46:25 +0530
Message-Id: <33110a95761cf304c04b2837d8539553adde85b8.1564646727.git.viresh.kumar@linaro.org>
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

Commit 945aceb1db8885d3a35790cf2e810f681db52756 upstream.

Call the per-processor type check_bugs() method in the same way as we
do other per-processor functions - move the "processor." detail into
proc-fns.h.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/proc-fns.h | 1 +
 arch/arm/kernel/bugs.c          | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index f379f5f849a9..19939e88efca 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -99,6 +99,7 @@ extern void cpu_do_suspend(void *);
 extern void cpu_do_resume(void *);
 #else
 #define cpu_proc_init			processor._proc_init
+#define cpu_check_bugs			processor.check_bugs
 #define cpu_proc_fin			processor._proc_fin
 #define cpu_reset			processor.reset
 #define cpu_do_idle			processor._do_idle
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
index 7be511310191..d41d3598e5e5 100644
--- a/arch/arm/kernel/bugs.c
+++ b/arch/arm/kernel/bugs.c
@@ -6,8 +6,8 @@
 void check_other_bugs(void)
 {
 #ifdef MULTI_CPU
-	if (processor.check_bugs)
-		processor.check_bugs();
+	if (cpu_check_bugs)
+		cpu_check_bugs();
 #endif
 }
 
-- 
2.21.0.rc0.269.g1a574e7a288b

