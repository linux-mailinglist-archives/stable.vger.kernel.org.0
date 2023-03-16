Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E606BCD98
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 12:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCPLJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 07:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCPLJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 07:09:35 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2125.outbound.protection.outlook.com [40.107.113.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03333599;
        Thu, 16 Mar 2023 04:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ER/Dx3iXQsvNjiorDHEywOtJTBR19/NnEkDvNI+gqZm3bDFN1G0PQdjrj12vdu3dBS/BaQk37LEjfrYqPO2VQGaCOji6pphEGyIV+C5ujApfW08RR6ekbUjlFq4TEWjZ8MdraSK0yFPXC9r72IZ4csN/Uzs6EBis9MuWx4nrbMSqVMMXKAS+rRBPnf/i627JempNFd8OW/EFU1IPbrZjVqeEY2bZftmYmdKzNaraytIYDMOonUGr+atI5lL8BTc8rfg+h/LSIlDFiMDQ/EM8SV42mPtZ73jLl5sEX0pos6hs9rXRQt8LlsAfl7yoBhPT1Hz5ZZaxFyL3EW7TspzW7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmfALKzXggQogQFR+JahXnPYkDa2OGxcvPeY0Nn6o/w=;
 b=PqSk3ielKDfxgUu4ov2iIlahbQHVGZPI6Rj8be9+GmJdVmfGsl3zzKWU6Fup7nDgHl3CGlzReVx/Tm9O+LU217a/DE3o05oKdwZcA7ysPXb2Krh23uduqpsJwDrJXb7gO0bay9BJFUaDvdfseFnNgWRCbO01uXu/+5vHQVJU2OdBbmA36OgnSjGy/p5W/TNJee2/YnaHQzr8NXbRdFyUgAYWgoWNYY4Lmaxl9gR2crdgjFTBlcuewx+mFPVDgDKpByAdX+5ek6HmNn5JrVim4I0yEK83uj7VqgEDbJwrYH04o55JmBgcIzYRBHXxQmdzQS38ORSp+NeC7CQu6Hv/DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmfALKzXggQogQFR+JahXnPYkDa2OGxcvPeY0Nn6o/w=;
 b=E3HhUzz5FNj1K5avVvRjI5ZILuXUse0EwNPH8OrLsK6Tv5f7wDRjh7UWzK4gYLy9LZc0Z6ueLSgZmwwlNrBPjJ6EWeLoYdrlTYYMbbah63I7zStmtNCLJkFBHMPtvT5J69Gw2i5Xqfn3azmbg97PKK2A1xaLDdp2o+BZXBFV3Hs=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TY3PR01MB9859.jpnprd01.prod.outlook.com (2603:1096:400:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 11:09:32 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 11:09:32 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 5.15 000/137] 5.15.103-rc2 review
Thread-Topic: [PATCH 5.15 000/137] 5.15.103-rc2 review
Thread-Index: AQHZV+R6C95Zf6O8XUuK9JtqO3mzQ679P4Sg
Date:   Thu, 16 Mar 2023 11:09:32 +0000
Message-ID: <TYCPR01MB10588021F75BDA06CF0D46407B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230316083443.411936182@linuxfoundation.org>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TY3PR01MB9859:EE_
x-ms-office365-filtering-correlation-id: 3fcaee47-080f-4277-1cc3-08db260eeb3b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zuWq16kAu7GQB8SEcUEmKMgET+xK40o94gusXT/Ss47ga6kJT3PFyd/47cTzqAsgqJJI6tFffjStKSdF/YQT5eGLnstQAc/qmm/3VPxMHc5YA3MV7x0o9dwrGHBXoN6G9netKhjgP5QO9XQ6A1YVv2KAV6mSN24Idydn08W7Z6zEP7WjWJL4ygJbM2qrebHN/g4gvkEA/oW2BKNcpvyKdWop6Qh5YjLyVvTECG/kGBinH9t68MxQNusJMadGulc9DeQXhy4T/p7wmElKkVA0WYcOdi2C7gxxFFxrnhPZYFpUBJsKk7KtOkw5TifqOfyIgPzUp1jjn6EAm2zkj+/rDe+qPPDtwXqkZ2TtTHNzHWtbCVtCZhNH1QG2iJVgs8g2Yr2x2zkIze3X/1Hi7ag6+rs0ANuwlzC6ZkTi08M27DssMbBB2waqY139TcKoNxRNbCos9uVy2+43NwG/9IuOnA05ucAzQvVOHwDni/xVUqx0TuuTyIhAgn0JEpcBjZ1MjV2gUkBgWq5n+qhT2gzfYP3wlLomA+IJ4SIpU41CBLa35i40+ILVsB2GGISboF+c7KwOXNDemA4itcwGRqU3E5RAngqfIcqh2pHkdah4kYkaWhceHNWTzPIL4RaYlY2lVcJnVZK5Diz3FOW9dkAIP9XVi3f+daMm57JdCEJBNrA3y1dnQ2mhPDykp0rJw5sNd0VuqGdLzQbd+aIghbwmNLmFIcMTFv2Xxs9OfMD8S2g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199018)(86362001)(38070700005)(122000001)(33656002)(2906002)(38100700002)(52536014)(41300700001)(4744005)(8936002)(7416002)(5660300002)(7696005)(55016003)(64756008)(66476007)(9686003)(26005)(6506007)(186003)(110136005)(316002)(54906003)(4326008)(66556008)(66946007)(8676002)(966005)(71200400001)(478600001)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?ZNp6yWzIgWUs99uSmzHTjG3YBpm3Ph2BH5BySt8eb6JwseQJcQlGkqc7I8?=
 =?iso-8859-2?Q?1HJwQyr7qBeDVJVb2CyTt01Uq71Tj18Nsmg7Li2WUJdQvM9ygn6hhY+J/0?=
 =?iso-8859-2?Q?N2Tsl3rkP9ZooSLuJDZ20OtlAz+4r6b3q4PTuURsyUyPLseygewpaTPrZc?=
 =?iso-8859-2?Q?ggqsuo3SslvMlY2Em787NpVgLm1WoCyyCTHBmNCkTTvhtts27m4YIGXFML?=
 =?iso-8859-2?Q?7kFMMhre0jiCiC9Z+vUhfmDuN4kQBDIWPrnLYVhogo99AL9eTFc3/lFKAK?=
 =?iso-8859-2?Q?zQ3UAsi0eNJEViFwtka/cxU43HhQVTojl9ele3xUyvNV/mMoyibMXePequ?=
 =?iso-8859-2?Q?Gxejfi49+4oR04KktWpQTShi3xMuRoH5Ce/2Q2sxxZVEfUVuP4rn1NnM/p?=
 =?iso-8859-2?Q?0czVC79DQsuVYZtEjaYFEg1iuBgHHk4E7L9c20MHL+zErB9SFzngl8bn+2?=
 =?iso-8859-2?Q?x58lwam4L/Zr4VO35OjAgLedWjCRpaDO97NvKCUd6IbTNyV24x+0De1l8+?=
 =?iso-8859-2?Q?6yUxo3Q8SBUZX6gURxPYIyQSHPA77D2cEN/9ZCahbU9LO5tVxn/w//IcSC?=
 =?iso-8859-2?Q?zo9vaqgRRj+M93Pd6xpsxbqMC8SX/vDhn4Vgw71ke8p9eT4gYIjLdI4P/2?=
 =?iso-8859-2?Q?LkPp8nbDrKVL0iDZVDlfTi2zs3VGdTzuoJOeOlMmjxKu3y0C0hbDtgFiB9?=
 =?iso-8859-2?Q?i4EPYwiYVqw2JWo+Sb8hUzr+hvHk21wrmBUjtQGG/FFwCI5wzYWyJ88sQn?=
 =?iso-8859-2?Q?RNkGwf+yssFw+d5a3yrA/Qjg0Q00+ZzdgV502smwv12CmcsiSYCvravilo?=
 =?iso-8859-2?Q?CIX6ZSvFeypm1E3m7cSETspTtwEVBP7Dn3F0gGdwDTTC76PUmF0Z6SV3C+?=
 =?iso-8859-2?Q?eRG4Tc4/+N5EXDwfy9E7rK38/Fkq6qVdASu2BMebNkY0KEHO1//tj4D10P?=
 =?iso-8859-2?Q?Q5j10QCsqag//I50nOblHGrTZT04pso8impTbaUdj8ASgQgWl+bw7CuJQz?=
 =?iso-8859-2?Q?GYEkTXdoD3auH3xj/MFOKC++02Es55Sa8Ud9TbZ/+8An/onUkne+ND0m36?=
 =?iso-8859-2?Q?nGJleWqQof3JjFksufwWfPcv+bFsFSoA0utHuZH9io6al+nrqc+PjWFQff?=
 =?iso-8859-2?Q?Dy/cIivMC+1l1HOWNoySCTIZM8D2BXnsU2QQjI8BUb2zcAkIXvV6T3D4jP?=
 =?iso-8859-2?Q?QKIhEbMeR1f2rEnHR9IrgUtd1o/U0QXVStLqixxj+M4bzSq3/c062jjDbU?=
 =?iso-8859-2?Q?R5qdhDafBqnHOM5MGdmCmUpZTMr7rD12eJGSGaU8F4I7qN7u5C/Pmz+IHF?=
 =?iso-8859-2?Q?2JQvpOr0IecUu263C04M29Tnx45zaqy91z04oviVoLWGYnfq4qLqred2RU?=
 =?iso-8859-2?Q?UtwkxSrRIbZ3hYW8CFN/7PpAoU2QozTCYKWEzpNK+4UJ1G9S6MHYtzHU2V?=
 =?iso-8859-2?Q?3n9v5g0m8UGXD0Qe92lYGhRfuM1iGeBddvvQxppxQz40pMzWz56fg3dMLF?=
 =?iso-8859-2?Q?wqQqv8X6SQR+WLjHX1ZiBkzvAaCWqIkEj2ZW6kRnlHjUmRpN26hYbD64NW?=
 =?iso-8859-2?Q?EkJJ0BNuHKx0cvSqk6KZ1mNXq0gqjta4R5WTscjUm/2+mI3WiRB9du2AJR?=
 =?iso-8859-2?Q?WjnsS9hvtzSGZRaIAiu7wbjPuPhEzRddVsX71wVZwyg2PvxbUkONBhJQ?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fcaee47-080f-4277-1cc3-08db260eeb3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 11:09:32.0350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aix8hDVpVs2LesE9KNWgbG9K6sbVPjGhvh0uFWNlAZiAvIIcbhUO/HbgdGg69DdqcWrJNIpj6T+PRYX43+AucLKuwuMz21pnNRhkqSbyr4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9859
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 16 March 2023 08:50
>=20
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 5.15.103-rc2 (bc64d631a29e):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
08352715
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.15.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
