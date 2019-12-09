Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18541168B2
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfLIIzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:55:00 -0500
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:6034
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727044AbfLIIzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 03:55:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEw83s9vsTzHg46GEt170rGMSaayOa35eRXbqf1ECvcgu3vRkPHxEx95uOTzkgLpkrBuoZmugteJYudxitFw1in1Z00+XAWXXNtwBs1MbI6pCGaJHozFe2xiaIgSr/EEtoc9E9CQqm4PVDZTQegBuGjZxJHlMk9BbRF/1tUM/1QPmoHxTdDp/Nd14uPTx7OurBCKYYn13VyRVUGtc1upgNtOBsAsEjFYI175QAIBWxeYw7yavjddJoX40QEofezVrbTYnUlnFeSUVPkyQZ+WYgdU7vw6aXIk4nq3zHiXLfO21SVfDkTQyo5GpwhzgRaYWE4Bd5GuqmJP3fUscQ+fKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFiVCoN3WXXtSv9yf9QhPUkjoDQogUvAHD0K82jNxNY=;
 b=MvF5AFZMDY5JiccUK/6PfP/EQ7Q+2KqEWR9c3aVlkE64NTT7o4dRNL0ftSfsDySZPXyUXIv9UQSVB2CgbOAIhjykfKmw40YJA7oK9e02kDp6cqoSmo3szMlkNmPyvCKXP/gsRqd1iCMmwV8TJYPC9jfT8l68BmbabWI4vJXm6dolinJTGy+Ou+/c7OSSiydRdUjvaxVfxrhCClsier/q3iaRCQYhKI68+uPxL9biE2XPImYqy9U2WP7WDlJ4UKZgXnEt5ZcFLrUPY7ztU0i2/ykegd4vCzLtDjskoIDcCSGx55wA7StnFQo/OPc3fYbsYV76rqmSQwePoDh9pTR3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFiVCoN3WXXtSv9yf9QhPUkjoDQogUvAHD0K82jNxNY=;
 b=hGCnm5cPZu/ALl5X8bZaPRHeT9c0IAR3SDH5tpmpQVL/U5sKrDcI1mEAhsE3YHzzOtEh1onteMXnjDShee+7rd3l3tXBtQ0bWZFLH4QFXuzAA1jkojdPMHjWnfqtHPdLM+UBBUsLRlTeh6vm2D2C0mw52Jc+gZa+o6xmBErlnKg=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6045.namprd05.prod.outlook.com (20.178.243.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Mon, 9 Dec 2019 08:54:56 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2538.012; Mon, 9 Dec 2019
 08:54:56 +0000
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
Thread-Index: AQHVlhhHx12DFRikrEimDS6JVcInLqeo2SgA//+tL4CABIDdgIAAUH2AgAS08AA=
Date:   Mon, 9 Dec 2019 08:54:55 +0000
Message-ID: <64284E33-3828-46E9-AFFB-649E0DA41023@vmware.com>
References: <20191108093814.16032-1-vbabka@suse.cz>
 <20191108093814.16032-6-vbabka@suse.cz>
 <519D18AF-DD01-4107-96D2-D8E33058B2CB@vmware.com>
 <a490e671-7291-4a82-ad27-0a18c17d7272@suse.cz>
 <68445EC7-1814-48C4-B88C-9C1E00489418@vmware.com>
 <fc4e3b6e-90fc-cd9f-75ad-452b060250d6@suse.cz>
In-Reply-To: <fc4e3b6e-90fc-cd9f-75ad-452b060250d6@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 330aba53-9465-4c12-aea7-08d77c8576cc
x-ms-traffictypediagnostic: MN2PR05MB6045:|MN2PR05MB6045:|MN2PR05MB6045:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB60454554DE24F000C6A77748BB580@MN2PR05MB6045.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(189003)(199004)(6486002)(966005)(6512007)(91956017)(478600001)(76176011)(76116006)(66446008)(64756008)(66556008)(66476007)(45080400002)(66946007)(71200400001)(71190400001)(229853002)(186003)(33656002)(2616005)(54906003)(110136005)(86362001)(4326008)(7416002)(316002)(305945005)(8936002)(102836004)(5660300002)(81166006)(81156014)(8676002)(99286004)(36756003)(26005)(53546011)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6045;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ne5uX2n+2gTAJoMYiQLVK2flmX+b0COBPuBwgR5EVOnTs6IdPrgaGw3UKUYFLUKM8C7nEJckCzTSLQRQKUnIh5JUB7u6l/2Mjw7QM6WFSnYBXG28miqJ7jI4b7th5uTNZL8peAaj9ACMPVoMErhxA8WX8nNmuOxVIdmfPBr4PC/oAgM7gjbQYvZmivA7p9oL+cH1J8mQ+TPw4dvwdMS33TLiEI7DO1lHCgxABH9f9tnzpg654mcFWGi8wCrG39AO/2WeRB8gumFMQtnCs+hfYaazsL0LYxnglFY6BSAPqj0IvxmxRiniEd7lca3ASUGqlocUDfzD8gQKN0JHy+C3EvnhipzzE4GXubXUMsDcEUr8rXePlFrjocTGBzfrtfC9jGlq6o2IbsHAQPs7zbPHc2O5AgRpDjEztLTofecnIl7d3qMXtHsGajjtIw1jtHqz7LKVZtz5rGEK2fKo2YS9Ob843ZkStzkeIxNJ/ysWBc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98FC6CCB6D3B3A4BABA7314599B3EA05@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330aba53-9465-4c12-aea7-08d77c8576cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 08:54:56.0415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKLXpZPNKxpt2Xnd4KhlADcG+WziCDLSUQ+c/nf5F1KyewyFUFI6Rih8toFf2xy8zDtRF2Gy57XRhoJSqVb6bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6045
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDA2LzEyLzE5LCA4OjAyIFBNLCAiVmxhc3RpbWlsIEJhYmthIiA8dmJhYmthQHN1
c2UuY3o+IHdyb3RlOg0KDQo+IE9uIDEyLzYvMTkgNToxNSBBTSwgQWpheSBLYWhlciB3cm90ZToN
Cj4+IA0KPj4gDQo+PiBPbiAwMy8xMi8xOSwgNjoyOCBQTSwgIlZsYXN0aW1pbCBCYWJrYSIgPHZi
YWJrYUBzdXNlLmN6PiB3cm90ZToNCj4+Pj4+ICAgIA0KPj4+Pj4gWyA0LjQgYmFja3BvcnQ6IHRo
ZXJlJ3MgZ2V0X3BhZ2VfZm9sbCgpLCBzbyBhZGQgdHJ5X2dldF9wYWdlKCktbGlrZSBjaGVja3MN
Cj4+Pj4+ICAgICAgICAgICAgICAgICBpbiB0aGVyZSwgZW5hYmxlZCBieSBhIG5ldyBwYXJhbWV0
ZXIsIHdoaWNoIGlzIGZhbHNlIHdoZXJlDQo+Pj4+PiAgICAgICAgICAgICAgICAgdXBzdHJlYW0g
cGF0Y2ggZG9lc24ndCByZXBsYWNlIGdldF9wYWdlKCkgd2l0aCB0cnlfZ2V0X3BhZ2UoKQ0KPj4+
Pj4gICAgICAgICAgICAgICAgICh0aGUgVEhQIGFuZCBodWdldGxiIGNhbGxlcnMpLg0KPj4+Pg0K
Pj4+PiBDb3VsZCB3ZSBoYXZlIHRyeV9nZXRfcGFnZV9mb2xsKCksIGFzIGluOg0KPj4+PiBodHRw
czovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0El
MkYlMkZsb3JlLmtlcm5lbC5vcmclMkZzdGFibGUlMkYxNTcwNTgxODYzLTEyMDkwLTMtZ2l0LXNl
bmQtZW1haWwtYWthaGVyJTQwdm13YXJlLmNvbSUyRiZhbXA7ZGF0YT0wMiU3QzAxJTdDYWthaGVy
JTQwdm13YXJlLmNvbSU3Q2I2NWNmNTYyMmNhODQwMWZkMmJhMDhkNzdhNTkxNGU4JTdDYjM5MTM4
Y2EzY2VlNGI0YWE0ZDZjZDgzZDlkZDYyZjAlN0MwJTdDMCU3QzYzNzExMjM5NTM0NDMzODYwNiZh
bXA7c2RhdGE9c0xidyUyQlFXdTAlMkJCMHkyT3BmYVFTJTJGeFhYNlo5ak5CM3dQZVRjUHNhd05K
QSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPj4+Pg0KPj4+PiArIENvZGUgd2lsbCBiZSBpbiBzeW5jIGFz
IHdlIGhhdmUgdHJ5X2dldF9wYWdlKCkNCj4+Pj4gKyBObyBuZWVkIHRvIGFkZCBleHRyYSBhcmd1
bWVudCB0byB0cnlfZ2V0X3BhZ2UoKQ0KPj4+PiArIE5vIG5lZWQgdG8gbW9kaWZ5IHRoZSBjYWxs
ZXJzIG9mIHRyeV9nZXRfcGFnZSgpDQo+PiANCj4+IEFueSByZWFzb24gZm9yIG5vdCB1c2luZyB0
cnlfZ2V0X3BhZ2VfZm9sbCgpLg0KPiAgICANCj4gQWgsIHNvcnJ5LCBJIG1pc3NlZCB0aGF0IHBy
ZXZpb3VzbHkuIEl0J3MgY2VydGFpbmx5IHBvc3NpYmxlIHRvIGRvIGl0DQo+IHRoYXQgd2F5LCBJ
IGp1c3QgZGlkbid0IGNhcmUgc28gc3Ryb25nbHkgdG8gcmV3cml0ZSB0aGUgZXhpc3RpbmcgU0xF
Uw0KPiBwYXRjaC4gSXQncyBhIHN0YWJsZSBiYWNrcG9ydCBmb3IgYSByYXRoZXIgb2xkIExUUywg
bm90IGEgY29kZWJhc2UgZm9yDQo+IGZ1cnRoZXIgZGV2ZWxvcG1lbnQuDQogDQpUaGFua3MgZm9y
IHlvdXIgcmVzcG9uc2UuDQoNCkkgd291bGQgYXBwcmVjaWF0ZSBpZiB5b3Ugd291bGQgbGlrZSB0
byBpbmNsdWRlIHRyeV9nZXRfcGFnZV9mb2xsKCksDQphbmQgcmVzZW5kIHRoaXMgcGF0Y2ggc2Vy
aWVzIGFnYWluLg0KDQpHcmVnIG1heSByZXF1aXJlIEFja2VkLWJ5IGZyb20gbXkgc2lkZSBhbHNv
LCBzbyBpZiBpdCdzIGZpbmUgd2l0aCB5b3UsDQp5b3UgY2FuIGFkZCBvciBJIHdpbGwgYWRkIG9u
Y2UgeW91IHdpbGwgcG9zdCB0aGlzIHBhdGNoIHNlcmllcyBhZ2Fpbi4NCg0KTGV0IG1lIGtub3cg
aWYgYW55dGhpbmcgZWxzZSBJIGNhbiBkbyBoZXJlLg0KDQo+Pj4+PiAJCUluIGd1cF9wdGVfcmFu
Z2UoKSwgd2UgZG9uJ3QgZXhwZWN0IHRhaWwgcGFnZXMsIHNvIGp1c3QgY2hlY2sNCj4+Pj4+ICAg
ICAgICAgICAgICAgICBwYWdlIHJlZiBjb3VudCBpbnN0ZWFkIG9mIHRyeV9nZXRfY29tcG91bmRf
aGVhZCgpDQo+Pj4+DQo+Pj4+IFRlY2huaWNhbGx5IGl0J3MgZmluZS4gSWYgeW91IHdhbnQgdG8g
a2VlcCB0aGUgY29kZSBvZiBzdGFibGUgdmVyc2lvbnMgaW4gc3luYw0KPj4+PiB3aXRoIGxhdGVz
dCB2ZXJzaW9ucyB0aGVuIHRoaXMgY291bGQgYmUgZG9uZSBpbiBmb2xsb3dpbmcgd2F5cyAod2l0
aG91dCBhbnkNCj4+Pj4gbW9kaWZpY2F0aW9uIGluIHVwc3RyZWFtIHBhdGNoIGZvciBndXBfcHRl
X3JhbmdlKCkpOg0KPj4+Pg0KPj4+PiBBcHBseSA3YWVmNDE3MmM3OTU3ZDdlNjVmYzE3MmJlNGM5
OWJlY2FlZjg1NWQ0IGJlZm9yZSBhcHBseWluZw0KPj4+PiA4ZmRlMTJjYTc5YWZmOWI1YmE5NTFm
Y2UxYTI2NDE5MDFiOGQ4ZTY0LCBhcyBkb25lIGhlcmU6DQo+Pj4+IGh0dHBzOi8vbmFtMDQuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmxvcmUua2Vy
bmVsLm9yZyUyRnN0YWJsZSUyRjE1NzA1ODE4NjMtMTIwOTAtNC1naXQtc2VuZC1lbWFpbC1ha2Fo
ZXIlNDB2bXdhcmUuY29tJTJGJmFtcDtkYXRhPTAyJTdDMDElN0Nha2FoZXIlNDB2bXdhcmUuY29t
JTdDYjY1Y2Y1NjIyY2E4NDAxZmQyYmEwOGQ3N2E1OTE0ZTglN0NiMzkxMzhjYTNjZWU0YjRhYTRk
NmNkODNkOWRkNjJmMCU3QzAlN0MwJTdDNjM3MTEyMzk1MzQ0MzQ4NTk5JmFtcDtzZGF0YT1NWUEl
MkZ4N29WdTh4MWM3JTJGR2tFdyUyQjY5Rlg3V04xTzM0T3E4bGtNaUZzMVdrJTNEJmFtcDtyZXNl
cnZlZD0wDQo+PiAgICAgDQo+Pj4gWXVwLCBJIGhhdmUgY29uc2lkZXJlZCB0aGF0LCBhbmQgZGVs
aWJlcmF0ZWx5IGRpZG4ndCBhZGQgdGhhdCBjb21taXQNCj4+PiA3YWVmNDE3MmM3OTUgKCJtbTog
aGFuZGxlIFBURS1tYXBwZWQgdGFpbCBwYWdlcyBpbiBnZXJuZXJpYyBmYXN0IGd1cA0KPj4+IGlt
cGxlbWVudGFpdG9uIikgYXMgaXQncyBwYXJ0IG9mIGEgbGFyZ2UgVEhQIHJlZmNvdW50IHJld29y
ay4gSW4gNC40IHdlDQo+Pj4gZG9uJ3QgZXhwZWN0IHRvIEdVUCB0YWlsIHBhZ2VzIHNvIEkgd2Fu
dGVkIHRvIGtlZXAgaXQgdGhhdCB3YXkgLQ0KPj4+IG1pbmltYWxseSwgdGhlIGNvbXBvdW5kX2hl
YWQoKSBvcGVyYXRpb24gaXMgYSB1bm5lY2Vzc2FyeSBhZGRlZCBjb3N0LA0KPj4+IGFsdGhvdWdo
IGl0IHdvdWxkIGFsc28gd29yay4NCj4+ICAgICANCg0KVGhhbmtzIGZvciBhYm92ZSBleHBsYW5h
dGlvbi4NCiAgICANCiAgICANCg0K
