Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC10330457
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCGTlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 14:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhCGTkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 14:40:47 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2000C06174A;
        Sun,  7 Mar 2021 11:40:42 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t25so5017516pga.2;
        Sun, 07 Mar 2021 11:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bnz5/dN9339RrRu3KShS6i5PlP1+9kZIaFyxkuBBjkw=;
        b=OKQDl/rd3jQpKdyMnlFZX94JTf3btMFgEma6CEAi81UmMgYa1PQFvXWw+W99wBpfxf
         9svETjt4h0dCHWpG0fsIrHucaSQ0upRRpQkYobe9uNcyKRIOCOyyxK3FpK+jcSD7i43F
         6iTjZQ3Ld2juqcm2yaEEs9OrZhY4rxFF2Tasuu9+YJl9Z0oAMGhQW2a0rcxiBuMRsPXK
         VsLYVZJIjSCcM0U3/pLFr3BVvBUxE4iTxpezJbRo4oVeH1cmtr8ItgG00EFuPdE2Tbyw
         JNaztQoJdjfz7QvUfU9IjsAp1g2DKRkZMFbEzuFL6/HgvBdKyapS8ITKlWkEGs8iJf6U
         6KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bnz5/dN9339RrRu3KShS6i5PlP1+9kZIaFyxkuBBjkw=;
        b=WIt23HN5WFpAjFbZkuAPusZpNznEaRH3etnkcgAog4YLMm7c1o+VuJOXcw5UMbrQ2V
         ExZGlL1QJKJssE4NGn4eupu6gXFmAN7WBzSxnY/nwhE6H6FQ1D75m3z2CuNWbimvR8ZI
         QMG0lGeSYHwZnjF59vBM7KCdCpovFwZC4uRL2XHsF/J5mQrTc1DMd2JAE6pVOmLT1j1g
         lV2/oa8B4Mdkrc36dNiO9KNugAh1K1+Bwc4BrbfAEJJ+hsZrXZ+xbsjZXTownKldlUhk
         SDEZvuY6XR2VMNY8KhcTDDY9heyONzy+bREf5oI5+f53Sa+MYwiQyCg86x5yNp/Pfoy6
         bUhQ==
X-Gm-Message-State: AOAM530Kgyy/UcmAymCOtnfhxw/huqFN68Y755TWQfTdrf/SjAu4ndN8
        EfMiGpSUu4ZSdM37eoW070I=
X-Google-Smtp-Source: ABdhPJzlgEx9VvSFRTnYchQfsNnVN79V8qoZ3yUHMgGknD5BN4oTG2YOABEz1g3WfpbnWHtlg8FtTQ==
X-Received: by 2002:aa7:92cb:0:b029:1f1:542f:2b2b with SMTP id k11-20020aa792cb0000b02901f1542f2b2bmr12294563pfa.31.1615146042241;
        Sun, 07 Mar 2021 11:40:42 -0800 (PST)
Received: from z640-arch.lan ([2602:3f:e6a6:5d00::678])
        by smtp.gmail.com with ESMTPSA id t22sm8629087pjo.45.2021.03.07.11.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 11:40:41 -0800 (PST)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Youling Tang <tangyouling@loongson.cn>
Cc:     Tobias Wolf <dev-NTEO@vplace.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: fix memory reservation for non-usermem setups
Date:   Sun,  7 Mar 2021 11:40:30 -0800
Message-Id: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Wolf <dev-NTEO@vplace.de>

Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
not. As the prerequisite of custom memory map has been removed, this results
in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
platform.

This patch adds the originally intended prerequisite again.

This patch has been present in OpenWrt tree for over 2 years:
https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=93bfafb8dc209f153022796d9e747149e66cc29e

Fixes: 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling")
Signed-off-by: Tobias Wolf <dev-NTEO@vplace.de>
[Reword commit message]
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Marcin Nowakowski <marcin.nowakowski@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 arch/mips/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 279be0153f8b..97e3a0db651b 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -251,6 +251,8 @@ static unsigned long __init init_initrd(void)
  * Initialize the bootmem allocator. It also setup initrd related data
  * if needed.
  */
+static int usermem __initdata;
+
 #if defined(CONFIG_SGI_IP27) || (defined(CONFIG_CPU_LOONGSON64) && defined(CONFIG_NUMA))
 
 static void __init bootmem_init(void)
@@ -290,7 +292,7 @@ static void __init bootmem_init(void)
 	/*
 	 * Reserve any memory between the start of RAM and PHYS_OFFSET
 	 */
-	if (ramstart > PHYS_OFFSET)
+	if (usermem && ramstart > PHYS_OFFSET)
 		memblock_reserve(PHYS_OFFSET, ramstart - PHYS_OFFSET);
 
 	if (PFN_UP(ramstart) > ARCH_PFN_OFFSET) {
@@ -338,8 +340,6 @@ static void __init bootmem_init(void)
 
 #endif	/* CONFIG_SGI_IP27 */
 
-static int usermem __initdata;
-
 static int __init early_parse_mem(char *p)
 {
 	phys_addr_t start, size;
-- 
2.30.1

