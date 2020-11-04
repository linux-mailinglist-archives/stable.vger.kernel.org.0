Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF602A5AE6
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 01:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgKDAKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 19:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgKDAKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 19:10:37 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B217223BD;
        Wed,  4 Nov 2020 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604448635;
        bh=nM4qR27zBwVBJDObR2t2L7TxXAuBBOYmUCYOwnssXPs=;
        h=Date:From:To:Subject:From;
        b=B7IVAm50t6i8d525usgvXflD8gCd8rLmCCiIvU+aX6ZxfYMTqnUe/P1m9fAF6jfGa
         wTS0ex3lE1FapkDzUP9Ccy684Zb0Ex0syQ07UAWmN03AtnmJyMGoCEv1H1XFaWDvlb
         j9nKQAF1Cuw7u+JNq2Vgs7tXpjxW5Y8HEBoM8yS8=
Date:   Tue, 03 Nov 2020 16:10:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, robinmholt@gmail.com, pmladek@suse.com,
        pasha.tatashin@soleen.com, linux@roeck-us.net,
        keescook@chromium.org, gregkh@linuxfoundation.org, fabf@skynet.be,
        arnd@arndb.de, mcroce@microsoft.com
Subject:  +
 revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch added to -mm
 tree
Message-ID: <20201104001033.UfTtn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"
has been added to the -mm tree.  Its filename is
     revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
reboot-fix-overflow-parsing-reboot-cpu-number.patch
reboot-refactor-and-comment-the-cpu-selection-code.patch

