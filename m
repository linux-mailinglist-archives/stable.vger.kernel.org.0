Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323CF662307
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 11:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbjAIKTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 05:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbjAIKS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 05:18:58 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2105.outbound.protection.outlook.com [40.107.113.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED151A834;
        Mon,  9 Jan 2023 02:17:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZkwijN5aPl3Kj/gezzvnL4n8uyxIDS6NYEATicF0Bie5/XdmbBcnnC1C1wsMSjHKKHP89hb4SXp/JGmun/KqtVO/vxbJRjR9TfOzgEDZsBprWOOUBh5QeQFhe2EEKASmLOKeU6GD8N7ih/DhIH6hn0x6Q+DIZ0QPRZp5IFUShMrVqCFWk3vrIkKOyq9FIZvMiywTW6IEKaDQESAw1+NU7AKaLbUsJ1QDsPXRKfre02HTR7Pq9mwpsXtPVmcf+46i08Ok/hhpgeP4MZdtXTkd+yyDrPc00od1La1/j3LY2pVt66CSEc1gySLC5SicRjwke+A80g4JF63dVDElI3/xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAmTUfjE/9yH9zVBHmWtDG3aQs0Swy38esZx3PHp4pw=;
 b=Gp3sp8BjQGqhP6t307xu8/GMY2GGfsHE7KX1MODXpHVP5HZVt1FsYclNLK+BeyH8QjFDAbwZEvUuWpW2odlFeVarbYLxdlMMEeMvdza4HP/c53bwJ4SAQuOWO9727gCZqPEZqXDO6qMAHr5XDf6UcunMd3cGbdM5T7Zi0q3P1KnipJhel2CMD+WHhhrlySCAgz0WzDmlQDJsdTVuHbjvnmBzYWY2tC9fsEC+S8LCDCGrp9H0t2iHNosSzfjpmRzW/wgZncVyeneU3iewmuJvm0PxRxH7KSnvYlh3rq2lXbqr6BRxVcJlScfGzzVy4WP8WrC3iMQS877acgMkXWTUmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAmTUfjE/9yH9zVBHmWtDG3aQs0Swy38esZx3PHp4pw=;
 b=s54zuzel4oygh1wlPdCbOtOYz+1JkvxvuMXimJWgB7AWzeO2Gcn1nBj07LQJM/FpprvVkyHgwGMdNVOhWQaPrm/7PM2QyyU4/Rjm4a15I7MGPvQ00mNHl19dOoh4PQ3UdBMxSqoKElrLQDF2IKBGqDqxFJIYRIT5tUFUIvOn2m8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB6229.jpnprd01.prod.outlook.com (2603:1096:604:ea::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 10:17:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::343d:7339:78e5:a46e]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::343d:7339:78e5:a46e%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:17:47 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] ravb: Fix "failed to switch device to
 config mode" message" failed to apply to 4.9-stable tree
Thread-Topic: FAILED: patch "[PATCH] ravb: Fix "failed to switch device to
 config mode" message" failed to apply to 4.9-stable tree
Thread-Index: AQHZIEdAQk1JF6l/Akywbkwz8uCaVq6V5g5A
Date:   Mon, 9 Jan 2023 10:17:47 +0000
Message-ID: <OS0PR01MB5922975C247CE8CF27779B7A86FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <1672841813129164@kroah.com>
In-Reply-To: <1672841813129164@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OSZPR01MB6229:EE_
x-ms-office365-filtering-correlation-id: a80423cb-4c23-463b-62ba-08daf22ac16a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 30UYz7z7lGmAR4h2FtqkKRM29q5Zmz0243Jz7GX7k283iFCa6x/f55H49nJk9wExbpVtfg2EvfjOPL9xah7NDrXIxA1nUCMi4KCAeYTtnChuhZpSo5opy1wCHCQZo8LDHAgLdwPc78S//IqhbWXteUA6RcSbIy9xLFYdFsHOXfJhJN9OGElZY3nv11sgAVJe8hKNNSI3lVpVOvvkMWL+UGBpd5/Y3mfQShNFg+QLw3nGLrTuU2C/+MAxrRiLjp/aKVS0EopDyPO2q10zMFptHq+y33hHEtHtZNqBVinJ3JMLN0TQM/awKc59NQMTFzDtpHo3gyV0cEj8gIQpSyAraBQefI4rkDdGzmEQvB29KPpsoTSnuF9yNLJtNdsPJEzgg1GCglU1VvFabMkMNtKJL27Ml5YUikjMIkDAK8XQveJG/MfIMp1BClwqM847RL9wuWnEQxLa0/jCrPT09yZ4QpX4kEojX5F2FUmgJ7ZCIewkiv/F7pEfOR02s+IwxiGJB2JKr8OZBO5ZBq5WT3F0MxvIF1SEpfgNtcS1ACSDrJGRm09L27zcKkd4uO2SNhgP2r/PeEdWKApCK2s+0pJUGuRdmZI8Ol1uohfAD0nYaXFOrXElnpkBbtHwNRH2R6si2mhpUsDOtSwlmsiR2cOmo8duFErtUOXXww5wFLcKELBAIl1RZBprVupXVAltdEv7Kgkg9+jAlfNO0dwHNaN3dA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199015)(53546011)(6506007)(478600001)(26005)(33656002)(55016003)(186003)(9686003)(66446008)(66476007)(66946007)(76116006)(64756008)(8676002)(41300700001)(54906003)(110136005)(4326008)(316002)(71200400001)(7696005)(83380400001)(86362001)(122000001)(38070700005)(38100700002)(66556008)(52536014)(2906002)(15650500001)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u4VbGVzHDtBWg791HmyLLwMVkSgj2knCk32o7r8hKOuYG+FH1iAKJ/8hcyUA?=
 =?us-ascii?Q?2p3dI9I7YAkvkW8HpApfiLe1j2qEiw1VcWI3yBA4IyMhqKlYoBfyOrFr+r0z?=
 =?us-ascii?Q?RUttpkZhfANjEtpsXQvCCYNmBZIJCxe6pGMZXUmZoRUuuNUNVGZCOf39Fx96?=
 =?us-ascii?Q?IwaxxL5GJjyiAPMQy+OXvMS6goNXssIGsDXTwfGF9yaTqfSfsiJ7EcjzLGhv?=
 =?us-ascii?Q?EuXUV02LuVWzxswcx845WPTyfdMqSc3W6KTWWm6EIB23ELvuzVOyxk9Vp48B?=
 =?us-ascii?Q?UdEFqznsM+1vPTVJNUMOXz6O9fOwN5Ff6KqtKpuK45EKv4vO39iZYYzKYbx1?=
 =?us-ascii?Q?j4j6B6LJp3nm0GFOI14x3ZCX95s8yFuIUBi8luKF4gAuYsi2QVHJy2lOHU21?=
 =?us-ascii?Q?IUTIYP1B5n8optIIWhoCAqZZR7QPm7CXLtqGk27BVTjb9C5jvd+CYsU/8cfi?=
 =?us-ascii?Q?CZ5YQWAsG4BDaJPzLe1BMobN/2zzr5NOnInPbybRbISaZZaP9l1iv8lnBDP+?=
 =?us-ascii?Q?yLN4QZFQ4Xnszb9yAfe7QHx3cBf+CIYyZsvrcT33aDFFk0Ma8l9Thq7Y+MtW?=
 =?us-ascii?Q?PYq9YsyPgybVl76QbA9ef+NQyxbiaBjl0zZ9UYy0iibtHp5b0PW2HX10f9P5?=
 =?us-ascii?Q?RAV8yRjY77ebB+3vNOVVdvcfqZZPGLPWU+M7RVVct88dNXbOxWOrtM6mTOeE?=
 =?us-ascii?Q?n6SF4cfttpjJtOCsUBvFczX/L7z3U8thHFla9kcuJx6oErEZTNJZAkUvr0/p?=
 =?us-ascii?Q?2/2kDCYJCtcKRl6hkB6DEhhFa1ksmDGHlKbCk6WsTzGhEn+XOVSx86La7JfS?=
 =?us-ascii?Q?l+TO/GuWuZyMT6f3QE9yHXjoCHBc5d9nmbhSdZz6tAbVEP1E7YQlJb0ILIjh?=
 =?us-ascii?Q?W7uQp8dm9WjL6Qr45OlDxVaIMBsG6B3lKBD9vP+SfoLF2mINy7HryeNSHyfW?=
 =?us-ascii?Q?14CHA8JHmJTk4sTdMeqtFqSzSBVRtsIlXKjzT+8enveMqKT0N5i0tPKW/1oS?=
 =?us-ascii?Q?4xYwQi2cbzwjfDsXXWQ0fABEE3vRBZaOAUzjdA2DYKmJ8l4iEwi6w4B22V+r?=
 =?us-ascii?Q?01LrMkgNT+O5/Ed0yWtbZvd/dBeq+4JHa0rfK9pxK0kXCUcv5E6ZukuVb8GK?=
 =?us-ascii?Q?IKy7HuvXAgwB8QhMug9eM0/4n57+U9mndqC0a2nOLt4NBhrZsAuizI2rgYME?=
 =?us-ascii?Q?JH2EJhvflzIHuQYsLi+o3cvqvZzmTASOpJIdJJe3h6/gpcIIIrnUp28BdYh/?=
 =?us-ascii?Q?kJ1cHx5JarT6SN2cekHNJo6NnUwc1xs8os9uyYV7g1ssfUwdHszFIlmmZeKI?=
 =?us-ascii?Q?EK5z1yG0m8xEpZEUKcEF6Qo6pGQ3ew9YBLKN5TMcU1+5uPhJHUR1cKy85u67?=
 =?us-ascii?Q?BtHGYPR0jKxIYpg6axScXAi97xagUMxZQXZXx5Lvj5VbPOXgAO7FFQOwJXgb?=
 =?us-ascii?Q?sGm8+ITXQA/fn05fqpvOf4EiS9jaV1dsVTu14l8DodnAipmIVB4shaoWcl7k?=
 =?us-ascii?Q?q4O3/LbsiIdts5A9cupVy8U14rLRny4GptQFbENSmXrIR865y16HVZDhzJkb?=
 =?us-ascii?Q?EvrbnAXsgwELHpos+XjNDDfz861DqhRsCOHmG7vZQ1mjt27p4SI5vHtJi549?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80423cb-4c23-463b-62ba-08daf22ac16a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 10:17:47.3713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4A5yRBnk5HN8p56UhBMqBC6qUx+G1VFiGCnsj+Jbl3GoE9HOL3APPgYmn7jw64tssJZDYVSa1QCDrIc7T1L/7AfwLtVnhTgZppUTR+Ml4Ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6229
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I will fix the failed patches and send to 4.9, 4.14, 4.19, 5.4 , 5.10 and 5=
.15 stable trees.

Cheers,
Biju=20

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: 04 January 2023 14:17
> To: Biju Das <biju.das.jz@bp.renesas.com>; leonro@nvidia.com;
> pabeni@redhat.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] ravb: Fix "failed to switch device to con=
fig
> mode" message" failed to apply to 4.9-stable tree
>=20
>=20
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> Possible dependencies:
>=20
> c72a7e42592b ("ravb: Fix "failed to switch device to config mode" message
> during unbind")
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From c72a7e42592b2e18d862cf120876070947000d7a Mon Sep 17 00:00:00 2001
> From: Biju Das <biju.das.jz@bp.renesas.com>
> Date: Wed, 14 Dec 2022 10:51:18 +0000
> Subject: [PATCH] ravb: Fix "failed to switch device to config mode" messa=
ge
> during unbind
>=20
> This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
> device to config mode" during unbind.
>=20
> We are doing register access after pm_runtime_put_sync().
>=20
> We usually do cleanup in reverse order of init. Currently in remove(), th=
e
> "pm_runtime_put_sync" is not in reverse order.
>=20
> Probe
> 	reset_control_deassert(rstc);
> 	pm_runtime_enable(&pdev->dev);
> 	pm_runtime_get_sync(&pdev->dev);
>=20
> remove
> 	pm_runtime_put_sync(&pdev->dev);
> 	unregister_netdev(ndev);
> 	..
> 	ravb_mdio_release(priv);
> 	pm_runtime_disable(&pdev->dev);
>=20
> Consider the call to unregister_netdev() unregister_netdev-
> >unregister_netdevice_queue->rollback_registered_many
> that calls the below functions which access the registers after
> pm_runtime_put_sync()
>  1) ravb_get_stats
>  2) ravb_close
>=20
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Link:
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index 33f723a9f471..b4e0fc7f65bd 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2903,12 +2903,12 @@ static int ravb_remove(struct platform_device *pd=
ev)
>  			  priv->desc_bat_dma);
>  	/* Set reset mode */
>  	ravb_write(ndev, CCC_OPC_RESET, CCC);
> -	pm_runtime_put_sync(&pdev->dev);
>  	unregister_netdev(ndev);
>  	if (info->nc_queues)
>  		netif_napi_del(&priv->napi[RAVB_NC]);
>  	netif_napi_del(&priv->napi[RAVB_BE]);
>  	ravb_mdio_release(priv);
> +	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  	reset_control_assert(priv->rstc);
>  	free_netdev(ndev);

