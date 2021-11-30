Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFF462EF2
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbhK3I5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhK3I5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 03:57:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E88CC061574;
        Tue, 30 Nov 2021 00:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABEDBCE1831;
        Tue, 30 Nov 2021 08:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B995C53FCD;
        Tue, 30 Nov 2021 08:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638262457;
        bh=KEKlYH2VmtWar206GD1+Dp6Q+cMHF4NKpvs4fvgzIvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ga4ode4d4QSv8vt0ZjyJpiH3EM3plIy1HBIK5plOJI44bwKBMPr10DdgsSv7Jal59
         X2BXkU85AvvjViGlNHlXqkhGDV43WPJF3NKJqpHCO62TJU2xUmD2NhmuLRu7Q982Bp
         6ZfMeyUAvbtsLw4M2BDP2O8WqppSU17TnpIX4rdw=
Date:   Tue, 30 Nov 2021 09:54:15 +0100
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
Subject: Re: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Message-ID: <YaXmt1WJqRy4pOss@kroah.com>
References: <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
 <087A6F82-BC44-41DE-9FE9-05B5932A2911@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <087A6F82-BC44-41DE-9FE9-05B5932A2911@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 08:45:44AM +0000, Aditya Garg wrote:
> 
> 
> > On 29-Nov-2021, at 7:30 PM, Aditya Garg <gargaditya08@live.com> wrote:
> > 
> > From: Aditya Garg <gargaditya08@live.com>
> > 
> > Some Macs with the T2 security chip had Bluetooth not working.
> > To fix it we add DMI based quirks to disable querying of LE Tx power.
> > 
> > Signed-off-by: Aditya Garg <gargaditya08@live.com>
> > Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
> > Link:
> > https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
> > Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
> > ---
> > drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 40 insertions(+)
> > 
> > diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> > index e4182acee488c5..40f7c9c5cf0a5a 100644
> > --- a/drivers/bluetooth/btbcm.c
> > +++ b/drivers/bluetooth/btbcm.c
> > @@ -8,6 +8,7 @@
> > 
> > #include <linux/module.h>
> > #include <linux/firmware.h>
> > +#include <linux/dmi.h>
> > #include <asm/unaligned.h>
> > 
> > #include <net/bluetooth/bluetooth.h>
> > @@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct hci_dev *hdev)
> > 	return skb;
> > }
> > 
> > +static const struct dmi_system_id disable_broken_read_transmit_power[] = {
> > +	{
> > +		 .matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
> > +		},
> > +	},
> > +	{
> > +		 .matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
> > +		},
> > +	},
> > +	{
> > +		 .matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
> > +		},
> > +	},
> > +	{
> > +		 .matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
> > +		},
> > +	},
> > +	{
> > +		 .matches = {
> > +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
> > +		},
> > +	},
> > +	{ }
> > +};
> > +
> > static int btbcm_read_info(struct hci_dev *hdev)
> > {
> > 	struct sk_buff *skb;
> > +	const struct dmi_system_id;
> > 
> > 	/* Read Verbose Config Version Info */
> > 	skb = btbcm_read_verbose_config(hdev);
> > @@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
> > 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
> > 	kfree_skb(skb);
> > 
> > +	/* Read DMI and disable broken Read LE Min/Max Tx Power */
> > +	if (dmi_first_match(disable_broken_read_transmit_power))
> > +		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
> > +
> > 	return 0;
> > }
> > 
> May I know whether this is fine or not.

Please realize that maintainers have lots and lots of patches to review.
If after 2 weeks of no response, it is fine to resend the patch again.

If you wish to help out with the maintainer's review load, please feel
free to review patches on the relevant mailing list to help lighten that
load such that your patch can be reviewed quicker.

thanks,

greg k-h
