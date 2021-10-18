Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBCC431A35
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 14:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJRNBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhJRNBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDD660C4B;
        Mon, 18 Oct 2021 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634561932;
        bh=gWn40r+naaqqjt1aJbfukr37PaCJ66Me0kZ+C6c15yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2qp36iEJ6yeHUhVnZZf8bh3uAdH4YIHv96qQ3IGSpDDw9b86tLFLmhT65r96KEO68
         P2OS6VFWMOXufk3SJ5qwl53lyYD21ghZKRPjXavx+3FzgXu1+BKYcrpBRXvnJ/2P4z
         cVBa5NMewyHKC4JTVfxCtc1Zs9+km7P6LIKHRMb8=
Date:   Mon, 18 Oct 2021 14:58:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maarten Zanders <maarten.zanders@mind.be>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10] net: dsa: mv88e6xxx: don't use PHY_DETECT on
 internal PHY's
Message-ID: <YW1viTPVNKSwOc6N@kroah.com>
References: <20211018125220.22190-1-maarten.zanders@mind.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018125220.22190-1-maarten.zanders@mind.be>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 02:52:20PM +0200, Maarten Zanders wrote:
> mv88e6xxx_port_ppu_updates() interpretes data in the PORT_STS
> register incorrectly for internal ports (ie no PPU). In these
> cases, the PHY_DETECT bit indicates link status. This results
> in forcing the MAC state whenever the PHY link goes down which
> is not intended. As a side effect, LED's configured to show
> link status stay lit even though the physical link is down.
> 
> Add a check in mac_link_down and mac_link_up to see if it
> concerns an external port and only then, look at PPU status.
> 
> Difference from upstream commit:
> ops->port_sync_link() renamed to ops->port_set_link()
> 
> Fixes: 5d5b231da7ac (net: dsa: mv88e6xxx: use PHY_DETECT in mac_link_up/mac_link_down)
> Cc: <stable@vger.kernel.org> # 5.10
> Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Thanks for the backport, now queued up.  But next time can you let me
know what the upstream SHA1 is?  I had to go dig it up...

thanks,

greg k-h
