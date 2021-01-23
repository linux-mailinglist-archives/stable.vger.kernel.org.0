Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B2A301892
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbhAWVkP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 23 Jan 2021 16:40:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:21838 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWVkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 16:40:15 -0500
IronPort-SDR: GNAyPm5aLrpTLI79+0TWMtln7V9xYIwVCTwpsmtRtRc+q7wG/Hes26ZTIqy/eg6b06gNnTIV28
 +phwAoguz4rA==
X-IronPort-AV: E=McAfee;i="6000,8403,9873"; a="166683837"
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="166683837"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2021 13:39:32 -0800
IronPort-SDR: AHN5Bz7cSgsYj1qcJ3Ket1o5684irzM1NM6tO4qWYDdd+K+jzFu/RK+H99CLv1ufODpvIr8man
 4XgjTbP2N4JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="405087279"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jan 2021 13:39:32 -0800
Received: from hasmsx601.ger.corp.intel.com (10.184.107.141) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 23 Jan 2021 13:39:31 -0800
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 HASMSX601.ger.corp.intel.com (10.184.107.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 23 Jan 2021 23:39:29 +0200
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Sat, 23 Jan 2021 23:39:29 +0200
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [watchdog] watchdog: mei_wdt: request stop on unregister
Thread-Topic: [watchdog] watchdog: mei_wdt: request stop on unregister
Thread-Index: AQHW5S9gkIdx23nrZEuNJxrFE8ot0qocufCAgBjKogCAAD0REA==
Date:   Sat, 23 Jan 2021 21:39:29 +0000
Message-ID: <a25386324dba4721a43bc7e4a3d0e5a5@intel.com>
References: <20210107195730.1660449-1-tomas.winkler@intel.com>
 <20210108001215.GA58926@roeck-us.net> <20210123184744.GA61339@roeck-us.net>
In-Reply-To: <20210123184744.GA61339@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> Tomas,
> 
> On Thu, Jan 07, 2021 at 04:12:15PM -0800, Guenter Roeck wrote:
> > Hi,
> >
> > On Thu, Jan 07, 2021 at 09:57:30PM +0200, Tomas Winkler wrote:
> > > From: Alexander Usyskin <alexander.usyskin@intel.com>
> > >
> > > Send the stop command to the firmware on watchdog unregister to
> > > eleminate false event on suspend.
> > >
> >
> > Normally the watchdog driver would not be expected to unregister
> > during suspend, only when the driver is manually unloaded.
> > To support suspend/resume, other watchdog drivers implement
> > suspend/resume functions to stop the watchdog on suspend and to
> > restart it on resume. Unloading a watchdog driver on suspend would
> > also have odd implications for userspace watchdog daemons.
> >
> > On top of that, it should not actually be possible to unregister a
> > watchdog while it is in use (because it is open in that case and
> > should be marked as busy). watchdog_stop_on_unregister() only serves
> > as backup in case someone actually manages to unload the driver while
> > the watchdog is running. The function was implemented to avoid calls
> > to stop the watchdog in the remove function because I can not
> > mathematically prove that there are no situations where the watchdog
> > is unloaded while running.
> > However, I have not actually been able to do that.
> >
> > Are you sure this patch is doing what you expect it to do ?
> >
> 
> I have not heard anything back. I tried to understand how this patch would
> resolve a problem during suspend/resume, but I didn't find anything.

Sorry,  I've already prepared better commit message,  just had to move the attention to other issues.

> 
> Can you maybe add a log message showing the false event that is prevented
> with this patch, and some context explaining how the patch fixes the
> problem ?

The MEI watchdog device lives on mei client bus and currently this bus has a special behavior, on suspend it destroys all the devices that are present on the bus.
This is due to fact that  the context in the MEI firmware is also lost on suspend and the resume is always a fresh start. 

Thanks
Tomas


> 
> Thanks,
> Guenter
> 
> > Thanks,
> > Guenter
> >
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > ---
> > >  drivers/watchdog/mei_wdt.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
> > > index 5391bf3e6b11..c5967d8b4256 100644
> > > --- a/drivers/watchdog/mei_wdt.c
> > > +++ b/drivers/watchdog/mei_wdt.c
> > > @@ -382,6 +382,7 @@ static int mei_wdt_register(struct mei_wdt *wdt)
> > >
> > >  	watchdog_set_drvdata(&wdt->wdd, wdt);
> > >  	watchdog_stop_on_reboot(&wdt->wdd);
> > > +	watchdog_stop_on_unregister(&wdt->wdd);
> > >
> > >  	ret = watchdog_register_device(&wdt->wdd);
> > >  	if (ret)
> > > --
> > > 2.26.2
> > >
