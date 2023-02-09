Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19B568FE35
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 05:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjBIEF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 23:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjBIEF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 23:05:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF2F5FC6;
        Wed,  8 Feb 2023 20:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A174C6186E;
        Thu,  9 Feb 2023 04:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4341C433D2;
        Thu,  9 Feb 2023 04:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675915554;
        bh=k51pD91TkGZpYruuyhBjx1xB1Ozuv33mLgOUWYdQI1I=;
        h=Date:To:From:Subject:From;
        b=0y5vT78lFwCShRCKdavzxk8amW3qCxpxVJhCI5RrccuDYfkVMPaRUNxMMqVkQhBf8
         xaSLiT//GwpCXNYGOiALl17YWX6yRqZm3A3mSGmy7EguhZ/qP4KajwrBm3MRckooV6
         qmaOUa/+n4or3PH/02AHqY9LNjvQGzDWIwVYFVNI=
Date:   Wed, 08 Feb 2023 20:05:53 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        saravanak@google.com, rppt@kernel.org, robh@kernel.org,
        rmk+kernel@armlinux.org.uk, rafael.j.wysocki@intel.com,
        mick@ics.forth.gr, kirill.shtuemov@linux.intel.com,
        frowand.list@gmail.com, catalin.marinas@arm.com,
        isaacmanjarres@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + of-reserved_mem-have-kmemleak-ignore-dynamically-allocated-reserved-mem.patch added to mm-hotfixes-unstable branch
Message-Id: <20230209040553.E4341C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     of-reserved_mem-have-kmemleak-ignore-dynamically-allocated-reserved-mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/of-reserved_mem-have-kmemleak-ignore-dynamically-allocated-reserved-mem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem
Date: Wed, 8 Feb 2023 15:20:00 -0800

Patch series "Fix kmemleak crashes when scanning CMA regions", v2.

When trying to boot a device with an ARM64 kernel with the following
config options enabled:

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK=y

a crash is encountered when kmemleak starts to scan the list of gray
or allocated objects that it maintains. Upon closer inspection, it was
observed that these page-faults always occurred when kmemleak attempted
to scan a CMA region.

At the moment, kmemleak is made aware of CMA regions that are specified
through the devicetree to be dynamically allocated within a range of
addresses. However, kmemleak should not need to scan CMA regions or any
reserved memory region, as those regions can be used for DMA transfers
between drivers and peripherals, and thus wouldn't contain anything
useful for kmemleak.

Additionally, since CMA regions are unmapped from the kernel's address
space when they are freed to the buddy allocator at boot when
CONFIG_DEBUG_PAGEALLOC is enabled, kmemleak shouldn't attempt to access
those memory regions, as that will trigger a crash. Thus, kmemleak
should ignore all dynamically allocated reserved memory regions.


This patch (of 1):

Currently, kmemleak ignores dynamically allocated reserved memory regions
that don't have a kernel mapping.  However, regions that do retain a
kernel mapping (e.g.  CMA regions) do get scanned by kmemleak.

This is not ideal for two reasons:

1  kmemleak works by scanning memory regions for pointers to allocated
   objects to determine if those objects have been leaked or not. 
   However, reserved memory regions can be used between drivers and
   peripherals for DMA transfers, and thus, would not contain pointers to
   allocated objects, making it unnecessary for kmemleak to scan these
   reserved memory regions.

2  When CONFIG_DEBUG_PAGEALLOC is enabled, along with kmemleak, the
   CMA reserved memory regions are unmapped from the kernel's address
   space when they are freed to buddy at boot.  These CMA reserved regions
   are still tracked by kmemleak, however, and when kmemleak attempts to
   scan them, a crash will happen, as accessing the CMA region will result
   in a page-fault, since the regions are unmapped.

Thus, use kmemleak_ignore_phys() for all dynamically allocated reserved
memory regions, instead of those that do not have a kernel mapping
associated with them.

Link: https://lkml.kernel.org/r/20230208232001.2052777-1-isaacmanjarres@google.com
Link: https://lkml.kernel.org/r/20230208232001.2052777-2-isaacmanjarres@google.com
Fixes: a7259df76702 ("memblock: make memblock_find_in_range method private")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Kirill A. Shutemov <kirill.shtuemov@linux.intel.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/of/of_reserved_mem.c~of-reserved_mem-have-kmemleak-ignore-dynamically-allocated-reserved-mem
+++ a/drivers/of/of_reserved_mem.c
@@ -48,9 +48,10 @@ static int __init early_init_dt_alloc_re
 		err = memblock_mark_nomap(base, size);
 		if (err)
 			memblock_phys_free(base, size);
-		kmemleak_ignore_phys(base);
 	}
 
+	kmemleak_ignore_phys(base);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

of-reserved_mem-have-kmemleak-ignore-dynamically-allocated-reserved-mem.patch

