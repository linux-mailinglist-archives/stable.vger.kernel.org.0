Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03521F34C5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 09:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgFIHXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 03:23:45 -0400
Received: from mail-am6eur05on2124.outbound.protection.outlook.com ([40.107.22.124]:42177
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbgFIHXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 03:23:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt4j9NQwlOanWwWc/zBU9+4TwmlBuCUWN1vtBHM73VfnjcKFbdp7iKumdSkWvURs2dO9ASdvyUOVUrDsVLMAMQDyvnEXcW2VjFArmXu5Nx/YGgvonWq4/raYhNmn/FPThOnthdyACrvNw+eVx/aKvoqNiUMMRCPunKLlKPYfHg7qw/UtiC9Kp3ZLYdXCURxHzw7lLppm2jDfd10Hh2L+e4LEy6PbmW9+O3zEvuKUAkO/Sr6soaOkzppXOuUN35xizJLZedtlRba9F8gZAgmyXncOaOcplHU5XY6/cFwI31utZZ/tNLubldzcPJ3YaWwWLAb/4T5RBhF13yKOIhFg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WSE4mdrEa4VrmDwLEkO8/+v34K36Kl/YH4u56hlgYI=;
 b=U8WflaV42iaFOZd2AfWCxl6oKsOmTunoURFEH5tfDRsDABrq8kZZ5xv3oXVAK3gJhipLNld6Ef4Z7wio759VavB/eFsXzNiIVBbT2pKHVeznCYn73TtlPDzWARNQFjKXdSQjyQPrbMYMKj/2vqkXhYdSoaNl5Ka2aNdkN2B/biHSArCd7WjWAtfSEG0vHyPKYqZzzWHgkXY0oho0KCMtZTE9YXJONEDYr1FQzHWNV1NqThZFRmQlNN/1tfkqE6KAQ56hQ2nwD72BNf2JWxXkvm5Nqi42e4bR/YhTCzNDAXYPDBywgHcMAYIiB8ABvdwvP7VZRLUWR7hoTTYmYZ9Kyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WSE4mdrEa4VrmDwLEkO8/+v34K36Kl/YH4u56hlgYI=;
 b=kvXEw30YCgg5zRKrnJZA1agDK7V+HPgt8FeJk7y0a8wAs3RJJroCWD9AMdrHjHM8UzhqQDCctdVPaFdQ/TK86qUVcOSl8z7tgO5VjJCu3rOtk7enCBTIYDGUYHMkzShU3at2NnGMt3GmOohlN7G7949Cq1TAycXCRX4B+F5q2UM=
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:50::12)
 by DB7PR10MB1900.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:5:a::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.20; Tue, 9 Jun 2020 07:23:40 +0000
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048]) by DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 07:23:40 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Fabio Estevam <festevam@gmail.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: [PATCH v2] serial: imx: Fix handling of TC irq in combination with
 DMA
Thread-Topic: [PATCH v2] serial: imx: Fix handling of TC irq in combination
 with DMA
Thread-Index: AQHWPi7m3YXfW/ta4UitHElBbvaQXQ==
Date:   Tue, 9 Jun 2020 07:23:40 +0000
Message-ID: <20200609072259.8259-1-frieder.schrempf@kontron.de>
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
x-ms-office365-filtering-correlation-id: 7afe26dc-b56b-4626-99df-08d80c4608c8
x-ms-traffictypediagnostic: DB7PR10MB1900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR10MB19005FE8BD9790F19D23A9B3E9820@DB7PR10MB1900.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:226;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W2j+fdXqfUu2hAQNJRps9JlCOktEhEGf9CCxxtbZHyrMl/WDIvTio9k1fzKzUmzE/NM8Vjl7Q+hsLil7eek2HiMCgLBF1cXckff8Kxgn+9kfS3gonafcLk/Fo1PFNjrpb/PFLcxCkEK5OblJDd5xSSxR6TWtapy9ua0NquuYX50j4gxo1tmEMfKQJx9CFcGffHn0Vo8yojB+ACa9qT6Te0mCLQp0xqTmS3w8xDKPW0/0AhM5DK3DWuJBjs8Me8umVAADcBmPiS4DDetG+TUpIxYRUFp5WD5U0tluvECY83rdn6oQ3Jxcb9JGGoPMHjtgmSZKPxEfgVHfsNuui7oIUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(39850400004)(346002)(396003)(4326008)(66574014)(54906003)(6512007)(83380400001)(36756003)(6486002)(6916009)(2616005)(8936002)(2906002)(6506007)(66946007)(8676002)(5660300002)(478600001)(71200400001)(66476007)(91956017)(66556008)(66446008)(64756008)(316002)(86362001)(26005)(186003)(76116006)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XRF9/dQpcOu+YGCBME3YEZ8Ge2f1lJ1jl5v5bP0FnLhrqsOAdudPN0/44B5cOVeLZtx2Je3qNRhaVCXP2SLmaQiORqs4JhDnGfsO+QsnpzuQ0ylc5Q5EU4d/A344yhop27AQK3593TItZpjvr+pPvNYI2JeR66LLR92+p9d8oLMK9+A5AW2VMcyk5aZRn/+YTgyxRdjWHO5hi3o4QHZ87jaRm2fi81SsPhyD1yM5WDKLrG3sldTXMtDoSLr1C6u08+B+8UF28wSLjfUTXhPGHEbRZKAxpsC7uS4egAE9+kq1RiRHl7jpppeqqxsrLWb2GXYCZvCYIkPrfBF+gfOSkhMALDVagXghpom4SxkZgFx0Q1me8yVZQX244S/oRn4z/vApw6E3uEPb8tWgMPMmesaxihDJvEhJ8Yjl+/gyPCwIeUnLAQeY60ZUE4W+JDvrfqjp9Sy2cMZfsJwv/2fSFzLAOhWmI2N55lcDuUAfyOV9UIaszdt4FhoCNBkIBVBJ
Content-Type: text/plain; charset="utf-8"
Content-ID: <96F7689729BDA647AD496AAA4A8CB489@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afe26dc-b56b-4626-99df-08d80c4608c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 07:23:40.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOWaNgPzZVmpGPEuz0ho6WySuSLqQeZNgh0yLZbj+b308C2h7E417fhy3abqeYkzdWonou+bR0uT9li252XPpqcsl+1XQ9d0xlL2oiI7b8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB1900
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
LS0tDQogZHJpdmVycy90dHkvc2VyaWFsL2lteC5jIHwgMjIgKysrKysrKysrKysrKysrKysrLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFsL2lteC5jIGIvZHJpdmVycy90dHkvc2VyaWFs
L2lteC5jDQppbmRleCAzZjI2MDVlZGQ4NTUuLjcwYzczNzIzNjg3MCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdHR5L3NlcmlhbC9pbXguYw0KKysrIGIvZHJpdmVycy90dHkvc2VyaWFsL2lteC5jDQpA
QCAtNTM4LDYgKzUzOCwxMSBAQCBzdGF0aWMgdm9pZCBkbWFfdHhfY2FsbGJhY2sodm9pZCAqZGF0
YSkNCiANCiAJaWYgKCF1YXJ0X2NpcmNfZW1wdHkoeG1pdCkgJiYgIXVhcnRfdHhfc3RvcHBlZCgm
c3BvcnQtPnBvcnQpKQ0KIAkJaW14X2RtYV90eChzcG9ydCk7DQorCWVsc2UgaWYgKHNwb3J0LT5w
b3J0LnJzNDg1LmZsYWdzICYgU0VSX1JTNDg1X0VOQUJMRUQpIHsNCisJCXRlbXAgPSByZWFkbChz
cG9ydC0+cG9ydC5tZW1iYXNlICsgVUNSNCk7DQorCQl0ZW1wIHw9IFVDUjRfVENFTjsNCisJCXdy
aXRlbCh0ZW1wLCBzcG9ydC0+cG9ydC5tZW1iYXNlICsgVUNSNCk7DQorCX0NCiANCiAJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmc3BvcnQtPnBvcnQubG9jaywgZmxhZ3MpOw0KIH0NCkBAIC01NTUs
NiArNTYwLDEwIEBAIHN0YXRpYyB2b2lkIGlteF9kbWFfdHgoc3RydWN0IGlteF9wb3J0ICpzcG9y
dCkNCiAJaWYgKHNwb3J0LT5kbWFfaXNfdHhpbmcpDQogCQlyZXR1cm47DQogDQorCXRlbXAgPSBy
ZWFkbChzcG9ydC0+cG9ydC5tZW1iYXNlICsgVUNSNCk7DQorCXRlbXAgJj0gflVDUjRfVENFTjsN
CisJd3JpdGVsKHRlbXAsIHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1I0KTsNCisNCiAJc3BvcnQt
PnR4X2J5dGVzID0gdWFydF9jaXJjX2NoYXJzX3BlbmRpbmcoeG1pdCk7DQogDQogCWlmICh4bWl0
LT50YWlsIDwgeG1pdC0+aGVhZCB8fCB4bWl0LT5oZWFkID09IDApIHsNCkBAIC02MTcsMTAgKzYy
NiwxNSBAQCBzdGF0aWMgdm9pZCBpbXhfc3RhcnRfdHgoc3RydWN0IHVhcnRfcG9ydCAqcG9ydCkN
CiAJCWlmICghKHBvcnQtPnJzNDg1LmZsYWdzICYgU0VSX1JTNDg1X1JYX0RVUklOR19UWCkpDQog
CQkJaW14X3N0b3BfcngocG9ydCk7DQogDQotCQkvKiBlbmFibGUgdHJhbnNtaXR0ZXIgYW5kIHNo
aWZ0ZXIgZW1wdHkgaXJxICovDQotCQl0ZW1wID0gcmVhZGwocG9ydC0+bWVtYmFzZSArIFVDUjQp
Ow0KLQkJdGVtcCB8PSBVQ1I0X1RDRU47DQotCQl3cml0ZWwodGVtcCwgcG9ydC0+bWVtYmFzZSAr
IFVDUjQpOw0KKwkJLyoNCisJCSAqIEVuYWJsZSB0cmFuc21pdHRlciBhbmQgc2hpZnRlciBlbXB0
eSBpcnEgb25seSBpZiBETUEgaXMgb2ZmLg0KKwkJICogSW4gdGhlIERNQSBjYXNlIHRoaXMgaXMg
ZG9uZSBpbiB0aGUgdHgtY2FsbGJhY2suDQorCQkgKi8NCisJCWlmICghc3BvcnQtPmRtYV9pc19l
bmFibGVkKSB7DQorCQkJdGVtcCA9IHJlYWRsKHBvcnQtPm1lbWJhc2UgKyBVQ1I0KTsNCisJCQl0
ZW1wIHw9IFVDUjRfVENFTjsNCisJCQl3cml0ZWwodGVtcCwgcG9ydC0+bWVtYmFzZSArIFVDUjQp
Ow0KKwkJfQ0KIAl9DQogDQogCWlmICghc3BvcnQtPmRtYV9pc19lbmFibGVkKSB7DQotLSANCjIu
MTcuMQ0K
