Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C74306774
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 00:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhA0XCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 18:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhA0XAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 18:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01A6564DD5;
        Wed, 27 Jan 2021 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788404;
        bh=6OndkKvgPn1usFvWt70AMS39vqsHZMLrv+enaXJhuac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vn5SHI8MM0wv1Ubalhfry4NlZYNLajiaY4cqS5B4whSr7h5w2bahMqs/zbd7/+H1F
         JJfikZ5QW+CblL2Gc3YoEQyAA6pIy/B4jSuGLimzJqygrK0aC/O9fHSCliU5yPVOa4
         5E4kBDKmNQycY1morq8/ZRlDhjhi+7bXQEuH5YKzgzOAoZAnw/PEXxLjsyGwCug02O
         cRCwYQQKcEBXbAgZ+jSvIaKn4UdCW6XoFZG4A3DnOBxaRWSeDdPrpp1Q8qORNXvspu
         XlR33BOVko4ygbYiVxh2e80a10bH8aJc3hC7EaRo+6pD5E7dF0KcVheEr7Et/+0WWP
         AH5tB9FT7ni/g==
Received: by pali.im (Postfix)
        id D8616768; Thu, 28 Jan 2021 00:00:01 +0100 (CET)
Date:   Thu, 28 Jan 2021 00:00:01 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210127230001.7zeeczkfj33zj5sw@pali>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
 <20210125201938.GB78651@roeck-us.net>
 <20210125202130.afwhcuznietmqo5s@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125202130.afwhcuznietmqo5s@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 25 January 2021 21:21:30 Pali Rohár wrote:
> On Monday 25 January 2021 12:19:38 Guenter Roeck wrote:
> > On Mon, Jan 25, 2021 at 11:05:40AM +0100, Pali Rohár wrote:
> > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > > > freezing behavior to the other systems[1] on this blacklist. The issue
> > > > was exposed by a prior change of mine to automatically load
> > > > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > > > this model to the blacklist.
> > > > 
> > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> > > > 
> > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> > > > Cc: stable@vger.kernel.org
> > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > ---
> > > > 
> > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
> > > >  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> > > >  		},
> > > >  	},
> > > > +	{
> > > > +		.ident = "Dell XPS 15 L502X",
> > > > +		.matches = {
> > > > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > > +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> > > 
> > > Hello! Are you sure that it is required to completely disable fan
> > > support? And not only access to fan type label for which is different
> > > blaclist i8k_blacklist_fan_type_dmi_table?
> > > 
> > 
> > I'll drop this patch from my branch. Please send a Reviewed-by: or Acked-by: tag
> > if/when I should apply it.
> 
> Of course! We will just wait for Bob test results.

Guenter, now we have all needed information, fix is really needed in
this form. So you can add my:

Reviewed-by: Pali Rohár <pali@kernel.org>
