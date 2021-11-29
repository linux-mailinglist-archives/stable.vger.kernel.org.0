Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7D0461315
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 12:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhK2LIr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Nov 2021 06:08:47 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:50017 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352092AbhK2LGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 06:06:47 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 488ECCED23;
        Mon, 29 Nov 2021 12:03:28 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3 resend 2/2] btbcm: disable read tx power for affected
 Macs with the T2 Security chip
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
Date:   Mon, 29 Nov 2021 12:03:27 +0100
Cc:     Greg KH <gregkh@linuxfoundation.org>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <BEB98DAF-0AEE-4758-A6AC-33F23D11D91A@holtmann.org>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com> <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <A003A45E-EE35-43EC-879F-3395CCB5EF59@live.com>
 <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

> Some Macs with the T2 security chip had Bluetooth not working.
> To fix it we add DMI based quirks to disable querying of LE Tx power.
> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
> 1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> index e4182acee488c5..40f7c9c5cf0a5a 100644
> --- a/drivers/bluetooth/btbcm.c
> +++ b/drivers/bluetooth/btbcm.c
> @@ -8,6 +8,7 @@
> 
> #include <linux/module.h>
> #include <linux/firmware.h>
> +#include <linux/dmi.h>
> #include <asm/unaligned.h>
> 
> #include <net/bluetooth/bluetooth.h>
> @@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct hci_dev *hdev)
> 	return skb;
> }
> 
> +static const struct dmi_system_id disable_broken_read_transmit_power[] = {
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
> +		},
> +	},
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
> +		},
> +	},
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
> +		},
> +	},
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
> +		},
> +	},
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
> +		},
> +	},
> +	{ }
> +};
> +
> static int btbcm_read_info(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	const struct dmi_system_id *dmi_id;

this variable is not needed.

> 
> 	/* Read Verbose Config Version Info */
> 	skb = btbcm_read_verbose_config(hdev);
> @@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
> 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
> 	kfree_skb(skb);
> 
> +	/* Read DMI and disable broken Read LE Min/Max Tx Power */
> +	if (dmi_first_match(disable_broken_read_transmit_power))
> +		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
> +
> 	return 0;
> }

Regards

Marcel

