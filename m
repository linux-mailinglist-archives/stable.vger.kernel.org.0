Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A06114B9A
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 05:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLFEQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 23:16:06 -0500
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:58464
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbfLFEQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 23:16:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIlRrzdNNBjjHsrLRO7XUxKq3qGdP0SQ43iDAb4ZZmrgFehu5IO26/v4qTmpNyKtUffXwN6jszhi7MIG8Vw1A5JuULyhDp5jCzhglnPtS+NrtPZ2TX77vuCaKriRG/cWbqVdz0GZDtzEMjZ95a/+02gNf5FFCV9P6BmLiiIVBpahnwAB2y7/eS6d20F+hNRqWPHI7oaFGrzbn4urtPmWgj7yRjZB9N/6PhtmG9ObGRk7QRPJCOr0KuaMJlH6cR9BMtTyqsCGNshkQ6C5fwRorDvghIO2iiN4T2Yrr/0NcchH8fNwTG/puQGDn5H861MICHt5lSFmNnG8IlX/mWAYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f0XGw89FbYPzO1tQ01o5TQyQoYdZAOyrECq+yi1EPs=;
 b=hyF8nPIWLc8eVSgvybzWmOpXCohLWE7PoCB3wwBXNx48Fbpqi3KtwoUX0e7VC5Voeuc1cN+cl+OajhP0pyRCx9G8paq7oVmx9VmxQf1NnvBRmYavAYSb/rgZhWfuA53QZWfLmeTWOzuftRDsgcFiPCdBP7oSjRQUBqrgc2dfbkCoov+J8g3KbAiX7O07rQYglWUtUrFZhfb2EoU3U6+tD+RhOwsyFx/PcObxgri8shsoLDy+8eUw97borOXNSEIFgUA+bM7SG304Qt9nqvVT/24E6dtfJgLApKlSOIueOY5yjTxBT6h79IRWcgeSJjyl1Md2MrSVT3WDmLx2UPbhnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f0XGw89FbYPzO1tQ01o5TQyQoYdZAOyrECq+yi1EPs=;
 b=zNMvv/7vbC/JBZopTGcKZTR9FUhXRIZRE7XnzwyuU0H331IQZnbDM2i485p5bBUseuIKd+ahYvly9qeWpbY3W6omcq+pl5IHxSmhH5ZpB6ozyR0eRgxPz3voKkiFooZtUjpAaXTEfx0xuTrhLP2BYjgtYGlXTYYySxpxqPBdgjE=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6190.namprd05.prod.outlook.com (20.178.240.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.6; Fri, 6 Dec 2019 04:15:24 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2538.000; Fri, 6 Dec 2019
 04:15:23 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH STABLE 4.4 5/8] mm: prevent get_user_pages() from
 overflowing page refcount
Thread-Topic: [PATCH STABLE 4.4 5/8] mm: prevent get_user_pages() from
 overflowing page refcount
Thread-Index: AQHVlhhHx12DFRikrEimDS6JVcInLqeo2SgA//+tL4CABIDdgA==
Date:   Fri, 6 Dec 2019 04:15:23 +0000
Message-ID: <68445EC7-1814-48C4-B88C-9C1E00489418@vmware.com>
References: <20191108093814.16032-1-vbabka@suse.cz>
 <20191108093814.16032-6-vbabka@suse.cz>
 <519D18AF-DD01-4107-96D2-D8E33058B2CB@vmware.com>
 <a490e671-7291-4a82-ad27-0a18c17d7272@suse.cz>
In-Reply-To: <a490e671-7291-4a82-ad27-0a18c17d7272@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2fa0ada-cc22-4cc4-b03c-08d77a02ea81
x-ms-traffictypediagnostic: MN2PR05MB6190:|MN2PR05MB6190:|MN2PR05MB6190:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB619059AA80B9707BC74B12FBBB5F0@MN2PR05MB6190.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(6486002)(66556008)(14454004)(64756008)(66946007)(66446008)(76116006)(81156014)(81166006)(54906003)(26005)(8676002)(66476007)(102836004)(99286004)(186003)(110136005)(86362001)(6512007)(316002)(5660300002)(229853002)(91956017)(6506007)(478600001)(966005)(71190400001)(71200400001)(305945005)(4326008)(2906002)(45080400002)(36756003)(11346002)(25786009)(2616005)(76176011)(33656002)(7416002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6190;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J4dl2vA+zTZtfHEFPvD/k/mSj05mhCJyUtujpsWyqStUMrQNCCwNp9moLt0fvYVR7RvJZjnkDsLMnhrl0E/abp0lW78moWXgT/piqYOcq1+P9VjApIbF4mWu5OV3OfaIaIRWWKLNfydKyvDEJJWS2D1SnVOZuHQTmdNbUUO0SPSnuZra3SYXjqrh7M7NgqMxIwFqQAHCCsccg6fSMWv9RtJ9nHWXNKtlQmFvEdUamMnQQmnl++UmDtrmmrnSd8+MsddYQih3s0YZtyWRLIMKi2V0ew71SBYe+C36JbtE6w+rzqOSeFqO00kgmN3uRoveKEYr7M9XoA5r6io3F3oEqC0uH0QPXTDT/baXUJ90X9JCVAPdGA6HzSWfVpiW2Q7idhYbXZBFKMSQ+1q0Ab7ewfJnIvI5C4nUP1s1Cynk7Fz/ZiSIA351Hydif+bpPuDTM0OSmIBst0cnpEGcT38PnVbrZDo+xikWhxrmtLhZeZ4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2804C14BE5A7B546A6DD675D84E5CA5A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fa0ada-cc22-4cc4-b03c-08d77a02ea81
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 04:15:23.6677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Binwo4suVXwJC9yl5l7l5xmr93ykPK3U/4yqdV3JBmb8UMbPaeaXn3arU/vfPwUaCPOWBpV/eO4/ngqW558NjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6190
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDAzLzEyLzE5LCA2OjI4IFBNLCAiVmxhc3RpbWlsIEJhYmthIiA8dmJhYmthQHN1
c2UuY3o+IHdyb3RlOg0KPj4+ICAgIA0KPj4+IFsgNC40IGJhY2twb3J0OiB0aGVyZSdzIGdldF9w
YWdlX2ZvbGwoKSwgc28gYWRkIHRyeV9nZXRfcGFnZSgpLWxpa2UgY2hlY2tzDQo+Pj4gICAgICAg
ICAgICAgICAgIGluIHRoZXJlLCBlbmFibGVkIGJ5IGEgbmV3IHBhcmFtZXRlciwgd2hpY2ggaXMg
ZmFsc2Ugd2hlcmUNCj4+PiAgICAgICAgICAgICAgICAgdXBzdHJlYW0gcGF0Y2ggZG9lc24ndCBy
ZXBsYWNlIGdldF9wYWdlKCkgd2l0aCB0cnlfZ2V0X3BhZ2UoKQ0KPj4+ICAgICAgICAgICAgICAg
ICAodGhlIFRIUCBhbmQgaHVnZXRsYiBjYWxsZXJzKS4NCj4+IA0KPj4gQ291bGQgd2UgaGF2ZSB0
cnlfZ2V0X3BhZ2VfZm9sbCgpLCBhcyBpbjoNCj4+IGh0dHBzOi8vbmFtMDQuc2FmZWxpbmtzLnBy
b3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmxvcmUua2VybmVsLm9yZyUy
RnN0YWJsZSUyRjE1NzA1ODE4NjMtMTIwOTAtMy1naXQtc2VuZC1lbWFpbC1ha2FoZXIlNDB2bXdh
cmUuY29tJTJGJmFtcDtkYXRhPTAyJTdDMDElN0Nha2FoZXIlNDB2bXdhcmUuY29tJTdDYjY1OTJm
MGZiZWMwNDBhYTA0NWYwOGQ3NzdmMDZhOWYlN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRk
NjJmMCU3QzAlN0MwJTdDNjM3MTA5NzQ2ODIxMzk1NDQ0JmFtcDtzZGF0YT1jWUJqM1N2RWlrUGJp
SHNWWmozekN5czh0OUlTTGlIS3pBbHNTcWlaUlc4JTNEJmFtcDtyZXNlcnZlZD0wDQo+PiANCj4+
ICsgQ29kZSB3aWxsIGJlIGluIHN5bmMgYXMgd2UgaGF2ZSB0cnlfZ2V0X3BhZ2UoKQ0KPj4gKyBO
byBuZWVkIHRvIGFkZCBleHRyYSBhcmd1bWVudCB0byB0cnlfZ2V0X3BhZ2UoKQ0KPj4gKyBObyBu
ZWVkIHRvIG1vZGlmeSB0aGUgY2FsbGVycyBvZiB0cnlfZ2V0X3BhZ2UoKQ0KDQpBbnkgcmVhc29u
IGZvciBub3QgdXNpbmcgdHJ5X2dldF9wYWdlX2ZvbGwoKS4NCg0KPj4+IAkJSW4gZ3VwX3B0ZV9y
YW5nZSgpLCB3ZSBkb24ndCBleHBlY3QgdGFpbCBwYWdlcywgc28ganVzdCBjaGVjaw0KPj4+ICAg
ICAgICAgICAgICAgICBwYWdlIHJlZiBjb3VudCBpbnN0ZWFkIG9mIHRyeV9nZXRfY29tcG91bmRf
aGVhZCgpDQo+PiANCj4+IFRlY2huaWNhbGx5IGl0J3MgZmluZS4gSWYgeW91IHdhbnQgdG8ga2Vl
cCB0aGUgY29kZSBvZiBzdGFibGUgdmVyc2lvbnMgaW4gc3luYw0KPj4gd2l0aCBsYXRlc3QgdmVy
c2lvbnMgdGhlbiB0aGlzIGNvdWxkIGJlIGRvbmUgaW4gZm9sbG93aW5nIHdheXMgKHdpdGhvdXQg
YW55DQo+PiBtb2RpZmljYXRpb24gaW4gdXBzdHJlYW0gcGF0Y2ggZm9yIGd1cF9wdGVfcmFuZ2Uo
KSk6DQo+PiANCj4+IEFwcGx5IDdhZWY0MTcyYzc5NTdkN2U2NWZjMTcyYmU0Yzk5YmVjYWVmODU1
ZDQgYmVmb3JlIGFwcGx5aW5nDQo+PiA4ZmRlMTJjYTc5YWZmOWI1YmE5NTFmY2UxYTI2NDE5MDFi
OGQ4ZTY0LCBhcyBkb25lIGhlcmU6DQo+PiBodHRwczovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0
aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZsb3JlLmtlcm5lbC5vcmclMkZzdGFi
bGUlMkYxNTcwNTgxODYzLTEyMDkwLTQtZ2l0LXNlbmQtZW1haWwtYWthaGVyJTQwdm13YXJlLmNv
bSUyRiZhbXA7ZGF0YT0wMiU3QzAxJTdDYWthaGVyJTQwdm13YXJlLmNvbSU3Q2I2NTkyZjBmYmVj
MDQwYWEwNDVmMDhkNzc3ZjA2YTlmJTdDYjM5MTM4Y2EzY2VlNGI0YWE0ZDZjZDgzZDlkZDYyZjAl
N0MwJTdDMCU3QzYzNzEwOTc0NjgyMTM5NTQ0NCZhbXA7c2RhdGE9Z1RKTUozWXg2RzBuZzQ2VFFz
QnpDUzJEb3d3UDdZdElqbHVLSnVxdk42byUzRCZhbXA7cmVzZXJ2ZWQ9MA0KICAgIA0KPiBZdXAs
IEkgaGF2ZSBjb25zaWRlcmVkIHRoYXQsIGFuZCBkZWxpYmVyYXRlbHkgZGlkbid0IGFkZCB0aGF0
IGNvbW1pdA0KPiA3YWVmNDE3MmM3OTUgKCJtbTogaGFuZGxlIFBURS1tYXBwZWQgdGFpbCBwYWdl
cyBpbiBnZXJuZXJpYyBmYXN0IGd1cA0KPiBpbXBsZW1lbnRhaXRvbiIpIGFzIGl0J3MgcGFydCBv
ZiBhIGxhcmdlIFRIUCByZWZjb3VudCByZXdvcmsuIEluIDQuNCB3ZQ0KPiBkb24ndCBleHBlY3Qg
dG8gR1VQIHRhaWwgcGFnZXMgc28gSSB3YW50ZWQgdG8ga2VlcCBpdCB0aGF0IHdheSAtDQo+IG1p
bmltYWxseSwgdGhlIGNvbXBvdW5kX2hlYWQoKSBvcGVyYXRpb24gaXMgYSB1bm5lY2Vzc2FyeSBh
ZGRlZCBjb3N0LA0KPiBhbHRob3VnaCBpdCB3b3VsZCBhbHNvIHdvcmsuDQogICAgDQoNCg==
