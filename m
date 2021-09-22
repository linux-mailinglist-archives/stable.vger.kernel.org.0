Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E279414229
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 08:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhIVGvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 02:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhIVGvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 02:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F736112F;
        Wed, 22 Sep 2021 06:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632293371;
        bh=lfaOSkxBNB/O8psqxYEKBfWo321nH0cgbTyMQKAZ3DU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g64E1eqfSj9wqnmKW46+J/WaFbTenDs6bPgGeMPEJjxARq98v7w36mCSsWU5PX2Rv
         /2XJfzWKa7i2Kq8vPuua9olFVoW1YLqCmwtRxe115XofbHbg4gSBQZm4htrsmmmTrj
         ZvnF4jF0iA2lowPpcq2jZ6OssvJvs+DmWAa336Q0=
Date:   Wed, 22 Sep 2021 08:49:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] xhci: Improve detection of device initiated wake
 signal.
Message-ID: <YUrR+CyEVWktMqQ7@kroah.com>
References: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
 <20210311115353.2137560-3-mathias.nyman@linux.intel.com>
 <20210922011643.GD3515@jackp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922011643.GD3515@jackp-linux.qualcomm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 06:16:43PM -0700, Jack Pham wrote:
> Hi Mathias,
> 
> On Thu, Mar 11, 2021 at 01:53:51PM +0200, Mathias Nyman wrote:
> > A xHC USB 3 port might miss the first wake signal from a USB 3 device
> > if the port LFPS reveiver isn't enabled fast enough after xHC resume.
> > 
> > xHC host will anyway be resumed by a PME# signal, but will go back to
> > suspend if no port activity is seen.
> > The device resends the U3 LFPS wake signal after a 100ms delay, but
> > by then host is already suspended, starting all over from the
> > beginning of this issue.
> > 
> > USB 3 specs say U3 wake LFPS signal is sent for max 10ms, then device
> > needs to delay 100ms before resending the wake.
> > 
> > Don't suspend immediately if port activity isn't detected in resume.
> > Instead add a retry. If there is no port activity then delay for 120ms,
> > and re-check for port activity.
> 
> We have a use case with which this change is causing unnecessary delay.
> Consider a USB2* device is attached and host is initiating the resume.
> Since this is not a device initiated wakeup there wouldn't be any
> pending event seen on the PORTSC registers, yet this adds an additional
> 120ms delay to re-check the PORTSC before returning and allowing the USB
> core to perform resume signaling.
> 
> Is there a way to avoid this delay in that case?  Perhaps could we
> distinguish whether we arrive here at xhci_resume() due to a
> host-initiated resume vs. a device remote wakeup?

Do you have a proposed patch that would do such a thing?  Given that you
are seeing the problem it should be easy for you to test :)

> * I think it should be similar for attached USB3 devices as well, since
> the host-initiated exit from U3 wouldn't happen until usb_port_resume().

Can you reliably detect "attached" devices?

thanks,

greg k-h
