Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE95663676
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 01:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbjAJAxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 19:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjAJAxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 19:53:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252EE1D0EA;
        Mon,  9 Jan 2023 16:53:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6C2614AC;
        Tue, 10 Jan 2023 00:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5682C433EF;
        Tue, 10 Jan 2023 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312027;
        bh=+hoosqHoVwfWOHeYONLgy7PnYKLjR/ahMvksZsAEcJk=;
        h=Date:To:From:Subject:From;
        b=YRdEPrfChHYnOXHGntNDc3Q1iEQQN9HmPfxV42XrOpxDTT8lY1lUqrWm1aMBiAa0z
         pKeRIjoOhtVLvQnWF2L3CKo1MqrQbwPAD+WIasQn8JQfUB48esPeARz6Z+KAX447rn
         wnp2XMSxGl8xTjj4f0Uu9TD0VEmcnz7gIpKe/lGc=
Date:   Mon, 09 Jan 2023 16:53:47 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, saravanak@google.com,
        catalin.marinas@arm.com, isaacmanjarres@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch added to mm-unstable branch
Message-Id: <20230110005347.D5682C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/cma.c: make kmemleak aware of all CMA regions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch

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

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

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

mm-cmac-make-kmemleak-aware-of-all-cma-regions.patch
mm-cmac-delete-kmemleak-objects-when-freeing-cma-areas-to-buddy-at-boot.patch

