Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6798B159489
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgBKQNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 11:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgBKQNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 11:13:18 -0500
Received: from localhost (unknown [104.133.9.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE232070A;
        Tue, 11 Feb 2020 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581437597;
        bh=mpthMPkNTmBrSE6fyhf8FwsYXxQ+Fb0JRMAAkISpmgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jWiiqI+7RyyCw3hJoQhHNZTg2/M9zQnl8+zLXrDAe1n2XkHIKE5YO/a8mQGkpMhu5
         KCScjHxyJHCCgMF0uw8fDyTmr9OOpQtdCrbZx5GL2ySWQun19bECNPXzreriYToGS2
         zqVoav8R35mGJ7cw9diNyL4HDwYgvZITLVdbLaco=
Date:   Tue, 11 Feb 2020 08:13:16 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        pmenzel@molgen.mpg.de, mika.westerberg@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, krzk@kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [RFT PATCH v2] xhci: Fix memory leak when caching protocol
 extended capability PSI tables
Message-ID: <20200211161316.GA1914687@kroah.com>
References: <20d0559f-8d0f-42f5-5ebf-7f658a172161@linux.intel.com>
 <CGME20200211150022eucas1p1774275707908e4ee455291a793da308a@eucas1p1.samsung.com>
 <20200211150158.14475-1-mathias.nyman@linux.intel.com>
 <da2d0387-47f8-e047-0ff8-d971072f9f89@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da2d0387-47f8-e047-0ff8-d971072f9f89@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 11, 2020 at 04:12:40PM +0100, Marek Szyprowski wrote:
> Hi Mathias,
> 
> On 11.02.2020 16:01, Mathias Nyman wrote:
> > xhci driver assumed that xHC controllers have at most one custom
> > supported speed table (PSI) for all usb 3.x ports.
> > Memory was allocated for one PSI table under the xhci hub structure.
> >
> > Turns out this is not the case, some controllers have a separate
> > "supported protocol capability" entry with a PSI table for each port.
> > This means each usb3 roothub port can in theory support different custom
> > speeds.
> >
> > To solve this, cache all supported protocol capabilities with their PSI
> > tables in an array, and add pointers to the xhci port structure so that
> > every port points to its capability entry in the array.
> >
> > When creating the SuperSpeedPlus USB Device Capability BOS descriptor
> > for the xhci USB 3.1 roothub we for now will use only data from the
> > first USB 3.1 capable protocol capability entry in the array.
> > This could be improved later, this patch focuses resolving
> > the memory leak.
> >
> > Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> > Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
> > Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
> > Cc: stable <stable@vger.kernel.org> # v4.4+
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Nice!

Should I revert the first and then apply this?

thanks,

greg k-h
