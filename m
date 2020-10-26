Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B406D298D78
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 14:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773950AbgJZNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 09:07:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:18176 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773920AbgJZNHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 09:07:53 -0400
IronPort-SDR: z1ZAUR0Ecj3TGol77GdcYiKbGoNSYdERzGWf+KeEc7x60KZNVtcv2ucHclM4RVt3Vcxw+BqwWs
 qttJFUvr0m5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="185644041"
X-IronPort-AV: E=Sophos;i="5.77,419,1596524400"; 
   d="scan'208";a="185644041"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 06:05:25 -0700
IronPort-SDR: zM/xi1SkIfHhwXPa0Want6A593UHClAIAWlA9t1jJoEYhWIxF/AQQ8gYEm4x/J9ly4paZhtCUD
 rY57F6XYcOyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,419,1596524400"; 
   d="scan'208";a="424088518"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 26 Oct 2020 06:05:22 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 26 Oct 2020 15:05:22 +0200
Date:   Mon, 26 Oct 2020 15:05:22 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Sriharsha Allenki <sallenki@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackp@codeaurora.org,
        mgautam@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: Prevent setting invalid opmode value
Message-ID: <20201026130522.GC1442058@kuha.fi.intel.com>
References: <1603359734-2931-1-git-send-email-sallenki@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603359734-2931-1-git-send-email-sallenki@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 22, 2020 at 03:12:14PM +0530, Sriharsha Allenki wrote:
> Setting opmode to invalid values would lead to a
> paging fault failure when there is an access to the
> power_operation_mode.
> 
> Prevent this by checking the validity of the value
> that the opmode is being set.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: fab9288428ec ("usb: USB Type-C connector class")
> Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
> ---
>  drivers/usb/typec/class.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
> index 35eec70..63efe16 100644
> --- a/drivers/usb/typec/class.c
> +++ b/drivers/usb/typec/class.c
> @@ -1427,7 +1427,8 @@ void typec_set_pwr_opmode(struct typec_port *port,
>  {
>  	struct device *partner_dev;
>  
> -	if (port->pwr_opmode == opmode)
> +	if ((port->pwr_opmode == opmode) || (opmode < TYPEC_PWR_MODE_USB) ||

You don't need to check if opmode < anything. opmode is enum which
apparently means that GCC handles it as unsigned. Since
TYPEC_PWR_MODE_USB is 0 it means opmode < TYPEC_PWR_MODE_USB is never
true.

> +						(opmode > TYPEC_PWR_MODE_PD))
>  		return;

You really need to print an error at the very least. Otherwise we will
just silently hide possible driver bugs.

To be honest, I'm not a big fan of this kind of checks. They have
created more problems than they have fixed in more than one occasion
to me. For example, there really is no guarantee that the maximum will
always be TYPEC_PWR_MODE_PD, which means we probable should have
something like TYPEC_PWR_MODE_MAX defined somewhere that you compare
the opmode value to instead of TYPEC_PWR_MODE_PD to play it safe, but
let's not bother with that for now (it will create other problems).

Basically, with functions like this, especially since it doesn't
return anything, the responsibility of checking the validity of the
parameters that the caller supplies to it belongs to the caller IMO,
not the function itself. I would be happy to explain that in the
kernel doc style comment of the function.

If you still feel that this change is really necessary, meaning you
have some actual case where the caller can _not_ check the range
before calling this function, then explain the case you have carefully
in the commit message and add the check as a separate condition:

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 35eec707cb512..7de6913d90f9c 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1430,6 +1430,11 @@ void typec_set_pwr_opmode(struct typec_port *port,
        if (port->pwr_opmode == opmode)
                return;
 
+       if (opmode > TYPEC_PWR_OPMODE_PD) {
+               dev_err(&port->dev, "blah-blah-blah\n");
+               return;
+       }
+
        port->pwr_opmode = opmode;
        sysfs_notify(&port->dev.kobj, NULL, "power_operation_mode");
        kobject_uevent(&port->dev.kobj, KOBJ_CHANGE);

Otherwise you can just propose a patch that improves the documentation
of this function, explaining that it does not take any responsibility
over the parameters passed to it for now.


thanks,

-- 
heikki
