Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0B04E3C71
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiCVK3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiCVK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF39100
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3527BB81B3E
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C94C340EC;
        Tue, 22 Mar 2022 10:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647944895;
        bh=zdSWJPd8jHenyDaz4dYU1Fa6WaJYjakGUKCLLPSmctk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3GsBEFmKGtLF+h4hhOLLzhJlNwwQSCJewdB0mqno/lZEXtr3livp7knQXJw83z/Y
         Rt9fHnCnbGjgy30zpwmLFxJsklWbEQOZ2KLZyV1S6wcXGDEuv1cBPDoueEh+TbvQDY
         23P6KA8LJ1SMbEEGTVBkhjrOEYNiLUnkAJRvNHAM=
Date:   Tue, 22 Mar 2022 11:28:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH for 5.10.x 2/2] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <YjmkvPFTOkxiP29k@kroah.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
 <20220322100218.2158138-3-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322100218.2158138-3-pasic@linux.ibm.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 11:02:18AM +0100, Halil Pasic wrote:
> Unfortunately, we ended up merging an old version of the patch "fix info
> leak with DMA_FROM_DEVICE" instead of merging the latest one. Christoph
> (the swiotlb maintainer), he asked me to create an incremental fix
> (after I have pointed this out the mix up, and asked him for guidance).
> So here we go.
> 
> The main differences between what we got and what was agreed are:
> * swiotlb_sync_single_for_device is also required to do an extra bounce
> * We decided not to introduce DMA_ATTR_OVERWRITE until we have exploiters
> * The implantation of DMA_ATTR_OVERWRITE is flawed: DMA_ATTR_OVERWRITE
>   must take precedence over DMA_ATTR_SKIP_CPU_SYNC
> 
> Thus this patch removes DMA_ATTR_OVERWRITE, and makes
> swiotlb_sync_single_for_device() bounce unconditionally (that is, also
> when dir == DMA_TO_DEVICE) in order do avoid synchronising back stale
> data from the swiotlb buffer.
> 
> Let me note, that if the size used with dma_sync_* API is less than the
> size used with dma_[un]map_*, under certain circumstances we may still
> end up with swiotlb not being transparent. In that sense, this is no
> perfect fix either.
> 
> To get this bullet proof, we would have to bounce the entire
> mapping/bounce buffer. For that we would have to figure out the starting
> address, and the size of the mapping in
> swiotlb_sync_single_for_device(). While this does seem possible, there
> seems to be no firm consensus on how things are supposed to work.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
> Cc: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [pasic@linux.ibm.com: adapted for 5.10]
> ---
>  Documentation/core-api/dma-attributes.rst |  8 --------
>  include/linux/dma-mapping.h               |  8 --------
>  kernel/dma/swiotlb.c                      | 25 +++++++++++++++--------
>  3 files changed, 16 insertions(+), 25 deletions(-)

What is the git commit id of this commit in Linus's tree?

thanks,

greg k-h
