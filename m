Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ABE414E94
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhIVRDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbhIVRDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:03:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0529DC061574;
        Wed, 22 Sep 2021 10:01:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id k17so3249180pff.8;
        Wed, 22 Sep 2021 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=NcoCwUx1Vysb5fmvfESOEvUJ4lGbJFrhbHeO5GgrhqCDDeow5AQdpe98mTj/wEzxfM
         25ps7EymFUZN209QD8Gutk4NT328sEaFF8a/06Cx9ZwWrZhbAAK45pYGy0T7/kQKsGN6
         C+YoUCC/CFDV50Bu2fcOPhlAl9JeW2YgkRP5nrWVMUSviSusf+UPpQ1jE+mleSzoQABk
         gmzanpHv9dpuCzaXZLRoydQ6zSvg04xi/ZKTtZfzjOXxCWJy3xoRnirCmt4/NewzMnUn
         TBPEsNEjndTum5nB3FyLappH3m/vEIf7vLaL8rvtOSHj0hLpgRsSjzscFFz4EqNtWpRl
         mYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RE9qlrpj4A/Ec+OQwHI70Yn7GuZgbAKhGWX1AXM0xpo=;
        b=FTlc9ARIKxcDeDVB2lRqMZDKY9GeWwcuxtKJpJCuX8nZbpzTiMGC8V85ATz90ARW48
         /jTAKTK06hKLuHhB1+5noXSNyCeedmDq2tmjJqVUjAfc+HkGCJvskFy1HnrHlKuO4Kp6
         MX7hDHdGbfo72FwpgxKn9JRa+v3mRPA7Hs7xhVyeD/O68ceEZh4I3yEvrwrLrSfCGyb1
         /o5/keWibzCghdTlo+6KOurgrYyoQka2a0H5y8/+nYRHHEoKkNqpNVQGzksvAUU0fi5W
         CfVcwT4utvtFeMLENm05SuQjVdJhPU7qaHg3KGYp4bZhZQlL/7ShT8Hj2n3Sn9q4V7yC
         O3XA==
X-Gm-Message-State: AOAM532s5ksUJuQQx2/cor8Pd6Fi0u7rY9880JgqgZB1AnPZC/frN5PF
        uC4K8EaaLt2a/9R341U4e7FtfFz7dg4=
X-Google-Smtp-Source: ABdhPJwx/1HPx00NTjTAXQh2HacGrpLfSM+X0rlcbfDvDbY0C5D1ORscK26/URfhsK8teJ7f0Y9UNA==
X-Received: by 2002:a63:3d4c:: with SMTP id k73mr674652pga.44.1632330112224;
        Wed, 22 Sep 2021 10:01:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7sm3101087pfh.168.2021.09.22.10.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:01:51 -0700 (PDT)
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
Subject: [PATCH stable 4.19 v2 1/4] ARM: 9077/1: PLT: Move struct plt_entries definition to header
Date:   Wed, 22 Sep 2021 10:01:25 -0700
Message-Id: <20210922170128.190321-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922170128.190321-1-f.fainelli@gmail.com>
References: <20210922170128.190321-1-f.fainelli@gmail.com>
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

