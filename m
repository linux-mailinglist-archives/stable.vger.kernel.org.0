Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B626CD4AF
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 10:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjC2Idc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 04:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjC2Id2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 04:33:28 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2139.outbound.protection.outlook.com [40.107.113.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B03E44AA;
        Wed, 29 Mar 2023 01:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFpDRiTHT7Ql7xJj40hgoKmLTMDjfH2BM1qCigGfiYjovd66Y4vG7fi+Tumd2BjLPjyCFGXJazfLe07LdIklwRbeJqOpwuMsn71HXqcy7fkWa8mJw3oiZIsTaCG4Zk2jB0TL+J/sRu71KooOuNeglXvlX9Au4Jik/sVvWKYz6AD04vKHyzLYAdZqzRMi9QGwX7Nb/Kdv/EEba7assZMxqtOyiPYfAB9EKUJFHk/pJ9BVDekdypbxgjoc7mr+4fNBzb1N+0hRKNiuW4oxlTswE1dO5rl4wrxKlaqkzQS1ySRVHjIa8PuAAbaqcOGqBF782LqnMo5DXOkjDyn+touzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q89E7fLkQu2DsQAlJ+kVrvtIfrqmiBVFsRShiNZcvbQ=;
 b=k/YuTD0YLJUL4XwoKBVPdwdADdzBJ9VHE307PV6PtXsjXlTQfr2rEsmYBqsvMGA/3jDk6MdX/p9uUk4eJytcGn8cGgkgIQXesjO6+YNI/AmsfttPudBNnbYHhoed5NUCxmXDNJ1WE53E7jSEorEC9T0cr43IsxGN5uB/Yg53FFVWOSQ/RXStRTZE6XHp4ER8wEf20oVmus5p9WE5/dkhYexXM74advVzcRkwkD4XaDImY6ZkigZTMT+OeADkcRpWnkXD6k3SAVXksgiS+A4M+Xyq9swZQ5t+PeGtgJzpnRLIZi/732jIDijoASq95lhh6/Vvf+cps7Nz8Ep1t7o0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q89E7fLkQu2DsQAlJ+kVrvtIfrqmiBVFsRShiNZcvbQ=;
 b=Z7jdPBXSQjDhUulghgP0/6dRiQFVCLs29XMLQM3d0382Qsc0HS3tKtlsRnJFKAD9o4qR1gst+VIeTn843GWie6sPQu3IlUrarPj4AdicwnCvz3MjCpuZKJRlCQ/MwNmBxfHcQgMvXVk0aaxZz7GjzBshFnMsywbBUL7L/q2sR0k=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYWPR01MB11192.jpnprd01.prod.outlook.com (2603:1096:400:3f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 08:33:12 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::1dc8:5434:72a7:eeea%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 08:33:12 +0000
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
Subject: RE: [PATCH 6.2 000/240] 6.2.9-rc1 review
Thread-Topic: [PATCH 6.2 000/240] 6.2.9-rc1 review
Thread-Index: AQHZYYQVCqPfz9UbeE+AB5KnBbwmuq8RbqXw
Date:   Wed, 29 Mar 2023 08:33:12 +0000
Message-ID: <TY2PR01MB3788DE48F45133BAA119BB91B7899@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230328142619.643313678@linuxfoundation.org>
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYWPR01MB11192:EE_
x-ms-office365-filtering-correlation-id: c6718b50-ab5d-47da-a6f7-08db30303c1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Mk7VKmJEf/fGOHCsVjVmUDIJ7KBUykOLN7277vH+8Zg7pr+BFtJUyuoO4pgrctko5VWxRZa+n5VUmynMjZg0i50Bd8i9ACZnARKK9fFAv31P1stxZe5bAbpc8igaNILVdOM3UdFrrZi9HqNGeaEnvC5qvBHn3nTCDvo6UXI/OSwYCwjv35SGDE9GLZ/c0Dp2UmVAWFKP5fsbHm9vUOQTwvMH9dGEyKRduhiOAxibUEVtGzWldAjtkLgnrk+9e38aMoVXWAYPwjmL5/bTWDioLUhZvY4pB+OILaNKxE62Z+wzssy1tZ95wNkB/S7m7ACUNBktDtUO9edKBQInroSSwp/M9u4S9GgtOjyQURIpv9VXIpTWCzIsijx2Of67QRWEMUv2fXr6OA2MNbgmjDJZ5Hunbi8CdY+GuUK/3xYgRliM+zZ2Iivo9cPC1+cNCoSQYs+50D1D879BWpKKOKyoRD6de7qvfGDN+I+6ljyE8UEQe2BjT9SwsnYS1Jwbz1gqA5+bkLaimtZdl0NplNKe7nRVb60AatHQqwnhkQu8qo/eJdYGtPwKHE2NMFqF7RJUgq59Xv3I4WgRNC0h8O7KcjO5oNOBZhrXeKPpkvEbIN+sROpRJGMugLktt7Ag3Eky0NvPm8m2CHRdF+klCl6Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199021)(38070700005)(33656002)(86362001)(2906002)(55016003)(966005)(26005)(71200400001)(7696005)(6506007)(9686003)(478600001)(66946007)(66446008)(66556008)(64756008)(316002)(8676002)(54906003)(66476007)(76116006)(110136005)(122000001)(52536014)(4326008)(186003)(8936002)(5660300002)(7416002)(38100700002)(4744005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGRSSkxJT0R5Z2dVMDc2aTdsMTBSWTFvVGQ3OWpuaDQxWnM4YkVXRVIxMnNn?=
 =?utf-8?B?S0NwY1YvZXNXODlsZDNnejNHNzdoS25mcEY1eU1BQnhlUXh5bXRKdEswbTJp?=
 =?utf-8?B?TXV4MlplOG16dXZ1QnMxUVl0Z0JZN0JRam1RSzY1anh4Vit3ZEs2eEdQUjZE?=
 =?utf-8?B?MUV1SFhqdlB1SjlUSmN4emxFaGhXTEs4VU02amdZanVYcUozSTJkNWYwN3ZC?=
 =?utf-8?B?Sng1MXorMHpaWVZGRlNtei9DVDNxKzVHTEJUbVBmNFNjbzN4VXFHSWtkc25r?=
 =?utf-8?B?VWNNeXMyUlFtdXZNZmRpbE15WmNDVTRkZjVSeWNWbjVVNkYreG5xaExWdmx6?=
 =?utf-8?B?UU8rVFdqVTVHbWE4UFp0aWE3UmpmdHIwZTE2M1o2NUhVdkY4MzR4UzJvMm1i?=
 =?utf-8?B?N1piVEd6cWhvOEZUMHFNcytTQUsyWFh6QWZiR2krRWhVWThhaWVMOWhseDcr?=
 =?utf-8?B?b21hT1BIZWFRU0RXREhCTUY4dHRuTTNETnhpUENyWXZJU1lUSlBWTXcrcEhD?=
 =?utf-8?B?T3BLSkYvM2pON2l2K0lmeHgyQ2pRbmlMR2xHY0xhZ3huK1VwQ2gxQ0lYMVIw?=
 =?utf-8?B?dk5OYTJDZThXTFVpOHRmNTVBa1dQdlNtMTNHb0FJKzBmR1J0bGJhTVNxZEhw?=
 =?utf-8?B?U3JCdm5FMWtraGg5eUFLRlcxVXA4Y3BUbXhHRUhxNTNUeUdGditBanNlQ0Iw?=
 =?utf-8?B?ZW1qOFNPcXQyeDNOYjMxblN2dlhkR2E3bE5ET3h3dEIvdW9yVGNRNmZwQUJk?=
 =?utf-8?B?UldrN25OcFZOVUZsMnJSWWN0Q2MrQklJT1poYjdReDFZa2M4aXF3UUxybnUv?=
 =?utf-8?B?QlUvZWh4M3VRaUR0WmQxQ1d3eEU1UE5nUWdPOC9VT0tkeVcrV3RZLy8zUzVo?=
 =?utf-8?B?Tm5zRWdDMGsvVitrbTZmMDZPNnEzenRSaW5PL3h3b1RWN0MwQ1J3ZGhVQnJ5?=
 =?utf-8?B?TjVoaFVqTzB1aHVHbHc2UjVTS2x4OHpMKzNRNUt1WW9xZ05kUWhRcjZlaDda?=
 =?utf-8?B?ZTNVU08rWWJWWUJieDVMOGdYbzgxR0NkU3NLRE5BRHV2Q2RHaHlXOGFyU09H?=
 =?utf-8?B?VXEvOTZEWjNkYWMyZE9Cc29sV0MzS0dkR0RhMjMrcEVyZ283VWVFRWxySHZJ?=
 =?utf-8?B?bEZvQ3BpeWYxL2tEN0xyMHlRekFMdklObUdSbXEwVUlGZTBQZjJ3b3Fuaktk?=
 =?utf-8?B?a2F2aC9HVWJIQUdMSHNjeUQ5dXpoOWJmRWcrd0NDbDdVRVJPQkxkVDJCNU5z?=
 =?utf-8?B?RjBTcUxXZGtlOTlhNnNhMVVXQkEyM1BJWW9KODVSdnFJS2l6VlVnbllGd1Q5?=
 =?utf-8?B?RDZBWFZYMXZrNWFjSnVJSzNndDRzNjJRYlAvSVpMWWdxNlowM0psNm04d0dI?=
 =?utf-8?B?ZU9OTWN2b2d0VHVtL2V0V2Z0TTNzUVQ4Smo4TWZsNlc2c1luSlNpbEZlN2hQ?=
 =?utf-8?B?ZURqTksxU2VZZVJzdVJXZitpcTNpV0hFcjlTQkJwU2ZRcTFvemZZVU1WRDlG?=
 =?utf-8?B?bjJ6YVN6WnJRdGZqeG5DdjhuQ3M3dXhoSmxtbUZHYXJyYktnbzhWZVJ3TWpy?=
 =?utf-8?B?WWEzZVVGU014UzB1TVFoczRIS1pLaWNENTlKbE00aXA5V2NYTHJsZjJLaW52?=
 =?utf-8?B?anl2WGQxc1pRZysxUVVXalp1OHBpTjNUampNcWtqWlFoQXErVFNIWHloRUdD?=
 =?utf-8?B?RjhhN00raU8vQ1RsaWFWbmt2clVoa2lVSjhzS0FneW0rQjNVRGtoVkR4MTN3?=
 =?utf-8?B?VlJ4bXVkNEJhS0E3RnFLSXZnRWM1R1FTekd1OUlCaHdCdHhtR2NkY1FwaDhL?=
 =?utf-8?B?Q0ZqaHNqV2ppUDdXV3IrcEk5aldhZG01TVBHNFdDNnhBYnI2TklxUWhVYkdQ?=
 =?utf-8?B?OVBDa3RpYzhONStJRldMRk14UVNLNjVzWTRBcG1HK096aXFSL1JKUE0yNUFH?=
 =?utf-8?B?ZkVMUFhIS0l3K3RQQUNTdXlaZFdwUUtHNW4wamJ4OVI4OFF3b1Fkem5IUWw2?=
 =?utf-8?B?cUx2dW41VG5PM2lta09OekFNYVRLdit5THZjaVF5NVprayszVmxTWjZqamN4?=
 =?utf-8?B?cnRGN3JnUG1VN3FmRFhwdy9oREpiV0JMZmxaMURUNDdySWM0cHlWTnpZakRp?=
 =?utf-8?B?clk1RDlJWTZFZ0s3Z1UxQ01NRnpwM3NISDBHZGtNQmQwRWt3N1dObHJ0RHpH?=
 =?utf-8?B?c0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6718b50-ab5d-47da-a6f7-08db30303c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:33:12.8097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FLuJU7oYdw1P7IMCrUSAJLZ/EqZfHwPHPDOvriTZrq4UfDTxYlFU4I5RdQv4ADbLg67c+/CIppIW7QQIYuXUPRAHdejAqwBxvfHD1RNcKus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11192
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyOCBNYXJjaCAyMDIzIDE1OjM5DQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMi45IHJlbGVh
c2UuDQo+IFRoZXJlIGFyZSAyNDAgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUg
cG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBp
c3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+
IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgVGh1LCAzMCBNYXIgMjAyMyAxNDoyNToz
MyArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRv
byBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3RlZCB3aXRoIExpbnV4
IDYuMi45LXJjMSAoMDk5NzRjM2Q3NjY2KToNCmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVj
dC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGluZXMvODIwNTk0OTQwIA0K
aHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2NpcC10ZXN0aW5nL2xpbnV4LXN0YWJsZS1y
Yy1jaS8tL2NvbW1pdHMvbGludXgtNi4yLnkNCg0KVGVzdGVkLWJ5OiBDaHJpcyBQYXRlcnNvbiAo
Q0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5kIHJlZ2FyZHMsIENocmlz
DQo=
