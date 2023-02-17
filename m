Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2474C69AD3B
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 14:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBQN62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 08:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBQN61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 08:58:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5E56241E
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 05:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0689AB82B48
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 13:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412ACC433D2;
        Fri, 17 Feb 2023 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676642303;
        bh=8ve8sR7nn52/F4s3Fy2SmfxjEdu0l1mlnMGQYiO7yJY=;
        h=Subject:To:Cc:From:Date:From;
        b=VxXcPeBW1YERQHlk40618Iu3wvp7wZMLm7cdrfV4VXuN1aByX5fmjzodG4LYU9Nd7
         R32UcrCXR6sGjmshGjnu0lPkLqQMMRtmX8hpgaQQOuGLVOoCiN5uvcv6afOu722KzT
         cQD/4ivo4UHUzK7yRp6pY/WLomRE1Fw0LL/FhvKM=
Subject: FAILED: patch "[PATCH] of: reserved_mem: Have kmemleak ignore dynamically allocated" failed to apply to 5.15-stable tree
To:     isaacmanjarres@google.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, frowand.list@gmail.com,
        kirill.shtuemov@linux.intel.com, mick@ics.forth.gr,
        rafael.j.wysocki@intel.com, rmk+kernel@armlinux.org.uk,
        robh@kernel.org, rppt@kernel.org, saravanak@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Feb 2023 14:58:15 +0100
Message-ID: <1676642295174188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ce4d9a1ea35a ("of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem")
3ecc68349bba ("memblock: rename memblock_free to memblock_phys_free")
fa27717110ae ("memblock: drop memblock_free_early_nid() and memblock_free_early()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce4d9a1ea35ac5429e822c4106cb2859d5c71f3e Mon Sep 17 00:00:00 2001
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Wed, 8 Feb 2023 15:20:00 -0800
Subject: [PATCH] of: reserved_mem: Have kmemleak ignore dynamically allocated
 reserved mem

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
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Kirill A. Shutemov <kirill.shtuemov@linux.intel.com>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 65f3b02a0e4e..f90975e00446 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -48,9 +48,10 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 		err = memblock_mark_nomap(base, size);
 		if (err)
 			memblock_phys_free(base, size);
-		kmemleak_ignore_phys(base);
 	}
 
+	kmemleak_ignore_phys(base);
+
 	return err;
 }
 

