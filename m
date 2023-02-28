Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB24A6A5877
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 12:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjB1Ll4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 06:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjB1Llz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 06:41:55 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C572CC77;
        Tue, 28 Feb 2023 03:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677584513; x=1709120513;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=phj48FYIPUNxXUJbLJqKUoI6zPBm7GSV3FNYT5R+/0Y=;
  b=m320wiyDn/sQGGSChlIuJc+Nvrr3FZSvNFjz7Wq063+10l90wiIrI9jy
   8vCUEHKtFXw4HDv+QNPTan9hin2aPC7W73LaV14x3xEkrz/WHGZFQMQVQ
   Ds0fXTDbgPbGfsEdC9f3auCboIi++dhMhEb+QqQl6X6Z14tPtTLwE2RQH
   8Fv+9pU6VfELykEmYCd9i6zhRQJ5odYLBddyY2LcFHhQLN/9ssj+bNXfu
   1J9Ze2IVHylghTHzAOWI5Nck3oqn329zSn8ZIiN+U4Va3uE1pf+TaKBmw
   f+cCuvBSGqnW/9crhiGIvdXZ324Z3bSbqr7VjTNcQBFn2jvUVq2H4UWvV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396681671"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="396681671"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 03:41:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="817061554"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="817061554"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 28 Feb 2023 03:41:51 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 28 Feb 2023 13:41:50 +0200
Date:   Tue, 28 Feb 2023 13:41:50 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: ucsi: Fix NULL pointer deref in
 ucsi_connector_change()
Message-ID: <Y/3ofhWfttn6gdJg@kuha.fi.intel.com>
References: <20230228090305.9335-1-hdegoede@redhat.com>
 <Y/3R68g6qKsqqLdL@kuha.fi.intel.com>
 <800fcc20-8009-529f-fc09-c1394cd397fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800fcc20-8009-529f-fc09-c1394cd397fb@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 11:15:46AM +0100, Hans de Goede wrote:
> Hi,
> 
> On 2/28/23 11:05, Heikki Krogerus wrote:
> > On Tue, Feb 28, 2023 at 10:03:03AM +0100, Hans de Goede wrote:
> >> When ucsi_init() fails, ucsi->connector is NULL, yet in case of
> >> ucsi_acpi we may still get events which cause the ucs_acpi code to call
> >> ucsi_connector_change(), which then derefs the NULL ucsi->connector
> >> pointer.
> >>
> >> Fix this by adding a check for ucsi->connector being NULL, as is
> >> already done in ucsi_resume() for similar reasons.
> >>
> >> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>  drivers/usb/typec/ucsi/ucsi.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> >> index 1cf8947c6d66..e762897cb25a 100644
> >> --- a/drivers/usb/typec/ucsi/ucsi.c
> >> +++ b/drivers/usb/typec/ucsi/ucsi.c
> >> @@ -842,7 +842,13 @@ static void ucsi_handle_connector_change(struct work_struct *work)
> >>   */
> >>  void ucsi_connector_change(struct ucsi *ucsi, u8 num)
> >>  {
> >> -	struct ucsi_connector *con = &ucsi->connector[num - 1];
> >> +	struct ucsi_connector *con;
> >> +
> >> +	/* Check for ucsi_init() failure */
> >> +	if (!ucsi->connector)
> >> +		return;
> >> +
> >> +	con = &ucsi->connector[num - 1];
> >>  
> >>  	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
> >>  		dev_dbg(ucsi->dev, "Bogus connector change event\n");
> > 
> > I think we should try to rely on that ucsi->ntfy. Would this work:
> > 
> > diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> > index fe1963e328378..0da1e9c66971a 100644
> > --- a/drivers/usb/typec/ucsi/ucsi.c
> > +++ b/drivers/usb/typec/ucsi/ucsi.c
> > @@ -928,15 +928,13 @@ static void ucsi_handle_connector_change(struct work_struct *work)
> >   */
> >  void ucsi_connector_change(struct ucsi *ucsi, u8 num)
> >  {
> > -       struct ucsi_connector *con = &ucsi->connector[num - 1];
> > -
> >         if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
> >                 dev_dbg(ucsi->dev, "Bogus connector change event\n");
> >                 return;
> >         }
> >  
> >         if (!test_and_set_bit(EVENT_PENDING, &ucsi->flags))
> > -               schedule_work(&con->work);
> > +               schedule_work(&ucsi->connector[num - 1].work);
> >  }
> >  EXPORT_SYMBOL_GPL(ucsi_connector_change);
> >  
> 
> This hunk is not necessary, the con pointer pointing to lala land is
> not an issue as long as we don't deref it. The &ucsi->connector[num - 1];
> does not deref ucsi->connector it it simply adds an offset to it and
> stores that in con (the backtrace I got pointed to the schedule_work call).
> 
> But I guess your way does make it more obvious that we don't
> deref ucsi->connector.
> 
> > @@ -1404,6 +1402,7 @@ static int ucsi_init(struct ucsi *ucsi)
> >         ucsi->connector = NULL;
> >  
> >  err_reset:
> > +       ucsi->ntfy = 0;
> >         memset(&ucsi->cap, 0, sizeof(ucsi->cap));
> >         ucsi_reset_ppm(ucsi);
> >  err:
> 
> In would expect this to fix things, but I only have access to the monitor
> triggering this on Mondays, so I can only 100% confirm next Monday.
> 
> Note this does open the race I try to fix in patch 2/3 again.
> 
> So what should be done here is to make ntfy a local variable and only
> store it in ucsi->ntfy on success.

OK.

thanks,

-- 
heikki
