Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE44156CD
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhIWDny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239653AbhIWDmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A9061214;
        Thu, 23 Sep 2021 03:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368405;
        bh=Zzwvj7vFWn+QWUmFvTx3HEs3BeEv6FUcFbv3HsCfu9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKEKPrJ+boaGyoar6Ma1C7j9rpDOVCNNW4uoz+RAgMLIVbefa03z4fBRwLZZ6f+Vc
         mmIXULraKpTpJQRzdz7vx14VskeLCNg9+jSKQ8/cAja7MgjqyYHyH0+82YHKaC05Vt
         GQwtevzxvubCBiBs4atkHFHNwMeWSKPkNDJIlMBOKIFAZyGxM7UXxvy6t1txyQJSmp
         e0uXAQwOWvFTQ6hz2OgulxkzUOqW6VPNmcXaUZ4NWQi0ts0isitdI+p3bRUE+NLS90
         D0pGKjhJft2hvXlyhmU9OcJocGtPso9RK9VCGL2dPex3WmlxI/RBamU3VSd5pIR7Kr
         AfCLF0Xh+m6Dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.14 03/13] m68k: Double cast io functions to unsigned long
Date:   Wed, 22 Sep 2021 23:39:49 -0400
Message-Id: <20210923033959.1421662-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033959.1421662-1-sashal@kernel.org>
References: <20210923033959.1421662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b1a89856fbf63fffde6a4771d8f1ac21df549e50 ]

m68k builds fail widely with errors such as

arch/m68k/include/asm/raw_io.h:20:19: error:
	cast to pointer from integer of different size
arch/m68k/include/asm/raw_io.h:30:32: error:
	cast to pointer from integer of different size [-Werror=int-to-p

On m68k, io functions are defined as macros. The problem is seen if the
macro parameter variable size differs from the size of a pointer. Cast
the parameter of all io macros to unsigned long before casting it to
a pointer to fix the problem.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210907060729.2391992-1-linux@roeck-us.net
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/raw_io.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/include/asm/raw_io.h b/arch/m68k/include/asm/raw_io.h
index 05e940c29b54..cbfff90c2a69 100644
--- a/arch/m68k/include/asm/raw_io.h
+++ b/arch/m68k/include/asm/raw_io.h
@@ -31,21 +31,21 @@ extern void __iounmap(void *addr, unsigned long size);
  * two accesses to memory, which may be undesirable for some devices.
  */
 #define in_8(addr) \
-    ({ u8 __v = (*(__force volatile u8 *) (addr)); __v; })
+    ({ u8 __v = (*(__force volatile u8 *) (unsigned long)(addr)); __v; })
 #define in_be16(addr) \
-    ({ u16 __v = (*(__force volatile u16 *) (addr)); __v; })
+    ({ u16 __v = (*(__force volatile u16 *) (unsigned long)(addr)); __v; })
 #define in_be32(addr) \
-    ({ u32 __v = (*(__force volatile u32 *) (addr)); __v; })
+    ({ u32 __v = (*(__force volatile u32 *) (unsigned long)(addr)); __v; })
 #define in_le16(addr) \
-    ({ u16 __v = le16_to_cpu(*(__force volatile __le16 *) (addr)); __v; })
+    ({ u16 __v = le16_to_cpu(*(__force volatile __le16 *) (unsigned long)(addr)); __v; })
 #define in_le32(addr) \
-    ({ u32 __v = le32_to_cpu(*(__force volatile __le32 *) (addr)); __v; })
+    ({ u32 __v = le32_to_cpu(*(__force volatile __le32 *) (unsigned long)(addr)); __v; })
 
-#define out_8(addr,b) (void)((*(__force volatile u8 *) (addr)) = (b))
-#define out_be16(addr,w) (void)((*(__force volatile u16 *) (addr)) = (w))
-#define out_be32(addr,l) (void)((*(__force volatile u32 *) (addr)) = (l))
-#define out_le16(addr,w) (void)((*(__force volatile __le16 *) (addr)) = cpu_to_le16(w))
-#define out_le32(addr,l) (void)((*(__force volatile __le32 *) (addr)) = cpu_to_le32(l))
+#define out_8(addr,b) (void)((*(__force volatile u8 *) (unsigned long)(addr)) = (b))
+#define out_be16(addr,w) (void)((*(__force volatile u16 *) (unsigned long)(addr)) = (w))
+#define out_be32(addr,l) (void)((*(__force volatile u32 *) (unsigned long)(addr)) = (l))
+#define out_le16(addr,w) (void)((*(__force volatile __le16 *) (unsigned long)(addr)) = cpu_to_le16(w))
+#define out_le32(addr,l) (void)((*(__force volatile __le32 *) (unsigned long)(addr)) = cpu_to_le32(l))
 
 #define raw_inb in_8
 #define raw_inw in_be16
-- 
2.30.2

