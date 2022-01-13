Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0F48D815
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 13:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiAMMhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 07:37:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58918 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiAMMhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 07:37:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F025C61BE6
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 12:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613A7C36AE3;
        Thu, 13 Jan 2022 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642077430;
        bh=uXMWx4tmL9rR9alX4m10DO5JMAJ6pID/jV5iF9qcpdI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XX7Ne9eRQ4F9F1eSleRERd7/g92auewjvgYngJXiVqUn34QPDqHyP+3G2VP8ha+Gd
         sNA7VclmjyM/+UJqP9pZKOS6PFsUWqSwCq6XJOWEDHycApZMjDVxYM1n/E3dncqHAJ
         R/3Jx1/vZKF5oHhduw3G3E/6OXhA7LgV6oxySEy4=
Date:   Thu, 13 Jan 2022 13:37:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read
 Transmit Power" failed to apply to 5.16-stable tree
Message-ID: <YeAc8u+o6QwaEvue@kroah.com>
References: <164207083324474@kroah.com>
 <C77BF2E3-DB98-4610-99C5-B46A2578585F@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C77BF2E3-DB98-4610-99C5-B46A2578585F@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 11:53:50AM +0000, Aditya Garg wrote:
> 
> 
> > On 13-Jan-2022, at 4:17 PM, gregkh@linuxfoundation.org wrote:
> > 
> > 
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From d2f8114f9574509580a8506d2ef72e7e43d1a5bd Mon Sep 17 00:00:00 2001
> > From: Aditya Garg <gargaditya08@live.com>
> > Date: Thu, 2 Dec 2021 12:41:59 +0000
> > Subject: [PATCH] Bluetooth: add quirk disabling LE Read Transmit Power
> 
> From: Aditya Garg <gargaditya08@live.com>
> 
> Some devices have a bug causing them to not work if they query
> LE tx power on startup. Thus we add a quirk in order to not query it
> and default min/max tx power values to HCI_TX_POWER_INVALID.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
> Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
> Link:
> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  include/net/bluetooth/hci.h | 9 +++++++++
>  net/bluetooth/hci_core.c    | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 63065bc01..383342efc 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -246,6 +246,15 @@ enum {
>  	 * HCI after resume.
>  	 */
>  	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
> +
> +	/*
> +	 * When this quirk is set, LE tx power is not queried on startup
> +	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
> +	 *
> +	 * This quirk can be set before hci_register_dev is called or
> +	 * during the hdev->setup vendor callback.
> +	 */
> +	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
>  };
>  
>  /* HCI device flags */
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 8d33aa648..2cf77d76c 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
>  			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
>  		}
>  
> -		if (hdev->commands[38] & 0x80) {
> +		if ((hdev->commands[38] & 0x80) &&
> +		    !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
>  			/* Read LE Min/Max Tx Power*/
>  			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
>  				    0, NULL);
> -- 
> 2.25.1
> 
> 

Thank you for all of the backports, now queued up!

greg k-h
