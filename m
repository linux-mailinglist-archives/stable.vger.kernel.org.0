Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF966BA53C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438450AbfIVSzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438440AbfIVSzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6154F222BD;
        Sun, 22 Sep 2019 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178537;
        bh=wDpL378kGVf4pMIXAYaTkF7wCXDt9A51ysKZ6bNNgTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Roullq0+4od8yfTPplBkGO/MJNkfl6Q+9dC/sz3+LCnMktPBi4ZVzToVAr+kSTDg2
         s66MOCygLka09TxerxP78AV1UYCzizcuesYpBGiW4pVmKfYTmZb3KVCeKA8cZyIf1m
         DRa+m5n4lTLflFwZ3Mft2CDgeV8ggxD4AGSH9KAM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.19 058/128] m68k: Prevent some compiler warnings in Coldfire builds
Date:   Sun, 22 Sep 2019 14:53:08 -0400
Message-Id: <20190922185418.2158-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
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
index 9000b249d225e..407a617fa3a2b 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -22,7 +22,6 @@
 
 #include <linux/types.h>
 #include <asm/bootinfo-atari.h>
-#include <asm/raw_io.h>
 #include <asm/kmap.h>
 
 extern u_long atari_mch_cookie;
@@ -126,14 +125,6 @@ extern struct atari_hw_present atari_hw_present;
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
index 782b78f8a0489..e056feabbaf0b 100644
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
index 08cee11180e69..e441517785fda 100644
--- a/arch/m68k/include/asm/macintosh.h
+++ b/arch/m68k/include/asm/macintosh.h
@@ -4,6 +4,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/bootinfo-mac.h>
 
-- 
2.20.1

