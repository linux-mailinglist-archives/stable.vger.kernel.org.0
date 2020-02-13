Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4715C3C9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgBMPoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgBMP1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C648324676;
        Thu, 13 Feb 2020 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607661;
        bh=XWFvTXfYNzLK9xy8MuWVG8VNm3uWOjyKcLAzorH8MJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwjdiSXzILzRzNZdDRYie0i2TMGOfeoy16SOJA378qWvaUmBTLzojv6aVF1W2vxYv
         9Eiovfy/zwwsGrkTiDScepr1TC+EZN3TF9w4p/1UmtFxp/BsHP9QJUcYxpVlL/yjFQ
         cTgpg74dv7Gc9cVVNUQNIJJ80+TSmPEbmHPLVKIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 63/96] ARM: 8949/1: mm: mark free_memmap as __init
Date:   Thu, 13 Feb 2020 07:21:10 -0800
Message-Id: <20200213151903.383922742@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

commit 31f3010e60522ede237fb145a63b4af5a41718c2 upstream.

As of commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly"), free_memmap() might not always be inlined, and thus is
triggering a section warning:

WARNING: vmlinux.o(.text.unlikely+0x904): Section mismatch in reference from the function free_memmap() to the function .meminit.text:memblock_free()

Mark it as __init, since the faller (free_unused_memmap) already is.

Fixes: ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING forcibly")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -323,7 +323,7 @@ static inline void poison_init_mem(void
 		*p++ = 0xe7fddef0;
 }
 
-static inline void
+static inline void __init
 free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct page *start_pg, *end_pg;


