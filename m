Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D321411DA8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbhITRW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348825AbhITRU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C46613E6;
        Mon, 20 Sep 2021 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157233;
        bh=e7iKw00Iyzn8j8D3IFC/qqlpaK67JS53s9qBptL+f20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kk+fNfenfNKttyjwaU9aDfDbPIDomwYnwTdXauq2tI+sA3qCaxC4E/uMNM4/TJtN
         XnqOcRu+AG01Xk9XagMKxjuxFIqSKyBb7cj2sQZLjOKuJbsEmHl2bkUQXOZp4Cgrxt
         SnECONwpuHXxrELUBDtMlhQJJGKaSTyAv4CSQONk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        David Heidelberg <david@ixit.cz>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 115/217] ARM: 9105/1: atags_to_fdt: dont warn about stack size
Date:   Mon, 20 Sep 2021 18:42:16 +0200
Message-Id: <20210920163928.549909568@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

commit b30d0289de72c62516df03fdad8d53f552c69839 upstream.

The merge_fdt_bootargs() function by definition consumes more than 1024
bytes of stack because it has a 1024 byte command line on the stack,
meaning that we always get a warning when building this file:

arch/arm/boot/compressed/atags_to_fdt.c: In function 'merge_fdt_bootargs':
arch/arm/boot/compressed/atags_to_fdt.c:98:1: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]

However, as this is the decompressor and we know that it has a very shallow
call chain, and we do not actually risk overflowing the kernel stack
at runtime here.

This just shuts up the warning by disabling the warning flag for this
file.

Tested on Nexus 7 2012 builds.

Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/compressed/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -87,6 +87,8 @@ $(addprefix $(obj)/,$(libfdt_objs) atags
 	$(addprefix $(obj)/,$(libfdt_hdrs))
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
+CFLAGS_REMOVE_atags_to_fdt.o += -Wframe-larger-than=${CONFIG_FRAME_WARN}
+CFLAGS_atags_to_fdt.o += -Wframe-larger-than=1280
 OBJS	+= $(libfdt_objs) atags_to_fdt.o
 endif
 


