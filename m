Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CD92A9399
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 11:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgKFKC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 05:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgKFKC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 05:02:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E134206DC;
        Fri,  6 Nov 2020 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604656977;
        bh=nYdHL5tyv5VMecLwSV/l3uI2NstXIrB2qMwuqFJkM4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M2WaU7q4zH8m7KvvkhjUQ2pCKYppWcW4xZc8Sbd+MJHPZQ7u/1yV62PBVKKYrx2Y6
         TrqCKM7i7uTANmTINzFj9ooaRAzBORHGqUCF216GRkX+wQ0KmNy+NmZQe6zuJetZ+R
         6sSKWmg+XOtXTJOXaV6ITnlfo69WmhRLZwuA2tOg=
Date:   Fri, 6 Nov 2020 11:03:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     devel@driverdev.osuosl.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: cb_pcidas: reinstate delay removed from
 trimpot setting
Message-ID: <20201106100343.GA2715339@kroah.com>
References: <20201029141833.126856-1-abbotti@mev.co.uk>
 <3d7cf15a-c389-ec2c-5e29-8838e8466790@mev.co.uk>
 <f28af317-08a7-8218-d2a6-0cdd9e681873@mev.co.uk>
 <975358e2-6a08-211a-d232-3cd0ce628e8e@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <975358e2-6a08-211a-d232-3cd0ce628e8e@mev.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 10:49:18AM +0000, Ian Abbott wrote:
> On 02/11/2020 11:16, Ian Abbott wrote:
> > On 02/11/2020 10:25, Ian Abbott wrote:
> > > On 29/10/2020 14:18, Ian Abbott wrote:
> > > > Commit eddd2a4c675c ("staging: comedi: cb_pcidas: refactor
> > > > write_calibration_bitstream()") inadvertently removed one of the
> > > > `udelay(1)` calls when writing to the calibration register in
> > > > `cb_pcidas_calib_write()`.  Reinstate the delay.  It may seem strange
> > > > that the delay is placed before the register write, but this function is
> > > > called in a loop so the extra delay can make a difference.
> > > > 
> > > > This _might_ solve reported issues reading analog inputs on a
> > > > PCIe-DAS1602/16 card where the analog input values "were scaled in a
> > > > strange way that didn't make sense".  On the same hardware running a
> > > > system with a 3.13 kernel, and then a system with a 4.4 kernel, but with
> > > > the same application software, the system with the 3.13 kernel was fine,
> > > > but the one with the 4.4 kernel exhibited the problem.  Of the 90
> > > > changes to the driver between those kernel versions, this change looked
> > > > like the most likely culprit.
> > > 
> > > Actually, I've realized that this patch will have no effect on the
> > > PCIe-DAS1602/16 card because it uses a different driver -
> > > cb_pcimdas, not cb_pcidas.
> > 
> > But that's also confusing because PCIe-DAS1602/16 was not supported
> > until the 3.19 kernel!  I know the reported has both PCI-DAS1602/16 and
> > PCIe-DAS1602/16 cards (supported by cb_pcidas and cb_pcimdas
> > respectively), so there could have been some mix-up in the reporting.
> 
> Mystery solved.  The reporter had a mixture of PCIe-DAS1602/16 and
> PCIM-DAS1602/16 cards (not PCI-DAS1602/16).  Both of those are supported by
> the "cb_pcimdas" driver (not "cb_pcidas"), although the PCIe card was not
> supported until the 3.19 kernel (by commit 4e3d14af1286).  Testing with the
> 3.13 kernel was done with the PCIM card.
> 
> The "strange scaling" was due to a change in the ranges reported for the
> analog input subdevice in the 4.1 kernel (by commit c7549d770a27). Before
> then, it just reported a single dummy range [0, 1000000] with no units
> (converted to [0.0, 1.0] with no units by comedilib).  Afterwards, it
> reported four different voltage ranges (either unipolar or bipolar,
> depending in a status bit tied to a physical switch).  The reporter's
> application code was using the reported range to scale the raw values to a
> voltage (using comedilib functions), but because the reported range was
> bogus, the application code was performing additional scaling (outside of
> comedilib).  The application code can be changed to check whether the device
> is reporting a proper voltage range or the old, bogus range, and behave
> accordingly.
> 
> > > Greg, you might as well drop this patch if you haven't already
> > > applied it, since it was only a hunch that it fixed a problem.
> 
> That's still the case, although it won't do any harm if applied (apart from
> the incorrect patch description).

I'll leave it dropped :)

thanks,

greg k-h
