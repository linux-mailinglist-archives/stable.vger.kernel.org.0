Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940F424253C
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 08:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgHLGQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 02:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgHLGQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 02:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F84F20771;
        Wed, 12 Aug 2020 06:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597212963;
        bh=hpdk68RNfOyfqiR186qS6WghZoc8ZwHoLkbwEJW/ck4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJcv03ur3QmZZLygKENaHo/iHqLccFTwrqqtryfG0cWoUTJQ5qKk8G6D4X+OFAy0N
         6cX5bmyW52tdVEe6PHKoDhQ+cH+m+N7HYqabTWQNq+axMttMmkRkabqgNiByVje7BX
         gJCRe+phlwbSCDU0nlKs9+YGVblQv+XQEb15Tf6I=
Date:   Wed, 12 Aug 2020 08:16:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] usbip: Implement a match function to fix usbip
Message-ID: <20200812061600.GH1299081@kroah.com>
References: <20200810160017.46002-1-m.v.b@runbox.com>
 <6e450e16117afb9e1dd1e4270ef5c2e0d5885348.camel@hadess.net>
 <a7351706-9933-a3e1-4e7d-b7ab6f289938@linuxfoundation.org>
 <99330f61-ed16-7e27-6852-d3486f331ef5@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99330f61-ed16-7e27-6852-d3486f331ef5@runbox.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 08:47:20AM +0300, M. Vefa Bicakci wrote:
> On 10/08/2020 22.09, Shuah Khan wrote:
> > On 8/10/20 11:31 AM, Bastien Nocera wrote:
> > > On Mon, 2020-08-10 at 19:00 +0300, M. Vefa Bicakci wrote:
> > > > Commit 88b7381a939d ("USB: Select better matching USB drivers when
> > > > available") introduced the use of a "match" function to select a
> > > > non-generic/better driver for a particular USB device. This
> > > > unfortunately breaks the operation of usbip in general, as reported
> > > > in
> > > > the kernel bugzilla with bug 208267 (linked below).
> > > > 
> > > > Upon inspecting the aforementioned commit, one can observe that the
> > > > original code in the usb_device_match function used to return 1
> > > > unconditionally, but the aforementioned commit makes the
> > > > usb_device_match
> > > > function use identifier tables and "match" virtual functions, if
> > > > either of
> > > > them are available.
> > > > 
> > > > Hence, this commit implements a match function for usbip that
> > > > unconditionally returns true to ensure that usbip is functional
> > > > again.
> > > > 
> > > > This change has been verified to restore usbip functionality, with a
> > > > v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
> > > > usbip to redirect USB devices between VMs.
> > > > 
> > > > Thanks to Jonathan Dieter for the effort in bisecting this issue down
> > > > to the aforementioned commit.
> > > 
> > > Looks correct. Thanks for root causing the problem.
> > > 
> > > Reviewed-by: Bastien Nocera <hadess@hadess.net>
> > > 
> > 
> > Thank you for finding and fixing the problem.
> > 
> > Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Hello Shuah and Bastien,
> 
> Thank you for reviewing the patch!
> 
> Just to confirm, should I re-publish this patch after having added your
> Reviewed-by tags to the commit message? My current understanding is that
> a re-spin of a patch is only necessary when changes are requested during
> the code review. The development process documentation in the kernel
> repository does not mention this aspect, but I might have missed it during
> my quick search.

No need to resend it, my tools will pick up these reviewed-by tags and
add it to the final patch when I apply it.

See the tool 'b4' if you are curious as to how that works.

thanks,

greg k-h
