Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE6E531244
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiEWPUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237681AbiEWPUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:20:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431045DA79
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04FF2B81117
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F25C385A9;
        Mon, 23 May 2022 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653319236;
        bh=NFxnRajJwBRWw9mfWKKMshEVwuK6ml43RM9MDwzrjUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NO1H9s6tL00SLTtzkqynmR2PWAirb/bSgC31374rjJNjck6P9qrQa+eaWlw85Mrh+
         FBGswZNGaWqP5utaHueHxeO0bweGJFx4GSllqNKyuq+ZGgyEIVtuLmTcT1Jj/h5TUL
         rtJN+EM2M7gfnCTAn1bTUbCJnBL5AcjxC/h5/JnU=
Date:   Mon, 23 May 2022 17:20:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.10 1/1] Reinstate some of "swiotlb: rework "fix info
 leak with DMA_FROM_DEVICE""
Message-ID: <YoumQWO3dYqQJ29D@kroah.com>
References: <20220523114008.297420-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220523114008.297420-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 02:40:08PM +0300, Ovidiu Panait wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.
> 
> Halil Pasic points out [1] that the full revert of that commit (revert
> in bddac7c1e02b), and that a partial revert that only reverts the
> problematic case, but still keeps some of the cleanups is probably
> better.  ￼
> 
> And that partial revert [2] had already been verified by Oleksandr
> Natalenko to also fix the issue, I had just missed that in the long
> discussion.
> 
> So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
> rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
> revert the part that caused problems.
> 
> Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
> Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
> Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [OP: backport to 5.10: adjusted context]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> This is part of CVE-2022-0854 patchset:
> [1] ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
> [2] 901c7280ca0d ("Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""")
> 
> [1] is already present in 5.10-stable.
> [2] is present in 5.17/5.16/5.15, but not in 5.10 and 5.4 branches;
> 
>  Documentation/core-api/dma-attributes.rst |  8 --------
>  include/linux/dma-mapping.h               |  8 --------
>  kernel/dma/swiotlb.c                      | 12 ++++++++----
>  3 files changed, 8 insertions(+), 20 deletions(-)

This looks much different than the backport Sasha did.  I'll drop his
and review all of this after this next round of -rc releases go out.

thanks,

greg k-h
