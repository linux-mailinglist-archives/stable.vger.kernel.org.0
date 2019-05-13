Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A121B45A
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 12:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfEMK4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 06:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbfEMK4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 06:56:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D880D20862;
        Mon, 13 May 2019 10:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557744969;
        bh=CMZl5DTLPilsyZPUKZjfGBiZbwKac7NjgmfC9Tfbf9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+J9zWw54GrJbFUhU3a+iWeVAuxLt8CSz4vydM1ZxAtKF1TSAmAVn8cGlawj+0ckk
         M5pV6NqEFNLn07JSV9Cc9Dj4SVrNnZhitonIBZPy8o3DDpG5HYSMRS0LuDuGHDYoy3
         gstDfMLigJaxHsgdr+2V2wdhvlpomRp1ePmIZqK0=
Date:   Mon, 13 May 2019 12:56:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190513105606.GA21346@kroah.com>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513104339.GA9651@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 12:43:39PM +0200, Johan Hovold wrote:
> On Thu, Apr 25, 2019 at 06:05:36PM +0200, Johan Hovold wrote:
> > Fix two long-standing bugs which could potentially lead to memory
> > corruption or leave the port throttled until it is reopened (on weakly
> > ordered systems), respectively, when read-URB completion races with
> > unthrottle().
> > 
> > First, the URB must not be marked as free before processing is complete
> > to prevent it from being submitted by unthrottle() on another CPU.
> > 
> > 	CPU 1				CPU 2
> > 	================		================
> > 	complete()			unthrottle()
> > 	  process_urb();
> > 	  smp_mb__before_atomic();
> > 	  set_bit(i, free);		  if (test_and_clear_bit(i, free))
> > 	  					  submit_urb();
> > 
> > Second, the URB must be marked as free before checking the throttled
> > flag to prevent unthrottle() on another CPU from failing to observe that
> > the URB needs to be submitted if complete() sees that the throttled flag
> > is set.
> > 
> > 	CPU 1				CPU 2
> > 	================		================
> > 	complete()			unthrottle()
> > 	  set_bit(i, free);		  throttled = 0;
> > 	  smp_mb__after_atomic();	  smp_mb();
> > 	  if (throttled)		  if (test_and_clear_bit(i, free))
> > 	  	  return;			  submit_urb();
> > 
> > Note that test_and_clear_bit() only implies barriers when the test is
> > successful. To handle the case where the URB is still in use an explicit
> > barrier needs to be added to unthrottle() for the second race condition.
> > 
> > Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Greg, I noticed you added a stable tag to the corresponding cdc-acm fix
> and think I should have added on one from the start to this one as well.
> 
> Would you mind queuing this one up for stable?
> 
> Upstream commit 3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab.

Sure, now queued up for 4.9+

thanks,

greg k-h
