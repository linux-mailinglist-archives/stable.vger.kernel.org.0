Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA07668877
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 01:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjAMAdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 19:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbjAMAdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 19:33:39 -0500
Received: from mg.richtek.com (mg.richtek.com [220.130.44.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A31E061448;
        Thu, 12 Jan 2023 16:33:32 -0800 (PST)
X-MailGates: (flag:4,DYNAMIC,BADHELO,RELAY,NOHOST:PASS)(compute_score:DE
        LIVER,40,3)
Received: from 192.168.10.46
        by mg.richtek.com with MailGates ESMTP Server V5.0(16491:0:AUTH_RELAY)
        (envelope-from <cy_huang@richtek.com>); Fri, 13 Jan 2023 08:33:08 +0800 (CST)
Received: from ex4.rt.l (192.168.10.47) by ex3.rt.l (192.168.10.46) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Fri, 13 Jan
 2023 08:33:08 +0800
Received: from linuxcarl2.richtek.com (192.168.10.154) by ex4.rt.l
 (192.168.10.45) with Microsoft SMTP Server id 15.2.1118.20 via Frontend
 Transport; Fri, 13 Jan 2023 08:33:08 +0800
Date:   Fri, 13 Jan 2023 08:33:07 +0800
From:   ChiYuan Huang <cy_huang@richtek.com>
To:     <linux@roeck-us.net>, <heikki.krogerus@linux.intel.com>,
        <matthias.bgg@gmail.com>
CC:     <gregkh@linuxfoundation.org>, <gene_chen@richtek.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] usb: typec: tcpm: Fix altmode re-registration
 causes sysfs create fail
Message-ID: <20230113003307.GA4232@linuxcarl2.richtek.com>
References: <1673248790-15794-1-git-send-email-cy_huang@richtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1673248790-15794-1-git-send-email-cy_huang@richtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
> ---
> Since v2:
> - Correct the mail sent from Richtek.
> - Add 'Reviewed-by' tag.
>

Sorry, it seems I focus on the email testing and forget to attach the issue
log in the v2 patch appendix.

If anyone check this issue. Please refer to the v1 patch link.
https://lore.kernel.org/lkml/1671096096-20307-1-git-send-email-u0084500@gmail.com/
Inside this, the issue log show how it happened.

This can help better analyze this issue. 

ChiYuan Huang.
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
> 
