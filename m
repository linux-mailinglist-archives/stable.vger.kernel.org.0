Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E29509CFE
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387998AbiDUKC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388013AbiDUKCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:02:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9713239F
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 02:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B08AB8233A
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D330C385A1;
        Thu, 21 Apr 2022 09:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650535190;
        bh=uG9Y7KNlr7DuiZDhvD6RVntPkThGReRPqDKgdhxZWY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIwj4UP4RKBhL4UM556YBFRFnNTYNuAyQcCBu6433mj7/k/9w5/y4hfJ+GzFtxZBd
         YtwKcOCz7QeyLBnVT/l1WUbUSVfHYlcs2Xrpt5S8S//0r4zFZ3bvZlXmT+Np3wT31m
         VKR2SgTTeitQI9bxRXuc4l3ES9BJyIpO9TdGiDMw=
Date:   Thu, 21 Apr 2022 11:59:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marco Elver <elver@google.com>
Cc:     42.hyeyoo@gmail.com, akpm@linux-foundation.org,
        oliver.sang@intel.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y] mm, kfence: support kmem_dump_obj() for KFENCE
 objects
Message-ID: <YmErE2tiWEBAvkqE@kroah.com>
References: <165027573318316@kroah.com>
 <Yl6g3B5/d+uwHal2@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl6g3B5/d+uwHal2@elver.google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 01:45:32PM +0200, Marco Elver wrote:
> commit 2dfe63e61cc31ee59ce951672b0850b5229cd5b0 upstream.
> 
> Calling kmem_obj_info() via kmem_dump_obj() on KFENCE objects has been
> producing garbage data due to the object not actually being maintained
> by SLAB or SLUB.
> 
> Fix this by implementing __kfence_obj_info() that copies relevant
> information to struct kmem_obj_info when the object was allocated by
> KFENCE; this is called by a common kmem_obj_info(), which also calls the
> slab/slub/slob specific variant now called __kmem_obj_info().
> 
> For completeness, kmem_dump_obj() now displays if the object was
> allocated by KFENCE.
> 
> Link: https://lore.kernel.org/all/20220323090520.GG16885@xsang-OptiPlex-9020/
> Link: https://lkml.kernel.org/r/20220406131558.3558585-1-elver@google.com
> Fixes: b89fb5ef0ce6 ("mm, kfence: insert KFENCE hooks for SLUB")
> Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
> Signed-off-by: Marco Elver <elver@google.com>
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>	[slab]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [elver@google.com: backport - substitute uses of struct slab with page]
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  include/linux/kfence.h | 24 +++++++++++++++++++++
>  mm/kfence/core.c       | 21 -------------------
>  mm/kfence/kfence.h     | 21 +++++++++++++++++++
>  mm/kfence/report.c     | 47 ++++++++++++++++++++++++++++++++++++++++++
>  mm/slab.c              |  2 +-
>  mm/slab.h              |  2 +-
>  mm/slab_common.c       |  9 ++++++++
>  mm/slob.c              |  2 +-
>  mm/slub.c              |  2 +-
>  9 files changed, 105 insertions(+), 25 deletions(-)

Now queued up, thanks.

greg k-h
