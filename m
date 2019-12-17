Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A253B1220D9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLQA6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34844 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfLQAvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:38 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Kl-9l; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005WK-KV; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Helge Deller" <deller@gmx.de>
Date:   Tue, 17 Dec 2019 00:46:36 +0000
Message-ID: <lsq.1576543535.901115451@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 062/136] parisc: Fix vmap memory leak in
 ioremap()/iounmap()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 513f7f747e1cba81f28a436911fba0b485878ebd upstream.

Sven noticed that calling ioremap() and iounmap() multiple times leads
to a vmap memory leak:
	vmap allocation for size 4198400 failed:
	use vmalloc=<size> to increase size

It seems we missed calling vunmap() in iounmap().

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/mm/ioremap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/parisc/mm/ioremap.c
+++ b/arch/parisc/mm/ioremap.c
@@ -2,7 +2,7 @@
  * arch/parisc/mm/ioremap.c
  *
  * (C) Copyright 1995 1996 Linus Torvalds
- * (C) Copyright 2001-2006 Helge Deller <deller@gmx.de>
+ * (C) Copyright 2001-2019 Helge Deller <deller@gmx.de>
  * (C) Copyright 2005 Kyle McMartin <kyle@parisc-linux.org>
  */
 
@@ -83,7 +83,7 @@ void __iomem * __ioremap(unsigned long p
 	addr = (void __iomem *) area->addr;
 	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
 			       phys_addr, pgprot)) {
-		vfree(addr);
+		vunmap(addr);
 		return NULL;
 	}
 
@@ -91,9 +91,11 @@ void __iomem * __ioremap(unsigned long p
 }
 EXPORT_SYMBOL(__ioremap);
 
-void iounmap(const volatile void __iomem *addr)
+void iounmap(const volatile void __iomem *io_addr)
 {
-	if (addr > high_memory)
-		return vfree((void *) (PAGE_MASK & (unsigned long __force) addr));
+	unsigned long addr = (unsigned long)io_addr & PAGE_MASK;
+
+	if (is_vmalloc_addr((void *)addr))
+		vunmap((void *)addr);
 }
 EXPORT_SYMBOL(iounmap);

