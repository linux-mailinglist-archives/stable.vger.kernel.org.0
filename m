Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56D414E76
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhIVRBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhIVRBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:01:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9994CC061574;
        Wed, 22 Sep 2021 10:00:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j14so2188887plx.4;
        Wed, 22 Sep 2021 10:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hta6ESAus4YnwKU4Yit7RtVqe+WClVS7262FFZl8yc=;
        b=oC8tjXSLCyC1uS+RD/ygUMBk6pz84Ja4TePYcptolQaliPO8WbD+mlXrmXf3tCK+Gl
         /c5S3n+Xu5T9AEAXtCROQJXfBYQxRGO/9AI8s32xYjJy5zJjkeaIuAscY2xrktCrBlBT
         Ez+EEnB8Tznxx5logOFBrBVdVX3hYfHju3DbiI3V9n0AZiQEnYoWOuSk66PV3M/K1jbd
         xMFWQutsdCGebalICqvGppo/juipypYiXMFnSt6XVijq0dl/6ok39SOhgRnAlTu98VuZ
         d1aNmCNRA98JLVq1Fsjk+qG6IlKKudaFNhFL4HNatzWpx2P7dTmwDwVgOkv2wth8JTjh
         T/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hta6ESAus4YnwKU4Yit7RtVqe+WClVS7262FFZl8yc=;
        b=nWsvjBug2+US4Z0l6eSix2kx9TPUH0NJEw/0CtpISSy5aOVtbWLTST2amquNrCXVip
         i58OmXX8b7cj6nj6WlvZbMCH5oUiahSUjxrbLxRyBdUC+brgP+R2XOz11jmihqPHI0S+
         Sqdx3T0I12NSDH6ua6EP+02YSb7ipRe3AcI6RFQsguLCCwoDCa9dbmkJK55sGykBPaEG
         rqYEcYLUeZhWWPyWGKg/hK4XH6aVwxni1KKiDXLL6k3qk+NGhAmj9Pb+cRVsrqX+vRoS
         mcySyWOxDU4o6covjmFJXlnWmCPWkTCifu6IbfP2bpNj0Y/elv7Xfo9qAAt2+KhJZI1S
         9SAQ==
X-Gm-Message-State: AOAM532EGAppcl+xaocTwCdyVHDQq4dGSBPy/SSBuD3cj6SGT3mhMjPl
        8GuJx7ertvgQPxrvhQ8jiRI6fwd+2sg=
X-Google-Smtp-Source: ABdhPJx11pUXaXUAhRWiTzTH24XA2n975wJSt1c+UFIFPFL72IRh10u8P0smfhVRq9OWsO4VSqYK1g==
X-Received: by 2002:a17:902:7e82:b0:13c:a612:4712 with SMTP id z2-20020a1709027e8200b0013ca6124712mr471018pla.29.1632330016796;
        Wed, 22 Sep 2021 10:00:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j23sm3196336pfr.208.2021.09.22.10.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:00:16 -0700 (PDT)
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
Subject: [PATCH stable 5.10 v2 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Wed, 22 Sep 2021 09:59:55 -0700
Message-Id: <20210922165958.189843-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922165958.189843-1-f.fainelli@gmail.com>
References: <20210922165958.189843-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 4e271701c17dee70c6e1351c4d7d42e70405c6a9 upstream upstream

No functional change, later it will be re-used in several files.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/module.h | 9 +++++++++
 arch/arm/kernel/module-plts.c | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 4b0df09cbe67..09b9ad55b83d 100644
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
index 6e626abaefc5..d330e9ec2de3 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -12,10 +12,6 @@
 #include <asm/cache.h>
 #include <asm/opcodes.h>
 
-#define PLT_ENT_STRIDE		L1_CACHE_BYTES
-#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
-#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
-
 #ifdef CONFIG_THUMB2_KERNEL
 #define PLT_ENT_LDR		__opcode_to_mem_thumb32(0xf8dff000 | \
 							(PLT_ENT_STRIDE - 4))
@@ -24,11 +20,6 @@
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

