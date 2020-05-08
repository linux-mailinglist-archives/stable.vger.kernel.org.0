Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBCB1CAD59
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEHNBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729924AbgEHMwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:52:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4467524959;
        Fri,  8 May 2020 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942327;
        bh=6MhnXnbtNfLJ0jlaUPyyoCpxL8tqSH1IEalC6dOkG0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J73+g/+JmFmgqxlLUbJUjTUkVovbjr9u3h3Nn+Y9YUZijysZxeMY/cAG7FYOJ2KB4
         sAQ2BjXvvMNirGjISheZWW+cUY6hFcE7rkHs4EtIFP9LFTnPASzV/7htxJ+p1q1tvj
         2zqLE2paHdSNn4i2vAxCOHmWbftXNePzxgiRd7AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 26/32] hexagon: clean up ioremap
Date:   Fri,  8 May 2020 14:35:39 +0200
Message-Id: <20200508123038.724700825@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ac32292c8552f7e8517be184e65dd09786e991f9 upstream.

Use ioremap as the main implemented function, and defined
ioremap_nocache to it as a deprecated alias.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/hexagon/include/asm/io.h       |   11 ++---------
 arch/hexagon/kernel/hexagon_ksyms.c |    2 +-
 arch/hexagon/mm/ioremap.c           |    2 +-
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/arch/hexagon/include/asm/io.h
+++ b/arch/hexagon/include/asm/io.h
@@ -186,16 +186,9 @@ static inline void writel(u32 data, vola
 
 #define mmiowb()
 
-/*
- * Need an mtype somewhere in here, for cache type deals?
- * This is probably too long for an inline.
- */
-void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size);
+void __iomem *ioremap(unsigned long phys_addr, unsigned long size);
+#define ioremap_nocache ioremap
 
-static inline void __iomem *ioremap(unsigned long phys_addr, unsigned long size)
-{
-	return ioremap_nocache(phys_addr, size);
-}
 
 static inline void iounmap(volatile void __iomem *addr)
 {
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(__vmgetie);
 EXPORT_SYMBOL(__vmsetie);
 EXPORT_SYMBOL(__vmyield);
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(ioremap_nocache);
+EXPORT_SYMBOL(ioremap);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 
--- a/arch/hexagon/mm/ioremap.c
+++ b/arch/hexagon/mm/ioremap.c
@@ -22,7 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 
-void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap(unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_addr, addr;
 	unsigned long offset = phys_addr & ~PAGE_MASK;


