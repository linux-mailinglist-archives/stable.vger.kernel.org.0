Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F71663677
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 01:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbjAJAx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 19:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbjAJAxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 19:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961981EC44;
        Mon,  9 Jan 2023 16:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B9D1B810A9;
        Tue, 10 Jan 2023 00:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E66C433EF;
        Tue, 10 Jan 2023 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312029;
        bh=ToaOwqfBM90N62cmHYhWIUdFXOKrnYBEI1T/CW5dfzE=;
        h=Date:To:From:Subject:From;
        b=VuD5sXD375+qyEgD4w8NDCv3LWuikblzHhber1dN4n00RyJ32K264OlH9aVWMjStE
         Jwj58ToS+bhC+0xrFJSA3NQpT6jPV6mKEQh+wg4AboRGRyb6Z8cGNx6tVkdOdwyXNF
         rEbqphotlwDAti+C16e5Qll9CCR84eAr4C+Ee0IU=
Date:   Mon, 09 Jan 2023 16:53:49 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, saravanak@google.com,
        catalin.marinas@arm.com, isaacmanjarres@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch added to mm-unstable branch
Message-Id: <20230110005349.D9E66C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/cma.c: delete kmemleak objects when freeing CMA areas to buddy at boot
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

This patch will later appear in the mm-unstable branch at
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

 mm/cma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

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

mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch
mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

