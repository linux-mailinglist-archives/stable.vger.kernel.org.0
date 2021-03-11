Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC25A3372CD
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 13:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhCKMh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 07:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233171AbhCKMhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 07:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA3EC64FDF;
        Thu, 11 Mar 2021 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615466230;
        bh=yj9BLjFX/Ld02Tvam9QEdp3E9cEM2pmnpLKhViJCcnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qi9q8i7ZpDiWrmPgdjMaQ1aNwz5Ui+o4f4HaTU4Sp1SVGLAML8UweTXNpIYdMGUHY
         oNixdmz8+MQCoJO6WncHqb9/v+Rs77CgAzG8Njuoqfiko6Y+d+Hao1byq6GRnBiXH1
         OBe1f+ojjoHjv4lRoEc/5q5I6udBgjjQOHhQPjl8=
Date:   Thu, 11 Mar 2021 13:37:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Jasper St. Pierre" <jstpierre@mecheye.net>,
        Chris Chiu <chiu@endlessos.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 23/49] ACPI: video: Add DMI quirk for GIGABYTE
 GB-BXBT-2807
Message-ID: <YEoO82QF7Y8kTif0@kroah.com>
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.685806668@linuxfoundation.org>
 <20210310200458.GA12122@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310200458.GA12122@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 09:04:58PM +0100, Pavel Machek wrote:
> Hi!
> 
> On Wed 2021-03-10 14:23:34, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > From: Jasper St. Pierre <jstpierre@mecheye.net>
> 
> Something is funny with the From header here. But that's not main
> thing -- this patch is evil.

That is odd...

> 
> > 
> > [ Upstream commit 25417185e9b5ff90746d50769d2a3fcd1629e254 ]
> > 
> > The GIGABYTE GB-BXBT-2807 is a mini-PC which uses off the shelf
> > components, like an Intel GPU which is meant for mobile systems.
> > As such, it, by default, has a backlight controller exposed.
> > 
> > Unfortunately, the backlight controller only confuses userspace, which
> > sees the existence of a backlight device node and has the unrealistic
> > belief that there is actually a backlight there!
> > 
> > Add a DMI quirk to force the backlight off on this system.
> 
> > +++ b/drivers/acpi/video_detect.c
> > @@ -140,6 +140,13 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
> >  	},
> >  	{
> >  	.callback = video_detect_force_vendor,
> > +	.ident = "GIGABYTE GB-BXBT-2807",
> > +	.matches = {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
> > +		},
> > +	},
> > +	{
> >  	.ident = "Sony VPCEH3U1E",
> >  	.matches = {
> >  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> 
> Yup, and it looks like this fixes the problem for GIGABYTE
> GB-BXBT-2807 but re-introduces the problem for Sony VPCEH3U1E, because
> its .callback is now NULL.

That's what upstream has right now, for 5.11, so I'll take this for now
and if upstream changes it, I'll take that patch as well.

thanks,

greg k-h
