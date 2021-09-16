Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5029440E201
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242259AbhIPQdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235730AbhIPQbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A77DC61A03;
        Thu, 16 Sep 2021 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809176;
        bh=5OR6E+o4q2AYNSRmd2mvgScYabgkc0xkTQt0UlrvFY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kmb4kARQco/B3Qpct1BIdB4Gj2vm3Zii+TrFl20OcGOCl3K9pHAbFCppFUHMeAZmJ
         7Y4eZxj0g3EHry/wsISJfPUjuGygepMe7qPJAed491ewY5Rm/HvuIvcqxiE6cO+UH/
         M6/qHlYSfXr3OxNuLtKZay3C4zYDcrz7YkUpIAAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        David Heidelberg <david@ixit.cz>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.13 058/380] ARM: 9105/1: atags_to_fdt: dont warn about stack size
Date:   Thu, 16 Sep 2021 17:56:55 +0200
Message-Id: <20210916155805.959751346@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
@@ -85,6 +85,8 @@ compress-$(CONFIG_KERNEL_LZ4)  = lz4
 libfdt_objs := fdt_rw.o fdt_ro.o fdt_wip.o fdt.o
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
+CFLAGS_REMOVE_atags_to_fdt.o += -Wframe-larger-than=${CONFIG_FRAME_WARN}
+CFLAGS_atags_to_fdt.o += -Wframe-larger-than=1280
 OBJS	+= $(libfdt_objs) atags_to_fdt.o
 endif
 ifeq ($(CONFIG_USE_OF),y)


