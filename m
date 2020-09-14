Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DBC2687F7
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgINJGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:06:43 -0400
Received: from mail-eopbgr700064.outbound.protection.outlook.com ([40.107.70.64]:23008
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgINJGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 05:06:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fu5Kluvur/1cQHqUVWNe1m8OhHw4l54CfA3LOm89LO8v3bUiY7lpD+ujC3Ium88L1igPS2IgNbggJ+8coQUGFfz1XIoeBScbUZMsmmdQUNE2QlOUFR3GeJUNIj8VqNG7apIrBBSALEH/vPIHUhCf150/lUmm11PG4lKZ8nzLNrdVgxcQ/lKE7oR6+cspSq0FQK2pcGeyLOt/no1HwGsVJ2KxE2Ew/C/fgqLk3aXqIpkwwdB1V9LtENkEcRnt0ml3gtwiWfF0jWwJiBNqLGu//XPd6jULReCh78XZ5iz5SVvZePu9RjAshpQ0R7+PQq8HveBUzD6J6wsne/pw5de9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHIlsQZJ/lbsypyE/2m0tKIro9ZIX1IVoMFm/LHuL+s=;
 b=kNU8CCri7Co0Tl36ES4x7OUkEo2DKpfrCo1CBXTlk5lKxmx3oAGt7FDXEaZ+SSRPsmOzor8/b1KVzTggFHNELPYujtNizek5XtG7scj8nrjXoqGRpm5rpolX1wE4H6gG+IN8WjJNRTo3Eiv+fs1cmKbZ+6PGjYanNDd6hcPraXldvDX51nQBGFpRfCNOP7dEvTZdSxuXAY/olh5E5MtRuSgup7igXFmCdUASYYwbZpeIpCKM7WI/kQjXW84Ra0z78o5q8Yuhdi06TYuheDhfnlMYdJaJxmNOem9cakKdpBv0bSY3AZV3ABZaaM9YUKUkDl/8zxCDcedGGWkoHBsEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHIlsQZJ/lbsypyE/2m0tKIro9ZIX1IVoMFm/LHuL+s=;
 b=X0TnHGZcSrrfDGu4wtZpHGhwP/rtR7Xh0ko+8KE84Uu/WSjb7tGZ+gEFDwb/uj20hKIJ7lpAiXRsssTOqJKiyIMN2OzHn1t1tFjm54vZQvcTvs8uFQYVKt9nwjgdLH0/a4X4YyRwFz+ACcqmTIVdmlSjoJYJizuym5zo8Tx0GIY=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1943.namprd10.prod.outlook.com
 (2603:10b6:903:11a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 09:06:36 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::7c3b:e8e3:3d1b:284d]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::7c3b:e8e3:3d1b:284d%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 09:06:36 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "broonie@kernel.org" <broonie@kernel.org>,
        "npiggin@gmail.com" <npiggin@gmail.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Topic: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Index: AQHWglNX/MkS6yQMU06L+lI5I1P9i6lnLtiAgABJ/gCAAG8xgA==
Date:   Mon, 14 Sep 2020 09:06:36 +0000
Message-ID: <7ae62a6e39195af79eb8415f98d64ba5a1789d8d.camel@infinera.com>
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
         <ecedc71d-100a-7d7a-ff7f-ef1a3086dd74@alliedtelesis.co.nz>
         <1600050281.5iiy8pkb7z.astroid@bobo.none>
In-Reply-To: <1600050281.5iiy8pkb7z.astroid@bobo.none>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.92 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b6f2e28-46ef-4b8a-7c2d-08d8588d7bd7
x-ms-traffictypediagnostic: CY4PR10MB1943:
x-microsoft-antispam-prvs: <CY4PR10MB1943B9B4517E2A960E6D1AC0F4230@CY4PR10MB1943.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0TIZOBoZN+FpKtWDngocoG870EHHdq/iRUE18KGrb+gQWvs46s7M0k7WKddRnXWZUC0byjcyTEXWCtzuOjxG/QW7mTqddNahpLMIY9BD7sTXSH/vs0ej1ty2E5xRec4HfZUQx4YPTZ5AYZ0iOINcVbTFIQgeFa7/D1mLGXVxo0/Ii8+7hG4hu0isicKfbPkdrUMP1rtqx3WyfYo+EUbn2sayBKWCTe5/+ltNqXycz3FH935DUFp53yw+Us4hKKPckoTEyuZ6KSbV7pdEmQIsLx7t4S8Ez8f2+pmYBisBFdWG0ViogSvCJtgwkVuJjPaUoxrcA+9Kf5fQWL3UE0xPpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(54906003)(5660300002)(110136005)(6512007)(6486002)(316002)(71200400001)(2616005)(66556008)(66476007)(478600001)(8936002)(2906002)(53546011)(64756008)(66446008)(36756003)(6506007)(26005)(8676002)(66946007)(83380400001)(76116006)(91956017)(86362001)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P1Ga8YsOs0KbKjCySpOli/t5xrDt4G29K2chYij0oKFYUNheZEHGQhM3MNPqzmb6nZr6pYUD74RqIYqTYqRtBUaGyzRGb4+cUXG7X3k7p5vk7Lg+8wqIINj4qg50Byp7SeKvPfRzJukZUgJZbWs5nxfvz+2CFzYJdsK0Ywanoqg0TqZD0E3mLDaKf28ezX0tOY51O9f64yn3xMTwyrzffVNERXMz+oG8pocwAtrDwLjqsXzLJxEy8lQhXWT/1xUFuWsMkUuuQPs/hDWpKtpO8tn5KttJM82bkrH+4szzxi8mTpPib/ghu1yNL/qaIXHMYXePKwggDTGg+9AbZauDfUN0zj/e5Tcj+FP3mfY+e2YzHlNJ+cLXDl3gnU5rQffsyT1ApQZSxNrirKCXyQ0NQ6cJy+NlTrGwDpcVB+T0YXzwsQpFCS75k905Hd7mePKKhF2ZC9voa8tagMGsiPoM7j0030d/DJy7CR2s4qtI0pNjzTUpQ5zaH8qaXFrrTJ6a+4QRLRZramkBKEDW8oV1yJVOcTnGQ/mPdEWVvYUPvggmESrL0agNAW1YTwD3e3xhXwZoF8a7meBU/4u9eGSgZxgEnw0xuU4mW+fkeE6DrVbh+/3dbMyJ64VcgUvWKE5o90vEULMR7KlVFxja60v+qw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B54D11ED1530094EA0F116D330AB50F3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6f2e28-46ef-4b8a-7c2d-08d8588d7bd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 09:06:36.2928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2VNkKMxraK7S4mfZycH25Jb2q0k+Cg65An/Jfx1Xa3rxPFjqmtIi5NitG9daCzKtIKYGQJYaKcUoyhi61YeKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1943
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDEyOjI4ICsxMDAwLCBOaWNob2xhcyBQaWdnaW4gd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0K
PiANCj4gDQo+IEV4Y2VycHRzIGZyb20gQ2hyaXMgUGFja2hhbSdzIG1lc3NhZ2Ugb2YgU2VwdGVt
YmVyIDE0LCAyMDIwIDg6MDMgYW06DQo+ID4gSGkgQWxsLA0KPiA+IA0KPiA+IE9uIDQvMDkvMjAg
MTI6MjggcG0sIENocmlzIFBhY2toYW0gd3JvdGU6DQo+ID4gPiBUaGUgU1BJRSByZWdpc3RlciBj
b250YWlucyBjb3VudHMgZm9yIHRoZSBUWCBGSUZPIHNvIGFueSB0aW1lIHRoZSBpcnENCj4gPiA+
IGhhbmRsZXIgd2FzIGludm9rZWQgd2Ugd291bGQgYXR0ZW1wdCB0byBwcm9jZXNzIHRoZSBSWC9U
WCBmaWZvcy4gVXNlIHRoZQ0KPiA+ID4gU1BJTSB2YWx1ZSB0byBtYXNrIHRoZSBldmVudHMgc28g
dGhhdCB3ZSBvbmx5IHByb2Nlc3MgaW50ZXJydXB0cyB0aGF0DQo+ID4gPiB3ZXJlIGV4cGVjdGVk
Lg0KPiA+ID4gDQo+ID4gPiBUaGlzIHdhcyBhIGxhdGVudCBpc3N1ZSBleHBvc2VkIGJ5IGNvbW1p
dCAzMjgyYTNkYTI1YmQgKCJwb3dlcnBjLzY0Og0KPiA+ID4gSW1wbGVtZW50IHNvZnQgaW50ZXJy
dXB0IHJlcGxheSBpbiBDIikuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzIFBh
Y2toYW0gPGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNpcy5jby5uej4NCj4gPiA+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+ID4gPiAtLS0NCj4gPiBwaW5nPw0KPiANCj4gSSBkb24ndCBr
bm93IHRoZSBjb2RlL2hhcmR3YXJlIGJ1dCB0aGFua3MgZm9yIHRyYWNraW5nIHRoaXMgZG93bi4N
Cj4gDQo+IFdhcyB0aGVyZSBhbnl0aGluZyBtb3JlIHRvIGJlIGRvbmUgd2l0aCBKb2NrZSdzIG9i
c2VydmF0aW9ucywgb3Igd291bGQNCj4gdGhhdCBiZSBhIGZvbGxvdy11cCBwYXRjaCBpZiBhbnl0
aGluZz8NCg0KUGF0Y2ggaXMgZ29vZCBJTUhPLCB0aGVyZSBtYXkgYmUgbW9yZSB0byBmaXggdy5y
LnQgY2xlYXJpbmcgdGhlIElSUXMNCg0KPiANCj4gSWYgdGhpcyBwYXRjaCBmaXhlcyB5b3VyIHBy
b2JsZW0gaXQgc2hvdWxkIHByb2JhYmx5IGdvIGluLCB1bmxlc3MgdGhlcmUNCj4gYXJlIGFueSBv
YmplY3Rpb25zLg0KDQpJdCBzaG91bGQgZ28gaW4gSSB0aGluay4NCg0KIEpvY2tlDQoNCj4gDQo+
IFRoYW5rcywNCj4gTmljaw0KPiANCj4gPiA+IA0KPiA+ID4gTm90ZXM6DQo+ID4gPiDCoMKgwqDC
oMKgSSd2ZSB0ZXN0ZWQgdGhpcyBvbiBhIFQyMDgwUkRCIGFuZCBhIGN1c3RvbSBib2FyZCB1c2lu
ZyB0aGUgVDIwODEgU29DLiBXaXRoDQo+ID4gPiDCoMKgwqDCoMKgdGhpcyBjaGFuZ2UgSSBkb24n
dCBzZWUgYW55IHNwdXJpb3VzIGluc3RhbmNlcyBvZiB0aGUgIlRyYW5zZmVyIGRvbmUgYnV0DQo+
ID4gPiDCoMKgwqDCoMKgU1BJRV9ET04gaXNuJ3Qgc2V0ISIgb3IgIlRyYW5zZmVyIGRvbmUgYnV0
IHJ4L3R4IGZpZm8ncyBhcmVuJ3QgZW1wdHkhIiBtZXNzYWdlcw0KPiA+ID4gwqDCoMKgwqDCoGFu
ZCB0aGUgdXBkYXRlcyB0byBzcGkgZmxhc2ggYXJlIHN1Y2Nlc3NmdWwuDQo+ID4gPiANCj4gPiA+
IMKgwqDCoMKgwqBJIHRoaW5rIHRoaXMgc2hvdWxkIGdvIGludG8gdGhlIHN0YWJsZSB0cmVlcyB0
aGF0IGNvbnRhaW4gMzI4MmEzZGEyNWJkIGJ1dCBJDQo+ID4gPiDCoMKgwqDCoMKgaGF2ZW4ndCBh
ZGRlZCBhIEZpeGVzOiB0YWcgYmVjYXVzZSBJIHRoaW5rIDMyODJhM2RhMjViZCBleHBvc2VkIHRo
ZSBpc3N1ZSBhcw0KPiA+ID4gwqDCoMKgwqDCoG9wcG9zZWQgdG8gY2F1c2luZyBpdC4NCj4gPiA+
IA0KPiA+ID4gwqDCoGRyaXZlcnMvc3BpL3NwaS1mc2wtZXNwaS5jIHwgNSArKystLQ0KPiA+ID4g
wqDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4g
PiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGkuYyBiL2RyaXZl
cnMvc3BpL3NwaS1mc2wtZXNwaS5jDQo+ID4gPiBpbmRleCA3ZTdjOTJjYWZkYmIuLmNiMTIwYjY4
YzBlMiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvc3BpL3NwaS1mc2wtZXNwaS5jDQo+ID4g
PiArKysgYi9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGkuYw0KPiA+ID4gQEAgLTU3NCwxMyArNTc0
LDE0IEBAIHN0YXRpYyB2b2lkIGZzbF9lc3BpX2NwdV9pcnEoc3RydWN0IGZzbF9lc3BpICplc3Bp
LCB1MzIgZXZlbnRzKQ0KPiA+ID4gwqDCoHN0YXRpYyBpcnFyZXR1cm5fdCBmc2xfZXNwaV9pcnEo
czMyIGlycSwgdm9pZCAqY29udGV4dF9kYXRhKQ0KPiA+ID4gwqDCoHsNCj4gPiA+IMKgwqDCoMKg
wqBzdHJ1Y3QgZnNsX2VzcGkgKmVzcGkgPSBjb250ZXh0X2RhdGE7DQo+ID4gPiAtICAgIHUzMiBl
dmVudHM7DQo+ID4gPiArICAgIHUzMiBldmVudHMsIG1hc2s7DQo+ID4gPiANCj4gPiA+IMKgwqDC
oMKgwqBzcGluX2xvY2soJmVzcGktPmxvY2spOw0KPiA+ID4gDQo+ID4gPiDCoMKgwqDCoMKgLyog
R2V0IGludGVycnVwdCBldmVudHModHgvcngpICovDQo+ID4gPiDCoMKgwqDCoMKgZXZlbnRzID0g
ZnNsX2VzcGlfcmVhZF9yZWcoZXNwaSwgRVNQSV9TUElFKTsNCj4gPiA+IC0gICAgaWYgKCFldmVu
dHMpIHsNCj4gPiA+ICsgICAgbWFzayA9IGZzbF9lc3BpX3JlYWRfcmVnKGVzcGksIEVTUElfU1BJ
TSk7DQo+ID4gPiArICAgIGlmICghKGV2ZW50cyAmIG1hc2spKSB7DQo+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHNwaW5fdW5sb2NrKCZlc3BpLT5sb2NrKTsNCj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIElSUV9OT05FOw0KPiA+ID4gwqDCoMKgwqDCoH0NCg0K
