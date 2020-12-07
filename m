Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC892D1872
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 19:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLGSXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 13:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgLGSXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 13:23:47 -0500
Date:   Mon, 7 Dec 2020 19:24:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607365386;
        bh=91I0mcZnaLSZzLoO30GuXp+F9yqz/Y9S5H3zqlh8ieQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=vmhEKoSp0Gzy5L7TNIpWV54AOqVbRnu0R2EmIAqFOGiv33nSOKF6+TZ65jDM3kCHx
         cM4w5yFTmnK408eVLhcp4RiZoDQyo/lUBbfStfmmZHtTbs7p5UGFNX+ZG25zb9C2D0
         JzTwK4yFn+q3DWofskqv/+e1DXjUVNLAKKX8uXp4=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will McVicker <willmcvicker@google.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        security@kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Will Coster <willcoster@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] HID: make arrays usage and value to be the same
Message-ID: <X85zUOmQ6e6T8wqQ@kroah.com>
References: <20201205004848.2541215-1-willmcvicker@google.com>
 <X8tMDQTls/RcTSAy@kroah.com>
 <X85spIzp1/gRxvKr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X85spIzp1/gRxvKr@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 09:55:48AM -0800, Will McVicker wrote:
> On Sat, Dec 05, 2020 at 09:59:57AM +0100, Greg KH wrote:
> > On Sat, Dec 05, 2020 at 12:48:48AM +0000, Will McVicker wrote:
> > > The HID subsystem allows an "HID report field" to have a different
> > > number of "values" and "usages" when it is allocated. When a field
> > > struct is created, the size of the usage array is guaranteed to be at
> > > least as large as the values array, but it may be larger. This leads to
> > > a potential out-of-bounds write in
> > > __hidinput_change_resolution_multipliers() and an out-of-bounds read in
> > > hidinput_count_leds().
> > > 
> > > To fix this, let's make sure that both the usage and value arrays are
> > > the same size.
> > > 
> > > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > 
> > Any reason not to also add a cc: stable on this?
> No reason not to include stable. CC'd here.
> 
> > 
> > And, has this always been the case, or was this caused by some specific
> > commit in the past?  If so, a "Fixes:" tag is always nice to included.
> I dug into the history and it's been like this for the past 10 years. So yeah
> pretty much always like this.
> 
> > 
> > And finally, as you have a fix for this already, no need to cc:
> > security@k.o as there's nothing the people there can do about it now :)
> Is that short for security@kernel.org? If yes, then I did include them. If no,
> do you mind explaining?

Yes, I see you included it, my point was that once you have a patch,
there is no need to include this email address as all we do at this
address is work to match up a problem with a developer that can create a
fix.  You already did this, so no need for us to get involved at all! :)

thanks,

greg k-h
