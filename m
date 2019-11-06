Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092A4F0AF4
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 01:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfKFASr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 19:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbfKFASr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 19:18:47 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88B62087E;
        Wed,  6 Nov 2019 00:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572999526;
        bh=xdCq91yOnBvmSUuhtJO18uIKVytxc59ip6x5qVWsesQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xxX93IXMGF5SOlvoP29sLP7A0JaILkUkMNCG+f0pTtqnFPN5GVJdd4JrTDYFiR3y1
         r8nbeI2fvqeUCpbyDkUYVqlZESSb5b1oX5efFOHTqaTcej+D/KZMFpsrHs5VjIz6WS
         6svPV43nWLcPUq8Wc+C4IJGJ4Y5rp6+KoPUqrkio=
Date:   Wed, 6 Nov 2019 09:18:39 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Marta Rybczynska <mrybczyn@kalray.eu>,
        Charles Machalow <csm10495@gmail.com>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        axboe <axboe@fb.com>, Sagi Grimberg <sagi@grimberg.me>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] nvme: change nvme_passthru_cmd64 to explicitly mark rsvd
Message-ID: <20191106001839.GB1450@redsun51.ssa.fujisawa.hgst.com>
References: <20191105061510.22233-1-csm10495@gmail.com>
 <442718702.90376810.1572939552776.JavaMail.zimbra@kalray.eu>
 <20191105153144.GA12437@lst.de>
 <20191106000836.GH4787@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106000836.GH4787@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 07:08:36PM -0500, Sasha Levin wrote:
> On Tue, Nov 05, 2019 at 04:31:44PM +0100, Christoph Hellwig wrote:
> > On Tue, Nov 05, 2019 at 08:39:12AM +0100, Marta Rybczynska wrote:
> > > Looks good to me. However, please note that the new ioctl made it already to 5.3.8.
> > 
> > It wasn't in 5.3, but it seems like you are right and it somehow got
> > picked for the stable releases.
> > 
> > Sasha, can you please revert 76d609da9ed1cc0dc780e2b539d7b827ce28f182
> > in 5.3-stable ASAP and make sure crap like backporting new ABIs that
> > haven't seen a release yet is never ever going to happen again?
> 
> Sure, I'll revert it. I guess I wasn't expecting to see something like
> this in a -rc release. How did it make it into one if it's not a fix?

It is a fix, but it wasn't marked as such in the original changelog.
I've adjusted it for the pull request, currently staged here:

  https://git.kernel.dk/cgit/linux-block/commit/?h=for-linus&id=0d6eeb1fd625272bd60d25f2d5e116cf582fc7dc

Still, a new ioctl seems pretty aggressive for stable bot, yeah?
