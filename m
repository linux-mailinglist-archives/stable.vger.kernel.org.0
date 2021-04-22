Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639D3367DC7
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 11:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhDVJfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 05:35:37 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:9532 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235339AbhDVJfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 05:35:36 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M9VllN023388;
        Thu, 22 Apr 2021 11:34:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=selector1;
 bh=PAzGZymp8Tn7VEiuoukm8luQ4ogr9Bf/DPZZ5qZ6axE=;
 b=gpQIdbVqq/TOpNVXl+xiUBeGU1gf64h84zEtNnWp3bsQ/J4ijna1glmJhC4yTml53NaT
 mNSDr0C4lvNnAxn9c9t2YL07kZLB0cywT/qsc0bM1ak0ix4Otc0CtkBEBhFSrcPkKlLl
 AjigITtIPEMv4dnn8SF4jTLledFel/XYsHemKmAi78AQnYB0sqYKj81tN5Delcg48frN
 b5AManEhZEME/uDn0Q419rVFfuqCdDMJ1SnsTgQeDUgdQcRjG78oHTUJMmg3occ23C4c
 UDXdtCP2hhE+Iwm09ugcV1gDWlzZMqyShrP5ZqA7qTw8O3hEUEhWnlStZRhjHO7OQRRz FQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 382fxqfsb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 11:34:57 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2A20010002A;
        Thu, 22 Apr 2021 11:34:56 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 17FD425F400;
        Thu, 22 Apr 2021 11:34:56 +0200 (CEST)
Received: from SFHDAG2NODE3.st.com (10.75.127.6) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Apr
 2021 11:34:55 +0200
Received: from SFHDAG2NODE3.st.com ([fe80::31b3:13bf:2dbe:f64c]) by
 SFHDAG2NODE3.st.com ([fe80::31b3:13bf:2dbe:f64c%20]) with mapi id
 15.00.1497.012; Thu, 22 Apr 2021 11:34:55 +0200
From:   Valentin CARON - foss <valentin.caron@foss.st.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE - foss <alexandre.torgue@foss.st.com>,
        "dillon.minfei@gmail.com" <dillon.minfei@gmail.com>,
        Erwan LE-RAY - foss <erwan.leray@foss.st.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Gerald BAEZA <gerald.baeza@st.com>
Subject: Re: [PATCH 2/3] serial: stm32: fix threaded interrupt handling
Thread-Topic: [PATCH 2/3] serial: stm32: fix threaded interrupt handling
Thread-Index: AQHXMsptWrbsx4Er7UavsC4846LX06rALmWA
Date:   Thu, 22 Apr 2021 09:34:55 +0000
Message-ID: <b687c2f2-e6f3-818a-1bb7-bf632d589171@foss.st.com>
References: <20210416140557.25177-1-johan@kernel.org>
 <20210416140557.25177-3-johan@kernel.org>
In-Reply-To: <20210416140557.25177-3-johan@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACAE7D4482F3474797035C4AEF2DBF8E@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksIEpvaGFuDQoNCk9uIDQvMTYvMjEgNDowNSBQTSwgSm9oYW4gSG92b2xkIHdyb3RlOg0KPiBX
aGVuIERNQSBpcyBlbmFibGVkIHRoZSByZWNlaXZlIGhhbmRsZXIgcnVucyBpbiBhIHRocmVhZGVk
IGhhbmRsZXIsIGJ1dA0KPiB0aGUgcHJpbWFyeSBoYW5kbGVyIHVwIHVudGlsIHZlcnkgcmVjZW50
bHkgbmVpdGhlciBkaXNhYmxlZCBpbnRlcnJ1cHRzDQo+IGluIHRoZSBkZXZpY2Ugb3IgdXNlZCBJ
UlFGX09ORVNIT1QuIFRoaXMgd291bGQgbGVhZCB0byBhIGRlYWRsb2NrIGlmIGFuDQo+IGludGVy
cnVwdCBjb21lcyBpbiB3aGlsZSB0aGUgdGhyZWFkZWQgcmVjZWl2ZSBoYW5kbGVyIGlzIHJ1bm5p
bmcgdW5kZXINCj4gdGhlIHBvcnQgbG9jay4NCj4NCj4gQ29tbWl0IGFkNzY3NjgxMjQzNyAoInNl
cmlhbDogc3RtMzI6IGZpeCBhIGRlYWRsb2NrIGNvbmRpdGlvbiB3aXRoDQo+IHdha2V1cCBldmVu
dCIpIGNsYWltZWQgdG8gZml4IGFuIHVucmVsYXRlZCBkZWFkbG9jaywgYnV0IHVuZm9ydHVuYXRl
bHkNCj4gYWxzbyBkaXNhYmxlZCBpbnRlcnJ1cHRzIGluIHRoZSB0aHJlYWRlZCBoYW5kbGVyLiBX
aGlsZSB0aGlzIHByZXZlbnRzDQo+IHRoZSBkZWFkbG9jayBtZW50aW9uZWQgaW4gdGhlIHByZXZp
b3VzIHBhcmFncmFwaCBpdCBhbHNvIGRlZmVhdHMgdGhlDQo+IHB1cnBvc2Ugb2YgdXNpbmcgYSB0
aHJlYWRlZCBoYW5kbGVyIGluIHRoZSBmaXJzdCBwbGFjZS4NCj4NCj4gRml4IHRoaXMgYnkgbWFr
aW5nIHRoZSBpbnRlcnJ1cHQgb25lLXNob3QgYW5kIG5vdCBkaXNhYmxpbmcgaW50ZXJydXB0cw0K
PiBpbiB0aGUgdGhyZWFkZWQgaGFuZGxlci4NCj4NCj4gTm90ZSB0aGF0IChyZWNlaXZlKSBETUEg
bXVzdCBub3QgYmUgdXNlZCBmb3IgYSBjb25zb2xlIHBvcnQgYXMgdGhlDQo+IHRocmVhZGVkIGhh
bmRsZXIgY291bGQgYmUgaW50ZXJydXB0ZWQgd2hpbGUgaG9sZGluZyB0aGUgcG9ydCBsb2NrLA0K
PiBzb21ldGhpbmcgd2hpY2ggY291bGQgbGVhZCB0byBhIGRlYWRsb2NrIGluIGNhc2UgYW4gaW50
ZXJydXB0IGhhbmRsZXINCj4gZW5kcyB1cCBjYWxsaW5nIHByaW50ay4NCj4NCj4gRml4ZXM6IGFk
NzY3NjgxMjQzNyAoInNlcmlhbDogc3RtMzI6IGZpeCBhIGRlYWRsb2NrIGNvbmRpdGlvbiB3aXRo
IHdha2V1cCBldmVudCIpDQo+IEZpeGVzOiAzNDg5MTg3MjA0ZWIgKCJzZXJpYWw6IHN0bTMyOiBh
ZGRpbmcgZG1hIHN1cHBvcnQiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAgICAgICMg
NC45DQo+IENjOiBBbGV4YW5kcmUgVE9SR1VFIDxhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbT4NCj4g
Q2M6IEdlcmFsZCBCYWV6YSA8Z2VyYWxkLmJhZXphQHN0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
Sm9oYW4gSG92b2xkIDxqb2hhbkBrZXJuZWwub3JnPg0KDQpSZXZpZXdlZC1ieTogVmFsZW50aW4g
Q2Fyb248dmFsZW50aW4uY2Fyb25AZm9zcy5zdC5jb20+DQoNCj4gLS0tDQo+ICAgZHJpdmVycy90
dHkvc2VyaWFsL3N0bTMyLXVzYXJ0LmMgfCAyMiArKysrKysrKysrKystLS0tLS0tLS0tDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFsL3N0bTMyLXVzYXJ0LmMgYi9kcml2ZXJzL3R0
eS9zZXJpYWwvc3RtMzItdXNhcnQuYw0KPiBpbmRleCA0ZDI3NzgwNGM2M2UuLjM1MjRlZDJjMGM3
MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy90dHkvc2VyaWFsL3N0bTMyLXVzYXJ0LmMNCj4gKysr
IGIvZHJpdmVycy90dHkvc2VyaWFsL3N0bTMyLXVzYXJ0LmMNCj4gQEAgLTIxNCwxNCArMjE0LDEx
IEBAIHN0YXRpYyB2b2lkIHN0bTMyX3VzYXJ0X3JlY2VpdmVfY2hhcnMoc3RydWN0IHVhcnRfcG9y
dCAqcG9ydCwgYm9vbCB0aHJlYWRlZCkNCj4gICAJc3RydWN0IHR0eV9wb3J0ICp0cG9ydCA9ICZw
b3J0LT5zdGF0ZS0+cG9ydDsNCj4gICAJc3RydWN0IHN0bTMyX3BvcnQgKnN0bTMyX3BvcnQgPSB0
b19zdG0zMl9wb3J0KHBvcnQpOw0KPiAgIAljb25zdCBzdHJ1Y3Qgc3RtMzJfdXNhcnRfb2Zmc2V0
cyAqb2ZzID0gJnN0bTMyX3BvcnQtPmluZm8tPm9mczsNCj4gLQl1bnNpZ25lZCBsb25nIGMsIGZs
YWdzOw0KPiArCXVuc2lnbmVkIGxvbmcgYzsNCj4gICAJdTMyIHNyOw0KPiAgIAljaGFyIGZsYWc7
DQo+ICAgDQo+IC0JaWYgKHRocmVhZGVkKQ0KPiAtCQlzcGluX2xvY2tfaXJxc2F2ZSgmcG9ydC0+
bG9jaywgZmxhZ3MpOw0KPiAtCWVsc2UNCj4gLQkJc3Bpbl9sb2NrKCZwb3J0LT5sb2NrKTsNCj4g
KwlzcGluX2xvY2soJnBvcnQtPmxvY2spOw0KPiAgIA0KPiAgIAl3aGlsZSAoc3RtMzJfdXNhcnRf
cGVuZGluZ19yeChwb3J0LCAmc3IsICZzdG0zMl9wb3J0LT5sYXN0X3JlcywNCj4gICAJCQkJICAg
ICAgdGhyZWFkZWQpKSB7DQo+IEBAIC0yNzgsMTAgKzI3NSw3IEBAIHN0YXRpYyB2b2lkIHN0bTMy
X3VzYXJ0X3JlY2VpdmVfY2hhcnMoc3RydWN0IHVhcnRfcG9ydCAqcG9ydCwgYm9vbCB0aHJlYWRl
ZCkNCj4gICAJCXVhcnRfaW5zZXJ0X2NoYXIocG9ydCwgc3IsIFVTQVJUX1NSX09SRSwgYywgZmxh
Zyk7DQo+ICAgCX0NCj4gICANCj4gLQlpZiAodGhyZWFkZWQpDQo+IC0JCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnBvcnQtPmxvY2ssIGZsYWdzKTsNCj4gLQllbHNlDQo+IC0JCXNwaW5fdW5sb2Nr
KCZwb3J0LT5sb2NrKTsNCj4gKwlzcGluX3VubG9jaygmcG9ydC0+bG9jayk7DQo+ICAgDQo+ICAg
CXR0eV9mbGlwX2J1ZmZlcl9wdXNoKHRwb3J0KTsNCj4gICB9DQo+IEBAIC02NjcsNyArNjYxLDgg
QEAgc3RhdGljIGludCBzdG0zMl91c2FydF9zdGFydHVwKHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQp
DQo+ICAgDQo+ICAgCXJldCA9IHJlcXVlc3RfdGhyZWFkZWRfaXJxKHBvcnQtPmlycSwgc3RtMzJf
dXNhcnRfaW50ZXJydXB0LA0KPiAgIAkJCQkgICBzdG0zMl91c2FydF90aHJlYWRlZF9pbnRlcnJ1
cHQsDQo+IC0JCQkJICAgSVJRRl9OT19TVVNQRU5ELCBuYW1lLCBwb3J0KTsNCj4gKwkJCQkgICBJ
UlFGX09ORVNIT1QgfCBJUlFGX05PX1NVU1BFTkQsDQo+ICsJCQkJICAgbmFtZSwgcG9ydCk7DQo+
ICAgCWlmIChyZXQpDQo+ICAgCQlyZXR1cm4gcmV0Ow0KPiAgIA0KPiBAQCAtMTE1Niw2ICsxMTUx
LDEzIEBAIHN0YXRpYyBpbnQgc3RtMzJfdXNhcnRfb2ZfZG1hX3J4X3Byb2JlKHN0cnVjdCBzdG0z
Ml9wb3J0ICpzdG0zMnBvcnQsDQo+ICAgCXN0cnVjdCBkbWFfYXN5bmNfdHhfZGVzY3JpcHRvciAq
ZGVzYyA9IE5VTEw7DQo+ICAgCWludCByZXQ7DQo+ICAgDQo+ICsJLyoNCj4gKwkgKiBVc2luZyBE
TUEgYW5kIHRocmVhZGVkIGhhbmRsZXIgZm9yIHRoZSBjb25zb2xlIGNvdWxkIGxlYWQgdG8NCj4g
KwkgKiBkZWFkbG9ja3MuDQo+ICsJICovDQo+ICsJaWYgKHVhcnRfY29uc29sZShwb3J0KSkNCj4g
KwkJcmV0dXJuIC1FTk9ERVY7DQo+ICsNCj4gICAJLyogUmVxdWVzdCBETUEgUlggY2hhbm5lbCAq
Lw0KPiAgIAlzdG0zMnBvcnQtPnJ4X2NoID0gZG1hX3JlcXVlc3Rfc2xhdmVfY2hhbm5lbChkZXYs
ICJyeCIpOw0KPiAgIAlpZiAoIXN0bTMycG9ydC0+cnhfY2gpIHs=
