Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38ABB1B666
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 14:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfEMMvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 08:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfEMMvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 08:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B961621019;
        Mon, 13 May 2019 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557751894;
        bh=Jg67lMAFwj/x7HtbrUeWiaHXb/jkU8DLgcRc+obzEnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZZGRhegFE7NnPBaZHJnbn7jfe9Lfqd82peB368t5YMeu9cvLZd5ZdyIbGU/nxEsr
         EWucw86C0sBHRB/NTBomTsynNamDXnccL2vAg0WUrwQgjJ7lE1Ot/YdC/8Gav2myPQ
         8R83zr983VceZVt6w1QXuzJ7PsH1d4tDBNumq8+w=
Date:   Mon, 13 May 2019 14:51:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190513125131.GA7541@kroah.com>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
 <20190513105606.GA21346@kroah.com>
 <20190513114601.GB9651@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513114601.GB9651@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 01:46:01PM +0200, Johan Hovold wrote:
> On Mon, May 13, 2019 at 12:56:06PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, May 13, 2019 at 12:43:39PM +0200, Johan Hovold wrote:
> > > On Thu, Apr 25, 2019 at 06:05:36PM +0200, Johan Hovold wrote:
> > > > Fix two long-standing bugs which could potentially lead to memory
> > > > corruption or leave the port throttled until it is reopened (on weakly
> > > > ordered systems), respectively, when read-URB completion races with
> > > > unthrottle().
> 
> > > > Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > 
> > > Greg, I noticed you added a stable tag to the corresponding cdc-acm fix
> > > and think I should have added on one from the start to this one as well.
> > > 
> > > Would you mind queuing this one up for stable?
> > > 
> > > Upstream commit 3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab.
> > 
> > Sure, now queued up for 4.9+
> 
> Thanks. The issue has been there since v3.3 so I guess you could queue
> it for all stable trees.

Doesn't apply cleanly for 4.4.y or 3.18.y, so if it's really worth
adding there (and I kind of doubt it), I would need a backport :)

thanks,

greg k-h
