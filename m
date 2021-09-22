Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0750414E8F
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhIVRDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhIVRC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:02:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ED4C061574;
        Wed, 22 Sep 2021 10:01:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v19so2526070pjh.2;
        Wed, 22 Sep 2021 10:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/ftcT1Si5LLqrGRd7+ykyLXm/kzJfgC1iySzpAzFqo=;
        b=j7q6p/LWwo6ESmjJq+GhqTt1eYjOuU8ON1WGKI2/KgW2x96nfl8wlo4D+uQo1aRV90
         Z901/KLZfoVHE4ha3BzFrbj6ikMcZnMLfO1mZhNsQdsQO96Wj0sNipFg2/msKIefqoNg
         bfdhKOidZ+9x4zVuw7Z0I5pR0DfVW2OIUj5wdmNOGYEmkty70Mgli1/1nilO/+JvEDJC
         l6xKy8Ao8vpa4BUL21ZH0LFcZnPxCi0AJX42T2UmUIY6DHIQjKNgxaaUCCkexvLshQUG
         BlFs/gKJ6JIllQHtB6V+wVOBZmPQZumZM8gwT0CDh6kY5BhROsyGAA2XfDGqWevmbuuE
         ZP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/ftcT1Si5LLqrGRd7+ykyLXm/kzJfgC1iySzpAzFqo=;
        b=23g3dw4JJ8iY8OlR6P3e1PukYk4iSjE1IRUD2qdmdCUQRjss+t7b6edZJMBUp8i+0d
         xeQNJtduS4ZGImZD0LvAWFDltxocu5/qqWliglLXWszbNbAieCs/cqdFgpZY3Tr6neIB
         0cHDjZnfsH3ZFtQzKzhZ/VxREZFgKNBy8TjKQGKByCYMYnogCtnCC7QO1o2kWJkI+ovi
         GvnC+4S2gGemCGc7Us41NSw+8YgxmRhJFnSSm3QSNhaI5C5TvAZ0xPaETRaxPQ9U3yLp
         tG6UzyTzKWxbQCPrHLB1lB2flosGlgVvaBzdozXTcisH/G+PB+UDfb4Fw1u3MTXiOdzh
         ztpg==
X-Gm-Message-State: AOAM533nahBLoV4HQ2BJUIpVK307aP5G3u508ghFjI70vu9pINHAaHoO
        77LlKF8/nlzZAJB4HVBbZTjsAdevfKY=
X-Google-Smtp-Source: ABdhPJwinukf6bX92dmwbAt6lE1DpGM7e8DM4Z7pbtvT8NkWppTtDNGyuWn9wq2aJLCuVhZIjbGpiw==
X-Received: by 2002:a17:90a:1912:: with SMTP id 18mr8578402pjg.24.1632330087349;
        Wed, 22 Sep 2021 10:01:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i27sm3041404pfq.184.2021.09.22.10.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:26 -0700 (PDT)
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
Subject: [PATCH stable 5.4 v2 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Wed, 22 Sep 2021 10:00:34 -0700
Message-Id: <20210922170034.190023-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170034.190023-1-f.fainelli@gmail.com>
References: <20210922170034.190023-1-f.fainelli@gmail.com>
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
index 1285d6770fdf..d1c2d3bd55b6 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -21,7 +21,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif
-- 
2.25.1

