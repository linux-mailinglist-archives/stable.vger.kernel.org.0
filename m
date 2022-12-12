Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C9D649B57
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 10:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiLLJjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 04:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLLJjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 04:39:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCF6293;
        Mon, 12 Dec 2022 01:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670837990; x=1702373990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D4aq1midSea1cXjpHa196Bf+aoonOH7F/fZwukvECEw=;
  b=ilM9DKw+TLzfHMcuzxXwj933OdPH9MCNOSnEaLyS03/QXRfz1f8ykn6H
   vdwjwMkTqRw4/J7QAmuhd7Ot/NCg0zfxVQuX5Aevq/lDrS4FYjpYeEW2n
   3aSzKO+PZ3vVbNCNpZ3auU+vWx8B7/BbUXVeibqmb3XvxmWW57/YznqyO
   MZCPmYOska7oqF00A4oM8QuQ0G/YCvpwT4hV8q/HTVaNP9TG1Hy5W0bNN
   DccO4RkRh0rdsWsdJuwLni2EkpN5tgzQl8Vr55ppg+TwKlmt1WkOjTp+x
   lvxEW9VKTsx0hFkqgbCdb51xim4Cl5TT+wzxHT4MQASBobYlIkI3FbtB6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="297491974"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="297491974"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 01:39:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="790429513"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="790429513"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Dec 2022 01:39:47 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 12 Dec 2022 11:39:46 +0200
Date:   Mon, 12 Dec 2022 11:39:46 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das@bp.renesas.com>, linux-usb@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: typec: hd3ss3220: Fix NULL pointer crash
Message-ID: <Y5b24vdYTNW/aJ+0@kuha.fi.intel.com>
References: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209170740.70539-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Biju,

On Fri, Dec 09, 2022 at 05:07:40PM +0000, Biju Das wrote:
> The value returned by usb_role_switch_get() can be NULL and it leads
> to NULL pointer crash. This patch fixes this issue by adding NULL
> check for the role switch handle.
> 
> [   25.336613] Hardware name: Silicon Linux RZ/G2E evaluation kit EK874 (CAT874 + CAT875) (DT)
> [   25.344991] Workqueue: events_unbound deferred_probe_work_func
> [   25.350869] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   25.357854] pc : renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
> [   25.364428] lr : renesas_usb3_role_switch_get+0x24/0x80 [renesas_usb3]
> [   25.370986] sp : ffff80000a4b3a40
> [   25.374311] x29: ffff80000a4b3a40 x28: 0000000000000000 x27: 0000000000000000
> [   25.381476] x26: ffff80000a3ade78 x25: ffff00000a809005 x24: ffff80000117f178
> [   25.388641] x23: ffff00000a8d7810 x22: ffff00000a8d8410 x21: 0000000000000000
> [   25.395805] x20: ffff000011cd7080 x19: ffff000011cd7080 x18: 0000000000000020
> [   25.402969] x17: ffff800076196000 x16: ffff800008004000 x15: 0000000000004000
> [   25.410133] x14: 000000000000022b x13: 0000000000000001 x12: 0000000000000001
> [   25.417291] x11: 0000000000000000 x10: 0000000000000a40 x9 : ffff80000a4b3770
> [   25.424452] x8 : ffff00007fbc9000 x7 : 0040000000000008 x6 : ffff00000a8d8590
> [   25.431615] x5 : ffff80000a4b3960 x4 : 0000000000000000 x3 : ffff00000a8d84f4
> [   25.438776] x2 : 0000000000000218 x1 : ffff80000a715218 x0 : 0000000000000218
> [   25.445942] Call trace:
> [   25.448398]  renesas_usb3_role_switch_get+0x40/0x80 [renesas_usb3]
> [   25.454613]  renesas_usb3_role_switch_set+0x4c/0x440 [renesas_usb3]
> [   25.460908]  usb_role_switch_set_role+0x44/0xa4
> [   25.465468]  hd3ss3220_set_role+0xa0/0x100 [hd3ss3220]
> [   25.470635]  hd3ss3220_probe+0x118/0x2fc [hd3ss3220]
> [   25.475621]  i2c_device_probe+0x338/0x384

Based on that backtrace, your role switch is not NULL.

You can only end up calling renesas_usb3_role_switch_set() if your
hd3ss3220->role_sw contains a handle to the renesas usb3 role switch.

> Fixes: 5a9a8a4c5058 ("usb: typec: hd3ss3220: hd3ss3220_probe() warn: passing zero to 'PTR_ERR'")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> This issue triggered on RZ/G2E board, where there is no USB3 firmware and it
> returned a null role switch handle.
> 
> v1->v2:
>  * Make it as individual patch
>  * Added Cc tag
> ---
>  drivers/usb/typec/hd3ss3220.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/hd3ss3220.c b/drivers/usb/typec/hd3ss3220.c
> index 2a58185fb14c..c24bbccd14f9 100644
> --- a/drivers/usb/typec/hd3ss3220.c
> +++ b/drivers/usb/typec/hd3ss3220.c
> @@ -186,7 +186,10 @@ static int hd3ss3220_probe(struct i2c_client *client,
>  		hd3ss3220->role_sw = usb_role_switch_get(hd3ss3220->dev);
>  	}
>  
> -	if (IS_ERR(hd3ss3220->role_sw)) {
> +	if (!hd3ss3220->role_sw) {
> +		ret = -ENODEV;
> +		goto err_put_fwnode;
> +	} else if (IS_ERR(hd3ss3220->role_sw)) {
>  		ret = PTR_ERR(hd3ss3220->role_sw);
>  		goto err_put_fwnode;
>  	}

You should not do that.

Either I'm missing something, or this patch is hiding some other
issue.

thanks,

-- 
heikki
