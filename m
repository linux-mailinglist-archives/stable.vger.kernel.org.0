Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B3024A769
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHSUFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHSUFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 16:05:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8ED2078D;
        Wed, 19 Aug 2020 20:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597867507;
        bh=nHvO1R7E8eeOWRO2eO6KSxIkz2fBZXkK0YHHMyZRSqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jl7umYqyumTDMpKdpoG92h4Mf6HK5k7wSr58hk2CAQAkROWv674x3zbTl44cuiiU2
         kiuo+rWzm3cSdrH4mF5JCzQu5aOtfNX38MJUSEaKszfk7OTdVdZAY2vEbq9hFLJghq
         e0Yvii9cPFQyhO+kGRr2qsnps2HDIjJsg+kUlAHQ=
Date:   Wed, 19 Aug 2020 13:05:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-Id: <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
In-Reply-To: <20200819195613.24269-1-hsiangkao@redhat.com>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:

> SWP_FS doesn't mean the device is file-backed swap device,
> which just means each writeback request should go through fs
> by DIO. Or it'll just use extents added by .swap_activate(),
> but it also works as file-backed swap device.

This is very hard to understand :(

> So in order to achieve the goal of the original patch,
> SWP_BLKDEV should be used instead.
> 
> FS corruption can be observed with SSD device + XFS +
> fragmented swapfile due to CONFIG_THP_SWAP=y.
> 
> Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")

Why do you think it has taken three years to discover this?


