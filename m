Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D240451E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 07:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhIIFoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 01:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhIIFoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 01:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782C761158;
        Thu,  9 Sep 2021 05:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631166175;
        bh=r9o1CP4+B7HBUCKSiENG0NPcrypHvY9dY0wYuuke0sA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCNQjT6zf4C6XVa8EEopbGip4FGZOKbtusEUVgIfNaHCmIxwQi9kJQ8iQkEwy7Qzh
         z3LmSet1HIh7HdcVoyqpDUZGFVDaUCo7BcG+hAWPBBIcrb0HqHeaEsFaCwEXW5MPQ4
         h8zCGi/2azd60XmjXnV/tdZlS2fwR3cUBeLCyQXXMbXhiqlRoSI6hA3oL36VGaRrp9
         /azXWvcceir4qBowTh7C75j9j1ecuLgJezj2dA6eNAL++y4YFQCslVvLwSlOh4agx3
         Yjn5CEAPZVOU5P/Lf9mIL3nY72Pw2CC1e3sqREDNW4FRB9XsYTcgyNL96UPEPw77ab
         muNrSQQIUANDw==
Date:   Wed, 8 Sep 2021 22:42:53 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] f2fs: guarantee to write dirty data when enabling
 checkpoint back
Message-ID: <YTme3altl3q5lc8N@google.com>
References: <20210908220020.599899-1-jaegeuk@google.com>
 <YTmaPCd3/cpMyNEe@kroah.com>
 <YTmbhc7J5ZdVp3vI@google.com>
 <YTmcbNMRaPzQRqmf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTmcbNMRaPzQRqmf@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/09, Greg KH wrote:
> On Wed, Sep 08, 2021 at 10:28:37PM -0700, Jaegeuk Kim wrote:
> > On 09/09, Greg KH wrote:
> > > On Wed, Sep 08, 2021 at 03:00:20PM -0700, Jaegeuk Kim wrote:
> > > > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > 
> > > > commit dddd3d65293a52c2c3850c19b1e5115712e534d8 upstream.
> > > > 
> > > > We must flush all the dirty data when enabling checkpoint back. Let's guarantee
> > > > that first by adding a retry logic on sync_inodes_sb(). In addition to that,
> > > > this patch adds to flush data in fsync when checkpoint is disabled, which can
> > > > mitigate the sync_inodes_sb() failures in advance.
> > > > 
> > > > Reviewed-by: Chao Yu <chao@kernel.org>
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > ---
> > > >  fs/f2fs/file.c  |  5 ++---
> > > >  fs/f2fs/super.c | 11 ++++++++++-
> > > >  2 files changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > What stable kernel(s) are you wanting to have this backported to?
> > 
> > 5.10 please.
> 
> Why would you want to skip 5.14.y and 5.13.y?  You never want anyone to
> upgrade stable kernel releases and have a regression.

I was just looking at the essential kernel version, since the fix is only
related to checkpoint=disable feature used in android only. Feel free to
merge it into any stable kernels if you want.

> 
> thanks,
> 
> greg k-h
