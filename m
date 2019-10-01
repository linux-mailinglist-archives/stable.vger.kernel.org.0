Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45970C41E3
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 22:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfJAUlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 16:41:47 -0400
Received: from mail-eopbgr790095.outbound.protection.outlook.com ([40.107.79.95]:60252
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726469AbfJAUlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 16:41:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUnE+UbVQEhHMO1FkTpyez8aA2Y4sZIk2JsFs3hf1PbZswSYWiwLzJ4gcupJbuKwVKPjaRIvxHWzRgQjJDwDESYKE0i7K/PLr0R0dXBnZ7ejFpbBNFNAorLmfgPyXoCGED325zdH/sn0nNfGmT3P72McfQzIAfo5fkrROL4vvF1XaszKKooblKuHCYwC/pdew/tsSWmuduaZGzt0QlPj2hzXHt52j+chCArn/t2aDvjqIDZOwOC5CmVmlglUNvahdBkIiCKOHgcxUMHaJN+srneubdyApOqdbWMPzAcEfb7alxSX2NgjFkU+Jc22Z/Ms1uKnOcLrkW7FoIsnJ3yD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBvCT8Vl+sC4mG9QiJu8WPEUnuk2/jl7iv4y4WWQpcs=;
 b=jlpnVFZ2cUB8f+UQxv8CidLC8lUNQHUjmJLyhQFbfD4Uilea6qbjob+biaPS5fh5K041v7HijErQamjBAymWGVvYxEU6qMQ7mQRJMECzONluYrSdfCVzjW45wzLJllsmmvrA/JAOMCWti1EHg+Erh4qlfKVPehm1L7joD3zVd7FV5g7BRFZiOmmRePXukQNd11GXdp3dxKdYU+5wFM/yIYCCkd5eSf1e3rtUksoacujE5zWJBEKv/+ssTxgtJkrUPGgnqKODjM612jJHMhx1Oc1HjKB/pxUEUSlY3al4cCa8FPBoIvaCzmnNJ8ENhUYFu8xrM2h60ueZKYqJqKHX6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBvCT8Vl+sC4mG9QiJu8WPEUnuk2/jl7iv4y4WWQpcs=;
 b=iMBBavONOfeUSJyCc3bg36qSxoI+iHSkx4Y3GXSICL4ZtGsU4jYBv9g/+ac6k+MXHcWQd4IxlStzWzML/xW4CxS4Rd8fls9VqMLp94RDPW494u3NxVEMKeCod/BN+2bHntviM/UAVyM0SBBW4NNySSG+g7zKYIW5Z7dgkiuAdBc=
Received: from BY5PR21MB1395.namprd21.prod.outlook.com (20.180.34.12) by
 BY5PR21MB1410.namprd21.prod.outlook.com (20.180.32.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Tue, 1 Oct 2019 20:41:43 +0000
Received: from BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc]) by BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc%2]) with mapi id 15.20.2347.003; Tue, 1 Oct 2019
 20:41:43 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven French <Steven.French@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Thread-Topic: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Thread-Index: AQHVds5cF4tEGrkArkiZ6kF9upgKeadGQl8g
Date:   Tue, 1 Oct 2019 20:41:43 +0000
Message-ID: <BY5PR21MB13958939EBDEB4122A29675EB69D0@BY5PR21MB1395.namprd21.prod.outlook.com>
References: <20190929135024.387033930@linuxfoundation.org>
 <20190929135025.151404151@linuxfoundation.org>
In-Reply-To: <20190929135025.151404151@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-01T20:41:41.7576699Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=04c45f1d-c62a-4cb3-a277-8112665b8cf6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:f:b045:70db:d1b9:d0f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be2ed7e-02e5-4c2b-6ec3-08d746afc4e0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BY5PR21MB1410:|BY5PR21MB1410:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB1410CEB045B21DF398909F28B69D0@BY5PR21MB1410.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(189003)(199004)(13464003)(446003)(46003)(6436002)(4326008)(110136005)(476003)(8990500004)(55016002)(6116002)(81156014)(486006)(10290500003)(81166006)(8676002)(7736002)(14454004)(11346002)(33656002)(8936002)(14444005)(256004)(52536014)(7696005)(6506007)(316002)(66476007)(71200400001)(2906002)(66556008)(66446008)(74316002)(2501003)(6246003)(76176011)(64756008)(53546011)(54906003)(99286004)(10090500001)(22452003)(86362001)(76116006)(186003)(229853002)(9686003)(305945005)(5660300002)(25786009)(71190400001)(66946007)(478600001)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR21MB1410;H:BY5PR21MB1395.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5MTXjxuC6amSbibmRunANC6OBbkQRMnDzRHApRubV1sWo1mohJb2U+axsz9tUutYwF2q+uOq4AJpRKTU3WiGr/nNE2xhAdZvX6r5pRUcKAsGiyZBdiPe9iPq/aaDanDco3fYJaSzNnOB9R4i1qba+ZJneWh+OiNBBa/CYbugvB9SLakYOW1WmRNxFYhbP3nq71GmYTdy4CZMzoIfEjUlZn5fN9VVf82FaJEBeYsFhKRm4zkc/Yp4xVMoKV6jm/lfN/OjeGeOLGCkk7s5NhIPVh8DJhfJDBaWXTVBUQmDkg28Km18spOgQNU4zwwZXJ+tfhAbIcr/Wk/TCy7KYiucI3sQGVq6B4hxrYEx8Usqd5MQIqxsc4MkPPDUTX0k7i0msvgZbUlwPMnFmx1CAulD3mpopX7NKpDlAuERyP3XxEw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be2ed7e-02e5-4c2b-6ec3-08d746afc4e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 20:41:43.1577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4euXsZjDClfrGw23bGlI0JbydYQJRjBzoRtsePXGxHdul+gK/idPLQBNDtN5eEqC6B1yTby/55ejkClgjW6GNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1410
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KQXJlIHlvdSBnb2luZyB0byBhcHBseSB0aGlzIHBhdGNoIHRvIHRoZSA1LjMu
eSBzdGFibGUga2VybmVsPyBUaGUgcGF0Y2ggaXMgYXBwbGljYWJsZSB0aGVyZSB0b28uDQoNCkJl
c3QgcmVnYXJkcywNClBhdmVsIFNoaWxvdnNreQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4g
DQpTZW50OiBTdW5kYXksIFNlcHRlbWJlciAyOSwgMjAxOSA2OjU2IEFNDQpUbzogbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZw0KQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBrYnVpbGQgdGVzdCByb2Jv
dCA8bGtwQGludGVsLmNvbT47IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNv
bT47IFBhdmVsIFNoaWxvdnNraXkgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT47IFN0ZXZlbiBGcmVu
Y2ggPFN0ZXZlbi5GcmVuY2hAbWljcm9zb2Z0LmNvbT47IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxA
c3VzZS5jb20+OyBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQpTdWJqZWN0OiBbUEFU
Q0ggNS4yIDAyLzQ1XSBzbWIzOiBmaXggdW5tb3VudCBoYW5nIGluIG9wZW5fc2hyb290DQoNCkZy
b206IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4NCg0KWyBVcHN0cmVhbSBj
b21taXQgOTZkOWY3ZWQwMGI4NjEwNGJmMDNhZGVmZmM4OTgwODk3ZTk2OTRhYiBdDQoNCkFuIGVh
cmxpZXIgcGF0Y2ggIkNJRlM6IGZpeCBkZWFkbG9jayBpbiBjYWNoZWQgcm9vdCBoYW5kbGluZyIN
CmRpZCBub3QgY29tcGxldGVseSBhZGRyZXNzIHRoZSBkZWFkbG9jayBpbiBvcGVuX3Nocm9vdC4g
VGhpcyBwYXRjaCBhZGRyZXNzZXMgdGhlIGRlYWRsb2NrLg0KDQpJbiB0ZXN0aW5nIHRoZSByZWNl
bnQgcGF0Y2g6DQogIHNtYjM6IGltcHJvdmUgaGFuZGxpbmcgb2Ygc2hhcmUgZGVsZXRlZCAoYW5k
IHNoYXJlIHJlY3JlYXRlZCkgd2Ugd2VyZSBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgb3Blbl9zaHJv
b3QgZGVhZGxvY2sgdG8gb25lIG9mIHRoZSB0YXJnZXQgc2VydmVycyBpbiB1bm1vdW50IGluIGEg
ZGVsZXRlIHNoYXJlIHNjZW5hcmlvLg0KDQpGaXhlczogN2U1YTcwYWQ4OGIxZSAoIkNJRlM6IGZp
eCBkZWFkbG9jayBpbiBjYWNoZWQgcm9vdCBoYW5kbGluZyIpDQoNClRoaXMgaXMgdmVyc2lvbiAy
IG9mIHRoaXMgcGF0Y2guIEFuIGVhcmxpZXIgdmVyc2lvbiBvZiB0aGlzIHBhdGNoICJzbWIzOiBm
aXggdW5tb3VudCBoYW5nIGluIG9wZW5fc2hyb290IiBoYWQgYSBwcm9ibGVtIGZvdW5kIGJ5IERh
bi4NCg0KUmVwb3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KUmVw
b3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4NCg0KU3Vn
Z2VzdGVkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4NClJldmll
d2VkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4NClNpZ25lZC1v
ZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4NCkNDOiBBdXJlbGll
biBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPg0KQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4NClNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCi0t
LQ0KIGZzL2NpZnMvc21iMm9wcy5jIHwgMjEgKysrKysrKysrKystLS0tLS0tLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYyBpbmRleCA0MmRlMzFkMjA2
MTY5Li44YWU4ZWY1MjZiNGE1IDEwMDY0NA0KLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMNCisrKyBi
L2ZzL2NpZnMvc21iMm9wcy5jDQpAQCAtNjU2LDYgKzY1NiwxNSBAQCBpbnQgb3Blbl9zaHJvb3Qo
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IGNpZnNfZmlk
ICpwZmlkKQ0KIAkJcmV0dXJuIDA7DQogCX0NCiANCisJLyoNCisJICogV2UgZG8gbm90IGhvbGQg
dGhlIGxvY2sgZm9yIHRoZSBvcGVuIGJlY2F1c2UgaW4gY2FzZQ0KKwkgKiBTTUIyX29wZW4gbmVl
ZHMgdG8gcmVjb25uZWN0LCBpdCB3aWxsIGVuZCB1cCBjYWxsaW5nDQorCSAqIGNpZnNfbWFya19v
cGVuX2ZpbGVzX2ludmFsaWQoKSB3aGljaCB0YWtlcyB0aGUgbG9jayBhZ2Fpbg0KKwkgKiB0aHVz
IGNhdXNpbmcgYSBkZWFkbG9jaw0KKwkgKi8NCisNCisJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZp
ZC5maWRfbXV0ZXgpOw0KKw0KIAlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pKQ0K
IAkJZmxhZ3MgfD0gQ0lGU19UUkFOU0ZPUk1fUkVROw0KIA0KQEAgLTY3Nyw3ICs2ODYsNyBAQCBp
bnQgb3Blbl9zaHJvb3QodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwg
c3RydWN0IGNpZnNfZmlkICpwZmlkKQ0KIA0KIAlyYyA9IFNNQjJfb3Blbl9pbml0KHRjb24sICZy
cXN0WzBdLCAmb3Bsb2NrLCAmb3Bhcm1zLCAmdXRmMTZfcGF0aCk7DQogCWlmIChyYykNCi0JCWdv
dG8gb3Nocl9leGl0Ow0KKwkJZ290byBvc2hyX2ZyZWU7DQogCXNtYjJfc2V0X25leHRfY29tbWFu
ZCh0Y29uLCAmcnFzdFswXSk7DQogDQogCW1lbXNldCgmcWlfaW92LCAwLCBzaXplb2YocWlfaW92
KSk7DQpAQCAtNjkwLDE4ICs2OTksMTAgQEAgaW50IG9wZW5fc2hyb290KHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBjaWZzX2ZpZCAqcGZpZCkNCiAJCQkJ
ICBzaXplb2Yoc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbykgKw0KIAkJCQkgIFBBVEhfTUFYICog
MiwgMCwgTlVMTCk7DQogCWlmIChyYykNCi0JCWdvdG8gb3Nocl9leGl0Ow0KKwkJZ290byBvc2hy
X2ZyZWU7DQogDQogCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbMV0pOw0KIA0KLQkvKg0KLQkgKiBX
ZSBkbyBub3QgaG9sZCB0aGUgbG9jayBmb3IgdGhlIG9wZW4gYmVjYXVzZSBpbiBjYXNlDQotCSAq
IFNNQjJfb3BlbiBuZWVkcyB0byByZWNvbm5lY3QsIGl0IHdpbGwgZW5kIHVwIGNhbGxpbmcNCi0J
ICogY2lmc19tYXJrX29wZW5fZmlsZXNfaW52YWxpZCgpIHdoaWNoIHRha2VzIHRoZSBsb2NrIGFn
YWluDQotCSAqIHRodXMgY2F1c2luZyBhIGRlYWRsb2NrDQotCSAqLw0KLQ0KLQltdXRleF91bmxv
Y2soJnRjb24tPmNyZmlkLmZpZF9tdXRleCk7DQogCXJjID0gY29tcG91bmRfc2VuZF9yZWN2KHhp
ZCwgc2VzLCBmbGFncywgMiwgcnFzdCwNCiAJCQkJcmVzcF9idWZ0eXBlLCByc3BfaW92KTsNCiAJ
bXV0ZXhfbG9jaygmdGNvbi0+Y3JmaWQuZmlkX211dGV4KTsNCi0tDQoyLjIwLjENCg0KDQoNCg==
