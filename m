Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB58D149AB5
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAZNTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 08:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgAZNTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 08:19:44 -0500
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804712071A;
        Sun, 26 Jan 2020 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580044784;
        bh=aKCKS9AL2z61/oGPTAaoZA+DHJSUB/HCGvtzayApHvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYXOn2nYW7L/Twe2BbCfmZhNvhqNqIYSERxhsWHEnAGLrSbA8Xv04zy6zpgGU34Un
         OlElIoryWml2HyfEdI2l65YlTXyguCBO8bM8PXY5hdHQC+xjx16j9KLMZjA5hOKpbC
         CRbSEn0cB2cxbcNSnbo8JrDi1F2BgHoMeF58USB4=
Date:   Sun, 26 Jan 2020 14:19:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 521/639] rtc: pcf2127: bugfix: read rtc disables
 watchdog
Message-ID: <20200126131935.GA4074691@kroah.com>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093154.044998307@linuxfoundation.org>
 <20200126102634.GA19082@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126102634.GA19082@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 26, 2020 at 11:26:35AM +0100, Pavel Machek wrote:
> On Fri 2020-01-24 10:31:31, Greg Kroah-Hartman wrote:
> > From: Bruno Thomsen <bruno.thomsen@gmail.com>
> > 
> > [ Upstream commit 7f43020e3bdb63d65661ed377682702f8b34d3ea ]
> > 
> > The previous fix listed bulk read of registers as root cause of
> > accendential disabling of watchdog, since the watchdog counter
> > register (WD_VAL) was zeroed.
> > 
> > Fixes: 3769a375ab83 rtc: pcf2127: bulk read only date and time registers.
> > 
> > Tested with the same PCF2127 chip as Sean reveled root cause
> > of WD_VAL register value zeroing was caused by reading CTRL2
> > register which is one of the watchdog feature control registers.
> > 
> > So the solution is to not read the first two control registers
> > (CTRL1 and CTRL2) in pcf2127_rtc_read_time as they are not
> > needed anyway. Size of local buf variable is kept to allow
> > easy usage of register defines to improve readability of code.
> 
> Should the array be zeroed before or something? This way, one array
> contains both undefined values and valid data...
> 
> > Debug trace line was updated after CTRL1 and CTRL2 are no longer
> > read from the chip. Also replaced magic numbers in buf access
> > with register defines.
> 
> That part is not an improvement. Previously the code was formatted so
> that you could parse what is being printed.

Meta-comment: Making review comments on patches that are already in
Linus's tree, is fine, but making them here seems a bit odd.  Please
just go find the original patch and respond there, as there's not much
you can do here _way_ after the fact, as the change is already
committed.

thanks,

greg k-h
