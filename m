Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA744E784
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhKLNmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231436AbhKLNmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:42:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5262B6103A;
        Fri, 12 Nov 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724355;
        bh=w7KISjjpwAQfHcjDkAis5xgabdnXkMH+Lzo/tN1xL9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvIOGKxGzrSQRe5WlnLlbZkONvC3T5mP5GP0pSFiJ8NC1qCa5ptg8RBCH7dQI2xhJ
         p7Klvkqpk5oHkxiShgjutmsQvcPLefTLnOCu3V5iPiHmMD7Tg15FHPoHRMUMY+OlvI
         j7BljCggWKchnbMm+3v5XcM78V+Dng/1UPVTLLXI=
Date:   Fri, 12 Nov 2021 14:39:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pavel Machek <pavel@ucw.cz>, Zubin Mithra <zsm@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Message-ID: <YY5ugWtHt2e/aQLJ@kroah.com>
References: <20211110182001.994215976@linuxfoundation.org>
 <20211110182002.041203616@linuxfoundation.org>
 <20211111164754.GA29545@duo.ucw.cz>
 <YY1OHxpimjKYgxGR@google.com>
 <20211111185308.GA7933@duo.ucw.cz>
 <20211112054811.GD27605@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112054811.GD27605@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 12, 2021 at 06:48:11AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 11, 2021 at 07:53:08PM +0100, Pavel Machek wrote:
> > > There is some more context on this at:
> > > https://lore.kernel.org/linux-block/YXweJ00CVsDLCI7b@google.com/T/#u
> > > and
> > > https://lore.kernel.org/stable/YYVZBuDaWBKT3vOS@google.com/T/#u
> > 
> > Thank you!
> 
> Honestly, this looks broken to me.  multipage-bvec was a big invasive
> series with a lot of latter fixups.  While taking this patch on it's
> own should be save by itself, but also useless.  So if it is needed
> to make a KASAN warning go away we need to dig deeper and back something
> else out that should not have been backported to rely on multipage
> bvec becasue without the other patches they don't exist and can't
> acually work.

Ok, let me drop this for now.

Zubin, can you provide a better report as to what driver is causing the
problem and what exactly resolves it?  Has this issue always been in
4.19 since 4.19.0?

thanks,

greg k-h
