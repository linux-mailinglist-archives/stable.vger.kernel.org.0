Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFFB414E9B
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhIVRDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbhIVRDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:03:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E03C061574;
        Wed, 22 Sep 2021 10:02:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m21so3314088pgu.13;
        Wed, 22 Sep 2021 10:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=PYdDrlvyoIx20X25Y4bJbJxIlfKvkkV2DIUtLJAwKCY7zQBCcXRL5HEXrkvocnmpBh
         IXh6Bn/MKi9v/wva3x/INOxqbv5sYyczLFuuIa5K9NvfAQa+bW4LPSVQsji5d95vUy3i
         Tv540NV1tsi0y+CkeQyS8QewknFHZNbxO4/Kw78Y63impfsq71lF+D7jgw+W+SPQLoYp
         JcFnEAx4CGm2TtrkYHUaNXijsP51hafrwFDNvcCxfUIkM3NngxtlbA2pznjB3BVySTUP
         QsC+rgIeDUJdErayVRpdCkTZ2ySAgvIOtukg2xC6km2zToicoAYQpGLxmzR9jtQHRK9e
         HzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=XkW9iWXVmv8IhXGASofVeLyydZYVASrGlvmdvk85RrHFANn6kPVuG9EutTxMMNCnqa
         jrMItMOlX1NEc9MwdSShqZ3QNM4jyL/eoBvcH2KkYDAJZR+w12Cl04wm5k8TGJclHc7z
         eHLBrUBKs2KSes/WKOh//JaKTLYP8KSrOL0jJlbFsfKkgKNM8LILii4AhdMx5IKJPykv
         kKJcogBQaW3DkzXOfGGgTViKsb3VOVf0urfkAuNp7Gjw5kbA2NdbxMcjFTlwCIa74uGM
         rzUp8/eyysrDJRZamgpYhT+sh1Kd/GUGcv9lFxeqjlIIcxiUDBUvjcmxS9H8slQeneal
         G2fA==
X-Gm-Message-State: AOAM531j2QKdH6VONGOEUnauuje/UJ07dnfEhKT1xP/Cn1uoMnXhB/pG
        OHJOmIWoJXttnXug2lCCzQR9zdj6n+I=
X-Google-Smtp-Source: ABdhPJwBS2j4/8g4/sDYfgfM1Kok8nj2ipUPmAHkdmCWbkxiHzbwnCLa48gtbWUD92Uvx8srt4jO+A==
X-Received: by 2002:aa7:98db:0:b0:43e:8544:7e49 with SMTP id e27-20020aa798db000000b0043e85447e49mr119979pfm.58.1632330129272;
        Wed, 22 Sep 2021 10:02:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7sm3101087pfh.168.2021.09.22.10.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:08 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Wed, 22 Sep 2021 10:01:28 -0700
Message-Id: <20210922170128.190321-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170128.190321-1-f.fainelli@gmail.com>
References: <20210922170128.190321-1-f.fainelli@gmail.com>
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

