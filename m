Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82345FFF9
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 16:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhK0PyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 10:54:14 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:8262
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350408AbhK0PwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Nov 2021 10:52:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPyEyZv2GDmn6ZPq7pRuGcMF1PnWwWWy8f7+RBxmiXMxWgzvGiEjt/a8acceu3d7W0Y8kHrberNG4T9jOM28x9G8lf6qs6rG8PNwHwNYh2mRQIZfzgXNH9QSVmMBP0L7ZLJsq+OQ64hG8NiB727AVd/OKFw1lRP32HZJZSc2TZjVgr2Xz8AszwvJMv06nAp2rou6wnd+1Rd35QFAxz8lK4DVLEhtUm1W942g5ghi18C2YXH+6WC3UFyGtG6iuSo4twlEIbrX46gMCHz0UUn5OBuoLjgiPOTM9J2hXRUbWBhWtfasXR2kUOZ+6+PTN47t8WX6VeaooJ+KW5T4HudXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8lR0G+0+Kek7SRuYgsQbAaoJfA/NpfQUwUvjb+gv+0=;
 b=kRYIADf/K8/qCEDWvyw/IX+eVGkOyKR31nT+7+zK5RHpy7IFpHx2GwjVLE8UWKQhP89uyZrRh9fXh2R1lwrrWwrhOwvsdQmZQcxjWb+l+Fza6+t+TB3pcoYnsut16N+EFCCoM6dYhCHt9eX3J2MvUc5mQNlOYUDee0b15AHn8XrMADxGfV1StzE9CarWB6eTnrC/Q0qJsoSGt5V5gB542VChmR8DdQW8sZH8IMQgz+rMKxaYGDdnXQuVewH7MHdopGbVvfP2ibD7XL1DtjRPqA8pHtHnBuh3ZnlFXkN/FlznlTeYMHsBTBWUtycnDR0o4VBzkoTfNnEUS6HePQowyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8lR0G+0+Kek7SRuYgsQbAaoJfA/NpfQUwUvjb+gv+0=;
 b=kPXBwdc4569MGjpgMzU1f7+DpqOoxniNHGjql4OTRuqrzCbWCoEDXug+ENSVfieTH5BYXFVsTdakJozkceqI9NPawi1D1Q0W7JvIcHhUkhoNGK4teOjCZBBobdjq8JCpIz+8YE6Q11Ic42c72B54fc3TVoUSWImH9GXSSrL3DVA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5296.eurprd04.prod.outlook.com (2603:10a6:803:55::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 15:48:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 15:48:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/mm: fix early initialization failure for MMUs
 with no hash table
Thread-Topic: [PATCH] powerpc/mm: fix early initialization failure for MMUs
 with no hash table
Thread-Index: AQHX4zMyTd6jC6dzkE216Yt21RNlsqwXhikA
Date:   Sat, 27 Nov 2021 15:48:55 +0000
Message-ID: <20211127154854.lnu3blrsjm6wfkni@skbuf>
References: <20211127020448.4008507-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211127020448.4008507-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96fecbbc-6409-408a-66e5-08d9b1bd6b63
x-ms-traffictypediagnostic: VI1PR04MB5296:
x-microsoft-antispam-prvs: <VI1PR04MB5296A2A1E5E69DF5EA88B2E7E0649@VI1PR04MB5296.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aw8C5hYF9puVONRdhoYBa2nRErBrCdphYhagXVkvGH6hZuGW6CHfRIs9IUgPm1otggLGYepk0Rm9Vel1e1GSLi1+/d6UGWvJC/KLSzwKhpDv+W2OhvprbUyfofa8dv21HgpRV+U6vgFs8ZIJOTcm6n18S79TBoNcjf+tYAWr/6hyCx8Yc12g8o3hCOabClcDK3pwAkH9aWwLLiNDC1Ma+ehPe4Yz4+h0UWhqZpl5d6kjqmAkE2ZFr9yd6XaToKLRQ/umpzUZ9paQM3NUQuwYf1jtU9Q4ciWamDqu+PQ1WNhtBivDSy0/RC/tIwsQgUzNOTtd370HZUAZG+CiEtbSKqDXiy7K+Xs7l+f86fqQZOHmmzu16zkyJJUxS3Q5mEKfxTxPbM4T4ryo+ZouV5M5gjZtOjjVZee8Jktrzw97Qt8nyUCdjbEwfYG5yd9UHP41rTHDptZwIVUBvvl5HTZbkMGlKP8218v/zcSvkyxB/CTXNwQmRUjUL6zmKknMMo7Cm76UJv8MflbKwhd+sHD17RHllQaiNpolnvjuxz9UUMs+yPHswFtaYmHkfKDtrcMbRvl6ptxy27wBa/aJ1QOSC435JxJzHEPmq7BW3lONWo2aOTazrch9FZfkDAEt9K8wBZqIlaHCzrKQqQu8bPbTLOU96S3j7/BSfDmejRK/FP6aXwldDTvIriJuP8UBvm7Zsioj1Ys03fQj5bM2KUpWcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(1076003)(83380400001)(44832011)(66556008)(316002)(38100700002)(8676002)(2906002)(66446008)(66946007)(9686003)(66476007)(8936002)(38070700005)(508600001)(5660300002)(6486002)(6512007)(54906003)(186003)(71200400001)(122000001)(110136005)(4326008)(76116006)(91956017)(64756008)(26005)(6506007)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WqIjr1W+jvS/G8RQgjsWWzjVN6oF7Wzok0nZjj/1v8O7ClSx7hQIMWYUs1NX?=
 =?us-ascii?Q?V02S7yNmm4/GbbISJRq3kuk4wkSUzT9RZW8FDILdSvwee4amnp9dkjkNwMBv?=
 =?us-ascii?Q?yMAwooJkEVxke8jPNvgUUd/AFX9AxRJBCAsEV75ojizr1a10If+j/TEmGh1F?=
 =?us-ascii?Q?QZQY+s3xtyDDbCvacRZodN2U/aAVwE32+24fD4OJpD8hXDI8QqrriL4+GBn7?=
 =?us-ascii?Q?XKC1q2fS4wUCZXboStrdh7d+lo82VWi9i5+gd7gafwoXxjuuomkPqWhlSbCH?=
 =?us-ascii?Q?B3RLc7YRYydd6g8eObwIhY/iTOZtKjNS0L8XhMhx7biGf7VDxeSCkVT/x7OQ?=
 =?us-ascii?Q?3LvzUMGf+JC2b4OFwkq7WYnuqkyJv8C7OtC9Jj/KJz9zaIJGOGUUIdDfTHEQ?=
 =?us-ascii?Q?QDL/GPB1UNJKHb3UVoj8+Y2LqFRZ3DZZTbQeXO2d2XBr2wOVJneEcBhDqEY3?=
 =?us-ascii?Q?PW+0KvzYbuDsPEeVSJm/m1AzewQNUVG0Wgki3yrqk0lfVNDQyySyscC/kzyH?=
 =?us-ascii?Q?7vRjMgWLNdbKSGRV6lkVy3nEKsSQDeNqp97uys82fyS3c7M6GKY6agl9NGOA?=
 =?us-ascii?Q?tt8XJvfggzZag9eMhVJ6jRb0L4Rt5EjH+ppLnbdGFJHz4lmQUmkgClvOAazC?=
 =?us-ascii?Q?LNOwqprI8nwn8qr6e4TMNL22zLvI9lxzqTwIbq4h1PMkQ2Z5sxZOjeb6kPFZ?=
 =?us-ascii?Q?NSi1tYayYLYZS0lAhedGgDwerJQwgvEvRUp1+efe6l7/XhPeOMKBu0SZfEPS?=
 =?us-ascii?Q?YonOccoApQ3wM+vQ/CcJtesQyWh7qZVIwbMrJnVZDAxu2O8aALM/DP1N5fEj?=
 =?us-ascii?Q?GUDU9FBIvFm908l/iRS6uWgs+aVAvQcteDS70O0RVITbDtFkvVoJfJTN1Ea0?=
 =?us-ascii?Q?d+Zw9fAldDh7NuDTKNMtI+D5Ww+ywAhew5hB3RwkQXhxK2yK9o35VMu6/k4N?=
 =?us-ascii?Q?1Rp3dw0mecUALql7eiA8j3exqatrMmvSG2Y+bZEDt6vb4CC+YzG9GB+FwnGN?=
 =?us-ascii?Q?QwGQXsnj2wx1uuUALaxKn3GEHQvtcuwahZqs8Q9mfnD0JZBuoNpfVQQTz5xw?=
 =?us-ascii?Q?JRKLrtAuHgqEfPavUO7gSxGh1oN0w/N2Na768ZCD8JlvSxXhinle/NFR6Q1M?=
 =?us-ascii?Q?Y09IhT60XQ8uiPVukakGQrxt4DECm5ANN25z5GL178k19k8y+RnSb496vSpO?=
 =?us-ascii?Q?Dps9L2WoLptjlom+2mvUo3NOTO20sDBmSjzkggSUHPXy4mnY0MtkxKLZFDbX?=
 =?us-ascii?Q?PGZw2P07my/CSvvtDnHIHSS99gxd0mh9CG8ddgPIw48houajB7NOnAz1Gp1W?=
 =?us-ascii?Q?7rboRfSEbCkm7/GTcepE2sKqoFjAxJxgWfoMK6fSaX2RfLl4RrPaw+2zA2up?=
 =?us-ascii?Q?faBaB3x2aiNGRhZeRB0bWeSUwnZGngedAq0ENQzSlyWb6f6KdLyH+uXA93Ys?=
 =?us-ascii?Q?+BgSBZPOeIbT5nMlNgI8rIrW+FRrG31DiYZHUnjqw8aCOY1TynWx7CllRT9L?=
 =?us-ascii?Q?CDkQPsYqVGNkhJpWNyj7eHR6l6sNk/6C9Kcz9Nxk/CScjlDj717zpJNxDtkd?=
 =?us-ascii?Q?/IPx2XskLOoZBc4NoxkM6UzIsHVSEFjGszsWu8M2PoSXfLEa/t2REMoIzPvJ?=
 =?us-ascii?Q?5QpaVHvC43pyIEwEAEf3VlI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69EB1757AD0D804CA152119CAE4E3861@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fecbbc-6409-408a-66e5-08d9b1bd6b63
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 15:48:55.7318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ph/124n/+dRsIV6UU4nlD/bU3dFebkA/WlxSp5cba19mVRS+wi067WEPBbip/6FUqGRXzzzVHak2CYFqRAYfEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 27, 2021 at 04:04:48AM +0200, Vladimir Oltean wrote:
> The blamed patch attempted to do a trivial conversion of
> map_mem_in_cams() by adding an extra "bool init" argument, but by
> mistake, changed the way in which two call sites pass the other boolean
> argument, "bool dry_run".
>=20
> As a result, early_init_this_mmu() now calls map_mem_in_cams() with
> dry_run=3Dtrue, and setup_initial_memory_limit() calls with dry_run=3Dfal=
se,
> both of which are unintended changes.
>=20
> This makes the kernel boot process hang here:
>=20
> [    0.045211] e500 family performance monitor hardware support registere=
d
> [    0.051891] rcu: Hierarchical SRCU implementation.
> [    0.057791] smp: Bringing up secondary CPUs ...
>=20
> Issue noticed on a Freescale T1040.
>=20
> Fixes: 52bda69ae8b5 ("powerpc/fsl_booke: Tell map_mem_in_cams() if init i=
s done")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  arch/powerpc/mm/nohash/tlb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/mm/nohash/tlb.c b/arch/powerpc/mm/nohash/tlb.c
> index 89353d4f5604..647bf454a0fa 100644
> --- a/arch/powerpc/mm/nohash/tlb.c
> +++ b/arch/powerpc/mm/nohash/tlb.c
> @@ -645,7 +645,7 @@ static void early_init_this_mmu(void)
> =20
>  		if (map)
>  			linear_map_top =3D map_mem_in_cams(linear_map_top,
> -							 num_cams, true, true);
> +							 num_cams, false, true);
>  	}
>  #endif
> =20
> @@ -766,7 +766,7 @@ void setup_initial_memory_limit(phys_addr_t first_mem=
block_base,
>  		num_cams =3D (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
> =20
>  		linear_sz =3D map_mem_in_cams(first_memblock_size, num_cams,
> -					    false, true);
> +					    true, true);
> =20
>  		ppc64_rma_size =3D min_t(u64, linear_sz, 0x40000000);
>  	} else
> --=20
> 2.25.1
>

This is a duplicate of commit 5b54860943dc ("powerpc/book3e: Fix TLBCAM pre=
set at boot"),
looks like I'm late to the party. That commit unbricks my board, so
please drop this patch.=
