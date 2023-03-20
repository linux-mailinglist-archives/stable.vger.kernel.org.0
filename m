Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9164D6C1DC6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjCTRYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjCTRYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:24:06 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AEA37701;
        Mon, 20 Mar 2023 10:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2XnWCSU7pV6C+utbbXAt/vQzvII/EncRMr+pRTZ5t5wAG66fBRDGBaaxNv81ce/cRbj2SnGxkVjqTMhvvDOdGR4E8TAEQ9cPiS9QRg8UJYsvXd2KKe1IWDzu16Jiw6VX7dDn+RlI7VAgui8GAelDzc0gtATvwXdS3fBXkAEiQC5pQzYIqUtIY1OplOcxgmpz5A84VRssN83buh0okoeaA0Gtvc9hJEqGTBH2WxR0+qEqriWt6qxBI8knI80rLHIAu5KBv/T0BmJCRXVFZBAQvy+B237bqcaEY1P6kQKZHpGfV7D+IowaMyNilPHeue/z0fy+C7I8YEoJrmqD9w4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yAWDfHdY6Ic4Lvn7m2DjhGM+mmPc/oyTIeJ1MyHHwM=;
 b=C9ImRCic5sycdOXqHWRy+5hNx/3godJwL1MRhhnInYWIo0sgNtTdEbuZuA6FANPbrrDm0Q1SpQNZ2rh7BbLu9lX/iAGZOa+aCtsvmn0REmnXzApKsmxz7WGXand3kUv14qV8fSxsZ7koaqApGi6wty/Rn6YkS5gC/uv7K9QRFyMgR8lWFU0JJwTXE7mRb4n/uK/cxo2Uq9kW+z8wF6IOj8kuRgD4PH5ElzLedNf0yXBYyNi8wF5A2S4EJ2sxYXZsGuej12xaYKPOWnic7Qp+KSdTb4TwwCBDs0yZXCTifSrrLoiySyVSOWX1Fm3YA5lDSnr8s8q2XgbQmaRGvJ9Wgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yAWDfHdY6Ic4Lvn7m2DjhGM+mmPc/oyTIeJ1MyHHwM=;
 b=ZJYA0WUSocffkaYURSkm1S7TXezZDDs1B71y4fvpCek2XUwcbepc/PybHuzSAFSnazxOhAOxi7gy/v7ExmDv5JhITWb+pfmUV7AU2XF/ITU4s9lu3ngzzUn0cx+ZQ3nIleQXQ6WuFsejDm/qH0fJwC+AuQLobyeSroLdj+3QnbI=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:18:59 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:19:04 +0000
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
Subject: RE: [PATCH 6.2 000/211] 6.2.8-rc1 review
Thread-Topic: [PATCH 6.2 000/211] 6.2.8-rc1 review
Thread-Index: AQHZWzzUkIYHUMay8k6S2egBWWfFVq8D5bhQ
Date:   Mon, 20 Mar 2023 17:19:04 +0000
Message-ID: <TYCPR01MB10588664DFC2346C27CD93FCEB7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145513.305686421@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: 9499263c-8cfe-49a0-7468-08db2967346d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 98kNvNfZCF/LH+SvZhOpFPTgEulWQ6iAt5ufSBPI3H/nvR7smbFevsqC75bfY/unA5wZSZXGhw9NSrVWK0Y+L9FunQPmzOnin26AGSONFh7bcCgW+WCigdw2Mjrj6+46EoElU6P9Litebi6OH+LvbeRJtGe0mC1VDSBdlVgrx7U8XwB3+Uh33XUrPEDQ37s0CVtKNhJvXeBkvNPCtMA6tb5llkTa0C8XFHlQPHTz4pP+rFZrQCAcd79/tI44Ov+sS+Zf2z68f607d9fvAA/5YZ1CXJULcZ0Ybl8orkZINnmqNUm6GKdZx3kb0ZbiN0TxbZAFJSH2l12F43Koo0+A/lQKI06MjCjh6El1YdIzt/HrfW7YDcHFGXwqedqPWp3/NdzXai7SxMckZoMLMs9utXvktqkElg1kyzEi1mxJUKBNlAKPc6nqb7gVAfS5qyjW9NEy5qqEiBZjOGegHn026E441/t/vlCQ8Q6JbEiAw+4uEfIFe3WENHKNxVqsvB6AqKW5GRQOBEWkCbGB4eIT0cGeR7eSQiPK4FBsXycn8ADqID86zunCoL0+PlZs9YmdVo6r2UHDMSX//A8Ziquo3YBW15W5bHl4qjsRk0Rc4zKvvQ1T7mn8Otn1If5rysVxidD2Rubf0cW/rMs0pLl2d1BfwbU37szWXSTxT3ML/SoQwtZoHAlLfJdxn5Dd+PeYSZq/rpzJFBO+/3SgX9MU88apuCibCq1Ks1ugJuPnw/0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUJ1YVNGT2tNL1c0d1QzOUpyVlVhbEYrY0NTWFFLUzA0QTd6aWloSk9ZVmRL?=
 =?utf-8?B?Znl0WGF5cHRndUNvWlRpQ0VwQnF2eDJYVHhDTlBZN1hMVGNPSndOdE9JOGJi?=
 =?utf-8?B?Wmw5ZmRiQ2VxdldNMjc5Q3E2QVRFQ3lmK3AzdWw5bDBnb21LYjNQR1l1bU5w?=
 =?utf-8?B?WksvMitteWRPbXFWb3kzY1pvVkdmREoxN0ZaOEFiU0VTNjQrdDBmRFJ1QVRh?=
 =?utf-8?B?cTRhb01na3BqRDU3OXVvekEvaE14Kyt2bHJjNjlqUmFleVNZSnR3NUlkQU4r?=
 =?utf-8?B?eDhZNm0rRXgxSlV4SVFvTDJzY2VPQjhyMUI3NHZZdW1VeTF5RDMrRWtYVGxk?=
 =?utf-8?B?MDgvL2ZIN0JtbVlodXMrVHNVTkUvSW8ybG5nRHhLdDIxYUZ5ZHFzU1k5WEpV?=
 =?utf-8?B?RVI5QWlkS1c2RDRIaFg4VE1adnBTeEkrOG5iS3Zkc1YxL1NsRS9GTDJwbm1n?=
 =?utf-8?B?Z2cvL0VEQXdzOFIyZm9idkZsa1h2OHo0ZlpJMkk2QlZXOCs5NHJDbFl1VHVX?=
 =?utf-8?B?UVN1NWZ6MXJ0L2lPVEZHcVJXRDFMNkRGV2xlVzV3NUxkUG9EVGxnWXRtQ21J?=
 =?utf-8?B?elNmS1R1Vk9rVzd5aG5xU3Q5MHA2THM2M0U1aGxSVUR6U0h4aFkwVmJLMHYx?=
 =?utf-8?B?WGptUVRCRXl3NlNqRFI1b1JFQ0FUWnpEYU5UOGFNY1hSaE1uSG5QQ05vU2d6?=
 =?utf-8?B?QUJhNlNSTWMxVmhnTzNINGVWRmU5QjRGT1cyS0pIak1MdGxVbWVsNUV5Q1NB?=
 =?utf-8?B?TFhLa0p3YlRFV29udHQya29HNG1jVVFPampqR3owcDZ4OFdxdVFwTjRNZWJp?=
 =?utf-8?B?NkUwcCtwakJDV0JabEVCMHFhZkk5U3RqVDR2WFRaMVZ3UFpoYUovZGVCdnV1?=
 =?utf-8?B?SVhGZDhvcURHbUJXU3JWTFZsekNDRktRZ1VibEdhYTF2Ykx1MzJzWVYrbFZ2?=
 =?utf-8?B?ZnV0ZS9KSW4wWUl3MkpyWXgrbGFJZjVGQ1J6V1IyT29xOTBDS0djYVd1L3BN?=
 =?utf-8?B?ZG1ncmxCdWZFYVhSK1BvZzFNTkxkbWpSaExzT1VFMmNwNXhqdTcrVnN3WDhv?=
 =?utf-8?B?OUdVWjJCYVFuVGh2K3plcG9WSlFhUnhnU3FyU283aVRiY2lLbkIzMFhjY1A1?=
 =?utf-8?B?amhaYlNYUkpqTUhpTVJTaXFidG9EcitUb3F5L015SWMxMDBVV0UzMjBOZHM4?=
 =?utf-8?B?WjlEZThWQzdOMVF4UUZTSDcwS004YlVqQjJFL1JSZXk4emNDcVlBb1R3a0lP?=
 =?utf-8?B?SlgvTWprRC94dk9VNmRNcDJjYTZFRit4OFBkcWZ0ZXUreHdwSWpuL1FRZFk2?=
 =?utf-8?B?ZDI3WVlyMzdvRXhuVCtoak4xNEFpWDFmZVRNOHZHbWVycThZd1luT1JYR3VO?=
 =?utf-8?B?bE9YRjZNQmMrVmRseVZvVHdsWXVudVp2RjB0VHNrd01HbEVjTTNjOFY5RnMv?=
 =?utf-8?B?OUcvdEsvSVlxYUgvelZXSWFUUFBqSFNGV0ZvSmJxSTh1WEtYK0RkdXJ1cVFx?=
 =?utf-8?B?MGlsVHEvSDQydEc4T3F2d1U2cUtKSGtNdTI4a3ZJOUE0K1ZGUkttSUlIeXE0?=
 =?utf-8?B?RzBJZllCTDVtMzIzSnA2ZERKdytRWkJmQ3BhczJHTzY5MFl2bUxQOVBmeGZO?=
 =?utf-8?B?R3VmeGNOSjJLVExxM2xoNXd3dE5OVllsQWltc3ZPdy90NXFOSmhyWFFZVTlR?=
 =?utf-8?B?R0ZWZTkxV2sxU1RLZFFscy9NTXJ0MGtiakh0ZGh2ZnE0c2lUeTBFVlFCUktj?=
 =?utf-8?B?ZmhXbWk2UTloL0tmcW03UnI5YTRjd3MrdjFRVWV6TnNkV1VZelJIMXpYeWhz?=
 =?utf-8?B?N1RuQTFmcWhGd0lYRVp2Y2IzWjVwKzJrM2ZGajVqTHdqY2FpTEtnVjlVNytO?=
 =?utf-8?B?THNrd0Z0K240eVIvKzkzbEJpaWd0SlhiUHhMbU0yZHlyRW5VT3czWTFQeXZG?=
 =?utf-8?B?aGdCYW0xNmR3d0kyY2wyVmVJN1ZZdUpJcHhVUFpQeitJTG1mYWVSM2JBelBE?=
 =?utf-8?B?akxKaUdMTVpQNmZnekY2WHlZS2pzRXdoZVJWbDNZc2xJSkdrckRQNzA5cVRJ?=
 =?utf-8?B?OTFmWVBFNXhncDZCU0JzWUZyd1dWUWYxS2R4UnVXYkc0TlhVekRjaENwdlRI?=
 =?utf-8?B?TDdtQVFnQXN0T2FSNmozVE55SWtOT0pCa3NsSmkrUHF5N3RIbTBEU3VqVGYx?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9499263c-8cfe-49a0-7468-08db2967346d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:19:04.0547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HFZurRRYl9FtXzVb+O9W3j2Vq4DeTsF1UqPOekBAfY7k/s/AT3XUB1AukfWi2tqxxtRLbRKjwxoTL498+Vu4sdXteoQ2RIQvxxFRvFieNIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMCBNYXJjaCAyMDIzIDE0OjUyDQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMi44IHJlbGVh
c2UuDQo+IFRoZXJlIGFyZSAyMTEgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUg
cG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBp
c3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+
IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgV2VkLCAyMiBNYXIgMjAyMyAxNDo1NDoz
MiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRv
byBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3RlZCB3aXRoIExpbnV4
IDYuMi44LXJjMSAoYzUzNmY0ODY1MGE4KToNCmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVj
dC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGluZXMvODEyMTcyMjcwDQpo
dHRwczovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJj
LWNpLy0vY29tbWl0cy9saW51eC02LjIueQ0KDQpUZXN0ZWQtYnk6IENocmlzIFBhdGVyc29uIChD
SVApIDxjaHJpcy5wYXRlcnNvbjJAcmVuZXNhcy5jb20+DQoNCktpbmQgcmVnYXJkcywgQ2hyaXMN
Cg==
