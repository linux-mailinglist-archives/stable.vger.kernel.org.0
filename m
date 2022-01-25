Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710EA49B207
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 11:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344733AbiAYKeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 05:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353710AbiAYK0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 05:26:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693C5C06176A
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 02:26:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 303F0B81753
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256D5C340E0;
        Tue, 25 Jan 2022 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643106373;
        bh=HwgjM0hM7mHltpwror+OIq0997f5VRLvJZ4u347ZpSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phBA4PTyCJs3jrh1GIHpZmAtUNoxtOcpkJDUzo1W3jH3qmiNs9z3an9GTpkLyB+4n
         H7qKgTMFHfJAMGsKYcAzzoMhrZ7d913HEd8ehK1AS/L78SIGGceRuheyhaZI61v+/T
         VuMxl4CFRItH1NXsQCdgno2X3SxwOkZP7UW6sAFk=
Date:   Tue, 25 Jan 2022 11:26:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: Re: [PATCH 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Message-ID: <Ye/QQj/f/ka7/XBu@kroah.com>
References: <20220124161243.1029417-1-lee.jones@linaro.org>
 <Ye7wcqssa5RuvwQe@kroah.com>
 <Ye/BFKrUP/nLSGJC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye/BFKrUP/nLSGJC@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 09:21:24AM +0000, Lee Jones wrote:
> On Mon, 24 Jan 2022, Greg KH wrote:
> 
> > On Mon, Jan 24, 2022 at 04:12:41PM +0000, Lee Jones wrote:
> > > From: Daniel Rosenberg <drosen@google.com>
> > > 
> > > If a user happens to call ION_IOC_FREE during an ION_IOC_ALLOC
> > > on the just allocated id, and the copy_to_user fails, the cleanup
> > > code will attempt to free an already freed handle.
> > > 
> > > This adds a wrapper for ion_alloc that adds an ion_handle_get to
> > > avoid this.
> > > 
> > > Signed-off-by: Daniel Rosenberg <drosen@google.com>
> > > Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
> > > Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/staging/android/ion/ion-ioctl.c | 14 +++++++++-----
> > >  drivers/staging/android/ion/ion.c       | 15 ++++++++++++---
> > >  drivers/staging/android/ion/ion.h       |  4 ++++
> > >  3 files changed, 25 insertions(+), 8 deletions(-)
> > 
> > What is the git commit id of this in Linus's tree (same for the other
> > 2)?
> 
> They are not in Linus' tree.
> 
> These fixes only made it into Android for some reason.
> 
> > And why just 4.9?  What about 4.14 and newer kernels?
> 
> The troublesome code was refactored before v4.14.

Then that needs to be said here in the changelog text please.

thanks,

greg k-h
