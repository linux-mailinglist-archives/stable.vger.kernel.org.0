Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC069D375
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjBTS4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjBTS4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:56:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1177321A15;
        Mon, 20 Feb 2023 10:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418E260EFD;
        Mon, 20 Feb 2023 18:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED4AC4339E;
        Mon, 20 Feb 2023 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676919285;
        bh=6XmyMRcrfPbQTQhluv+1iDNaqe3Yg3/MNk7J7+Obc3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uAv1sbNVY+WUqAyXDMQz6JsdIMPKuxmowp+cGy3fpXobRyAwLT23KphDk4Q3J1vaT
         p/6yIJ92D7tXn7J0LOKXHSWxcoz5LWkOg9A5VO9Q2maDbETP1eI/c61cnLmEMwxcjO
         jyDqguBityZ5VFzae2bS4087FSIVOrHeQnpWZ6ng=
Date:   Mon, 20 Feb 2023 19:54:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Bach <christian.bach@scs.ch>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        =?utf-8?B?Y3lfaHVhbmco6buD5ZWf5Y6fKQ==?= <cy_huang@richtek.com>
Subject: Re: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Message-ID: <Y/PB87qws1ko77xg@kroah.com>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
 <ZR0P278MB07731B49E8938F98DB2098ABEBA49@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR0P278MB07731B49E8938F98DB2098ABEBA49@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 04:45:32PM +0000, Christian Bach wrote:
> Hello everyone
> 
> We finally found a solution to the problem we had with the PTN5110 Chip and the Kernel Module tcpci that manages this chip in 5.15.xx Kernel. NXP Patched their Kernel a while ago (https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/usb/typec/tcpm/tcpci.c?h=lf-5.15.y&id=2a263f918b25725e0434afa9ff3b83b1bc18ef74) and we reimplemented the NXP patch for the Kernel 5.15.91. I attached my reworked patch below:
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index 5340a3a3a81b..0d715e091b78 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -628,6 +628,9 @@ static int tcpci_init(struct tcpc_dev *tcpc)
>         if (ret < 0)
>                 return ret;
> 
> +       /* Clear fault condition */
> +       regmap_write(tcpci->regmap, TCPC_FAULT_STATUS, 0x80);
> +
>         if (tcpci->controls_vbus)
>                 reg = TCPC_POWER_STATUS_VBUS_PRES;
>         else
> @@ -644,7 +647,8 @@ static int tcpci_init(struct tcpc_dev *tcpc)
> 
>         reg = TCPC_ALERT_TX_SUCCESS | TCPC_ALERT_TX_FAILED |
>                 TCPC_ALERT_TX_DISCARDED | TCPC_ALERT_RX_STATUS |
> -               TCPC_ALERT_RX_HARD_RST | TCPC_ALERT_CC_STATUS;
> +               TCPC_ALERT_RX_HARD_RST | TCPC_ALERT_CC_STATUS |
> +               TCPC_ALERT_V_ALARM_LO | TCPC_ALERT_FAULT;
>         if (tcpci->controls_vbus)
>                 reg |= TCPC_ALERT_POWER_STATUS;
>         /* Enable VSAFE0V status interrupt when detecting VSAFE0V is supported */
> @@ -728,6 +732,13 @@ irqreturn_t tcpci_irq(struct tcpci *tcpci)
>                         tcpm_vbus_change(tcpci->port);
>         }
> 
> +       /* Clear the fault status anyway */
> +       if (status & TCPC_ALERT_FAULT) {
> +               regmap_read(tcpci->regmap, TCPC_FAULT_STATUS, &raw);
> +               regmap_write(tcpci->regmap, TCPC_FAULT_STATUS,
> +                               raw | TCPC_FAULT_STATUS_MASK);
> +       }
> +
>         if (status & TCPC_ALERT_RX_HARD_RST)
>                 tcpm_pd_hard_reset(tcpci->port);
> 
> 
> 
> 
> 
> 
> 

Can you submit this as a real fix so that we can apply it properly?

thanks,

greg k-h
