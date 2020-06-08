Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A110B1F1BBE
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgFHPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 11:11:44 -0400
Received: from mail-eopbgr30109.outbound.protection.outlook.com ([40.107.3.109]:34305
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730190AbgFHPLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 11:11:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0k9dpL6t9I/b2C1tshF6YiQFdZp5a0tSpGPMSvYZNHHAdGqGTYElM2gJ1Bit8Xr4DTwsuwNMwPhc7jKS+b2ebCT1KOvO8aKl8JnO0oO1+nFH2mquTdKxgd1DR/oC9JTrHYm1znWiT2Z1/lsSK8sTQYeVpV7UnXPMjeFqF7e+HKHduU29wI6IFmpdEgUGNnYFS11FWCI/t6nrYYRBilyMkkTZWwW2ZzzgmXUvW3IivzFIL0OTDkfXCwvNW3CgqGV+CPSyXCJlBZAc4fOVL/HbmJeuzuPzbcaxVKX9rheQMNAFBbRxps1qiUdU9pXGNYTvA5NNespqY1nG59iHkocOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4kZAD0Lgw+oGfxVwzCegd01JmMLaNZFSW8ITYYMk4g=;
 b=FKaPV4l9tJ+OuHuTuo8lPgd62YND525RwsxHxOfVq1WVrvkv8V3KjaSN5cx0HLiIljfRSWREDCe1bRBWZzmc1brImU+Y5IM7E8ulKCy2XfmBsw0vb6GherbIatjMd3RWlVUu9mu4zgcFy38DFiWQIlhU+6cQYvg3syJ2gWxJzdrKKHRmN5C7QYTzXdTRXBoJMvgVc5FBHPORcmOtpJpbgAhkzWHkV3ZMVTQR2HGTQqq/v3uJvG5T3lDkbHb6HBVdH2uRIT9SmzVr2UIsULlFbMupL2cG6UMqO4eguFTTbyAcG/+5VEYGqmhPuT0+EofF9mzpmJQ4sqt326bzkPd5zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4kZAD0Lgw+oGfxVwzCegd01JmMLaNZFSW8ITYYMk4g=;
 b=MyjiaSxuIrpgHwlF/zWRLABL4eb7JMMmucsXfh81fAINr4CDy/mjjJg0GBxy2uvgGIYIyv65EU8wJf0K7YB1HERm2ECmgQ8jG5CP64L0/SKFaMljQzhStsBz1TeBCOwjTpAain4ivskM75E8KLpmKsblYD1Vjehu9W7mLfoRydY=
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:50::12)
 by DB7PR10MB2043.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:5:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Mon, 8 Jun
 2020 15:11:36 +0000
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048]) by DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 15:11:36 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: [PATCH] serial: imx: Fix handling of TC irq in combination with DMA
Thread-Topic: [PATCH] serial: imx: Fix handling of TC irq in combination with
 DMA
Thread-Index: AQHWPacakgJZrwZ8pkOomdvwi0/9IQ==
Date:   Mon, 8 Jun 2020 15:11:36 +0000
Message-ID: <20200608151012.7296-1-frieder.schrempf@kontron.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=kontron.de;
x-originating-ip: [77.246.119.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32172caa-f316-4836-c6f4-08d80bbe3c93
x-ms-traffictypediagnostic: DB7PR10MB2043:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR10MB204324DB19BD518CAC7FA0AAE9850@DB7PR10MB2043.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:226;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kyxuASHfKYig5pqqedEIUSoCgUJ51Dd/YGZ+cNScLqceahb5my81JCc7SbWXk7ulcNJQVWsoAqpgQeW1e8jcQxnRxSYQF/4SoCGHdK9Na655OkaLjohsre4VWzu7b9OyI9mTkXkKv9Ph4gSZ/LNGQekW9QH12GiM+HQhYdYSv2YFvi39QFCs+6LmFOZGaylpr0EXG9DlXbC+c4TVsv+Zt5HLrUdI6K+5q+RhNAhQ6HBjdwgfPuu3rtnGO8zMsg/kk9fiVTINlsReejKSisqnhAM9t3AFLoD+9uvseKe0ZhDSKr8Mps6BQy0dinetDj93rDAb6EglXvoIv99vsSAiIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(136003)(376002)(396003)(366004)(8936002)(66574014)(6506007)(86362001)(83380400001)(8676002)(5660300002)(36756003)(71200400001)(4326008)(2906002)(478600001)(26005)(186003)(66476007)(91956017)(6916009)(66446008)(2616005)(64756008)(54906003)(6486002)(1076003)(316002)(6512007)(66556008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rbsJnBu+DNoqm2d12U7EOB9faKZBbjHjMzeqydfKqhNVn2pTB70x2WdDGkI1jaDymBskAUksBnPdS7gPLrHnMiFW38D0Eaj80hnzqC6r+vFk/EKAC0UHC7Wp7+oURxuY/tVhrhk2wMxvrrXThDPUOpR739vjH027M3hCRz92pIPu7wh/SMySKMNFqer6QLa5PRGO0aFOtyB20UWDBlRGlAStubY8S2wCo1HdJ/ckAZHYJh/6se7TTC8ZhxNfUi5yFIsftlyyg5RVlmdW6Tqbxg+dbb9Z+qcGb0R6nHQEplnUZp7ZvEiiWIB5NX0uABgO1NLeRvApCkgl43/M9RvcihLP+SV3zAOr1W3IIZWQF36qZ8iZjZ8Jh+5YrYXm2jVUgLzN90gJMNMX5W15Hd+XbeBATRFTKznXorasN+Igl7HsRZBkUq9zrXwB9+ngZ/9+eSyEiPnl/A2DV8bLn+9CFURKANvwckqCUvDXNsTsO8IcADgrcKH4fInkw/pybkT8
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D23C829F8B0C34D8F5AC104D2B3DA92@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 32172caa-f316-4836-c6f4-08d80bbe3c93
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 15:11:36.0594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LrY1+xSLEkmvRmTulTuDRBJXn6Rxd8+HrVzFdm8/R6ouvJB4UxbPXUPO+LVyu0tYqcIsCKuSmGlGBEpkvP+wL6++KqQlwtIPJlDymN0nK2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB2043
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5pZ0BwZW5ndXRyb25peC5kZT4N
Cg0KY29tbWl0IDE4NjY1NDE0OTI2NDFjMDI4NzRiZjUxZjlkODcxMmI1NTEwZjJjNjQgdXBzdHJl
YW0NCg0KV2hlbiB1c2luZyBSUzQ4NSBoYWxmIGR1cGxleCB0aGUgVHJhbnNtaXR0ZXIgQ29tcGxl
dGUgaXJxIGlzIG5lZWRlZCB0bw0KZGV0ZXJtaW5lIHRoZSBtb21lbnQgd2hlbiB0aGUgdHJhbnNt
aXR0ZXIgY2FuIGJlIGRpc2FibGVkLiBXaGVuIHVzaW5nDQpETUEgdGhpcyBpcnEgbXVzdCBvbmx5
IGJlIGVuYWJsZWQgd2hlbiBETUEgaGFzIGNvbXBsZXRlZCB0byB0cmFuc2ZlciBhbGwNCmRhdGEu
IE90aGVyd2lzZSB0aGUgQ1BVIG1pZ2h0IGJ1c2lseSB0cmlnZ2VyIHRoaXMgaXJxIHdoaWNoIGlz
IG5vdA0KcHJvcGVybHkgaGFuZGxlZCBhbmQgc28gdGhlIGFsc28gcGVuZGluZyBpcnEgZm9yIHRo
ZSBETUEgdHJhbnNmZXIgY2Fubm90DQp0cmlnZ2VyLg0KDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+ICMgdjQuMTQueA0KU2lnbmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xl
aW5lLWtvZW5pZ0BwZW5ndXRyb25peC5kZT4NClNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQpbQmFja3BvcnQgdG8gdjQuMTRdDQpT
aWduZWQtb2ZmLWJ5OiBGcmllZGVyIFNjaHJlbXBmIDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24u
ZGU+DQotLS0NCldoZW4gdXNpbmcgUlM0ODUgd2l0aCBETUEgZW5hYmxlZCBzaW1wbHkgdHJhbnNt
aXR0aW5nIHNvbWUgZGF0YSBvbiBvdXINCmkuTVg2VUxMIGJhc2VkIGJvYXJkcyBvZnRlbiBmcmVl
emVzIHRoZSBzeXN0ZW0gY29tcGxldGVseS4gVGhlIGhpZ2hlcg0KdGhlIGJhdWRyYXRlLCB0aGUg
ZWFzaWVyIGl0IGlzIHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUuIFRvIHRlc3QgdGhpcyBJDQpzaW1w
bHkgdXNlZDoNCg0Kc3R0eSAtRiAvZGV2L3R0eW14YzEgc3BlZWQgMTE1MjAwDQp3aGlsZSB0cnVl
OyBkbyBlY2hvIFRFU1QgPiAvZGV2L3R0eW14YzE7IGRvbmUNCg0KV2l0aG91dCB0aGUgcGF0Y2gg
dGhpcyBsZWFkcyB0byBhbiBhbG1vc3QgaW1tZWRpYXRlIHN5c3RlbSBmcmVlemUsDQp3aXRoIHRo
ZSBwYXRjaCBhcHBsaWVkLCBldmVyeXRoaW5nIGtlZXBzIHdvcmtpbmcgYXMgZXhwZWN0ZWQuIA0K
LS0tDQogZHJpdmVycy90dHkvc2VyaWFsL2lteC5jIHwgMjMgKysrKysrKysrKysrKysrKysrKy0t
LS0NCiAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYyBiL2RyaXZlcnMvdHR5L3Nlcmlh
bC9pbXguYw0KaW5kZXggM2YyNjA1ZWRkODU1Li45OTNhYjU3ZTc0NDggMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3R0eS9zZXJpYWwvaW14LmMNCisrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYw0K
QEAgLTUzOCw2ICs1MzgsMTEgQEAgc3RhdGljIHZvaWQgZG1hX3R4X2NhbGxiYWNrKHZvaWQgKmRh
dGEpDQogDQogCWlmICghdWFydF9jaXJjX2VtcHR5KHhtaXQpICYmICF1YXJ0X3R4X3N0b3BwZWQo
JnNwb3J0LT5wb3J0KSkNCiAJCWlteF9kbWFfdHgoc3BvcnQpOw0KKwllbHNlIGlmIChzcG9ydC0+
cG9ydC5yczQ4NS5mbGFncyAmIFNFUl9SUzQ4NV9FTkFCTEVEKSB7DQorCQl0ZW1wID0gcmVhZGwo
c3BvcnQtPnBvcnQubWVtYmFzZSArIFVDUjQpOw0KKwkJdGVtcCB8PSBVQ1I0X1RDRU47DQorCQl3
cml0ZWwodGVtcCwgc3BvcnQtPnBvcnQubWVtYmFzZSArIFVDUjQpOw0KKwl9DQogDQogCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJnNwb3J0LT5wb3J0LmxvY2ssIGZsYWdzKTsNCiB9DQpAQCAtNTU1
LDYgKzU2MCwxMCBAQCBzdGF0aWMgdm9pZCBpbXhfZG1hX3R4KHN0cnVjdCBpbXhfcG9ydCAqc3Bv
cnQpDQogCWlmIChzcG9ydC0+ZG1hX2lzX3R4aW5nKQ0KIAkJcmV0dXJuOw0KIA0KKwl0ZW1wID0g
cmVhZGwoc3BvcnQtPnBvcnQubWVtYmFzZSArIFVDUjQpOw0KKwl0ZW1wICY9IH5VQ1I0X1RDRU47
DQorCXdyaXRlbCh0ZW1wLCBzcG9ydC0+cG9ydC5tZW1iYXNlICsgVUNSNCk7DQorDQogCXNwb3J0
LT50eF9ieXRlcyA9IHVhcnRfY2lyY19jaGFyc19wZW5kaW5nKHhtaXQpOw0KIA0KIAlpZiAoeG1p
dC0+dGFpbCA8IHhtaXQtPmhlYWQgfHwgeG1pdC0+aGVhZCA9PSAwKSB7DQpAQCAtNjA4LDYgKzYx
Nyw3IEBAIHN0YXRpYyB2b2lkIGlteF9zdGFydF90eChzdHJ1Y3QgdWFydF9wb3J0ICpwb3J0KQ0K
IA0KIAlpZiAocG9ydC0+cnM0ODUuZmxhZ3MgJiBTRVJfUlM0ODVfRU5BQkxFRCkgew0KIAkJdGVt
cCA9IHJlYWRsKHBvcnQtPm1lbWJhc2UgKyBVQ1IyKTsNCisNCiAJCWlmIChwb3J0LT5yczQ4NS5m
bGFncyAmIFNFUl9SUzQ4NV9SVFNfT05fU0VORCkNCiAJCQlpbXhfcG9ydF9ydHNfYWN0aXZlKHNw
b3J0LCAmdGVtcCk7DQogCQllbHNlDQpAQCAtNjE3LDEwICs2MjcsMTUgQEAgc3RhdGljIHZvaWQg
aW14X3N0YXJ0X3R4KHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQpDQogCQlpZiAoIShwb3J0LT5yczQ4
NS5mbGFncyAmIFNFUl9SUzQ4NV9SWF9EVVJJTkdfVFgpKQ0KIAkJCWlteF9zdG9wX3J4KHBvcnQp
Ow0KIA0KLQkJLyogZW5hYmxlIHRyYW5zbWl0dGVyIGFuZCBzaGlmdGVyIGVtcHR5IGlycSAqLw0K
LQkJdGVtcCA9IHJlYWRsKHBvcnQtPm1lbWJhc2UgKyBVQ1I0KTsNCi0JCXRlbXAgfD0gVUNSNF9U
Q0VOOw0KLQkJd3JpdGVsKHRlbXAsIHBvcnQtPm1lbWJhc2UgKyBVQ1I0KTsNCisJCS8qDQorCQkg
KiBFbmFibGUgdHJhbnNtaXR0ZXIgYW5kIHNoaWZ0ZXIgZW1wdHkgaXJxIG9ubHkgaWYgRE1BIGlz
IG9mZi4NCisJCSAqIEluIHRoZSBETUEgY2FzZSB0aGlzIGlzIGRvbmUgaW4gdGhlIHR4LWNhbGxi
YWNrLg0KKwkJICovDQorCQlpZiAoIXNwb3J0LT5kbWFfaXNfZW5hYmxlZCkgew0KKwkJCXRlbXAg
PSByZWFkbChwb3J0LT5tZW1iYXNlICsgVUNSNCk7DQorCQkJdGVtcCB8PSBVQ1I0X1RDRU47DQor
CQkJd3JpdGVsKHRlbXAsIHBvcnQtPm1lbWJhc2UgKyBVQ1I0KTsNCisJCX0NCiAJfQ0KIA0KIAlp
ZiAoIXNwb3J0LT5kbWFfaXNfZW5hYmxlZCkgew0KLS0gDQoyLjE3LjENCg==
