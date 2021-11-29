Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F76460F6D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbhK2HiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:38:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbhK2HgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 02:36:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F2EB80E00;
        Mon, 29 Nov 2021 07:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87F5C004E1;
        Mon, 29 Nov 2021 07:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638171176;
        bh=6IiCV9pQTYXa+fmF1zhVvj0DNejN1BX6v/DtjbI/jY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8g7YPcogcxQoHVuQ/6zOzK1VBTawLDfdB7iy8P1GcIf+l3NgmL4PkrxIwHRP7dwV
         PXIw/hGrqchg+nzxnDQG0+rerDJhLpw89Z9d0JNiskO3LN9PYJxUzuVF8Eiwl/AVkq
         5ckb4FVm2EKog988jK4Jo7vbD5tj4q4NXHzU94aY=
Date:   Mon, 29 Nov 2021 08:32:54 +0100
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
Subject: Re: [PATCH 1/6] Bluetooth: add quirk disabling LE Read Transmit Power
Message-ID: <YaSCJg+Xkyx8w2M1@kroah.com>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:22:27AM +0000, Aditya Garg wrote:
> From: Aditya Garg <redecorating@protonmail.com>
> 
> Some devices have a bug causing them to not work if they query LE tx power on startup. Thus we add a quirk in order to not query it and default min/max tx power values to HCI_TX_POWER_INVALID.

Please wrap your changelog text at 72 columns, like your editor asked
you to :)

> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Tested-by: Aditya Garg <gargaditya08@live.com>

Tested-by: is implicit for patches you create yourself, so no need to
add it again :)


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

Did you run checkpatch on this patch?  Please indent properly.

thanks,

greg k-h
