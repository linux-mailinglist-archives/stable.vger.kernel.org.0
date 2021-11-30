Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD804630FB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhK3Kbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:31:49 -0500
Received: from mail-0201.mail-europe.com ([51.77.79.158]:52740 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbhK3Kbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:31:48 -0500
Date:   Tue, 30 Nov 2021 10:28:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1638268105;
        bh=4CxBkUAhjShO6mhtkiCe234FaKXdEmvGEiGyRqiAttw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=K/+iOcR9yhNWGCqMefwfp1ozhoVP7gVRa350qYOrsqrVM1WEKN0CW+Fklz0ICXfqh
         9eLTBIesdqHipG3Kpg0MVARurDz09KVL1N68ABvUErr01cRXndnAZfEAKLIb5m5y86
         YkYYLLQxWLPxHPbycUhAAUIzQmv1OE8vWN09bR1s=
To:     Aditya Garg <gargaditya08@live.com>
From:   Orlando Chamberlain <redecorating@protonmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Reply-To: Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs with the T2 Security chip
Message-ID: <20211130102812.66cddfec@localhost>
In-Reply-To: <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com> <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org> <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com> <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com> <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com> <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com> <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com> <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Nov 2021 01:00:43 +1100
"Aditya Garg" <gargaditya08@live.com> wrote:
> From: Aditya Garg <gargaditya08@live.com>
>=20
> Some Macs with the T2 security chip had Bluetooth not working.
> To fix it we add DMI based quirks to disable querying of LE Tx power.
>=20
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
> Link:
> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail=
.com
> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
> ---

It's hard to tell what the differences between versions of this patch
are. This spot here after the "---" is often used for a change log
(e.g. "v5->v6: Made change X and change Y"), so it would be useful to
have that if you can add one in future patches. I think someone may have
mentioned this earlier.

>  drivers/bluetooth/btbcm.c | 40
> +++++++++++++++++++++++++++++++++++++++ 1 file changed, 40
> insertions(+)
>=20
> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> index e4182acee488c5..40f7c9c5cf0a5a 100644
> --- a/drivers/bluetooth/btbcm.c
> +++ b/drivers/bluetooth/btbcm.c
> @@ -8,6 +8,7 @@
>=20
>  #include <linux/module.h>
>  #include <linux/firmware.h>
> +#include <linux/dmi.h>
>  #include <asm/unaligned.h>
>=20
>  #include <net/bluetooth/bluetooth.h>
> @@ -343,9 +344,44 @@ static struct sk_buff
> *btbcm_read_usb_product(struct hci_dev *hdev) return skb;
>  }
>=20
> +static const struct dmi_system_id
> disable_broken_read_transmit_power[] =3D {
> +=09{
> +=09=09 .matches =3D {
> +=09=09=09DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +=09=09=09DMI_MATCH(DMI_PRODUCT_NAME,
> "MacBookPro16,1"),
> +=09=09},
> +=09},
> +=09{
> +=09=09 .matches =3D {
> +=09=09=09DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +=09=09=09DMI_MATCH(DMI_PRODUCT_NAME,
> "MacBookPro16,2"),
> +=09=09},
> +=09},
> +=09{
> +=09=09 .matches =3D {
> +=09=09=09DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +=09=09=09DMI_MATCH(DMI_PRODUCT_NAME,
> "MacBookPro16,4"),
> +=09=09},
> +=09},
> +=09{
> +=09=09 .matches =3D {
> +=09=09=09DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +=09=09=09DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
> +=09=09},
> +=09},
> +=09{
> +=09=09 .matches =3D {
> +=09=09=09DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +=09=09=09DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
> +=09=09},
> +=09},
> +=09{ }
> +};
> +
>  static int btbcm_read_info(struct hci_dev *hdev)
>  {
>  =09struct sk_buff *skb;
> +=09const struct dmi_system_id;

This line seems to produce a compiler warning:

drivers/bluetooth/btbcm.c: In function =E2=80=98btbcm_read_info=E2=80=99:
drivers/bluetooth/btbcm.c:384:22: warning: empty declaration with type
qualifier does not redeclare  tag
  384 |         const struct dmi_system_id;
      |                      ^~~~~~~~~~~~~

I think Marcel mentioned this line could be removed.

The two patches make Bluetooth work on my MacBookPro16,1, with and without
that line.

Tested-by: Orlando Chamberlain <redecorating@protonmail.com>

>=20
>  =09/* Read Verbose Config Version Info */
>  =09skb =3D btbcm_read_verbose_config(hdev);
> @@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
>  =09bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
>  =09kfree_skb(skb);
>=20
> +=09/* Read DMI and disable broken Read LE Min/Max Tx Power */
> +=09if (dmi_first_match(disable_broken_read_transmit_power))
> +=09=09set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
> &hdev->quirks); +
>  =09return 0;
>  }
>=20
>=20

--=20

Thanks,

Orlando

