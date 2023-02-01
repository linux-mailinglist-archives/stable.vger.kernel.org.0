Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AE4685C56
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjBAApV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjBAApM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4034551C7E;
        Tue, 31 Jan 2023 16:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04936175A;
        Wed,  1 Feb 2023 00:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3336CC433D2;
        Wed,  1 Feb 2023 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212310;
        bh=xlf9bGU48+SnDhZ4w89ISkqujpEh9Ulqm/zUn92nDYA=;
        h=Date:To:From:Subject:From;
        b=UytXmMPeb+B24ikjW69Hnnc/JACAGEXdHsa5FkEc+/7S8kIx94Htn3ZBeAjMKRwTJ
         vaW16Vn9qDnN/fYKHgu8Tfp8WB3TC07VUbbOTY6LECdm69lkyAijTL3M6WN14qUsv+
         pMduUWEZ3X82g7eNN50B6KhoiWw7n4UY/s1PKtJY=
Date:   Tue, 31 Jan 2023 16:45:09 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        saravanak@google.com, robh+dt@kernel.org, frowand.list@gmail.com,
        catalin.marinas@arm.com, calvinzhang.cool@gmail.com,
        isaacmanjarres@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch removed from -mm tree
Message-Id: <20230201004510.3336CC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: kmemleak: alloc gray object for reserved region with direct map"
has been removed from the -mm tree.  Its filename was
     revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
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


