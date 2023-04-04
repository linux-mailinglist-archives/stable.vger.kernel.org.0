Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D106D5E57
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbjDDKzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbjDDKy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:54:59 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2112.outbound.protection.outlook.com [40.107.113.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831BB3ABD;
        Tue,  4 Apr 2023 03:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJdZ+uoPVBi7z/ZGBsG0/sMxSbA/z4WSno9g3vjrrdgrzilNFg8yPJ4md5yu6lsES9xELw01g5EG3SVrQgbbrXHwdlEHbtwervwlpI25TBMB2eM3p8ewzEm1Q3npI2/bWs/cWVxjotjBoLu9KAnSJIH/nqMHC4Lw8XzidVbuVfut1oHkRLl+PTVUMq+xwUZyziu2boQnFuEEDdlubT7iy7SJ1FGR+3kq2OZ8bMD7q7aGXEVeIpgC9hUlCS3dwDBcQ2GHOfPQmrSFoEnDJCXm2Q0bMloTG55o7tTI1sX7cZTgPEiEXESbJyDbyj9ytBSnQdjayGOzptQPZ/A+yXXOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuNEA/7RsyENw6ii76rJH5lgk1d0eL+/Ow6qWZuWoec=;
 b=LKhHJkFjE/6I+TGulFXga6X/HqH8JAwVExqiu3sODJUtTgKQlPUW0tgzbfKp98hlo/KZ5NsiMj6VwoMDneF7i8Yn1Xoke0hPyMlxdqq6/vLg6adSDeppXNT4wvGFAamDz8yCrP178PvglzkaSUVPf3sxAi/J4oUHLx4T6Lsoyubg846Q30vqIwLA+DVHXUxYq1C9cPtJzTUZgZB2g1iFyvBSzym0e6cwMc4WudBiqY4+QtVHsZGzMy/WeV0PjnanLxUng0zN7/mAPPSBRWl7AMSjej/j0voGFB7RhRwGLOh23INDd6OZePI5Ehr17Z29XqQmHqq12MRu7TZoKvQ77Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuNEA/7RsyENw6ii76rJH5lgk1d0eL+/Ow6qWZuWoec=;
 b=pjIjMw6vDkDhWBT+ia6l4Y0S0UXZyjuPsni/3TH/KNhO0Eg2uxNu1i5f20c2eOlIsqsCfqXb+THDTZkYBpsaRot6IBd2YVnnccI4HKjjctQu4BL848J6pnsVyBT5ZhFwn98Tsjc0mOU/9nUcWWw/qpFuaf8gTzCkeARq4ktx9H8=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYBPR01MB5406.jpnprd01.prod.outlook.com (2603:1096:404:801e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 10:53:53 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:53:53 +0000
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
Subject: RE: [PATCH 6.2 000/187] 6.2.10-rc1 review
Thread-Topic: [PATCH 6.2 000/187] 6.2.10-rc1 review
Thread-Index: AQHZZjrEXK1v70jGLECRIs8NCA1KY68a+rcw
Date:   Tue, 4 Apr 2023 10:53:53 +0000
Message-ID: <TY2PR01MB3788FA88D8F017C4E7193FEEB7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140416.015323160@linuxfoundation.org>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYBPR01MB5406:EE_
x-ms-office365-filtering-correlation-id: 9b9804d2-3b5a-426a-8535-08db34fae1bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9nMsXI4TjWLWRji75FIH55XwLHWoI/2ZA8Txyex7bIUryOXlNrSSCtalemgrfLrdz2aJ6S5J5AiRJZYR2ouwsFEulmrxvR3L50ztnOwW+GygzSv25wyBZvO1xli11oMPn9pZDSE8K6DyWWXxX6vH7YF6Qu1vWVctb7OJuI9zjKIv+qT9iN47EBCbvnJsp12ScvAtiR816KZOBfvlfHPzVwPPO8mY8HChk+CDx6M7E/rP8SWlwcWI/8bG4U9+x+/OLfCwLY7g2BdACly47iXJWfJj6zHx/vCa8p3dvr91nEVx7j4WrrRceUe6N8ijAzXMGNjiiNmxNlnQ+wHS9ULfz1Y11dGOTIN7pbVQ2FmSdPLJyB7eh8EujlF20ye1ep4McEUw+yvGClsHDMByPIkL5CzevNkRJZ6rgybv3KtqIxwiejl4AygjEcenSJm5vcOCbbfD73Aupzw4aLd4fnFINerWohhsAYThbO2ecDgzR61K1FKAw7GnilBSVUSeDyWYfXJaP7cwQG7KDF4IjiBDsSIiA8Ey44nGzMpZHA4WsvN02S7J4sr9GRc46i/4ljpsukahiMGVEyw2Oz898oFryZE+qtRXv9Yjn83vv2ifJNBnGy/mfcsBfK5YTRehVfHfgd8ZH2P1sW1HRGupuh8oWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(66946007)(26005)(9686003)(6506007)(966005)(122000001)(66556008)(66476007)(38100700002)(41300700001)(7696005)(71200400001)(186003)(66446008)(54906003)(110136005)(316002)(478600001)(7416002)(2906002)(33656002)(86362001)(4744005)(64756008)(76116006)(8676002)(4326008)(55016003)(5660300002)(38070700005)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVFRbS83dzY3c1MvNEhGSUh3dUdMQkZlQ3ByNHl1V1JxTUp6ZGUvanZmdG5o?=
 =?utf-8?B?YkhNb0lRYkNMYkxoOEU3ZHdLRG9yME9OaXNvVkxWRTcyQlNDVExSTFkwbnYx?=
 =?utf-8?B?V2w2Tjh5bkZxM1Nsb1ZuRG9odiswdWJKU0gwYlp6Vno4OXBrTVA0K1BqUFlM?=
 =?utf-8?B?ZzlZcklTeVgxV3krZnAxeFhxcU5abDZWTy9hMFR0aitEd3JIdThobmZCKzF4?=
 =?utf-8?B?V1lmaXFUYTBnbkNPZkRVSkdZaUlLSkszZ1BpTmhKQXAxZkFpUUo1TjcxRmpD?=
 =?utf-8?B?WVFRcEcrVDFjMnFxQXdzYWRwempjREUvSWUvZVA4a3dTcjdab2d1cGJIQjls?=
 =?utf-8?B?M1NJeStKVDRrd0pmM2NTUU5ERXVFKzhZaTBLQm5SK0ViRjFWK2ZCbUhTeFVp?=
 =?utf-8?B?SGRHekZHdTZJTzI0VkhpVW5EbFY3VDNmTEhtZ1NweWZZM21mcHRXNnBnblNr?=
 =?utf-8?B?b2IzdFAwQWtFRktFNXpVU1pEYy9laFgvVXNTMFNkbzVWRGtNQWtsVGtNU0ZM?=
 =?utf-8?B?QWRycEpBYkdxWFVDUXFrRDU4L3JvZXNHTnhYd3NFM0h0NFVYa1hGL3B6QTg3?=
 =?utf-8?B?YTdaVFRZWm80cjB5V0Z3aCtuS01nd1lvTkVDRCtaVXNmWFovbm9BN3EvenBs?=
 =?utf-8?B?VTc3QXhyMFpKNWpwODRDb0xEZUUrUjRoejJPQnJjUnVTTytHeVp0MzV5c1B6?=
 =?utf-8?B?bEFzRDZLYTl1S2RHREVyNFc1UWEwL1NxS0tnNmZnaStIYU5wTmM4OTFoUzZt?=
 =?utf-8?B?b1Q0bWRTM0Q1YWJYTHdRRVhQUndpNXpncnlWdENzSXRMU0N5TjVPZkFBamNV?=
 =?utf-8?B?WlhrVk9iL3N2b2ZRNlhUdkVON1ZDWjQ2YzMrOE9rd2pEckFienBnZzZ1U0Ra?=
 =?utf-8?B?TW9kTHBxM3EvT25FQ3dUNTlKWFVMNVhRbDA3cVQ3MHBNUDlRMjhLQWVPM2Ir?=
 =?utf-8?B?S2dYUzZNL0pYZXBsOHBtenhMWWRML1dVc0JjWWUrVDhUQ2I0UVVXeXc3amp4?=
 =?utf-8?B?bUJpSjRFNGRSd0puOXB6Qk8vUm94aE1IQ1RaSW1SeTRhU1dUOTQ3U09ZZml2?=
 =?utf-8?B?MURZVGJ4K3dKTC8yVHF5WmVOS21EZElDeXBNWDlvY2F1ZnJ1Yk5kRUxQUFRv?=
 =?utf-8?B?YTlyYU9pa2xaSVUzZUd0ajlTbHRpM25JeC9yczV4bmN6RnMvWnJib2VaUm4z?=
 =?utf-8?B?NytDZUFXSzU0NU9KUy94dGZhVmtvTmsySTVXTXpSN3d1eEJScFowYWJrbnVG?=
 =?utf-8?B?eEZ3RnRNSGZnQmphM21JdEU5ekE5MzBUa2ZiMzQxcXNib1NoejkyQjgyRmFI?=
 =?utf-8?B?djFFRE4zdzVtZ3pwcUVScEdDOExPZWFhcGxSMDVwd1IwZ3c3ZTdtckF5bXlK?=
 =?utf-8?B?QUlRWVZ0T3oyVmgxdGdUQW5MZ2V1Rm5HaVo4WUZBN3l0UjZrT2ZES2xhdFQ1?=
 =?utf-8?B?SGpsbE45ZGJYM1BZaS8rMHBwMXJXSnBLcHlEanZuT1RlcldMWlArdm1SVHZj?=
 =?utf-8?B?alVNRCtjYW9QNkw1WGVhZzV5WU5GQi9MMGJCcmpFbURWcVN3MVcxejZISHhs?=
 =?utf-8?B?eTBpRlNwVDMvRnFOdHRDK0VYaXpmblVZalhvOUx6dW5CclN3VTh3dnE5TFRC?=
 =?utf-8?B?SHFGc2JGL1RHRjk1dUR3UEw1S1ExcmVCSS8xbGVLYlZZR2dTS3lZaHZyZU82?=
 =?utf-8?B?a3Zzb25RVWU2bnh1dzlkSzhyV28rYXBEcGphRXp2YnhzUzhwcGJ0UkkvZCtZ?=
 =?utf-8?B?NmprYVk0blo5cjlHTTJUaE8rbEh1bVRqOGZWT0V3Ky8vVUpBeEg3dkdGV0Na?=
 =?utf-8?B?ZEtVYWNuV0s5NU1nRFgwWGpvcnJSaXNsaWhPWWZ3K2o5WjdXNzlSSjN2RE9M?=
 =?utf-8?B?QTZpd3ozRnRZSWU2Mytwdm8zT0xtNkJXNWdnNVk5SDcwYlB0NjZZMjJGYmlZ?=
 =?utf-8?B?V3FJWm94Q0ZKbWg2MnFKbTg2M0hhTXlueldNWU1Fc3FnajZ4N0ZwQlhVUy9j?=
 =?utf-8?B?TU01T2xpcTk0QU9hK054L2hWTndmcDFKNGl5SVllYnU3NUFwVG9qZHowditV?=
 =?utf-8?B?WllHa1lvMmFTVnJXQWcwRHZVaWNnUjFmNjFwaXNVTGliRFJoT0NNNVhGN2hP?=
 =?utf-8?B?YVZoMVEzVGNxa3dpOWVjRkh6TzhOaEg5dzlqTnBSdEdtbXhGMDBZYS9oVGJa?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9804d2-3b5a-426a-8535-08db34fae1bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:53:53.6303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HAKwA4ARi2o2vw+jm268aU6Pr5JLCT/oIJQrfjQkE3MDXINE2LhXNxag3TST8xi3/pVZormzev59fVie1ZjxhBsW7cFfm/SgNcXfrugQWxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYBPR01MB5406
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
dW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXksIEFwcmlsIDMsIDIwMjMgMzowNyBQTQ0KPiAN
Cj4gVGhpcyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA2
LjIuMTAgcmVsZWFzZS4NCj4gVGhlcmUgYXJlIDE4NyBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBh
bGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9uZS4gIElmIGFueW9u
ZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPiBsZXQg
bWUga25vdy4NCj4gDQo+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBXZWQsIDA1IEFwciAy
MDIzIDE0OjAzOjE4ICswMDAwLg0KPiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0aGF0IHRpbWUg
bWlnaHQgYmUgdG9vIGxhdGUuDQoNCkNJUCBjb25maWd1cmF0aW9ucyBidWlsdCBhbmQgYm9vdGVk
IHdpdGggTGludXggNi4yLjEwLXJjMSAoNmU0NDY2YzY5ZTIwKToNCmh0dHBzOi8vZ2l0bGFiLmNv
bS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvLS9waXBlbGluZXMv
ODI2NTY2ODMxDQpodHRwczovL2dpdGxhYi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGlu
dXgtc3RhYmxlLXJjLWNpLy0vY29tbWl0cy9saW51eC02LjIueQ0KDQpUZXN0ZWQtYnk6IENocmlz
IFBhdGVyc29uIChDSVApIDxjaHJpcy5wYXRlcnNvbjJAcmVuZXNhcy5jb20+DQoNCktpbmQgcmVn
YXJkcywgQ2hyaXMNCg0K
