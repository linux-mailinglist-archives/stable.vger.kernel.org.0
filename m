Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DC11C94A
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfLLJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfLLJhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:37:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149F622527;
        Thu, 12 Dec 2019 09:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143455;
        bh=oJ1Wi824XDxsCOW+eDltih+dYyGc1ssB6AgkDwln7/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MzLG+BPoGDbAsQQFGz0+FxhYifZncRdJEGAYJZ/krqgFV9t9uHmvHD8YxubcBXuyP
         bbcnMooMOpzLc17uSgFjPKliegutg7nRg/Q5qXs0T3zgB6UB/LcE8sk6tf+pokrpbo
         ttxd1aIRQRfN3X92pYGs2z+l/gw/SSQBzzbvcp5M=
Date:   Thu, 12 Dec 2019 10:33:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 070/243] xfs: extent shifting doesnt fully
 invalidate page cache
Message-ID: <20191212093304.GC1378792@kroah.com>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150343.827226097@linuxfoundation.org>
 <20191211232613.pxegji52vf4gd3eh@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211232613.pxegji52vf4gd3eh@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 08:26:13AM +0900, Nobuhiro Iwamatsu wrote:
> On Wed, Dec 11, 2019 at 04:03:52PM +0100, Greg Kroah-Hartman wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > [ Upstream commit 7f9f71be84bcab368e58020a42f6d0dd97adf0ce ]
> > 
> > The extent shifting code uses a flush and invalidate mechainsm prior
> > to shifting extents around. This is similar to what
> > xfs_free_file_space() does, but it doesn't take into account things
> > like page cache vs block size differences, and it will fail if there
> > is a page that it currently busy.
> > 
> > xfs_flush_unmap_range() handles all of these cases, so just convert
> > xfs_prepare_shift() to us that mechanism rather than having it's own
> > special sauce.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> This commit also required following commit:
> 
> commit 1749d1ea89bdf3181328b7d846e609d5a0e53e50
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Fri Apr 26 07:30:24 2019 -0700
> 
>     xfs: add missing error check in xfs_prepare_shift()
> 
>     xfs_prepare_shift() fails to check the error return from
>     xfs_flush_unmap_range(). If the latter fails, that could lead to an
>     insert/collapse range operation over a delalloc range, which is not
>     supported.
> 
>     Add an error check and return appropriately. This is reproduced
>     rarely by generic/475.
> 
>     Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page cache")
>     Signed-off-by: Brian Foster <bfoster@redhat.com>
>     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Reviewed-by: Allison Collins <allison.henderson@oracle.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>

Now added, thanks!

greg k-h
