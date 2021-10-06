Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3471B42423A
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhJFQKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 12:10:38 -0400
Received: from mail-mw2nam12on2103.outbound.protection.outlook.com ([40.107.244.103]:40193
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231998AbhJFQKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 12:10:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSvjXU/F41ekELdIqjddtDpRidj2fvt6MGmfNdikWaA84SOTR1qjGhX5S8PTn3i/2Syzb+sKrgQvLH8FC2nhxRkFAglWZe8fIEw9flb5tlJpRrZ0aKoyTr7sgp7xFD9h3M3UX35JJi4jQJmzl4OAZkSKsb/L0XvxuZyyLTHLKPUtNQXqBooR/h4P8QwVAwCdL1h82NbSBw95qaP3/kN66zCVMeSWZcAoUPIrR8gjTMd/5dhR5vBM63TR2HMPLgna03gn0FkMF8gajqRN+fQE1DXsHzzQahorp6YLMj/FCxt7OLCeux4oSvlFbSNh+3hZMJ0NklAPe3yStz52R6ixaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyFFko2XCrTEQNxqh2b5ia3xo6iO1AtRyflFpvnn9l8=;
 b=gVlllDodx0Z+dLwYeb1APEzh9u9u839YxFKBdrk+ZrKdEmS99YUY0QLFf2uhL0ze/BKNUZeJ27vRQ2riLGHPqYt9v5D3BIPxwwyimxlcOjNnTM7Gfz9HUt0+jfsXJ4l4IO+legFMjphlcd5hUQ/lIV5FXA7CVcHzOf6mkDfZ9LY5qSQ7yO43qK7h+mnmUQgekw8NksDw0BpYVBVJp/EjiRLJbSBwzOD0a6DetwQThyV7rMLiQmqjMqMb2rdHVeBXf/kE4WcyDtJQ/NSjmo3R1tq6nB2xx1My7I1fDjGHe+SIZOd2FQaImBYIrQcz60kYSmMob2p4xM2sXeww4LcDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyFFko2XCrTEQNxqh2b5ia3xo6iO1AtRyflFpvnn9l8=;
 b=F1qnz+8uoxIFboLVQX3WXWRau/Zt4kfBpQhnThOPtY2m5wWZ41S2XUcp+vUzTj6yXowuPnsfszTaCcQaHwyQOP6D1N8pvqJkz/Y4zeH1laX6SjWfCXTCitE33sYgNVn+VvrIs5uxNztEtkvV0RP/Ao2Kb/p6n2KODuJjhbKcAGg=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0782.namprd21.prod.outlook.com (2603:10b6:300:77::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1; Wed, 6 Oct
 2021 16:08:42 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899%4]) with mapi id 15.20.4587.017; Wed, 6 Oct 2021
 16:08:42 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     John Garry <john.garry@huawei.com>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
Thread-Topic: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
Thread-Index: AQHXuoBy/NlLBxf5z0auumIxPhrPF6vFoByAgABqc/CAABfAgIAAAJpQ
Date:   Wed, 6 Oct 2021 16:08:42 +0000
Message-ID: <MWHPR21MB15932B5C5B5C5EE5CBAFE00ED7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211006070345.51713-1-decui@microsoft.com>
 <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
 <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
In-Reply-To: <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d84091e0-1582-4233-b4fe-2e1d28075431;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-06T16:05:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 692e0778-a413-4087-3ab5-08d988e39143
x-ms-traffictypediagnostic: MWHPR21MB0782:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB078284536527DD732A4EFC77D7B09@MWHPR21MB0782.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rGOypehUarWMzyYJpBaXUik+QlVDhJYRzYzw9wWGLcNLwLqssi2jvex/Pg/lHLR8WD747aG/YUFv9sv+rGCF+zIpx0P1unjBLqJdI49B82DVTJ3njIuARTLj2XGNqaJB4RxLEqOVxoNhUs3SjVDCA1nfz7d5iW449+fOuK27fSXq5OZjfq6qEWzff+5DeaPsHzUHu/TDPE0b1/dugLyku5SqqNGhMWzDQki/8C/pec/tKdvMa1/sY38kQOmBMEVJGIQdx8FvSOsUOQn7ThZcBuNIC+53u9rc5bzXqvcB2y1wcwkUfjPAdDWhPfpoXcebAIk3OS7GC/01bXfmTQVgI6q28ao1PeqzdxbhcWcxH4YAXXjZ0PunMxlPKtWDcs7VxA9vQr37lx1iKBLgbLcCpoOOk0QFuBRCVBASxDoR/VBzW059k47P653vDv00oadFtTmHcTS4babzAWmoCzWsKMLLiLmXXlUUZ4u3nGgFwlQXygGxppfwKWkZJQ1BoLEE1VwjBtIdbqGcf8w8MIMxWzZBlsCA2YJDatAx/OKWMiZZDCNn5K1xnv3XxMXK1Un1NlVt/8uav42mYjamDfChr58dcmkpswyr9ufVDigAfRqx6fuXNGA09w/09LJXkLQg/s59Gm3HHUlRK/fTa0Hbs9cEBmVq9E+MbbpdK2Ij2w22CO0WMdnTH9r7MSYX8QcvC9IqZGe/v2L7eS1f0yEBB9bkx5bQ2qXsOCNd1k5B6i8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(110136005)(53546011)(54906003)(8990500004)(122000001)(86362001)(921005)(38070700005)(6506007)(316002)(9686003)(508600001)(5660300002)(76116006)(26005)(2906002)(38100700002)(4326008)(52536014)(64756008)(186003)(82960400001)(82950400001)(33656002)(66556008)(83380400001)(8676002)(7696005)(7416002)(66476007)(10290500003)(66446008)(66946007)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y29CbXZ3NWhYUklGYUVvTlJsQ3VzVWRjNThpN2F4YTdxT2dDaERoY1N5V1NE?=
 =?utf-8?B?cWlRdGswd3J2RHE1d1pkRk1DTVg2aWp0eHZPQ2RCQ3ZhckEzcjU1SnFLdW9R?=
 =?utf-8?B?MWpyK2psOG9SSGV2VDJFUG1NaG16YmkrNkpYRUovVFduRW96czJtVmM0bUYw?=
 =?utf-8?B?andIVXZPQURmSVA5UXEyL1l5NHVGc1BRNTMvOXBpVklZNFpaeGozY2N4Mlpq?=
 =?utf-8?B?LzRYRTlrV0FhV2FXYWhaRGFubWY4c1ZpYitiM05wcWF4Uk12emdkUlMxd25L?=
 =?utf-8?B?YmF2MnpMYnY1YXJxcVZwTzNiZGtjOTA5MkozUXFKNi9QenpaTjBMYWYzUUdK?=
 =?utf-8?B?RFlWMDN4K082TDJGemtRdlZEUnZHWXRjejU1Z0hQZkRBL3M0R0pYVWFsa3U2?=
 =?utf-8?B?czMxbkNid0VPUDVsY01MWVVUbDdUYnU5OEh2ZzJYZ1VUT3dtcGdKR1RrOTZN?=
 =?utf-8?B?S2lQSXE2eTNBTGVtaG9Xb0lIYVhrcm0rcGptOEFXam1iTEdLMU9ad3RISkJI?=
 =?utf-8?B?TXIwQlFpU3NwUXhwMTlDT3NzdkR5NHI3djFEUTNDd0pROGZ3OE0ySjBIemFw?=
 =?utf-8?B?NUo5ZnhmOG5MV2c2aFhTZmpXRTVmYXhTcnZ5RzBQaWVxRTAzS2V3dUl5Vm5o?=
 =?utf-8?B?aXg0bzhWcEwyWXh3ZmprR3lBaWY0bExRcys5eWhxb29OYnhhcS9XSGdiaWti?=
 =?utf-8?B?ak5idXhiNEo3OW9GSlZ1eVg5K0llNEliaGFFZ0FiSDB6ZEhWTmp0Mk4vV3Bp?=
 =?utf-8?B?akUzYkVUVmlOeUQyZGVZVWU2dWFtdU4veUxTd0pNY0ZGOW1pTEJYYlFpMnBW?=
 =?utf-8?B?aFFVY1ZtQW1hN1dSU1JPL2svS3VSSS9RdEZMNko3ZUdzMHZwbFpGYVpEU2RK?=
 =?utf-8?B?Z0tabnF5OVdPTllSYnhYcjQrd1RIS3FpcWVYNkhZVUQvUWJBRktLNEZLd2Z5?=
 =?utf-8?B?M3VPOVVlc1VGMnliRGtVMXJuTG5xNWdQNzR5SGNGbDljM1FIN0ZNSzR1bWRz?=
 =?utf-8?B?L0VPM0VXSFVIZ1FieXhnRDBkZUxaV1hpQkdNQlV0L3J0OVpFc24rdmNLYUhH?=
 =?utf-8?B?TTF4a0xtQ0s1dGdwaVZXUjUzbkxzeXlTb2FKQ2V4azdHMTdmdU9iRnVNbWM4?=
 =?utf-8?B?K1lSQVJyMlVheWR6L21OV1JFeUpLcTVXUTNvL3RveUkrQktsM1BtRnVFcUk4?=
 =?utf-8?B?Z0o3NDNCQkVnamlnWUJMQi9SaGVHRm52NUw2TWk2SzI2ZFI1NjA3UklVd2Zx?=
 =?utf-8?B?QkxUako0Z2JCYjdqK2MwOTl5UEg5bWxQa3l1bHk5aCtiQllBQytqSEZrYU1D?=
 =?utf-8?B?emF1V25LeE9qVmkrYTJxdGxKeElxQjVsUC9US1NQbmhXaXg5VlZUeEN6M2pz?=
 =?utf-8?B?RUNuZlhoQW1nUDBGZXMydVJLSlhUa0IwS29YTkRrbm5EdU4zMldid0ZlR2VJ?=
 =?utf-8?B?TjZxZzh1TFlaR3ZmWVV3aUZwN0djOGFTSnVZbU9Ja0lHZ0xrVTZoZUVsN21M?=
 =?utf-8?B?OTY4c3E3WGZrbHlmejF6N3dxQXZhOHB6SCtQSHArcU42QlpBNXlRMzB0WVNr?=
 =?utf-8?B?aDRqT2ErUjVxSmZFamExcXhONU9pZlFNOVdpL3pnMm1pdU5DbnJxb3Y5ZVBR?=
 =?utf-8?B?U1c4djNSSjdMMU12aVF4OW5YdWZtOFdQdW1tOG5LelMveTFkeW44b0krU2RF?=
 =?utf-8?B?L3Y3WTlHcE5KYmRxM1FMOHNiNm1Ta0xNUklhSWhMM2NKUjlHSEpzcmR2b081?=
 =?utf-8?Q?eimOpFX3ZaafW0agfcb83E+SJJmPABen3f6uLXu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692e0778-a413-4087-3ab5-08d988e39143
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 16:08:42.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9nEeOe5xRIgQoLz2N55sU2yvXlmsyykT+WY2q184f/AIAGY2WGIh1Ceko+Omxt+oha60gnMcqqw74tbOWyCXls2ClveyUhm3+qIfoDCLqz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0782
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSm9obiBHYXJyeSA8am9obi5nYXJyeUBodWF3ZWkuY29tPiBTZW50OiBXZWRuZXNkYXks
IE9jdG9iZXIgNiwgMjAyMSA5OjAzIEFNDQo+IA0KPiBPbiAwNi8xMC8yMDIxIDE2OjAxLCBNaWNo
YWVsIEtlbGxleSB3cm90ZToNCj4gPiBGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmdhcnJ5QGh1YXdl
aS5jb20+IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciA2LCAyMDIxIDE6MTcgQU0NCj4gPj4NCj4g
Pj4gT24gMDYvMTAvMjAyMSAwODowMywgRGV4dWFuIEN1aSB3cm90ZToNCj4gPj4+IEFmdGVyIGNv
bW1pdCBlYTJmMGY3NzUzOGMsIGEgNDE2LUNQVSBWTSBydW5uaW5nIG9uIEh5cGVyLVYgaGFuZ3Mg
ZHVyaW5nDQo+ID4+PiBib290IGJlY2F1c2Ugc2NzaV9hZGRfaG9zdF93aXRoX2RtYSgpIHNldHMg
c2hvc3QtPmNtZF9wZXJfbHVuIHRvIGENCj4gPj4+IG5lZ2F0aXZlIG51bWJlcjoNCj4gPj4+IAkn
bWF4X291dHN0YW5kaW5nX3JlcV9wZXJfY2hhbm5lbCcgaXMgMzUyLA0KPiA+Pj4gCSdtYXhfc3Vi
X2NoYW5uZWxzJyBpcyAoNDE2IC0gMSkgLyA0ID0gMTAzLCBzbyBpbiBzdG9ydnNjX3Byb2JlKCks
DQo+ID4+PiBzY3NpX2RyaXZlci5jYW5fcXVldWUgPSAzNTIgKiAoMTAzICsgMSkgKiAoMTAwIC0g
MTApIC8gMTAwID0gMzI5NDcsIHdoaWNoDQo+ID4+PiBpcyBiaWdnZXIgdGhhbiBTSFJUX01BWCAo
aS5lLiAzMjc2NykuDQo+ID4+DQo+ID4+IE91dCBvZiBjdXJpb3NpdHksIGFyZSB0aGVzZSB2YWx1
ZXMgcmVhbGlzdGljPyBZb3UncmUgY2FwcGluZyBjYW5fcXVldWUNCj4gPj4ganVzdCBiZWNhdXNl
IG9mIGEgZGF0YSBzaXplIGlzc3VlLCBzbywgaWYgdGhlc2UgdmFsdWVzIGFyZSByZWFsaXN0aWMs
DQo+ID4+IHNlZW1zIGEgd2VhayByZWFzb24uDQo+ID4+DQo+ID4NCj4gPiBUaGUgY2FsY3VsYXRl
ZCB2YWx1ZSBvZiBjYW5fcXVldWUgaXMgbm90IHJlYWxpc3RpYy4gIFRoZSBibGstbXEgbGF5ZXIN
Cj4gPiBjYXBzIHRoZSBudW1iZXIgb2YgdGFncyBhdCAxMDI0MCwNCj4gDQo+IG5pdDogMTAyNCwg
SSB0aGluaw0KDQpJIHdhcyB0aGlua2luZyBhYm91dCBCTEtfTVFfTUFYX0RFUFRIICgjZGVmaW5l
J2QgYXMgMTAyNDApLCB3aGljaA0KaXMgdXNlZCB0byBsaW1pdCB0aGUgdGFnIHNldCBzaXplIGlu
IGJsa19tcV9hbGxvY190YWdfc2V0KCkuICAgV2hlbiBydW5uaW5nDQpvbiBsYXJnZSBWTXMgb24g
SHlwZXItViwgd2UgY2FuIHNlZSB0aGUgImJsay1tcTogcmVkdWNlZCB0YWcgZGVwdGgNCnRvIDEw
MjQwIiBtZXNzYWdlLiA6LSgNCg0KTWljaGFlbA0K
