Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027E3F4BD6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKHMg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:57 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82E8224D5;
        Fri,  8 Nov 2019 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216616;
        bh=0QjqhVsp76t9caeWGd64aTloHA72cawsl8X7RJI3Mjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep5n3/xy7oLti/QQ0Z1a2HgQbw6f6ySmZy7ghaaDUgku507xlvGTb4owQA2lk7aGx
         2xppmkJTUfBmf/WdUersrLeMqWzQfgDpPHnH07+R7IKEPkYKooRNMZ1fRSIl9eaWhz
         wFFjl8zDkUi+G38jhtqIhqw4bnQ40rHlzXqfsqVY=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 28/50] ARM: spectre-v1: add array_index_mask_nospec() implementation
Date:   Fri,  8 Nov 2019 13:35:32 +0100
Message-Id: <20191108123554.29004-29-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 1d4238c56f9816ce0f9c8dbe42d7f2ad81cb6613 upstream.

Add an implementation of the array_index_mask_nospec() function for
mitigating Spectre variant 1 throughout the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/barrier.h | 21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index edd9e633a84b..8514b70704de 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -108,5 +108,26 @@ do {									\
 #define smp_mb__before_atomic()	smp_mb()
 #define smp_mb__after_atomic()	smp_mb()
 
+#ifdef CONFIG_CPU_SPECTRE
+static inline unsigned long array_index_mask_nospec(unsigned long idx,
+						    unsigned long sz)
+{
+	unsigned long mask;
+
+	asm volatile(
+		"cmp	%1, %2\n"
+	"	sbc	%0, %1, %1\n"
+	CSDB
+	: "=r" (mask)
+	: "r" (idx), "Ir" (sz)
+	: "cc");
+
+	return mask;
+}
+#define array_index_mask_nospec array_index_mask_nospec
+#endif
+
+#include <asm-generic/barrier.h>
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_BARRIER_H */
-- 
2.20.1

