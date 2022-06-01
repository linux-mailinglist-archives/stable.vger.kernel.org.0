Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6038C539D13
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 08:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244135AbiFAGN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 02:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiFAGN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 02:13:28 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2091.outbound.protection.outlook.com [40.107.113.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415246A002;
        Tue, 31 May 2022 23:13:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQNtxB1jpHJytsuetYJfxqDF9nQk+KU79ND15FLnVsK+x+vf9da2HpF198NMT5t2MfAOu6XieyO1agKlQDpVE4Ot0J/ihK/B2qn3vFKeYy1G3lcl+ObQHOmq9Gi+XJH0a+E3vzQ7nDwqaQXgALsyN45RQz1nDSPrXfsLEMuuTVc140Vi2/oh7WZr5wPmCZAn1kE0fm7kqIRr8hQDuuODXajjMojxyXJpkZqOxtWW9NIMjbnrNrHK98FqWw7QjwAGXnX/ILN99UGbcodHZ0JXDXuPlWNy+xGfxHMO1QZe1iwC+y1E8EsmUzpLwGwOg0MiUibo2QB5WCP2RvXDu7k56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvD2YxNmtKl3BySSu3j1rRc4D1NS0Z7vS85HEE5Tg0s=;
 b=K+2v/UYW8dazqg0WNi4us0cF3HZKHNNImLW9yDIULkZ2rTBazk7Hvo2SgeDw0RXUCjVl5ypiJp4TUZkjss8NK77X3zSgfVDHKjCLo3DCjVdiV5H34LBnWCdJ7RfRlG+E4XD/Zc56xauXrZqjXWGpy/7GU8skMoiVgfjtKQougleNiUO0vH0hf3/d1XC2VwEak61S0KKNL3aoIUFk1rDt4IP0i9XQrwSY/5Itf5Ef/m38bR3BsM6w0/rQFpQPFoxqz4n4qgDgYUiaENDm0KYZMfigeQDobO7S/9vQXR7zg30/v13rAb2YUKJxBFKrXBQyKgTKmfcPIByNIe5tLfH1og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvD2YxNmtKl3BySSu3j1rRc4D1NS0Z7vS85HEE5Tg0s=;
 b=jWJfyiasfMDtQkJd40s1FevjbnIhpuPmTVj8KUmSJPEQ/1uLLYvGT+9QXHI9uDRFvKUkFqRzJXRFKuOrDbhUHfoAVWp6G6ZeD4zYoaPgAT7DWrGviUq90f5wr8CJX8+lLGnP/MJZQ94v0GB9tlmcZVqKe4sHEW/FnjJICoxOivQ=
Received: from OSZPR01MB8124.jpnprd01.prod.outlook.com (2603:1096:604:164::6)
 by OSYPR01MB5526.jpnprd01.prod.outlook.com (2603:1096:604:90::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 06:13:22 +0000
Received: from OSZPR01MB8124.jpnprd01.prod.outlook.com
 ([fe80::9198:5a5e:9c13:9227]) by OSZPR01MB8124.jpnprd01.prod.outlook.com
 ([fe80::9198:5a5e:9c13:9227%6]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 06:13:22 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "slade@sladewatkins.com" <slade@sladewatkins.com>
Subject: RE: [PATCH 5.10 000/163] 5.10.119-rc1 review
Thread-Topic: [PATCH 5.10 000/163] 5.10.119-rc1 review
Thread-Index: AQHYcacNDB9rYkH/vUOsQF3WNaz0Ga0yxNCAgAByrgCABt96sA==
Date:   Wed, 1 Jun 2022 06:13:22 +0000
Message-ID: <OSZPR01MB8124A4010BED09E1996492C7B7DF9@OSZPR01MB8124.jpnprd01.prod.outlook.com>
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz> <YpE88Nwh/FQMyVVL@zx2c4.com>
In-Reply-To: <YpE88Nwh/FQMyVVL@zx2c4.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e34fa056-a053-4681-e4d2-08da4395d4e2
x-ms-traffictypediagnostic: OSYPR01MB5526:EE_
x-microsoft-antispam-prvs: <OSYPR01MB552695CDE6A48D4CAA29478EB7DF9@OSYPR01MB5526.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RsbKVfZNMCuXo1/55UE4s3NnJkYeIXJrVD3ZCwOIeX1qAiOAt37+u3BP34wdlaTpEK2rm6dv10qNEj2qQcaSWsNcy/4HZWK+dj4Df+1LE8LDJHYiISUqrhRUmHhsWPl+b7ihdPiKic7LqDjApvCt5ip2rNdCsHTNiqNdP0Netwo9A8RlE+/fNbCvqd6MrZnyHylcdEsTXFZBMH0YjDPGoAPzeoXu+NeotuS11ULcc4a0qzSgX6LDEwSYGg1bTlUi6VC2aXwU6By5ul0uke7QlTYCFkNriGzRrRCnVEzDd53GrdbIraCmoTAvjtmwBfoijTEwYcxWnNnxGpj9GMh9+EVqm2f54CYhv5jdJxKV7hliBA4eRQdOd3Q4nekNu65LU+Sjbo0jk9v1FzL8rv2HUMA2E9JEQic8gL2+iSWqirbDU9LPW83IzWmX8UQlD9y+jFUf3M7eUyAJH9FSLHx+ZPpjFvke4csINwQZH2xpWfu+6OgK1p8ZRDKe/yvY030P2e1ZpBgBBqb2Z7++GjVReC17zOzpISmidBcrYAvzyK1zwB5e6tkufFKjjmSX7renKcad5agMa+nLe5icOmNAQa007A1wU+yKCfmgchNwT3MJowmKTiDk885//nFwUu2QEU/b3FuKryUGvoBGQq6ykqzPVX+3eKJnpovLFN4qpaUV8bKrVAsBHOo1t93tIXWCMObDrhWiLUCQRab9BeGsLCy/w4LGLEfiTCtR95tYHVKaFunQJX7Kjam+Mtfk1pdRdyMWJ8yIeGn0UH9Qs1l9fLw+AJReqjTw8lMPs7v69EA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8124.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(7696005)(86362001)(6506007)(9686003)(83380400001)(55016003)(38100700002)(2906002)(316002)(38070700005)(122000001)(45080400002)(33656002)(508600001)(5660300002)(966005)(8936002)(7416002)(66446008)(66556008)(76116006)(66946007)(52536014)(66476007)(4326008)(64756008)(8676002)(54906003)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?yBFw+6hKDKN2RTdSErlttDhdLbELI8g1WPNwAXo0psSkw6RXne8ovNLU?=
 =?Windows-1252?Q?RRF7/UZ5KPtGzfTA7Xftfe+LWDezsAJ8UM6LEOyzfuJB/gkN00/rgooE?=
 =?Windows-1252?Q?24KAdpCDj5tV6iOEsgmbJ+L1t8jFmL1q+zG/qsTPUG+kvCc5/YZS2MmE?=
 =?Windows-1252?Q?/27Eyj7D0XQ4Kr46K+ua9mU7EVotzju0QlfHILOebys+NQ9vY+68Z5dn?=
 =?Windows-1252?Q?kheOKECzQsdI4dLY//Py1Xk9PqnQzvWyQSy+GlpmBt1edJAqA5feG+N/?=
 =?Windows-1252?Q?QjMLo6BdQJQk5E0Z/FAmWwc6iULioKRehP6/fgYi9leODBhbefFrsh6H?=
 =?Windows-1252?Q?eB83C6nRpdk+1rPXXpi1cuvDPLFfP6bnmv9re5XQpKWqqjBGugDYbAYS?=
 =?Windows-1252?Q?Yjko6vLWBvc2MJOHAleE2d9aN9Vio5h5y/0MGgy8U0AC1mVH4xiZxOYP?=
 =?Windows-1252?Q?L4aQLzMgfAzurdvyUyM7GdGFuWMhquBFOfXitxbipRK6FXBlU3nBkqoH?=
 =?Windows-1252?Q?h3QO3Nwb6oo80V/9v0xZVB0Y6khqTP+sjYFLWxSaAMFzXmBpPX/g9YWl?=
 =?Windows-1252?Q?Qx4ugsfwnMI21FDRSsBiXObucl7mXg48L/IW3CGAwgyYXCADlhPxTsQF?=
 =?Windows-1252?Q?+cS+xel8bCn3kkK3LaC1AU4M4Eetan8pE4cQp9JybnH3ohkpMJLghcrN?=
 =?Windows-1252?Q?JQsmxigHOBxTBAuoCnw4E/NL0u+i1sCU+jN75Gt617Jw7y6/BO9nXT0W?=
 =?Windows-1252?Q?3XnwtCT11xhq7RkATiKWDiYne+XidXs4VE1TX+lmPoYBoIrwvZZWfz8u?=
 =?Windows-1252?Q?duk/MVhOKgEX4c3oYfWTHFZc7FjumKmsnRkKyVp/F3xBqpHVAQ6E9606?=
 =?Windows-1252?Q?HtfbtKxdbX/r860rtAbyabTi1crB1MREMRr7hOUh6V3OQK6TXHVPqYUt?=
 =?Windows-1252?Q?Ah51ei9Yd/JY7TO5JBRXvHwK7B6iKoSauWOpPAYJFv5H/ADmmYGrqMde?=
 =?Windows-1252?Q?dgzQcdAJELLYK84WwqOt3Pea9fFoAT39oWn7hC+eHNYPJ467Ieps/z4T?=
 =?Windows-1252?Q?3gp2LiMtkJieJiFd542Wjlzw59748/OPgYc2AqwqnFcwGWLn/JizPEPQ?=
 =?Windows-1252?Q?afKBAgFKMrpOetxbhmePMKVtJwqQYtwazpSMxgda4ZwLXtP0jnd4BXY8?=
 =?Windows-1252?Q?hhKcx04q94QCndlokuAwS9teQByDlfEMsDFCtQTkwHMszyJBJ1m50MTs?=
 =?Windows-1252?Q?2/htCdOrWfKonPWpZg4+786tXyDgZ6ZksiiWmAVMrSkR072QOLFc5xTI?=
 =?Windows-1252?Q?z4XVUbFpufqAUqCi2Tk7RR+BPIXNOFoKktuRt8PhnXbX7NocYUfG7L0p?=
 =?Windows-1252?Q?MQTG4EG6n3OnDH8U2cTf+OglICvWrSWXzSIP5OCRYLJz9poSKC2rN55y?=
 =?Windows-1252?Q?MAi8i5E+ShcQ6CNg6Eu0go+O+Q08mLrz/rDD/FJ2WBlMes3Rm2MSssy2?=
 =?Windows-1252?Q?yOmf9DEm09/fLaql1MEBuQGQF0JW6/JsnEGmYQUbcRi1RCxhGdPusAOn?=
 =?Windows-1252?Q?srwBWgd9ogAJ/x20+RrMzScvT0XD5Yp/QFl/pifeVWKd4NQEguQ6qr4j?=
 =?Windows-1252?Q?NL/wlpxw5TTpVASKGWXxINeau3cOis2jD2kk+g9Rukh2Pk4RpZcWLVO6?=
 =?Windows-1252?Q?19lXJ8S2/pio2O/JyviO8QR9NcjWJiB1KfqYEYW2aI6W71QdRHWyYbGL?=
 =?Windows-1252?Q?Jt/eb1KO17ZW0Dq8XmQtOTTKyFepPhYx5NGeAHyRaTliNXaWMwT9DgOm?=
 =?Windows-1252?Q?s4j2dSMwJDIcNPr8hh4YIPKhiK8f4K0bu6Ad3bHcyMW8Gl44Lg1mjFVQ?=
 =?Windows-1252?Q?mNbEQiMMKwgOJXOHIC/NzP7RozNhj11bWlA=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8124.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34fa056-a053-4681-e4d2-08da4395d4e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 06:13:22.6705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uaWlX0LahxvdBOcwXDPTat34qpzQZJvob4mcWMR3tQpA4EQ+ll8EBXRURGhFtAPgXvtw6XS2nCMfNe574UA8wPEGXcKUYyKtwvZolkWn5rU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5526
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Sorry for being late to the party.

> From: Jason A. Donenfeld <Jason@zx2c4.com>
> Sent: 27 May 2022 22:05
>=20
> Hi Pavel,
>=20
> On Fri, May 27, 2022 at 04:14:21PM +0200, Pavel Machek wrote:
> > It seems we hit some problems, but I'm not sure if they are kernel
> > problems or test infrastructure problems. Perhaps Chris can help?
> >
> >
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla=
b
> .com%2Fcip-project%2Fcip-testing%2Flinux-stable-rc-ci%2F-
> %2Fpipelines%2F549589225&amp;data=3D05%7C01%7CChris.Paterson2%40ren
> esas.com%7C0de8f5ed337148db7bcf08da4024905d%7C53d82571da1947e49c
> b4625a166a4a2a%7C0%7C0%7C637892823031829365%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DP8snmZjBO52JAyScIA4rWmFe
> woxUstyBGl3%2Fvvn%2BC%2B4%3D&amp;reserved=3D0
>=20
> I'm clicking on everything red, and all the actual boot logs and
> execution logs show things passing. Seems like this might be a CI issue?
> I'm certainly very interested to learn about potential regressions
> though if you can point to anything specific.
>=20
> If I had to guess, it looks to me like the "lava" job finishes with
> "result: pass", but never tells the controller properly, so it times out
> waiting for the reply. Seems like CI infrastructure issue.

Exactly that, thank you Jason.
We had some issues with some of the labs going offline at the end of last w=
eek. A bit sneaky because I was on leave.
It resulted in a big backlog in jobs which meant it took more then 2 hours =
for them to go through and the GitLab runner gave up.

I've re-run the "failed" jobs and now we have lots of green ticks.
Sorry for all the noise!

Kind regards, Chris

>=20
> Jason
