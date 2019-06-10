Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FB43B730
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbfFJOX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403788AbfFJOX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:23:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F54B207E0;
        Mon, 10 Jun 2019 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560176605;
        bh=A90YY0XScEWebv7Wa6OalV1D5wbhdju9RVpdpcHWqU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qd8G1NTbPOEvGugSZVmVm8H25EuH9qwztLE4UVT+TXnRwkifwY6An3zPfp13vG0/q
         UafexcVizdk1Sri1xgonAcETAjX5qzFGy/MYIsa/ZlWCkXxSHcCzpw8c00bso+xHcL
         6V/z90ocdyGAKeLAjCWXPSOFEdGIIVfNM2x5pD3w=
Date:   Mon, 10 Jun 2019 16:23:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 01/51] ethtool: fix potential userspace buffer
 overflow
Message-ID: <20190610142323.GD5937@kroah.com>
References: <20190609164127.123076536@linuxfoundation.org>
 <20190609164127.215699992@linuxfoundation.org>
 <20190610082112.GA8783@amd>
 <20190610084229.GA31797@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610084229.GA31797@unicorn.suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 10:42:29AM +0200, Michal Kubecek wrote:
> On Mon, Jun 10, 2019 at 10:21:12AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Vivien Didelot <vivien.didelot@gmail.com>
> > > 
> > > [ Upstream commit 0ee4e76937d69128a6a66861ba393ebdc2ffc8a2 ]
> > > 
> > > ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> > > and pass it to the kernel driver via ops->get_regs() for filling.
> > > 
> > > There is no restriction about what the kernel drivers can or cannot do
> > > with the open ethtool_regs structure. They usually set regs->version
> > > and ignore regs->len or set it to the same size as ops->get_regs_len().
> > > 
> > > But if userspace allocates a smaller buffer for the registers dump,
> > > we would cause a userspace buffer overflow in the final copy_to_user()
> > > call, which uses the regs.len value potentially reset by the driver.
> > > 
> > > To fix this, make this case obvious and store regs.len before calling
> > > ops->get_regs(), to only copy as much data as requested by userspace,
> > > up to the value returned by ops->get_regs_len().
> > > 
> > > While at it, remove the redundant check for non-null regbuf.
> > 
> > Mainline differs from 4.19-stable here, and while the non-null check
> > is redundant in -mainline, it does not seem to be redundant in
> > -stable.
> > 
> > In stable, if get_regs_len() returns < 0, we'll pass it to vzalloc.
> 
> Right. :-(
> 
> I guess we should also pick commit f9fc54d313fa ("ethtool: check the
> return value of get_regs_len") to stable branches before 5.0.

Now queued up, thanks.

greg k-h
