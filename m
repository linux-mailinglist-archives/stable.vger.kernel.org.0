Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF776C1071
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCTLNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCTLMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:12:48 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2126.outbound.protection.outlook.com [40.107.114.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098E5C14F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:10:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ji27sVxbbt1r6+JOCy1zyXS+s9dmYZ6FoCLF4L7nSm/JxgKCPTz0iwW6nEL1qnaDJgAbbFeIbz8CXwAWKBNgOCJiyou9jARXVVTkl7ZBj4INg2maiFsL+U+QQDwgCCYnP/OxqKer18fOoOUsF9QTvhDf5VHdRqClf1W0L3ogFrcYfm4e/bzYradhpqX9eZmXXxwqjHe/yFaf9rzBPHBxqrKbZMlqjZW0jl9GCRRw3LVxT2w/N3ceZZ5X5clrctsay5w6Hu7REA7xTvzsz27Bzt6wWfiE3c0Af87a7f4dUXOPcxF1pA1BdHToi+hddjxZwwscVkWW6pwjh/fj+LOSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIS29AWoemsV5w2kzApQQ9u/fP8DxeLydWv7Kk5p0RQ=;
 b=F4IChFQ42E58ujQP0LTZRU1Ikc9DO0m/PP85hLD8VZgWOdam1IodP7m9EomDu78dd/7DSCXeU0IMZZ2sRtLwukY9kWr0mkdrLrl4dVMAtlVv0Jt8XtnWcGb0qFWwIW6MtYM8ecxxi/YZ4jbb9AHonWPLA09Eg9I5I/pS57E9RH18NFKxDHtHGdVzRiQbmbqhJvTVBCXTqBAYtLEPd8SC44Fl0bKdWqfexxKhYCdzpx1l/ZO3iSVl37ZyxxQrSBxN95pweVuq7BCG97LK4KbTVTdhtjXqHY3RMLOzLXjk2c2FYkF2bBvMnUyPwKFuVZPix85bPPa64MiICI7bHEq9CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIS29AWoemsV5w2kzApQQ9u/fP8DxeLydWv7Kk5p0RQ=;
 b=f5B01ElJy6kL86TsPW15B0t7PU2LoaCNeE8B0e8V3HNnczM+5S1xXkEamMOGI5o6nX8s46a4qapWI5vysIWUAQHzOg0OP+iM5uv4R8ndu9miT6RIRcqjPR3BRRBdbG0IaXXcYRQUvKzoZk41zrM3yXM6JHcToteDy1AhBOOyg5U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB9551.jpnprd01.prod.outlook.com (2603:1096:604:1d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 11:09:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::f54c:4b2:9c7d:f207%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 11:09:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>
Subject: RE: FAILED: patch "[PATCH] serial: 8250_em: Fix UART port type"
 failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] serial: 8250_em: Fix UART port type"
 failed to apply to 5.4-stable tree
Thread-Index: AQHZWwwZ6PPk2CUdnEme5V1n+7pp7a8Dgh+w
Date:   Mon, 20 Mar 2023 11:09:43 +0000
Message-ID: <OS0PR01MB59223D3A8C941D843C62293686809@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <167930353815674@kroah.com>
In-Reply-To: <167930353815674@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OSZPR01MB9551:EE_
x-ms-office365-filtering-correlation-id: 45e262dc-1315-4aad-54ec-08db29339bce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BhKh72GV+ljr/gh/NnJQc9pRlFax4OWtYrymv6finyvrYzIiX/HcMsF4E8HsU4gCpby8nMTydFEJU7/X1h+pEjXW4YitvaeVtddgBKLG3ZVVSAapF4WbVGpzpea1TdsW6dzlu8B2/MyJaAYTdxg2HZlpV7tM6wVLYZgBduBBoCe9OM8LjMc3jWlu5l0wfUbMCMqlW2cPOX8OH6vb6MS9P1GZLI628XFHuavz2FGkfbH5FJVdKti2XeZJWfh/sI+BrKemZmOdQczWD5Su1GehALptTzpBtG8yhJbB1E8EjCesWFpxiK6r6aLvHDTpiwPRPJzrPEr06NvnAYJRxY7E87C5o4SvDe1CfBG8SNYMLvouY5dZf+OfQxvSJj6doykKtH63yyv3UXNP7zYgMFRNwdfiejjBUddMSqbq5Aeurw/PDvpoJVaKaBOtJzXyc/G9PXyIBY5leEPMHKkpL+xeKMRMJTqK8P6yhaE/Koz+A3haafiaVeuHOspHgYC4lZ+Qc/ow6tI90y+PHClBqSKtnfC52KA3ZAdAGWZ9XCT+CTIgzxWkkUN+gGodNvmwk4UU4kdRRavV/YXqcosbbNZtpVC3BKFMVbjsIDjPgivz4eH0O/dN26cl96C0WI1zPoe4LA5OSSj33MpQO+wirabUsZAW/ga/u4CBQ1fyhOpzLkT9orD2VjmbIyIYiw02Esox
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199018)(7696005)(71200400001)(9686003)(966005)(4326008)(478600001)(45080400002)(316002)(66556008)(76116006)(64756008)(66476007)(66946007)(66446008)(6916009)(8676002)(53546011)(186003)(54906003)(26005)(6506007)(8936002)(52536014)(41300700001)(5660300002)(122000001)(38100700002)(2906002)(55016003)(38070700005)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sgraR0MGXN5oH+3FNm4x/yWBd/2yq3WBWWrWskQtZpt0BYYIt1U8dx0nOd?=
 =?iso-8859-1?Q?ClwfQKsobqPBMeFn75LCnPWLM+PcSeMuQuK4nzayWikADJl6vzfFUAtZN0?=
 =?iso-8859-1?Q?2sLqXOnjzCuAiLU082r3rJbSLpxwiDUNhGAL8gp7pkVZQ2oQ6Cg0OBzXpc?=
 =?iso-8859-1?Q?yhE8hdDD8uMWzYVgyOHIbqUJMnt7Ipb0mWsfv1lb7b+0yt+l/q1HrCRBXz?=
 =?iso-8859-1?Q?QH+IZikUc0fixd+uEzkiVw7OJWQ0v/QBsAvqjYtuFeZa+5adEDxKLcJfP3?=
 =?iso-8859-1?Q?oHElRqdUK9ZIwrnQiNpQANpwlIOYDXRylUQRvlXUUZ0VaxGU1k4aTXXkT6?=
 =?iso-8859-1?Q?3kbwwxpVRIwkY2hws1kQ82ag2/8r47gm4mbzd/VGLmxgHW/zUBAi97GpJ6?=
 =?iso-8859-1?Q?at4HE2fbHf02oe7nN+fLtg7fq8hoqwAYHrY3hd7uZkDyBX4uh/078P2PSX?=
 =?iso-8859-1?Q?ERs9oZp/uhKCOFwzPkYGbzMRKhNSnsTsk0INGjVSkv685eURb3cPWSz9dM?=
 =?iso-8859-1?Q?FqWX3F99GjUE2a6OWQ0wMqFGlH+nmRUebCXbw1iDtYvNo8QQwxf9KUZfQc?=
 =?iso-8859-1?Q?/FPQO8E6WUnsspmZ4Myecy9+Y8VO0jnWxHdM7Pe9bktiXSHm3RmqR0/MAQ?=
 =?iso-8859-1?Q?ZPQ8ayZAnPSKwecObgZNhRzwTq8LxNxqfz4nY/J5yQErYb1A+jW1DmtZP6?=
 =?iso-8859-1?Q?YZ+bCZepu4/9osFPpLyIcbohPRb5Rbxsn73kr0iMGWD/oYpJruLzBYODGv?=
 =?iso-8859-1?Q?5uQPXlJLxokoxcRmEryeO38mSki4Op3V79/RGKMOshXNRBqxXbQicH9P1M?=
 =?iso-8859-1?Q?td9uf0AbouSkB65WtcB6yCq6rWfywT56QkMNgIkWPzlIevzkQ7QpuII+QN?=
 =?iso-8859-1?Q?yPzWwMjFG2kAFFqmXkFbIaD53NWdAEj7jrdT6urBqpItof+H+zSc1V1mn3?=
 =?iso-8859-1?Q?JjagMU0dSXlvXCY6+qd3YjyTG1wGlp+h2hf6fh8KtPr0fe/i49foMkSOaF?=
 =?iso-8859-1?Q?8azNwEin1IYW4V2SzIBRTuhedDIoyB5gbKzAOokBJoBRikGjRD6AKa6dDa?=
 =?iso-8859-1?Q?+Crgkzmp+g5OC3A+Hnc13eoGnjvXQ36FNL75eRAM1IJF1yDwaTMeWR84sz?=
 =?iso-8859-1?Q?f+cFohkBQfsEXgVIpzWBLMUgyggpvur60IN9bM/D6KqRU72kULlewU/2pE?=
 =?iso-8859-1?Q?8+rY2G6tTB0CvTx54bSIkqeSzFejxdnHYjkSojiu9yiVGBMjnhArsK26fO?=
 =?iso-8859-1?Q?GZgErE+3wkKKLvtl7gUXGvEeQCMyGQClCKdPvEq1cw5MaWmGGiTYIZvbMC?=
 =?iso-8859-1?Q?7+Tlhs5PdZaXA1dPNYPvBHbMma77CqXo4ocjtWCfiptmp2NEP38PezwKM7?=
 =?iso-8859-1?Q?xJrs+v5DUp6f2Xcr/f1m5CdbMTFQv90A1JE7efsI1E8PAsiYTb+eOcKej1?=
 =?iso-8859-1?Q?kRMObBdjpjIighBu2W7C+TQziAq3dsNCB+yE9T5lmtEd5G48alrQ0JpXR8?=
 =?iso-8859-1?Q?Rvv4+9UGtPvr4f6glJZyk8ezW5RyftENUjJvZ4g7VWD02k8sCGIO5yGt0W?=
 =?iso-8859-1?Q?bouhZFcdr82ux5LUfYgIGtEyOri+shJOC4nPOz54SBRIEhQ5pfstuZWY0G?=
 =?iso-8859-1?Q?unhQ6zjLkDHaH/KOeZ08HjD4tBM7LAUvOo?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e262dc-1315-4aad-54ec-08db29339bce
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 11:09:43.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YslMIfgt1VW4TL5lxdlV9pvreMf4lysKMDuRIdm7YDusz+yZnX8xizZEg44CKKTf1BB1wok0ozdWxjMRapXFr7n/8iswZHOw+Xo8HgXgbv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9551
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Thanks for feedback.

> Subject: FAILED: patch "[PATCH] serial: 8250_em: Fix UART port type" fail=
ed
> to apply to 5.4-stable tree
>=20
>=20
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> To reproduce the conflict and resubmit, you may use the following command=
s:
>=20
> git fetch
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k=
ernel
> .org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fstable%2Flinux.git%2F&data=3D05=
%7C01
> %7Cbiju.das.jz%40bp.renesas.com%7C05314cf919e7472983e208db29233b43%7C53d8=
257
> 1da1947e49cb4625a166a4a2a%7C0%7C0%7C638149003512485403%7CUnknown%7CTWFpbG=
Zsb
> 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3=
000
> %7C%7C%7C&sdata=3DeLxnB6PHZsrF3%2BUbZ4r90nz5se5HFps6MGCXbzNpudk%3D&reserv=
ed=3D0
> linux-5.4.y git checkout FETCH_HEAD git cherry-pick -x
> 32e293be736b853f168cd065d9cbc1b0c69f545d
> # <resolve conflicts, build, test, etc.> git commit -s git send-email --t=
o
> '<stable@vger.kernel.org>' --in-reply-to '167930353815674@kroah.com' --
> subject-prefix 'PATCH 5.4.y' HEAD^..
>=20
> Possible dependencies:
>=20
> 32e293be736b ("serial: 8250_em: Fix UART port type")
> 2a1dbd259e63 ("serial: 8250_em: Switch to use platform_get_irq()")


OK, will send these fixes to 5.4 and similarly for 4.19 and 4.14.

Cheers,
Biju

>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 32e293be736b853f168cd065d9cbc1b0c69f545d Mon Sep 17 00:00:00 2001
> From: Biju Das <biju.das.jz@bp.renesas.com>
> Date: Mon, 27 Feb 2023 11:41:46 +0000
> Subject: [PATCH] serial: 8250_em: Fix UART port type
>=20
> As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART IP found=
 on
> EMMA mobile SoC is Register-compatible with the general-purpose 16750 UAR=
T
> chip. Fix UART port type as 16750 and enable 64-bytes fifo support.
>=20
> Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link:
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/drivers/tty/serial/8250/8250_em.c
> b/drivers/tty/serial/8250/8250_em.c
> index f8e99995eee9..d94c3811a8f7 100644
> --- a/drivers/tty/serial/8250/8250_em.c
> +++ b/drivers/tty/serial/8250/8250_em.c
> @@ -106,8 +106,8 @@ static int serial8250_em_probe(struct platform_device
> *pdev)
>  	memset(&up, 0, sizeof(up));
>  	up.port.mapbase =3D regs->start;
>  	up.port.irq =3D irq;
> -	up.port.type =3D PORT_UNKNOWN;
> -	up.port.flags =3D UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
> +	up.port.type =3D PORT_16750;
> +	up.port.flags =3D UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
>  	up.port.dev =3D &pdev->dev;
>  	up.port.private_data =3D priv;
>=20

