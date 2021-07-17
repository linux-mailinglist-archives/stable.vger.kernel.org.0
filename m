Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310DC3CC4E6
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhGQRhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233280AbhGQRhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D75B61151;
        Sat, 17 Jul 2021 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626543297;
        bh=cNLDAL8cqetw2WohunGLgyT4MIPB2gmlE1nTue+sV7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MgVmORWCi6BHeqxwX4gkgMDUCvIfr3/p+OA9sOzzP2Ghb9YMJIif7XlBEXSQd4qGU
         /W7JvDXtpajlLTIOT6Ki/jkAxA6rXnJFwNJVmZWyhkkYYtPwp2wLZg95qe1MgEb2gl
         QZcYPcL6boZjVw+15YB1NCRlnf6YnvIYDq5V0LfU=
Date:   Sat, 17 Jul 2021 19:34:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
Message-ID: <YPMUu+kNu0GZeQQ1@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 08:39:19AM -0500, Justin Forbes wrote:
> On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Moritz Fischer <mdf@kernel.org>
> >
> > commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
> >
> > The ROM load sometimes seems to return an unknown status
> > (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
> >
> > If the ROM load indeed failed this leads to failures when trying to
> > communicate with the controller later on.
> >
> > Attempt to load firmware using RAM load in those cases.
> >
> > Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> > Cc: stable@vger.kernel.org
> > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Tested-by: Vinod Koul <vkoul@kernel.org>
> > Reviewed-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> 
> After sending out 5.12.17 for testing, we had a user complain that all
> of their USB devices disappeared with the error:
> 
> Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
> for renesas_usb_fw.mem failed with error -2
> Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
> Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2
> 
> After first assuming that something was missing in the backport to
> 5.12, I had the user try 5.13.2, and then 5.14-rc1. Both of those
> failed in the same way, so it is not working in the current Linus tree
> either.  Reverting this patch fixed the issue.

Can you send a revert for this so I can get that into Linus's tree and
then all stable releases as well?

thanks,

greg k-h
