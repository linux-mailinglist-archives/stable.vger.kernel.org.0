Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8576737B946
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhELJcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:32:35 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:50414 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230403AbhELJc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:32:26 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-79-oLFw4AwlPEex5jOXqlFBlw-1; Wed, 12 May 2021 10:31:12 +0100
X-MC-Unique: oLFw4AwlPEex5jOXqlFBlw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 12 May 2021 10:31:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Wed, 12 May 2021 10:31:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Juergen Gross' <jgross@suse.com>, 'Joerg Roedel' <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Thread-Topic: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Thread-Index: AQHXRwQswpicLJM6a0eoGXhfP+3kQqrfe29ggAAQd36AAAai8A==
Date:   Wed, 12 May 2021 09:31:10 +0000
Message-ID: <8cdbb6928c7144c6b065c3ff68f03aee@AcuMS.aculab.com>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com> <YJuW4TtRJKZ+OIhj@8bytes.org>
 <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
In-Reply-To: <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSnVlcmdlbiBHcm9zcw0KPiBTZW50OiAxMiBNYXkgMjAyMSAwOTo1OA0KPiANCj4gT24g
MTIuMDUuMjEgMTA6NTAsICdKb2VyZyBSb2VkZWwnIHdyb3RlOg0KPiA+IE9uIFdlZCwgTWF5IDEy
LCAyMDIxIGF0IDEwOjE2OjEyQU0gKzAyMDAsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+ID4+IFlv
dSB3YW50IHNvbWV0aGluZyBsaWtlIHhlbl9zYWZlX1tyZWFkfHdyaXRlXV91bG9uZygpLg0KPiA+
DQo+ID4gIEZyb20gYSBmaXJzdCBnbGFuY2UgSSBjYW4ndCBzZWUgaXQsIHdoYXQgaXMgdGhlIGRp
ZmZlcmVuY2UgYmV0d2VlbiB0aGUNCj4gPiB4ZW5fc2FmZV8qX3Vsb25nKCkgZnVuY3Rpb25zIGFu
ZCBfX2dldF91c2VyKCkvX19wdXRfdXNlcigpPyBUaGUgb25seQ0KPiA+IGRpZmZlcmVuY2UgSSBj
YW4gc2VlIGlzIHRoYXQgX19nZXQvX19wdXRfdXNlcigpIHN1cHBvcnQgZGlmZmVyZW50IGFjY2Vz
cw0KPiA+IHNpemVzLCBidXQgbmVpdGhlciBvZiB0aG9zZSBkaXNhYmxlcyBwYWdlLWZhdWx0cyBi
eSBpdHNlbGYsIGZvciBleGFtcGxlLg0KPiA+DQo+ID4gQ291bGRuJ3QgdGhlc2UgeGVuLXNwZWNp
ZmljIGZ1bmN0aW9ucyBub3QgYWxzbyBiZSByZXBsYWNlcyBieQ0KPiA+IF9fZ2V0X3VzZXIoKS9f
X3B1dF91c2VyKCk/DQo+IA0KPiBObywgdGhvc2Ugd2VyZSB1c2VkIGJlZm9yZSwgYnV0IGNvbW1p
dCA5ZGEzZjJiNzQwNTQ0MCBicm9rZSBYZW4ncyB1c2UNCj4gY2FzZS4gVGhhdCBpcyB3aHkgSSBk
aWQgY29tbWl0IDE0NTdkOGNmNzY2NGYuDQoNCkkndmUganVzdCBsb29rZWQgYXQgOWRhM2YyYjc0
MDU0NDAuDQoNCkl0IGRvZXNuJ3QgbG9vayByaWdodCB0byBtZSAtIHdyb25nIHJldHVybiB2YWx1
ZSBmb3IgYSBsb3Qgb2YgY2FzZXMuDQpPVE9IIGl0IGlzbid0IGluIG15IG5ld2VzdCB0cmVlIGF0
IGFsbC4NCg0KSWYgYm9ndXNfdWFjY2VzcygpIGlzIG5vdyBlbHNld2hlcmUgSSBjYW4ndCBzZWUg
aG93ICh3aXRob3V0IGNoYW5nZXMpDQppdCB3b3VsZCBhbGxvdyB0aHJvdWdoIHRoZXNlIGZhdWx0
cy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

