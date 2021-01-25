Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5712E302C6D
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbhAYUWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731633AbhAYUWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:22:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50AF8224F9;
        Mon, 25 Jan 2021 20:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611606093;
        bh=vQNnXrURblkA6w2/EHCepvadwI2O+Pj+tMV6HI4mRrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqfr0pjC4Y73jrKmjgqQdimInnH59En+EI/1TMP/g69/4kmuJwyShrPOi0vim44U7
         oj52JhJ0Se06U3jkCqlib9sgJaTrD/Q0aZ6QSCCjUQlyklwS5dWhKK2CfkKS1Ofqd0
         E3UB+X/bX5zdGtS/8ThUIlgLrW+Ue++2x3AQUDEOZIMhbB3mkaq1S/qC4p2lpOnD94
         m8rL9SZmlT7ypr7UFhQnrOLw8cnDotFKXPyt2g0iKDlfKKJhmqkdN/mcHyYDxxXpjT
         9oM6y4vHn6/VJPrlqTJsKbgP7M6wKblE1tkpp48WAbLLSUzZgzlPot+LHoYgXllBUg
         H+Xmn0KMKGYrg==
Received: by pali.im (Postfix)
        id 0C624BAB; Mon, 25 Jan 2021 21:21:30 +0100 (CET)
Date:   Mon, 25 Jan 2021 21:21:30 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210125202130.afwhcuznietmqo5s@pali>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
 <20210125201938.GB78651@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125201938.GB78651@roeck-us.net>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 25 January 2021 12:19:38 Guenter Roeck wrote:
> On Mon, Jan 25, 2021 at 11:05:40AM +0100, Pali Rohár wrote:
> > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > > freezing behavior to the other systems[1] on this blacklist. The issue
> > > was exposed by a prior change of mine to automatically load
> > > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > > this model to the blacklist.
> > > 
> > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> > > 
> > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > ---
> > > 
> > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
> > >  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> > >  		},
> > >  	},
> > > +	{
> > > +		.ident = "Dell XPS 15 L502X",
> > > +		.matches = {
> > > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> > 
> > Hello! Are you sure that it is required to completely disable fan
> > support? And not only access to fan type label for which is different
> > blaclist i8k_blacklist_fan_type_dmi_table?
> > 
> 
> I'll drop this patch from my branch. Please send a Reviewed-by: or Acked-by: tag
> if/when I should apply it.

Of course! We will just wait for Bob test results.

> Thanks,
> Guenter
