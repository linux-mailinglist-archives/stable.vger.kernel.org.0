Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE13246329E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhK3Lop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:44:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhK3Lop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 06:44:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7D9CB81840;
        Tue, 30 Nov 2021 11:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D3C53FC7;
        Tue, 30 Nov 2021 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638272483;
        bh=TjA/LPu+RtGrLqljDfWvEHuS7gLvvmV7WQUiPz4BIdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIU+IT8vbezwQf1G6hd4Of/k/PfbRYsLWtafW76NNYxK0JJZpuNrfmGVuhe2RXiOT
         qS0uXkQIym/19XhAcT2/UinhnlANt71bwS5hcMNGAPiv6FMhFZuGgmluVbdcKqOMsi
         nJ+t+B3M23MHrHr4fSpiQMXa2BelAozJ7Sasti40=
Date:   Tue, 30 Nov 2021 12:41:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Message-ID: <YaYN35NRBTV61qpT@kroah.com>
References: <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 11:38:58AM +0000, Aditya Garg wrote:
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
> ---
> v7 :- Added Tested-by.
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
> +		if ((hdev->commands[38] & 0x80) &&
> +		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {

This line is still not properly formatted.

Please always use scripts/checkpatch.pl to find issues like this.

thanks,

greg k-h
