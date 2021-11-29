Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1AE460FC1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhK2INg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Nov 2021 03:13:36 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:48712 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbhK2ILf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 03:11:35 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 31804CED21;
        Mon, 29 Nov 2021 09:08:17 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1 (16
 inch, 2019)
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
Date:   Mon, 29 Nov 2021 09:08:16 +0100
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EBE48AE4-BCE3-42A6-BA8E-304C789C4667@holtmann.org>
References: <20211001083412.3078-1-redecorating@protonmail.com>
 <YYePw07y2DzEPSBR@kroah.com>
 <70a875d0-7162-d149-dbc1-c2f5e1a8e701@leemhuis.info>
 <20211116090128.17546-1-redecorating@protonmail.com>
 <e75bf933-9b93-89d2-d73f-f85af65093c8@leemhuis.info>
 <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

> Bluetooth on Apple MacBook Pro 16,1 is unable to start due to LE Min/Max Tx Power being queried on startup. Add a DMI based quirk so that it is disabled.

list all the MacBooks that you found problematic right now. We add the
initial as a large batch instead of all individual.

> 
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Tested-by: Aditya Garg <gargaditya08@live.com>
> ---
> drivers/bluetooth/btbcm.c | 20 ++++++++++++++++++++
> 1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> index e4182acee488c5..c1b0ca63880a68 100644
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
> @@ -343,9 +344,23 @@ static struct sk_buff *btbcm_read_usb_product(struct hci_dev *hdev)
> 	return skb;
> }
> 
> +static const struct dmi_system_id disable_broken_read_transmit_power[] = {
> +	{
> +		/* Match for Apple MacBook Pro 16,1 which needs
> +		 * Read LE Min/Max Tx Power to be disabled.
> +		 */

Actually leave the comment out. You are not adding any value that isn’t
already in the variable name or the DMI. It is just repeating the obvious.

> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
> +		},
> +	},
> +	{ }
> +};
> +
> static int btbcm_read_info(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	const struct dmi_system_id *dmi_id;
> 
> 	/* Read Verbose Config Version Info */
> 	skb = btbcm_read_verbose_config(hdev);
> @@ -362,6 +377,11 @@ static int btbcm_read_info(struct hci_dev *hdev)
> 
> 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
> 	kfree_skb(skb);
> +
> +	/* Read DMI and disable broken Read LE Min/Max Tx Power */
> +	dmi_id = dmi_first_match(disable_broken_read_transmit_power);
> +	if (dmi_id)
> +		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);

	if (dmi_first_match(..))
		set_bit(.., &hdev->quirks);

There is really no need to have a variable for this.

Regards

Marcel

