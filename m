Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7E90490
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 17:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfHPPVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 11:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbfHPPVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 11:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C854E2133F;
        Fri, 16 Aug 2019 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565968878;
        bh=+xGZSv7ViqyR23bAiTMFMUG/XokgMKZKAFgh2DIRSNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkbzrfHkK8ChrlYsKKj2TluDyZD4lcKLP1eIfD9WJoQpkHpvF7cAS7qh58GNe3Nfp
         Xag71ItV5Bz1vKkhBNdf7D2Il6Kfl6Isj69f6qxYxj4cos7hy8Bv9KR2k9rJH3mDx7
         i6yvUnJsLBWBwFznbLwbeNJHsDP47VfCwGVIILUw=
Date:   Fri, 16 Aug 2019 17:21:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
Message-ID: <20190816152116.GA7636@kroah.com>
References: <20190816074849.7197-1-ming.lei@redhat.com>
 <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
 <20190816145435.GA3424@kroah.com>
 <0b0f1017-ea52-a155-fc05-e22006813105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b0f1017-ea52-a155-fc05-e22006813105@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 09:12:33AM -0600, Jens Axboe wrote:
> On 8/16/19 8:54 AM, Greg KH wrote:
> > On Fri, Aug 16, 2019 at 08:20:42AM -0600, Jens Axboe wrote:
> >> On 8/16/19 1:48 AM, Ming Lei wrote:
> >>> It is reported that sysfs buffer overflow can be triggered in case
> >>> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> >>> blk_mq_hw_sysfs_cpus_show().
> >>>
> >>> This info isn't useful, given users may retrieve the CPU list
> >>> from sw queue entries under same kobject dir, so far not see
> >>> any active users.
> >>>
> >>> So remove the entry as suggested by Greg.
> >>
> >> I think that's a bit frivolous, there could very well be scripts or
> >> apps that use it. Let's just fix the overflow.
> > 
> > As no one really knows what the format is (and the patch to fix the
> > overflow changes the format of the file), I would say that it needs to
> > just be dropped as it is not an example of what you should be doing in
> > sysfs.
> 
> It's a list of CPUs, I think the format is quite self explanatory?

I'm not disagreeing, but the patch to fix the length changes the
formatting to be different.  So if you were needing to parse that file,
it now just broke the parser.

Which is why sysfs is to be one-value-per-file :)

> But in any case, I'm not 100% opposed to removing it, it's just not
> one of those things that should be done on a whim.

If the format of the file is going to change, I would argue that the
filename should change as well, so that it's obvious what is happening
here.  This is how we got in trouble with /proc files so many times...

thanks,

greg k-h
