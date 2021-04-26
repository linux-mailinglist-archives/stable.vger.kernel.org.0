Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2922236AF60
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 10:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhDZIA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 04:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232259AbhDZH7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B5D608FC;
        Mon, 26 Apr 2021 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619423900;
        bh=OHEGpQxJ+wMTvR+n4XwSvOVejv7FUdKkMqp79g1wzWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2uhIz5tlD/X05k36ymbO8QLlZKfebgciaI+guAsZ8mn9Uw1Xdwak4LDFHgEZHFsJ6
         vNnAtJB5G2CaKxp9Dh+lrW2X4XtYNrOcCwpCAMOAQn9YmO7VQBSwpXYJ90B5C7W9lK
         GqbVYk4usJm1l+EvBXmfJv1DyOfdIZ5UAZanW+no=
Date:   Mon, 26 Apr 2021 09:58:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 4.4 22/32] net: hso: fix null-ptr-deref during tty device
 unregistration
Message-ID: <YIZymrX0lZ+kyerf@kroah.com>
References: <20210426072816.574319312@linuxfoundation.org>
 <20210426072817.327441466@linuxfoundation.org>
 <YIZtmT1CjlnwImlc@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIZtmT1CjlnwImlc@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:36:57AM +0200, Johan Hovold wrote:
> On Mon, Apr 26, 2021 at 09:29:20AM +0200, Greg Kroah-Hartman wrote:
> > From: Anirudh Rayabharam <mail@anirudhrb.com>
> > 
> > commit 8a12f8836145ffe37e9c8733dce18c22fb668b66 upstream
> > 
> > Multiple ttys try to claim the same the minor number causing a double
> > unregistration of the same device. The first unregistration succeeds
> > but the next one results in a null-ptr-deref.
> > 
> > The get_free_serial_index() function returns an available minor number
> > but doesn't assign it immediately. The assignment is done by the caller
> > later. But before this assignment, calls to get_free_serial_index()
> > would return the same minor number.
> > 
> > Fix this by modifying get_free_serial_index to assign the minor number
> > immediately after one is found to be and rename it to obtain_minor()
> > to better reflect what it does. Similary, rename set_serial_by_index()
> > to release_minor() and modify it to free up the minor number of the
> > given hso_serial. Every obtain_minor() should have corresponding
> > release_minor() call.
> > 
> > Fixes: 72dc1c096c705 ("HSO: add option hso driver")
> > Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> > Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > [sudip: adjust context]
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/usb/hso.c |   33 ++++++++++++---------------------
> >  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> We just got a regression report against this one. Perhaps better to hold
> off until that has been resolved.
> 
> 	https://lore.kernel.org/r/20210425233509.9ce29da49037e1a421000bdd@aruba.it

Good point, I'll go drop this from everywhere.

greg k-h
