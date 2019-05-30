Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45E82F554
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfE3EqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbfE3DLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:44 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E49C244FC;
        Thu, 30 May 2019 03:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185902;
        bh=JiKLfGdF1GBvxS/NHn/yixWD70lJRE3tN76wzctWgYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lw2P+prs42dAwb11Sw0mXBOs/dJ2FvUDdL76szxreQz0cXIcCIOWE6jG8+IPUBxHf
         dmlnkw5jfC/+XTnk81yzBwiO/5uqUbqcfM0VchCQw+VxFpYMluUbJ8/fyzqWAtoXz8
         Cfgbg+FO6lN4LgmBk9+ylNaW7b+mqk87hxpPuxv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 272/405] sh: sh7786: Add explicit I/O cast to sh7786_mm_sel()
Date:   Wed, 29 May 2019 20:04:30 -0700
Message-Id: <20190530030554.657716581@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8440bb9b944c02222c7a840d406141ed42e945cd ]

When compile-testing on arm:

    arch/sh/include/cpu-sh4/cpu/sh7786.h: In function ‘sh7786_mm_sel’:
    arch/sh/include/cpu-sh4/cpu/sh7786.h:135:21: warning: passing argument 1 of ‘__raw_readl’ makes pointer from integer without a cast [-Wint-conversion]
      return __raw_readl(0xFC400020) & 0x7;
			 ^~~~~~~~~~
    In file included from include/linux/io.h:25:0,
		     from arch/sh/include/cpu-sh4/cpu/sh7786.h:14,
		     from drivers/pinctrl/sh-pfc/pfc-sh7786.c:15:
    arch/arm/include/asm/io.h:113:21: note: expected ‘const volatile void *’ but argument is of type ‘unsigned int’
     #define __raw_readl __raw_readl
			 ^
    arch/arm/include/asm/io.h:114:19: note: in expansion of macro ‘__raw_readl’
     static inline u32 __raw_readl(const volatile void __iomem *addr)
		       ^~~~~~~~~~~

__raw_readl() on SuperH is a macro that casts the passed I/O address to
the correct type, while the implementations on most other architectures
expect to be passed the correct pointer type.

Add an explicit cast to fix this.

Note that this also gets rid of a sparse warning on SuperH:

    arch/sh/include/cpu-sh4/cpu/sh7786.h:135:16: warning: incorrect type in argument 1 (different base types)
    arch/sh/include/cpu-sh4/cpu/sh7786.h:135:16:    expected void const volatile [noderef] <asn:2>*<noident>
    arch/sh/include/cpu-sh4/cpu/sh7786.h:135:16:    got unsigned int

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/cpu-sh4/cpu/sh7786.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/include/cpu-sh4/cpu/sh7786.h b/arch/sh/include/cpu-sh4/cpu/sh7786.h
index 8f9bfbf3cdb10..d6cce65b48713 100644
--- a/arch/sh/include/cpu-sh4/cpu/sh7786.h
+++ b/arch/sh/include/cpu-sh4/cpu/sh7786.h
@@ -132,7 +132,7 @@ enum {
 
 static inline u32 sh7786_mm_sel(void)
 {
-	return __raw_readl(0xFC400020) & 0x7;
+	return __raw_readl((const volatile void __iomem *)0xFC400020) & 0x7;
 }
 
 #endif /* __CPU_SH7786_H__ */
-- 
2.20.1



