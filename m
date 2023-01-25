Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A791D67BD81
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 21:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbjAYU6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 15:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbjAYU6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 15:58:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42811EB0;
        Wed, 25 Jan 2023 12:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40BFCB81BAE;
        Wed, 25 Jan 2023 20:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F0C433D2;
        Wed, 25 Jan 2023 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674680286;
        bh=URAacItCUg3Q7cu5mejJIDfi+OUx4R78Ds5qjZPIRSE=;
        h=Date:To:From:Subject:From;
        b=sReDfOaOlybNTwCdj2blzDJ3zJFrp2g6Ch2iSkvKqFTJn/aDQfgHTVTujGsJ64vjE
         SwmxK31yRN/8RtZrljjDYmHI7JFOhOZBz1BQaLLh0EvRrfWCeGMik0b0OzIR6HkMoa
         AXW/LEDlCHLCCp951GxwrEExw77yNedGUt1BKhyE=
Date:   Wed, 25 Jan 2023 12:58:05 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, saravanak@google.com,
        catalin.marinas@arm.com, isaacmanjarres@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch removed from -mm tree
Message-Id: <20230125205805.DC8F0C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/cma.c: make kmemleak aware of all CMA regions
has been removed from the -mm tree.  Its filename was
     mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/cma.c: make kmemleak aware of all CMA regions
Date: Mon, 9 Jan 2023 14:16:22 -0800

Patch series "Fixes for kmemleak tracking with CMA regions".

When trying to boot a device with an ARM64 kernel with the following
config options enabled:

CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK=y

a page-fault is encountered when kmemleak starts to scan the list of gray
or allocated objects that it maintains.  Upon closer inspection, it was
observed that these page-faults always occurred when kmemleak attempted to
scan a CMA region.

At the moment, kmemleak is made aware of CMA regions that are specified
through the devicetree to be created at specific memory addresses or
dynamically allocated within a range of addresses.  However, if the CMA
region is constrained to a certain range of addresses through the command
line, the region is reserved through the memblock_reserve() function, but
kmemleak_alloc_phys() is not invoked.  Furthermore, kmemleak is never
informed about CMA regions being freed to buddy at boot, which is
problematic when CONFIG_DEBUG_PAGEALLOC is enabled, as all CMA regions are
unmapped from the kernel's address space, and subsequently causes a
page-fault when kmemleak attempts to scan any of them.

This series makes it so that kmemleak is aware of every CMA region before
they are freed to the buddy allocator, so that at that time, kmemleak can
be informed that each region is about to be freed, and thus it should not
attempt to scan those regions.


This patch (of 2):

Currently, kmemleak tracks CMA regions that are specified through the
devicetree.  However, if the global CMA region is specified through the
commandline, kmemleak will be unaware of the CMA region because
kmemleak_alloc_phys() is not invoked after memblock_reserve().  Add the
missing call to kmemleak_alloc_phys() so that all CMA regions are tracked
by kmemleak before they are freed to the page allocator in
cma_activate_area().

Link: https://lkml.kernel.org/r/20230109221624.592315-1-isaacmanjarres@google.com
Link: https://lkml.kernel.org/r/20230109221624.592315-2-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: <stable@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/cma.c~mm-cmac-make-kmemleak-aware-of-all-cma-regions
+++ a/mm/cma.c
@@ -318,6 +318,8 @@ int __init cma_declare_contiguous_nid(ph
 			ret = -EBUSY;
 			goto err;
 		}
+
+		kmemleak_alloc_phys(base, size, 0);
 	} else {
 		phys_addr_t addr = 0;
 
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

revert-mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch
mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

