Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064F63B0E3
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbfFJImc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:42:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388267AbfFJImb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 04:42:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97B14AF6A;
        Mon, 10 Jun 2019 08:42:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E447EE00E3; Mon, 10 Jun 2019 10:42:29 +0200 (CEST)
Date:   Mon, 10 Jun 2019 10:42:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 01/51] ethtool: fix potential userspace buffer
 overflow
Message-ID: <20190610084229.GA31797@unicorn.suse.cz>
References: <20190609164127.123076536@linuxfoundation.org>
 <20190609164127.215699992@linuxfoundation.org>
 <20190610082112.GA8783@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610082112.GA8783@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 10:21:12AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Vivien Didelot <vivien.didelot@gmail.com>
> > 
> > [ Upstream commit 0ee4e76937d69128a6a66861ba393ebdc2ffc8a2 ]
> > 
> > ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> > and pass it to the kernel driver via ops->get_regs() for filling.
> > 
> > There is no restriction about what the kernel drivers can or cannot do
> > with the open ethtool_regs structure. They usually set regs->version
> > and ignore regs->len or set it to the same size as ops->get_regs_len().
> > 
> > But if userspace allocates a smaller buffer for the registers dump,
> > we would cause a userspace buffer overflow in the final copy_to_user()
> > call, which uses the regs.len value potentially reset by the driver.
> > 
> > To fix this, make this case obvious and store regs.len before calling
> > ops->get_regs(), to only copy as much data as requested by userspace,
> > up to the value returned by ops->get_regs_len().
> > 
> > While at it, remove the redundant check for non-null regbuf.
> 
> Mainline differs from 4.19-stable here, and while the non-null check
> is redundant in -mainline, it does not seem to be redundant in
> -stable.
> 
> In stable, if get_regs_len() returns < 0, we'll pass it to vzalloc.

Right. :-(

I guess we should also pick commit f9fc54d313fa ("ethtool: check the
return value of get_regs_len") to stable branches before 5.0.

Michal
