Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A606F69AF95
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBQPdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQPdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:33:35 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD726D26E
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:33:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1Q9I+37tTvlcfmCYK3TSmdA4CuRqyESgbxBM0I1DDAfPDZnBokd9/qTB96MVNqBDviNPO7UP/AhoBMerJJDfr9sfWawT70egfJo55SHyXSsK/5px9l9nvWNnhWvyBedBfXGt4zHXHn/lsKsncgr7p7XxSmLuP9vHjZiEM1aoQ6jy735Gyqwvp0lue1EGwsd2tpvSbFFjUzJ+cF/8ySYzsjPP8jbYGrIIcM2xQgjSEMUxRpwxPIgdzubDu1rMoyV8+o4EGGrqVlOk1VmNvoLxa3Fl7to7cGQfNvbUvclZc+myFkxT+t+3DneBCEMNOTVEcckjTE1V6f/6rviuDX71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFuBML7bv1bkRKDtFEdrXymvjN01OYKYmGECyAcKiRc=;
 b=beviWuZqqhyGc6OU97TtIDGbhQ8rvb+CnduU9/PIYa7CVW/IXpmPlleZCgR5BA04EY2Sjs1W/3dGuNkcZqbknBsxXTIRSL45UmcUTrfLXvhpJ1En/3MiQ2FmPxvkBHreh42P6VbTiATTGXjEdH8DzkJ5L5pmSbY0xYDCXwWkZfkti7elG/OYkEn8ixjkXcgHDP19yTBvhaMjTlKUegAOrqPuUlQ5gs3n5fD6WDN+YTcjDprRNnRAWgAjqj7uTohce5cnL835RSLQOcXSqfeExMkpHPGZitTnXqdHYQWFu7XrohR1iRau4WCMsL9Xb/gpXa/dj4fJifujk4zRAEH16A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFuBML7bv1bkRKDtFEdrXymvjN01OYKYmGECyAcKiRc=;
 b=cciVgxIQfN1CSeqXDBK6+lGVMbksdKetyedSFOE6ipyCdqbkZhMWhbJ26Oy9JtIAxfbIwN0rdgYtlYFlsEjKH9GdPe5KkDY8YB1sTao7HcRV5Ku7toZVTq38xCwwfwKeCtUdxfVwjXw92LmAwVguzby7DiNkEtsGv3DglPuUq8Wblz5f/uJyfaJw2p5vV6qhHb8BKDXvfAD78Hu9g8u6NdW1jKqmnNOXo1EY+oGxZpciH5q6Zf+RbXsSmglki96SeqOD3Ku5I7y9U6iljNPFPfxE+MzR91GIhCklQ1ZJDFumsC+VJ5GVd17Y4isgnX2VYVj5shKINTO45B3VoLzKAA==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 15:33:28 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::5f35:2f2d:94a4:f7c3]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::5f35:2f2d:94a4:f7c3%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 15:33:28 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Khoa Vo <khoav@nvidia.com>, Meriton Tuli <meriton@nvidia.com>,
        Vladimir Sokolovsky <vlad@nvidia.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: RE: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of
 GPIO chip irq members before initialization
Thread-Topic: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of
 GPIO chip irq members before initialization
Thread-Index: AQHZQtk+Nb1tuhsuTEueNJD39NNgCq7TMfQAgAARpvA=
Date:   Fri, 17 Feb 2023 15:33:28 +0000
Message-ID: <CH2PR12MB3895AFD55DBF315028F72CF0D7A19@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20230217140744.20600-1-asmaa@nvidia.com>
 <20230217140744.20600-2-asmaa@nvidia.com> <Y++OlqihvPis7NK4@kroah.com>
In-Reply-To: <Y++OlqihvPis7NK4@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR12MB3895:EE_|DM4PR12MB8498:EE_
x-ms-office365-filtering-correlation-id: 02afac71-a078-4f03-cca8-08db10fc512f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRsNSHzM8wxpqOIhHOx05EQ8UUK9fL6uSRZhkmaZdPK+rPlHyKoKcCW2ePKWMi94LAVslpNfOD+L6zQUnuGoDFsdbeXzAQiujU0XUQyoE1DQkKeJMzGSH6muLdlYRxwlRgt3VdYdtCtVz0cwlbtNjyorwXsKmL4G4495OvcFZZGhHRzx7KkSlWYi1ZdPLsj+PJ8o1yAUTV5QCUDdY2pGbIPDzG9okJ+HLtiT1Hg/i2e45OUtWO7MsXuozAY/SCIz2JEa7tzI/igsVOH3cLBkPrIm4c7xyrhgYN0SXlDJGACT0RuV2y1qnj2N68CPqZgkPTx8vMLAD1xsS8bhWIYaTAPjLvPafDZlkg5jW8AJUGZDfiiFhXSqcqBbWo3kDCf1/DJUICmq4DlzY5zZ34I/+JMBxtjpVhsIEUmQf0BzZ22kfDPJQwZRAtZPImoQwXH/mFbxPJyySsRYRgVCd3q/9JGPRJQrIcpL52MFZ3ZKIS4NEELVwtRnewhbq9dPPDlH9URd2LkS0LXlhWMQ6CpDpfRSTouJCMSnWQaVriu76S7uTxPnVV4JiU1VQh9idruWV5zZBK/whsD4QmVSn2jt7UAcphCHpTlI/cFULOyYUzF9VsHU8nbXt5JQZy58Jo9N13BggrdFZ+TBtdURDfsEyRJPV1YknDMyBscZ1Op7alTr04wbobL7dNYvLY6+dMUfrFVs/s4axMRFx7EK8fA9qsxS7DMkf6RYKVnWPPj7mLatgTJ49DremvshlEOycU5u1rBaYsaASWkfQxCYhaOpGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199018)(6916009)(64756008)(66556008)(66946007)(66446008)(66476007)(76116006)(8676002)(83380400001)(316002)(8936002)(4326008)(52536014)(5660300002)(41300700001)(6506007)(53546011)(186003)(9686003)(478600001)(26005)(54906003)(966005)(71200400001)(7696005)(33656002)(55016003)(38070700005)(86362001)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4JObB2+0UAJ1PeQWsByZivC9dytHrz8gGhPlqmq/Cfs9umJH2WDSWoYkGN/6?=
 =?us-ascii?Q?/S46owjkakBGFOHR2/XhjvP3i9wfW6M66YdUGUefpz5Eoc2Fca2l3Da/1BYD?=
 =?us-ascii?Q?IuAd5SZRsx3pvppBUSt3iXQZh1YDpJftNR6JxEnlzW7JVKUj16u2pIJM0tdK?=
 =?us-ascii?Q?PKdtrSfuNzYMK/M8/qeSZ8eQWtagsrU/k1rJd+nJayQYyJL/WNOda6iHZeKH?=
 =?us-ascii?Q?zn8tn/RDAA3Z0w4Pc908OsyZsvhS1cw7C+dgt/lDkeaciDhyo8OHcyOUUxq5?=
 =?us-ascii?Q?W6enym/j7MEQ8LUPFSLxzVvYqFye+rK/OQeu6i7RQ6ZS44lwxBgHMS9rkbfw?=
 =?us-ascii?Q?B03KxGJAlKkQO7jUzZos+Q9Ug2AbvyIE6oPH+Md+9FC5qpmEzYYw32An5twF?=
 =?us-ascii?Q?8qE2dkaGyCSs0OZugxFtC+uqkMeSppCQAz7QyolRczPFuB28fIV9xn8o4MBe?=
 =?us-ascii?Q?rLOWFcwOgTBETxkaOQW79G1HgWtB+wxYi9CU/ineZnmSOmXtsHvNA/cR+K9W?=
 =?us-ascii?Q?SI/3p3i/5IbiRqNHPxcdvmX3LiyZ/CroBVZGWMc7O6DWxGhLVXnEaGZUldwM?=
 =?us-ascii?Q?Cjz0qGLMhw1p88Mg797VswcKR4hPIi+XSkG6px/HiC2u5vlvb8JZNp7iWzzo?=
 =?us-ascii?Q?XA6Y86xu5eSRloO4czHpDZtkJ6+egmIe9+CBUIZMfMdLIT3oxQFKwHFjPp6J?=
 =?us-ascii?Q?BnINb3djLxeY/WIFO0yF397V6J/EkVmci+J0b7+rdHUKHeCTZNNnkyIYK0RR?=
 =?us-ascii?Q?3SXIS88yomnKiBLc4s2q+2ZYInhPY9vetMmMcryjQDklx0xbbJp9xNpJkAiv?=
 =?us-ascii?Q?WEE5q+8K3a2feM3IQJkICbfIr5QymMNvM574XHN1ffz8Q7FIKB8FdYuR2HfH?=
 =?us-ascii?Q?s+o4ViydVsvDXGnndRjfbYcAoSRm5z4yQwD8ZEy3YKlWS0p5wn1Z7e4EtUI1?=
 =?us-ascii?Q?Vd/RUxp/8GZUzWIxn6e9KHjAkCtei66/d7/gpb+UTKIEra9JL7GSUm2gwya3?=
 =?us-ascii?Q?Z+gseaPxMrwYFNYM1yOIOdTCPG/Pbu0FU/yMaaAYxragWELtpMs+PXPMTEoX?=
 =?us-ascii?Q?M0b6WifVA1Xkb2AK1jL2N3rk7YPcE5PXNcS/OfhTPRzRxSOUTZXzxYotg/i0?=
 =?us-ascii?Q?QUtrs7kKlHcOl9mVPK7949GkWTKCerbDAnwz56V8nf3PurXp9OkcLcXXh2wv?=
 =?us-ascii?Q?6KBA2A2MwmsU9j0q1HGaTRirSTu/cUniRVGgu1Y0qb+iAu66qX7KUhagFSmX?=
 =?us-ascii?Q?qheeA5/Hdc7Dg21jFByw3LY2MZh2ugj3PjWeeBq0UPw6+e4Oeiap2QOD9YMs?=
 =?us-ascii?Q?G3P2E1A1Lh/sbkbiwFXf2u2aAxuVBB6aVgy24FPMqJYXhd4Hxkod8GXFJ8ZX?=
 =?us-ascii?Q?Gt6Ry8SbZSJs+MoZcULO7Vt2DtEiVWKwQTCUIKs5FiUdd5NU+/OFXtGd/k7e?=
 =?us-ascii?Q?+Le/yvXd6PrRfRton06YyGgtdhCUWLM5kL2zF68rPbduic6RAvP5qp5ZcxS3?=
 =?us-ascii?Q?zdJ0Xdqu8bcleoZnzNuWpVlwrUq1JHGmci1Ds1yg8k36wPUDfpaObuHWde3B?=
 =?us-ascii?Q?A0YNiXGiTiHBqM42QBQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02afac71-a078-4f03-cca8-08db10fc512f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 15:33:28.2478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 678+BZvqteFgI5Q5odiaBmvvOnfTfYKJqlezYYFqlSic+AyPFrqPjzXwRWCbMKco0kXn3fHTrXJzW9iTk2JTlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,=20

Apologies, This is not meant for the Linux kernel. You got spammed because =
when I cherry-picked this change for canonical only (kernel-team@lists.ubun=
tu.com), this got added to the patches:
> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl> (backported from=20
> commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320)
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Which caused it to be sent to everyone. =20
Will talk to canonical on how to avoid this in the future.

-----Original Message-----
From: Greg KH <gregkh@linuxfoundation.org>=20
Sent: Friday, February 17, 2023 9:27 AM
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: kernel-team@lists.ubuntu.com; Khoa Vo <khoav@nvidia.com>; Meriton Tuli =
<meriton@nvidia.com>; Vladimir Sokolovsky <vlad@nvidia.com>; Shreeya Patel =
<shreeya.patel@collabora.com>; stable@vger.kernel.org; Andy Shevchenko <and=
y.shevchenko@gmail.com>; Linus Walleij <linus.walleij@linaro.org>; Bartosz =
Golaszewski <brgl@bgdev.pl>
Subject: Re: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of=
 GPIO chip irq members before initialization

On Fri, Feb 17, 2023 at 09:07:43AM -0500, Asmaa Mnebhi wrote:
> BugLink: https://bugs.launchpad.net/bugs/2007581
>=20
> GPIO chip irq members are exposed before they could be completely=20
> initialized and this leads to race conditions.
>=20
> One such issue was observed for the gc->irq.domain variable which was=20
> accessed through the I2C interface in gpiochip_to_irq() before it=20
> could be initialized by gpiochip_add_irqchip(). This resulted in=20
> Kernel NULL pointer dereference.
>=20
> Following are the logs for reference :-
>=20
> kernel: Call Trace:
> kernel:  gpiod_to_irq+0x53/0x70
> kernel:  acpi_dev_gpio_irq_get_by+0x113/0x1f0
> kernel:  i2c_acpi_get_irq+0xc0/0xd0
> kernel:  i2c_device_probe+0x28a/0x2a0
> kernel:  really_probe+0xf2/0x460
> kernel: RIP: 0010:gpiochip_to_irq+0x47/0xc0
>=20
> To avoid such scenarios, restrict usage of GPIO chip irq members=20
> before they are completely initialized.
>=20
> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl> (backported from=20
> commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320)
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>


<formletter>

This is not the correct way to submit patches for inclusion in the stable k=
ernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
