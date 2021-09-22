Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A14414EA3
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhIVREG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbhIVREB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:04:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAB1C061768;
        Wed, 22 Sep 2021 10:02:29 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so3344854pgl.10;
        Wed, 22 Sep 2021 10:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=OeXTE0J8t3tMOJYFZTC2oSzoXqJRXhT75qkT8Pi/2Cp7fE1DvXK2IgCqImYYXBYrZ4
         1CO3WimDugs6/qYaqHrTsxnTKBXV0GDc2GYrfWCysCSBLXcCJU5rpaAXSfxNzZ9XAc+s
         rO92WcDL4QpaGVRbJzIV4pQeAhpk1sfLF7U68V6GFCKfWOe0dAEyetkWNkDbjHEoPEvs
         dst3U3moOIz57z3JmuPzYMw6beWqfEx74Rt9osgYYkkaFzAh3gSW+azV+eSMpNLoEK8H
         O5ksB4HUC2RFnJ4jL30kok3DGFzj4EWydTmYk9HwfEvChmduL8A2dy3lPr5CXY6r96gb
         jT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=XwQ26PryGy6bXM5Z7J0Bz4e6kt4PSTCOIMAkfPGtDw1zBsdZKnK5snu1cXUseHs5Qn
         qNNRLiJfnEGv5vhbN/CeuQ5g4WBotthGSE8A2MZnAhRvjBudC7ikWRGnk7o7cV+q/8+a
         CWKsd+fkfwi+TJ8Uo+6+4gM4vcm0v9S4uDRckze0yzSutn+sXwsxpdnIIrPejZ2rO1Pi
         bevvUDvCGiMK5CYLklqA/duQjQuh0SL+DMWTuU5EHM66hZ0Unfd39wYq72JKGnAb8OQD
         hKXQ9hIRPzgDI6xmeHKsPJcGHGbgp2cqPxIMyPtTvjiquUaQH2kwHifl51QqUXY0w1ln
         1hFQ==
X-Gm-Message-State: AOAM5334OG121isspOp1qMi3ZCBthi/+W+Y89K3B/Ctlz79YFLYrPOVy
        RjF3Du8fJrJ5/Zo/r7pv0m2YW4uj4PA=
X-Google-Smtp-Source: ABdhPJzDEnGBhNxEj4sL452h5H+7FtzmiANEXAluhYCY1W7UgYvG3m3F8EbICkBZQ1eEzVae4LcmDQ==
X-Received: by 2002:a65:62d1:: with SMTP id m17mr652556pgv.370.1632330148306;
        Wed, 22 Sep 2021 10:02:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r76sm2796579pfc.2.2021.09.22.10.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:27 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Wed, 22 Sep 2021 10:02:07 -0700
Message-Id: <20210922170210.190410-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170210.190410-1-f.fainelli@gmail.com>
References: <20210922170210.190410-1-f.fainelli@gmail.com>
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
index 89ad0596033a..6996405770f9 100644
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

