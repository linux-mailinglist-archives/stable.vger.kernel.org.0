Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBECE15AF12
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 18:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBLRvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 12:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgBLRvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 12:51:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A0CA20714;
        Wed, 12 Feb 2020 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581529912;
        bh=CxkrovGv+VwPpjoOAvZm2PqQCvnr5Wtoftc21B0UHTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fGVjNz4UWtFx6kGkl2XTfCOEiXyadq7bMWbG9TozLizytoCWomtQAEQscEVeIMQMw
         MGcQLCU/Dvfia1A7iBwQv7rqwg69C4diPpEAHbFLQnkAL0RBpxCTfthen+NscnNRZy
         2xNscEhefreq/0xFrJqZPllN3C/gI7Qx7PBjzY1c=
Date:   Wed, 12 Feb 2020 09:51:51 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, pmenzel@molgen.mpg.de,
        mika.westerberg@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        krzk@kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [RFT PATCH v2] xhci: Fix memory leak when caching protocol
 extended capability PSI tables
Message-ID: <20200212175151.GA1872825@kroah.com>
References: <20d0559f-8d0f-42f5-5ebf-7f658a172161@linux.intel.com>
 <CGME20200211150022eucas1p1774275707908e4ee455291a793da308a@eucas1p1.samsung.com>
 <20200211150158.14475-1-mathias.nyman@linux.intel.com>
 <da2d0387-47f8-e047-0ff8-d971072f9f89@samsung.com>
 <20200211161316.GA1914687@kroah.com>
 <a6eedbbf-ce9f-b9c8-beee-a9c941051aeb@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6eedbbf-ce9f-b9c8-beee-a9c941051aeb@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 12, 2020 at 11:01:52AM +0200, Mathias Nyman wrote:
> On 11.2.2020 18.13, Greg KH wrote:
> > On Tue, Feb 11, 2020 at 04:12:40PM +0100, Marek Szyprowski wrote:
> >> Hi Mathias,
> >>
> >> On 11.02.2020 16:01, Mathias Nyman wrote:
> >>> xhci driver assumed that xHC controllers have at most one custom
> >>> supported speed table (PSI) for all usb 3.x ports.
> >>> Memory was allocated for one PSI table under the xhci hub structure.
> >>>
> >>> Turns out this is not the case, some controllers have a separate
> >>> "supported protocol capability" entry with a PSI table for each port.
> >>> This means each usb3 roothub port can in theory support different custom
> >>> speeds.
> >>>
> >>> To solve this, cache all supported protocol capabilities with their PSI
> >>> tables in an array, and add pointers to the xhci port structure so that
> >>> every port points to its capability entry in the array.
> >>>
> >>> When creating the SuperSpeedPlus USB Device Capability BOS descriptor
> >>> for the xhci USB 3.1 roothub we for now will use only data from the
> >>> first USB 3.1 capable protocol capability entry in the array.
> >>> This could be improved later, this patch focuses resolving
> >>> the memory leak.
> >>>
> >>> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> >>> Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
> >>> Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
> >>> Cc: stable <stable@vger.kernel.org> # v4.4+
> >>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> >>
> >> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > 
> > Nice!
> > 
> > Should I revert the first and then apply this?
> > 
> 
> Yes, please

Now done, thanks.

greg k-h
