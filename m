Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D72A120129
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 10:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfLPJ2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 04:28:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfLPJ2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 04:28:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAF312075A;
        Mon, 16 Dec 2019 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576488501;
        bh=RW14kw0PJ2wrm6ulu6HtyD0f3CFUMop1Am8yugJWJLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZR9zT84IZckgL6VojKqYtTYubTnmKvXzNr8AlFm4gcwHI/sjcPmZzLNtZV53XQyzI
         1IqF2do9BVvrI9iRYVZX+unWx1dwf2wJtRRLH8qKOHZxuj7MA7KJ9Hyhkc/Q4Jjd6k
         ELcF5ywb2uDp7ymvJjK3TnaoLcfG6VA7an7pl+ro=
Date:   Mon, 16 Dec 2019 10:28:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andre Tomt <andre@tomt.net>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 153/306] block: fix the DISCARD request merge
 (4.19.87+ crash)
Message-ID: <20191216092818.GA1203682@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203126.845809286@linuxfoundation.org>
 <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net>
 <CA+res+RtrAOfiVLeg1QE7V1Xjs6029y3tVmh0vfy+B71_bhsUw@mail.gmail.com>
 <4d8343e0-f38a-3e08-edf6-3346b3011ddf@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d8343e0-f38a-3e08-edf6-3346b3011ddf@tomt.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 10:18:48AM +0100, Andre Tomt wrote:
> On 16.12.2019 08:42, Jack Wang wrote:
> > Andre Tomt <andre@tomt.net> 于2019年12月14日周六 下午3:24写道：
> > > 
> > > 4.19.87, 4.19.88, 4.19.89 all lock up frequently on some of my systems.
> > > The same systems run 5.4.3 fine, so the newer trees are probably OK.
> > > Reverting this commit on top of 4.19.87 makes everything stable.
> > > 
> > > To trigger it all I have to do is re-rsyncing a directory tree with some
> > > changed files churn, it will usually crash in 10 to 30 minutes.
> > > 
> > > The systems crashing has ext4 filesystem on a two ssd md raid1 mounted
> > > with the mount option discard. If mounting it without discard, the
> > > crashes no longer seem to occur.
> > > 
> > > No oops/panic made it to the ipmi console. I suspect the console is just
> > > misbehaving and it didnt really livelock. At one point one line of the
> > > crash made it to the console (kernel BUG at block/blk-core.c:1776), and
> > > it was enough to pinpoint this commit. Note that the line number might
> > > be off, as I was attempting a bisect at the time.
> > > 
> > > This commit also made it to 4.14.x, but I have not tested it.
> > Hi Andre,
> > 
> > I noticed one fix is missing for discard merge in 4.19.y
> > 2a5cf35cd6c5 ("block: fix single range discard merge")
> > 
> > Can you try if it helps? just "git cherry-pick 2a5cf35cd6c5"
> 
> Indeed, adding this commit on top a clean 4.19.89 fixes the issue. So far
> survived about an hour of rsyncing file churn.
> 

Great!

Thanks Jack for finding the fix and Andre for reporting this.  I'll go
queue this fix up right now.

greg k-h
