Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171144227D4
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhJENci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:32:38 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3934 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhJENci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:32:38 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNz0T740vz67Lvm;
        Tue,  5 Oct 2021 21:27:37 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 15:30:45 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.008;
 Tue, 5 Oct 2021 15:30:45 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Juergen Gross <jgross@suse.com>, Heiko Carstens <hca@linux.ibm.com>
CC:     "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] s390: Fix strrchr() implementation
Thread-Topic: [PATCH v2] s390: Fix strrchr() implementation
Thread-Index: AQHXueHATFLOi7wt6E68WgfJPL6IPqvEQLAAgAACsICAACMUYA==
Date:   Tue, 5 Oct 2021 13:30:45 +0000
Message-ID: <923ea0761d4d45158acbd1347d9bb6b5@huawei.com>
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
 <YVxP0OoUWQvhmqkq@osiris> <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
In-Reply-To: <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBKdWVyZ2VuIEdyb3NzIFttYWlsdG86amdyb3NzQHN1c2UuY29tXQ0KPiBTZW50OiBU
dWVzZGF5LCBPY3RvYmVyIDUsIDIwMjEgMzoyNSBQTQ0KPiBPbiAwNS4xMC4yMSAxNToxNCwgSGVp
a28gQ2Fyc3RlbnMgd3JvdGU6DQo+ID4gT24gVHVlLCBPY3QgMDUsIDIwMjEgYXQgMDI6MDg6MzZQ
TSArMDIwMCwgUm9iZXJ0byBTYXNzdSB3cm90ZToNCj4gPj4gRml4IHR3byBwcm9ibGVtcyBmb3Vu
ZCBpbiB0aGUgc3RycmNocigpIGltcGxlbWVudGF0aW9uIGZvciBzMzkwDQo+ID4+IGFyY2hpdGVj
dHVyZXM6IGV2YWx1YXRlIGVtcHR5IHN0cmluZ3MgKHJldHVybiB0aGUgc3RyaW5nIGFkZHJlc3Mg
aW5zdGVhZCBvZg0KPiA+PiBOVUxMLCBpZiAnXDAnIGlzIHBhc3NlZCBhcyBzZWNvbmQgYXJndW1l
bnQpOyBldmFsdWF0ZSB0aGUgZmlyc3QgY2hhcmFjdGVyDQo+ID4+IG9mIG5vbi1lbXB0eSBzdHJp
bmdzICh0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBzdG9wcyBhdCB0aGUgc2Vjb25kKS4NCj4g
Pj4NCj4gPj4gRml4ZXM6IDFkYTE3N2U0YzNmNCAoIkxpbnV4LTIuNi4xMi1yYzIiKQ0KPiA+PiBD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+PiBSZXBvcnRlZC1ieTogSGVpa28gQ2Fyc3Rl
bnMgPGhjYUBsaW51eC5pYm0uY29tPiAoaW5jb3JyZWN0IGJlaGF2aW9yIHdpdGgNCj4gZW1wdHkg
c3RyaW5ncykNCj4gPj4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNz
dUBodWF3ZWkuY29tPg0KPiA+PiAtLS0NCj4gPj4gICBhcmNoL3MzOTAvbGliL3N0cmluZy5jIHwg
MTUgKysrKysrKy0tLS0tLS0tDQo+ID4+ICAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygr
KSwgOCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IEFwcGxpZWQsIHRoYW5rcyENCj4gPg0KPiANCj4g
UmVhbGx5PyBJIGp1c3Qgd2FudGVkIHRvIHdyaXRlIGEgcmVzcG9uc2U6IGxlbiBpcyB1bnNpZ25l
ZCAoc2l6ZV90KQ0KPiBhbmQgY29tcGFyZWQgdG8gYmUgPj0gMCwgd2hpY2ggc291bmRzIGxpa2Ug
YWx3YXlzIHRydWUuDQoNClRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcy4gV2lsbCBmaXggaXQuDQoN
ClJvYmVydG8NCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYw
NjMNCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQo=
