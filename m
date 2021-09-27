Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4368B41A10B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhI0VFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbhI0VEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:53 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026EBC061771;
        Mon, 27 Sep 2021 14:03:12 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id y186so7603029pgd.0;
        Mon, 27 Sep 2021 14:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=nrztCDDL4ORIaQ1rqekpF4Kd+WvOFqxaF+fe7fmfRF4mLxN3pESgGRsiARd8f0SBwN
         uV3Pu0yVIeJNrucCdi99jdBxv3tVuQuM/PhLL2Hrlz+lXapl5h1q6xKGjWktmKS5/qXw
         cMD4idUJVEWVUaz0P8uPWB1msoH35iWO4W+HlgTc0ulKzDQGDhoa6edhEOnv2rEyd7d0
         KlkNyqDDIX3vdSA0mUajdu9ebrGKvs/vor9MIQsqh1KSB74xDBRBELLehgYrLmCcEbiD
         2rKfVTzuoH7OvRDA3IE10ztDD5EDo49qdhr7gHpzO1xs9ZcumcQnf5+E/592lOVgkYIw
         sqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3c7+1FjEQVvXK/8I+aPaOJMr2BWsGKNeLa7wMBIJNU=;
        b=AMhOI/V5df/t962TYKGuTSXTdOpAOe4JX1mS+d0jKKpG4hFLBORR7dbI4tPcmcFhBU
         I5A8VLZz8WfM8j+agu0jk/Bi7tUcLDIo3IM9m+h6/VjBTszI32k7aQ1fTSs8Nxcu6BIV
         foxo2dlUsEBCkXaXZ0AxuhcMBxsP7j2XVUI87Y5RfETsWBdC4Km4hQMPD+v+GOnzlGub
         jxxDkvX8Y1mcq7Lq7NKi9yPNhkXEazrtzhLcsOtH/v6YDYYgN9wY53E0HXKRGl5KrsQ9
         wGYz4sJCsLEYk/sSwa9NFAYuH/iT14WnftH+y+IU3Hq/WCG6WTKqcwIGIL58Q0OaOTry
         PcvQ==
X-Gm-Message-State: AOAM530SkHLBhcvo5s2GVm5NaayyBjcv29BpRhDvzH8olKypeRFLx5oR
        2LRtEQv7tDNemaYB3W8uR3xWziDeXDM=
X-Google-Smtp-Source: ABdhPJz7d+rXV3J7u777+KSHt/E8YYZFLjLmqTv9LhalvRcR3JbchEsiUZJoMcAJOP2t6sy/Zn2JSg==
X-Received: by 2002:a63:a70e:: with SMTP id d14mr1377004pgf.431.1632776591220;
        Mon, 27 Sep 2021 14:03:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm19227652pgv.29.2021.09.27.14.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:10 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v3 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Mon, 27 Sep 2021 14:02:56 -0700
Message-Id: <20210927210259.3216965-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210259.3216965-1-f.fainelli@gmail.com>
References: <20210927210259.3216965-1-f.fainelli@gmail.com>
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

