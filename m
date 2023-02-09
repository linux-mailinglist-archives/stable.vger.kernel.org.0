Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E785B69001C
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 06:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBIF7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 00:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIF7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 00:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77D81B307;
        Wed,  8 Feb 2023 21:59:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA026190B;
        Thu,  9 Feb 2023 05:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B4C433EF;
        Thu,  9 Feb 2023 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675922371;
        bh=C3PzIyt2T/NB+g/Zf8/N5OjMn3X2HNTvVkA2m4KLgY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OculTekPRb8o5jkmwqmVaE7Zf0U8O5GJqyWmZdkRlXkuUXIpjxhrSe3iP5QWlV8os
         Ev1tH6HbFCUgpiwy5vwBb7n5CK6GQy+fP7f0LA3nCbWXVSnCRLXyBKBFLNOGGoyuo4
         Bggg6XiTjJ2pqaFGhALv3rmCqzV1b7jiBJzi1PSYQBI/U32qn0q88X4AZ8r8Rv6d0X
         Jk9rnpFVv9r+Qvo35TwRjEtjYPT4uuZrdc3GGmS4KVHBGfbcIT11Np/htuueEShFIq
         X/CZ6D4s0tIyWXXPBFIcdwl9OW29FmtmkYk7q7jRr5Wn5gtzAEK+gqoT9LKwAYS+DH
         ES3IJfxyBjMYw==
Date:   Thu, 9 Feb 2023 07:59:17 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "Kirill A. Shutemov" <kirill.shtuemov@linux.intel.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Saravana Kannan <saravanak@google.com>, linux-mm@kvack.org,
        kernel-team@android.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/1] of: reserved_mem: Have kmemleak ignore
 dynamically allocated reserved mem
Message-ID: <Y+SLtTXOn80YoIEN@kernel.org>
References: <20230208232001.2052777-1-isaacmanjarres@google.com>
 <20230208232001.2052777-2-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208232001.2052777-2-isaacmanjarres@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>

> ---
>  drivers/of/of_reserved_mem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 65f3b02a0e4e..f90975e00446 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -48,9 +48,10 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
>  		err = memblock_mark_nomap(base, size);
>  		if (err)
>  			memblock_phys_free(base, size);
> -		kmemleak_ignore_phys(base);
>  	}
>  
> +	kmemleak_ignore_phys(base);
> +
>  	return err;
>  }
>  
> -- 
> 2.39.1.581.gbfd45094c4-goog
> 

-- 
Sincerely yours,
Mike.
