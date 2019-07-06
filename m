Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1FE61241
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfGFQvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 12:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfGFQvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Jul 2019 12:51:03 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2853320836;
        Sat,  6 Jul 2019 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562431862;
        bh=03VXPoBGTEudhnVcaNxaOVX1cfv+o2GmUaqaEjZx+50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ingCHlRr0ouEaWbvT2OAbv4fmZiMg8QNjH2L9FhoMGSqugRHJmIARkHwSKyL33kre
         vPXZUXBONySfsLLpPPfpnN15DFDgsLpD/PxSpt7+T0/WNYTSfFCb7DJmeg0AZQRV7h
         b4fIS0eHgwXqi8X/UCTjOCyn5Zu5J56nsunnQ4Gg=
Date:   Sat, 6 Jul 2019 18:50:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: fix up placement of debugfs directory of queue
 files
Message-ID: <20190706165044.GA18886@kroah.com>
References: <20190706155032.GA3106@kroah.com>
 <a4e28385-6f87-05f5-edb2-d68446771b7c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e28385-6f87-05f5-edb2-d68446771b7c@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 06, 2019 at 10:07:14AM -0600, Jens Axboe wrote:
> On 7/6/19 9:50 AM, Greg Kroah-Hartman wrote:
> > When the blk-mq debugfs file creation logic was "cleaned up" it was
> > cleaned up too much, causing the queue file to not be created in the
> > correct location.  Turns out the check for the directory being present
> > is needed as if that has not happened yet, the files should not be
> > created, and the function will be called later on in the initialization
> > code so that the files can be created in the correct location.
> 
> How about we shove this in for 5.2 final? Trivial enough to do, and it
> would suck to have 5.2 released with this.

Sure, no objection from me!

> Though not sure what devices this actually impacts, I haven't noticed
> anything awry on my setups?

I can easily trigger this with loop devices.  I know Stephen reported
this and I don't know if that was the driver that caused it for him.  I
have also seen this happen in syzbot boot logs already, but again, don't
know what block devices they are using that causes this.

thanks,

greg k-h
