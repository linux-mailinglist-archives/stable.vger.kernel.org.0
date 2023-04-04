Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74C96D5DDD
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbjDDKrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjDDKrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:47:03 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2111.outbound.protection.outlook.com [40.107.113.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A81E62;
        Tue,  4 Apr 2023 03:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYwUpliZiKBov/xFz3GLZCaVJWNJJeLHs8iZWih1mtpQ4ykSQMBEIlOrD7bSW0Rl8WPCfzMvhctua+KuqymFJzyui5EW8ErnapHWCtxke9/D/0NxLTNjuxrwXwQm4hCOU+NuthZcs+dd6mQ4qjR2wrqMfn6BtxZ0U7abXhi77sGiWCOSEf191Zw8+QIMVJCAD7/QZIrmGPfKqyGHyH8uHO5npLONpLnvL8Zl9JLCjJF5ZBF1RDN/RWxutbBcOEv7VGZEuzPMx5bPaTYxuKMx9JrNuwnl4i+73ebM1HXd0sNzwUr6zHyiPb42iEITomuyO7jNP4qaj79ZE/A77AmGJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7euKmCAjJZRC93Vixeo+fO/rq3kjH2uGClO6ddywbIs=;
 b=QFT2ItAtWC+5ALqlMuZ1/RyyMvAoH3xZaq+8+owuo+w0IjT+flTeComjvKE/7xL6+b3DCnM9fHcL5cbLj+GVJfAxC34HbheOCRHIaoZfuy5+Uiw13NNi7XRwc2ni98yufH9pzPlfaRwTyEto54qK0Hj8uWPdMET6+LRIZtU110akp4z4ycOXiy+soOTEPXdxWcuv3TVIWkAdvEMV2jx38QGPfQcZV9A26xXsNT8v7VlQE/BKvMNUJ9ukfTY9a0KkuHJWX+uTAU4IAHNeEgHp59/RNPwKgq8gOZ3TmK2uM7h4Ai1F2XFSagAvwKatphsGxA0CperXr5f7lwvOTbgZWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7euKmCAjJZRC93Vixeo+fO/rq3kjH2uGClO6ddywbIs=;
 b=HH9qVOPyZnIQGRfJEk9nBz3lNJg6ITEedxMmB6aGihRPufpKLJRF3L0bETcSehZEHlTIB4QgAMkYiLYJOvglSVihtSx9EzKthwBalW4ooRPlWQhF/z9JscrU08cfD6LqqgZRqU1DN5HMlQYINyQb+WVNs501dPxQhbnvIRvsPpU=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OSZPR01MB8645.jpnprd01.prod.outlook.com (2603:1096:604:18e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Tue, 4 Apr
 2023 10:46:58 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::773c:e3ab:106d:cc3a%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:46:58 +0000
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
Subject: RE: [PATCH 6.1 000/181] 6.1.23-rc1 review
Thread-Topic: [PATCH 6.1 000/181] 6.1.23-rc1 review
Thread-Index: AQHZZjmcWZRAQ4TkcEW67y6z7FP0Sq8a+IQQ
Date:   Tue, 4 Apr 2023 10:46:58 +0000
Message-ID: <TY2PR01MB3788EA4E76927B97CF9EAA3DB7939@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230403140415.090615502@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OSZPR01MB8645:EE_
x-ms-office365-filtering-correlation-id: 759a17e0-47fc-4d7a-ed96-08db34f9ea2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwQMvj3AxCsfu8ynygQ4D/62/VB4WAJrEUlYdaG2P1blQ3PFqPg3cyC/T5hgmnwkfuY75YbN4IzvU3F8MOi4MYOvSu/tUxPQBjvon6WsDyqF7ZxOWT1caf9/9mTQLueNKg3luOtKwvpHlUilRL5FQeKjpP/ei0hnv878QfWNP4vmP/meZzKC7YG2yVR8cMKIl4VjEIhmnVP1vda9GWyMtdkY6XcKddHoHlecvZCeIrd/DM6MOEp8L5JuU8hE5+AbVmIJy8H0kNmh3D6ac3dGH7jNDQYCC+kmvLF9UG+HR2WVceVtOyrY38SWTvPtPhVk8yvb3PmKJZkkrTVaOHZyM+9mgxiuFVqcx/LniaS/EpZIwYQQs/U/XSXH6ImD3+ZwSI7eacE2jyx/sVypsyaK+XG7oL/0KYNnHoXvZqwjfcexqLCrZtLrM5tjF2R3A7jYvXgBLqDpgBDJUGRBuPt4QYnq4/W+7pviAIM/wgQ4g5CWSWqv4XDyJnHNqxwdB+3wTkrR6dR12fpqKgH+N0bYMCmHbOPzV5g3Bp7gboxI5bYqLWMvy6Fi3VctJMB/U28y1x2w6NqlDfmPi8m00Ub7ZYEsgc273J7kx6VjUhBSTm3vGKNDZu3koyuCpcinU4YRfis0yQaEukMq1nLA0abEYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199021)(8936002)(8676002)(54906003)(122000001)(7416002)(38070700005)(55016003)(38100700002)(33656002)(52536014)(26005)(186003)(966005)(5660300002)(71200400001)(9686003)(66446008)(6506007)(76116006)(66476007)(66946007)(2906002)(4326008)(66556008)(4744005)(64756008)(86362001)(478600001)(7696005)(41300700001)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzRicWxCV1pyS3NFNDRmTndHZ1QwbWh6UUczV2MzSW0yajdkSkZTcEJaUFc3?=
 =?utf-8?B?R0ZWMDFOQVYzMlNucHVuZWxmSkZGYTcwWjFVYm1DaEsyZWUyVkIxN1ZGWkIr?=
 =?utf-8?B?ZFpmV2daZ1czYzNOVUk1UEh2bnlyZmJTdXFDUDZVR0tLU0VzQ1RzVTluRFAz?=
 =?utf-8?B?aEpnYXhlQjB4SnI1Z2RVSjJqYnhSNFNqaU9HOEc2Qk9mWjZmY1N0eTdDMVB1?=
 =?utf-8?B?em02WWNSeGxnSHJ1bVZoaVdRb0VSVm1mOU5sNEhSNmh5Z0taYlJNTE5NYUN6?=
 =?utf-8?B?a0VaWWI2eG8reFhSRlhTSHdvcERMTFJUWmUzSWJpOXdiTzMyeXE3ZXBnd29M?=
 =?utf-8?B?TkFpUGMzaHpzWmo5RnRyclZFUXV2UjViclhKamkwQVlSTE1ZOXppK2wwY0pF?=
 =?utf-8?B?SHlzTENOWmUycURwenlGckQzNUFRVUtOV3RON25obkJNVzBBZnRsTzYrNTNn?=
 =?utf-8?B?YXk0dmhPOWwrOXpsZUJaR0F6VWxwcFNOWWZoMXpqTjN6dVNtbEVlV2xwSnVx?=
 =?utf-8?B?UDZqWVJXanZOZzlCVVRKK1p1YXpEWWJ3TjFwOEF1b0pTbXdFc285TG83WVBW?=
 =?utf-8?B?dEs4VE9HcnhsbUI4bm5aUE1rSkE0dnIwdWFaSlhqemwvdFg5RnBzdFlKOE5n?=
 =?utf-8?B?NGNXWENBYTZwL2hqWFErOWZJOFlKc1RJMHQzMTQyc1o0TDZkUlIzaUQ4M1Qr?=
 =?utf-8?B?S2gwZ3ZNcmdWbTlhMGJyN2N4dWlGL0ZsSHJwY1F3RVVJdzBOcGhhdE9scHI4?=
 =?utf-8?B?SStRWnROVVcyMWhVdW50dDU2bWVXMlk0ekY5b2N2dlpJWWhJN1dmTUovenhi?=
 =?utf-8?B?b1V6VG9sM2pFL01QZEMwekpzWmc4dkRRdm0rbmRnUCswa2F0WGdvekI1R2Vy?=
 =?utf-8?B?Z2l5NFFuWTdRdDAvZG05bFhBYnl6UTZIaExSa1F2QWhwdnhEUjhlazB1ckZ4?=
 =?utf-8?B?NTZVWWU4WFdjNHM0L1o0UlhEejMzTU1MZDZtajE0VGhxcXY0dTlKakRJNkw2?=
 =?utf-8?B?R2YwbWo5QzJQM2FFTnQ1SUJyWEVCYUl0WGVLYys2ZXo5aE9sY3FOVnZJVXBR?=
 =?utf-8?B?WWprSGQrRi81QUdZQ2wrK210aVhrczY1S2UxQ3I5elhLMnlqNy8vS1RQUCtS?=
 =?utf-8?B?aC91c1FaUkUwbTBlVTRwWkJSeXlaOU51T0l1S1VMemtydG9KRGJpWnh4TGZr?=
 =?utf-8?B?WGJmb1V1ZFJ0b1pndnIyWUNEODJETUxiNTVTWkpvSW1zTEZhT1IwN2lyZlgw?=
 =?utf-8?B?VllOMzlveUhqVGdYWWhKYWZWUGhYMGF2RFZndEVVNWp1dHpVam9WM3FvT0VN?=
 =?utf-8?B?TVhqaEJGM0Z0QkUvMktkWGxzYzJRK1J2WXkwVldVUUl6cjNIWGNIUWNlSXlh?=
 =?utf-8?B?YjJoSU0zRmk5cXlUZmZPcjNxZTJtRGhMcjRPVlpyVVIydnFSY2lOaDFpRHd2?=
 =?utf-8?B?SitiL1dwNEMwY0JlbG1pQUVwdkNsOG5NQjNQZnVRTEJ4YjltbEt1YzdMOCtQ?=
 =?utf-8?B?TWc5c3dodGFsb0hYSUlqb1N0WEVCTEdZMW95YnE4cWdDMVBPWno2S2JiTHpO?=
 =?utf-8?B?ZkxCeGxzY2ZUMVUyQTQ2STBpQjcvU2pZMDc5akVHMGlpZUFJREROSWE5N2h0?=
 =?utf-8?B?QjVjb1ZUbW1QK3NyTHlVQkxpT0JmY0paR2tOOUE5OXhkSmhyNWcrcHVpc3c0?=
 =?utf-8?B?eUhiM3hDOS9Lb2RQT3ZseFhWMGxIRVVEM2NTekVKaEZGekZlOVhWT09lYVRF?=
 =?utf-8?B?QlBEVEJUSUVaZ0RvblhDY2EzVkJ2cmNkNGJScThXNnJlcThESjZLSUxrRHlT?=
 =?utf-8?B?OHBzWVJOUlBhMjhjVSs5MG1RenpLTmZvK0dYKzhxU2hVMEQvUnVUQjZiM0xi?=
 =?utf-8?B?QVV5VlhJcTdQb2phaU1VS25DRVh4cXlSbU9SQmtYTm5SbTdBdnljQjJDd1hR?=
 =?utf-8?B?TC9MbXpqTi80UVJpLzZQV01HcjFKVzdLYkgrQ2VuNlkwUHZ6M1dudWxOekg4?=
 =?utf-8?B?QkZaK0F6b3VWaWRSVGMrMHh4RFhRRDdNR0MwaDEwWFJPWTl1d3pqSUdva0N5?=
 =?utf-8?B?bGNjb05LMm50MVl2eWpha09CNHRqeDErR1dMeHlQTFcwVTVlM2dWUEg3dGg4?=
 =?utf-8?B?VWR3dFdkanVIUmF1OSsxQWgxYlpJRytKc2c3bGFRV0dXNXh3Ujh3M0thUmxr?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a17e0-47fc-4d7a-ed96-08db34f9ea2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 10:46:58.3035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v/iJHW0WL/sIJade787CuK5Mt+it67eauXMZ0DaU4CGUFYiTaVvBFBsxgfhyXftcq8NkC1GSSss0sm0I/cT4D4riMGOz5Vx0xgaOPhCnb74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8645
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
LjEuMjMgcmVsZWFzZS4NCj4gVGhlcmUgYXJlIDE4MSBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBh
bGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9uZS4gIElmIGFueW9u
ZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPiBsZXQg
bWUga25vdy4NCj4gDQo+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBXZWQsIDA1IEFwciAy
MDIzIDE0OjAzOjE4ICswMDAwLg0KPiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0aGF0IHRpbWUg
bWlnaHQgYmUgdG9vIGxhdGUuDQogDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJvb3Rl
ZCB3aXRoIExpbnV4IDYuMS4yMy1yYzEgKDAxY2QwMDQxYjdhNSk6DQpodHRwczovL2dpdGxhYi5j
b20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJjLWNpLy0vcGlwZWxpbmVz
LzgyNjU2NjY5Mw0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2NpcC10ZXN0aW5nL2xp
bnV4LXN0YWJsZS1yYy1jaS8tL2NvbW1pdHMvbGludXgtNi4xLnkNCg0KVGVzdGVkLWJ5OiBDaHJp
cyBQYXRlcnNvbiAoQ0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5kIHJl
Z2FyZHMsIENocmlzDQo=
