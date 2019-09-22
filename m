Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8765CBA4C9
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392868AbfIVSvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392064AbfIVSvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5178021A4C;
        Sun, 22 Sep 2019 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178311;
        bh=uYufKrDpTA1A5HijS+YC1Ff7fl9umsInfHim8PACkIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XB36SsuKAEEyhZtnkDIK8BTUQdWHqxqMhNLHtIv5ug/suXDE6cnIYsMKCUVYISEnG
         A3L+zWdf+x4NxNaYYOBtPFYlOKJfmiJlD8OIOcgevLvs/t6Yj3eiazIOPDK6pQ1Per
         e1pt+4j5/reLjhHYEs8K5nOL2qh8yfqKo8yYQc8Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.2 080/185] m68k: Prevent some compiler warnings in Coldfire builds
Date:   Sun, 22 Sep 2019 14:47:38 -0400
Message-Id: <20190922184924.32534-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 94c04390225bcd8283103fd0c04be20cc30cc979 ]

Since commit d3b41b6bb49e ("m68k: Dispatch nvram_ops calls to Atari or
Mac functions"), Coldfire builds generate compiler warnings due to the
unconditional inclusion of asm/atarihw.h and asm/macintosh.h.

The inclusion of asm/atarihw.h causes warnings like this:

In file included from ./arch/m68k/include/asm/atarihw.h:25:0,
                 from arch/m68k/kernel/setup_mm.c:41,
                 from arch/m68k/kernel/setup.c:3:
./arch/m68k/include/asm/raw_io.h:39:0: warning: "__raw_readb" redefined
 #define __raw_readb in_8

In file included from ./arch/m68k/include/asm/io.h:6:0,
                 from arch/m68k/kernel/setup_mm.c:36,
                 from arch/m68k/kernel/setup.c:3:
./arch/m68k/include/asm/io_no.h:16:0: note: this is the location of the previous definition
 #define __raw_readb(addr) \
...

This issue is resolved by dropping the asm/raw_io.h include. It turns out
that asm/io_mm.h already includes that header file.

Moving the relevant macro definitions helps to clarify this dependency
and make it safe to include asm/atarihw.h.

The other warnings look like this:

In file included from arch/m68k/kernel/setup_mm.c:48:0,
                 from arch/m68k/kernel/setup.c:3:
./arch/m68k/include/asm/macintosh.h:19:35: warning: 'struct irq_data' declared inside parameter list will not be visible outside of this definition or declaration
 extern void mac_irq_enable(struct irq_data *data);
                                   ^~~~~~~~
...

This issue is resolved by adding the missing linux/irq.h include.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/atarihw.h   | 9 ---------
 arch/m68k/include/asm/io_mm.h     | 6 +++++-
 arch/m68k/include/asm/macintosh.h | 1 +
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index 533008262b691..5e5601c382b80 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -22,7 +22,6 @@
 
 #include <linux/types.h>
 #include <asm/bootinfo-atari.h>
-#include <asm/raw_io.h>
 #include <asm/kmap.h>
 
 extern u_long atari_mch_cookie;
@@ -132,14 +131,6 @@ extern struct atari_hw_present atari_hw_present;
  */
 
 
-#define atari_readb   raw_inb
-#define atari_writeb  raw_outb
-
-#define atari_inb_p   raw_inb
-#define atari_outb_p  raw_outb
-
-
-
 #include <linux/mm.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index 6c03ca5bc4365..819f611dccf28 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -29,7 +29,11 @@
 #include <asm-generic/iomap.h>
 
 #ifdef CONFIG_ATARI
-#include <asm/atarihw.h>
+#define atari_readb   raw_inb
+#define atari_writeb  raw_outb
+
+#define atari_inb_p   raw_inb
+#define atari_outb_p  raw_outb
 #endif
 
 
diff --git a/arch/m68k/include/asm/macintosh.h b/arch/m68k/include/asm/macintosh.h
index d9a08bed4b128..f653b60f2afcf 100644
--- a/arch/m68k/include/asm/macintosh.h
+++ b/arch/m68k/include/asm/macintosh.h
@@ -4,6 +4,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/bootinfo-mac.h>
 
-- 
2.20.1

