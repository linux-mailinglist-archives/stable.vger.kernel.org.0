Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413002762B0
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 23:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIWVB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 17:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgIWVB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 17:01:27 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18598C0613D1
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 14:01:26 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8B28B80719;
        Thu, 24 Sep 2020 09:01:20 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1600894880;
        bh=c/5Krfr7PvrTEyKZtronFLGYVTunfBjhz+LCV+z+3NQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=teEEJ/nYFbBaMhLEvXeDfDE2xZ8BQ0g8bneGMe11MOFkNrucjKPfeeNK1Jg6flBvk
         +1dNjs1HCc2mInrPB4X4UHWafCsiDH0pS3puGDYhefX6Y+0eP8+XAoKcD+Y8hbdJz8
         lrq3LhF+9/XBfBqE1nBpPETxnrv97mDOXA198IzMsgcsX6P1u+b3HO3AUZEoAuS5uo
         omyDSOiVHKCblH1qEjwb16kE1SfmEIM47Evsha1Jlkit/hBeSYREC5fsRN1L31J04h
         c/ZIpWs/4Vpvd+beM2YE7Pmd6RSR+HESdjsAXSuwDwlT9RPSaXhBd3BeAslWA2e4pY
         z04laGF5STE0w==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f6bb79f0000>; Thu, 24 Sep 2020 09:01:19 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 24 Sep 2020 09:01:19 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 24 Sep 2020 09:01:19 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "npiggin@gmail.com" <npiggin@gmail.com>
CC:     "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Topic: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Index: AQHWglJIf7HpaAEB10myzqnWl8w4gal2AiCAgAAJbgA=
Date:   Wed, 23 Sep 2020 21:01:18 +0000
Message-ID: <baac170f-4729-0519-2dca-fd8e90eba5fb@alliedtelesis.co.nz>
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
 <ec77cf82-5ef1-c650-3e8a-80be749c2214@gmail.com>
In-Reply-To: <ec77cf82-5ef1-c650-3e8a-80be749c2214@gmail.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <112C70DD5F3F4248843A2C4946A3BA9A@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAyNC8wOS8yMCA4OjI3IGFtLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6DQo+IE9uIDA0LjA5
LjIwMjAgMDI6MjgsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+PiBUaGUgU1BJRSByZWdpc3RlciBj
b250YWlucyBjb3VudHMgZm9yIHRoZSBUWCBGSUZPIHNvIGFueSB0aW1lIHRoZSBpcnENCj4+IGhh
bmRsZXIgd2FzIGludm9rZWQgd2Ugd291bGQgYXR0ZW1wdCB0byBwcm9jZXNzIHRoZSBSWC9UWCBm
aWZvcy4gVXNlIHRoZQ0KPj4gU1BJTSB2YWx1ZSB0byBtYXNrIHRoZSBldmVudHMgc28gdGhhdCB3
ZSBvbmx5IHByb2Nlc3MgaW50ZXJydXB0cyB0aGF0DQo+PiB3ZXJlIGV4cGVjdGVkLg0KPj4NCj4+
IFRoaXMgd2FzIGEgbGF0ZW50IGlzc3VlIGV4cG9zZWQgYnkgY29tbWl0IDMyODJhM2RhMjViZCAo
InBvd2VycGMvNjQ6DQo+PiBJbXBsZW1lbnQgc29mdCBpbnRlcnJ1cHQgcmVwbGF5IGluIEMiKS4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBQYWNraGFtIDxjaHJpcy5wYWNraGFtQGFsbGll
ZHRlbGVzaXMuY28ubno+DQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4gLS0tDQo+
Pg0KPj4gTm90ZXM6DQo+PiAgICAgIEkndmUgdGVzdGVkIHRoaXMgb24gYSBUMjA4MFJEQiBhbmQg
YSBjdXN0b20gYm9hcmQgdXNpbmcgdGhlIFQyMDgxIFNvQy4gV2l0aA0KPj4gICAgICB0aGlzIGNo
YW5nZSBJIGRvbid0IHNlZSBhbnkgc3B1cmlvdXMgaW5zdGFuY2VzIG9mIHRoZSAiVHJhbnNmZXIg
ZG9uZSBidXQNCj4+ICAgICAgU1BJRV9ET04gaXNuJ3Qgc2V0ISIgb3IgIlRyYW5zZmVyIGRvbmUg
YnV0IHJ4L3R4IGZpZm8ncyBhcmVuJ3QgZW1wdHkhIiBtZXNzYWdlcw0KPj4gICAgICBhbmQgdGhl
IHVwZGF0ZXMgdG8gc3BpIGZsYXNoIGFyZSBzdWNjZXNzZnVsLg0KPj4gICAgICANCj4+ICAgICAg
SSB0aGluayB0aGlzIHNob3VsZCBnbyBpbnRvIHRoZSBzdGFibGUgdHJlZXMgdGhhdCBjb250YWlu
IDMyODJhM2RhMjViZCBidXQgSQ0KPj4gICAgICBoYXZlbid0IGFkZGVkIGEgRml4ZXM6IHRhZyBi
ZWNhdXNlIEkgdGhpbmsgMzI4MmEzZGEyNWJkIGV4cG9zZWQgdGhlIGlzc3VlIGFzDQo+PiAgICAg
IG9wcG9zZWQgdG8gY2F1c2luZyBpdC4NCj4+DQo+PiAgIGRyaXZlcnMvc3BpL3NwaS1mc2wtZXNw
aS5jIHwgNSArKystLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGku
YyBiL2RyaXZlcnMvc3BpL3NwaS1mc2wtZXNwaS5jDQo+PiBpbmRleCA3ZTdjOTJjYWZkYmIuLmNi
MTIwYjY4YzBlMiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc3BpL3NwaS1mc2wtZXNwaS5jDQo+
PiArKysgYi9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGkuYw0KPj4gQEAgLTU3NCwxMyArNTc0LDE0
IEBAIHN0YXRpYyB2b2lkIGZzbF9lc3BpX2NwdV9pcnEoc3RydWN0IGZzbF9lc3BpICplc3BpLCB1
MzIgZXZlbnRzKQ0KPj4gICBzdGF0aWMgaXJxcmV0dXJuX3QgZnNsX2VzcGlfaXJxKHMzMiBpcnEs
IHZvaWQgKmNvbnRleHRfZGF0YSkNCj4+ICAgew0KPj4gICAJc3RydWN0IGZzbF9lc3BpICplc3Bp
ID0gY29udGV4dF9kYXRhOw0KPj4gLQl1MzIgZXZlbnRzOw0KPj4gKwl1MzIgZXZlbnRzLCBtYXNr
Ow0KPj4gICANCj4+ICAgCXNwaW5fbG9jaygmZXNwaS0+bG9jayk7DQo+PiAgIA0KPj4gICAJLyog
R2V0IGludGVycnVwdCBldmVudHModHgvcngpICovDQo+PiAgIAlldmVudHMgPSBmc2xfZXNwaV9y
ZWFkX3JlZyhlc3BpLCBFU1BJX1NQSUUpOw0KPj4gLQlpZiAoIWV2ZW50cykgew0KPj4gKwltYXNr
ID0gZnNsX2VzcGlfcmVhZF9yZWcoZXNwaSwgRVNQSV9TUElNKTsNCj4+ICsJaWYgKCEoZXZlbnRz
ICYgbWFzaykpIHsNCj4+ICAgCQlzcGluX3VubG9jaygmZXNwaS0+bG9jayk7DQo+PiAgIAkJcmV0
dXJuIElSUV9OT05FOw0KPiBTb3JyeSwgSSB3YXMgb24gdmFjYXRpb24gYW5kIHRoZXJlZm9yZSBj
b3VsZG4ndCBjb21tZW50IGVhcmxpZXIuDQo+IEknbSBmaW5lIHdpdGggdGhlIGNoYW5nZSwganVz
dCBvbmUgdGhpbmcgY291bGQgYmUgaW1wcm92ZWQgSU1PLg0KPiBJZiB3ZSBza2lwIGFuIHVubmVl
ZGVkIGludGVycnVwdCBub3csIHRoZW4gcmV0dXJuaW5nIElSUV9OT05FDQo+IGNhdXNlcyByZXBv
cnRpbmcgdGhpcyBpbnRlcnJ1cHQgYXMgc3B1cmlvdXMuIFRoaXMgaXNuJ3QgdG9vIG5pY2UNCj4g
YXMgc3B1cmlvdXMgaW50ZXJydXB0cyB0eXBpY2FsbHkgYXJlIHNlZW4gYXMgYSBwcm9ibGVtIGlu
ZGljYXRvci4NCj4gVGhlcmVmb3JlIHJldHVybmluZyBJUlFfSEFORExFRCBzaG91bGQgYmUgbW9y
ZSBhcHByb3ByaWF0ZS4NCj4gVGhpcyB3b3VsZCBqdXN0IHJlcXVpcmUgYSBjb21tZW50IGluIHRo
ZSBjb2RlIGV4cGxhaW5pbmcgd2h5IHdlDQo+IGRvIHRoaXMsIGFuZCB3aHkgaXQgY2FuIGhhcHBl
biB0aGF0IHdlIHJlY2VpdmUgaW50ZXJydXB0cw0KPiB3ZSdyZSBub3QgaW50ZXJlc3RlZCBpbi4N
CkknZCBiZSBoYXBweSB0byBzZW5kIGEgZm9sbG93LXVwIHRvIGNoYW5nZSBJUlFfTk9ORSB0byBJ
UlFfSEFORExFRC4gSSANCmRvbid0IHRoaW5rIHRoZSBvbGQgY29kZSBjb3VsZCBoYXZlIGV2ZXIg
aGl0IHRoZSBJUlFfTk9ORSAoYmVjYXVzZSBldmVudCANCndpbGwgYWx3YXlzIGJlIG5vbi16ZXJv
KSBzbyBpdCB3b24ndCByZWFsbHkgYmUgYSBjaGFuZ2UgaW4gYmVoYXZpb3VyLiANCldpdGggdGhl
IHBhdGNoICh0aGF0IGlzIG5vdyBpbiBzcGkvZm9yLW5leHQpIHNvIGZhciBJIGRvIHNlZSBhIGxv
dyANCm51bWJlciBvZiBzcHVyaW91cyBpbnRlcnJ1cHRzIG9uIHRoZSB0ZXN0IHNldHVwIHdoZXJl
IHByZXZpb3VzbHkgSSB3b3VsZCANCmhhdmUgc2VlbiBmYWlsdXJlIHRvIHRhbGsgdG8gdGhlIHNw
aS1mbGFzaC4NCg==
