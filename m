Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB3D673A42
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjASNbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 08:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjASNbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 08:31:47 -0500
X-Greylist: delayed 124 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 05:31:39 PST
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5EF78AA9;
        Thu, 19 Jan 2023 05:31:39 -0800 (PST)
Received: from spam.longcheer.com ([101.230.211.172])
        by unicom145.biz-email.net ((D)) with ESMTP id PGW00020;
        Thu, 19 Jan 2023 21:28:20 +0800
IronPort-SDR: ylXXkT3nsdAS84MTxKFLOPzxw6tflzM0I5vEc88+NrsuSPfzkuzsdz4kQX2UNAI2xfyTEq+BeH
 3PvWjfMLWKYQ==
Received: from unknown (HELO mailboxsrv03.LongCheer.net) ([172.16.9.237])
  by spam.longcheer.com with ESMTP; 19 Jan 2023 21:28:20 +0800
Received: from mailboxsrv05.LongCheer.net (172.16.9.229) by
 mailboxsrv03.LongCheer.net (172.16.9.237) with Microsoft SMTP Server (TLS) id
 15.0.1497.28; Thu, 19 Jan 2023 21:28:19 +0800
Received: from mailboxsrv05.LongCheer.net ([fe80::7007:e737:2540:ce0e]) by
 mailboxsrv05.LongCheer.net ([fe80::7007:e737:2540:ce0e%13]) with mapi id
 15.00.1497.028; Thu, 19 Jan 2023 21:28:20 +0800
From:   =?utf-8?B?546L5rOV5p2w?= <wangfajie@longcheer.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "daniel.lezcano@kernel.org" <daniel.lezcano@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "quic_ylal@quicinc.com" <quic_ylal@quicinc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        =?utf-8?B?5YiY5LuB5pe6?= <liurenwang@longcheer.com>,
        =?utf-8?B?5byg6L6J?= <zhanghui5@longcheer.com>,
        "liangke1@xiaomi.com" <liangke1@xiaomi.com>,
        =?utf-8?B?5rKI5YW1?= <ShenBing@longcheer.com>,
        =?utf-8?B?5YiY55Cm?= <liuqi405@icloud.com>
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
Thread-Topic: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
Thread-Index: AdksBYTv2ngAL484ROuwJXp61xjGcA==
Date:   Thu, 19 Jan 2023 13:28:19 +0000
Message-ID: <86c8b6b630954e63999b58de9d820408@mailboxsrv05.LongCheer.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.16.9.215]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
tUid:   2023119212820f360090d5d42d2f8d207616523421b68
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWFyYyBaeW5naWVyDQoNCldlIGZvdW5kIHRoZSBBUFBTIENyYXNoIGlzc3VlIG9uIE1UQkYg
dGVzdC4NCkJyaWVmIGNyYXNoIGluZm9ybWF0aW9uLCBBUFBTIENyYXNoIC0gS2VybmVsIEJVRyBh
dCAvc2NoZWQvd2FsdC9zY2hlZF9hdmcuYzoyODEhIGluIHNjaGVkX3VwZGF0ZV9ucl9wcm9kIGZs
b3cNCg0KW1Rlc3QgZXF1aXBtZW50XQ0KMS4gTnVtYmVyIG9mIHBob25lOiAgMjAwIHBjcw0KMi4g
Q1BVIGluZm8gb2YgcGhvbmU6ICBDUFUgYXJjaGl0ZWN0dXJlIHdpdGggUXVhZCBDb3J0ZXgtQTcz
IGFuZCBRdWFkIENvcnRleC1BNTMNCg0KW1ByZXNldCBjb25kaXRpb25zXQ0KMS4gQW5kcm9pZCAx
MyB3aXRoIGtlcm5lbCA1LjE1DQoyLiBJbnN0YWxsIGFwcGxpY2F0aW9uIG9mIHRvcCAyMA0KMy4g
Q29ubmVjdGVkIHRvIFdpLUZpDQo0LiBDb25uZWN0IHRoZSBhZGFwdGVyIHRvIGNoYXJnZSB0aGUg
cGhvbmUNCjUuIFRlc3QgZHVyYXRpb24gNDggaG91cnMNCg0KW0V4cGVjdGVkIHJlc3VsdHNdDQow
IGNyYXNoIGhhcHBlbmVkLg0KDQpbVGVzdCByZXN1bHRzIHdpdGhvdXQgW1BBVENIXSBjbG9ja3Nv
dXJjZS9kcml2ZXJzL2FybV9hcmNoX3RpbWVyOiBVcGRhdGUgc2NoZWRfY2xvY2sgd2hlbiBub24t
Ym9vdCBDUFVzIG5lZWQgY291bnRlciB3b3JrYXJvdW5kIF0NCjEuIEZpcnN0IHJvdW5kIG9mIHRl
c3QsIGZvdW5kIDMgcGhvbmVzIHdpdGggQVBQUyBDcmFzaCBpc3N1ZSBvbiAvc2NoZWQvd2FsdC9z
Y2hlZF9hdmcuYzoyODEhIGluIHNjaGVkX3VwZGF0ZV9ucl9wcm9kIGZsb3cNCjIuIFNlY29uZCBy
b3VuZCBvZiB0ZXN0LCBmb3VuZCA3IHBob25lcyB3aXRoIEFQUCBDcmFzaCBpc3N1ZSBvbiAvc2No
ZWQvd2FsdC9zY2hlZF9hdmcuYzoyODEhIGluIHNjaGVkX3VwZGF0ZV9ucl9wcm9kIGZsb3cNCg0K
W1Rlc3QgcmVzdWx0cyB3aXRoIFtQQVRDSF0gY2xvY2tzb3VyY2UvZHJpdmVycy9hcm1fYXJjaF90
aW1lcjogVXBkYXRlIHNjaGVkX2Nsb2NrIHdoZW4gbm9uLWJvb3QgQ1BVcyBuZWVkIGNvdW50ZXIg
d29ya2Fyb3VuZCBdIA0KMS4gRmlyc3Qgcm91bmQgb2YgdGVzdCwgMCBjcmFzaCBoYXBwZW5lZC4N
CjIuIFNlY29uZCByb3VuZCBvZiB0ZXN0LCAwIGNyYXNoIGhhcHBlbmVkLg0KDQpUZXN0ZWQtYnk6
IHdhbmdmYWppZSA8d2FuZ2ZhamllQGxvbmdjaGVlci5jb20+DQpUZXN0ZWQtYnk6IGxpdXJlbndh
bmcgPGxpdXJlbndhbmdAbG9uZ2NoZWVyLmNvbT4NClRlc3RlZC1ieTogemhhbmdodWkgPHpoYW5n
aHVpNUBsb25nY2hlZXIuY29tPg0KVGVzdGVkLWJ5OiBsaWFuZ2tlIDxsaWFuZ2tlMUB4aWFvbWku
Y29tPg0KDQpTbyB3ZSB0aGluayB0aGUgUEFUQ0ggaXMgd29ya2luZyBhbmQgaXQgY2FuIGZpeCBB
UFBTIGNyYXNoIGlzc3VlLiBNYW55IHRoYW5rcyB5b3VyIHRpbWUuDQoNCkJlc3QgcmVnYXJkcyEN
CldhbmdmYWppZQ0KDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogTWFyYyBa
eW5naWVyIFttYWlsdG86bWF6QGtlcm5lbC5vcmddIA0K5Y+R6YCB5pe26Ze0OiAyMDIz5bm0Meac
iDE55pelIDE3OjUyDQrmlLbku7bkuro6IOWImOeQpiA8bGl1cWk0MDVAaWNsb3VkLmNvbT4NCuaK
hOmAgTogZGFuaWVsLmxlemNhbm9Aa2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBtYXJrLnJ1dGxhbmRA
YXJtLmNvbTsgcXVpY195bGFsQHF1aWNpbmMuY29tOyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyB3
aWxsQGtlcm5lbC5vcmc7IOeOi+azleadsCA8d2FuZ2ZhamllQGxvbmdjaGVlci5jb20+OyDliJjk
u4Hml7ogPGxpdXJlbndhbmdAbG9uZ2NoZWVyLmNvbT47IOW8oOi+iSA8emhhbmdodWk1QGxvbmdj
aGVlci5jb20+OyBsaWFuZ2tlMUB4aWFvbWkuY29tDQrkuLvpopg6IFJlOiBbUEFUQ0hdIGNsb2Nr
c291cmNlL2RyaXZlcnMvYXJtX2FyY2hfdGltZXI6IFVwZGF0ZSBzY2hlZF9jbG9jayB3aGVuIG5v
bi1ib290IENQVXMgbmVlZCBjb3VudGVyIHdvcmthcm91bmQNCg0KT24gMjAyMy0wMS0xOSAwNzo1
OSwg5YiY55CmIHdyb3RlOg0KPiBbVGVzdCBSZXBvcnRdDQo+IFJlc3VsdDogVGVzdCBQYXNzDQo+
IA0KPiBBIHRvdGFsIG9mIHR3byByb3VuZHMgb2YgcGVuZGluZyB0ZXN0aW5nDQo+ICAgICAgYS4g
VGhlIGZpcnN0IHJvdW5kIG9mIGhhbmdpbmcgdGVzdA0KPiAgICAgICAgICAgTnVtYmVyIG9mIG1h
Y2hpbmVzOiAyMDANCj4gICAgICAgICAgIEhhbmdpbmcgdGVzdCBkdXJhdGlvbjogNDhoDQo+ICAg
ICAgICAgICBIYW5naW5nIHRlc3QgcmVzdWx0czogbm8gd2FsdCBjcmFzaCBwcm9ibGVtDQo+ICAg
ICAgYi4gVGhlIHNlY29uZCByb3VuZCBvZiBoYW5naW5nIHRlc3QNCj4gICAgICAgICAgIE51bWJl
ciBvZiBtYWNoaW5lczogMjAwDQo+ICAgICAgICAgICBIYW5naW5nIHRlc3QgZHVyYXRpb246IDcy
aA0KPiAgICAgICAgICAgSGFuZ2luZyB0ZXN0IHJlc3VsdHM6IG5vIHdhbHQgY3Jhc2ggcHJvYmxl
bQ0KPiANCj4gVGVzdGVkLWJ5OiB3YW5nZmFqaWUgPHdhbmdmYWppZUBsb25nY2hlZXIuY29tPg0K
PiBUZXN0ZWQtYnk6IGxpdXJlbndhbmcgPGxpdXJlbndhbmdAbG9uZ2NoZWVyLmNvbT4NCj4gVGVz
dGVkLWJ5OiB6aGFuZ2h1aSA8emhhbmdodWk1QGxvbmdjaGVlci5jb20+DQo+IFRlc3RlZC1ieTog
bGlhbmdrZSA8bGlhbmdrZTFAeGlhb21pLmNvbT4NCg0KVGhhbmtzIGZvciB0aGlzLg0KDQpUaGUg
b25seSBpc3N1ZSBoZXJlIGlzIHRoYXQgdGhhdCB5b3UgZG9uJ3QgZXhwbGFpbiB3aGF0IHlvdSB0
ZXN0ZWQsIG5vciBob3cgeW91IHRlc3RlZCBpdC4NCg0KSXQgaXMgYWxzbyBhIHBhdGNoIHRoYXQg
aGFzIGtub3duIGRlZmVjdHMgKHlvdSBqdXN0IGhhdmUgdG8gcmVhZCB0aGUgdGhyZWFkIGZvciB0
aGUgZGV0YWlscykuLi4gVGhpcyBtYWtlcyB0aGlzIHRlc3RpbmcsIG5vIG1hdHRlciBob3cgdGhv
cm91Z2ggaXQgaXMsIHJhdGhlciBpbmVmZmVjdGl2ZS4NCg0KICAgICAgICAgTS4NCi0tDQpKYXp6
IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLg0K
