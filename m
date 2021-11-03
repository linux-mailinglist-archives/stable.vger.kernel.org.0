Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059C84449E0
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhKCVAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 17:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhKCVAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 17:00:17 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BE7C061714;
        Wed,  3 Nov 2021 13:57:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f8so3548097plo.12;
        Wed, 03 Nov 2021 13:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0dFQ/UQsJWaH1kYJj3rWoS4C5q2ObA8TNk2IQSTt/E=;
        b=AXEWEp3emvXTgbngg4++MXlbgCHH34v77Xce8c+ORkiO3/qFOKvu0613Q6ztFJfnPS
         VeoxlHXujoFqOXxq322zYzRFXYyauddU9hS0kdhCp9F7Yr2xVUF34o+uS2pwXVPSMc3a
         CyrLgQLFw1Duf1oMB2WN8QuOXt4V4HB3CwFyavkEpqN8dfvxmYSee7yAo8lTPnV/PWJa
         CpaaShYJCHMUSRu3yD8vPSTstS8/E2uMd9awmsBMSB/GpyeXh3Ol5jv1IYmFhT3dsdu8
         9IBtuS22yL8DvScVbbeS2BK5usQTjChqURTmsc2be3zGiw7+EmRDEwy6nXGFC/PS11Xz
         Bhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0dFQ/UQsJWaH1kYJj3rWoS4C5q2ObA8TNk2IQSTt/E=;
        b=ln/Ywxe9dFMdEO1MQdt6JuTNUaPGoWJaZL2YzS+ZltCFaOxC/w1Yz0cvEWaPQyeWTK
         BlsxelDybJyNu0gwT1i3NRtIAOj/CpHxskEhV4U3ylTscbMUPsN6M8BKENa710dz/tnp
         Wlq8CI5iiuimQi+u//hWMDJrvphiYNu5E2nm1mO3EGKaUjLPZcNAy1mN1hdrL44RiLWD
         zN9VaTkYDpTwmH6rpdadf7bhtV8vHKDDmFopr9Nr2gia5HuBc8SDCMvrQjtEDVp3GeqK
         Yn2+wkLbwjkyc93w9nc97bVxhlDj+iTdcLc7cwNOHTJjSlJx82UtAh4Y95N2rS5IfYXw
         r8BA==
X-Gm-Message-State: AOAM5306rw6A9wX7YPGzmWDw5lxdBjcvC97bJXCBhMgtd4aaBLCoistb
        owo/+25MAdcq6KHK04fovMfPhMx1qeg=
X-Google-Smtp-Source: ABdhPJx3h3YvixDAK7XkDn1NEXW/Ly0bj8zLO7l9ZanyuX8A7hDGbBtgHH352XBpCOFs5bwZzGQnXg==
X-Received: by 2002:a17:902:cec4:b0:141:cfa1:f7e with SMTP id d4-20020a170902cec400b00141cfa10f7emr26542606plg.13.1635973058968;
        Wed, 03 Nov 2021 13:57:38 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n14sm2512073pgd.68.2021.11.03.13.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:57:22 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Stefan Agner <stefan@agner.ch>,
        linux-snps-arc@lists.infradead.org (open list:SYNOPSYS ARC ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES)
Subject: [PATCH stable 4.9 1/2] mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS
Date:   Wed,  3 Nov 2021 13:57:13 -0700
Message-Id: <20211103205714.374801-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211103205714.374801-1-f.fainelli@gmail.com>
References: <20211103205714.374801-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit 02390b87a9459937cdb299e6b34ff33992512ec7 upstream

With boot-time switching between paging mode we will have variable
MAX_PHYSMEM_BITS.

Let's use the maximum variable possible for CONFIG_X86_5LEVEL=y
configuration to define zsmalloc data structures.

The patch introduces MAX_POSSIBLE_PHYSMEM_BITS to cover such case.
It also suits well to handle PAE special case.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/20180214111656.88514-3-kirill.shutemov@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[florian: drop arch/x86/include/asm/pgtable_64_types.h changes since
there is no CONFIG_X86_5LEVEL]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/x86/include/asm/pgtable-3level_types.h |  1 +
 mm/zsmalloc.c                               | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index bcc89625ebe5..f3f719d59e61 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -42,5 +42,6 @@ typedef union {
  */
 #define PTRS_PER_PTE	512
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	36
 
 #endif /* _ASM_X86_PGTABLE_3LEVEL_DEFS_H */
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8db3c2b27a17..2b7bfd97587a 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -83,18 +83,19 @@
  * This is made more complicated by various memory models and PAE.
  */
 
-#ifndef MAX_PHYSMEM_BITS
-#ifdef CONFIG_HIGHMEM64G
-#define MAX_PHYSMEM_BITS 36
-#else /* !CONFIG_HIGHMEM64G */
+#ifndef MAX_POSSIBLE_PHYSMEM_BITS
+#ifdef MAX_PHYSMEM_BITS
+#define MAX_POSSIBLE_PHYSMEM_BITS MAX_PHYSMEM_BITS
+#else
 /*
  * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
  * be PAGE_SHIFT
  */
-#define MAX_PHYSMEM_BITS BITS_PER_LONG
+#define MAX_POSSIBLE_PHYSMEM_BITS BITS_PER_LONG
 #endif
 #endif
-#define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
+
+#define _PFN_BITS		(MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 
 /*
  * Memory for allocating for handle keeps object position by
-- 
2.25.1

