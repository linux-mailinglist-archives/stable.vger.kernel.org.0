Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2547947CDB3
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 08:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhLVHym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 02:54:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38386 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbhLVHyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 02:54:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0369E618D6;
        Wed, 22 Dec 2021 07:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF50C36AE5;
        Wed, 22 Dec 2021 07:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640159680;
        bh=YjXqL4Z0rW6HSakPTtDSodXM3P36BkzOc2Oo3D5+UGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQeh5J/+jP4kK7r4iUVD7DRT0WToGrb4umMhhW0yAcnRAr9sG7/1AORO5bsC3rVin
         /rdrTxTKqe0UaCK2bfmTeyGtK6nV9IcFgOVpm5uDHQWI3yOUC844g/gl3Yt+nJgGqA
         ZhWgHXO6/BKk6t9u/yWmOJMRCYen3K9zpf0nuAs4=
Date:   Wed, 22 Dec 2021 08:54:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 18/56] hv: utils: add PTP_1588_CLOCK to Kconfig to
 fix build
Message-ID: <YcLZvcoiPVVmWhu4@kroah.com>
References: <20211220143023.451982183@linuxfoundation.org>
 <20211220143024.049888083@linuxfoundation.org>
 <20211220203136.GA4116@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220203136.GA4116@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 09:31:36PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > [ Upstream commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 ]
> > 
> > The hyperv utilities use PTP clock interfaces and should depend a
> > a kconfig symbol such that they will be built as a loadable module or
> > builtin so that linker errors do not happen.
> > 
> > Prevents these build errors:
> > 
> > ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
> > hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
> > ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
> > hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'
> 
> This is bad idea for 4.19:
> 
> > +++ b/drivers/hv/Kconfig
> > @@ -16,6 +16,7 @@ config HYPERV_TSCPAGE
> >  config HYPERV_UTILS
> >  	tristate "Microsoft Hyper-V Utilities driver"
> >  	depends on HYPERV && CONNECTOR && NLS
> > +	depends on PTP_1588_CLOCK_OPTIONAL
> >  	help
> >  	  Select this option to enable the Hyper-V Utilities.
> 
> grep -ri PTP_1588_CLOCK_OPTIONAL .
> 
> Results in no result in 4.19. So this will break hyperv. No results in
> 5.10, either, so it is bad idea there, too.

Thanks, I will go delete it from all queues.

greg k-h
