Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99116C1DC3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjCTRYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbjCTRXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:23:48 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2071a.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::71a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74418AF34;
        Mon, 20 Mar 2023 10:19:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9vrfZdGa4esZiHyg5JNMYRzsbNFAfUDVZHucRbDqY6RX3p38uhxJo7LdiHd3G1T0Y/N4lqR554u+i0NZkauqxlfN5pLvcmvngxqKFXW3yYDP6NDtWuJGrEIQGdJl5JguIiDO61wOInRGGr4uJKhfB4YO4bo6D2lCMIVP2lQkbs+46kagPwrEzwWZ52AGiva0eMi51geBoz9RN7GifLURslBQG3tJ7VZ3J9ZbROeireznxW1V1MaKdOymZFmw4p8jlsvRQrXBEbmYFX5ll48Di13YAe1JbamdU3v1tdRpvNCRLwBfKyk10dQRC2Khv11fHqB6r4//9PluF6FHtwMUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJCiLGKGhkdzkbNAqOugJSelabHE6KpynD+M0rPHiyo=;
 b=ZOIblpLnli0ylTcm82DTfcdlBXPbxn9eAW8qm3AAk5ZfiQDp8VlY+jB7slWWQ5St3WUfQgjlbsIIXS/G8/gAtDwddcDrNNNe/LcPpH+eB2Z3Qx98RcqFRUObEvghtjkYf0P/4xsEjzkWWk3JIle+VuOWSkxif2zrpgBbDW5jn6QxGo/Fzt7YgYKZ7k77uwImjmr/Zaie2vjsfPrgzZeY6ZqInn6O9h72fEoPHojsIN2AFi2//4PLrsRH1wF24OrSU/cBsaTbNqt5rN3K5lVJiTUrzYRqNoD4NmUyLTsiQKp9ZYA/uCJtD8vQ5MKekDrmdbkkzvB5fDvS9/pPNiid+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJCiLGKGhkdzkbNAqOugJSelabHE6KpynD+M0rPHiyo=;
 b=J9ugsMPg++LcepOhMhsrbv/U5jj+LXqSC/H+6SNeIa5doDGYlc6EbNzODRO8RJ4OeTiYOD8AL0+1Bb3ELMmKjpquGTESNmZ2jOdYpHBibsIr7qP06tKbQA5tNCNijDmf1pWwbcRaBloudm8FP3kxO8S3AbXBe33/qPMNTeSLEkc=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB10457.jpnprd01.prod.outlook.com (2603:1096:400:2f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:18:41 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:18:45 +0000
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
Subject: RE: [PATCH 5.15 000/115] 5.15.104-rc1 review
Thread-Topic: [PATCH 5.15 000/115] 5.15.104-rc1 review
Thread-Index: AQHZWzyL3h5EAcsEwk+TvAtOtKyDoK8D59Lw
Date:   Mon, 20 Mar 2023 17:18:45 +0000
Message-ID: <TYCPR01MB1058811C3F6C03462F6D8A07AB7809@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230320145449.336983711@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB10457:EE_
x-ms-office365-filtering-correlation-id: fdfb586e-d900-4f02-21e3-08db29672937
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4P2jaT2oiOKtmQOTrmEUuaL87ye9DbZU4JvJVpoLk3Cuk5TOf0LjX0WQTWz+GT4vPostFhZfpOoFAV1BgIlMPcmbh2FsrbGpL1CS/+us5YZbEVAS/clty5Ggc2oz/uHIAIaZs6Q8IIWn76TPkgGQP70Q+x4wuVLJB5HgJKnckNdWETa05FtqZfHub9KzN4rS2CgT9BBxJJvrkIZ7RIyxah8dHXZPT5Hbmt5yjqx9PSiLn7y3LD8Qqg88sopK4z4jB4ph6dDJy+WHk0+Kz8xsHTsZ6VnUJCSItijNS9jLLb+WRnWrrGiVVsbmMqv3lFt7E8dP/NFJDfMua+rXWGGKXM2DGR2SuKqYffLCmGfdwWAemrGa0LLrvMdROkPFIRUrMxFDi/kN252u4L2SFLHRaHfLJ2Sg9Ss8zt7USTWm5zj3fpUCaPe3weCXGBpfasOY5rHom/X1O6b7elgSOnbfydhZOjZDfiuRFsEwIjYxzkGGH5ec4xe6FbG6h8cY3P5qPhluJ1HQH6AjJxbExtWorvnh8Mw15E0KQXpr50F8ETxHmVCjJpEYTgGNAptWoPnetKT7/+5VGVPyVy+B798gA1Wzzf8vHJN/tYP0E21Y0nZE1U5Q6HQg5SMhgHTO/Z4k50vEyzo7jAmyQP8g5SQL4VKKGuMux9OXYrDtHwgxUV+E1ElDPUbUjgym716u4b32ZRWHTmzBKqPqvGZFXekislD5XgpFleD9tdSwNTk7yI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(966005)(7696005)(478600001)(71200400001)(316002)(8676002)(66946007)(66556008)(66476007)(66446008)(76116006)(186003)(9686003)(26005)(6506007)(54906003)(64756008)(110136005)(4326008)(7416002)(52536014)(4744005)(41300700001)(5660300002)(8936002)(122000001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akhGSGFoRGQxZXd5KzQyV3N3Y29NakhLWDNsZXBSRGw3R1llOW12dFJYU3pw?=
 =?utf-8?B?Z3JwVXNvRDd5eUdvRGhncmlseW5lNUdvd1RCbEdrMHJOR2wwaUxRUVFEcUJK?=
 =?utf-8?B?L1JCdUNxYmQveXVUYytOYWRzK2FYQUJZQnVESFdkRjRBTkVBU2RqRWNObmgv?=
 =?utf-8?B?Q3ZlS0pUL3hPN1lrMVVUZWFLdzlTZVVndDUwbEE2TlZ0bDdPazZvNEFtQnFV?=
 =?utf-8?B?aERNeGdjR0VjdEpnc1pEK1lwcnFSUjNJczMxdVhTRjR6OHM1L1lCZ0RJS2Q3?=
 =?utf-8?B?cm5UTVJldzJXMlF4VnBSUTR4K2IrY3NvTmQxWk9KOGwwMDRQcVB2WXgxc3Na?=
 =?utf-8?B?V2d5V2VrQXBSM20wTjI4MWpNSFB1ZFZUOS8rWk9kbFpqTERuMnBuYk1XNWor?=
 =?utf-8?B?RUsyVmtNa0JXQ3pzV2Z2WGNoSFZidnY0ZDBTbWp3cnlKcjViVnVyVmpzdU5R?=
 =?utf-8?B?REp5WkdNRTZsTVFJb2NWbVd0QzBHUW52S3pDUDB1ekxMUWFHOS84L3A1alZJ?=
 =?utf-8?B?SGcvamZaUXFFaGIyMGg2RmdER0VkU2tEV0k4UmhzM1RidlJJeUN3WnpCcU5T?=
 =?utf-8?B?NjZqZlhPTlBBQXJRcnN1UFJPaFNKRDlmUzJ5aHlSQ0NpbXo3bDhBQ3lLQ0RW?=
 =?utf-8?B?MThSVU9GVE5Ma05hQnYrM3QyMkxRR2FPQTRJTTFTQlhCbVE3anJlZVREWEhC?=
 =?utf-8?B?cVhHcjFLbnF2clp6OVRKYW9Cbmd3ZkhseU9VeTg4SHRNZ283M05OMXlIeU1I?=
 =?utf-8?B?V1VLQU41U29YWDFmVWN5VEQzRkYwYmZnUU5jY0VGaThIT1c5VG1saCtVWld6?=
 =?utf-8?B?TXRCSWtkdTM3dWJsaVo1blFkR1ZodnpMWG1TZm5QczIyc2xWUE9oS2ExODFx?=
 =?utf-8?B?ZWdWM2RZVzR3N2VOMERFUDRPcUdReFZkdDlXaXl6V2hneHpHRlZTSURvTWc4?=
 =?utf-8?B?N09Ub3ZSSGl3d3E4b3RHMGJ4RExyQUIzRERIWFArUkQxRXNIUVBvVVZNNks0?=
 =?utf-8?B?Y21IN1ZaNU0xRjYvTExkT0VxNzZ2S1VMbjFyK1FKekR5bWlPWVVIUzFxeHJQ?=
 =?utf-8?B?U3ZhVXNOMXYreHhEcWJ2a055R0pGSmp3NVpRS0tSaDV2c3V2OEpNR0RoL1FL?=
 =?utf-8?B?SjVvNStGeWpUaVl2NHBjWDRXMXlMNlJ2T2UyaHZjeXU1d2VrdFFZcEhSZFVD?=
 =?utf-8?B?ZHNJT2JkZitVODZHTGxuWTJ0dTJKa2xYQU8xdFlqS2RMdmZrY0tCdjc1MS9N?=
 =?utf-8?B?cXVlazlrS25DL2V0Y2MzSFhyRTZDQW5Dcm9hMks3SFlabUVFRE9Yd1ZRelov?=
 =?utf-8?B?cFJ3WWdOWWNYdVlOaHZWUlhsNTd0RXN5ZllDNkF3SEZtd0c4UDkrNUVnMEo1?=
 =?utf-8?B?WVlxeGxMM0ZCYThCNUYxYkFMSnVGaTJnV29HSkMva1RlOE5UVHdERGhxSG5W?=
 =?utf-8?B?MlQ0UkJGTnRKdnRzNDZDbzc5bFdtc2pFNUI3NmgzTm1HWEdMVVZiekFBL1Vz?=
 =?utf-8?B?Yi9SSFo5RmtncTgwT0lwdEZ5WHpoTmhSRTYyVi9USEVvRGlRS0R4VnpYZnVt?=
 =?utf-8?B?Q0x4QldKNFBXam9vSTA4cEQza29BSmZOU2FEZGtQSXhPMDN1RWxVTmdVZjJT?=
 =?utf-8?B?aU42dGtRN3ozRmo5Tkhvb3FZRlBSWDZUUTBLWVRWY3A5VyszeGJnYllROE5H?=
 =?utf-8?B?QzNndmpSekVGNkNwZjBIRjB2NDM5cUk4NTY1S1NCU0hGMFNYQ20zZGY0QlZL?=
 =?utf-8?B?VkM4clRac3hURFI0MEhHV29sTytuYjNkcTJVT0hxVlk5K0N4dStzZlRQMkJn?=
 =?utf-8?B?QUVSOEtNeHRlVDladU5EMk1nUEloUUY5MEtmT1ZHRjhjQ1ZNMm5EWnBiSzUv?=
 =?utf-8?B?UUl6RVZsdGVpekFhaGphU0hEdTQ3ajFNSEdOMUR1SWI1cE1DZUhuck5OVXVh?=
 =?utf-8?B?Q0lYMFd2MTZxVGxBK0ZDTEszcmNzNjlnSUJBWVR5cmFHUEdvYXlSZmJtMUhI?=
 =?utf-8?B?VS9QMFBpN0tScnRIRktpOGdJRlNuQktvamxLYmRCTEtCajVCYXExQkl0UEFr?=
 =?utf-8?B?QnE0dFdpNE1LdVQ5U0dMVENURkkybVB0RHl0Ujl4aXdsSmp4TEMvMkJ6bFlu?=
 =?utf-8?B?Mjc0R0QxMGw3UHYzdEQrd0J5YWxmRU1TbHFCeGxqcnJTWUZUejhNdjRiZm9I?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfb586e-d900-4f02-21e3-08db29672937
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 17:18:45.2281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVTVH2dkF8cvd1VOgGlCYX1EiVby8+fkTlt3v3JTxla6s7akiYh5uojjvoHpczyR3uXR3FwHZM2kUmFhjvGSXUzH7TOia+s1Cp/LSNUaSjY=
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
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMCBNYXJjaCAyMDIzIDE0OjU0DQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUuMTUuMTA0IHJl
bGVhc2UuDQo+IFRoZXJlIGFyZSAxMTUgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwg
YmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFu
eSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4gbGV0IG1lIGtub3cu
DQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgV2VkLCAyMiBNYXIgMjAyMyAxNDo1
NDoyNiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJl
IHRvbyBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3RlZCB3aXRoIExp
bnV4IDUuMTUuMTA0LXJjMSAoNDMzZGFhNGRlNjgxKToNCmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAt
cHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGluZXMvODEyMTcy
MjgzDQpodHRwczovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3Rh
YmxlLXJjLWNpLy0vY29tbWl0cy9saW51eC01LjE1LnkNCg0KVGVzdGVkLWJ5OiBDaHJpcyBQYXRl
cnNvbiAoQ0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5kIHJlZ2FyZHMs
IENocmlzDQo=
