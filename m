Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F56689384
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 10:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjBCJV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 04:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjBCJUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 04:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BFE9DEC9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 01:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C2E61E20
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 09:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49A3C433EF;
        Fri,  3 Feb 2023 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675415964;
        bh=TpC+4TP4Vm5cHRzY4Qfn2BqtqNfv6PkJjoETZOUdg2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgrra4n5up39ifiYLiT1iyQmeiurQ4qeqRGT45cLudGFO8PZXE2hdqb3si+nDv8s0
         nehBQM9Fo/3RIj4ha1LO65Zmd/QYbZitNV+//PO0bwf2Yjxr1NCeMGiJ8SFbmA3gL5
         Ki4FvsIZoA5fqm4rOQ9CrtAn6j5rTauvY7oyGimo=
Date:   Fri, 3 Feb 2023 10:19:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATH stable 5.4] mm: swap: properly update readahead statistics
 in unuse_pte_range()
Message-ID: <Y9zRmZ2KdSMRrO4g@kroah.com>
References: <20230130152823.65880-1-luizcap@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130152823.65880-1-luizcap@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 03:28:23PM +0000, Luiz Capitulino wrote:
> From: Andrea Righi <andrea.righi@canonical.com>
> 
> Commit ebc5951eea499314f6fbbde20e295f1345c67330 upstream.
> 
> [ This fixes a performance issue we're seeing in AWS instances when
>   running swapoff and using the global readahead algorithm. For a
>   particular instance configuration, Without this fix I/O throughput
>   is very low during swapoff (about 15 MB/s) with this patch is
>   reaches 500 MB/s. Tested swapoff with different workloads with
>   this patch applied. 5.10 onwards already have this fix ]
> 
> In unuse_pte_range() we blindly swap-in pages without checking if the
> swap entry is already present in the swap cache.
> 
> By doing this, the hit/miss ratio used by the swap readahead heuristic
> is not properly updated and this leads to non-optimal performance during
> swapoff.
> 
> Tracing the distribution of the readahead size returned by the swap
> readahead heuristic during swapoff shows that a small readahead size is
> used most of the time as if we had only misses (this happens both with
> cluster and vma readahead), for example:
> 
> r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
>         COUNT      EVENT
>         36948      $retval = 8
>         44151      $retval = 4
>         49290      $retval = 1
>         527771     $retval = 2
> 
> Checking if the swap entry is present in the swap cache, instead, allows
> to properly update the readahead statistics and the heuristic behaves in a
> better way during swapoff, selecting a bigger readahead size:
> 
> r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
>         COUNT      EVENT
>         1618       $retval = 1
>         4960       $retval = 2
>         41315      $retval = 4
>         103521     $retval = 8
> 
> In terms of swapoff performance the result is the following:
> 
> Testing environment
> ===================
> 
>  - Host:
>    CPU: 1.8GHz Intel Core i7-8565U (quad-core, 8MB cache)
>    HDD: PC401 NVMe SK hynix 512GB
>    MEM: 16GB
> 
>  - Guest (kvm):
>    8GB of RAM
>    virtio block driver
>    16GB swap file on ext4 (/swapfile)
> 
> Test case
> =========
>  - allocate 85% of memory
>  - `systemctl hibernate` to force all the pages to be swapped-out to the
>    swap file
>  - resume the system
>  - measure the time that swapoff takes to complete:
>    # /usr/bin/time swapoff /swapfile
> 
> Result (swapoff time)
> ======
>                   5.6 vanilla   5.6 w/ this patch
>                   -----------   -----------------
> cluster-readahead      22.09s              12.19s
>     vma-readahead      18.20s              15.33s
> 
> Conclusion
> ==========
> 
> The specific use case this patch is addressing is to improve swapoff
> performance in cloud environments when a VM has been hibernated, resumed
> and all the memory needs to be forced back to RAM by disabling swap.
> 
> This change allows to better exploits the advantages of the readahead
> heuristic during swapoff and this improvement allows to to speed up the
> resume process of such VMs.
> 
> [andrea.righi@canonical.com: update changelog]
>   Link: http://lkml.kernel.org/r/20200418084705.GA147642@xps-13
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Anchal Agarwal <anchalag@amazon.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Vineeth Remanan Pillai <vpillai@digitalocean.com>
> Cc: Kelley Nielsen <kelleynnn@gmail.com>
> Link: http://lkml.kernel.org/r/20200416180132.GB3352@xps-13
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---

You forwarded on a backport without signing off on it yourself, sorry, I
can't take this as-is.  Please fix up and resend.

thanks,

greg k-h
