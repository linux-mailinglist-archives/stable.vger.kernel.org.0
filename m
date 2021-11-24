Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499EE45C3A4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350626AbhKXNlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349548AbhKXNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A100F63227;
        Wed, 24 Nov 2021 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758595;
        bh=UtI8oZQYedgNqDAT0GxmJgSH1NypOYlmWQnUMbG6Ieg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAHQgCzSLbDdhUSc4ko2a55isLY6AJ/d0w61Rp4WAC06iWhDYncW3UepPOAzBUJtg
         wMkHGBb1vISQ82a6Yd+sWPKkJ3URN0ZPC/6JjaRjrO6aoTl/eFE0rn3MjAhpGvXMQr
         zN4rPens6FOosOuUGG5elx7pyWYAZEYaeHprOSV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Brian Cain <bcain@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 121/154] hexagon: export raw I/O routines for modules
Date:   Wed, 24 Nov 2021 12:58:37 +0100
Message-Id: <20211124115706.200464438@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
@@ -27,6 +27,7 @@ void __raw_readsw(const void __iomem *ad
 		*dst++ = *src;
 
 }
+EXPORT_SYMBOL(__raw_readsw);
 
 /*
  * __raw_writesw - read words a short at a time
@@ -47,6 +48,7 @@ void __raw_writesw(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesw);
 
 /*  Pretty sure len is pre-adjusted for the length of the access already */
 void __raw_readsl(const void __iomem *addr, void *data, int len)
@@ -62,6 +64,7 @@ void __raw_readsl(const void __iomem *ad
 
 
 }
+EXPORT_SYMBOL(__raw_readsl);
 
 void __raw_writesl(void __iomem *addr, const void *data, int len)
 {
@@ -76,3 +79,4 @@ void __raw_writesl(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesl);


