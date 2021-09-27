Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75102419B01
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhI0ROx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhI0RN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB7461357;
        Mon, 27 Sep 2021 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762580;
        bh=xlPz1IA3S/nhGlMQlYiIETy34Q3qfe1/0sG8U+HFN5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+VD8hhqQ4+RyVGqYLYt/xCNQGAB/rhLP1ELv3XM/Jzy4qFLz1xGR09iWHAxew7rX
         rHnxHiICQXtJaQnKTuOBHb/K+WMCMUTjdolOTLD1mbC+cZ3KxhA04VS7bbaulpsYz/
         sy0n+MeTGPCDE91x6JGXboJgEUAYoPTGpD+VJBgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/103] m68k: Double cast io functions to unsigned long
Date:   Mon, 27 Sep 2021 19:02:49 +0200
Message-Id: <20210927170228.432768658@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 911826ea83ce..80eb2396d01e 100644
--- a/arch/m68k/include/asm/raw_io.h
+++ b/arch/m68k/include/asm/raw_io.h
@@ -17,21 +17,21 @@
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
2.33.0



