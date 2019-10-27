Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C18E682D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbfJ0VY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbfJ0VY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:26 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6FC21726;
        Sun, 27 Oct 2019 21:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211465;
        bh=8jmxZ2IQvza0hiJBvlidENn+RvnEXJ8eFPMGst97j9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt66F4HWVux8rflFQ84v+s/5sdCScOrps654LGfOy/uJIhe7LXAsSMKlfiklN/aUL
         oz5GzeW64VY3KLmQVLFigYau3bJ51EACsfIchfrs0YTFW7jHIUXKCYsQcmR2euzgtW
         Zol/lXHfJ6WaIjfr8fkQotXRL35O9PabfPf1Qb/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sven Schnelle <svens@stackframe.org>
Subject: [PATCH 5.3 161/197] parisc: Fix vmap memory leak in ioremap()/iounmap()
Date:   Sun, 27 Oct 2019 22:01:19 +0100
Message-Id: <20191027203401.149437135@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 513f7f747e1cba81f28a436911fba0b485878ebd upstream.

Sven noticed that calling ioremap() and iounmap() multiple times leads
to a vmap memory leak:
	vmap allocation for size 4198400 failed:
	use vmalloc=<size> to increase size

It seems we missed calling vunmap() in iounmap().

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: Sven Schnelle <svens@stackframe.org>
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/mm/ioremap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/parisc/mm/ioremap.c
+++ b/arch/parisc/mm/ioremap.c
@@ -3,7 +3,7 @@
  * arch/parisc/mm/ioremap.c
  *
  * (C) Copyright 1995 1996 Linus Torvalds
- * (C) Copyright 2001-2006 Helge Deller <deller@gmx.de>
+ * (C) Copyright 2001-2019 Helge Deller <deller@gmx.de>
  * (C) Copyright 2005 Kyle McMartin <kyle@parisc-linux.org>
  */
 
@@ -84,7 +84,7 @@ void __iomem * __ioremap(unsigned long p
 	addr = (void __iomem *) area->addr;
 	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
 			       phys_addr, pgprot)) {
-		vfree(addr);
+		vunmap(addr);
 		return NULL;
 	}
 
@@ -92,9 +92,11 @@ void __iomem * __ioremap(unsigned long p
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


