Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DA241A111
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhI0VFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbhI0VFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:05:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADCEC06176D;
        Mon, 27 Sep 2021 14:03:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s11so18915854pgr.11;
        Mon, 27 Sep 2021 14:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkhLdmrHmkgMMt1LbOtoU8XmiMwNfTKIfISAPG6mWV4=;
        b=oMtgY/sCIaVV/K8un4kN0zGD6prfOG9zRFq4Y7jeSwmBW/oATV0VENAnfrZHsz5h23
         Nnp/9Wxa2x8R5oGH8CNExc9kuU5yloG2wpcqU+7zVJidRB4nUnEAiYk+Q96Ur1ZD5a/x
         66LVsagcePI96nLQ0Z1E55mRmpSk9PtwmTeDAAYYbpWp81u/8G1T76+wx5mfj2boYRiu
         +2fqTeCsndtliw7wiQNVeU1rN9P5M7fn+qYXZ0LJ/FWBWU0vUQ1bIB4UeYkmJcP2WV4B
         FUTLh4plf1LDI+/zNXVb9sAMx1kEpmKwZLhpbruIMvVdVQpjYnc/lJxTzobtAGNGy2e4
         7GpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkhLdmrHmkgMMt1LbOtoU8XmiMwNfTKIfISAPG6mWV4=;
        b=8IH2tovhWW5/CMzNlT3hIG0ua8y230ZNjuasKqwkUSOj4tOTFkxYKxI2Qtlv9jtsjk
         wqJP7KjBNSzyPbmroKRNdDmGpdyqsNSTjSWPMLjBPWhQaVGP1iO9s1nYg/dpF+pj5D2Z
         qBvubo/XSiQTR244HWDmmXIekppggKXTYqbffYvvD88AIJo0zj7/3UelC5Q+oZCzSTkl
         FguFMO6o8a06uN2ffuVkUxHv3uyeMufLHe3nJp/EUPjxj4ugv0yEUTi/ASDSvTEDFKS/
         LgUC8EIqrV1Jk4Vxg3alyN2PbEnLHXt7ROwbz1rMWYuREmfZivdP4Yhye7LIg90x/7LZ
         s9Uw==
X-Gm-Message-State: AOAM533BDX6+4WV+ZRDSjf8XTHAzggehsoT9APFAOncu5JVzn3/ukZ3L
        4ZOi10YTDtk+yNWDF649EKdPVqmTXbM=
X-Google-Smtp-Source: ABdhPJwk0jRk/eVVhjdLpd4ZLLNPaRgFiyukcQrtmci8jBvDv7dXbegbnfyeMFbEwD/oetbgX6AXTA==
X-Received: by 2002:a05:6a00:190b:b0:447:b298:423f with SMTP id y11-20020a056a00190b00b00447b298423fmr1985703pfi.10.1632776601219;
        Mon, 27 Sep 2021 14:03:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e12sm16444086pgv.82.2021.09.27.14.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:20 -0700 (PDT)
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
Subject: [PATCH stable 4.9 v3 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Mon, 27 Sep 2021 14:03:13 -0700
Message-Id: <20210927210316.3217044-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210316.3217044-1-f.fainelli@gmail.com>
References: <20210927210316.3217044-1-f.fainelli@gmail.com>
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
index ed2319663a1e..2e9872a22359 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -18,6 +18,15 @@ enum {
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
index 3d0c2e4dda1d..f272711c411f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -14,10 +14,6 @@
 #include <asm/cache.h>
 #include <asm/opcodes.h>
 
-#define PLT_ENT_STRIDE		L1_CACHE_BYTES
-#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
-#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
-
 #ifdef CONFIG_THUMB2_KERNEL
 #define PLT_ENT_LDR		__opcode_to_mem_thumb32(0xf8dff000 | \
 							(PLT_ENT_STRIDE - 4))
@@ -26,11 +22,6 @@
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

