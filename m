Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7A24D34F
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHUKzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 06:55:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:1522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbgHUKy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 06:54:58 -0400
IronPort-SDR: RnwvpeHgYYzHk/P4dssr/meOhnLk/YU1J7qUUY/P6dZLrDfBzzUiB17SyM5HbRKf7fbL3wnxzc
 16FCIVmAtfAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="135044537"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="135044537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 03:54:52 -0700
IronPort-SDR: B+RpOjZMIwmGp0HVidz9fJuODHW4MTp4+dOYVPIIXXOHa/fI4aEAVIklC1uWdgpsP6wlzjna3M
 Kc+F81tZUxUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="327731447"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 21 Aug 2020 03:54:50 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1k94h7-00AK6y-Cr; Fri, 21 Aug 2020 13:54:49 +0300
Date:   Fri, 21 Aug 2020 13:54:49 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 83/92] mfd: dln2: Run event handler loop under
 spinlock
Message-ID: <20200821105449.GN1891694@smile.fi.intel.com>
References: <20200820091537.490965042@linuxfoundation.org>
 <20200820091541.964627271@linuxfoundation.org>
 <20200821072123.GC23823@amd>
 <CAHp75Vcbmc-PV-gQxuj9i8sAcFCzhJKe_qzEfrkUTZbnf3Vupg@mail.gmail.com>
 <20200821091416.GA1894114@kroah.com>
 <20200821091510.GA1894407@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821091510.GA1894407@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 11:15:10AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 21, 2020 at 11:14:16AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Aug 21, 2020 at 12:06:45PM +0300, Andy Shevchenko wrote:
> > > On Fri, Aug 21, 2020 at 10:26 AM Pavel Machek <pavel@denx.de> wrote:
> > > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > >
> > > > > [ Upstream commit 3d858942250820b9adc35f963a257481d6d4c81d ]
> > > > >
> > > > > The event handler loop must be run with interrupts disabled.
> > > > > Otherwise we will have a warning:
> > > > ...
> > > > > Recently xHCI driver switched to tasklets in the commit 36dc01657b49
> > > > > ("usb: host: xhci: Support running urb giveback in tasklet
> > > > > context").
> > > >
> > > > AFAICT, 36dc01657b49 is not included in 4.19.141, so this commit
> > > > should not be needed, either.
> > > 
> > > I'm wondering if there are any other USB host controller drivers that
> > > use URB giveback in interrupt enabled context.
> > 
> > Almost all do.
> 
> Sorry, read that the wrong way, most have interrupts disabled, so this
> change should be fine.

The change is harmless in these cases. I was wondering if it actually *helps*
in some cases besides xHCI.

-- 
With Best Regards,
Andy Shevchenko


