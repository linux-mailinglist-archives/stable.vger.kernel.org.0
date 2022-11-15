Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E17F628F08
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKOBQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 20:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiKOBQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 20:16:55 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2047.outbound.protection.outlook.com [40.107.113.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3FB12ADC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 17:16:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QR6QThNxHi6Qti/X5e87n59Cvl5womn6UTMGlrX31eFwB6q01//78muul5M2nTGprCAt0AprLjuS5VPloLd/0sh3EuUZ0w0C5w34KUXVqV9cM089rN3L++ctwsh4oyV5b4Ojfw6r/5x8NIepOHMvfhWxfgcTpy9hepxXyBoAoJ5OFZY3HeItTJlF2V9uRpiYvj5XM8g+LiDFWivU8RDDBOPxx6nzkbmw+JT67ry2U40TnfLTANy6adPsMbxrM+j6BG3dGScsj50FlgYgoHpOOmNI718FkVP2zvrL6C5UVCV6gbe7KuGgzBDu8JM1JM+wecI+kSvcqb7fG69uflzWYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yg0wh3nXwoyqdyPiY2IZKnBJiZ9+Uz/7yT2zPC0OTIk=;
 b=K6qqcYak36vTd+X2/wHzhdY5hG7f5Ggw1YSR8dfRHK8Muow6A6xqZZb15WyFH5VCzSpu1wxGjpP2wxjiB4Fu7or/Dq1u5Kj+uJx6VAILxeJNoSWenWwutVgsa53Nap6GS81/ICz64L60cwwfUL3IYQDOnjPp4EGFY7z5tA5LSKIbP7mozBr41BWiqOnbTCqBv7w4mnbbe67dk2RZphgdloy4wKW2stSihRB1YdYdC/gMZHWPnC763RFc/hQqWElkOcvvtq0z7egESheE6TRmTAaHLZZ7YcpMsxx6+PsilqrWl8luXFItn41eaUjRQCZxKEnHEUp7m6ssFXgWDMj9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yg0wh3nXwoyqdyPiY2IZKnBJiZ9+Uz/7yT2zPC0OTIk=;
 b=Ol6HVQzQ6tw1nUy4eXC8zVuo/YUo5PZVPBd0BQMnYi5f/UFx5wAisua2qWuOuaWvH4olsoYicX+5lC7nGAdpVSymex85zAUOWa1C65PASNYNZ7y8t0Hw7+imtW6CXbXatgujVG51y6TmFwdUviCdjLngLv080LP2dG1+lCPMYeU=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by TYAPR01MB5947.jpnprd01.prod.outlook.com (2603:1096:404:8059::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 01:16:50 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::9f34:8082:cd2f:589c%9]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 01:16:50 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Thread-Topic: hwpoison, shmem: fix data lost issue for 5.15.y
Thread-Index: AQHY+CsHZIZObyRaEEq9Wqzak4c2Fq4+lzKAgABsPwCAAAQmgIAAJ+4A
Date:   Tue, 15 Nov 2022 01:16:50 +0000
Message-ID: <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
References: <20221114131403.GA3807058@u2004> <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004> <Y3LG/+wWSSj6ZYzl@monkey>
In-Reply-To: <Y3LG/+wWSSj6ZYzl@monkey>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB8591:EE_|TYAPR01MB5947:EE_
x-ms-office365-filtering-correlation-id: 879cd925-79a9-4e8e-69cb-08dac6a712ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6lt19btqxYiATl67RFOGTC5wZnf+CAwOeeSANrpL75tBgVyYDfmqJzgXeUcxfT75yGrkTh3Sos2fZnPY4UoAC39TZ9WNsPSXPZb9AVCSvtJBsG91sAdtFJHazJg2ryUYBY8g6J4iub7cpfg7+skmZO7jQiwVS5zbY7pVz2aCpkjppLvDuYVqn0HDnSqrHBlqWAc4wyIXbeLTsDnufBucNM+5orjwUSAtfhmDpmDrn4ehS8r91zZLxnpJ+4w/PzRhyyJkMpWoZefEchGozw9c04kZ0+Z99v9gXv4hHpHXoTWvkmu1acbMuMYpCes9Z0yq0NGhjaclVNub+iQ7gVjXNK/VsdfIryJdc03/fE/yjmtvr+b1/u+OVuFex4b8YZP+KYsTUyDoNT7fPuHoe0SApItDfKU2AcMQMHqqjsQxiKZrUSv3qKWRsZzGVIsiQT160mUwg0X1/ieNcRwAY/dV9EYjvdzqIunIpzypMudUR5KQtDb8ZgC4hOAWEKccHXbx3FwP9JrTuvEJ1Y6UyshDBmfCjAMhQNGMlyud3SBWa9wA1yfRUGSbhxo0y2j0EYTaJws35t1AtDkgxRSunj4PdX7I35Sy+3im8AMyWNNruEsikhgna25hhb3f1K01Tlx4GxvOQztE/qhwsTR22INxq3jEX7ykCDycKIYq8cEqNoXAyuao3WOeww+lb6kM9Tf964qZtTJ+YuH0qQuBzHMr6cCqpJlQ4al6rmL1wAUUsYYMh2E12Pb0zz/9Ef2OTnv06eAGTh1uPpmTfbgzHN6NkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(186003)(1076003)(5660300002)(8936002)(6506007)(316002)(26005)(76116006)(66946007)(9686003)(66556008)(8676002)(38070700005)(4326008)(66446008)(64756008)(66476007)(6512007)(85182001)(38100700002)(55236004)(53546011)(41300700001)(86362001)(122000001)(2906002)(33656002)(82960400001)(478600001)(6486002)(71200400001)(54906003)(6916009)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjR0U3A1eCswV3MxQlNwR3hId29CVytzb1lTZTBNd2JXemg4MithU25lb3ZE?=
 =?utf-8?B?anlPaFJkQkRvSURIYjQxSm1wa0gva2M4V25VTmFMcy9uZ2pORjVrb2FraWYy?=
 =?utf-8?B?S1ZLNm0yRldXL1Y1akU0WHpza0xQd3ZtcXlVSVBqdXFMSEk1TFFiRWJveXZY?=
 =?utf-8?B?ODdhSGEyLzJ4bW1rYWtFK09rcUhCK21KdzJnQ294SzkyYTFkTDFuSE1PNk5o?=
 =?utf-8?B?ZWNscUhlQ08zdTljMjRadG9CenJnb3YrT01oc1orN20xMk1HNS9kWG1JRlNS?=
 =?utf-8?B?TUR6STVhcVlzcm4zOXRleFE4TFZQa2x1WldwYjhMbHB3bWZlcStyVzBTU2tp?=
 =?utf-8?B?K2tkcTQzdkhLTVYwbUVucWlWZ2cxUzNzZmlOb2l4azR1czJ0SjZIQ1YzVjRx?=
 =?utf-8?B?ZDljRjd6VWdUOWtNU3RlQ2FYZzVkSW1BSTJIclllazl6UVdOV1B0VHBRby9E?=
 =?utf-8?B?OGVvRlhBamxuYzlNTzRjQVlYakd2Q1QydURidFhrWGZ5eEl4UFFQOXJUeHlG?=
 =?utf-8?B?YjA5WmoxMS9VUmZWdnBsRHJaNE10OUZ5RTc2OHpncjkvS05nQnVGQWYwRjkz?=
 =?utf-8?B?QnVuZFlXQ0syV1dtK1phcXlrU2JPYWd5VVU1Nk9hNWp2ZlRueGQ0Sy8zU3Bp?=
 =?utf-8?B?STVmZTQ2eUdnUWUvUHlwUHNzNUlNVkNtdjlkWmZqbTZlcHhKa21FZzhkTTdC?=
 =?utf-8?B?bzg2NkszWGtpRjRPazZQV1lrSi9la1pwQ0RMMWF4em0rWXNUV3p0Z2hndXA3?=
 =?utf-8?B?bEg4QnlZKzNZb3ArNk5NcnNoeW5GV3ZWS1NlREViZHpheExzVTl4alFtZTAw?=
 =?utf-8?B?blpqanBLbmlnbWVIVXBTUURFY1hkL1hCOFh5czhZeGJmVEJneUNDSWZyc2Mz?=
 =?utf-8?B?LzhWOVBjMTM4Z0N3WmtBTURPQ2pObXpBZ1E0c1lJVmpGTjgveU1JYy9IZmJB?=
 =?utf-8?B?b2wzWWtiWER2UXJUUEY3MnZKejAvZkhtbjJwTm9FTlc5SkpwZllsZ1dwVERo?=
 =?utf-8?B?WEJKTXdaL2tWOCtXdWE0QjE0dERqVlhycWNmRlNzNGRHdVdOM2VIUmFRcDc5?=
 =?utf-8?B?enEyZGZweitOOXQwUE9QNXlZa2dJcGt6TWFueTF2YUlQVkRmck5Xb1FVbkM5?=
 =?utf-8?B?NlpWc0N4NGNxaWQ5VzA1NXlKdHpFQUdyc0haVDFzdFpwK3ZYckJJNjRVQXlT?=
 =?utf-8?B?aUJxNXNJWkcxMHp6UkI1Rnl5dGNDbnNHU0lDVUlERE1qUWFGeFZyMk94aEN3?=
 =?utf-8?B?ZlJ6cmFVNi9SUFVQMWZnc1RtaEduOVhoV2o0VjdVeldyY29DaHdlZklZUFpL?=
 =?utf-8?B?bmdFTEY0L3djN0tWZ3g1aWtIVHkvaGVlbU9OeWxWa05CaGR1ZEdwdXhpaDRa?=
 =?utf-8?B?YldaeFlQWHA2OFZkaC9GQWtKeFdpL3ZVUUdzNFE1MW9GUVNvazJ1RFFIZmQ4?=
 =?utf-8?B?TWZ3YXA2QzAxVHAreUJiOWw3anN6TFRlNkM5emU1TTFTQ3RYL1FISUNKUnl4?=
 =?utf-8?B?ZnV2TGF4clZoS3FMYnRZaENBdFhqYUdUK3kwamhGY3ZPVW9nQUY0dkVBZmhC?=
 =?utf-8?B?YWxERGh2Y0xXcW4rKzZXdnBGVHBOc1pyQXhsZGJKaXBySjltR2U1R1BoNUY2?=
 =?utf-8?B?RUQ4Y3daVEgvNytQS1FicVYrRzhrZzViaTFOTnFkY2RLNmQwVnRmZEc2RHhk?=
 =?utf-8?B?b0NDb1VtTTJKR25MWDZZdVhZRURhMEprZjduMmd3RUZKeGFCeWdFdVIrbkM0?=
 =?utf-8?B?WFMzS1doSWxRYmFYMkErMkFBZ29Wd3JiK20yUnQ4UFl3UW1VSzA2elcyMVhy?=
 =?utf-8?B?c2RKWS9YUVVPeVBNaFZaVXQweVlYL0JhYjdtRXFnbHNxcHJXRWYwanhqaS9G?=
 =?utf-8?B?L3FVMy9raWFaT0hDc1BET3F1OUhPQlZHdzcrZVpkc2RiZ0hhTHpUSDhWWjdE?=
 =?utf-8?B?MTdQQ05wMmZ6dXU5YnVsbUVYcDVWczJBT1JZVy9JSjMySGliazJhWHBWdkxP?=
 =?utf-8?B?b295WCtNWlo1RXIvb2VBekhMaDBVbFJDbW5VbkxhbWFwdmQ5WkF2VW5ueEJp?=
 =?utf-8?B?WW9aZyswd2RKVFkxNVhsZDF1eTJldDRTeHRLT01ERkpFSU9LdkZnaE1uUVNh?=
 =?utf-8?B?NGpuRDZsWmk2OElMd0JHWm5RWitvVGFlVE92VTMvd1dkNWRKZHF6dnpWZ2ZX?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <487525BAE3526A4EA0C2E7424C9F7569@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879cd925-79a9-4e8e-69cb-08dac6a712ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 01:16:50.5708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ymc/8xmh/Ayns7FIlc3biS+7fy4FQE22jiLAIZCBOivJfpWGiWOQBkw6eOdzSLjnaaHIXZmtkC6LQDM5oIumXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5947
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCBOb3YgMTQsIDIwMjIgYXQgMDI6NTM6NTFQTSAtMDgwMCwgTWlrZSBLcmF2ZXR6IHdy
b3RlOg0KPiBPbiAxMS8xNS8yMiAwNzozOSwgTmFveWEgSG9yaWd1Y2hpIHdyb3RlOg0KPiA+IE9u
IE1vbiwgTm92IDE0LCAyMDIyIGF0IDA1OjExOjM1UE0gKzAxMDAsIEdyZWcgS0ggd3JvdGU6DQo+
ID4gPiBPbiBNb24sIE5vdiAxNCwgMjAyMiBhdCAxMDoxNDowM1BNICswOTAwLCBOYW95YSBIb3Jp
Z3VjaGkgd3JvdGU6DQo+ID4gPiA+IEhpLA0KPiA+ID4gPiANCj4gPiA+ID4gSSdkIGxpa2UgdG8g
cmVxdWVzdCB0aGUgZm9sbG93IGNvbW1pdHMgdG8gYmUgYmFja3BvcnRlZCB0byA1LjE1LnkuDQo+
ID4gPiA+IA0KPiA+ID4gPiAtIGRkMGYyMzBhMGE4MCAoIm1tOiBod3BvaXNvbjogcmVmYWN0b3Ig
cmVmY291bnQgY2hlY2sgaGFuZGxpbmciKQ0KPiA+ID4gPiAtIDQ5NjY0NTVkOTEwMCAoIm1tOiBo
d3BvaXNvbjogaGFuZGxlIG5vbi1hbm9ueW1vdXMgVEhQIGNvcnJlY3RseSIpDQo+ID4gPiA+IC0g
YTc2MDU0MjY2NjYxICgibW06IHNobWVtOiBkb24ndCB0cnVuY2F0ZSBwYWdlIGlmIG1lbW9yeSBm
YWlsdXJlIGhhcHBlbnMiKQ0KPiA+ID4gPiANCj4gPiA+ID4gVGhlc2UgcGF0Y2hlcyBmaXhlZCBh
IGRhdGEgbG9zdCBpc3N1ZSBieSBwcmV2ZW50aW5nIHNobWVtIHBhZ2VjYWNoZSBmcm9tDQo+ID4g
PiA+IGJlaW5nIHJlbW92ZWQgYnkgbWVtb3J5IGVycm9yLiAgVGhlc2Ugd2VyZSBub3QgdGFnZ2Vk
IGZvciBzdGFibGUgb3JpZ2luYWxseSwNCj4gPiA+ID4gYnV0IHRoYXQncyByZXZpc2l0ZWQgcmVj
ZW50bHkuDQo+ID4gPiANCj4gPiA+IEFuZCBoYXZlIHlvdSB0ZXN0ZWQgdGhhdCB0aGVzZSBhbGwg
YXBwbHkgcHJvcGVybHkgKGFuZCBpbiB3aGljaCBvcmRlcj8pDQo+ID4gDQo+ID4gWWVzLCBJJ3Zl
IGNoZWNrZWQgdGhhdCB0aGVzZSBjbGVhbmx5IGFwcGx5ICh3aXRob3V0IGFueSBjaGFuZ2UpIG9u
DQo+ID4gNS4xNS43OCBpbiB0aGUgYWJvdmUgb3JkZXIgKGkuZS4gZGQwZjIzIGlzIGZpcnN0LCA0
OTY2NDUgY29tZXMgbmV4dCwNCj4gPiB0aGVuIGE3NjA1NCkuDQo+ID4gDQo+ID4gPiBhbmQgd29y
ayBjb3JyZWN0bHk/DQo+ID4gDQo+ID4gWWVzLCBJIHJhbiByZWxhdGVkIHRlc3RjYXNlcyBpbiBt
eSB0ZXN0IHN1aXRlLCBhbmQgdGhlaXIgc3RhdHVzIGNoYW5nZWQNCj4gPiBGQUlMIHRvIFBBU1Mg
d2l0aCB0aGVzZSBwYXRjaGVzLg0KPiANCj4gSGkgTmFveWEsDQo+IA0KPiBKdXN0IGN1cmlvdXMg
aWYgeW91IGhhdmUgcGxhbnMgdG8gZG8gYmFja3BvcnRzIGZvciBlYXJsaWVyIHJlbGVhc2VzPw0K
DQpJIGRpZG4ndCBoYXZlIGEgY2xlYXIgcGxhbi4gIEkganVzdCB0aG91Z2h0IHRoYXQgd2Ugc2hv
dWxkIGJhY2twb3J0IHRvDQplYXJsaWVyIGtlcm5lbHMgaWYgc29tZW9uZSB3YW50IGFuZCB0aGUg
cGF0Y2hlcyBhcmUgYXBwbGljYWJsZSBlYXNpbHkNCmVub3VnaCBhbmQgd2VsbC10ZXN0ZWQuDQoN
Cj4gDQo+IElmIG5vdCwgSSBjYW4gc3RhcnQgdGhhdCBlZmZvcnQuICBXZSBoYXZlIHNlZW4gZGF0
YSBsb3NzL2NvcnJ1cHRpb24gYmVjYXVzZSBvZg0KPiB0aGlzIG9uIGEgNC4xNCBiYXNlZCByZWxl
YXNlLiAgIFNvLCBJIHdvdWxkIGdvIGF0IGxlYXN0IHRoYXQgZmFyIGJhY2suDQoNClRoYW5rIHlv
dSBmb3IgcmFpc2luZyBoYW5kLCB0aGF0J3MgcmVhbGx5IGhlbHBmdWwuDQoNCk1heWJlIGRkMGYy
MzBhMGE4MCAoIltQQVRDSF0gaHVnZXRsYmZzOiBkb24ndCBkZWxldGUgZXJyb3IgcGFnZSBmcm9t
DQpwYWdlY2JhY2hlIikgc2hvdWxkIGJlIGNvbnNpZGVyZWQgdG8gYmFja3BvcnQgdG9nZXRoZXIs
IGJlY2F1c2UgaXQncw0KdGhlIHNpbWlsYXIgaXNzdWUgYW5kIHJlcG9ydGVkIChhIHdoaWxlIGFn
bykgdG8gZmFpbCB0byBiYWNrcG9ydC4NCmRkMGYyMzBhMGE4MCBkb2VzIG5vdCBhcHBseSBjbGVh
bmx5IG9uIHRvcCBvZiA1LjE1Ljc4ICsgdGhlIGFib3ZlIDMgcGF0Y2hlcy4NClNvIEkgbmVlZCBj
aGVjayBtb3JlIGFuZCB3aWxsIHVwZGF0ZSBteSBjdXJyZW50IHByb3Bvc2FsIGZvciA1LjE1Lnku
DQoNClRoYW5rcywNCk5hb3lhIEhvcmlndWNoaQ==
