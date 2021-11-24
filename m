Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40C45BA98
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbhKXMMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241709AbhKXMKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 081D6610E9;
        Wed, 24 Nov 2021 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755565;
        bh=leETTxEOUjK8p6dO07fgcIaIw8pBK76xzUPEmbE259w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8CLjfYpMMgZT8isaUbJmLt8SiekUZrJtItsvj56Cs2cnax49saMNUSUv9thhk0Hs
         biSjiE3TSDOeK61gT+bPN0he/r0rfTTOQPlJ2uu7+Fl7yrVI6f9TRQmdG9iK4F181V
         j8bwq9QYotw+fDcDzBBGR14ioXAhixSDL1n6INQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Brian Cain <bcain@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 142/162] hexagon: export raw I/O routines for modules
Date:   Wed, 24 Nov 2021 12:57:25 +0100
Message-Id: <20211124115702.880545346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit ffb92ce826fd801acb0f4e15b75e4ddf0d189bde upstream.

Patch series "Fixes for ARCH=hexagon allmodconfig", v2.

This series fixes some issues noticed with ARCH=hexagon allmodconfig.

This patch (of 3):

When building ARCH=hexagon allmodconfig, the following errors occur:

  ERROR: modpost: "__raw_readsl" [drivers/i3c/master/svc-i3c-master.ko] undefined!
  ERROR: modpost: "__raw_writesl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
  ERROR: modpost: "__raw_readsl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
  ERROR: modpost: "__raw_writesl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!
  ERROR: modpost: "__raw_readsl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!

Export these symbols so that modules can use them without any errors.

Link: https://lkml.kernel.org/r/20211115174250.1994179-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20211115174250.1994179-2-nathan@kernel.org
Fixes: 013bf24c3829 ("Hexagon: Provide basic implementation and/or stubs for I/O routines.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/lib/io.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/hexagon/lib/io.c
+++ b/arch/hexagon/lib/io.c
@@ -40,6 +40,7 @@ void __raw_readsw(const void __iomem *ad
 		*dst++ = *src;
 
 }
+EXPORT_SYMBOL(__raw_readsw);
 
 /*
  * __raw_writesw - read words a short at a time
@@ -60,6 +61,7 @@ void __raw_writesw(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesw);
 
 /*  Pretty sure len is pre-adjusted for the length of the access already */
 void __raw_readsl(const void __iomem *addr, void *data, int len)
@@ -75,6 +77,7 @@ void __raw_readsl(const void __iomem *ad
 
 
 }
+EXPORT_SYMBOL(__raw_readsl);
 
 void __raw_writesl(void __iomem *addr, const void *data, int len)
 {
@@ -89,3 +92,4 @@ void __raw_writesl(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesl);


