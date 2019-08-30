Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745E3A2FB8
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 08:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfH3GXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 02:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfH3GXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 02:23:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650872186A;
        Fri, 30 Aug 2019 06:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567146231;
        bh=PRUhatSeU/3T/AMs4GtzyoWnaRohArYodojMqtzoabU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=swdgx3EeSI3MsNB2JN+gyh2gKdV4OMK7dXbAeJgOizr6RUJr++DN4edDVGSPIbQxt
         thdqo0EL1GE5KzHAAuHu40kZs6M/USeadSEQHm4yQV1xz8Nq6639uJSH9VzKlKnA0z
         +R6kl9HxgSSj7hszfCA3EUQyb1tRogq6pGuEYJdw=
Date:   Fri, 30 Aug 2019 08:23:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tyler Hicks <tyhicks@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Todd Kjos <tkjos@android.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 4.14 05/14] binder: take read mode of mmap_sem in
 binder_alloc_free_page()
Message-ID: <20190830062349.GB15257@kroah.com>
References: <20190829105043.2508-1-sashal@kernel.org>
 <20190829105043.2508-5-sashal@kernel.org>
 <20190829151052.GB27650@elm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829151052.GB27650@elm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 10:10:52AM -0500, Tyler Hicks wrote:
> Hello, Sasha!
> 
> On 2019-08-29 06:50:34, Sasha Levin wrote:
> > From: Tyler Hicks <tyhicks@canonical.com>
> > 
> > [ Upstream commit 60d4885710836595192c42d3e04b27551d30ec91 ]
> > 
> > Restore the behavior of locking mmap_sem for reading in
> > binder_alloc_free_page(), as was first done in commit 3013bf62b67a
> > ("binder: reduce mmap_sem write-side lock"). That change was
> > inadvertently reverted by commit 5cec2d2e5839 ("binder: fix race between
> > munmap() and direct reclaim").
> > 
> > In addition, change the name of the label for the error path to
> > accurately reflect that we're taking the lock for reading.
> > 
> > Backporting note: This fix is only needed when *both* of the commits
> > mentioned above are applied. That's an unlikely situation since they
> > both landed during the development of v5.1 but only one of them is
> > targeted for stable.
> 
> This patch isn't meant to be applied to 4.14 since commit 3013bf62b67a
> ("binder: reduce mmap_sem write-side lock") was never brought back to
> 4.14.

But the patch says:
	Fixes: 5cec2d2e5839 ("binder: fix race between munmap() and direct reclaim")
and that commit is in 4.14.124.

thanks,

greg k-h
