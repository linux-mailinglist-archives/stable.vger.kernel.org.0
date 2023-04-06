Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97F6D9C9B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 17:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbjDFPp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 11:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbjDFPpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 11:45:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2094.outbound.protection.outlook.com [40.107.113.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FF9A275;
        Thu,  6 Apr 2023 08:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2zoJNw4YSgbuKh0yPdEolpqOYgQoJSLAZq12XrcBIylQOCg0lkMgug2Ih3xA8mRHlGdm/aP4zxRMQh6/hRH03YROA6SgKyDsLGu8LwNA3gApRY11fdaNt45l/RoT3++hF7CElaEVgepFVpGZUD3l1K8uuXqRl8xGj1ee6nug5dkRpxLeHkM4mLg1ShPr6U3BDSsS3ZL5WsXszEakly6nv0VJ2L1zyb4b4xFPF+p+/k6jyzjQyk9qs4gbt/JpYWQlf54Akeo4AR07i3xs4kr5/Nlfgn1GiMke8BROBgE3OIZ7GfW5PX6a8sIYiGg8knKHYEromEE6lPIdB2YONaDGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MClja9ixxmnV7+DWsvLyrn5eHfVVH7aGlFdhewNXbKU=;
 b=ZwCRN/VI/+thk92AwYyCPB+Qee885xkg+ujL/goIAAdNgczGIbSBsjDaQBAuYUxXhE/BQQ9vH9loLH0ELl1UJALNKiq50heRN5DEThogwX+O83lJBq5L60Oo8kybqJv3dFFwaogd5p3f4fT5MtGxPDfFYdQkQ68r1JlKRamdGYCf4Dqc4wVQP4RPv34I8w549apaOTDqg24DpDTy1l+5S124oeBbNfc7jNoqGecAPmGeoUca11pnLayxtMwkRYKx9WSX19p4byh73h8ep/TG7rRL9eq936Qsvg7ROTUe5Pi78uTMataqUR/Ms0bjfEbBBxHDMpNCXG1t/rKBTTvo9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MClja9ixxmnV7+DWsvLyrn5eHfVVH7aGlFdhewNXbKU=;
 b=GE6VeD5fSGypr5+/41Rewx/V4CeKGcJ5OAauXrfP2FXvyf5n4OwqzLK4tPvPOQGGQJA46NnOvYHo5vLgeop+4idX6B58vXczk1FwUcaATbtGtHSjZ2r3yA/Wx32V8c+86smwvVvcLP1IcpZOWjQftzPtvRJgMSQcHD5ik2M1CBk=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYAPR01MB5595.jpnprd01.prod.outlook.com (2603:1096:404:805a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 15:45:45 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6277.030; Thu, 6 Apr 2023
 15:45:45 +0000
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
Subject: RE: [PATCH 6.1 000/177] 6.1.23-rc3 review
Thread-Topic: [PATCH 6.1 000/177] 6.1.23-rc3 review
Thread-Index: AQHZZ6XsB09yRDFZHEWlSWgc/7XwL68ebg3g
Date:   Thu, 6 Apr 2023 15:45:45 +0000
Message-ID: <TY2PR01MB378839BEF6C3F0AE1FF5F9E2B7919@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230405100302.540890806@linuxfoundation.org>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYAPR01MB5595:EE_
x-ms-office365-filtering-correlation-id: a8db3370-32f1-4672-45a0-08db36b5fc52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eH52MjgGPErzYuCmJHl9IhfLCbNTUITPzNEtHYfl00C+XvNFRceJ+Pc5toCN204+L0YCLto0K9tHs6GNTAGO2laA3MqndbLugvXpXN3aQbrWk0mHx3KCXUA3Hr7fAlCvsI87hvAc6Qsej6sQ+FEl1kduOj/Ups7MZ2VYmqU/hurgmHuQPclOIWbuJuPjCT5lsQxPV4wMK7Zvd91Owk8V2xF1vPJNACy0UiYfxzlsa2v6rpy19a+9uBpDX0ysa0mrmkzg5rOGzVJ78SDbt6tp3YAxQ+KOODhC3UpebEP+e905EjdxqugXXYbkFim0iDkG6vLSqC3Gm9wYc1VWV6UEBZHRGxOMegMyIDByysebGV8/FJc+Zd1s7IudCwD5zbNntAL5bARt9Qu1zDIT0xC6X9Po+Z/yYnAwRTf5E1OKDaMaC0O7nuN3HtPvY87hUMisgXUuyzF9HmebZitxZ4mErSIGmN8w65ik4wg5VwVOolNj87ZltEy73GoKt1aKm+8qA8hyHfLqPgauFyBoGrXdky7jZ7dcXjQ5OGlVkG9+PgfJG80TVPkWQfuqgp1o5IrA2w4xtZarCt6/NN2P8vUVDuqtc/Pfv0O5bE8oAfGJrOsL3Qc4UsWXPheikX+uosTX2L2Wg+CdL9RZ6hy27bBWuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(86362001)(33656002)(38070700005)(110136005)(316002)(76116006)(41300700001)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(966005)(7696005)(54906003)(478600001)(71200400001)(55016003)(5660300002)(8936002)(7416002)(52536014)(2906002)(4744005)(38100700002)(122000001)(186003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eC8yV1ZzcE1NK1E4ZlpVSGt4QmxXK09VeGVSS0sxRmpLZzh1elpPR1FPR1Z5?=
 =?utf-8?B?YWZQclkxU3ZnaG1FOWY3b0hGQkcvdXZaejFleXBTeVdydkhQR2p4U2h1Vlo1?=
 =?utf-8?B?bHltNmlyRERla0NZU0xjWSs3MitqeTY5a1hyaFJoNjYwOC9Fcnk0NklHeHJ4?=
 =?utf-8?B?cnRENEJJZmdUU0ZqTHdQWXJDK05Vd0F6eUkxaXNhYmszQThjalBjVnlSZGNI?=
 =?utf-8?B?bU45UjF4bnZ3Tk1yTjJZTW8vZGRlWm10VWx2UjdSeUxaWHNJb1pib3hYMkhk?=
 =?utf-8?B?LzREeGVzV2l6Mll6VFVyK0xMb0p4U1B0QllGd0FGUFRTUFpRUFE2U1paVWl5?=
 =?utf-8?B?SmdLSXFVQmsvVUtMaVdYd250THpvUmVWNUpVUDBoUFBBZEhLNW9Jcm9rQUVk?=
 =?utf-8?B?MEhDNG1XQVB3TTljV1dtNFozOERTOWR5ZERhUllXajZUOVhMRTYrRVVKUlZT?=
 =?utf-8?B?QVE3TmRRVEJxY0dqL1duUElHS3VwR01CeTIwSHZNQzQ2djlZSUl2TzZ6cUJy?=
 =?utf-8?B?bVRnUlU4cGdaVFA3RU84NUQ4b1ZIM1ltdVo2WU85YUlsMXRJNUhxYnRDSjE5?=
 =?utf-8?B?U2NxNDZHY1NiclBNb3dXdmEzeHJjaktHbTdrSFFDVUNQejU5UGo2eDFQNVRv?=
 =?utf-8?B?ekx6dC9SSE91R09PU1JVNENzK2dmZ0x6MysvN1JFRDAveFlockJLV0FqOGZm?=
 =?utf-8?B?dW9lSDUyZUJHNy91OXQrN3BjbUNtbjkvY1c4RzZoMmFYUE9LRmhGOHNWL2V5?=
 =?utf-8?B?TUZkVHVWRFkxaTFRVk1CMkNpdEViZFZuNkJXUnEzLzhzbTJXajdUSi8xM0tS?=
 =?utf-8?B?Ukc5V2lqOVFoMmlGdzJGSHBTRktUU052UXRhcEh3enN1bDJqNzFrcjRaMysv?=
 =?utf-8?B?aDdKaThjbHB6dVRvZ000aDNPZEhVVGF2ZW1KMktQUnhheXE3cUYrUWJEdVhn?=
 =?utf-8?B?QnAzbmNFckR6aGxmOXozVDBhU0tscTlWUDNyY2FzTE02NGkxbHJJMWlIZEhE?=
 =?utf-8?B?WkkvNzQ5TVg2UkFKLzMyY1BPSUJnNG5WUkpkQlJ1MHR2eXdLb1B5czE4Tmxx?=
 =?utf-8?B?ekxsUmtKMnluNk9sQ09VbEFMY2J0Q24zN0hKTUlOdG9WM2x2bDJnL1Yza2tq?=
 =?utf-8?B?eTJWait3eUVtWnp6QkVvV3p3ekJ3VFV4UE00QkZNYmpmRzg5RDlBNTdCdGJR?=
 =?utf-8?B?b3kxUmF2NHFaSUtmMkxUQ01uK2VmamgwVGh2c0YwVFRoc2YwV056T21peDZv?=
 =?utf-8?B?c25Qd2hqMjFFa2h4cWNMd3FJVzQ2djdDSWVWY254ak96dDhyOGcwcTRkOGda?=
 =?utf-8?B?aFJFcTkzQ1dQdS9MRzlQTGUxWXpGMnB6ZzRLcGpKSFE5eXNuYW5hNzkxcWV4?=
 =?utf-8?B?TXoyMlZva1R1cXloV3p0aG00VmhIVFdGSlVoSmVZS2tOeGhXRUo0NlVkSGpG?=
 =?utf-8?B?S205VzBXVFozZnh1TEQ1dzkrRk90Mks3NFUyTVkyMEROMVJLNU9pL3ppTjdy?=
 =?utf-8?B?MnJ4QkM4Yk5teHFLclIrdWhyOXI2bTRFVWFab1VlcGxreUNpdjRjdGxaMTQ4?=
 =?utf-8?B?UTBiZERyeVFMeTN6VUdJSUJ2czk4UUVnSlBSZDdWb0N1L3pSdnBzTTVlMUtU?=
 =?utf-8?B?VG5uRTd6K1ErbVhQSml6aEQ4TFNnZE9YNTVEWFUweUE0eERiZkRwd0xFL0JS?=
 =?utf-8?B?MWJyZCtpZzFLS1F2MkYrb3NuYkFsd2pSbUczZVJFUDN1UXRiVTJMeWNBbjFy?=
 =?utf-8?B?aEp6Wk1jeGM1Z0ZvN0xEc2xmMGE4K0JDTmg5YjVDNTZGZitlWDJMUEQzUUhO?=
 =?utf-8?B?SHIzWThqR1Y0MGpEYUpEYzVMeVorVXl3dE55OEFtNjU0Rkc1QUE2N2tvM2li?=
 =?utf-8?B?Y3VjenZGL1pXYlJ1dmlJcUF2ZDJqdFhvZ21INnhFYU5lK3g1UllIdWF3czVm?=
 =?utf-8?B?ajJRL2h2TElBRFFhdnRUSGRlRWIxSGlPQmVsbms1M3ZyMWpWVDhXUXdUc3hp?=
 =?utf-8?B?d1lmTTFlaVhpRWJmbENSQ1hLbFpCQTFEaStnQkV2UHJzajlIejFicEhSbUVJ?=
 =?utf-8?B?OTlPZ1Uzdkg4SmxzbUFndVQyWnY5aXBqZjlpcUlaclQ1dU5rcVlCYVJWS3Np?=
 =?utf-8?B?VkZyc3o5bzhpR1dSZVAxVXVhc0NvMUVvTnlmSWNpWVduc01LTUp1ZmZoSXBY?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8db3370-32f1-4672-45a0-08db36b5fc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 15:45:45.2858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZ8snuK3WsKsQ3LJtznGA5lGOjRIwfQQml1VWv7hzw8epBx4l4+3aujR0p5H+qGuHIq/wlTlI31OQO3742neyXJAMGQqyBTtnE5t27yClRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5595
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
dW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDUsIDIwMjMgMTE6MDQgQU0N
Cj4gDQo+IFRoaXMgaXMgdGhlIHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0
aGUgNi4xLjIzIHJlbGVhc2UuDQo+IFRoZXJlIGFyZSAxNzcgcGF0Y2hlcyBpbiB0aGlzIHNlcmll
cywgYWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBh
bnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4g
bGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgRnJpLCAwNyBB
cHIgMjAyMyAxMDowMjoyNiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0
aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJv
b3RlZCB3aXRoIExpbnV4IDYuMS4yMy1yYzMgKGY4YTdmYTRhOTZiYik6DQpodHRwczovL2dpdGxh
Yi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJjLWNpLy0vcGlwZWxp
bmVzLzgyODY4NzM1MA0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2NpcC10ZXN0aW5n
L2xpbnV4LXN0YWJsZS1yYy1jaS8tL2NvbW1pdHMvbGludXgtNi4xLnkNCg0KVGVzdGVkLWJ5OiBD
aHJpcyBQYXRlcnNvbiAoQ0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5k
IHJlZ2FyZHMsIENocmlzDQo=
