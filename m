Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C717824E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgCCSSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgCCSSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:18:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E715D20656;
        Tue,  3 Mar 2020 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583259486;
        bh=kgwYA8jHKo3dcsw6x45Y1PX+SxYOADIKIjm/Qo8z6yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XfzYcqO3z/ZVJkDPP8k2+fqUMkA8gYbN14ahfUnqidy+1Mq6Hn37tHrSrpncx2cHY
         Wuej9fRnSdhLJx6SGRh37iOyKBnwO/pUtQuh6RaLwyaiTe80rmY+ZQCxObWV6w0WYY
         v1sqnfNlAurrg/WQ+MpVJrt27oKBy0NSi5uAfTOg=
Date:   Tue, 3 Mar 2020 19:14:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Coly Li <colyli@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 072/176] bcache: ignore pending signals when creating
 gc and allocator thread
Message-ID: <20200303181413.GB1014382@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <20200303174312.994115258@linuxfoundation.org>
 <24e19cd9-8eea-a41a-27f7-84ffcd872977@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24e19cd9-8eea-a41a-27f7-84ffcd872977@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 10:58:29AM -0700, Jens Axboe wrote:
> On 3/3/20 10:42 AM, Greg Kroah-Hartman wrote:
> > From: Coly Li <colyli@suse.de>
> > 
> > [ Upstream commit 0b96da639a4874311e9b5156405f69ef9fc3bef8 ]
> > 
> > When run a cache set, all the bcache btree node of this cache set will
> > be checked by bch_btree_check(). If the bcache btree is very large,
> > iterating all the btree nodes will occupy too much system memory and
> > the bcache registering process might be selected and killed by system
> > OOM killer. kthread_run() will fail if current process has pending
> > signal, therefore the kthread creating in run_cache_set() for gc and
> > allocator kernel threads are very probably failed for a very large
> > bcache btree.
> > 
> > Indeed such OOM is safe and the registering process will exit after
> > the registration done. Therefore this patch flushes pending signals
> > during the cache set start up, specificly in bch_cache_allocator_start()
> > and bch_gc_thread_start(), to make sure run_cache_set() won't fail for
> > large cahced data set.
> 
> Ditto this one, of course.
> 
> Did someone send this in for stable? It's not marked stable in the
> original commit.

I think the autobot grabbed it.
