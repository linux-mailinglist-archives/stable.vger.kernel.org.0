Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB46482330
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 11:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhLaKSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 05:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhLaKSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 05:18:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9832C061574;
        Fri, 31 Dec 2021 02:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC59617A8;
        Fri, 31 Dec 2021 10:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D83C36AEA;
        Fri, 31 Dec 2021 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640945920;
        bh=W4gCix9DyaimD79GMXZWaGfwS+mV5yHLdzhBL/68EsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJojEaKyszuhZeZE8k0ejvlsIxYpdyyLSY7xFKeMMDvQSVi1UsHJNI0m0ickGzy9n
         VilkGSmUNEJEDvrjo3vrxiMGArHfDZzy6fharvvNNPTioJU7St2ZKg4j0teeRmly2d
         e203jW9u1JdQ2lOUv+JEQPH4OAumDAV++0P9jiPE=
Date:   Fri, 31 Dec 2021 11:18:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 5.10 48/76] platform/x86: intel_pmc_core: fix memleak on
 registration failure
Message-ID: <Yc7Y/HOgY5aT7STP@kroah.com>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151326.366957180@linuxfoundation.org>
 <20211231100405.GB17525@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231100405.GB17525@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 31, 2021 at 11:04:05AM +0100, Pavel Machek wrote:
> Hi!
> 
> On Mon 2021-12-27 16:31:03, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit 26a8b09437804fabfb1db080d676b96c0de68e7c upstream.
> > 
> > In case device registration fails during module initialisation, the
> > platform device structure needs to be freed using platform_device_put()
> > to properly free all resources (e.g. the device name).
> >
> 
> Does it? What exactly was leaking here?
> 
> > +++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
> > @@ -65,7 +65,7 @@ static int __init pmc_core_platform_init
> >  
> >  	retval = platform_device_register(pmc_core_device);
> >  	if (retval)
> > -		kfree(pmc_core_device);
> > +		platform_device_put(pmc_core_device);
> >  
> 
> This is strange. Failing registration should have no effects that need
> to be undone.

Sadly, that is not how the driver model has ever worked for various
reasons.

greg k-h
