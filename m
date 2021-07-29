Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7193DA282
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 13:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhG2Lwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 07:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhG2Lwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 07:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C6560720;
        Thu, 29 Jul 2021 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627559557;
        bh=TcHKExQZ71Wdyku14F28gAs13SSIwm1sfNPVSRj02YQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YF+5Dl6T36a8JJ9JpPN+19QDeqNTNKFjbw6UOykXm7cNTHgPrxRZiZAH+suLojlor
         WiEWFmrio0Mj+bhxg2n+823tskVJWg1z69W/Ukt2DGyZDXvxkShiYyPKhO0/a//BlW
         Avd8BOf/iIxXQPJUN+TSnbw9l6JuK+ESyjT2nMRwStPTBeBctWi0pdVlD1By8gDNyB
         F8HFJB2m8HXQO7h9CV9JFPfEAucsHyeFAFJ8YP24VbEm+SEGwTaJmvco2xGfJ15Bc1
         j1j3RwnnVOdFJp2uLEg4+24aZDvG67fDDTE6yPkqplv/sZay8rThHRuhAxIyEyq9+N
         NyijGvbQqNn0Q==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m94Zy-0002fM-P7; Thu, 29 Jul 2021 13:51:58 +0200
Date:   Thu, 29 Jul 2021 13:51:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ch341: fix character loss at high transfer
 rates
Message-ID: <YQKWXlTj02OW/h5S@hovoldconsulting.com>
References: <20210724152739.18726-1-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210724152739.18726-1-w@1wt.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 24, 2021 at 05:27:39PM +0200, Willy Tarreau wrote:
> The chip supports high transfer rates, but with the small default buffers
> (64 bytes read), some entire blocks are regularly lost. This typically
> happens at 1.5 Mbps (which is the default speed on Rockchip devices) when
> used as a console to access U-Boot where the output of the "help" command
> misses many lines and where "printenv" mangles the environment.
> 
> The FTDI driver doesn't suffer at all from this. One difference is that
> it uses 512 bytes rx buffers and 256 bytes tx buffers. Adopting these
> values completely resolved the issue, even the output of "dmesg" is
> reliable. I preferred to leave the Tx value unchanged as it is not
> involved in this issue, while a change could increase the risk of
> triggering the same issue with other devices having too small buffers.

Since these device do not support automatic flow control this is indeed
the best we can to do here (otherwise I'd probably prefer framing it
more as an optimisation than a fix).

> I verified that it backports well (and works) at least to 5.4. It's of
> low importance enough to be dropped where it doesn't trivially apply
> anymore.

This should be fine to backport to all stable trees.

> Cc: stable@vger.kernel.org
> Signed-off-by: Willy Tarreau <w@1wt.eu>

Now applied for 5.14, thanks.

Johan
