Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F183B41A116
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbhI0VFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbhI0VFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:05:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFD7C061771;
        Mon, 27 Sep 2021 14:03:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id x191so12025235pgd.9;
        Mon, 27 Sep 2021 14:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=XpvWzPwGwWdBcSVU8HoIDPkp3FhA5QkwC4vjsoD8hwgEpWq03uUohI1GhY0ijA+BWi
         LPUJvtFWTf884MGGDNOcrZQot5ucPa3edlnFPwmq//le0l3/ad+m0x5A5IrLZ4/j4qLb
         BaXYWN7ef39y+9XoETfbySA5LrXQtZfUL3WuJ+IhE8sG6PKC0VueweEFps0NvDsHvFnp
         fp/NAYdsUiKXK/mf0oHLvp4gAw+IvkLFF5vG8seBuIkoWthalkfK86/zqjpqfAQS2XCp
         4JRnNnX+zrpFui3+eu2dDg8O9E4RhQZ9QLhdZxIrhr+j1UiaXV23f8qGA0FYWljZydQU
         YFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=i1X+XjTCSVMm/teJq9edme84TkYq2Ev9AqizmW8T8ffWIer8+4OU4CuTq91HhTW+FQ
         b4xHljgcdW6ABrFRdA4nSXp5TJc7DvQC1VKSkBU9FhfRXDigC6cblh1NZ+P2v+Dpccwp
         Wvz1i/xGOKIBSt1R0XYCAJEdd/CnM7ojcr7MoXwMf1G1w+YTVc+NQNMYPUBemqkbXhfA
         W8cWS0/0WxZA02zo+uNhgTG8ALUvhn8YsjQVFHR09KrJKsTV0OWzNd+6hpv2EZrdGLNQ
         dXCifHwFL4bZ6JvnBgyxLsrPFlzYs6IFbjed8AQfl1H2lIisEr6F+XbWAv6BkaXap24b
         ai+w==
X-Gm-Message-State: AOAM533zB5kiPD8YjkcWeJQdrYu0kXoKHmxufI53EsaSiP6oXt62JE0k
        BWnFi/mMyAsvfbbF8kaYkaMFYcKnmtc=
X-Google-Smtp-Source: ABdhPJy42ZtwDoPBrd/Nrq24HJHXQ/y99KsiQLcu1b0KuYnzSCLW9YKT7DSPdGpIQcYDR0OkU8jAUQ==
X-Received: by 2002:aa7:8426:0:b0:438:3550:f190 with SMTP id q6-20020aa78426000000b004383550f190mr1934647pfn.19.1632776605214;
        Mon, 27 Sep 2021 14:03:25 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e12sm16444086pgv.82.2021.09.27.14.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        kernel test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.9 v3 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Mon, 27 Sep 2021 14:03:16 -0700
Message-Id: <20210927210316.3217044-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210316.3217044-1-f.fainelli@gmail.com>
References: <20210927210316.3217044-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 6fa630bf473827aee48cbf0efbbdf6f03134e890 upstream

FTRACE_ADDR is only defined when CONFIG_DYNAMIC_FTRACE is defined, the
latter is even stronger requirement than CONFIG_FUNCTION_TRACER (which is
enough for MCOUNT_ADDR).

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

Fixes: 1f12fb25c5c5d22f ("ARM: 9079/1: ftrace: Add MODULE_PLTS support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/kernel/module-plts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index 6804a145be11..ed0e09cc735f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -24,7 +24,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif
-- 
2.25.1

