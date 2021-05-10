Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E95378E86
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbhEJN3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhEJNW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:22:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8EDC061574;
        Mon, 10 May 2021 06:21:51 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y32so13257982pga.11;
        Mon, 10 May 2021 06:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNMN409vhgmIJzMSgLO/z7XdlSTjFBeziZjCWQllPk4=;
        b=ItqtkaXHzA9SOc+NAaVNUjbNGvlX1vpO/6aLSRhVMWMYTwXTdoJwRosAyTe9mr3aAJ
         EXgpJ+Luz/2JaHktrfICACEbsm+aTNeZWyyG6qUbLQTBiZMG+5p4TxoAbx3iFA+JFgm5
         t0PcCX6jhKHF8WMayvslT/ECNays92REEp3HIFu1i01jrzfc3csfA5EiUHAmRzj2wsmF
         fW5IQan7cINI6RJf/balIlj9CKxrzrS0Ypw4+P/igMREd+/tT6aZtxdxcDS0YS1byH0z
         5fLobHIu7wwqhqZL5e08wQBHgCZz0BeinFMxFtkCcC+DR5TJso4Ng8XrRhneK8ZZw+Cx
         Dlkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNMN409vhgmIJzMSgLO/z7XdlSTjFBeziZjCWQllPk4=;
        b=eKPlPdu6DU5AJZaadVopcM/Z9uLZzxpMeZCG653lWKaH/kwwu36QpusxfwkrTqMLMm
         gc9FALrh9bdOeocs7a3PRsP3+kjNyqjC0G9NNaJ0BtyidnYomflm4cGcqgBizoLbawHO
         AKqUEYQhOAsqBPh+YGAymEOGoznPMEXT3n4RFeRcPcpFpElydzZ/f9FCurhUp0f3Boj7
         j84uXsMBoirvRWGzXjOoStXqOucELrLuoMWB49hGoUsxNidxY2WUDx3itO8fnb+3Zxyj
         PhQ+jmbCrWWisCV+78+BPfthA6Bh+25sCrBeBM6D9UrS4kXFeTBa+V6Y4TX1urHQNVAw
         tyIQ==
X-Gm-Message-State: AOAM531PBfPPAX92YF62bKuFyo8hCyxZ4EjOTfa4FdLE7vIanGq2U9H5
        9sHXt87hx9yiu7c9G/GMqyzz05GHV7o=
X-Google-Smtp-Source: ABdhPJzB9NtITnt+5bB6ip6N5wsPp2jrZ5DDAFu2MSMXUWorHaCUUtAaEz2GhcdhX1m/dbGSg0CFPQ==
X-Received: by 2002:aa7:9992:0:b029:28e:b432:190a with SMTP id k18-20020aa799920000b029028eb432190amr24359592pfh.50.1620652910279;
        Mon, 10 May 2021 06:21:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n8sm11129351pgm.7.2021.05.10.06.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:21:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Joel Stanley <joel@jms.id.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.10 v2 3/4] ARM: 9020/1: mm: use correct section size macro to describe the FDT virtual address
Date:   Mon, 10 May 2021 06:21:10 -0700
Message-Id: <20210510132111.1690943-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510132111.1690943-1-f.fainelli@gmail.com>
References: <20210510132111.1690943-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit fc2933c133744305236793025b00c2f7d258b687 upstream

Commit

  149a3ffe62b9dbc3 ("9012/1: move device tree mapping out of linear region")

created a permanent, read-only section mapping of the device tree blob
provided by the firmware, and added a set of macros to get the base and
size of the virtually mapped FDT based on the physical address. However,
while the mapping code uses the SECTION_SIZE macro correctly, the macros
use PMD_SIZE instead, which means something entirely different on ARM when
using short descriptors, and is therefore not the right quantity to use
here. So replace PMD_SIZE with SECTION_SIZE. While at it, change the names
of the macro and its parameter to clarify that it returns the virtual
address of the start of the FDT, based on the physical address in memory.

Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/memory.h | 6 +++---
 arch/arm/kernel/setup.c       | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index bb79e52aeb90..f717d7122d9d 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -68,8 +68,8 @@
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
 #define FDT_FIXED_BASE		UL(0xff800000)
-#define FDT_FIXED_SIZE		(2 * PMD_SIZE)
-#define FDT_VIRT_ADDR(physaddr)	((void *)(FDT_FIXED_BASE | (physaddr) % PMD_SIZE))
+#define FDT_FIXED_SIZE		(2 * SECTION_SIZE)
+#define FDT_VIRT_BASE(physbase)	((void *)(FDT_FIXED_BASE | (physbase) % SECTION_SIZE))
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
@@ -111,7 +111,7 @@ extern unsigned long vectors_base;
 #define MODULES_VADDR		PAGE_OFFSET
 
 #define XIP_VIRT_ADDR(physaddr)  (physaddr)
-#define FDT_VIRT_ADDR(physaddr)  ((void *)(physaddr))
+#define FDT_VIRT_BASE(physbase)  ((void *)(physbase))
 
 #endif /* !CONFIG_MMU */
 
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 694aa6b4bd03..f90479d8b50c 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1086,7 +1086,7 @@ void __init setup_arch(char **cmdline_p)
 	void *atags_vaddr = NULL;
 
 	if (__atags_pointer)
-		atags_vaddr = FDT_VIRT_ADDR(__atags_pointer);
+		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
 	setup_processor();
 	if (atags_vaddr) {
-- 
2.25.1

