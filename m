Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062206DED4B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDLINB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDLIM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D96659B;
        Wed, 12 Apr 2023 01:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F9A62A9E;
        Wed, 12 Apr 2023 08:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED92DC433EF;
        Wed, 12 Apr 2023 08:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681287170;
        bh=4kD1X1nPDIuP65hrqHo1MNSV41ybwOyniFd+/ESov6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HSo7hxvk8+Eh91VJA/ftbToDEXJWqPBcTuS4Br4mPz3rEk8UOp1KVOq6o7Hl8nsWR
         lLEAsrejZIAvHZw/vkZ8GrcOBZFo3m8e78GoF04UiWvw3w5+7Y/bKeWEg/XhW+39xB
         kD2Ip8hCHxEHhV6ft66U2ARekS6I11GxeBbsd6p4=
Date:   Wed, 12 Apr 2023 10:12:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     stable@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 00/14] Backport of maple tree fixes for 6.1/6.2
Message-ID: <2023041216-nemeses-uproot-5d4a@gregkh>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 11:10:41AM -0400, Liam R. Howlett wrote:
> Greg,
> 
> Here are the backports of the patches for the maple tree fixes from
> 6.3-rc6 for 6.1 and 6.2.
> 
> The patches differ with a few extra patches for the maple tree, and
> changes to the mm code patch to work without the vma iterator change.
> 
> Liam R. Howlett (14):
>   maple_tree: remove GFP_ZERO from kmem_cache_alloc() and
>     kmem_cache_alloc_bulk()
>   maple_tree: fix potential rcu issue
>   maple_tree: reduce user error potential
>   maple_tree: fix handle of invalidated state in mas_wr_store_setup()
>   maple_tree: fix mas_prev() and mas_find() state handling
>   maple_tree: fix mas_skip_node() end slot detection
>   maple_tree: be more cautious about dead nodes
>   maple_tree: refine ma_state init from mas_start()
>   maple_tree: detect dead nodes in mas_start()
>   maple_tree: fix freeing of nodes in rcu mode
>   maple_tree: remove extra smp_wmb() from mas_dead_leaves()
>   maple_tree: add smp_rmb() to dead node detection
>   maple_tree: add RCU lock checking to rcu callback functions
>   mm: enable maple tree RCU mode by default.
> 
>  include/linux/mm_types.h         |   3 +-
>  kernel/fork.c                    |   3 +
>  lib/maple_tree.c                 | 389 ++++++++++++++++++++-----------
>  mm/mmap.c                        |   3 +-
>  tools/testing/radix-tree/maple.c |  18 +-
>  5 files changed, 263 insertions(+), 153 deletions(-)
> 
> -- 
> 2.39.2
> 

Thanks for these.  One of them was already in the 6.2.y and 6.1.y
releases, so I just skipped it.

greg k-h
