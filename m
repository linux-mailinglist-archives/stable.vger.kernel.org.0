Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292BD414EAE
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhIVRE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhIVREX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:04:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B180C061762;
        Wed, 22 Sep 2021 10:02:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r2so3346178pgl.10;
        Wed, 22 Sep 2021 10:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkhLdmrHmkgMMt1LbOtoU8XmiMwNfTKIfISAPG6mWV4=;
        b=AWLGCnuYxvuHY/eWdFDPkxcQLv7jJZh8vwJ7d8A6cIa3eww6dqaGbOnRFMNnTO0R/V
         RF3kvi571krgpjhGf29g5i9m8OOQsee1GkHzR9MgjeeQL8LvOnlLqpqAqUoAq5qjnCtl
         AoqY9UKJJpuevK+UaFl2RVLNMBzbw2zxeDuLK7YIwbW5t9+N+w01gl0LLO5IeLj9JALm
         OFOLia3GjbBJUoSvomNY8TnzS+0Gytyt/s8KiqqHJWNYfeqczxqK+7UyrlkzgZ42Xsl4
         mtOLrscUz/uzg6Sgw8ckqzGlcoinHeon8chJZ0I1Y2wY7lialFu5bo/kPWvn45y1+yd7
         iCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkhLdmrHmkgMMt1LbOtoU8XmiMwNfTKIfISAPG6mWV4=;
        b=7ZGPSynq5ihe0GAu0wGenr3qYKxv2Yvnnqscv/N43gwy87u+XQR+TtohaVChsUeI1F
         mndHj8DpSOte1YDqnYaonU1BDdqiwtFefi+ryQPLaBtPJQ89I6hxIAG6ThwabtSV2974
         9YkF1p5mIFMUedsUYYi5LKDp58l8Ps0cAsUseUYfKf2xYDy2zQCuXI7DwrTp5bHOvDRr
         uqnXaG+8KJZu3xU6V5E5UldqGRp3Sn9YzoFsbTeLEddXnsMVA1BuLsrVASEpq11zZBMu
         FR/UQeeecVrCY8o/jTfiZ3tiTpOixD8m4xCUF21GG1kgETOG6lWoBEFlojZg7xzTWutg
         1E4w==
X-Gm-Message-State: AOAM530xiw10+Vc9/TPCBi9lOShhkH9Y/Hlz4pdZPR4jlTbajiB9osPG
        W2CSzDWZRgrFUWSjqV/Kk+zoE1Zf8u8=
X-Google-Smtp-Source: ABdhPJyq1J1vpE3mVxEq0jyvGL3dsAj/ovf2W3NVRIDnonFLCptD7fJ0s4Opf9VFyO8EYgfQ7iV0OA==
X-Received: by 2002:a05:6a00:1ad0:b0:448:3f3a:5ad with SMTP id f16-20020a056a001ad000b004483f3a05admr161170pfv.63.1632330172243;
        Wed, 22 Sep 2021 10:02:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x128sm3061885pfd.203.2021.09.22.10.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:02:51 -0700 (PDT)
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
Subject: [PATCH stable 4.9 v2 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Wed, 22 Sep 2021 10:02:43 -0700
Message-Id: <20210922170246.190499-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170246.190499-1-f.fainelli@gmail.com>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
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

