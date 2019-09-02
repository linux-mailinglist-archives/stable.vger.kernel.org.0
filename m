Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB38FA5AD7
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfIBPy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 11:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfIBPy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 11:54:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3822D217D7;
        Mon,  2 Sep 2019 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567439666;
        bh=HMwyh/e6yuiazEWDmWTrxtN8R7FLKODjf5dUfshAxQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbRvuexgwBsiQlMqtf0kEICmFvBY8Pcf7VhHUI5k8CyEzoS0+Bc50hycoq273oGOB
         kN6W1UMx/Szw7MIj5e6zeVveRR5neZTYnsERXyEDf3eRsL1f7LKqE2XrgLQ0IUBAhG
         dFniv99KVFplEhrchKtJE3C6fJ4ISwdL5U2CdSmc=
Date:   Mon, 2 Sep 2019 17:54:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tyler Hicks <tyhicks@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Todd Kjos <tkjos@android.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 4.19 11/29] binder: take read mode of mmap_sem in
 binder_alloc_free_page()
Message-ID: <20190902155424.GA21884@kroah.com>
References: <20190829105009.2265-1-sashal@kernel.org>
 <20190829105009.2265-11-sashal@kernel.org>
 <20190829151320.GC27650@elm>
 <20190830062910.GC15257@kroah.com>
 <20190830073019.GA16891@elm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830073019.GA16891@elm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 30, 2019 at 02:30:19AM -0500, Tyler Hicks wrote:
> On 2019-08-30 08:29:10, Greg Kroah-Hartman wrote:
> > On Thu, Aug 29, 2019 at 10:13:20AM -0500, Tyler Hicks wrote:
> > > Hello, Sasha!
> > > 
> > > On 2019-08-29 06:49:51, Sasha Levin wrote:
> > > > From: Tyler Hicks <tyhicks@canonical.com>
> > > > 
> > > > [ Upstream commit 60d4885710836595192c42d3e04b27551d30ec91 ]
> > > > 
> > > > Restore the behavior of locking mmap_sem for reading in
> > > > binder_alloc_free_page(), as was first done in commit 3013bf62b67a
> > > > ("binder: reduce mmap_sem write-side lock"). That change was
> > > > inadvertently reverted by commit 5cec2d2e5839 ("binder: fix race between
> > > > munmap() and direct reclaim").
> > > > 
> > > > In addition, change the name of the label for the error path to
> > > > accurately reflect that we're taking the lock for reading.
> > > > 
> > > > Backporting note: This fix is only needed when *both* of the commits
> > > > mentioned above are applied. That's an unlikely situation since they
> > > > both landed during the development of v5.1 but only one of them is
> > > > targeted for stable.
> > > 
> > > This patch isn't meant to be applied to 4.19 since commit 3013bf62b67a
> > > ("binder: reduce mmap_sem write-side lock") was never brought back to
> > > 4.19.
> > > 
> > > Tyler
> > > 
> > > > 
> > > > Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
> > 
> > But this commit is in 4.19.49
> 
> That's correct but commit 3013bf62b67a isn't present in 4.19.y. See the
> "Backporting note" above.

Heh, I never read that part of the text, nevermind :)

greg k-h
