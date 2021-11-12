Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A036144E1B1
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 06:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhKLFvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 00:51:06 -0500
Received: from verein.lst.de ([213.95.11.211]:60124 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhKLFvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 00:51:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E97B168AA6; Fri, 12 Nov 2021 06:48:11 +0100 (CET)
Date:   Fri, 12 Nov 2021 06:48:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Zubin Mithra <zsm@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Message-ID: <20211112054811.GD27605@lst.de>
References: <20211110182001.994215976@linuxfoundation.org> <20211110182002.041203616@linuxfoundation.org> <20211111164754.GA29545@duo.ucw.cz> <YY1OHxpimjKYgxGR@google.com> <20211111185308.GA7933@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111185308.GA7933@duo.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 07:53:08PM +0100, Pavel Machek wrote:
> > There is some more context on this at:
> > https://lore.kernel.org/linux-block/YXweJ00CVsDLCI7b@google.com/T/#u
> > and
> > https://lore.kernel.org/stable/YYVZBuDaWBKT3vOS@google.com/T/#u
> 
> Thank you!

Honestly, this looks broken to me.  multipage-bvec was a big invasive
series with a lot of latter fixups.  While taking this patch on it's
own should be save by itself, but also useless.  So if it is needed
to make a KASAN warning go away we need to dig deeper and back something
else out that should not have been backported to rely on multipage
bvec becasue without the other patches they don't exist and can't
acually work.
