Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795E964B140
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 09:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLMIhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 03:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiLMIho (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 03:37:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE37765BF;
        Tue, 13 Dec 2022 00:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670920662; x=1702456662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=muyLhzUL6TC6ixkunPAAIPRNRRxzfocbzQkAtYhFLbQ=;
  b=jDYKUiFCcQzs8mAoLAVn6kuDkZtYcRtYq3HkRpIso4t8FTb1jVXzNZyI
   8uZKA82+DM097OR/i5xoyL0Vmew37sbcfI2w86G30fY3uog2viPE+3TDO
   f7w8Wvovx4uosqAwQMtC2vWPLfRAgl+9vRESYZFtYtRL06kFvqrcq0pyE
   Q7RFZmkABu6ZLG5HvhsgKCeafYPGoDOWQPybsaCU6bR2xJm+RJCU8Owy6
   iZK+an9IrTrjpookfLopj4NZZ8ecyZREXkqunozSCnHDUWt4t44BWwGLn
   AYh0d7Eh2RT1uoTAuBaYpqlAAX3CO5Laatg0vn78Km2b0FT8Nf4rAXbWz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="298420192"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="298420192"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 00:36:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="790810464"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="790810464"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 13 Dec 2022 00:36:33 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 13 Dec 2022 10:36:32 +0200
Date:   Tue, 13 Dec 2022 10:36:32 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Message-ID: <Y5g5kPYu9+tGfriE@kuha.fi.intel.com>
References: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
 <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
 <OS0PR01MB59225780B75FDC02C077ACE986E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922FC3A7C5F0507292F99AF86E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922FC3A7C5F0507292F99AF86E29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Dec 12, 2022 at 10:54:25AM +0000, Biju Das wrote:
> > Looks It is a bug in renesas_usb3.c rather than this driver.
> > 
> > But how we will prevent hd3ss3220_set_role being called after
> > usb_role_switch_unregister(usb3->role_sw) from renesas_usb3.c driver??

Normally that should not be a problem. When you get a reference to the
role switch, also the reference count of the switch driver module (on
top of the device) is incremented.

From where is usb_role_switch_unregister() being called in this case -
is it renesas_usb3_probe()?

If it is, would something like this help:

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 615ba0a6fbee1..d2e01f7cfef11 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2907,18 +2907,13 @@ static int renesas_usb3_probe(struct platform_device *pdev)
        renesas_usb3_role_switch_desc.driver_data = usb3;
 
        INIT_WORK(&usb3->role_work, renesas_usb3_role_work);
-       usb3->role_sw = usb_role_switch_register(&pdev->dev,
-                                       &renesas_usb3_role_switch_desc);
-       if (!IS_ERR(usb3->role_sw)) {
-               usb3->host_dev = usb_of_get_companion_dev(&pdev->dev);
-               if (!usb3->host_dev) {
-                       /* If not found, this driver will not use a role sw */
-                       usb_role_switch_unregister(usb3->role_sw);
-                       usb3->role_sw = NULL;
-               }
-       } else {
+
+       usb3->host_dev = usb_of_get_companion_dev(&pdev->dev);
+       if (usb3->host_dev)
+               usb3->role_sw = usb_role_switch_register(&pdev->dev,
+                                                        &renesas_usb3_role_switch_desc);
+       if (IS_ERR(usb3->role_sw))
                usb3->role_sw = NULL;
-       }
 
        usb3->workaround_for_vbus = priv->workaround_for_vbus;
 


> Do we need to add additional check for "fwnode_usb_role_switch_get" and
> "usb_role_switch_get" to return error if there is no registered role_switch device
> Like the scenario above??

No. The switch is always an optional resource.

Error means that there is a switch that you can control, but you can't
get a handle to it for some reason.

NULL means you don't need to worry about it - there is no switch on
your platform that you could control.

thanks,

-- 
heikki
