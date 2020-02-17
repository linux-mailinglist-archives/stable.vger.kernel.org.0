Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DA616142A
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgBQOIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:08:05 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:47656 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgBQOIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:08:04 -0500
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 6FDDF67A6E7;
        Mon, 17 Feb 2020 15:08:02 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 17 Feb
 2020 15:08:01 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Mon, 17 Feb 2020 15:08:01 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: [PATCH 2/2] serial: imx: Only handle irqs that are actually enabled
Thread-Topic: [PATCH 2/2] serial: imx: Only handle irqs that are actually
 enabled
Thread-Index: AQHV5ZuqGzZ2GGx8A0ekS0WJ9nmp0w==
Date:   Mon, 17 Feb 2020 14:08:01 +0000
Message-ID: <20200217140740.29743-3-frieder.schrempf@kontron.de>
References: <20200217140740.29743-1-frieder.schrempf@kontron.de>
In-Reply-To: <20200217140740.29743-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <C390C6B0D2C0324D8FA4BDB59F838BB8@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 6FDDF67A6E7.A1B86
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        shawnguo@kernel.org, stable@vger.kernel.org,
        u.kleine-koenig@pengutronix.de
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5pZ0BwZW5ndXRyb25peC5kZT4N
Cg0KY29tbWl0IDQzNzc2ODk2MmY3NTRkOTUwMWU1YmE0ZDk4YjFmMmE4OWRjNjIwMjggdXBzdHJl
YW0NCg0KSGFuZGxpbmcgYW4gaXJxIHRoYXQgaXNuJ3QgZW5hYmxlZCBjYW4gaGF2ZSBzb21lIHVu
ZGVzaXJlZCBzaWRlIGVmZmVjdHMuDQpTb21lIG9mIHRoZXNlIGFyZSBtZW50aW9uZWQgaW4gdGhl
IG5ld2x5IGludHJvZHVjZWQgY29kZSBjb21tZW50LiBTb21lDQpvZiB0aGUgaXJxIHNvdXJjZXMg
YWxyZWFkeSBoYWQgdGhlaXIgaGFuZGxpbmcgcmlnaHQsIHNvbWUgZG9uJ3QuIEhhbmRsZQ0KdGhl
bSBhbGwgaW4gdGhlIHNhbWUgY29uc2lzdGVudCB3YXkuDQoNClRoZSBjaGFuZ2UgZm9yIFVTUjFf
UlJEWSBhbmQgVVNSMV9BR1RJTSBkcm9wcyB0aGUgY2hlY2sgZm9yDQpkbWFfaXNfZW5hYmxlZC4g
VGhpcyBpcyBjb3JyZWN0IGFzIFVDUjFfUlJEWUVOIGFuZCBVQ1IyX0FURU4gYXJlIGFsd2F5cw0K
b2ZmIGlmIGRtYSBpcyBlbmFibGVkLg0KDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMg
djQuMTQueA0KU2lnbmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5p
Z0BwZW5ndXRyb25peC5kZT4NClJldmlld2VkLWJ5OiBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5l
bC5vcmc+DQpTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KW0JhY2twb3J0IHRvIHY0LjE0XQ0KU2lnbmVkLW9mZi1ieTogRnJpZWRl
ciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KLS0tDQogZHJpdmVycy90
dHkvc2VyaWFsL2lteC5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYyBiL2RyaXZlcnMvdHR5L3Nl
cmlhbC9pbXguYw0KaW5kZXggMzFlMWUzMmM2MmM5Li45Njk0OTc1OTllODggMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3R0eS9zZXJpYWwvaW14LmMNCisrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXgu
Yw0KQEAgLTg0MywxNCArODQzLDQyIEBAIHN0YXRpYyB2b2lkIGlteF9tY3RybF9jaGVjayhzdHJ1
Y3QgaW14X3BvcnQgKnNwb3J0KQ0KIHN0YXRpYyBpcnFyZXR1cm5fdCBpbXhfaW50KGludCBpcnEs
IHZvaWQgKmRldl9pZCkNCiB7DQogCXN0cnVjdCBpbXhfcG9ydCAqc3BvcnQgPSBkZXZfaWQ7DQot
CXVuc2lnbmVkIGludCBzdHM7DQotCXVuc2lnbmVkIGludCBzdHMyOw0KKwl1bnNpZ25lZCBpbnQg
dXNyMSwgdXNyMiwgdWNyMSwgdWNyMiwgdWNyMywgdWNyNDsNCiAJaXJxcmV0dXJuX3QgcmV0ID0g
SVJRX05PTkU7DQogDQotCXN0cyA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVU1IxKTsN
Ci0Jc3RzMiA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVU1IyKTsNCisJdXNyMSA9IHJl
YWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVU1IxKTsNCisJdXNyMiA9IHJlYWRsKHNwb3J0LT5w
b3J0Lm1lbWJhc2UgKyBVU1IyKTsNCisJdWNyMSA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2Ug
KyBVQ1IxKTsNCisJdWNyMiA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1IyKTsNCisJ
dWNyMyA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1IzKTsNCisJdWNyNCA9IHJlYWRs
KHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1I0KTsNCiANCi0JaWYgKHN0cyAmIChVU1IxX1JSRFkg
fCBVU1IxX0FHVElNKSkgew0KKwkvKg0KKwkgKiBFdmVuIGlmIGEgY29uZGl0aW9uIGlzIHRydWUg
dGhhdCBjYW4gdHJpZ2dlciBhbiBpcnEgb25seSBoYW5kbGUgaXQgaWYNCisJICogdGhlIHJlc3Bl
Y3RpdmUgaXJxIHNvdXJjZSBpcyBlbmFibGVkLiBUaGlzIHByZXZlbnRzIHNvbWUgdW5kZXNpcmVk
DQorCSAqIGFjdGlvbnMsIGZvciBleGFtcGxlIGlmIGEgY2hhcmFjdGVyIHRoYXQgc2l0cyBpbiB0
aGUgUlggRklGTyBhbmQgdGhhdA0KKwkgKiBzaG91bGQgYmUgZmV0Y2hlZCB2aWEgRE1BIGlzIHRy
aWVkIHRvIGJlIGZldGNoZWQgdXNpbmcgUElPLiBPciB0aGUNCisJICogcmVjZWl2ZXIgaXMgY3Vy
cmVudGx5IG9mZiBhbmQgc28gcmVhZGluZyBmcm9tIFVSWEQwIHJlc3VsdHMgaW4gYW4NCisJICog
ZXhjZXB0aW9uLiBTbyBqdXN0IG1hc2sgdGhlIChyYXcpIHN0YXR1cyBiaXRzIGZvciBkaXNhYmxl
ZCBpcnFzLg0KKwkgKi8NCisJaWYgKCh1Y3IxICYgVUNSMV9SUkRZRU4pID09IDApDQorCQl1c3Ix
ICY9IH5VU1IxX1JSRFk7DQorCWlmICgodWNyMiAmIFVDUjJfQVRFTikgPT0gMCkNCisJCXVzcjEg
Jj0gflVTUjFfQUdUSU07DQorCWlmICgodWNyMSAmIFVDUjFfVFhNUFRZRU4pID09IDApDQorCQl1
c3IxICY9IH5VU1IxX1RSRFk7DQorCWlmICgodWNyNCAmIFVDUjRfVENFTikgPT0gMCkNCisJCXVz
cjIgJj0gflVTUjJfVFhEQzsNCisJaWYgKCh1Y3IzICYgVUNSM19EVFJERU4pID09IDApDQorCQl1
c3IxICY9IH5VU1IxX0RUUkQ7DQorCWlmICgodWNyMSAmIFVDUjFfUlRTREVOKSA9PSAwKQ0KKwkJ
dXNyMSAmPSB+VVNSMV9SVFNEOw0KKwlpZiAoKHVjcjMgJiBVQ1IzX0FXQUtFTikgPT0gMCkNCisJ
CXVzcjEgJj0gflVTUjFfQVdBS0U7DQorCWlmICgodWNyNCAmIFVDUjRfT1JFTikgPT0gMCkNCisJ
CXVzcjIgJj0gflVTUjJfT1JFOw0KKw0KKwlpZiAodXNyMSAmIChVU1IxX1JSRFkgfCBVU1IxX0FH
VElNKSkgew0KIAkJaWYgKHNwb3J0LT5kbWFfaXNfZW5hYmxlZCkNCiAJCQlpbXhfZG1hX3J4aW50
KHNwb3J0KTsNCiAJCWVsc2UNCkBAIC04NTgsMTggKzg4NiwxNSBAQCBzdGF0aWMgaXJxcmV0dXJu
X3QgaW14X2ludChpbnQgaXJxLCB2b2lkICpkZXZfaWQpDQogCQlyZXQgPSBJUlFfSEFORExFRDsN
CiAJfQ0KIA0KLQlpZiAoKHN0cyAmIFVTUjFfVFJEWSAmJg0KLQkgICAgIHJlYWRsKHNwb3J0LT5w
b3J0Lm1lbWJhc2UgKyBVQ1IxKSAmIFVDUjFfVFhNUFRZRU4pIHx8DQotCSAgICAoc3RzMiAmIFVT
UjJfVFhEQyAmJg0KLQkgICAgIHJlYWRsKHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1I0KSAmIFVD
UjRfVENFTikpIHsNCisJaWYgKCh1c3IxICYgVVNSMV9UUkRZKSB8fCAodXNyMiAmIFVTUjJfVFhE
QykpIHsNCiAJCWlteF90eGludChpcnEsIGRldl9pZCk7DQogCQlyZXQgPSBJUlFfSEFORExFRDsN
CiAJfQ0KIA0KLQlpZiAoc3RzICYgVVNSMV9EVFJEKSB7DQorCWlmICh1c3IxICYgVVNSMV9EVFJE
KSB7DQogCQl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KLQkJaWYgKHN0cyAmIFVTUjFfRFRSRCkN
CisJCWlmICh1c3IxICYgVVNSMV9EVFJEKQ0KIAkJCXdyaXRlbChVU1IxX0RUUkQsIHNwb3J0LT5w
b3J0Lm1lbWJhc2UgKyBVU1IxKTsNCiANCiAJCXNwaW5fbG9ja19pcnFzYXZlKCZzcG9ydC0+cG9y
dC5sb2NrLCBmbGFncyk7DQpAQCAtODc5LDE3ICs5MDQsMTcgQEAgc3RhdGljIGlycXJldHVybl90
IGlteF9pbnQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KIAkJcmV0ID0gSVJRX0hBTkRMRUQ7DQog
CX0NCiANCi0JaWYgKHN0cyAmIFVTUjFfUlRTRCkgew0KKwlpZiAodXNyMSAmIFVTUjFfUlRTRCkg
ew0KIAkJaW14X3J0c2ludChpcnEsIGRldl9pZCk7DQogCQlyZXQgPSBJUlFfSEFORExFRDsNCiAJ
fQ0KIA0KLQlpZiAoc3RzICYgVVNSMV9BV0FLRSkgew0KKwlpZiAodXNyMSAmIFVTUjFfQVdBS0Up
IHsNCiAJCXdyaXRlbChVU1IxX0FXQUtFLCBzcG9ydC0+cG9ydC5tZW1iYXNlICsgVVNSMSk7DQog
CQlyZXQgPSBJUlFfSEFORExFRDsNCiAJfQ0KIA0KLQlpZiAoc3RzMiAmIFVTUjJfT1JFKSB7DQor
CWlmICh1c3IyICYgVVNSMl9PUkUpIHsNCiAJCXNwb3J0LT5wb3J0Lmljb3VudC5vdmVycnVuKys7
DQogCQl3cml0ZWwoVVNSMl9PUkUsIHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVU1IyKTsNCiAJCXJl
dCA9IElSUV9IQU5ETEVEOw0KLS0gDQoyLjE3LjENCg==
