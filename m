Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A896C4715
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 10:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCVJ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 05:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCVJ4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 05:56:38 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2129.outbound.protection.outlook.com [40.107.114.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDE059E0;
        Wed, 22 Mar 2023 02:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpT6MeJX6V/RvVk5E7leYl82qqCUv/JpNsJ5FptKqG38CAGk4joJB4laSFL8jzk5ur8qUaLCLzPuw3qRM9O0PWiUUac68XAJDO/NyBY3t4DpEzsB++1pPaNmKEkcz+CX/zrBZkB3bDUrLUdmafz/GHd8QoSDwKQZ7v7kH1FdM+bw7FNlZOM6n+4/E8jsRv/a4E0SIgCQl3m+PvQEYU9Oit2uWJQ/zd+XaHQEsgL5CugKfNZFblKGEZIjeFJCzePv9vy2b0f7H2062bJlloC2sPaOmXvdPJQ7vk3nLVtZxKKoKIx7XAqDJ9PHDVcMTw/AjC7fscAHXs9eezVty5v8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3MMEpnntFRSnAgobOnh/cqO3bbJTsCnKaYxuNfRtuY=;
 b=IUN6rLmGOltzDzyc4Sci+HkSFcDXfPnD5HsE8+o4jeAv63lCIgVz6lhso/Qrs0Vy21htyxxGX5SSAOr4NS7iNBtU2IeKef/QyJOPY72kuJTZix1nXnLaFqcJNUV/6av3cFQBnxAqt5L3yOR0FS7KOKHrgdr31XwHE2xkcnDwVzyjm/s8hADJKLmz1/JvB7RKqdEHDYN88QJFHxE0m0xaUsslqrxKZEc/oY0bI7oNZMANZce7/hdRKlE+jZ052pY4Uhk7J0Y2xUGCuXLQhLgQseODO7hieYRmUuUpkJ3A1pmVXlnAKbE8aAQ5REWhWko68cbplRy/RIlGvh8wlYEHVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3MMEpnntFRSnAgobOnh/cqO3bbJTsCnKaYxuNfRtuY=;
 b=a3efahs/zy6F9Wyagn23SoToQNZCRPy6WGZ28AZsVu87PTjRS4GdsD+7gIlXcfwXepWygXWZEpECeeU+oXBZk9ld3qF1Sr2j34ZQL+OMZg1u5WQWbJMfz8Y/9RAikdEG5IcvW/EY6hYYKWyG+kLY6xtTjVjbHX330dUs/7+c4DQ=
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com (2603:1096:400:309::8)
 by TYWPR01MB9574.jpnprd01.prod.outlook.com (2603:1096:400:1a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 09:56:13 +0000
Received: from TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53]) by TYCPR01MB10588.jpnprd01.prod.outlook.com
 ([fe80::dc49:e307:b424:4a53%4]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 09:56:13 +0000
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
Subject: RE: [PATCH 6.1 000/199] 6.1.21-rc3 review
Thread-Topic: [PATCH 6.1 000/199] 6.1.21-rc3 review
Thread-Index: AQHZXCAorFxkSBgDXUedhBO4QL9doq8GkGFg
Date:   Wed, 22 Mar 2023 09:56:13 +0000
Message-ID: <TYCPR01MB1058877945806A0D0C8F2709AB7869@TYCPR01MB10588.jpnprd01.prod.outlook.com>
References: <20230321180747.474321236@linuxfoundation.org>
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10588:EE_|TYWPR01MB9574:EE_
x-ms-office365-filtering-correlation-id: 214d4b1d-263f-4821-4306-08db2abbac1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QDQOvu16LV7S7NyGyJkwWBJ5a0jPA5LkQ0wrriKfS3c5weUP9AOHfDcva9LD7p3ARjMgUBFZYwU3lrS1+cqw98iq9Oa+ITSC9iRC+qhu+Uh6mqF4uiO7Ckh9EGGVkGLWI1kxNQZHosVyLUDbirOmptznYqhCBi8rXMtjHjXafj5zZryZi+Q+PY/ohT/YeJ80qWtKfA25dj9dxKgC4N6fBvSE4Crx5VFkaxgEWzrWr6uImigoJR/splouJdxlF2pM957BbvFGWhS28v4ccsEYHHFda48ModTBM0o1Ll2Z3ybUu7SJdBDlwOvO4KFLjrTgla6qE8ECbsqLZM8Vc9JI75xLOmgcAsVOFsN7nqlfoJXwImX3SsnkWRMp8BS2tVBOz5gcqWPqB0p53AtjC1vC1VcZab801QygdIg0PH9WejTTsPRzMxSjuUxZmZaIL30QOIOe5CBxdSjW3kgs5TKjiB/JLu7s7hwxKjbW3Db2epKq4geR6dX1kGikP7nNo8mvSUzr6PVUvdQMQsf/M//dtpY9VKCSw5maHs8OIiGynjf1gqJXxMLu/e2c2mrv1UWmthRHKVo+7C0wnQIl3qTclSv03jrUe2F6+QocyiAPzpzqAz3CGsdFk+N2Mh5TheXeXxzSy8YcO8n8f/zuVEilPIR201EtNEuehuU9hu30pJE3fPshefqOcEft8w/+QoYQH/altS6k/wFBA6lUREuTyLyunQdVcqq/azUCQkEUvQo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10588.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199018)(7696005)(86362001)(55016003)(33656002)(71200400001)(54906003)(66476007)(66556008)(4326008)(66946007)(186003)(110136005)(64756008)(966005)(26005)(6506007)(76116006)(52536014)(316002)(9686003)(2906002)(38100700002)(478600001)(66446008)(122000001)(38070700005)(41300700001)(8676002)(5660300002)(8936002)(4744005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmdFV0xZVVNaREdYalJQaGJYMHhvaC81aGpBWVVWdDE0NDNxdVN0aXVvQUd3?=
 =?utf-8?B?Qmw4T1pRMzV6bjY5ZmFxOHpNV2tCaTZIbGI5WDVPcEFMTzNSZVNWbUlSZFB2?=
 =?utf-8?B?YVpYaWprQzFuYW9VVUtFOFpiVThqclpJR2ZuOUZxSHhlM3NMb1JxeEFxTDNN?=
 =?utf-8?B?RDVTdTBERUEybnhHak84ek9DRXd6VFVnL295bGFCMjVKRDJtaTdHaGVKeVlZ?=
 =?utf-8?B?bDdBTjhwRXlsWEJEaDAxUUFVR1p4cy9DUVVSMWhPWi9XTzRGK2IrWXZ2V0ls?=
 =?utf-8?B?aGt1ZGZaY0dzbElGSzV4dVFuNVBTSjM0R3ZDRCtEZlZTTFp0RmgrV0FyM012?=
 =?utf-8?B?b01jK2ZpVzRpZDRnWmZ0T05FN3A3a3d1ZHVLQTR2QUVhMnhWTU80Mk9HeFQw?=
 =?utf-8?B?MGtsQnJyNCtUTDFmZkpWeTZ3N1dCbTlQaVM5Tm5tWTZFa2F2QmUzMUdXVFJM?=
 =?utf-8?B?QUVDVmNBZDZLSTZkblBxNXJ5bld1VVRMUWRjZ1FBN2R1aDNEbXM5Ukh6RzAr?=
 =?utf-8?B?MEFTNDBqcm1KRW0vZmRqcFBxcHcvdHlhc1JRZG1melpwdHBER3VCWGVaZmZB?=
 =?utf-8?B?cXJ3N1RneHhGVXAvOEFHTGl4dllYUEh3TEN5OFhiUG4rdXJialVuTG1qSEdE?=
 =?utf-8?B?N3BlQ3h5QklGTmpRc0NmcHRTaWFMaXJBTCtET3lHdjFzYjNvWmpRdWdQL0xT?=
 =?utf-8?B?WG1BVW9GLzE4enNwdmdzRnYxWVBLZUx6MldLbEdsL0Y3MGZETk1KV0FuOWNq?=
 =?utf-8?B?WmVOSUpncFlJNG5nL3orUWs5NG5pdWExckU2ZHpvMnM3ektaL1pyTHprS29L?=
 =?utf-8?B?WlMvN1BFY2hVQSs3VmZ2dEhrN2RuV2dLMXhIOHdJOUl5RWVDREcyNStPTjdo?=
 =?utf-8?B?VHQvV1lWbDRNTWE2R2c5eVdJM0V1OGloYVlSbnl5Z0VYempWSU11VWZUWXRX?=
 =?utf-8?B?WmxpWDhOU2NHK3loejY1QThCN0JJOXpxYVVmQmRKc0VaNVlCdjhnbC9HbHdS?=
 =?utf-8?B?SmVHQWpKdVZBa3hUUnRpaUphNVNJejZWbDE0SHNsa2dhNHVwcC9ha0ZDdDla?=
 =?utf-8?B?SXdNRWpSQ0pZbi9XdVlNWHc5NG83VHQrN1dDQXVtRWZsS1JiamF6Y2VvQ0Jt?=
 =?utf-8?B?WEpWM1pvZ05ITmQyY3VEbmZPMXIwbHl6amFmTFpRYUdpZHdSbHZRVTJrdllN?=
 =?utf-8?B?ZVRJLzBScEZjZ3RuMTBGcXpid0NldzkvdityNWMxNHIwNmVwR0tjTnpxaTE4?=
 =?utf-8?B?T3JDcEFvSFlyWWNVRXRBOWpVeDFqTVo0SEtNMkpkTXJCWWJoSjVjMlNWSmhx?=
 =?utf-8?B?dGZiZFlMM2N5QnhEUlJreGpXeDdiK3RmZ2NPQks2OHR3eXhTckR4czhORFM3?=
 =?utf-8?B?N3JYQWZPdk1WeTk4cThHWXlDbm9UcjU4RHVYZlhKdFowUWI3SjRKSWlrbXdR?=
 =?utf-8?B?YkZvWkJJU25vOTJGN0x0aU1QTitqeEdyb2t4VkllbWtNRFJxMlltU3dYaWpz?=
 =?utf-8?B?djMrYStaVVdxVlpaVTdhb2RIVyszeStXTzRZeWMzNHFpK0Z1V2J1YTVXV2Ix?=
 =?utf-8?B?clJkZ2ZJUHR0b1c5WXF3OE8rSEpTY2xsTlM2Tm10V1JhTHZlMmNrbUlkdVhR?=
 =?utf-8?B?UFZJWUE4OEc2RGVZczRuQktlaEcxTUFIZDNlUmtxSVdqdFRTc0w2UUJEZ2lZ?=
 =?utf-8?B?NWM5MG9yTzVLakxvWko0RjVva0hHMmV5RDgrYlk0cEtSM1ZOMW55ekdaQlBG?=
 =?utf-8?B?YkxDOGMzZm1hTG1CNXpBYXFOU3BPMHgrREtSL2l3VW5NV2d4OExVK3R2Um4r?=
 =?utf-8?B?SHlIN2N5VEVlVUdYTXUrd0tYS0J3amtGWmQvb1JrOTZtSkVDdmc0QkNBa1ZJ?=
 =?utf-8?B?L25JWldQTHBXMVY0OHMwT1VsWnNpTEsyN2Rlc3YzdlVTVzAvbjJ5Ky9SZHlJ?=
 =?utf-8?B?WGVFejFFQlBFUFFoaGlaL2laSktMZHFRVkJWS3ZoenRiMEFEYXFJOHcrUEQ0?=
 =?utf-8?B?MjVxa0w0L0Q5ajJscU90cFVjSEJHMjVXb1RhUi9ubXFIbFJNZ3FXMGVIMmF5?=
 =?utf-8?B?bVh4aXNXKzFUYmtnV01aMmdMRGRTS1ZZSjJKNE5JanQwbkJseUxoeFJ4RkRv?=
 =?utf-8?B?bTA5VFRSUDJ5V1RnS2dEQlQ0dzFsSE1aMlVqQngvVmVQT2pXSGROM1hKWk9I?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10588.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214d4b1d-263f-4821-4306-08db2abbac1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 09:56:13.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwCFCVPURJ3SryuZ8X8cir5aIkGuutjs0esJl23OwWJHcLv0hFqHgfF4ctV4SuVCGfCj57eOY7DOSBTvtm8UDxBywRyACdORiUbU+NHvqgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9574
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMSBNYXJjaCAyMDIzIDE4OjA4DQo+IA0KPiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMS4yMSByZWxl
YXNlLg0KPiBUaGVyZSBhcmUgMTk5IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMsIGFsbCB3aWxsIGJl
IHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+IHRvIHRoaXMgb25lLiAgSWYgYW55b25lIGhhcyBhbnkg
aXNzdWVzIHdpdGggdGhlc2UgYmVpbmcgYXBwbGllZCwgcGxlYXNlDQo+IGxldCBtZSBrbm93Lg0K
PiANCj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFRodSwgMjMgTWFyIDIwMjMgMTg6MDc6
MDUgKzAwMDAuDQo+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBtaWdodCBiZSB0
b28gbGF0ZS4NCg0KQ0lQIGNvbmZpZ3VyYXRpb25zIGJ1aWx0IGFuZCBib290ZWQgd2l0aCBMaW51
eCA2LjEuMjEtcmMzICgyMTUyY2VmZmY2NTQpOg0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9q
ZWN0L2NpcC10ZXN0aW5nL2xpbnV4LXN0YWJsZS1yYy1jaS8tL3BpcGVsaW5lcy84MTM2OTA5NDAN
Cmh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUt
cmMtY2kvLS9jb21taXRzL2xpbnV4LTYuMS55DQoNClRlc3RlZC1ieTogQ2hyaXMgUGF0ZXJzb24g
KENJUCkgPGNocmlzLnBhdGVyc29uMkByZW5lc2FzLmNvbT4NCg0KS2luZCByZWdhcmRzLCBDaHJp
cw0K
