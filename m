Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FBB40881A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhIMJZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238400AbhIMJZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:25:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAACD6101A;
        Mon, 13 Sep 2021 09:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631525067;
        bh=GMg86oIlLLx+ETn75Et6CCjLBv/Nlhtbb7ePATh9ZJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpRcJQYAjbYk0ddU/oPaybepeuhIOtwp7ger+Iyw43j7bNr3yIbwMUedjNiIdfEM2
         aZNEOB0o7Lp7TDDXTAetLzgEQIE8CTLC471JqCmeFuEStGlZKGwlg1+EFBOlQm1yZm
         4AKHktPEq2VIJ7H9KqedwVFIsHA8ei1sybkt4DZw=
Date:   Mon, 13 Sep 2021 11:24:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] f2fs: guarantee to write dirty data when enabling
 checkpoint back
Message-ID: <YT8YyIiLf0u3gifM@kroah.com>
References: <20210908220020.599899-1-jaegeuk@google.com>
 <YTmaPCd3/cpMyNEe@kroah.com>
 <YTmbhc7J5ZdVp3vI@google.com>
 <YTmcbNMRaPzQRqmf@kroah.com>
 <YTme3altl3q5lc8N@google.com>
 <YTmlAWm7g4NyM/rG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTmlAWm7g4NyM/rG@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 08:09:05AM +0200, Greg KH wrote:
> On Wed, Sep 08, 2021 at 10:42:53PM -0700, Jaegeuk Kim wrote:
> > On 09/09, Greg KH wrote:
> > > On Wed, Sep 08, 2021 at 10:28:37PM -0700, Jaegeuk Kim wrote:
> > > > On 09/09, Greg KH wrote:
> > > > > On Wed, Sep 08, 2021 at 03:00:20PM -0700, Jaegeuk Kim wrote:
> > > > > > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > > 
> > > > > > commit dddd3d65293a52c2c3850c19b1e5115712e534d8 upstream.
> > > > > > 
> > > > > > We must flush all the dirty data when enabling checkpoint back. Let's guarantee
> > > > > > that first by adding a retry logic on sync_inodes_sb(). In addition to that,
> > > > > > this patch adds to flush data in fsync when checkpoint is disabled, which can
> > > > > > mitigate the sync_inodes_sb() failures in advance.
> > > > > > 
> > > > > > Reviewed-by: Chao Yu <chao@kernel.org>
> > > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > > ---
> > > > > >  fs/f2fs/file.c  |  5 ++---
> > > > > >  fs/f2fs/super.c | 11 ++++++++++-
> > > > > >  2 files changed, 12 insertions(+), 4 deletions(-)
> > > > > 
> > > > > What stable kernel(s) are you wanting to have this backported to?
> > > > 
> > > > 5.10 please.
> > > 
> > > Why would you want to skip 5.14.y and 5.13.y?  You never want anyone to
> > > upgrade stable kernel releases and have a regression.
> > 
> > I was just looking at the essential kernel version, since the fix is only
> > related to checkpoint=disable feature used in android only. Feel free to
> > merge it into any stable kernels if you want.
> 
> No regressions for any stable releases is key here, Android is just one
> user of the kernel...
> 
> And in the future, just put a cc: stable in the signed-off-by area when
> you submit the patch and it will be handled automatically, like the
> documentation states :)

Now queued up.

greg k-h
