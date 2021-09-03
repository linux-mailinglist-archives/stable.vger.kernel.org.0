Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA33FFCBD
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhICJKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231734AbhICJKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EDB60FA0;
        Fri,  3 Sep 2021 09:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630660140;
        bh=DcjjJ2WAyz1ejKxh5caZx2UjPxskQXotN1KC+CVTphM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AXVe52q+2qENaWaDMiNqezmL4BsUWssD8bJgO6b/o7VEIMHLNCgzHRygULaFTLwRR
         oGz0JvrwOuCyWgZZPRJsgjb88aE0JCr9iBHnqDnHyutHvuocaJmuo0+o0dzEvLEmh3
         rgQwV9xE7s8/DBL80QGApRESQeCjgwrWCZXPWS2g=
Date:   Fri, 3 Sep 2021 11:08:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
Message-ID: <YTHmKvYz5j8ZT9Jt@kroah.com>
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com>
 <YTHjPbklWVDVaBfK@kroah.com>
 <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 11:01:58AM +0200, Juergen Gross wrote:
> On 03.09.21 10:56, Greg Kroah-Hartman wrote:
> > On Fri, Sep 03, 2021 at 10:49:36AM +0200, Juergen Gross wrote:
> > > In there is no legacy RTC device, don't try to use it for storing trace
> > > data across suspend/resume.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > ---
> > >   drivers/base/power/trace.c | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> > > index a97f33d0c59f..b7c80849455c 100644
> > > --- a/drivers/base/power/trace.c
> > > +++ b/drivers/base/power/trace.c
> > > @@ -13,6 +13,7 @@
> > >   #include <linux/export.h>
> > >   #include <linux/rtc.h>
> > >   #include <linux/suspend.h>
> > > +#include <linux/init.h>
> > >   #include <linux/mc146818rtc.h>
> > > @@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, unsigned int user)
> > >   	const char *file = *(const char **)(tracedata + 2);
> > >   	unsigned int user_hash_value, file_hash_value;
> > > +	if (!x86_platform.legacy.rtc)
> > > +		return 0;
> > 
> > Why does the driver core code here care about a platform/arch-specific
> > thing at all?  Did you just break all other arches?
> 
> This file is only compiled for x86. It depends on CONFIG_PM_TRACE_RTC,
> which has a "depends on X86" attribute.

Odd, and not obvious at all :(

Ok, I'll let Rafael review this...
