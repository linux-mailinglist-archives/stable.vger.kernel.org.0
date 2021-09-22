Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41043413F90
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhIVClh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhIVClg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:41:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74084C061574;
        Tue, 21 Sep 2021 19:40:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k23so1020807pji.0;
        Tue, 21 Sep 2021 19:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hta6ESAus4YnwKU4Yit7RtVqe+WClVS7262FFZl8yc=;
        b=AXf3ErLjTTOtNyRxhoH+CVWhrGAyttnLIFNrnFOK2EJ6ueuIl1Qtwmmj6a1nMf6tMH
         voX2QXvHWLzZAy3bGUBXQ74+8aifqLrjzzhKCQ1USBHb90a6TUmXor4L2FReFfFl3AoG
         47MFuvitychXfm95OJgCuwJOngXgvE8t6xmmeXyOafA1OMtG+zFkJICvwwPOh6iVXyqC
         4D7/2rHhoTWqXNdFHXLDs5wU6ovpmxtU+jCnYFbBx5ADTUgk55s/t6CP/OnE1mzVmDV4
         RyOVcXQ3lxcgWfMmCV182txi1OEG3HaNhyoAEXBIHZOMy/SAkCJKBgrnTwg/u1OztbaE
         H80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hta6ESAus4YnwKU4Yit7RtVqe+WClVS7262FFZl8yc=;
        b=HenvF1Q45vo9h9rSufsTWoINBoMtFL9vMkDWQwqnITctKxfWJT3x+bKp8DwGutv/Ep
         Vbo6AgDtgjZesq0TZwsBA0I59g8m6OuROuajZOMTQGOe1pU3i8RVFZ9ZG62UUP1G7BLY
         +msPQZYyujpc43gDUAjWbJPfDqj8igWXMMAEpT4HUGBJf4TIV86K2ruIkgOiVsxeRn+g
         FW9hoHjD6J1C4oFYDx8858YswzXHLMDyQ5fPwqxazs2wi/CMbuE4s9w5DGFbp++l1cp6
         gZISZVnqW+MRjpQJHUPxlYyiQ1Kh4+VaUmOdfbfXeELkFmztEyLa8uzqNn/EYVmXXzzI
         RGIQ==
X-Gm-Message-State: AOAM5333vU1s+lieMv7GUkUGbtPCnaXqpBaxl3Wm2uHHM4K3NiQ6/6jd
        Qk8/z1aPFNFSBx+LpT/Yuxt1OxEfggs=
X-Google-Smtp-Source: ABdhPJyn00XMRe+EFdgHgMAvb85G7YhqoFP9JgHPgIcBNbR7EKQ/p7r5mC8uPPoicaGy3Ghy4xPAbg==
X-Received: by 2002:a17:90b:605:: with SMTP id gb5mr8641119pjb.51.1632278406635;
        Tue, 21 Sep 2021 19:40:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm3805321pjl.25.2021.09.21.19.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:06 -0700 (PDT)
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
Subject: [PATCH stable 5.10 1/3] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Tue, 21 Sep 2021 19:39:45 -0700
Message-Id: <20210922023947.59636-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922023947.59636-1-f.fainelli@gmail.com>
References: <20210922023947.59636-1-f.fainelli@gmail.com>
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

