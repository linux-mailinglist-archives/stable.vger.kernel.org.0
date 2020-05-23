Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8F1DF4F7
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 07:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbgEWFXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 01:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387426AbgEWFXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 01:23:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6655E207F9;
        Sat, 23 May 2020 05:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590211383;
        bh=jcnuYjNBH5LabbOsYzGaeXyEnruzkS27cQ12H48OFz4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eyGBlWTBNDKD3EjG3BrzVOzX4TwzizZVKfDvBWRo4rkXD7cuH30DLpGN5WSaef1uD
         kejkd8rQ5cofvajIXkDiy7S5wEXP6vPWC4gIQEiPlyWm0IvVUHPa4KGGRNU6d9u5zw
         jjbmTT48LOBDSmkxYQ7Iwl9tXz6FnvU/gFQASEDg=
Date:   Fri, 22 May 2020 22:23:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, dalias@libc.org,
        davem@davemloft.net, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ysato@users.sourceforge.jp
Subject:  [patch 07/11] sh: include linux/time_types.h for sockios
Message-ID: <20200523052302._eJC5sQWp%akpm@linux-foundation.org>
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: sh: include linux/time_types.h for sockios

Using the socket ioctls on arch/sh (and only there) causes build time
problems when __kernel_old_timeval/__kernel_old_timespec are not already
visible to the compiler.

Add an explict include line for the header that defines these
structures.

Link: http://lkml.kernel.org/r/20200519131327.1836482-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Fixes: 8c709f9a0693 ("y2038: sh: remove timeval/timespec usage from headers")
Fixes: 0768e17073dc ("net: socket: implement 64-bit timestamps")
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/uapi/asm/sockios.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sh/include/uapi/asm/sockios.h~sh-include-linux-time_typesh-for-sockios
+++ a/arch/sh/include/uapi/asm/sockios.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_SH_SOCKIOS_H
 #define __ASM_SH_SOCKIOS_H
 
+#include <linux/time_types.h>
+
 /* Socket-level I/O control calls. */
 #define FIOGETOWN	_IOR('f', 123, int)
 #define FIOSETOWN 	_IOW('f', 124, int)
_
