Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66859413F98
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 04:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhIVCmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 22:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhIVCmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 22:42:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E791C061757;
        Tue, 21 Sep 2021 19:40:36 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c1so1367606pfp.10;
        Tue, 21 Sep 2021 19:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWRcCpDBCE+vzsQtuqngj9goI5v+Yy84JYj8ZdWoLcc=;
        b=ggF4k+/qIeKqYB0SXSyukrmuk5mVk4fF+YJ87pp8awDVgnfl+9/tP0lrRcgj5Q+eAO
         +cI2EX8DE6BqxSyr6Bu0Bnrk3z7PSU4F0mlgWLVT+ZIdyktAGN0GO3nUaEn3zH0x3Xoz
         e72vzS25btSexZnAK7tjiccKeZz5kuk+2hfpB3IbPsUAP35QL07gnc35dIRgxdBSLhQo
         Geqpgv1kJV7HGe1dWUa+f9vf8QrAFAwun/IQ3lO+T6q5XMH5BEGHkft38JGxfuv9492a
         nAvdYpGT2XEy1KU7USoAEvl7Kd+IJsRUp+NqWehGNLM9h0MKdka3faxSSh+VPRfR3AaN
         YHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWRcCpDBCE+vzsQtuqngj9goI5v+Yy84JYj8ZdWoLcc=;
        b=jsko+Uq2u+1y19mJscZplk8lWcAlLJfGecjayi3wWeMQow8h3G+8tiYC9c8pmCdIZR
         Qc/v52GWV8A8JHfUz5CIFvyjJ9nDn12HJCuvFnubAFz5PJZS+iCXbfb5ajAFr05xEkgu
         eNVZnUkC16TI+d7f7x4OOYnqBFPgsy0bGtt7y01kKaIxJExz4qtvcM1eIMWP6Gc66wzk
         EsdQznM/MF6v83vTl7xDS56yv1+MQAw4fagge9CzF1HbvK1ezG4GAGoINe2jh7TiJ8ni
         P19TKrNZmOY93pEiRgcteE62PvYlbj0CfoJji7Q10N7X6l8XWhiqUSyCdJyHsBnHX11M
         PH7g==
X-Gm-Message-State: AOAM530xkZHJf6nkPXqF1YShsWZ4gzaRbj86+5nQ1qF65OC6eB5BQnAe
        Q1lUcvf1V/4mK89x1m5wLRBEUwKbl8I=
X-Google-Smtp-Source: ABdhPJyMU3lpPamsoSICnUg21BfJXjONxL2/MhqpH3TGVZIGN6dAJ5xnt9KYrcUtSPQdtvp+2Qc89g==
X-Received: by 2002:aa7:9094:0:b0:42a:ea30:5509 with SMTP id i20-20020aa79094000000b0042aea305509mr33663685pfa.30.1632278435250;
        Tue, 21 Sep 2021 19:40:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b85sm438328pfb.0.2021.09.21.19.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 19:40:34 -0700 (PDT)
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
Subject: [PATCH stable 5.4 1/3] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Tue, 21 Sep 2021 19:40:17 -0700
Message-Id: <20210922024019.59726-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922024019.59726-1-f.fainelli@gmail.com>
References: <20210922024019.59726-1-f.fainelli@gmail.com>
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

