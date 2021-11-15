Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3DC451A9B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348691AbhKOXkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:40:47 -0500
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:63446
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354962AbhKOXiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 18:38:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUOM+Xbs4zna+o9uYrFbkjh6gho+/4FdJGQA8Wo4830L6rJTssDz+KeAYnbSFPNzHEMwUB0V7GvYHoQVikpWQEFcwChYxijvVN1/zKY1m1jwPwBlK8Q5F8ARINnSWVrr1Wp/2/+rny3XJEiLM/h1fb0lesK5KxEYJJvcbZcKUUjs4CCP2tCLjwwg3aCxJuMeT9XKBUNrHRCvQoioBNw+XKsM9KGEkaOQcYoxEhWYiBoQc4cKEJkNp3ZWmL5WTTM/WV56GoosviQQO/acFrt7icLK57wysOabkTuNspsti6XNObqmMQ427eWPhZ3TG/9Qy5NTfXI6Pi927TxB7tiQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDclQj0GYb9SladLIB+As0Omn1yd6gKG+UC6UdaxcdY=;
 b=ZQRQi9saZKwbG0OJ2irYSpnrdy6BHtXfO0xgMBiEWL3CCFgaZx3yzlmqS4Zeu6nen2hgdu1sMEiCPcMflYLn1iCUXOTLYcFEsyhUvJGY92Ipt5Q2RShLi88FkR5E/T3g+vniUMVzN135O1uSuzxjp09fMIH7LfvcNrbboWPQPLpL4z6ZtLIRlMT1zD3OAwFSNkIj9I5u+QgaTPfDuqrnn4Vz5ptvhm2nx2qw6J3g4xtnpimEkDuVHPhbX9zWdDAWMz6RlPRFz/ivm7J4yxhUnbY13tGU2LM1KJorU4WkpVZ+j0y3soGyk9rtMbW3eFJPVKk8hQNZwDwOsqJ9DcK2PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDclQj0GYb9SladLIB+As0Omn1yd6gKG+UC6UdaxcdY=;
 b=k+aCgHfzGj3siQPAqNDj8FRpHXDhuoIgu86b29DA86cVVyB8G6BLUzW2u8vMcSmTrSHOYlSiGeOupxKOTIQGQsQwXSYGZXM1xrOSZkMbNQ/e/NTHqimeW0z5wSiBd+76d8mLr6zKpCRWoanbZhT7XnMEtaSrPEjD9hfRr0+1GPA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 23:35:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 23:35:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 291/917] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Topic: [PATCH 5.15 291/917] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Index: AQHX2lB2nvRqldDb+EWuObXULPJzYawFPmaA
Date:   Mon, 15 Nov 2021 23:35:47 +0000
Message-ID: <20211115233547.bduho7ej5ft52cmd@skbuf>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165438.632409127@linuxfoundation.org>
In-Reply-To: <20211115165438.632409127@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf22378b-9762-44c9-86d1-08d9a890a709
x-ms-traffictypediagnostic: VE1PR04MB7343:
x-microsoft-antispam-prvs: <VE1PR04MB734323DF8151F19F27412141E0989@VE1PR04MB7343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vkLOpiA4se/dsJEvuiDJ9Li4PPLUkOU/ox+PIyRQokJBI0ggptPXj3AhxdhV5PoM98Anp/hDy35Nl5KFk2rJRoQJmp2C0MciPn7YzSstLOgBkT2vkncC1PKR11uW4LCGaPXzFfR6MJ38Y8c0MF149prO3GVLuqYGxpEbm10mjjSgPIag+AI+rWVKiQLZIcqLJsCLWb0Ym80P0dk/7UmIAomZnuBQUSTYsymwH2DJ7qCychsNAM0KMG0XuAi+TxaKErJBIdfZD6FgNxptV8qmbijH3GuLVKHQDJ/oh9FVAcs/sEQrldR3n0OZHuk8ONSdaeQ40zA/kd3iANyKY1p+3IExZyb0f/rJgwvnBG4PXYhKsiJrmsbJxEhiAm7996dgcSQCk16MzYzN4PgpM4z55F2tESWncInTSG/hKWoj1FwmxqDfM6YJ2A0VGsRB+59DyYtO4b7WZb/M68NrXgdF2Qsg9D2hrf4A5BPjZFIsRud+nPLnqk2v378aNL/qmuojzsyJ5+OY9Yj80tGd6MD1OSOtWlb8Sq1fGzzfWPIIxZh9ntz7j/SbfiYXWEG3Qh0you8O79vq7vQRV8y2+Vtz3N/mP/qQ/VRqyWZGpplesutbxPRYnpcWG3vkY0CITS4uBHEADq8QBSBW7MkOEdYfgbpIMiHRTC+zaUr7O0xObQhxEdhOZsh+inaBBoXLlX0Pt0goqHvjNliAGatMIMkdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66946007)(66556008)(66476007)(38100700002)(66446008)(26005)(44832011)(38070700005)(54906003)(64756008)(33716001)(508600001)(186003)(83380400001)(91956017)(316002)(122000001)(8936002)(4326008)(76116006)(6916009)(5660300002)(86362001)(2906002)(6512007)(8676002)(1076003)(9686003)(71200400001)(6506007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a0JKw3Zmot2/ou8jGv+q/26e+STjWsyvwneykV8Jt89YiItu3tX5j+FIu952?=
 =?us-ascii?Q?UzsJ6hWGSXIu7gqvlvCqSZkLe8mn9luitZ5Oc3m8Rj5SL/rFW3hNc4ZeS73H?=
 =?us-ascii?Q?q9YfAwRDg9EwhTrd7/PUcwfK5FzCBJLJiOCxgjkDPFOiqp8MHL5DtBLXSkvp?=
 =?us-ascii?Q?+tQbOlvGR2KyDJJFMZokl7KHV7lWGMM2phhFZYArGlVuqwG9SyAV5UC2aduh?=
 =?us-ascii?Q?sNGaCRX3yA+45Ma3xNAMIRASUBtxfO91LY6ns4CsqklJQ3Dh9GvCs/TLVTVk?=
 =?us-ascii?Q?ZrRk3PfsDipz6tj6LVhXCcDYOVDImHENwrppCHYgx+rTM7q5kqPDT2tQmrGQ?=
 =?us-ascii?Q?zBLFpUCGUOvX7JUYWF6E8XKHpyZKHJk2dzTl6zhePgJuxqJr0Gi+FOojCAYx?=
 =?us-ascii?Q?JT4QLieD6UnB2r2V+m9CTEaMFyv6mHoKqQ4zIVcSXZ7TIqleImyOtDHP5CJC?=
 =?us-ascii?Q?7NbM/+ASugoHcshGs+h63jXCBRmSb53SMQwM0GmfjC8ODemhG0+pemfMlQhD?=
 =?us-ascii?Q?68897y/aBpAkOUrG8+ouywoRWpqca3y1RpClP9SdQov4+5MfHtdqnZ7dPnqk?=
 =?us-ascii?Q?Mc9wCrEUg7se1zshRySlsIoQRY17HgpXgXnOxqQgYnqCa8IhpM5/6Lq+U1fU?=
 =?us-ascii?Q?BZRnSvXA9R0ihBPPNh+qG8VBb5ietuIeB70rzZsLBv9R4vLl/LScnhyc95CB?=
 =?us-ascii?Q?/FYjJhLjFPBUgzb6UJq94QNM3ufkQTYsDSWh7RTnPnrCYWtZeZR7EJxJpgwP?=
 =?us-ascii?Q?zKrxV0TySiraGkZi5TZyzFrayOGHebynqp0uXuwF7r8uar7w+5lJWKZXp0gt?=
 =?us-ascii?Q?MQep2PWFjCCnhO67VFJB7RkiSkWhiPQvrOIeTtOnlHGpi5EizwH/HK5GDBA5?=
 =?us-ascii?Q?ytBq9eyw/5nd+KbEwxdM+XIhZarJHkn7fDTqr8JzsR1kfP2HMQLZID96mAC6?=
 =?us-ascii?Q?bxaZDsoYsTVrH83oqGk5fgBJM0uTUg5VrPA5IWVEkkgczuXOqUVszQQDtISg?=
 =?us-ascii?Q?UGRiSv9GG3MKxwSNEpwvD7bkDnM9DEsI5Qnh2/gwDRTAiI8puoe8rUV0u7kB?=
 =?us-ascii?Q?xj/fT7YlpKDhuTeSFR/PDSxsWcd98KRBEUBgykUrs14RzPL2nR1u02hA2jH9?=
 =?us-ascii?Q?iEDczWzMuwXV15HXBkowmI1zNWLo6VB/VPS9d0Kq6m0x2PRTQzaMES3w8WUl?=
 =?us-ascii?Q?NeylQY9ARuo9lVZudaq0c80zk+Yuqnn8QSuBMG+DOoMo6X0ApU94nYkc+pwH?=
 =?us-ascii?Q?1bhHFXmORhhcUkm0K//z60tZFHgoytzmb1Y2Zw8gf078JTAQEh6mGYY3nPSC?=
 =?us-ascii?Q?I4xRDJaCCLpzgGUmbks+grQzm2zYVFS85cW5lt50W7w22vadEtbnALp5QkkO?=
 =?us-ascii?Q?brIy+dvRtJE2e1lt4/thrL5Qs/L7IiAGe4DX9yW2Bbt5HXICWCBS7AelYiAB?=
 =?us-ascii?Q?4FcDPTrzEvxpHB+t3fcMOhWhiHWZDpZO3Ina1AxrWcLgoQ/hZe0qTbDvBhgk?=
 =?us-ascii?Q?qEN2N/6MngOWu3cTV3vtpoLowOrg9jg/NgfGHeUvc0TKkxKhYCKEiwhzQjfs?=
 =?us-ascii?Q?WOm4Rhki4ph2iORAgtaOU3Mcr00eYk8Jgzhd1sbsCs5AEFh6orxu7h/SYO9v?=
 =?us-ascii?Q?URiu4A/zfkLdfAhb0l+7nsA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F0B450B6E836F43972C2D8F200E2E14@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf22378b-9762-44c9-86d1-08d9a890a709
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 23:35:47.9363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXKBbX0HHMCRcX0vRylt4wRzCT6UHpzraQ/Os6pH3Gt/tlBdVjIPzaeQ3Cv9fpJUajJH3wNUZufDDKPVjUdDwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 05:56:26PM +0100, Greg Kroah-Hartman wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 49753a75b9a32de4c0393bb8d1e51ea223fda8e4 ]
>=20
> Looking at the code, the GSWIP switch appears to hold bridging service
> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> Hardware access to the PCE table is non-atomic, and is comprised of
> several register reads and writes.
>=20
> These accesses are currently serialized by the rtnl_lock, but DSA is
> changing its driver API and that lock will no longer be held when
> calling ->port_fdb_add() and ->port_fdb_del().
>=20
> So this driver needs to serialize the access to the PCE table using its
> own locking scheme. This patch adds that.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswi=
p.c
> index dbd4486a173ff..1a96df70d1e85 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -276,6 +276,7 @@ struct gswip_priv {
>  	int num_gphy_fw;
>  	struct gswip_gphy_fw *gphy_fw;
>  	u32 port_vlan_filter;
> +	struct mutex pce_table_lock;
>  };
> =20
>  struct gswip_pce_table_entry {
> @@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_=
priv *priv,
>  	u16 addr_mode =3D tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
>  					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
> =20
> +	mutex_lock(&priv->pce_table_lock);
> +
>  	err =3D gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>  				     GSWIP_PCE_TBL_CTRL_BAS);
> -	if (err)
> +	if (err) {
> +		mutex_unlock(&priv->pce_table_lock);
>  		return err;
> +	}
> =20
>  	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
>  	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
> @@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_p=
riv *priv,
> =20
>  	err =3D gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>  				     GSWIP_PCE_TBL_CTRL_BAS);
> -	if (err)
> +	if (err) {
> +		mutex_unlock(&priv->pce_table_lock);
>  		return err;
> +	}
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(tbl->key); i++)
>  		tbl->key[i] =3D gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
> @@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_pr=
iv *priv,
>  	tbl->valid =3D !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
>  	tbl->gmap =3D (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
> =20
> +	mutex_unlock(&priv->pce_table_lock);
> +
>  	return 0;
>  }
> =20
> @@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip=
_priv *priv,
>  	u16 addr_mode =3D tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
>  					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
> =20
> +	mutex_lock(&priv->pce_table_lock);
> +
>  	err =3D gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
>  				     GSWIP_PCE_TBL_CTRL_BAS);
> -	if (err)
> +	if (err) {
> +		mutex_unlock(&priv->pce_table_lock);
>  		return err;
> +	}
> =20
>  	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
>  	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
> @@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_=
priv *priv,
>  	crtl |=3D GSWIP_PCE_TBL_CTRL_BAS;
>  	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
> =20
> -	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
> -				      GSWIP_PCE_TBL_CTRL_BAS);
> +	err =3D gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
> +				     GSWIP_PCE_TBL_CTRL_BAS);
> +
> +	mutex_unlock(&priv->pce_table_lock);
> +
> +	return err;
>  }
> =20
>  /* Add the LAN port into a bridge with the CPU port by
> @@ -2106,6 +2123,7 @@ static int gswip_probe(struct platform_device *pdev=
)
>  	priv->ds->priv =3D priv;
>  	priv->ds->ops =3D priv->hw_info->ops;
>  	priv->dev =3D dev;
> +	mutex_init(&priv->pce_table_lock);
>  	version =3D gswip_switch_r(priv, GSWIP_VERSION);
> =20
>  	np =3D dev->of_node;
> --=20
> 2.33.0
>=20
>=20
>

As discussed on the v5.14 backport, this patch can be dropped.=
