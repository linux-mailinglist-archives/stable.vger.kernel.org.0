Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D32F074
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfE3DRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731277AbfE3DRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:52 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB53024718;
        Thu, 30 May 2019 03:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186271;
        bh=FK2eOd6gHPjeb/9Nqb6dWLlgwBjcGSNJNwoAgFaYeMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdrWrCzcPblbCedEqY7kE6YGcDJGVQQva9P+072XIK9Qj8Y/iLFs/Drv/xapWlFuJ
         5VgONGmKYmPNsrOhzayoWzwMFMuz4MoUHar4QYOYjdt6vXkdynYdaDfpQo/4qvwLJD
         oBrkmDGThcq6z6Tav2SC3YEC38eWQsFDKiL57pJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/276] sh: sh7786: Add explicit I/O cast to sh7786_mm_sel()
Date:   Wed, 29 May 2019 20:06:10 -0700
Message-Id: <20190530030538.397622651@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
index 96b8cb1f754a9..029bbadaf7ab5 100644
--- a/arch/sh/include/cpu-sh4/cpu/sh7786.h
+++ b/arch/sh/include/cpu-sh4/cpu/sh7786.h
@@ -135,7 +135,7 @@ enum {
 
 static inline u32 sh7786_mm_sel(void)
 {
-	return __raw_readl(0xFC400020) & 0x7;
+	return __raw_readl((const volatile void __iomem *)0xFC400020) & 0x7;
 }
 
 #endif /* __CPU_SH7786_H__ */
-- 
2.20.1



