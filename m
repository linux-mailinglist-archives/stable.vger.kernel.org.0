Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52725667387
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjALNum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjALNul (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:50:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332F24731B;
        Thu, 12 Jan 2023 05:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673531439; x=1705067439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Nye+I+Clrq9SBmvHly5ZfjOGJz5IMOrCCli65DwBb60=;
  b=hYIz1FhjDg6vqs8d2troPkzh2bI7tQ0II5c2nGsmpTnjcqXUQSONgFix
   zCVmIMzt3dUXf88giw4XCsKZbVzOndHFiXMs6puA8R/8e6WNf5Doj7e1G
   rsDs59WCsVsSp833ie8vdy6xWIf9WtatYp8U7gSjc4Qe4guH7WsP24709
   Ulyk9PUE4NmyXUpMjGDAyJv+/ZwdatgygX4j2pqtD/kRVTDBQ+gFL1ULT
   pn4cFtrRH8NvLoiWs+K7d13VbiyRkov27xkWZ5E3rHU0Ye+5yq0rBaOhA
   3LNaMlDRzsMrsuB4VXGhtm63UUTqOGT7DLQvDCge4+0uiirHpUlI2Y09h
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="325730058"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="325730058"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 05:50:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="800213443"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="800213443"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Jan 2023 05:50:07 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 12 Jan 2023 15:50:07 +0200
Date:   Thu, 12 Jan 2023 15:50:06 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     cy_huang@richtek.com
Cc:     linux@roeck-us.net, matthias.bgg@gmail.com,
        gregkh@linuxfoundation.org, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] usb: typec: tcpm: Fix altmode re-registration
 causes sysfs create fail
Message-ID: <Y8AQDtBq9j3SmIUu@kuha.fi.intel.com>
References: <1673248790-15794-1-git-send-email-cy_huang@richtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1673248790-15794-1-git-send-email-cy_huang@richtek.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 03:19:50PM +0800, cy_huang@richtek.com wrote:
> From: ChiYuan Huang <cy_huang@richtek.com>
> 
> There's the altmode re-registeration issue after data role
> swap (DR_SWAP).
> 
> Comparing to USBPD 2.0, in USBPD 3.0, it loose the limit that only DFP
> can initiate the VDM command to get partner identity information.
> 
> For a USBPD 3.0 UFP device, it may already get the identity information
> from its port partner before DR_SWAP. If DR_SWAP send or receive at the
> mean time, 'send_discover' flag will be raised again. It causes discover
> identify action restart while entering ready state. And after all
> discover actions are done, the 'tcpm_register_altmodes' will be called.
> If old altmode is not unregistered, this sysfs create fail can be found.
> 
> In 'DR_SWAP_CHANGE_DR' state case, only DFP will unregister altmodes.
> For UFP, the original altmodes keep registered.
> 
> This patch fix the logic that after DR_SWAP, 'tcpm_unregister_altmodes'
> must be called whatever the current data role is.
> 
> Reviewed-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together)
> Reported-by: TommyYl Chen <tommyyl.chen@mediatek.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Since v2:
> - Correct the mail sent from Richtek.
> - Add 'Reviewed-by' tag.
> 
> Hi, Greg:
> 
>   Please check this one. I have strongly requested our MIS to remove the confidential string.
> 
> ChiYuan Huang.
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 904c7b4..59b366b 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -4594,14 +4594,13 @@ static void run_state_machine(struct tcpm_port *port)
>  		tcpm_set_state(port, ready_state(port), 0);
>  		break;
>  	case DR_SWAP_CHANGE_DR:
> -		if (port->data_role == TYPEC_HOST) {
> -			tcpm_unregister_altmodes(port);
> +		tcpm_unregister_altmodes(port);
> +		if (port->data_role == TYPEC_HOST)
>  			tcpm_set_roles(port, true, port->pwr_role,
>  				       TYPEC_DEVICE);
> -		} else {
> +		else
>  			tcpm_set_roles(port, true, port->pwr_role,
>  				       TYPEC_HOST);
> -		}
>  		tcpm_ams_finish(port);
>  		tcpm_set_state(port, ready_state(port), 0);
>  		break;
> -- 
> 2.7.4

-- 
heikki
