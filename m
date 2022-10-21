Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACE606C69
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJUANB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJUANA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:13:00 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1689D1826D3;
        Thu, 20 Oct 2022 17:12:40 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29L0BvLP2016494, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29L0BvLP2016494
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 21 Oct 2022 08:11:57 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 21 Oct 2022 08:12:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 21 Oct 2022 08:12:29 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Fri, 21 Oct 2022 08:12:29 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kevin Yang <kevin_yang@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.0 681/862] wifi: rtw88: phy: fix warning of possible buffer overflow
Thread-Topic: [PATCH 6.0 681/862] wifi: rtw88: phy: fix warning of possible
 buffer overflow
Thread-Index: AQHY45pdBM12yKu7+0eLe2tpBuSzlq4W+0XQ
Date:   Fri, 21 Oct 2022 00:12:29 +0000
Message-ID: <1ab422def27d43e1866b470a3f9d24aa@realtek.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083320.063888989@linuxfoundation.org>
In-Reply-To: <20221019083320.063888989@linuxfoundation.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzIwIOS4i+WNiCAxMDo0MTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3Rv
YmVyIDE5LCAyMDIyIDQ6MzMgUE0NCj4gVG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBz
dGFibGVAdmdlci5rZXJuZWwub3JnOyBLZXZpbiBZYW5nDQo+IDxrZXZpbl95YW5nQHJlYWx0ZWsu
Y29tPjsgUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBLYWxsZSBWYWxvIDxrdmFs
b0BrZXJuZWwub3JnPjsgU2FzaGEgTGV2aW4NCj4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiBTdWJq
ZWN0OiBbUEFUQ0ggNi4wIDY4MS84NjJdIHdpZmk6IHJ0dzg4OiBwaHk6IGZpeCB3YXJuaW5nIG9m
IHBvc3NpYmxlIGJ1ZmZlciBvdmVyZmxvdw0KPiANCj4gRnJvbTogWm9uZy1aaGUgWWFuZyA8a2V2
aW5feWFuZ0ByZWFsdGVrLmNvbT4NCj4gDQo+IFsgVXBzdHJlYW0gY29tbWl0IDg2MzMxYzdlMGNk
ODE5YmYwYzFkMGRjZjg5NWUwYzkwYjBhYTlhNmYgXQ0KPiANCj4gcmVwb3J0ZWQgYnkgc21hdGNo
DQo+IA0KPiBwaHkuYzo4NTQgcnR3X3BoeV9saW5lYXJfMl9kYigpIGVycm9yOiBidWZmZXIgb3Zl
cmZsb3cgJ2RiX2ludmVydF90YWJsZVtpXScNCj4gOCA8PSA4IChhc3N1bWluZyBmb3IgbG9vcCBk
b2Vzbid0IGJyZWFrKQ0KPiANCj4gSG93ZXZlciwgaXQgc2VlbXMgdG8gYmUgYSBmYWxzZSBhbGFy
bSBiZWNhdXNlIHdlIHByZXZlbnQgaXQgb3JpZ2luYWxseSB2aWENCj4gICAgICAgIGlmIChsaW5l
YXIgPj0gZGJfaW52ZXJ0X3RhYmxlWzExXVs3XSkNCj4gICAgICAgICAgICAgICAgcmV0dXJuIDk2
OyAvKiBtYXhpbXVtIDk2IGRCICovDQo+IA0KPiBTdGlsbCwgd2UgYWRqdXN0IHRoZSBjb2RlIHRv
IGJlIG1vcmUgcmVhZGFibGUgYW5kIGF2b2lkIHNtYXRjaCB3YXJuaW5nLg0KDQpMaWtlIFBhdmVs
IG1lbnRpb25lZCBbMV0sIHRoaXMgcGF0Y2ggaXMgdG8gYXZvaWQgc21hdGNoIHdhcm5pbmcsIG5v
dCBhIHJlYWxseQ0KYnVnLiBTbywgc2hvdWxkbid0IHRha2UgdGhpcyBwYXRjaC4gDQoNClsxXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC13aXJlbGVzcy8yMDIyMTAxODA5MzkyMS5HRDEy
NjRAZHVvLnVjdy5jei8NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWm9uZy1aaGUgWWFuZyA8a2V2
aW5feWFuZ0ByZWFsdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGluZy1LZSBTaGloIDxwa3No
aWhAcmVhbHRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEthbGxlIFZhbG8gPGt2YWxvQGtlcm5l
bC5vcmc+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA3MjcwNjUwMDMu
MjgzNDAtNS1wa3NoaWhAcmVhbHRlay5jb20NCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4g
PHNhc2hhbEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcGh5LmMgfCAyMSArKysrKysrKy0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGh5LmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BoeS5jDQo+IGluZGV4IDg5ODJlMGM5OGRhYy4uZGExZWZl
YzBhYTg1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L3BoeS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGh5LmMN
Cj4gQEAgLTgxNiwyMyArODE2LDE4IEBAIHN0YXRpYyB1OCBydHdfcGh5X2xpbmVhcl8yX2RiKHU2
NCBsaW5lYXIpDQo+ICAJdTggajsNCj4gIAl1MzIgZEI7DQo+IA0KPiAtCWlmIChsaW5lYXIgPj0g
ZGJfaW52ZXJ0X3RhYmxlWzExXVs3XSkNCj4gLQkJcmV0dXJuIDk2OyAvKiBtYXhpbXVtIDk2IGRC
ICovDQo+IC0NCj4gIAlmb3IgKGkgPSAwOyBpIDwgMTI7IGkrKykgew0KPiAtCQlpZiAoaSA8PSAy
ICYmIChsaW5lYXIgPDwgRlJBQ19CSVRTKSA8PSBkYl9pbnZlcnRfdGFibGVbaV1bN10pDQo+IC0J
CQlicmVhazsNCj4gLQkJZWxzZSBpZiAoaSA+IDIgJiYgbGluZWFyIDw9IGRiX2ludmVydF90YWJs
ZVtpXVs3XSkNCj4gLQkJCWJyZWFrOw0KPiArCQlmb3IgKGogPSAwOyBqIDwgODsgaisrKSB7DQo+
ICsJCQlpZiAoaSA8PSAyICYmIChsaW5lYXIgPDwgRlJBQ19CSVRTKSA8PSBkYl9pbnZlcnRfdGFi
bGVbaV1bal0pDQo+ICsJCQkJZ290byBjbnQ7DQo+ICsJCQllbHNlIGlmIChpID4gMiAmJiBsaW5l
YXIgPD0gZGJfaW52ZXJ0X3RhYmxlW2ldW2pdKQ0KPiArCQkJCWdvdG8gY250Ow0KPiArCQl9DQo+
ICAJfQ0KPiANCj4gLQlmb3IgKGogPSAwOyBqIDwgODsgaisrKSB7DQo+IC0JCWlmIChpIDw9IDIg
JiYgKGxpbmVhciA8PCBGUkFDX0JJVFMpIDw9IGRiX2ludmVydF90YWJsZVtpXVtqXSkNCj4gLQkJ
CWJyZWFrOw0KPiAtCQllbHNlIGlmIChpID4gMiAmJiBsaW5lYXIgPD0gZGJfaW52ZXJ0X3RhYmxl
W2ldW2pdKQ0KPiAtCQkJYnJlYWs7DQo+IC0JfQ0KPiArCXJldHVybiA5NjsgLyogbWF4aW11bSA5
NiBkQiAqLw0KPiANCj4gK2NudDoNCj4gIAlpZiAoaiA9PSAwICYmIGkgPT0gMCkNCj4gIAkJZ290
byBlbmQ7DQo+IA0KPiAtLQ0KPiAyLjM1LjENCj4gDQo+IA0KPiANCj4gDQo+IC0tLS0tLVBsZWFz
ZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
