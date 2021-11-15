Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480DC451AAC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbhKOXl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:41:27 -0500
Received: from mail-eopbgr00046.outbound.protection.outlook.com ([40.107.0.46]:35399
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345333AbhKOXjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 18:39:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBDjGBC3ZQ4yg+xqT52VyW69P9y/AXwOq/Xcp/8q2WTp5a274C+awve45xgcA4TU1R9V8I5aWdTmuv2P8DA3QSGtabSqoLaIjoWuPbBakatpb1UY8fQKB+8h0QNdMDWYZWFVL/XGoFNnyfa0gpf4kTecowxUvWQagoSYkb/DUfTN/HNbhEgOHh7Oa+rJquZvMUbaorAnBa7YD/up69xtFt7eRC6rPvOklv+ZbCpG+MlgMbTWQq3X2i63zWzx1Pcq6ZRR1cYnh3Pq0qdWP5dOskpYVx6BsoiwAzafGmjurCdEqRrRY4bc3tz2N7nVURlIqFLHv9tYwDYAXdZMSZsORQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPvIC9Xbnf6yUY3qEedTcAEDNNFDLfjWYpaK+C7ZGIM=;
 b=Spo5PdYDwhrKQz9VR1yM3xOJ3LeRLjZ3MeL5aVInV/33qJcURqosfXk2ZU23COygAayePfi+ipBouBbq2BPmE7iquf5WJD7hPkwBW3kuqivqkX4/3ExmUvyrErPSWP0qWIgUnFGUPx2JcAiHcA7sjbYTOdOxCdCMjG8PqgwH4+rGYaNvid5a2NJWgr8dkPKt0YH4ZfCBSR+DugSgbf1S6xTs0jRDZbdRqa9DWcnQG0QerCVbmZuFFT++1ja8ZQ9bXiZPr2o5nd9IV+KiFAifah1rjc/mRStgRNXZ1c3RKmA82TeEC38Hd0sH1A52fSLw4mIWiEGME9OxeW1YaojEgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPvIC9Xbnf6yUY3qEedTcAEDNNFDLfjWYpaK+C7ZGIM=;
 b=IZQi7r8DWbR7DtBB4ZtxMMg9CLMl3DQOk4qiiex+zBBLw9bUrnGgYQt9AU0k1NaQSac0OxDadZi/dQSjjVIHbUH8/Q+W8Ffbt4TMThwLXoUwOAZ0d8uhmvLvpXA1V9osfAw9MfBnu1JEPYMvydnAn4vOxSzHJfnue1c9rGyLFtk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 23:36:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 23:36:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 169/355] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Topic: [PATCH 5.4 169/355] net: dsa: lantiq_gswip: serialize access to
 the PCE table
Thread-Index: AQHX2kSnOkmxsoPWP0Cc60mbFnJbHqwFPqgA
Date:   Mon, 15 Nov 2021 23:36:23 +0000
Message-ID: <20211115233622.qdsnq72hlusszzxr@skbuf>
References: <20211115165313.549179499@linuxfoundation.org>
 <20211115165319.255917034@linuxfoundation.org>
In-Reply-To: <20211115165319.255917034@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 960af84b-518e-4070-b023-08d9a890bc0a
x-ms-traffictypediagnostic: VI1PR04MB5696:
x-microsoft-antispam-prvs: <VI1PR04MB569632AB73831C5CEB958D35E0989@VI1PR04MB5696.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5TejrGSgJ0VsSZfa0KKMj2Jo/aflBzJavP2oltTx9TKOZZa3CAtj0imMGEn9flhKNBjP2xmC/QDZ0SleIBOICsEg9T1Q+g8lwjz85LNxcFkMFzjDNMS7LlfjgOKa3WUfiu64Y4Vn008ITASomTgzOlzwOTKVLdQ2VY5jXOcUeCAjbRXVgUiRK5njBp0yVj1LpHbItWoI2LHJ9ez3Xgu8j/M+WGekrnt82O5QKvHslprctHLDA1XNbhPIGkj2yyZmBowOZ71xZgTS4zHtTXOofIFc/6y8REODcWUq+/uFDF0bAD9uWK8BKxtADjqMpT3uQkIKMDLWHeOkXFA6V18Nq6Lb/oPz1nZAarnD7G/eVy6pmNXJowPFN/GOuMozabY6JgGc3jr1cMc04YE9qpavJhyaoWlGMso0oWumW3Qz6CpT83ZlPqihnmJmr4vJewrNcxBJTUg178AHQS9ymllGQKDykGG+B3tDB8hWwbWlI4R5pIz0H9ErkWAl6ht27lpFd2qstZh5FG42ASTzV/uKNPNT86ZBBEV/f5zaT9jUBPENddqXnqMjtP7EAvJJWLwlGvmxuQTw3YnOuEb3RjCLD0Kg27PhisTrJHzomekp2D5pLuAR5KHooYlxzxuZfWkNEhY5BmL0txsxQ0sfWAUb8Odtsd/Sww+JEbLI6D3qoah4Vu1tdWgQx9YlqttK2F2tZkT39Gk6zeY+523LbFo3zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(54906003)(186003)(66946007)(66476007)(66556008)(91956017)(26005)(66446008)(64756008)(33716001)(76116006)(9686003)(6512007)(38070700005)(508600001)(44832011)(8936002)(5660300002)(8676002)(71200400001)(2906002)(86362001)(1076003)(6506007)(6916009)(122000001)(6486002)(83380400001)(38100700002)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s9TZhN7X+WEC3Gf08uCgoPM9cFvaZNfIq2W7j9XUo4TLHvqC5LLQiGOeXY1a?=
 =?us-ascii?Q?tfXnsRAgQPada3eXP9hLv6HIyImpHvWALASLJUXS+4LSjJUTiD8euYR8SmO+?=
 =?us-ascii?Q?wsVe8G1KT8E51TigK4evaZwpSkdNZ1dK+4HpSH9bzQL/ofxoZPQ+yGIT+1Vr?=
 =?us-ascii?Q?Wt9MQVqqcDSYtiRILR0Sg1INra87weN03VPvQB2QmGOwR8lm8dMi4ieVNeOA?=
 =?us-ascii?Q?eYKFHMAItF5jZ2KIgOsdr+VCSOomJMS76TJWTA5LjKDeLryoOMMlHJ9htiPw?=
 =?us-ascii?Q?F2h0usxNNhpbb5ae7K5RM/2Z8hZPHr0cpr0KjxxtuYOaZwA+Oo1OQW7jDDWx?=
 =?us-ascii?Q?8jLGHlgK1I4qtZRmQtxJlEb7obsU1Nk3AWITkrXavqi33mHcZ/dhHYX1XHHA?=
 =?us-ascii?Q?VqOM+lLdJLIYYv70ein+4tPMJorCwM8QkmLcHH6yA5ta9Xz9CImxOO1FabXm?=
 =?us-ascii?Q?zPyDP2rT6QdnZc85oHhLkI51fKEQnXarKCyS18jqgoBLtn54myZQX6+evzUG?=
 =?us-ascii?Q?MRFHEh0sE1ZHiUFo5j0Vvl2sterbRWGsnX2tNuhn4xOeWiKEB140/1K1N6pn?=
 =?us-ascii?Q?QXuYZZhrfSfIZxp3Ka5yDC2E1336naEVafCpjCo2x5yOdA5QcXN2GLWLdfOg?=
 =?us-ascii?Q?bctE+lxoimFDK8Td5KwoqpIuDetRrbsMqauWKIXgMOl+s9ZyJFhzweUwZ71O?=
 =?us-ascii?Q?3XNCLWfhyt+I7oVWS39xZuaSVPysmHKM8gSV+wdqEdxZY3srGTRhHMr7X/hr?=
 =?us-ascii?Q?/RBiP+8MuN3MjbkFjB0swyGAQAMUdoOpc3+GEAUYk3lzS94DgwXzmTvaSIxo?=
 =?us-ascii?Q?OVF3QxBc8YsH5FNLjIMfZrv+osrhRLHjCMMlbdCW0OjqlH66yM9Yn74u5y4t?=
 =?us-ascii?Q?sW3lPG/TxyyBXz7z+ckwQhOtRMOIlrt7cbtsy0RtGApr0jJ27XBfS/M8fTMy?=
 =?us-ascii?Q?0R1suaU3hn7aTT/B33OhdlUqd0QDcDV7hxcgKf/lfe2CadDVcWQy5qCoGhi9?=
 =?us-ascii?Q?xK7+y/C70t8SHGrlb72RwLNX7PUAzP6Ze7Crs+nhBS60nAczEal9I/Ph6j+L?=
 =?us-ascii?Q?tSjnY+kqLd8zlF43KqkQd47K6wS1SU8C3+saBllowFrC+Ygh8x2zDtsshG9U?=
 =?us-ascii?Q?qsY6yehXx536t7B38ehxPuJztkS0aTuPKHP0CJGS/9ja4egk+ZH4ruzD0wA2?=
 =?us-ascii?Q?/QF88spWV5D5KIfrneoLprZXA6mln31dXE36QpG3wXowM0xx0XHts6M3iYPA?=
 =?us-ascii?Q?BgeUI6ULNwTFxCs8OtkMXLPDJ52ZbyxCd0iYg7j3MJ4cpmbPFPUBMCecjTN4?=
 =?us-ascii?Q?b2KveUgjWbkUW5z8YiBTnRyYI2DnwFxIm4F5yk9sGCBiCxb5EC+V6P+0rGit?=
 =?us-ascii?Q?lEzHbtCkFPbK0+0ZpCQwMijEMGZzpk6DANwDHMnTH9Zk8yxEEsAjKI9bjT+d?=
 =?us-ascii?Q?YLOpss/MB3GKM4mgwjlVic/LM+R5/jimMmq7o9ieVlYOa7mPAftyTq6OwkLm?=
 =?us-ascii?Q?UfIsn/OUhSER84rdPhDuISYgqX8Erelrnn5AnPO9pobQksrD1xYsuBNwBGAR?=
 =?us-ascii?Q?i9rb0RzAaNp1NkpEwVPq+oOcq5hz45ZiY8W7ENH4XpwBbh6KUBuiSi6QjgDz?=
 =?us-ascii?Q?IpwIcVdVzVpTHoV4ScEJr+E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CBAA8669196C554192E3D77D0EFDA869@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960af84b-518e-4070-b023-08d9a890bc0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 23:36:23.2150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGV/6NPjYJa4sUWQ+W7I9Ey3I1dtJuj3IlbZKLy4ivLkdU2rTS2DqhVug1SwXHtk0pL1xLTsjsY+H7Xj7n+Rnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 06:01:33PM +0100, Greg Kroah-Hartman wrote:
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
> index 60e36f46f8abe..d612ef8648baa 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -274,6 +274,7 @@ struct gswip_priv {
>  	int num_gphy_fw;
>  	struct gswip_gphy_fw *gphy_fw;
>  	u32 port_vlan_filter;
> +	struct mutex pce_table_lock;
>  };
> =20
>  struct gswip_pce_table_entry {
> @@ -521,10 +522,14 @@ static int gswip_pce_table_entry_read(struct gswip_=
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
> @@ -534,8 +539,10 @@ static int gswip_pce_table_entry_read(struct gswip_p=
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
> @@ -551,6 +558,8 @@ static int gswip_pce_table_entry_read(struct gswip_pr=
iv *priv,
>  	tbl->valid =3D !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
>  	tbl->gmap =3D (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
> =20
> +	mutex_unlock(&priv->pce_table_lock);
> +
>  	return 0;
>  }
> =20
> @@ -563,10 +572,14 @@ static int gswip_pce_table_entry_write(struct gswip=
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
> @@ -598,8 +611,12 @@ static int gswip_pce_table_entry_write(struct gswip_=
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
> @@ -2020,6 +2037,7 @@ static int gswip_probe(struct platform_device *pdev=
)
>  	priv->ds->priv =3D priv;
>  	priv->ds->ops =3D &gswip_switch_ops;
>  	priv->dev =3D dev;
> +	mutex_init(&priv->pce_table_lock);
>  	version =3D gswip_switch_r(priv, GSWIP_VERSION);
> =20
>  	/* bring up the mdio bus */
> --=20
> 2.33.0
>=20
>=20
>

As discussed on the v5.14 backport, this patch can be dropped. Same
thing for the 5.10 version of the backport.=
