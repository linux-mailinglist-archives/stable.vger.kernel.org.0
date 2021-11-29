Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F10461E34
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378455AbhK2SeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:34:00 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:33263
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1378534AbhK2Sb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 13:31:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlcKXxTRtPZfwhskRk0q0R2WTuKYpWSoQpmvBZi8MVlA/RxqUqOcJ46gfbfWA7OAkbaunagpJY/bx8j6s6aVjnALIglfuOW2Ja2DqVlrOKGyqZIpq9lolqae8ZANT/wMS/kvejhx0hDVJFgFwFt++DjAYUI8akb3P/rC0lTSw6L06oI0WqvoYMNwqbqk5bBwP3lECDWK2uyKIfrTL2eLD37ijj44allkHU80rYqIxXmnrTzVIBsvIIeTOXgKyNY5G9/WocUC9DkriiP8q2CLphJ4j5t93c3aAPdOLFOtJz86LnvK6NiTHTioRcstKYLXjucyU4c88BwztJ0ICdoD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1QWbNZEJndo/2F699mVW+6AO1gdU47FVvPPhAg4jgI=;
 b=f6iHgjlK5BtavvLyVu17zwDOCH10uD1sxrDKRaDPcfFG6Fvg2f9u4pMnYTKIs+/o1oIu+O0qLMJQ9h32558g2me+phm9Hsp9kuwBCC2qghuCZuMxfnN8n1aDLKEFz9KbwYZnuoDKE81SskW4kAU8ugLnGR+SNCz9HyThzKwODhTdcS8MARdDQt6m8nmT9/9KGRp8WP0QAzjYvXbUBrSSx09+xVMPt7ZiLE2zuQtOPwPxzUGnT+257cf3g5zKDVEI5+uNvQvhoyW2jg85D7VT9nMkeJU76XB7Nq3QVrX+eMHDCPWu/+dPpMvBOThJNwjJ7M9sn526StP6rgxCCGkiHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1QWbNZEJndo/2F699mVW+6AO1gdU47FVvPPhAg4jgI=;
 b=jhpncLi2Tyg8XJZEk4Id2k6y/9meAYPCQe9mhekQGh+T5bzGeFiMl2z/RAtDtPDrzrcqNCJBbIAnlV1TnzzTFQs7Bzy53i91w2kQo/ggNSEjRT41ob6s506puXmb68LIrhMMLvWKRi61dy/YMrw3XT/9N02UciaWaapPfZyhJcE=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB2830.namprd12.prod.outlook.com (2603:10b6:805:e0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 18:28:39 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:28:39 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Tuikov, Luben" <Luben.Tuikov@amd.com>
Subject: RE: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check for
 APUs as well
Thread-Topic: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check for
 APUs as well
Thread-Index: AQHX5U6D+k/xYdWsa0Cf1vZhr110Zawa0u2AgAAAL1A=
Date:   Mon, 29 Nov 2021 18:28:39 +0000
Message-ID: <SA0PR12MB4510C0915655DDF82B71959FE2669@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211129182527.26440-1-mario.limonciello@amd.com>
 <20211129182527.26440-2-mario.limonciello@amd.com>
 <BL1PR12MB51447ED7FD5E2F3E33DEC37EF7669@BL1PR12MB5144.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB51447ED7FD5E2F3E33DEC37EF7669@BL1PR12MB5144.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-11-29T18:27:28Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=4903d5a9-50f3-4a25-aad3-1a2a538c663a;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dab0bb2f-8463-458a-af82-08d9b366108f
x-ms-traffictypediagnostic: SN6PR12MB2830:
x-microsoft-antispam-prvs: <SN6PR12MB28300550421F23B09D521CCEE2669@SN6PR12MB2830.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pANsBKC+GQ19zAPN+b6KKICmyczJl88QOTufxVn1SMe2XhNUuJBWhv5ACSe3v9IJ9lpe+s8TP8KOXhwvJ6vssagezDlt8hPYaFarSguH0rSwhRSZ4+PFLr2z1QD/ETYagSH9erTrAzphDuivn83WvepZr6hzeogtEtS8B2HRngCybxhDyFkQt+WfqN1AKV8z1rC3U6+0qF9x7jAP0uUOIoq2OUGXxFLbkf+UclWyoEeZShEXPCV10ggEA6ncrPYXjRGNyyS4p6E/P8RJhVuYjZBlRhrwSLpL5EjpbTA//TB9wt7gfCC5ckLOB93bKf2RHPIxY0JKr6VoglPwixk+Gud6iD2DeUtopWxKYnA6umQKRGrz+DZUMIDa35wZL+Ufewas3uomzibEPm4PjnHxf2r83kOlgca6RShwpYHbGkICfBOk83tuzDE9XSOAdyOz2nOGW6DYEiuczO4hN8eIBr0lQt7cLE3kFxNsnxYpFS+g8KqHyY0fX5PXelPJMexCOrrlM0mf0Cw4IHaUBcT9izplLvTjQ9MM1W6hFDAW9+PL46xp/HKaYFbGz0qfxfZmYZthB/kEf98nTPoNrFpYTI4bJ8Ey+kSpHw5rM7gyZvljxb8BHTxof2vIAGOPTjUG38dNYnWmN9oUJuY0QdHYV4QnpjEM+ZoDAdrWmrTM36Rfe0grYmmJToZRA6ovcGEBt9jFKnR4zW2jsdY/xNYGHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(7696005)(5660300002)(71200400001)(66476007)(86362001)(66946007)(66556008)(66446008)(122000001)(26005)(64756008)(6506007)(2906002)(52536014)(8936002)(38100700002)(4326008)(38070700005)(33656002)(508600001)(55016003)(9686003)(110136005)(316002)(53546011)(76116006)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6lT+a9JU6f6QXzFuomudIoFyxLdx4DL6rqlkT8oP65fAM25mkOrcxYQxSFwb?=
 =?us-ascii?Q?HFbIXZULb0tXk+CMSbq00jWk64mPRdDcur513Qb4DXSMvMOt6eMhLYlAsZSy?=
 =?us-ascii?Q?52oJZ5W8o0qW5fD7L+sM+X3YmDfgxuz8DFJXDTI97jQiYgIUw5UNEeP8zOnt?=
 =?us-ascii?Q?G9wZp4WlSgClflb6LW8vAVM6WSoGw1yk/HaGeH7+r02SWK8MYXHuLGoSPuAc?=
 =?us-ascii?Q?Bnyx3sEa8GYYTMyUGAA7+mXyP2Vs9hBUtMCTGVoQw/XfFQ9UbJ+Er3NN8Iyh?=
 =?us-ascii?Q?FMgHyQqaiPRsRpB4mKtsEWxhqb3Eoc74iSm5m97mXbmBi3q8eJO91U0bUIAA?=
 =?us-ascii?Q?dkfGUn4GGXLV95Su+eehjhjsXTI801PsRJUohR5vHXbJ95RZUeMAV20ByaO+?=
 =?us-ascii?Q?DcMO3nTRmNfBVjQTkM0f/oVspVkolFtney+D4PPFdiVG6vqysII8cxwLRqy7?=
 =?us-ascii?Q?ZvfAeKusv7MG0XW5nR8/rI57J8enU/um53cRwaSM9I5kS1CaLTiYDg+Ef4UR?=
 =?us-ascii?Q?v/SlTyNECDHTeP8+S7H8Uo1LFycbT5Hy5zk2RWSF1KgZpgdB97gJOgZ3nkbe?=
 =?us-ascii?Q?hpSe15t8mDzplwrVUFTGV0dyTJT7dkQMoFRphkpfdKgaRusYOzQGwabc9boe?=
 =?us-ascii?Q?Xu61xwPhZLFtPgO1B5H8FyYEGgyv1ZRXGp5L6Im0tmmBSA/Jfw8douPypTcJ?=
 =?us-ascii?Q?e3XKaDan8cbcvicE2Caz2Y5x94LKksHkXbqnI/1P6mCZ3BK5WPTZNnu6bjl1?=
 =?us-ascii?Q?1H97KKyYgtKa/VVvBW0UhUWwd80mPmZZuOe2+eTvIwQcQiCNfVernPrNRGuM?=
 =?us-ascii?Q?uxa+qUqn+p/xqB9bk/SuJx2FCUVY8/nW4SRpYTBNfPLylCVwO6u/Kn5cdELC?=
 =?us-ascii?Q?oGWOwKI2T758lBRIpDH/n6iG2jNWO+pIITkMx/7eA+hJmfHAw/qTCsa36GDX?=
 =?us-ascii?Q?BrfVYjtAfh7mB5jd1tPYsXPPbOoKsznI+JS9NAlJGPo8tavDa71WBgPpD6Vh?=
 =?us-ascii?Q?I708oaEjIohRA/CJnbvVl/xeGx/EHGBEwFz9UIioNU1vAXgh/lH/1+DsDbiY?=
 =?us-ascii?Q?CWQC7qzaUDm5iDyjOlDjXBxVEGPL8cQ6PenvAS7zcVF+huVA/+YZtZdPqpOI?=
 =?us-ascii?Q?QVIurbbHGgPnN8l8PeN0PzS5zn4L4EyGj8DJd+qvvVAn2b4wWBX0HFu7drgk?=
 =?us-ascii?Q?9BysZlM39xyrS7gk/6Q03FjkiEDpIvpnvQ/tI1WPlkkrdZxxBEN3qHJRIzld?=
 =?us-ascii?Q?RsxwV5Jbq9d1IQm68Fc1C0U5HD1JM1/LetxbLqyntfikOzBoXcnid+4+mJHY?=
 =?us-ascii?Q?ZuhvLyDUXdf6MVRF52GkvoqhXdsoP4sXTSzNf21akSufsEiYp9AZK57OiMcF?=
 =?us-ascii?Q?GN5jMu2WxtPNiD0emTo/gjtqeDQ7J+paXeDfu6MJ1wAG+IMLyA6zSTOkZsNu?=
 =?us-ascii?Q?U7eiTDPBoF2/PQthh2mZo/iUlpacFssD3VVZWChimx/dGT6PHMMip1hCQMaD?=
 =?us-ascii?Q?a/HiizDlWzv9huM9t9yzJKMTYqtF2qe4z764mArpHozepgTkqmnsTuhcgr4g?=
 =?us-ascii?Q?irsFA4Tg6iQZzzuMxg+59iIfVEPDw+NZwG92U7p8c9BeaN2qYr0WJsCYoBsf?=
 =?us-ascii?Q?Pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab0bb2f-8463-458a-af82-08d9b366108f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:28:39.4040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CB6LKTAJxOZEJ5WbTqbZHFuxdVxEtATVt2UZRVb3330RZbzYrsFAfwkjJEGNichulVEn9N0ZuF8/JhvRIydtMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2830
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Deucher, Alexander <Alexander.Deucher@amd.com>
> Sent: Monday, November 29, 2021 12:28
> To: Limonciello, Mario <Mario.Limonciello@amd.com>; stable@vger.kernel.or=
g
> Cc: Tuikov, Luben <Luben.Tuikov@amd.com>
> Subject: RE: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check
> for APUs as well
>=20
> [AMD Official Use Only]
>=20
> > -----Original Message-----
> > From: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Sent: Monday, November 29, 2021 1:25 PM
> > To: stable@vger.kernel.org
> > Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Tuikov, Luben
> > <Luben.Tuikov@amd.com>; Limonciello, Mario
> > <Mario.Limonciello@amd.com>
> > Subject: [PATCH] drm/amdgpu/gfx10: add wraparound gpu counter check
> > for APUs as well
> >
> > From: Alex Deucher <alexander.deucher@amd.com>
> >
> > commit 244ee398855d ("drm/amdgpu/gfx10: add wraparound gpu counter
> > check for APUs as well")
> >
> > Apply the same check we do for dGPUs for APUs as well.
> >
> > Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Mario Limnonciello <mario.limonciello@amd.com>
>=20
> I just send these out earlier today and Greg applied them.  I forgot to c=
c you.

Oh, ok thanks!

>=20
> Alex
>=20
> > ---
> >  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > Modified to take use ASIC IDs rather than IP version checking Please ap=
ply to
> > both 5.14.y and 5.15.y.
> >
> > When applying to 5.14.y this also has a dependency of:
> > commit 5af4438f1e83 ("drm/amdgpu: Read clock counter via MMIO to
> > reduce delay (v5)") If necessary I can send that separately.
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> > b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> > index 16dbe593cba2..970d59a21005 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> > @@ -7729,8 +7729,19 @@ static uint64_t
> > gfx_v10_0_get_gpu_clock_counter(struct amdgpu_device *adev)
> >  	switch (adev->asic_type) {
> >  	case CHIP_VANGOGH:
> >  	case CHIP_YELLOW_CARP:
> > -		clock =3D (uint64_t)RREG32_SOC15(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_LOWER_Vangogh) |
> > -			((uint64_t)RREG32_SOC15(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_UPPER_Vangogh) << 32ULL);
> > +		preempt_disable();
> > +		clock_hi =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
> > +		clock_lo =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
> > +		hi_check =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
> > +		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-
> > bit carry over
> > +		 * roughly every 42 seconds.
> > +		 */
> > +		if (hi_check !=3D clock_hi) {
> > +			clock_lo =3D RREG32_SOC15_NO_KIQ(SMUIO, 0,
> > mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
> > +			clock_hi =3D hi_check;
> > +		}
> > +		preempt_enable();
> > +		clock =3D clock_lo | (clock_hi << 32ULL);
> >  		break;
> >  	default:
> >  		preempt_disable();
> > --
> > 2.25.1
