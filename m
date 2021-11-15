Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0DA451A9E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353996AbhKOXkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:40:53 -0500
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:41120
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353549AbhKOXhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 18:37:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXVdSgD36T7c7ka4MnVSQgfFfuxJbXuvQJDN5e6ZqoM4Pvh07LUj/ovU7OyNw1DC94wP4w+kNtmlduOgYaj/H5QM59xjSrc+m0ZGKH6WHOGHtWBObHFm/DifC26uJmJmWXJ7kWcgYWpjEq/QbLBD4wpsZf0kI0zuxj4wKDD2ejhbqXFcADnVWBORfYf/SOUYSOLSklPhPM84Ynu59mDsUFAclAXs/b7MYz/IXpshpf19vgzkLUvWm5ndPG/HuS+DTNuJ4TYIUNmhhj1mkadMnb4takF/wZqyGyHjPfx6KZrEAMJiWxAHDLnP5yzYJ7bWWkwiEzFat1iggQRaFo3g+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2NKqAM4LJcX7BuvLtcv5UeuXoFBsaeH4bgC7RewZ7A=;
 b=G1HnsyT5ufaXm52ni5IJ9xa7gNGrDH6EQRmeEKQYz7QD/tmW+6TItUXW4g34yzRcvvIJl98C8q/ST7HZQ+nxFxDun8oR+/SpCbDQvskCm19Vgs3HrV8aZavaP8au6eU1x2u/ALNZUZn7E65IYh64bksRU7Q0LqGFOubo2j3Ih3rzN7YKqwRwwlou5/GglHQAGFxpuuoQ2UM9OjRjwUF5QB056ji38diCE3cRnOUNnle3TF4NZCb/F5i9E5T48ZEU8t0wmY35qxetrH+jJ9evSTd0p01pM7f7OzwBwmiB7w0aVfWoZlPW+2/5xS+nm/DCZf4VGITfJcZhWvxM+/mmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2NKqAM4LJcX7BuvLtcv5UeuXoFBsaeH4bgC7RewZ7A=;
 b=J/17NIgoet1zFmuJS0ADf2ttDMcz1yYXenD7wNlx2FcQ0vjaCWg/qoiiJkGx7+SxbhZOL5Msmb2cnZ/tCUA0haCf3MlWESbNks0nWMikCcbg7MdOS/9mnlvHuU2+mJjgDCeMIUgBl2L8l2NdM8FGoyxcrmj2CPMvDZjTKyoior4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 23:33:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 23:33:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 301/917] net: dsa: flush switchdev workqueue when
 leaving the bridge
Thread-Topic: [PATCH 5.15 301/917] net: dsa: flush switchdev workqueue when
 leaving the bridge
Thread-Index: AQHX2lCGilYJje69nES2QBLPNshWzKwFPeQA
Date:   Mon, 15 Nov 2021 23:33:59 +0000
Message-ID: <20211115233358.u6n44mop73le7rkw@skbuf>
References: <20211115165428.722074685@linuxfoundation.org>
 <20211115165438.966642608@linuxfoundation.org>
In-Reply-To: <20211115165438.966642608@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6be95eb-65d7-4ec4-611b-08d9a890661a
x-ms-traffictypediagnostic: VI1PR04MB6015:
x-microsoft-antispam-prvs: <VI1PR04MB60153D48B2191912C622D384E0989@VI1PR04MB6015.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ts6FvJBTR281/09Qc6ZXf5kFg4FBPi7ucrshU4h1hpQM+2b4bV4qWqbnF357tnDfFf5ctzP/37X0ZFFgmLaZVPKnm8SSknnjT88tTk++LI3O6Sxsn/0gVDm2T0I4nKi2BjrFkEoTQ6/CArcW2tDQ9eRaGWo4OS4t+xGbi5gAUhldj6Nqm6zJfoOZwnOVdoTrTu1eK+V52tmuxORLDywcezbZC1vBCAnXw+4ODnodWene0Wn5M2Tj71SLzhEXEE8tPJU7Di0dcqHcf0QtqIsAPP0jFiCscpKBB8AhlJc7mOFXOi5BgCj0L7nPvhH8L/Yjb4elh2V8U4R72UjmGYsMPJ1UHfURJ4y345jct6tNYgotvG4a1mf/oEvP8C8I6lH4f0xwRdNw+lliUA/B3jzEV0dKNxtuzYCbHWs2ZwHFWqRx0OfU3fym6EyFEmFzhMqLjrSFfB2Mq4sD0n0daIpko4wzm0vBSwgvkx1TZbZL455D8ca5pVBcIK329oK1tu8q+Ij4590E8e+XPPZYXVATub2Bf1mQ41AXQV3qq+zBVuJnuNB6wJOsrRfDa3aZHljMVvlhkBdw+UJ83TP9GfJTCkl4ik8USkw2jbbujxIz/7d4ZAIKUkG4uyU4eLIn27qObZ+E4FCwZIrVsdnSomfwTQoCm3MpRt2MBy/+aflLx8slMLdhBsZJIxG8mobROGrfsPqn0WyIApERGjwKiOrZJcVVFnThl6N/6NlbmTygKwWfJHSU9b5lJ9A89jBH0LasrvGIZuCS7wcDjcVNo5T+fv9rfo913Yyq9NFoFYr8KFw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(6486002)(966005)(54906003)(6506007)(316002)(83380400001)(66556008)(6512007)(5660300002)(44832011)(38100700002)(186003)(26005)(38070700005)(2906002)(8676002)(66446008)(4326008)(1076003)(33716001)(76116006)(71200400001)(64756008)(66476007)(8936002)(66946007)(86362001)(6916009)(122000001)(91956017)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w76LzN+9w6OgKiLspqA3ipW9/EwbaRrQ1ZVSkVa1fwFMDvt9cw8lT0LEFvEr?=
 =?us-ascii?Q?twh80bbXoBcLVW22ZcivAx2K2zI5VU5T3pJWgjkwjeErvEzZJHST1smHrpKk?=
 =?us-ascii?Q?FL9K0YLL6UPwJBq07zCjN8OWRH5HTeh48FkOQvOe/3iYJ4jD6mKNqpBDtMwG?=
 =?us-ascii?Q?hhGNIGbfd3FZt/Akq9otdJL2byDg6yku920cUNmtqY+riYxU+aHJjGowAVwV?=
 =?us-ascii?Q?sj85XFoMdlK+cldASE72kGGmgmKCI0NDKeClj6qrfcdzROhhiN5Wttn18JyK?=
 =?us-ascii?Q?kMKrktfESEM3Nmh3hvfqCzBrxCOB9z706pyx+W6TnhwmOGZXiDrdKVCDmpvA?=
 =?us-ascii?Q?9bSXhJ3+owbPHW2MOm9eBTBu/YkWKNPPHqn9JuzvIprGNZK2+4U+NgTaJ8ob?=
 =?us-ascii?Q?Z70eDU0cdukTRGSorpi9AaqS1gqqBmC9GPyfSXgRyNhvDuK6Aol82XP7n5sB?=
 =?us-ascii?Q?ZmLtfpCeuT7QpfR4OHMvj4Wp4+hrc9T0rHT7rUqYiPYiuokDyoKdZ2e7tD65?=
 =?us-ascii?Q?AFlSt6BYL0layk59DrZo9VSBuZI8HbSYsaoKn5oqEUmhYiKPgySDRhhVcUxH?=
 =?us-ascii?Q?6LV3W+ta1tMgD7T1m6oHHPaW2mJpcEOaLJzUzbmOeGHDa726HARbYYYYwKm1?=
 =?us-ascii?Q?NCYK06Cz/dzS2Rkf2boGnkYoP7P18LFunpeIO1l5qf8LzsUt2H72cjNs1/8P?=
 =?us-ascii?Q?OBtWkxreNTwgWxhxSV9jpytdYuhnk1jJP/QFRdbejk65venUxD1sbK/wXRG2?=
 =?us-ascii?Q?glEyptDk++WWfYX8EVtOCI980bswPJSrc4zJdf3TXtzErdIPjRQE2tkkn+Aw?=
 =?us-ascii?Q?lvR3iAdA4V8BetpoHJrI/JNi8Y4jtvEU7QKOAhfsPQz90lNw5eMFWttsFjBV?=
 =?us-ascii?Q?fNhjepn3FV14C7Kf+xvFtcly3v/R3CA/01ElKRksjMucxzmABJ+MeSmU+ugh?=
 =?us-ascii?Q?oc7gCKqtW93ip/2J+B7VemYc6X0q7hyNcnb35Xc2VPtMUija4/eSCAUZoftH?=
 =?us-ascii?Q?zkzOQe8aXyrn/AxzKru3QY+DdJJUYmE0DnWQGg8Orf2YAYyT/60HyEz5rtxh?=
 =?us-ascii?Q?KhFnTflsA8qjKv63Sct+7z6fv/Q8Z2yHvq0PkeB4Jk3HstwQKFMUY4109/eX?=
 =?us-ascii?Q?XwuGlqFOadnVn43svDTd3bAa5JSQ9/J52IMmfVOc42QtoAIt6PLF77ZNY5uq?=
 =?us-ascii?Q?wFv7s6gdmABPg+ZgG48uQIn9WE3RCuZbsCm9OIv3eF1Id31njrdXEDzCGVJo?=
 =?us-ascii?Q?9s8DM/+0XeX7Y9br6nxlQVS2+jBSrvWxzgaX4/H33JQT09vmvCT5RWIgyr/F?=
 =?us-ascii?Q?Bo8R91uuvRJ1hfvemKJ9ERTCpUcjNA20AnqQPRvfQIen9S34eJnal+po8/HT?=
 =?us-ascii?Q?9A7D6lRj2AX5vOULRi9ASZxfmxCTj+x7K22P4xhCSXWJE0+OigEnoRZUA48k?=
 =?us-ascii?Q?WQh+kotvEOimRnJ581S4qNU++CMjrsINU7J5becHgS6WGdEv8eGmYjjMKTDB?=
 =?us-ascii?Q?wQglr84hDp0ia+pSg34+f4nQ+Mtr2pJxRYgO2Nrj/ctfuWx0B9CyLFBo7oE/?=
 =?us-ascii?Q?BjwkoKdI5JVRsQMJW8HuYs1ewyyghj6TbsXjNCtvt79/N/qEayUAURRKW6QN?=
 =?us-ascii?Q?WCOh9JPWiiT6YJPSmqDUHDE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14BBAAF5FCB06B43B40B1ABC7EB6C0D7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6be95eb-65d7-4ec4-611b-08d9a890661a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 23:33:59.0568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pKxiAaGCM1Nu/z/XeeNCDMeQ/hjYvjJnmtnxf3LwecrgabnRnND7gIQd8UjtsoTGa8XVKdFKwAsLNY4cbI1V+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 05:56:36PM +0100, Greg Kroah-Hartman wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit d7d0d423dbaa73fd0506e25971dfdab6bf185d00 ]
>=20
> DSA is preparing to offer switch drivers an API through which they can
> associate each FDB entry with a struct net_device *bridge_dev. This can
> be used to perform FDB isolation (the FDB lookup performed on the
> ingress of a standalone, or bridged port, should not find an FDB entry
> that is present in the FDB of another bridge).
>=20
> In preparation of that work, DSA needs to ensure that by the time we
> call the switch .port_fdb_add and .port_fdb_del methods, the
> dp->bridge_dev pointer is still valid, i.e. the port is still a bridge
> port.
>=20
> This is not guaranteed because the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE API
> requires drivers that must have sleepable context to handle those events
> to schedule the deferred work themselves. DSA does this through the
> dsa_owq.
>=20
> It can happen that a port leaves a bridge, del_nbp() flushes the FDB on
> that port, SWITCHDEV_FDB_DEL_TO_DEVICE is notified in atomic context,
> DSA schedules its deferred work, but del_nbp() finishes unlinking the
> bridge as a master from the port before DSA's deferred work is run.
>=20
> Fundamentally, the port must not be unlinked from the bridge until all
> FDB deletion deferred work items have been flushed. The bridge must wait
> for the completion of these hardware accesses.
>=20
> An attempt has been made to address this issue centrally in switchdev by
> making SWITCHDEV_FDB_DEL_TO_DEVICE deferred (=3D> blocking) at the switch=
dev
> level, which would offer implicit synchronization with del_nbp:
>=20
> https://patchwork.kernel.org/project/netdevbpf/cover/20210820115746.37018=
11-1-vladimir.oltean@nxp.com/
>=20
> but it seems that any attempt to modify switchdev's behavior and make
> the events blocking there would introduce undesirable side effects in
> other switchdev consumers.
>=20
> The most undesirable behavior seems to be that
> switchdev_deferred_process_work() takes the rtnl_mutex itself, which
> would be worse off than having the rtnl_mutex taken individually from
> drivers which is what we have now (except DSA which has removed that
> lock since commit 0faf890fc519 ("net: dsa: drop rtnl_lock from
> dsa_slave_switchdev_event_work")).
>=20
> So to offer the needed guarantee to DSA switch drivers, I have come up
> with a compromise solution that does not require switchdev rework:
> we already have a hook at the last moment in time when the bridge is
> still an upper of ours: the NETDEV_PRECHANGEUPPER handler. We can flush
> the dsa_owq manually from there, which makes all FDB deletions
> synchronous.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/dsa/port.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 616330a16d319..3947537ed46ba 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -380,6 +380,8 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, s=
truct net_device *br)
>  	switchdev_bridge_port_unoffload(brport_dev, dp,
>  					&dsa_slave_switchdev_notifier,
>  					&dsa_slave_switchdev_blocking_notifier);
> +
> +	dsa_flush_workqueue();
>  }
> =20
>  void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
> --=20
> 2.33.0
>=20
>=20
>

This patch represents preparation work for a new feature. Unless it
constitutes a dependency for some other bugfix patches (which I doubt),
my suggestion is to not backport it. Thanks.=
