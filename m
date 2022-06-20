Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCAD551599
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiFTKSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbiFTKSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC312D02;
        Mon, 20 Jun 2022 03:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B71360F39;
        Mon, 20 Jun 2022 10:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD5C3411B;
        Mon, 20 Jun 2022 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655720299;
        bh=xbUYrGZ4lJgGxgsFFzQXmYD9L6O/YoMdaDnokqi6Zkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z8wTss+dR6BlX5Bx6Lc0LjllOqloq24Qf+DvdPAWza0do0JFMFoUZNupVcURaje8r
         uNxgMKIv9x8egrb9aBqPOR2fyyeL5DNB3cghyANk5D2o0M4exLBtYa0RDapsGUzW6q
         HPjcNwvSc0PHN++tcuAOkWsXY/knHbX1da9hpYcg=
Date:   Mon, 20 Jun 2022 12:17:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Message-ID: <YrBJVAZWOzmDyUN3@kroah.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
> can be fixed in a similar way too.
> 
> In unset_migratetype_isolate(), we also need the fix, so move page_is_buddy()
> from mm/page_alloc.c to mm/internal.h
> 
> In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
> so it would have pfn_base=512 and mem_map began with 512th PFN when
> CONFIG_FLATMEM=y.
> But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
> less than the pfn_base value. We need page_is_buddy() to verify the buddy to
> prevent accessing an invalid buddy.
> 
> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
> Cc: stable@vger.kernel.org
> Reported-by: zjb194813@alibaba-inc.com
> Reported-by: tianhu.hh@alibaba-inc.com
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c     | 37 +++----------------------------------
>  mm/page_isolation.c |  3 ++-
>  3 files changed, 39 insertions(+), 35 deletions(-)

What is the commit id of this in Linus's tree?

thanks,

greg k-h
