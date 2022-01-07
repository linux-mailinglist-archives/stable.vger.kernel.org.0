Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25460487118
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 04:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbiAGDMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 22:12:49 -0500
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:34529
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345775AbiAGDMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 22:12:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ac+yxe2/EYh8gZCsr9ZeoJ0WBliwU72UcZdY+M1Vap/yo2wI8Hfm2yyOfcYGX0ST2bA7KCd9QIvKCLadbbpyk8AuysZnQ6jffyJZw+Uza7Po6xses/PlEILWHUK4RmJdkoXiEXbEyuRFFI0eJQ20ZtNTE8RaYCS5C84TKXinpLu0sdBZiecgqmLwHmRof3Gwg0hvUd4eG033Za7JAqJHvG4iDGAGfC6htALoxnXTG0/DLNhaP0qrxfJaXZeuuiWXl1Hm8J+LwrjaOKyZ4ql21FZBG7VvGYVZjokDHIr/7WHw5bQumqVGs0SC+uCmS5otjt2M27HqyGAchwdE1Pl2zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoQBVudBqQfp9CmrLvcin6OogL0JAaAzcBIrQWWPoxY=;
 b=afWoA7fbF0y52rsHKP7dnLFHDfQmWI2FH5R3Zbf3ybGTiYgMCK0ObjI4z912JxQsGVT1JdwFZdoiRmOXeXaJzZG35UG8jOrqrSTAsdhM01q4shO/T8MsEeQx/KxJaLfdLqxxACw0g5rT+3JvvRhq6H17zpyLcrdBu5JRPwm3CwJlFD1Ucda8PikDMvGNzDy/YM2bnfh55m2qZDODefC/+oPXqbC9QBPBy7GXYkNGSjLPamffLDbYzgpRRxqCMBm3FkHspC5u+1kxjk40vtwrmqFletrDKx6bdRHeQJvkxRFDWYoeT7lEaFO88RvZGMKahEJPli8oCffT2NbxXBkS9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoQBVudBqQfp9CmrLvcin6OogL0JAaAzcBIrQWWPoxY=;
 b=k+2hcKrzZdVPzLvXI9UZs9n8+qOGs1SgauZyM2GDtko4m96tYfnWhQuoxYdgGAcCrZtv/fDWzl3u6M7pELcfMsv3SeZAaFubKb933qnq61c4O38sq+aEXx023R/1xjdttJWgQKkKp9dXmjQ4N8s9PPshMfUuCmvTDfM4dVaHaGM=
Received: from AS8PR04MB8676.eurprd04.prod.outlook.com (2603:10a6:20b:42b::10)
 by AS1PR04MB9239.eurprd04.prod.outlook.com (2603:10a6:20b:4c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:12:46 +0000
Received: from AS8PR04MB8676.eurprd04.prod.outlook.com
 ([fe80::949e:59fd:6098:6508]) by AS8PR04MB8676.eurprd04.prod.outlook.com
 ([fe80::949e:59fd:6098:6508%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:12:46 +0000
From:   Hongxing Zhu <hongxing.zhu@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
CC:     "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] PCI: imx6: Allow to probe when dw_pcie_wait_for_link()
 fails
Thread-Topic: [PATCH v2] PCI: imx6: Allow to probe when
 dw_pcie_wait_for_link() fails
Thread-Index: AQHYAulUqoU5yzekykaKibo8D4S/taxW4CRg
Date:   Fri, 7 Jan 2022 03:12:45 +0000
Message-ID: <AS8PR04MB8676540C48042F8E71D45E098C4D9@AS8PR04MB8676.eurprd04.prod.outlook.com>
References: <20220106103645.2790803-1-festevam@gmail.com>
In-Reply-To: <20220106103645.2790803-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01c89b4d-a5cf-42bb-d16e-08d9d18b93dd
x-ms-traffictypediagnostic: AS1PR04MB9239:EE_
x-microsoft-antispam-prvs: <AS1PR04MB923969CD7B3D4377013A55E28C4D9@AS1PR04MB9239.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XD20R+6mG3RRFQRPnhACHCuL6o84NSCDnPeMS0+yuUeyjkEdSQxVLVAt9NAm6z4QIFpphfv3xFoz83TRp3MeVGzz22J7km97YrYWVMUBseEysAUMtfRjzbw1gmS87A6DeM+JU/Uk8pQ22VAd8j5g7GhNyTF6sakywoamcVz5WkWZcGjW3UoACHEDoLQkIAcKfQM8OyGWAlSA07JphQDa42Zw9zEzoaJgdutmyMnxDAJ2vf8ysEAMug5qCvr0lxhPJN9eswS1iVXfQhZUIck1viwxGlU97Dzd0WPBYKtPux/9suoixcXxTyAMyZZmrYw3M7dT6igc5MC1GpHemaKd5Rpg+C8YRWGKgEaKmZocDMpLcS7qvjthdUQaViBaUUkIlgSLL1iJdm/5OwQukCTj0duVUZx2WziKSJYV4roToolszTNGKYdhtml36ezmSP2YzWV088qzEZPiyu+6OiXXjtPwrfdo7L5M0Z7wmu+FE6hi+aqdlw/e5IAdq09i0g0Q/RAngWd1zS1q1nKoEZ4ismR7ro93Na8wlYZbzIISZqv/DhJ7vvxL5KjhYaX2eB0oC0T736m99aNhPY0qu+5E8BRhbB16+KaK7KY0b6Wly4XDrkgC5W/kTN77KInQYiJZP6GZKek3a5pQGaa4VVSva5CQHWtthwdyrETHKaSJ7AMFrsiRMjx77ONI1qD7Ii0aIxzEhReHvNMSo+br4gNPTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8676.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(44832011)(54906003)(110136005)(5660300002)(33656002)(76116006)(26005)(8676002)(186003)(38100700002)(8936002)(55016003)(38070700005)(66446008)(71200400001)(64756008)(45080400002)(86362001)(9686003)(66946007)(53546011)(508600001)(6506007)(316002)(83380400001)(52536014)(2906002)(66556008)(66476007)(7696005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RT3GGfCDCtdKy7Gh9kYfuR4WQ2JKa/PQPUH9krsKijg1qnnAnat495ew/tim?=
 =?us-ascii?Q?29fVNnXAoUUX80IMRZfNELLmfEO4phyk1ksfC0sWXJOER1xNC2g05Bse/U0W?=
 =?us-ascii?Q?dkjgfil/kf6JhKVzDieuYfn0XK4lbP5QACv42ThPxfFO1UDUr2o9/pwC0Det?=
 =?us-ascii?Q?MfcaHm8A8OiE1LPC1PJdC3SKgrw/rwIEiodlIKJsE06hbg3lkjwvl+TvBdqJ?=
 =?us-ascii?Q?Ek5uA5W2KiTreA8BqmCO7R69HP7CfLv6m6qdlnvUuFSBUJBkmoAzA4MNZTNG?=
 =?us-ascii?Q?6XFn+l5bVraHE4hotmSGaSaHnSer4Zg3sKWYwth/6VMsaMvRPSJsCj1EcTkz?=
 =?us-ascii?Q?ycBA7JMKNR8I50JCivFEUOUno8o0AswtwHh7LPXT7o6wkjwmjA5Kk9yRUZfB?=
 =?us-ascii?Q?L0R6tjJhh/u0FNQOV8w7muEaqHUq7obEbJpiHSdUofOZ+8B7FDlvWG1VXSq2?=
 =?us-ascii?Q?QIL5kiiLj0RZ4mT7hEAng73HsDiWrW7NERjAIeQwTu3W0+Bmg5+t+B805v6j?=
 =?us-ascii?Q?MBCJwbsSnT1Qxq+NmB3dtZDL2SogJZu6aOSpmPhUahxmGUFOYcl4bOP2nD+V?=
 =?us-ascii?Q?IImfdkoyQhi574KUwwSmaBu+4kEHfFf0rVeGvTOHGpGTbjWrJuOVnoRdznt9?=
 =?us-ascii?Q?qgxjdTGH4KuDsOl9urOgNQICdxNy2cVXkkQb5w00F1gE69gVksHzvM6hMP1a?=
 =?us-ascii?Q?+Dk8mTBxChopIlAhK3+mJ0KVb0UKq6Xp96+mWd1gomnpUIU6NS/ZwQK+APfS?=
 =?us-ascii?Q?myUXFg6/rsrta3y5x0V0k2YRIReVxObqoVy+lR7uwBAF+oTzik9nzHzZE0nw?=
 =?us-ascii?Q?J5j4D1mfJR9ApthNTifRYDm24FzHwV02zITDwYSDBoIX6+uSJjMsfI8z9vWv?=
 =?us-ascii?Q?wnSxaJreneTB+N8uBrvmXiQbGcrngf7DsF6XqInnoKseBXwTnkiZXbf+HWaO?=
 =?us-ascii?Q?PnCKQVN4hABnR5FDJNvm4kuD7WyWHX11pgS64mcy3elWZDheQMt3HoE7j4ps?=
 =?us-ascii?Q?cMcZek8cu3YmVfj9nfweMTKXQGegAmq691vRfw9U7UN0uGXp1NeSC9giym22?=
 =?us-ascii?Q?gnsOYSi7QwJh/Ow0ghQEW5utBxb7tDrlV8gk7jLUmQUQS/ncTwXDZ912+8/l?=
 =?us-ascii?Q?2d5jXSeGDCz1XZiC8dZ8cOMAYlVe5B4DskE5d/7DbVQnrxxX7QKYx3RXFvXF?=
 =?us-ascii?Q?+fyJhNbeMA4D5oVeK8vSiP/0mYnDXUxjEPCz3lEykqWUM+wz4Nv82ITheIg9?=
 =?us-ascii?Q?Zmvcj0nRQ/h1Cj4hgX6hx5Wk4phjwu3sBGfJL39Zr72trYk94qarBdZSjipT?=
 =?us-ascii?Q?xIXW+BHHEPS+lXl6ILpc1bvSMCcxq8WvVFvaki9GPqdJ1Y2jxuCVjhJwKDmK?=
 =?us-ascii?Q?iunCd+Q+Z3D7O9sW2AHd9X7q3K0K+Zal4uMKc7DV6Y5solzS9RFuOvkj0WZW?=
 =?us-ascii?Q?FoKF59pOuX0RpQTBPzomrEs+o3XNBE3t0fRLDTpBKYwPXQROtiCkytDI8m7A?=
 =?us-ascii?Q?CsAwAC2jSfXD1Qb58F0k2bPE0X78y/ab7j9TN/QQRNFqVyRF440hnzxNKxWD?=
 =?us-ascii?Q?tLbjJZQD0Wj6qvIpdJsTIYi9qeemyUvwZZoie6ug1sUxnigHSL0Aiwf+tGg/?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8676.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c89b4d-a5cf-42bb-d16e-08d9d18b93dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 03:12:46.0145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H64X934KJdgwISkEsmU2lI/V9Kd6ypxDpnmcBbA3X/AJjUPqaZDGGWP7dditzcMUfgzradUd11AmJlJjsA/1rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9239
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Thursday, January 6, 2022 6:37 PM
> To: bhelgaas@google.com
> Cc: lorenzo.pieralisi@arm.com; robh@kernel.org;
> l.stach@pengutronix.de; Hongxing Zhu <hongxing.zhu@nxp.com>;
> linux-pci@vger.kernel.org; Fabio Estevam <festevam@gmail.com>;
> stable@vger.kernel.org
> Subject: [PATCH v2] PCI: imx6: Allow to probe when
> dw_pcie_wait_for_link() fails
>=20
> The intention of commit 886a9c134755 ("PCI: dwc: Move link handling
> into common code") was to standardize the behavior of link down as
> explained in its commit log:
>=20
> "The behavior for a link down was inconsistent as some drivers would fail
> probe in that case while others succeed. Let's standardize this to succee=
d
> as there are usecases where devices (and the link) appear later even
> without hotplug. For example, a reconfigured FPGA device."
>=20
> The pci-imx6 still fails to probe when the link is not present, which cau=
ses
> the following warning:
>=20
> imx6q-pcie 8ffc000.pcie: Phy link never came up
> imx6q-pcie: probe of 8ffc000.pcie failed with error -110 ------------[ cu=
t
> here ]------------
> WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257
> _regulator_put.part.0+0x1b8/0x1dc Modules linked in:
> CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103
> #1 Hardware name: Freescale i.MX6 SoloX (Device Tree)
> Workqueue: events_unbound async_run_entry_fn [<c0111730>]
> (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
> [<c010bb74>] (show_stack) from [<c0f90290>]
> (dump_stack_lvl+0x58/0x70) [<c0f90290>] (dump_stack_lvl) from
> [<c012631c>] (__warn+0xd4/0x154) [<c012631c>] (__warn) from
> [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8) [<c0f87b00>]
> (warn_slowpath_fmt) from [<c076b4bc>]
> (_regulator_put.part.0+0x1b8/0x1dc)
> [<c076b4bc>] (_regulator_put.part.0) from [<c076b574>]
> (regulator_put+0x2c/0x3c) [<c076b574>] (regulator_put) from
> [<c08c3740>] (release_nodes+0x50/0x178)
>=20
> Fix this problem by ignoring the dw_pcie_wait_for_link() error like it is
> done on the other dwc drivers.
>=20
> Tested on imx6sx-sdb and imx6q-sabresd boards.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
[Richard Zhu] Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Thanks.

Best Regards
Richard Zhu
> ---
> Changes since v1:
> - Remove the printk timestamp from the kernel warning log (Richard).
>=20
>  drivers/pci/controller/dwc/pci-imx6.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/pci/controller/dwc/pci-imx6.c
> b/drivers/pci/controller/dwc/pci-imx6.c
> index 2ac081510632..5e8a03061b31 100644
> --- a/drivers/pci/controller/dwc/pci-imx6.c
> +++ b/drivers/pci/controller/dwc/pci-imx6.c
> @@ -807,9 +807,7 @@ static int imx6_pcie_start_link(struct dw_pcie
> *pci)
>  	/* Start LTSSM. */
>  	imx6_pcie_ltssm_enable(dev);
>=20
> -	ret =3D dw_pcie_wait_for_link(pci);
> -	if (ret)
> -		goto err_reset_phy;
> +	dw_pcie_wait_for_link(pci);
>=20
>  	if (pci->link_gen =3D=3D 2) {
>  		/* Allow Gen2 mode after the link is up. */ @@ -845,11 +843,7
> @@ static int imx6_pcie_start_link(struct dw_pcie *pci)
>  		}
>=20
>  		/* Make sure link training is finished as well! */
> -		ret =3D dw_pcie_wait_for_link(pci);
> -		if (ret) {
> -			dev_err(dev, "Failed to bring link up!\n");
> -			goto err_reset_phy;
> -		}
> +		dw_pcie_wait_for_link(pci);
>  	} else {
>  		dev_info(dev, "Link: Gen2 disabled\n");
>  	}
> --
> 2.25.1

