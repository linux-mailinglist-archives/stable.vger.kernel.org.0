Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5367A6D8
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 00:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjAXX1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 18:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAXX1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 18:27:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9691F5E6;
        Tue, 24 Jan 2023 15:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B117D61324;
        Tue, 24 Jan 2023 23:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B30CC433EF;
        Tue, 24 Jan 2023 23:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674602841;
        bh=yQ0FnWsEfb1YLw6GUfva7gNt2F2wokzfCCHVjv0LAfs=;
        h=Date:To:From:Subject:From;
        b=0Z0ZasOfE13Fvydlys1eLPZy8zB4YcvL60hAO7HlPel5HxUKEzu75dTe044P5gj+q
         KRS/yddW2tzgOdEkJnOowWmLU24kv4k4/bH4nvck8YOK9b6u3TU8yliuHa/0k3car2
         jVysfZz0tToi6VHg4cx31QZBAdqZhl/e91iXHcFQ=
Date:   Tue, 24 Jan 2023 15:27:20 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        saravanak@google.com, robh+dt@kernel.org, frowand.list@gmail.com,
        catalin.marinas@arm.com, calvinzhang.cool@gmail.com,
        isaacmanjarres@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch added to mm-hotfixes-unstable branch
Message-Id: <20230124232721.0B30CC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm: kmemleak: alloc gray object for reserved region with direct map"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

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
Subject: Revert "mm: kmemleak: alloc gray object for reserved region with direct map"
Date: Tue, 24 Jan 2023 15:02:54 -0800

This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.

Kmemleak operates by periodically scanning memory regions for pointers to
allocated memory blocks to determine if they are leaked or not.  However,
reserved memory regions can be used for DMA transactions between a device
and a CPU, and thus, wouldn't contain pointers to allocated memory blocks,
making them inappropriate for kmemleak to scan.  Thus, revert this commit.

Link: https://lkml.kernel.org/r/20230124230254.295589-1-isaacmanjarres@google.com
Fixes: 972fa3a7c17c9 ("mm: kmemleak: alloc gray object for reserved region with direct map")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/of/fdt.c~revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map
+++ a/drivers/of/fdt.c
@@ -26,7 +26,6 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
-#include <linux/kmemleak.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -525,12 +524,9 @@ static int __init __reserved_mem_reserve
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
 		if (size &&
-		    early_init_dt_reserve_memory(base, size, nomap) == 0) {
+		    early_init_dt_reserve_memory(base, size, nomap) == 0)
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
-			if (!nomap)
-				kmemleak_alloc_phys(base, size, 0);
-		}
 		else
 			pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 			       uname, &base, (unsigned long)(size / SZ_1M));
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch
mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch
mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

