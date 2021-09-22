Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15438414E89
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhIVRCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbhIVRCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:02:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E012C06175F;
        Wed, 22 Sep 2021 10:01:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k24so3348362pgh.8;
        Wed, 22 Sep 2021 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWRcCpDBCE+vzsQtuqngj9goI5v+Yy84JYj8ZdWoLcc=;
        b=qhAhQXsWxKoZI6SsJA792fI7EuNZxblUI4fBuB0ALX2oNGGUOcv9yX26JTDamU+tgs
         2jmQ4Kl96+PQ6Qam2u6HUrZVPJZYTfnuhE9XfSQhRIYS49g1PKrUv/kQu+zCXPv8lzhs
         MfS0L7hFJvfdnp2talH/oeXgo34dq6iwReZfQqTliGB+ZvmTAqdBWr/scoGtFygScDtv
         1UTsA/Qhj8g6s3dyYufnoszHAgDIgAg7wMM++UH6VGLBG4U5LpWvBbnhF/ShHQi8UbZ8
         7WmPeqOBpMQ+onmVyTNxKjwzeJdOEirT58ZBHkv0/MoEFOFRV0PWMQqIe2L6DUTLTELA
         tyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWRcCpDBCE+vzsQtuqngj9goI5v+Yy84JYj8ZdWoLcc=;
        b=QZi2l7hY+fwBf29KpiPTMv3ijv+XBn9xcXPx9t0s6fDAJDV37x4CqQF1nR+61JjfHd
         pW3BFjTlqgc2AR3PuplliYQ0+jCZdRTTS/yAWeR5/+Mg+RwLQCu+9nFkW28o73g2WJYI
         Sx/2CcMmjZvkoBgtcDhNhFRtccs2Ix0FB7B6al5J4pk9frz5Ay3KqWZ0NIhr5zLXjVm/
         oz2Za33FnVbKuhp6YvRRHO899hNKIbYhAd4eLFULHQpRq9Hk8wKwh+pMaXA5OECdmnMV
         EYjrYrbxmgQjgFCVhn6d2BV5XnpPh4Hha+rxg45ezq3UpxMJWISYxNWujf0Rg4FORZ2k
         0JbQ==
X-Gm-Message-State: AOAM532Yeyu8bo61wx5czuTFfKrmNhLYAVWpRkeFqRJ8E6H9mxw3EMpI
        mWaS6Pc6GCwvaCt/yt8eC+Eft4siF+8=
X-Google-Smtp-Source: ABdhPJzXto/l2ks4tTQkP196214igtnpqDMIWeS2ZEKZOKBbTzPVmoNAajwkaJn7hp99pHegKQuZeA==
X-Received: by 2002:a63:1656:: with SMTP id 22mr667810pgw.20.1632330070640;
        Wed, 22 Sep 2021 10:01:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i27sm3041404pfq.184.2021.09.22.10.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 5.4 v2 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Wed, 22 Sep 2021 10:00:31 -0700
Message-Id: <20210922170034.190023-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170034.190023-1-f.fainelli@gmail.com>
References: <20210922170034.190023-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 4e271701c17dee70c6e1351c4d7d42e70405c6a9 upstream

No functional change, later it will be re-used in several files.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/module.h | 9 +++++++++
 arch/arm/kernel/module-plts.c | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 182163b55546..78e4c1644628 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -19,6 +19,15 @@ enum {
 };
 #endif
 
+#define PLT_ENT_STRIDE		L1_CACHE_BYTES
+#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
+#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
+
+struct plt_entries {
+	u32	ldr[PLT_ENT_COUNT];
+	u32	lit[PLT_ENT_COUNT];
+};
+
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
 	int			plt_count;
diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index b647741c0ab0..d1b76f3f3df9 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -11,10 +11,6 @@
 #include <asm/cache.h>
 #include <asm/opcodes.h>
 
-#define PLT_ENT_STRIDE		L1_CACHE_BYTES
-#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
-#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
-
 #ifdef CONFIG_THUMB2_KERNEL
 #define PLT_ENT_LDR		__opcode_to_mem_thumb32(0xf8dff000 | \
 							(PLT_ENT_STRIDE - 4))
@@ -23,11 +19,6 @@
 						    (PLT_ENT_STRIDE - 8))
 #endif
 
-struct plt_entries {
-	u32	ldr[PLT_ENT_COUNT];
-	u32	lit[PLT_ENT_COUNT];
-};
-
 static bool in_init(const struct module *mod, unsigned long loc)
 {
 	return loc - (u32)mod->init_layout.base < mod->init_layout.size;
-- 
2.25.1

