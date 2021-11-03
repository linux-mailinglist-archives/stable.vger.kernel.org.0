Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345B8443F7E
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKCJns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhKCJnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 05:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE566112D;
        Wed,  3 Nov 2021 09:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635932471;
        bh=jsOp6rDI9MoyiJ5Jf7bv2gmmxms+OBGzwYiDIAkfDss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4HtUz3/wrEc5oBB2oqSorivRnl5E7X3kugAN4lif7kQclhwN16GJo2c9QFlpzf2+
         FGx5iv18Qzl9mbYI4/w05OyJdbBTrGYFt9WFZw8AfSejphvl7LZ/Z2luP1BV72I0/G
         LcwhQ8t30wg0X9HudPaPywIrmpvprB4bZvt+12+M=
Date:   Wed, 3 Nov 2021 10:41:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Erik Ekman <erik@kryo.se>
Cc:     stable@vger.kernel.org
Subject: Re: sfc: Fix reading non-legacy supported link modes
Message-ID: <YYJZMuOFNQiJ3rGC@kroah.com>
References: <CAGgu=sBsiSVgr=uR95ZXFTtziLUO_LS4CW+6n2p2iBWxf2aq6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGgu=sBsiSVgr=uR95ZXFTtziLUO_LS4CW+6n2p2iBWxf2aq6A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 09:58:22PM +0100, Erik Ekman wrote:
> Upstream commit 041c61488236a5a84789083e3d9f0a51139b6edf
> 
> Initially this just fixed 50G and 100G modes which felt rare enough to
> not apply this to stable (also it got merged before I really had
> thought about it).
> 
> The testing mentioned in the change was actually from my development
> of c62041c5ba ("sfc: Export fibre-specific supported link modes"). I
> failed to mention the link between the two changes however and this
> commit ended up in net-next (just merged) while the second ended up in
> 5.15 via the net branch. The result is that for 5.15 even 10G cards
> only show 1G as supported:
> 
> $ ethtool ext
>     Settings for ext:
>     Supported ports: [ FIBRE ]
>     Supported link modes:   1000baseT/Full
>     Supported pause frame use: Symmetric Receive-only
> [..]
> 
> So this commit is needed at least for 5.15 to fix that.
> 
> Fixes:  c62041c5ba ("sfc: Export fibre-specific supported link modes")
> 
> It can also be applied further back if we want to fix the 50/100G
> modes (from v4.16 I believe):
> 
> Fixes: 5abb5e7f916 ("sfc: add bits for 25/50/100G supported/advertised speeds")

I have queued this up for 5.10.y, 5.14.y, and 5.15.y now, but I need a
backported version for 5.4.y and 4.19.y please.

thanks,

greg k-h
