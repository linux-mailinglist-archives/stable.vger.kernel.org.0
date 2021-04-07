Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6D3567DE
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 11:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhDGJYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 05:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350053AbhDGJYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 05:24:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF48C061762;
        Wed,  7 Apr 2021 02:22:35 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d5-20020a17090a2a45b029014d934553c4so232586pjg.1;
        Wed, 07 Apr 2021 02:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+TWgw6kTqY++Fbxfd3CQDQjeBZ3Vc7fKTS3ggHgVhQ=;
        b=M2sUfffeZ2hnL+c1iGiVTLrm9KwGVs9zUBidMXDJPkQF5lsN5BDOIcrhqnfODxY/fD
         nZXGnLetK1FrrCoa4d6INNpkfrqfAcPNEybpLAyCAiLHKJ6dQCz7gy/Vc65+rVhnY4zj
         KkCsK3DhNrR3lmJQcU0qYUAC5iECg6K+Kk3/+fU+HXcDNSNXv+ow/9IbyD9whB5+nqfp
         IPcDW0GRVWiMTyktqaAWezW++jJBvWDnI1K3mkwelgoASi9WXf/R6ZA1T+okFpgckdJi
         71csPTpml/BbU4obMaMCx54c7TeqxtwtYo9m8EGiDAlpp9s5UeArTeZDW+JagmrVAByi
         pKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=A+TWgw6kTqY++Fbxfd3CQDQjeBZ3Vc7fKTS3ggHgVhQ=;
        b=lGlygL+AD1WEIMjNSHVswfLsAMIJbJbkMil0/0XFncW+NZtFlsfwCO+JP3jlDVqBXN
         O3RsBV7KWQEi3iui5xlsCxOufAxSw4RIA7V0NfQs8FXWc53w/VkpdEBrL2MnIxEw2zy1
         FhnZPjVGy3y83RUTFARXk9F28wJUfPiB4T94sKncsL/jScsAb6SaJT48N2+uJopMHMZl
         fC2PTL89pCJLfuEBPaaBu9CEAYTWwpVlwj4trR7gej1Q7F+v2BijMFzDpWkA2NbNTvE9
         NcETw5UU1Z8XnPvymSpLP/usCIi8WorXV3Pu+060xNoUUbQPDfq/Kjde9uhe89XSGFQP
         rjLg==
X-Gm-Message-State: AOAM533QFlQofmk6Gfvo7g+jvg55OEn/hVZHG54JilLN3kjocXAdT71/
        uJbDQa4uu0wT0QqnjJWe7cEOJYPlgP4=
X-Google-Smtp-Source: ABdhPJxyXF57a5wIABXH9FvJcrDrIOY1A7f0crYA5jYLabOno2oufKKoRKJXmTn3n1ZxhqCDovGFiw==
X-Received: by 2002:a17:902:7c88:b029:e6:f006:f8e5 with SMTP id y8-20020a1709027c88b02900e6f006f8e5mr2281396pll.1.1617787355132;
        Wed, 07 Apr 2021 02:22:35 -0700 (PDT)
Received: from localhost.localdomain ([132.145.85.142])
        by smtp.gmail.com with ESMTPSA id f14sm21849430pfk.92.2021.04.07.02.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 02:22:34 -0700 (PDT)
Sender: Huacai Chen <chenhuacai@gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
X-Google-Original-From: Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH V3] MIPS: Fix longstanding errors in div64.h
Date:   Wed,  7 Apr 2021 17:23:07 +0800
Message-Id: <20210407092307.3920801-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are four errors in div64.h caused by commit c21004cd5b4cb7d479514
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):

1, Only 32bit kernel need __div64_32(), but the above commit makes it
   depend on 64bit kernel by mistake.

2, asm-generic/div64.h should be included after __div64_32() definition.

3, __n should be initialized as *n before use (and "*__n >> 32" should
   be "__n >> 32") in __div64_32() definition.

4, linux/types.h should be included at the first place, otherwise BITS_
   PER_LONG is not defined.

Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/mips/include/asm/div64.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
index dc5ea5736440..d827c13c3bc5 100644
--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -9,12 +9,10 @@
 #ifndef __ASM_DIV64_H
 #define __ASM_DIV64_H
 
-#include <asm-generic/div64.h>
-
-#if BITS_PER_LONG == 64
-
 #include <linux/types.h>
 
+#if BITS_PER_LONG == 32
+
 /*
  * No traps on overflows for any of these...
  */
@@ -24,9 +22,9 @@
 	unsigned long __cf, __tmp, __tmp2, __i;				\
 	unsigned long __quot32, __mod32;				\
 	unsigned long __high, __low;					\
-	unsigned long long __n;						\
+	unsigned long long __n = *n;					\
 									\
-	__high = *__n >> 32;						\
+	__high = __n >> 32;						\
 	__low = __n;							\
 	__asm__(							\
 	"	.set	push					\n"	\
@@ -63,6 +61,8 @@
 	__mod32;							\
 })
 
-#endif /* BITS_PER_LONG == 64 */
+#endif /* BITS_PER_LONG == 32 */
+
+#include <asm-generic/div64.h>
 
 #endif /* __ASM_DIV64_H */
-- 
2.27.0

