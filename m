Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC3673453
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 10:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjASJ0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 04:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjASJ0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 04:26:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F84B6EAE;
        Thu, 19 Jan 2023 01:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674120374; x=1705656374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QtNpUIEDSN85Lq8EgyeZ2aGyZiOiIaS380BR/yFoStQ=;
  b=fFPrbTv5dsaM//UFAdGO/+KOXoxyiSmjbE9x1AHj3TBRQ+63KoY1VSa7
   0b1JVvyCVGFwegmQPavcgZr8h2+DkfrXstVpJimZWbFn0BL/lqUryPSvS
   8RP8y9I0GXGho3kItqE6j3dORkgG3/JgoJWOJw1aTFLpNh5FHXk23oCe6
   +jRsOW9t8VAuR90S+NROF8hTPNZmICx8KatWib7hA5cU3vSZGEI/mQUxT
   SpJewOpzvzG2PJkKEXw6FMUn1irNhQ/JvfW6/Sp2rLLKU9Gbbp7eYMR3T
   iB7TteOSTwSHxfYQXVuAFqqqE0kmfzAuNd3QhzVIZaM7MfDASYU4Wdbwa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322924983"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="322924983"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:26:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802564865"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="802564865"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 19 Jan 2023 01:26:11 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 19 Jan 2023 11:26:11 +0200
Date:   Thu, 19 Jan 2023 11:26:11 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
Message-ID: <Y8kMsw/wT35KN7VK@kuha.fi.intel.com>
References: <20230118031514.1278139-1-pmalani@chromium.org>
 <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com>
 <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Prashant,

On Wed, Jan 18, 2023 at 10:26:21AM -0800, Prashant Malani wrote:
> Hi Heikki,
> 
> Thanks for reviewing the patch.
> 
> On Wed, Jan 18, 2023 at 1:39 AM Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
> >
> > On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> > > Update the altmode "active" state when we receive Acks for Enter and
> > > Exit Mode commands. Having the right state is necessary to change Pin
> > > Assignments using the 'pin_assignment" sysfs file.
> >
> > The idea was that the port drivers take care of this, not the altmode
> > drivers.
> 
> For the port's typec_altmode struct, that makes sense.
> Should the port driver be taking care of the state for the partner's altmode
> too, i.e "/sys/class/typec/port1-partner/port1-partner.0/active" ?
> 
> It seemed like the port driver should be forwarding the VDMs without snooping
> the header, or IOW, it should let the altmode driver parse the VDMs (which it's
> doing in this case) and manage the partner altmode state.
> 
> "pin_assignment_store" seems to only work if the partner's altmode
> "active" bit is set to active [1]
> 
> FWIW, I think we can make the typec_altmode_update_active() calls from
> our (cros-ec-typec) port driver too, but displayport.c is parsing the header
> anyway, so it seemed repetitive. Just wanted to clarify the intention here.

The alt modes may have been entered even if there are no drivers for
them, if for example the PD controller handles the mode entry. In
those cases the port driver needs to update the active state of the
partner alt mode.

Since the port drivers have to handle that in some cases, for the sake
of consistency I thought that they might as well take care of it in
every case.

On the other hand, it should be safe to do it in both the port driver
and the altmode driver.

If you prefer that the altmode drivers always do this, I'm not against
it. But in that case could you patch tcpm.c while at it - in the same
series:

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 904c7b4ce2f0c..0f5a9d4db105a 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1693,14 +1693,11 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
                        }
                        break;
                case CMD_ENTER_MODE:
-                       if (adev && pdev) {
-                               typec_altmode_update_active(pdev, true);
+                       if (adev && pdev)
                                *adev_action = ADEV_QUEUE_VDM_SEND_EXIT_MODE_ON_FAIL;
-                       }
                        return 0;
                case CMD_EXIT_MODE:
                        if (adev && pdev) {
-                               typec_altmode_update_active(pdev, false);
                                /* Back to USB Operation */
                                *adev_action = ADEV_NOTIFY_USB_AND_QUEUE_VDM;
                                return 0;

That's the only driver that will definitely always requires the
altmode drivers, so perhaps it would be good to drop the calls
from it at the same time.

thanks,

-- 
heikki
