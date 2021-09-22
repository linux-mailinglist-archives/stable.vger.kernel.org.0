Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41FE413FA1
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhIVCmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhIVCmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:42:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D02C061575;
        Tue, 21 Sep 2021 19:41:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w6so784805pll.3;
        Tue, 21 Sep 2021 19:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=E51AjTWAxrensSPC6a7ftQDNiv9Z8/AnEw1f/Xfz/WtQLwxG5CzrtbRaXUwrPJgRfb
         Vn/cUClOPXtH/XVVKZNFzPfdrUctomkncGogTdj5LKaY/7naiypyryqgUeaRsAYNoFTS
         Y81IIqe1XJvDh4TyP64g0VOBIq5M63FiNa4gxtAFSQKc5u4whIENYWJ0SWpIYT2gNSqQ
         w8LIAD4Fon4SEd7VcVwYRwBza9+mgYhzNNVmKHj70z6rT/bZ45Z8ofE33MgogIwtLywF
         08ifF92699XbPj6IzZogkzZy9Whbsi6b5wc88lNW4l3+h3ns/q5qEDsh6KFN95AUbLT8
         2WgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=aXznvDFnxlPvKbEAIm1+w+ihWT3RMa5kxnGuZpYDNrvcSmMqF6Lu6JMbi1SnC9bmQE
         PD0YYU75FBdcK4BgzruBjAw+kIDEuKKbfKoWHCWluyMEOxo+3c/Kx/h4bcnMpPi6eQeC
         zjKjxBJE674d2PwjvcnQumITQq4TJ4p3EnPJpGe8UAYm5krGPSGLfHmR9zesn9Tv44Cz
         3bl75dIQtLK+BuTa6lCdCOvoY12WmdZbz9WzgRYpVsbMANbqUl6pBgubpUwagLZQRVyv
         w8FCRB5dP57P6cpmSpe0qaeyi16xbC4nhCvNvdLCFkc1ZLX59pGOGias/qr8v+RJEt3v
         vHGw==
X-Gm-Message-State: AOAM533iqrJQij9nv1QzRyqaaYrgLA6JmToWc/H4uQZ07Hif2qbEjSJb
        alMd2q0ilYDLT1N47nhpgwffW2RzzoI=
X-Google-Smtp-Source: ABdhPJx+z25DjTQsZ1O/7JmCv6/zYe02u1N3Lf9CYZ+PG+hImMPEisVUJD94Q/lU6AsjKfF9DiqQCQ==
X-Received: by 2002:a17:902:e793:b0:13b:9cae:5dcd with SMTP id cp19-20020a170902e79300b0013b9cae5dcdmr30319502plb.53.1632278475245;
        Tue, 21 Sep 2021 19:41:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f24sm426309pfk.198.2021.09.21.19.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:41:14 -0700 (PDT)
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
Subject: [PATCH stable 4.19 1/3] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Tue, 21 Sep 2021 19:40:46 -0700
Message-Id: <20210922024048.59818-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024048.59818-1-f.fainelli@gmail.com>
References: <20210922024048.59818-1-f.fainelli@gmail.com>
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
index 9e81b7c498d8..56d4c97e578a 100644
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

