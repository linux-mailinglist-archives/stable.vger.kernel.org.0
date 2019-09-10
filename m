Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5216DAE6EE
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731163AbfIJJ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfIJJ3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 05:29:09 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B935D20872;
        Tue, 10 Sep 2019 09:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568107748;
        bh=S1LVx0xn7hzAb75Z1Ud5+wv+aqECl0vDMsdAvm8Z72I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnRnpan4G8nAcCuLHZWNCPMCU7E5pyHPYSNhGmcvNIgT0vda4KrBdchZ1VcYhMY9e
         PDaPa9/ac6fJjT31iT5bX1bMV2bpbJzL1p9/p45sjhDQktCo2gjD8zshmN8NgEzBkA
         NNJoN7yvwS7nLw2MsT+4+G/HjvocgPqbC6+HESrM=
Date:   Tue, 10 Sep 2019 10:29:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fabian Henneke <fabian.henneke@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 19/57] Bluetooth: hidp: Let hidp_send_message return
 number of queued bytes
Message-ID: <20190910092905.GA19176@kroah.com>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121132.859238319@linuxfoundation.org>
 <20190909121555.GA18869@amd>
 <8e7731e0-f0ad-8cbb-799e-dd585e6b7ed6@gmail.com>
 <20190909225929.GC26405@kroah.com>
 <c7aa8abe-86c1-e401-67b4-a9fbb85bf475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7aa8abe-86c1-e401-67b4-a9fbb85bf475@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 08:27:10AM +0200, Fabian Henneke wrote:
> 
> 
> On 10.09.19 00:59, Greg Kroah-Hartman wrote:
> > On Mon, Sep 09, 2019 at 03:00:46PM +0200, Fabian Henneke wrote:
> >> Hi,
> >>
> >> On Mon, Sep 9, 2019 at 2:15 PM Pavel Machek <pavel@denx.de> wrote:
> >>
> >>> Hi!
> >>>
> >>>> [ Upstream commit 48d9cc9d85dde37c87abb7ac9bbec6598ba44b56 ]
> >>>>
> >>>> Let hidp_send_message return the number of successfully queued bytes
> >>>> instead of an unconditional 0.
> >>>>
> >>>> With the return value fixed to 0, other drivers relying on hidp, such as
> >>>> hidraw, can not return meaningful values from their respective
> >>>> implementations of write(). In particular, with the current behavior, a
> >>>> hidraw device's write() will have different return values depending on
> >>>> whether the device is connected via USB or Bluetooth, which makes it
> >>>> harder to abstract away the transport layer.
> >>>
> >>> So, does this change any actual behaviour?
> >>>
> >>> Is it fixing a bug, or is it just preparation for a patch that is not
> >>> going to make it to stable?
> >>>
> >>
> >> I created this patch specifically in order to ensure that user space
> >> applications can use HID devices with hidraw without needing to care about
> >> whether the transport is USB or Bluetooth. Without the patch, every
> >> hidraw-backed Bluetooth device needs to be treated specially as its write()
> >> violates the usual return value contract, which could be viewed as a bug.
> >>
> >> Please note that a later patch (
> >> https://www.spinics.net/lists/linux-input/msg63291.html) fixes some
> >> important error checks that were relying on the old behavior (and were
> >> unfortunately missed by me).
> > 
> > As that patch doesn't seem to be in Linus's tree yet, we should postpone
> > taking this one in the stable tree right now, correct?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Yes, please wait for the other patch if it's not in his tree yet and apply the two together.

Ok, will move it out and wait for the fixup patch to hit Linus's tree,
thanks!

greg k-h
