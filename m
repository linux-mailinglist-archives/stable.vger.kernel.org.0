Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD20461FAF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351765AbhK2S6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:58:21 -0500
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:37345
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1379002AbhK2S4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 13:56:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmzPPMrqJ3/Ii2wrfEWyBua96xSxUsYOvfJ6A3BmvGknE+M3cQfNA10pcgIGEvbAgOeKNE8Sbasni43cOe/owqc+gyFHCde5YMI8G/9HoK+LNoLZ6DQeR+a7eVwTKRRHEboPtE6h3NmLzpyVT6hnDnM6H9SFEuOzZNwgz9z9mifH1abyjBcU8vNU9RUwQdOmjWTDO9PgkJKl5TGG+YTa3ERuAlXS5vtAxfce8Gz7PrOn+NrpPmhAhz/GXpbyz6tH513v3n5FEqNdHEIgUac+jn8ahj4XdNP0Q9e6WLrwUGMJtB7CHKj8Vs8d4SZUz8UT41usyWwNEzvXixseY2ix/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yK1BSazNv8py3nKNnmNdUwF19AZ0Y4SEFYNJ2GkMbM=;
 b=oebTPjRMJMW4cOEgDNZ1dQC901/br7KWFyd2HgVFmk1QHSmbFd5GQozlfeYiM2FA0aI3PAI71LJo2K2VJkn+KoD9hLdROHCbDlV1E06JyPhQ2DTRSroEaa9Q2uCt5bdCi0hc1jw2i32MM3+2ENuaSG8Y3fIxPqO5wtPgKXrEvODw/W8iJ3JOhmrLkkQXTfqpPBaUiMQaWLJrU2SCnlBIOqL4FQgZMwU22Wu7Ga+VjbwMCQTQkw98gVQI2J9doaV37FE0pG9DABZWh+eMYVMKaGV4/Xy4V1OwL36iB2Td9OgtJ9Q8jY18qB5OB01bsG12P/JE7osjyiZspBHLKEutlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yK1BSazNv8py3nKNnmNdUwF19AZ0Y4SEFYNJ2GkMbM=;
 b=AYkFdzQjP18nbmObNkON6bXDMb/0T01H/MAXq8HGlZkPRTrbPCXIta7D3591+XdKGM23zRoY57k28FTYdrNlaqO1pH5DRNmuuO/y1ddAXPA+Ak+36x6DIymsbIk505djEpqOmm/rgGZljb3TvmL7Pn/0sTcKwso6oFxBgdNVE1A=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 18:53:01 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:53:01 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Joerie de Gram <j.de.gram@gmail.com>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
 shared with SCI
Thread-Topic: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
 shared with SCI
Thread-Index: AQHX4m4UdZRH6Wi0x0mokfnrOvar9KwamwvwgABEg2A=
Date:   Mon, 29 Nov 2021 18:53:01 +0000
Message-ID: <SA0PR12MB4510FEE100D5555F655C7EA0E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211126023343.442045-1-sashal@kernel.org>
 <20211126023343.442045-10-sashal@kernel.org>
 <SA0PR12MB4510E32F459655B6387A8660E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
In-Reply-To: <SA0PR12MB4510E32F459655B6387A8660E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 461c7c5e-40fd-40cd-dfe0-08d9b36977e1
x-ms-traffictypediagnostic: SN1PR12MB2368:
x-microsoft-antispam-prvs: <SN1PR12MB23686FBE42D149C90D4433A1E2669@SN1PR12MB2368.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YtT7fnqdFJNYFl4oeLyuvKa7GIf2kg7TLGtzU1Km0rBnvjNNVkNxuaBGcN5WVaAKrlFO+39hcGJF2xiftmrPZDbTDEagzWBpMTwZaBs3cfO/f9PvuEn/MWZXK8Ave5tqMC6JNq5jkRUvshlQUUP/7ju4+G40ClZR+E0ncqdkVss5gmh0ldaCpzw4oqQ8nMwhWv0FFGq4006CXpq5tzGszD1zhloQcAJpmDI3+xAZ/BnHx7MZLlt+LMSK88qnqdEHhyQuqlxCPIDo9Q/3XVYeScUihGx8GWBj23qLXbLxqsHu5br/jZmkYlSXFuASKsX7RghsK79kNri7F+bqailOuNkSjLYrKtwBnd1SJmw8SkiPJ22Evr8IhDjqO61xGbQwaBSDZTtpZdwynsKF0YeWwJlZyJZtpKkiyC4CxJxdiJSJ2n0NvtUKmqqzhZ49mFaJtEOEg47hie77rZb4jalsYVez8rd1L3l6qD+79xcZiqOMBycFNLaX3fQq2lqUYl22gUMT5vl8ibdRuoPr8wLIu2f6NmgYDCpVhWO6iljiW0jLNzp9h23v3vZ/2c5udkny3fkr/bful12joqoD9qAnEMgkEl/AlquNpUVpk6l/uRnM0qI5S4C+oXsZcG5D+6MSfW5LVtuQGdjR9I+LFIGw5ikbgd87UZgjsBwA4nJS5knRIMwjx4Mae6jv6eHtiBkByUUby17INqpLBdFFKL4wdKByoonwdbylaSVzigOI8ijnvaQ9O9yxVH65hCyHTki1Lx1xJyzUy1GyUIyALsv+Ojd4YCdPohIyARAHH7VY44sA3ImG4gJbAob4q+vKprXN1DChU9ofKgE91ESJA/jmoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2940100002)(26005)(9686003)(66446008)(110136005)(52536014)(6506007)(53546011)(66556008)(76116006)(2906002)(66946007)(122000001)(54906003)(966005)(38100700002)(64756008)(38070700005)(83380400001)(8676002)(8936002)(33656002)(508600001)(45080400002)(86362001)(4326008)(7696005)(55016003)(66476007)(71200400001)(316002)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kZJm3xRa0ApCCiauIEaSauWRCk3Bj2oWLTmlUgRv7XE2uvdInl+IBMOBCFJw?=
 =?us-ascii?Q?iV89f7PQuGDH966SGm7jzl3FimCHxaHnq1c7J73+oZdgx0Gns1Rra56Dt9A1?=
 =?us-ascii?Q?ToOZinlOEah08iCGSnxyvuKWwlsfMlvRDP/M/bjX3n4iLYsSV9B4I7aHYlWQ?=
 =?us-ascii?Q?/+GsrH4GHfrUJwgIg/yuQnb1fbwZi3vg3D9ov+q8AULeWP4dUUy6SMBJh9Wk?=
 =?us-ascii?Q?HNGioTTEbOwujq5G+pvDPR+FQaVyZR2EZ4fDUotgDvYkeXRXSJeqIik2/jwt?=
 =?us-ascii?Q?YkU/jtpHsx9a6JgDuzFVkjbIJA1iJ6J+0b2Gog4SoVQnhMKy58PUvvI/uzR0?=
 =?us-ascii?Q?j2ooWYfEIQDLf4cebETNh1smnwEUX5lZi3GDBWvdQUSf+oslPTZ0q+0HOGXa?=
 =?us-ascii?Q?hzP4xLh6DrMP9EXUQCS6TtP4AGG0S3i9aILMyLIEEh/JC5Z/FiwxEBcSEz+o?=
 =?us-ascii?Q?KPSW0wbnRGY/gTXFpqvhtUovGZPhtdpda5ijiIIYy1IoWP593Qde9JCqhPLT?=
 =?us-ascii?Q?WgO5WDGrVbjLoBF1h+63W0KYdxwNtf9F2R/3xCp46Vg71N5UJaf9//T39Zgb?=
 =?us-ascii?Q?GheXFMN3IOjD0s/D1qI+KY8tXIicsZER7e/BsAh4iU5j2HH67yyEFQmlD6HL?=
 =?us-ascii?Q?f6OCIEXjI7LGo6qOsJt/m8Ce+h7XwrHUA4ofqSJV7qU4Alfs32nhtbiih833?=
 =?us-ascii?Q?gHXhl6zoF8L2sR1ZLbAqFdMLZ71/d5pWRfkVNgqWVsGbayuiot5JUPXdU7df?=
 =?us-ascii?Q?PtXbtm4hkkcWNODC/8PhDPLIttd9C7rbQbEZQXuVSVHQpuyt5fFO3XxVYSj8?=
 =?us-ascii?Q?Q2hS5d0Ml7Jisu3t+7WXIj5kjHfl9KpRW4t1cdcI1vlbbo/dpEsBvKLVX/+y?=
 =?us-ascii?Q?B6RRzYPtkyX43neEHQ2hOiYOJg9ujjRn9GqeSXXV/X7dufiBBAvdoDZEfNzy?=
 =?us-ascii?Q?fFArWUIOfHGCZ3a8JVAW8I5H/8Rlyjt5kQMxeEX5K7aFRCdprRK8Z0hCnbTW?=
 =?us-ascii?Q?U3ddJkvkxwdb7Q+BRgAxP6GpaZrSVFFlbPOgGCEqNiJZjvlXoq0codSdZn97?=
 =?us-ascii?Q?cvJDnyxbxy240VHWL3ozkCfrYRx7jfus2zsq65wfngLCBc6jxAOeqmkajqUv?=
 =?us-ascii?Q?25+JUd2HK2fM7TZHXOpzxC004hNJkHBHwCKdqd7FsAkDKAf9P59wsjkaVSOE?=
 =?us-ascii?Q?E03QzbEMgsol9OffMTgcfV7uI+M60lzERzP8BhJhr3gbokDIpbjMdeUvHTLo?=
 =?us-ascii?Q?EpidwuPWK3gommsOblO3loYxbNKdUe6BA6dnSBREZmiWHRLTndkisjV7D9hx?=
 =?us-ascii?Q?03mjRwSU9U5CIeTrPl1yQLHe6cD7PVVV9H3XEQD1aD/B1KxODQ3J8lK3bVao?=
 =?us-ascii?Q?JS2rYyxM3/XwManrLxLMr3CuP4knCOJmjEjlf7B57nFywFee0Sy3QO92hAKk?=
 =?us-ascii?Q?ehsOiql8RmWWr1kcEt4qGDddw4xZdQa24hTV9JOwMeRs2x6bKubV9h2GYW59?=
 =?us-ascii?Q?+ppBR2B8xj/reiOnbICJ2YI4MVrw3X+7SbvHFdV8mTi4OXaSzYF0I7aYQpUl?=
 =?us-ascii?Q?6lP0WptQxlbLaPreG3kpkBdMumr8mHeQ4kq+sHzHgMpDuT1Eq/jnR1jt4L0T?=
 =?us-ascii?Q?Pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461c7c5e-40fd-40cd-dfe0-08d9b36977e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:53:01.1913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHUczYsD5I8JzPfzeW7PKB07bMUg4fJVe+Sl7PBjZeG96uO1B8f2Tlm4D9UeRNgodwSwlOGi9IRUNsBys4FFYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Limonciello, Mario
> Sent: Monday, November 29, 2021 08:48
> To: Sasha Levin <sashal@kernel.org>; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Cc: Joerie de Gram <j.de.gram@gmail.com>; Natikar, Basavaraj
> <Basavaraj.Natikar@amd.com>; Linus Walleij <linus.walleij@linaro.org>; S-=
k,
> Shyam-sundar <Shyam-sundar.S-k@amd.com>; linux-gpio@vger.kernel.org
> Subject: RE: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IR=
Q
> is shared with SCI
>=20
>=20
>=20
> > -----Original Message-----
> > From: Sasha Levin <sashal@kernel.org>
> > Sent: Thursday, November 25, 2021 20:33
> > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Joerie de Gram
> > <j.de.gram@gmail.com>; Natikar, Basavaraj
> <Basavaraj.Natikar@amd.com>;
> > Linus Walleij <linus.walleij@linaro.org>; Sasha Levin <sashal@kernel.or=
g>;
> S-
> > k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; linux-
> > gpio@vger.kernel.org
> > Subject: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ
> is
> > shared with SCI
> >
> > From: Mario Limonciello <mario.limonciello@amd.com>
> >
> > [ Upstream commit 2d54067fcd23aae61e23508425ae5b29e973573d ]
> >
> > On some Lenovo AMD Gen2 platforms the IRQ for the SCI and pinctrl
> drivers
> > are shared.  Due to how the s2idle loop handling works, this case needs
> > an extra explicit check whether the interrupt was caused by SCI or by
> > the GPIO controller.
> >
> > To fix this rework the existing IRQ handler function to function as a
> > checker and an IRQ handler depending on the calling arguments.
> >
> > BugLink:
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> > b.freedesktop.org%2Fdrm%2Famd%2F-
> >
> %2Fissues%2F1738&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%
> >
> 7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608e11a82d994
> >
> e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWFpbGZsb3d8
> >
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> >
> D%7C3000&amp;sdata=3DBHHY3gLu2pQIJ1nvSE0VNQOaioTC0QdBM44ze3HXrtk
> > %3D&amp;reserved=3D0
> > Reported-by: Joerie de Gram <j.de.gram@gmail.com>
> > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
> > Link:
> >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> > kernel.org%2Fr%2F20211101014853.6177-2-
> >
> mario.limonciello%40amd.com&amp;data=3D04%7C01%7Cmario.limonciello%4
> >
> 0amd.com%7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608
> >
> e11a82d994e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWF
> >
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
> >
> CI6Mn0%3D%7C3000&amp;sdata=3DzUkTF851CdUmrY1z3YZbYrnVrjHQaVfb1%
> > 2Bg2dx28ZNA%3D&amp;reserved=3D0
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/pinctrl/pinctrl-amd.c | 29 ++++++++++++++++++++++++++---
> >  1 file changed, 26 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-am=
d.c
> > index e20bcc835d6a8..54dfa0244422c 100644
> > --- a/drivers/pinctrl/pinctrl-amd.c
> > +++ b/drivers/pinctrl/pinctrl-amd.c
> > @@ -520,14 +520,14 @@ static struct irq_chip amd_gpio_irqchip =3D {
> >
> >  #define PIN_IRQ_PENDING	(BIT(INTERRUPT_STS_OFF) |
> > BIT(WAKE_STS_OFF))
> >
> > -static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
> > +static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
> >  {
> >  	struct amd_gpio *gpio_dev =3D dev_id;
> >  	struct gpio_chip *gc =3D &gpio_dev->gc;
> > -	irqreturn_t ret =3D IRQ_NONE;
> >  	unsigned int i, irqnr;
> >  	unsigned long flags;
> >  	u32 __iomem *regs;
> > +	bool ret =3D false;
> >  	u32  regval;
> >  	u64 status, mask;
> >
> > @@ -549,6 +549,14 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
> void
> > *dev_id)
> >  		/* Each status bit covers four pins */
> >  		for (i =3D 0; i < 4; i++) {
> >  			regval =3D readl(regs + i);
> > +			/* caused wake on resume context for shared IRQ */
> > +			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
> > +				dev_dbg(&gpio_dev->pdev->dev,
> > +					"Waking due to GPIO %d: 0x%x",
> > +					irqnr + i, regval);
> > +				return true;
> > +			}
> > +
> >  			if (!(regval & PIN_IRQ_PENDING) ||
> >  			    !(regval & BIT(INTERRUPT_MASK_OFF)))
> >  				continue;
> > @@ -574,9 +582,12 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
> void
> > *dev_id)
> >  			}
> >  			writel(regval, regs + i);
> >  			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> > -			ret =3D IRQ_HANDLED;
> > +			ret =3D true;
> >  		}
> >  	}
> > +	/* did not cause wake on resume context for shared IRQ */
> > +	if (irq < 0)
> > +		return false;
> >
> >  	/* Signal EOI to the GPIO unit */
> >  	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> > @@ -588,6 +599,16 @@ static irqreturn_t amd_gpio_irq_handler(int irq,
> void
> > *dev_id)
> >  	return ret;
> >  }
> >
> > +static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
> > +{
> > +	return IRQ_RETVAL(do_amd_gpio_irq_handler(irq, dev_id));
> > +}
> > +
> > +static bool __maybe_unused amd_gpio_check_wake(void *dev_id)
> > +{
> > +	return do_amd_gpio_irq_handler(-1, dev_id);
> > +}
> > +
> >  static int amd_get_groups_count(struct pinctrl_dev *pctldev)
> >  {
> >  	struct amd_gpio *gpio_dev =3D pinctrl_dev_get_drvdata(pctldev);
> > @@ -958,6 +979,7 @@ static int amd_gpio_probe(struct platform_device
> > *pdev)
> >  		goto out2;
> >
> >  	platform_set_drvdata(pdev, gpio_dev);
> > +	acpi_register_wakeup_handler(gpio_dev->irq,
> > amd_gpio_check_wake, gpio_dev);
> >
> >  	dev_dbg(&pdev->dev, "amd gpio driver loaded\n");
> >  	return ret;
> > @@ -975,6 +997,7 @@ static int amd_gpio_remove(struct platform_device
> > *pdev)
> >  	gpio_dev =3D platform_get_drvdata(pdev);
> >
> >  	gpiochip_remove(&gpio_dev->gc);
> > +	acpi_unregister_wakeup_handler(amd_gpio_check_wake,
> > gpio_dev);
> >
> >  	return 0;
> >  }
> > --
> > 2.33.0
>=20
> Sasha,
>=20
> No concerns for me to 5.10, but would you mind also sending this to 5.14.=
y
> and 5.15.y too?  I didn't see it sent up for either.

One more thought on this - please also take this (which wasn't part of auto=
sel)
when this comes back:

e9380df85187 ACPI: Add stubs for wakeup handler functions

That prevents some compile errors in certain configurations.

>=20
> Thanks,
