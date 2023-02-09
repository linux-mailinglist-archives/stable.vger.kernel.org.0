Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40D16910D0
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBISzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBISzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:55:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F81287E;
        Thu,  9 Feb 2023 10:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22C6CB822C2;
        Thu,  9 Feb 2023 18:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2466C433D2;
        Thu,  9 Feb 2023 18:55:45 +0000 (UTC)
Date:   Thu, 9 Feb 2023 18:55:42 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shtuemov@linux.intel.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Saravana Kannan <saravanak@google.com>, linux-mm@kvack.org,
        kernel-team@android.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/1] of: reserved_mem: Have kmemleak ignore
 dynamically allocated reserved mem
Message-ID: <Y+VBrpGfwFD82PVF@arm.com>
References: <20230208232001.2052777-1-isaacmanjarres@google.com>
 <20230208232001.2052777-2-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208232001.2052777-2-isaacmanjarres@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 08, 2023 at 03:20:00PM -0800, Isaac J. Manjarres wrote:
> Currently, kmemleak ignores dynamically allocated reserved memory
> regions that don't have a kernel mapping. However, regions that do
> retain a kernel mapping (e.g. CMA regions) do get scanned by kmemleak.
> 
> This is not ideal for two reasons:
> 
> 1. kmemleak works by scanning memory regions for pointers to
> allocated objects to determine if those objects have been leaked
> or not. However, reserved memory regions can be used between drivers
> and peripherals for DMA transfers, and thus, would not contain pointers
> to allocated objects, making it unnecessary for kmemleak to scan
> these reserved memory regions.
> 
> 2. When CONFIG_DEBUG_PAGEALLOC is enabled, along with kmemleak, the
> CMA reserved memory regions are unmapped from the kernel's address
> space when they are freed to buddy at boot. These CMA reserved regions
> are still tracked by kmemleak, however, and when kmemleak attempts to
> scan them, a crash will happen, as accessing the CMA region will result
> in a page-fault, since the regions are unmapped.
> 
> Thus, use kmemleak_ignore_phys() for all dynamically allocated reserved
> memory regions, instead of those that do not have a kernel mapping
> associated with them.
> 
> Cc: <stable@vger.kernel.org>    # 5.15+
> Fixes: a7259df76702 ("memblock: make memblock_find_in_range method private")
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
