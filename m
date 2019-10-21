Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812BCDEE4F
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfJUNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 09:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbfJUNtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 09:49:01 -0400
Received: from localhost (unknown [107.87.137.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C2612053B;
        Mon, 21 Oct 2019 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571665738;
        bh=ySbWnaqJexdqBk/baKlyM5Agouu1qs77BQ86seAmqVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E13iGTfvwvVEb4mMT8FTeElz6uhJ/XfVhU+BRahFUOWjpvj1qmGUPkJQydFX6hROl
         MyjylgyBFfLuWERg2YGJxh/QlzVhuWjUhJfKSZyE9CTaKnvXnGjgnD6B2iUvHP/E18
         XErPOq6Bw6TGFhHbIxNdh4KYA3IX/pInIg8c2iWo=
Date:   Mon, 21 Oct 2019 09:48:56 -0400
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
Message-ID: <20191021134856.GA35072@kroah.com>
References: <20191018151955.25135-1-johan@kernel.org>
 <20191018151955.25135-3-johan@kernel.org>
 <20191018185458.GA1191145@kroah.com>
 <20191021085627.GD24768@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021085627.GD24768@localhost>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 10:56:27AM +0200, Johan Hovold wrote:
> On Fri, Oct 18, 2019 at 11:54:58AM -0700, Greg Kroah-Hartman wrote:
> > On Fri, Oct 18, 2019 at 05:19:55PM +0200, Johan Hovold wrote:
> > > The custom ring-buffer implementation was merged without any locking
> > > whatsoever, but a spinlock was later added by commit 9d33efd9a791
> > > ("USB: ldusb bugfix").
> > > 
> > > The lock did not cover the loads from the ring-buffer entry after
> > > determining the buffer was non-empty, nor the update of the tail index
> > > once the entry had been processed. The former could lead to stale data
> > > being returned, while the latter could lead to memory corruption on
> > > sufficiently weakly ordered architectures.
> > 
> > Ugh.
> > 
> > This almost looks sane, but what's the odds there is some other issue in
> > here as well?  Would it make sense to just convert the code to use the
> > "standard" ring buffer code instead?
> 
> Yeah, long term that may be the right thing to do, but I wanted a
> minimal fix addressing the issue at hand without having to reimplement
> the driver and fix all other (less-critical) issues in there...
> 
> For the ring-buffer corruption / info-leak issue, these two patches
> should be sufficient though.
> 
> Copying the ring-buffer entry to a temporary buffer while holding the
> lock might still be preferred to avoid having to deal with barrier
> subtleties. But unless someone speaks out against 2/2, I'd just go ahead
> and apply it.

Ok, feel free to resend this and I'll queue it up, it's gone from my
queue :(

thanks,

greg k-h
