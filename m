Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C4124BD31
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgHTNBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:01:01 -0400
Received: from mail-bn8nam12on2111.outbound.protection.outlook.com ([40.107.237.111]:36128
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbgHTNAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 09:00:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0wj0Wb1Wk4e4QC/Oe6eBF3Y1PTIMN3yCbRLSrzJmV8OomtDixUcn/0NKWO932m4+yxokzC63sMuR4bmMXBl+SKxfD2K7kjTobmWxqd+DmoXwILwnfdRbS8rZwUe9TSLnwbdCrsgpUhd8rAunnROlDGl4vxzExvThzxES6PK2UmR6a0LmFufTVQgWQHDP6p5nrGCC/DXxc6KlN/kQKe6EDX8UGHakiN7VhtNXTuM4AnLksa9Hxc9tbZl2isuI3BUvVjQY7EA/0ZIKRdWKnycZ/6AtmRBUfXU8XfUJZ0YQdmf6kkTtg6zQzN49T8wDFJzmUh13c/e3+Pt+k7s3m37Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt2fmnaVy3yPlDFKenJzzRcvsLekjlvXNYE2amN0r8c=;
 b=mvhGMxUd3seoW+/lX+mcfgcDyFxfQCmslUwMyIPSuPOiPEVCgMyLXIgGjC2BsEuDR5LeORVbdkJlOl/qahsfz8PrBqdNZetAUAergHeviRZiBdR1fF8Fncs0dVccm0Wum5rWmUFihgjt05AveezeM7tWc82Tgnb+0jKiRwCZAwgtaz5BuDutY1BT+74BtntCwL7XqbFagRyzCER7byToefypXNfh8S1DNkLfpRww0O9j8lkbVqcyBu6tCXQl7BRsVOsS6zu8oMxMRd7HENmlujd4Je8vAwm9KeRhQJsKRI5PSBQBZ3hkSMxgFH4H80AKhEfVnyEz1Eh03tbtb/fx0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt2fmnaVy3yPlDFKenJzzRcvsLekjlvXNYE2amN0r8c=;
 b=Np1MpfVp+lREgbRlcXmE3W4qcIiZKfY7xqysdQiSHDzpdi4l1B+pbUIOiF4VlhK1AHgONJmPRYiy9fQlX+U/C9S2ltkESUAXbMWwoase45y5l3OjWm+CaJ2Gqm99ZvJm1tb97hSXhpLknuABHu6sfZsq0Vuahpk0ANKqgNIIJ/8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0922.namprd21.prod.outlook.com (2603:10b6:302:10::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.3; Thu, 20 Aug
 2020 13:00:51 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%9]) with mapi id 15.20.3305.021; Thu, 20 Aug 2020
 13:00:51 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.8 164/232] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Thread-Topic: [PATCH 5.8 164/232] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Thread-Index: AQHWdtTZJWbPRSMfQk6PuRyZ+9TlkqlA9XoQ
Date:   Thu, 20 Aug 2020 13:00:51 +0000
Message-ID: <MW2PR2101MB10522B1242B1309BF35EFFEED75A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091620.754492308@linuxfoundation.org>
In-Reply-To: <20200820091620.754492308@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-08-20T13:00:49Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3a5c5e50-42a9-473b-80f4-457fb13c3360;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b87dd354-13e3-4900-0da2-08d845091113
x-ms-traffictypediagnostic: MW2PR2101MB0922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB0922E5A8801FCBF05C769DF2D75A0@MW2PR2101MB0922.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j/OKhPeP+uTuk30j9gw7UeM00T369iSWAnYgAxz8JGbn8SgiC7P2zWgeldwIeCNfKGfoL08IIeMOBDuufKOL6aHV9o7ycllfg+fSiV597WNNg31oIldPmEiZmntJ7Uj5s3HqkPb9iFRsc6LFMHaiYRaAI9LVqoSTGyQDhag1aGBN6vvHPbIcgS8YMr+EB8347yLPA3x77fah0iOBkJP6dD6yRDhHv9re6C0htRqEt4co58C5EmMDDcY+4ElJIn/0rg7R7QJEK/vduqddeHAZPUgQ5I79CfY2c6RSyM2Dj5tRVAi7PAKfQLbpEcDBC2jeOb+O+rckz99wMDxWZo5XnWJ5KHLZfXnKkpmKJUFmDOhb9TqsllgOYbayqu4XKdl094qr3Zv8g5W9NZ2Hywthxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(86362001)(186003)(8676002)(8990500004)(5660300002)(83380400001)(10290500003)(316002)(478600001)(54906003)(9686003)(966005)(66476007)(52536014)(55016002)(66556008)(8936002)(66446008)(110136005)(33656002)(64756008)(71200400001)(7696005)(6506007)(66946007)(26005)(76116006)(82950400001)(2906002)(82960400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Tqdk1vY3u3k8i7PctChSBw//sFyNdotODcyfr7NlZ43HbSulAjJ+tZRX7EhR2dLP9kbAA02Pts3Oa87bccfBikP7xFdWuPXak+uhxFoVGXM2NqnogiH6nOCYl6/x2s+63CRfLPLzfcq76AcQ0o6OXd4skVCyfIV5s4O0kI76jj4XLvPM8nsJ+Z6UJwdF8c/SrNEMhlT0URReEr7rqLiYWJvGze30CUhRNE74tZvxOEBO+0mBiqq1elIvetZ3OEXwlHUgsX1vSivdGA7FKWv+puEBVZ1peyMTWc1H44ojsuDDKO2zK9O6KsRYBa2I+UFbIdWZUOI5WMvHSxDTb+U2Hq5zQU4k7+DRknkHhJUMz+GwlWJQ3Q1Q0LMr/WBXL8ZVeMm7UY3qiRtilWefKv1ftdhymhTGh/CU/Qxk3AgfRVg+U5OaJ5AxIymEoilIjAGT1S8+SFp+UuOYO/QjtWhorYXKPg5/NmYw/C3e9u4p/g6Plm1rU9STb3Q6gv66wpYz5Lw6nX4in0UBfyNPM0T++jY1XR0RA+HUibG7FApkYVbZlvoGandmOiufNQNnRFh3kyUyK1YTXRaUJWmobHO3Brir8PP13QKhwiPZ+CWfvglSJJMjdtINAY1D1RM5y8cRPrvp06HQSMaFNyuo0uhNfA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87dd354-13e3-4900-0da2-08d845091113
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 13:00:51.4729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ftABr1pJM4DEKjN3xW3XjEiVuQPp55CAX6pg/XOrjHJPbF2M8DkkaCg/nva80wf3vqiVT4q3Gj1fxT7xC+s+L5V/rlJe4p/w9ahnpIByvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0922
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gU2Vu
dDogVGh1cnNkYXksIEF1Z3VzdCAyMCwgMjAyMCAyOjIwIEFNDQo+IA0KPiBGcm9tOiBXZWkgSHUg
PHdlaEBtaWNyb3NvZnQuY29tPg0KPiANCj4gWyBVcHN0cmVhbSBjb21taXQgZDZhZjJlZDI5Yzdj
MWMzMTFiOTZkYWM5ODlkY2I5OTFlOTBlZTE5NSBdDQo+IA0KPiBLZHVtcCBjb3VsZCBmYWlsIHNv
bWV0aW1lIG9uIEh5cGVyLVYgZ3Vlc3QgYmVjYXVzZSB0aGUgcmV0cnkgaW4NCj4gaHZfcGNpX2Vu
dGVyX2QwKCkgcmVsZWFzZXMgY2hpbGQgZGV2aWNlIHN0cnVjdHVyZXMgaW4gaHZfcGNpX2J1c19l
eGl0KCkuDQo+IA0KPiBBbHRob3VnaCB0aGVyZSBpcyBhIHNlY29uZCBhc3luY2hyb25vdXMgZGV2
aWNlIHJlbGF0aW9ucyBtZXNzYWdlIHNlbmRpbmcNCj4gZnJvbSB0aGUgaG9zdCwgaWYgdGhpcyBt
ZXNzYWdlIGFycml2ZXMgdG8gdGhlIGd1ZXN0IGFmdGVyDQo+IGh2X3NlbmRfcmVzb3VyY2VfYWxs
b2NhdGVkKCkgaXMgY2FsbGVkLCB0aGUgcmV0cnkgd291bGQgZmFpbC4NCj4gDQo+IEZpeCB0aGUg
cHJvYmxlbSBieSBtb3ZpbmcgcmV0cnkgdG8gaHZfcGNpX3Byb2JlKCkgYW5kIHN0YXJ0IHRoZSBy
ZXRyeQ0KPiBmcm9tIGh2X3BjaV9xdWVyeV9yZWxhdGlvbnMoKSBjYWxsLiAgVGhpcyB3aWxsIGNh
dXNlIGEgZGV2aWNlIHJlbGF0aW9ucw0KPiBtZXNzYWdlIHRvIGFycml2ZSB0byB0aGUgZ3Vlc3Qg
c3luY2hyb25vdXNseTsgdGhlIGd1ZXN0IHdvdWxkIHRoZW4gYmUNCj4gYWJsZSB0byByZWJ1aWxk
IHRoZSBjaGlsZCBkZXZpY2Ugc3RydWN0dXJlcyBiZWZvcmUgY2FsbGluZw0KPiBodl9zZW5kX3Jl
c291cmNlX2FsbG9jYXRlZCgpLg0KPiANCj4gTGluazoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgtaHlwZXJ2LzIwMjAwNzI3MDcxNzMxLjE4NTE2LTEtd2VoQG1pY3Jvc29mdC5jb20v
DQo+IEZpeGVzOiBjODE5OTJlN2Y0YWEgKCJQQ0k6IGh2OiBSZXRyeSBQQ0kgYnVzIEQwIGVudHJ5
IG9uIGludmFsaWQgZGV2aWNlIHN0YXRlIikNCj4gU2lnbmVkLW9mZi1ieTogV2VpIEh1IDx3ZWhA
bWljcm9zb2Z0LmNvbT4NCj4gW2xvcmVuem8ucGllcmFsaXNpQGFybS5jb206IGZpeGVkIGEgY29t
bWVudCBhbmQgY29tbWl0IGxvZ10NCj4gU2lnbmVkLW9mZi1ieTogTG9yZW56byBQaWVyYWxpc2kg
PGxvcmVuem8ucGllcmFsaXNpQGFybS5jb20+DQo+IFJldmlld2VkLWJ5OiBNaWNoYWVsIEtlbGxl
eSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4g
PHNhc2hhbEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNp
LWh5cGVydi5jIHwgNzEgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkNCj4gDQoNClRoaXMgcGF0
Y2ggY2FtZSB0aHJvdWdoIHRocmVlIGRheXMgYWdvLCBhbmQgSSBpbmRpY2F0ZWQgdGhlbiB0aGF0
IHdlIGRvbid0IHdhbnQNCml0IGJhY2twb3J0ZWQgdG8gNS44IGFuZCBlYXJsaWVyLg0KDQpNaWNo
YWVsDQoNCg==
