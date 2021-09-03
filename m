Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE93FFC77
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348548AbhICI5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 04:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348461AbhICI5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 04:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B3161051;
        Fri,  3 Sep 2021 08:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659392;
        bh=SsjjbztlEwoQ2/FB20kOEWlK/4U11FZMfaPIS5UzwPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HIACXt/YT6pWCqM1ZXgIK14DP/a+8b2wZJAtH533JTB7bHiNh5hQjPgWr4l844+Hp
         fsqjfJdlFyq4d5jAQMavIFBifH1me5UlrWLbbRy3fBUFxN2leYC9fYTFblIYrARotV
         Weq2nXrRWULvKRmXB2e4DIi5A9/LS26+/JVxSY+U=
Date:   Fri, 3 Sep 2021 10:56:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
Message-ID: <YTHjPbklWVDVaBfK@kroah.com>
References: <20210903084937.19392-1-jgross@suse.com>
 <20210903084937.19392-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903084937.19392-2-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 10:49:36AM +0200, Juergen Gross wrote:
> In there is no legacy RTC device, don't try to use it for storing trace
> data across suspend/resume.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  drivers/base/power/trace.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> index a97f33d0c59f..b7c80849455c 100644
> --- a/drivers/base/power/trace.c
> +++ b/drivers/base/power/trace.c
> @@ -13,6 +13,7 @@
>  #include <linux/export.h>
>  #include <linux/rtc.h>
>  #include <linux/suspend.h>
> +#include <linux/init.h>
>  
>  #include <linux/mc146818rtc.h>
>  
> @@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, unsigned int user)
>  	const char *file = *(const char **)(tracedata + 2);
>  	unsigned int user_hash_value, file_hash_value;
>  
> +	if (!x86_platform.legacy.rtc)
> +		return 0;

Why does the driver core code here care about a platform/arch-specific
thing at all?  Did you just break all other arches?

thanks,

greg k-h
