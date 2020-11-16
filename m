Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79F92B5005
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgKPSl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgKPSl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:27 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE4020867;
        Mon, 16 Nov 2020 18:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552087;
        bh=ZR2zok4QoE9NJVlggnscUG9GdL6AZGtfkIbNXR3lMN4=;
        h=Date:From:To:Subject:From;
        b=WGeCCou+5v1L2bV9djFCK93S5iyg9bMUueoA85sNsOmWvML/2ctH6c5d+xaGewg0l
         Rz/Jz/gEThG7OdcurD/43wvnWqEqE3VRtuut0SpeU7kpwbG4dg7E864TdIus1ZRNT1
         4iYYeZSJUAQsqh0Po9laYAeYOCsjyk4pyxY36GEU=
Date:   Mon, 16 Nov 2020 10:41:26 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, fabf@skynet.be, gregkh@linuxfoundation.org,
        keescook@chromium.org, linux@roeck-us.net, mcroce@microsoft.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pmladek@suse.com, robinmholt@gmail.com, rppt@kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch removed
 from -mm tree
Message-ID: <20201116184126.TBAAN96sK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
has been removed from the -mm tree.  Its filename was
     revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Patch series "fix parsing of reboot= cmdline", v3.

The parsing of the reboot= cmdline has two major errors:

- a missing bound check can crash the system on reboot
- parsing of the cpu number only works if specified last

Fix both.


This patch (of 2):

This reverts commit 616feab753972b97.

kstrtoint() and simple_strtoul() have a subtle difference which makes them
non interchangeable: if a non digit character is found amid the parsing,
the former will return an error, while the latter will just stop parsing,
e.g.  simple_strtoul("123xyx") = 123.

The kernel cmdline reboot= argument allows to specify the CPU used for
rebooting, with the syntax `s####` among the other flags, e.g. 
"reboot=warm,s31,force", so if this flag is not the last given, it's
silently ignored as well as the subsequent ones.

Link: https://lkml.kernel.org/r/20201103214025.116799-2-mcroce@linux.microsoft.com
Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/kernel/reboot.c~revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint
+++ a/kernel/reboot.c
@@ -551,22 +551,15 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 's':
-		{
-			int rc;
-
-			if (isdigit(*(str+1))) {
-				rc = kstrtoint(str+1, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else if (str[1] == 'm' && str[2] == 'p' &&
-				   isdigit(*(str+3))) {
-				rc = kstrtoint(str+3, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else
+			if (isdigit(*(str+1)))
+				reboot_cpu = simple_strtoul(str+1, NULL, 0);
+			else if (str[1] == 'm' && str[2] == 'p' &&
+							isdigit(*(str+3)))
+				reboot_cpu = simple_strtoul(str+3, NULL, 0);
+			else
 				*mode = REBOOT_SOFT;
 			break;
-		}
+
 		case 'g':
 			*mode = REBOOT_GPIO;
 			break;
_

Patches currently in -mm which might be from mcroce@microsoft.com are

reboot-refactor-and-comment-the-cpu-selection-code.patch
reboot-allow-to-specify-reboot-mode-via-sysfs.patch
reboot-remove-cf9_safe-from-allowed-types-and-rename-cf9_force.patch

