Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC0A489EF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 19:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFQRUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 13:20:53 -0400
Received: from mail-eopbgr820073.outbound.protection.outlook.com ([40.107.82.73]:55360
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbfFQRUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 13:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqaJrCrgxnuP9FTTiF6b+cE/nLHB0A2RzP/qo3U1IHg=;
 b=0VHjZjnBANeb/w95G5I4u/F8mI6XdaGx/ooExrQjTuq5TDk9eK2kRkRbh9BZ7t8YHjyQmhrX8NAXGHQI0mRRKJjGHJyAuswraNyFY2FS/9k5AtfLwEpZQoHRQ78TC72BVMskpE3K8tMLzWL2WpGln3VVVObFrpJhsUTk15mjPUk=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5303.namprd05.prod.outlook.com (20.177.127.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.12; Mon, 17 Jun 2019 17:20:48 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2008.007; Mon, 17 Jun 2019
 17:20:48 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Borislav Petkov <bp@suse.de>,
        Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] resource: Introduce resource cache
Thread-Topic: [PATCH 3/3] resource: Introduce resource cache
Thread-Index: AQHVJTEB4XE0tBkHtk2lJa7fZ26NHA==
Date:   Mon, 17 Jun 2019 17:20:48 +0000
Message-ID: <11F97160-C769-461F-ADE8-70D4A2A7A071@vmware.com>
References: <20190613045903.4922-4-namit@vmware.com>
 <20190615221607.4B44521841@mail.kernel.org>
In-Reply-To: <20190615221607.4B44521841@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a704e7df-9b53-4be6-fcbf-08d6f34823de
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5303;
x-ms-traffictypediagnostic: BYAPR05MB5303:
x-microsoft-antispam-prvs: <BYAPR05MB5303E3EBAE721E55CCF845B3D0EB0@BYAPR05MB5303.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(376002)(346002)(189003)(199004)(6512007)(8676002)(11346002)(3846002)(86362001)(81156014)(76176011)(2616005)(446003)(486006)(2906002)(186003)(26005)(476003)(6116002)(54906003)(256004)(53546011)(6506007)(25786009)(53936002)(7416002)(6246003)(4326008)(76116006)(73956011)(66946007)(7736002)(66446008)(305945005)(71190400001)(71200400001)(36756003)(64756008)(66476007)(66556008)(66066001)(6916009)(316002)(6486002)(5660300002)(99286004)(102836004)(81166006)(478600001)(8936002)(33656002)(14454004)(6436002)(229853002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5303;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c0xtzHxGc//Ba5vScAd1vLJiGHgeZNx61W7wQFdC6Oe/dkp3xjgMkZ6Be2KqYy1N/9V38F16z/p/D5JnQZRA7Q72YSPn4qxqwjkHa9Yhllr01Qf+UILx7nhRBD3NJ7nZhdAE+MbWL6OV6w/wShoCe8sJ28cjStnx7OEEAnU41ckqdS+qiAThcJl501Lfy3Xw4bmeZUDs/X7IFb0Ea7Bi5vWvb55vD7xY8xQCitgoeNZ+0M9Czp34mdbVHZHNbAHggmeVQ6mNhTXneDtno0neH5gr3/7NvUaGE1YvWJBSvbsPFUOInstFjrTQNZEnZEzbvl9YDpJhuvUqEFbRxenIPvOny4yaxQuJ1AIpXvPO5p2ZGXZZv4b2WGH9ZD5EYzPZoYmKkfhxt0uXpjtdwh3uIgy6B/V/2ztFy5mVKB+C6CA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FDAAD65E28C72469E1292356FAF4612@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a704e7df-9b53-4be6-fcbf-08d6f34823de
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 17:20:48.3625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5303
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiBKdW4gMTUsIDIwMTksIGF0IDM6MTYgUE0sIFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBIaSwNCj4gDQo+IFtUaGlzIGlzIGFuIGF1dG9tYXRlZCBlbWFp
bF0NCj4gDQo+IFRoaXMgY29tbWl0IGhhcyBiZWVuIHByb2Nlc3NlZCBiZWNhdXNlIGl0IGNvbnRh
aW5zIGEgIkZpeGVzOiIgdGFnLA0KPiBmaXhpbmcgY29tbWl0OiBmZjNjYzk1MmQzZjAgcmVzb3Vy
Y2U6IEFkZCByZW1vdmVfcmVzb3VyY2UgaW50ZXJmYWNlLg0KDQpUaGlzIGNvbW1pdCAoUGF0Y2gg
My8zKSBkb2VzIG5vdCBoYXZlIHRoZSDigJxGaXhlczrigJ0gdGFnIChhbmQgaXQgaXMgYQ0KcGVy
Zm9ybWFuY2UgZW5oYW5jZW1lbnQpLCBzbyBJIGRvbuKAmXQga25vdyB3aHkgaXQgd2FzIHByb2Nl
c3NlZC4NCg0KSU9XOiBwbGVhc2UgZG8gbm90IGJhY2twb3J0IGl0Lg0KDQo+IFRoZSBib3QgaGFz
IHRlc3RlZCB0aGUgZm9sbG93aW5nIHRyZWVzOiB2NS4xLjksIHY0LjE5LjUwLCB2NC4xNC4xMjUs
IHY0LjkuMTgxLg0KPiANCj4gdjUuMS45OiBCdWlsZCBPSyENCj4gdjQuMTkuNTA6IEZhaWxlZCB0
byBhcHBseSEgUG9zc2libGUgZGVwZW5kZW5jaWVzOg0KPiAgICAwMTBhOTNiZjk3YzcgKCJyZXNv
dXJjZTogRml4IGZpbmRfbmV4dF9pb21lbV9yZXMoKSBpdGVyYXRpb24gaXNzdWUiKQ0KPiAgICA3
YTUzYmIzMDllYjMgKCJyZXNvdXJjZTogRml4IGxvY2tpbmcgaW4gZmluZF9uZXh0X2lvbWVtX3Jl
cygpIikNCj4gICAgYTk4OTU5ZmRiZGExICgicmVzb3VyY2U6IEluY2x1ZGUgcmVzb3VyY2UgZW5k
IGluIHdhbGtfKigpIGludGVyZmFjZXMiKQ0KPiANCj4gdjQuMTQuMTI1OiBGYWlsZWQgdG8gYXBw
bHkhIFBvc3NpYmxlIGRlcGVuZGVuY2llczoNCj4gICAgMDEwYTkzYmY5N2M3ICgicmVzb3VyY2U6
IEZpeCBmaW5kX25leHRfaW9tZW1fcmVzKCkgaXRlcmF0aW9uIGlzc3VlIikNCj4gICAgMGU0YzEy
YjQ1YWE4ICgieDg2L21tLCByZXNvdXJjZTogVXNlIFBBR0VfS0VSTkVMIHByb3RlY3Rpb24gZm9y
IGlvcmVtYXAgb2YgbWVtb3J5IHBhZ2VzIikNCj4gICAgMWQyZTczM2IxM2I0ICgicmVzb3VyY2U6
IFByb3ZpZGUgcmVzb3VyY2Ugc3RydWN0IGluIHJlc291cmNlIHdhbGsgY2FsbGJhY2siKQ0KPiAg
ICA0YWMyYWVkODM3Y2IgKCJyZXNvdXJjZTogQ29uc29saWRhdGUgcmVzb3VyY2Ugd2Fsa2luZyBj
b2RlIikNCj4gICAgN2E1M2JiMzA5ZWIzICgicmVzb3VyY2U6IEZpeCBsb2NraW5nIGluIGZpbmRf
bmV4dF9pb21lbV9yZXMoKSIpDQo+ICAgIGE5ODk1OWZkYmRhMSAoInJlc291cmNlOiBJbmNsdWRl
IHJlc291cmNlIGVuZCBpbiB3YWxrXyooKSBpbnRlcmZhY2VzIikNCj4gDQo+IHY0LjkuMTgxOiBG
YWlsZWQgdG8gYXBwbHkhIFBvc3NpYmxlIGRlcGVuZGVuY2llczoNCj4gICAgMDEwYTkzYmY5N2M3
ICgicmVzb3VyY2U6IEZpeCBmaW5kX25leHRfaW9tZW1fcmVzKCkgaXRlcmF0aW9uIGlzc3VlIikN
Cj4gICAgMGU0YzEyYjQ1YWE4ICgieDg2L21tLCByZXNvdXJjZTogVXNlIFBBR0VfS0VSTkVMIHBy
b3RlY3Rpb24gZm9yIGlvcmVtYXAgb2YgbWVtb3J5IHBhZ2VzIikNCj4gICAgMWQyZTczM2IxM2I0
ICgicmVzb3VyY2U6IFByb3ZpZGUgcmVzb3VyY2Ugc3RydWN0IGluIHJlc291cmNlIHdhbGsgY2Fs
bGJhY2siKQ0KPiAgICA0YWMyYWVkODM3Y2IgKCJyZXNvdXJjZTogQ29uc29saWRhdGUgcmVzb3Vy
Y2Ugd2Fsa2luZyBjb2RlIikNCj4gICAgNjBmZTM5MTBiYjAyICgia2V4ZWNfZmlsZTogQWxsb3cg
YXJjaC1zcGVjaWZpYyBtZW1vcnkgd2Fsa2luZyBmb3Iga2V4ZWNfYWRkX2J1ZmZlciIpDQo+ICAg
IDdhNTNiYjMwOWViMyAoInJlc291cmNlOiBGaXggbG9ja2luZyBpbiBmaW5kX25leHRfaW9tZW1f
cmVzKCkiKQ0KPiAgICBhMDQ1ODI4NGYwNjIgKCJwb3dlcnBjOiBBZGQgc3VwcG9ydCBjb2RlIGZv
ciBrZXhlY19maWxlX2xvYWQoKSIpDQo+ICAgIGE5ODk1OWZkYmRhMSAoInJlc291cmNlOiBJbmNs
dWRlIHJlc291cmNlIGVuZCBpbiB3YWxrXyooKSBpbnRlcmZhY2VzIikNCj4gICAgZGE2NjU4ODU5
YjljICgicG93ZXJwYzogQ2hhbmdlIHBsYWNlcyB1c2luZyBDT05GSUdfS0VYRUMgdG8gdXNlIENP
TkZJR19LRVhFQ19DT1JFIGluc3RlYWQuIikNCj4gICAgZWMyYjliZmFhYzQ0ICgia2V4ZWNfZmls
ZTogQ2hhbmdlIGtleGVjX2FkZF9idWZmZXIgdG8gdGFrZSBrZXhlY19idWYgYXMgYXJndW1lbnQu
IikNCj4gDQo+IA0KPiBIb3cgc2hvdWxkIHdlIHByb2NlZWQgd2l0aCB0aGlzIHBhdGNoPw0KPiAN
Cj4gLS0NCj4gVGhhbmtzLA0KPiBTYXNoYQ0KDQoNCg==
