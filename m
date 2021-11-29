Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D5460F9C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhK2HxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:53:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60846 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhK2HvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 02:51:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C688B80D77;
        Mon, 29 Nov 2021 07:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF8C004E1;
        Mon, 29 Nov 2021 07:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638172074;
        bh=kPK1gJMxvTYCVwiHG1lGyKaBQ0tpNH+0ELh1qIRljDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uCWl9wqLt64nU7dBHqAm5WC9ZxLliBmfMMEzq2DP5A6usB0ePrNbohkenq4qVosZ3
         NoVIniDOk60OZapzXchP7TL3QAE2mNR5ZPE5AvCnasNcwbKgMXbNSfI0TVhGWQjyhQ
         XX+oWncCVTXWvAGAKPlyHJJc7tM6lwSVEbk/NWR8=
Date:   Mon, 29 Nov 2021 08:47:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Message-ID: <YaSFp8TpRPjP54nX@kroah.com>
References: <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:42:39AM +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> Some devices have a bug causing them to not work if they query LE tx power on startup. Thus we add a 
> quirk in order to not query it and default min/max tx power values to HCI_TX_POWER_INVALID.
> 
> v2: Wrap the changeling at 72 columns, correct email and remove tested by.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
>  include/net/bluetooth/hci.h | 9 +++++++++
>  net/bluetooth/hci_core.c    | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 63065bc01b766c..383342efcdc464 100644
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
> index 8d33aa64846b1c..434c6878fe9640 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
>  			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
>  		}
>  
> -		if (hdev->commands[38] & 0x80) {
> +		if (hdev->commands[38] & 0x80 &&
> +		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {

You did not fix this formatting?  Why not?

thanks,

greg k-h
