Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007AF67BD80
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 21:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbjAYU6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 15:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbjAYU6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 15:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157DE11E9B;
        Wed, 25 Jan 2023 12:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A148B6162C;
        Wed, 25 Jan 2023 20:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECA9C433EF;
        Wed, 25 Jan 2023 20:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674680287;
        bh=hUbY+M9TmJJPJ5+B85aSe0B6jEafWmQTr6Nn09N0v/g=;
        h=Date:To:From:Subject:From;
        b=Jc/M54nPmNC/8Jnyj59ac0E6CbMXCYeO6K1B0epCVz5dbfkw6+TZ67CbdxU4oy/3L
         3kPGmolMAf0sQIFcdRvUM2A2Sj7bmQAeDOb10V9Aww9lHA64ooXOdnknimq7OvE1f5
         EyKzuOM5spyQTO0xLC43cXFununlEEvCb5KF3omM=
Date:   Wed, 25 Jan 2023 12:58:06 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, saravanak@google.com,
        catalin.marinas@arm.com, isaacmanjarres@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch removed from -mm tree
Message-Id: <20230125205806.EECA9C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/cma.c: delete kmemleak objects when freeing CMA areas to buddy at boot
has been removed from the -mm tree.  Its filename was
     mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/cma.c: delete kmemleak objects when freeing CMA areas to buddy at boot
Date: Mon, 9 Jan 2023 14:16:23 -0800

Since every CMA region is now tracked by kmemleak at the time
cma_activate_area() is invoked, and cma_activate_area() is called for each
CMA region, invoke kmemleak_free_part_phys() during cma_activate_area() to
inform kmemleak that the CMA region will be freed.  Doing so also removes
the need to invoke kmemleak_ignore_phys() when the global CMA region is
being created, as the kmemleak object for it will be deleted.

This helps resolve a crash when kmemleak and CONFIG_DEBUG_PAGEALLOC are
both enabled, since CONFIG_DEBUG_PAGEALLOC causes the CMA region to be
unmapped from the kernel's address space when the pages are freed to
buddy.  Without this patch, kmemleak will attempt to scan the CMA regions,
even though they are unmapped, which leads to a page-fault.

Link: https://lkml.kernel.org/r/20230109221624.592315-3-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/cma.c~mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot
+++ a/mm/cma.c
@@ -103,6 +103,13 @@ static void __init cma_activate_area(str
 		goto out_error;
 
 	/*
+	 * The CMA region was marked as allocated by kmemleak when it was either
+	 * dynamically allocated or statically reserved. In any case,
+	 * inform kmemleak that the region is about to be freed to the page allocator.
+	 */
+	kmemleak_free_part_phys(cma_get_base(cma), cma_get_size(cma));
+
+	/*
 	 * alloc_contig_range() requires the pfn range specified to be in the
 	 * same zone. Simplify by forcing the entire CMA resv range to be in the
 	 * same zone.
@@ -361,11 +368,6 @@ int __init cma_declare_contiguous_nid(ph
 			}
 		}
 
-		/*
-		 * kmemleak scans/reads tracked objects for pointers to other
-		 * objects but this address isn't mapped and accessible
-		 */
-		kmemleak_ignore_phys(addr);
 		base = addr;
 	}
 
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

