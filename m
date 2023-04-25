Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A025A6EE33C
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 15:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjDYNjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 09:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbjDYNjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 09:39:17 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2097.outbound.protection.outlook.com [40.107.113.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7C21A5;
        Tue, 25 Apr 2023 06:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTJHFdEubGsIRQe5v9U5xhUQxfRUaZ92X2oerb3qQt1q1rWozl24anzSnIv4LO8ibX7bCg5jQKlfimCpiP75U4iAL+YGRqZ4bz7/NLzWu0355iLQLGl1vtssaAYNRbEy4Zpb9UYjhu62HA8uHAPaWVOa4qQlf2BGRWu9xmJdqHqcIW4AJxsXxvbmPxi4eoVHG92uGU13AGGiyV4VfJFjmxHm6qdS3nikBP+s4bsL0/baU9wQyLoIv8md4JHOaeUQxBTEjNIAWnOamEe37jPGXAGtKPMXvdwNJtzimZRw34ZEppL72PwJoQMDVpfOfzE2K4V5PnFHTuhNEku+0BIpiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQIdzAlnw+nlAu8g25qVLpqeDX74Ab9Hj+zDvmkXPAw=;
 b=Ln2e8JhvEWkwuku88FSUdLc8iL7XkIgWhlvC+ajdR4NX/F2wTwU9x4eEqli8IiP8F58xftarBs4D4O//IrF/HMZnAfz82nciBe3oSfB138wZ11Nea9Gg61opZtUJ5OaefBOUsfl4bDa7F5dpUfaYZgKRFzGdeDb5cm2nc3zOeFAhPfNXhnZxdsxDXhOx4GGcFvVR+p6TxIbEK7IrejPErZxZ3764qDv/9BfhxJr45UFsw/MLunH0mzu0zyVJYLyAMrUj8dfLu46qPKDIOGACierYiqBRQJqM/7fAzy74kWgOPfaWV+WiZM2XI1+eumX6V8FIItvc/ngtLzLrcuJOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQIdzAlnw+nlAu8g25qVLpqeDX74Ab9Hj+zDvmkXPAw=;
 b=XSPAHdjiC81LWLJ8hDuqdIYQipyfpDYq8A8bdz5bB9B+8BrtjUuMk4TdvYHM59E2j4NU6tHJ18/BBxemh12NLDevXoufr1Ai/DrHoVSalwiPtEfqcnA46JvTYM5NfGKyKb79HsiS9IBAHHQl7g7JigL23eOTQ6/HTQMQogLhnfw=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYVPR01MB11118.jpnprd01.prod.outlook.com (2603:1096:400:369::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 13:39:13 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 13:39:13 +0000
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
Subject: RE: [PATCH 4.19 00/29] 4.19.282-rc1 review
Thread-Topic: [PATCH 4.19 00/29] 4.19.282-rc1 review
Thread-Index: AQHZdrJFbvhxgEuBmkm4NN9GA4iYm688CPQQ
Date:   Tue, 25 Apr 2023 13:39:13 +0000
Message-ID: <TY2PR01MB378802C06BE5B02344913DADB7649@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230424131121.155649464@linuxfoundation.org>
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYVPR01MB11118:EE_
x-ms-office365-filtering-correlation-id: e508596a-8c96-4c21-84da-08db45927508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vb3fWmixsmwD13oEXIRDCLN5xyscJFTSmf+MLmscQHLmfQJ45XZUAIjXqYW5LCpPCYJAqyXoVIBQjRupoWaX20eCEx0Wo35gdl3vA4fnMccICHBcz3MZNR2+yukh/bv9HqRyCeIy6vc+lKq/GqmeD0BCkiwiJXZ1vcuPSnp9kYuowwWaYNRLCLy3h2LrCV3rrrY8EwO3eLDUEGRnTffboyhh/LfmPDuZ3a9FcVpNFvxVj7tBbIVmtlOUPz98VmTnDRIch0x9t5faNj+r+pBPU8gO11qGT6q0Zfxb8yhCxHi7Dy7xVsarAcc5naVwHKsfRpLsZgGwIX82lAXzwQ2gEDTHGfggMRc/Lkhahlvv+mc+tqpSnvfaYAhpT+vknKlJhi+EYWisQhXDgpJ1PKGE07D2PfZBRtY8kJbJ4T3ZbQ+TlaE9/LLP/8qmB3jE+qwHRaxrj8rtCov9H5ztj2sQZdaP2Gv5OYKmEzAfqJ3M5VIQxbruKrmZXoQeWDnocuPUsy0eeZHpx2VkuEDj+eOBTlYDgL9iS+VgrShzhj7lukSp2qAwu7ydBSgqfH90TfrRsX6uwTUWcU19dH1eHkbyK2EebIHY6DUSKX6zNeWPI4QjoYJNpcDvknu5d5LXcbO9ECP7tds2cqauQUxtwUbtfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(9686003)(26005)(6506007)(8676002)(8936002)(54906003)(4326008)(316002)(66446008)(66556008)(64756008)(66476007)(66946007)(76116006)(110136005)(41300700001)(33656002)(478600001)(7416002)(7696005)(71200400001)(966005)(55016003)(52536014)(5660300002)(122000001)(38100700002)(38070700005)(86362001)(2906002)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?/qMV2qQpLtTKNH4vwOd0+L36wJa4Hbj/Nkce9b0ZuTxzG26KxNOFZ0PR?=
 =?Windows-1252?Q?mmPePEB/HiTvjwbY/IwvFA1C2EuBUPZVDATauJ9NyHxtIrEfwfw0B6NK?=
 =?Windows-1252?Q?cWqG5C9zsHMSUpCBLNe/4UjGi5ytWY0e7IOQJPOojGyglAgEPNZqaOeu?=
 =?Windows-1252?Q?VRb+FPq7Z54aRGLKkBWJnFIKntwJ4vnhwZVN0OjNC+35x22Z5m49/4GD?=
 =?Windows-1252?Q?fOwKg4PCyO0vk7ZXv87LVSdu8CG4eqAamwrwIKE7eBg/4HiRvmZIgFIB?=
 =?Windows-1252?Q?FrGfapxkNXU9QdSH0RY8shb91Zv6NWmDkYfQHGdItUqW9ymJ53/fUhJk?=
 =?Windows-1252?Q?9yZZ9hAKtWJM/f+PGM7Ryqa1EdVnk56YuCUT5kHpsVrf6YWz+TmyFfKs?=
 =?Windows-1252?Q?L362EWlYL8Fsg/hOq0tCZGc/BUIlyFdguZGmOA3HSkm0DY0TmdOScj54?=
 =?Windows-1252?Q?5ZXSeuN/efBFpzIDsXeHG5NjF2+0Md3T1isERhTpwmokVHkHAGpq9ibO?=
 =?Windows-1252?Q?mFAWpM4b9EJ1RywTVX1wi8mkJ33B1WqOBgtF6vI/UfkWVkTlVbpIba70?=
 =?Windows-1252?Q?mSk6lPUJ1V9v1JDkTAEhUEO9dmDl3qN6hRkr+aLIBcNQhYpA/HEslkl2?=
 =?Windows-1252?Q?VeFjms3ki4WYyXASz4GdBX9ZwcoHU7Kh45/wmHVDist7TcAQhbk7WBOp?=
 =?Windows-1252?Q?GliPjmTU9cX4gZNIVC+LM4MFsiwnWQk3dBekseld0Pq4PxkJEyh+FpBK?=
 =?Windows-1252?Q?A6nUkZYs5MIEAq8Tj3nBIBRzskcOVO0Gdcp3tpnFr55G4WRZlysjsoXI?=
 =?Windows-1252?Q?plB+byV3Xw3sgpiqNz5ixt+Mb/9hfJjHg9AUH1t4m17xWfHMHMO1oPm9?=
 =?Windows-1252?Q?YB0QBBoVSrSfPJlPZKrF2V4/ONor8XQeUd2S1elV7omA7/TETvO/sLMF?=
 =?Windows-1252?Q?kjhxIhiYXJ7tXytifJ0Iey1HcV07OibnSGD739xbehB6O1ixEbWnXZhH?=
 =?Windows-1252?Q?Jmndy/Jod3MZUgV2JByePXEniZQYOgu1GJliFjYLBvR2u0T1rp6xloIX?=
 =?Windows-1252?Q?TWcjc7KkSR5L05MuBLiEgpKrtGjm0k6jBfhJaF0vG0MZ5N4aY1zv71x7?=
 =?Windows-1252?Q?z3PObbz9SGTQ21fxae+o9pjUj0Jf9usUGPG/JFva5xJvLQgu49omFbZb?=
 =?Windows-1252?Q?mPVwLU8hQ+sLDw37WG2gsO1RzGZVzx4b0R9UKWFCDRGbUcMhJLBNfWMO?=
 =?Windows-1252?Q?lpRda9TKsHOi/8V/1Ayl80u7JKVf1PCkXWXY05ctL3FoaFBwGB1GZ9lc?=
 =?Windows-1252?Q?iVEGPyPF1a4NgErYNqxjarRSBFxJElehy14VghrD2vtyOtwiVX3nDqrd?=
 =?Windows-1252?Q?pDVS2cFuTuPn4qizP12Cq74RHlneDB0osBFEmHubUq+qJ5K0CQcvXXYC?=
 =?Windows-1252?Q?7RQaI13UDt0sHAuKEqmAfFkdXpDURKOFkWFJVDdrbXyJSYkcIckLEhTS?=
 =?Windows-1252?Q?irJ25xQLEyrGToOgtrgQ6RSdyw3Bul7m6DUBBTJRIzGkPLOrJt+Xd7dR?=
 =?Windows-1252?Q?rNaeXwKBGMg3wdSVo0ARCwCr4d0dP0M0kqqVTE9D9fbZN5x8baCZWNtv?=
 =?Windows-1252?Q?s6ztLa2q48wq5fmSAYDS91GDlPruI5GPaBNmBba9QzjjdYI3YGJscHeS?=
 =?Windows-1252?Q?d/v9Wg1WKCadrYJUUZIrJS5MRPkqAYH8F7qeP0dq8ylMVGaiXiqCQQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e508596a-8c96-4c21-84da-08db45927508
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 13:39:13.3535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hV9+8hkQAK+6mQftc4t5Vbwg/dZarHL1g7IMEYM1IpnPFnkIPAF9UYqlFfHLaDSWG/VVN6TUDcMpxnreJux5jtxeR4ctEkrS8XuKrT7Wieo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB11118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, April 24, 2023 2:18 PM
>=20
> This is the start of the stable review cycle for the 4.19.282 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted with Linux 4.19.282-rc1 (8ca3c8d28616):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
47551052
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-4.19.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
