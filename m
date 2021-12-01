Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC346480F
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 08:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347307AbhLAH2f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 Dec 2021 02:28:35 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:51138 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347359AbhLAH2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 02:28:31 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9507FCECDD;
        Wed,  1 Dec 2021 08:25:09 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v8 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
Date:   Wed, 1 Dec 2021 08:25:09 +0100
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
Message-Id: <E294B230-4703-4952-8726-8C69617EDF2D@holtmann.org>
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
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
 <312202C7-C7BE-497D-8093-218C68176658@live.com>
 <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
To:     Aditya Garg <gargaditya08@live.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

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
> v8 :- Fix checkpatch error.
> include/net/bluetooth/hci.h | 9 +++++++++
> net/bluetooth/hci_core.c    | 3 ++-
> 2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 63065bc01b766c..383342efcdc464 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -246,6 +246,15 @@ enum {
> 	 * HCI after resume.
> 	 */
> 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
> +
> +	/*
> +	 * When this quirk is set, LE tx power is not queried on startup
> +	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
> +	 *
> +	 * This quirk can be set before hci_register_dev is called or
> +	 * during the hdev->setup vendor callback.
> +	 */
> +	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
> };
> 
> /* HCI device flags */
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 8d33aa64846b1c..434c6878fe9640 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
> 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
> 		}
> 
> -		if (hdev->commands[38] & 0x80) {
> +		if ((hdev->commands[38] & 0x80) &&
> +		    !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
> 			/* Read LE Min/Max Tx Power*/
> 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
> 				    0, NULL);
> 

while patch and indentation look good now, it doesn’t actually apply
cleanly against bluetooth-next tree. So you need to re-spin it.

Regards

Marcel

