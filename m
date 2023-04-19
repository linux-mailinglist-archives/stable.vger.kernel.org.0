Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3EE6E824B
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 22:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDSUES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 16:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSUER (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 16:04:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973AE49CE
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 13:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtJuB2PjxPfGNf3GeONL+t2UGCl/SDXZSVmo34mz82ccGPcx/7q1OQjcJ0cU/ymiqJbi85FXM7ZQAnyIn6+2/TYJk5Cvst8/8cp5FD+04chpkuaje0XEO4QNYYbvPvkd/eX9+NAnkW1N5aPqqSG95q1n43JjsCA3cOLPN3XrwxDVsApETt/CfUd9LtckSdy9TenOEW/FobavWHWi0MuoXEt5DjqQdP2Kicj+jw9jhzcoC9WtHe9TwlNiWktK46ItvXgLRZZIDlDnK4aKmvhXK8QsruTS+m7qQ0ezjFQAuCbjZ72YP3xtJ9CL07e4cW0bpBKeEmqc3sqJxxg32MaACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+hjpS7AnkX3u3yruEgVi5z8ey89UjKNoE/n1FRQ+Wk=;
 b=KAmcra+y7i4w2/UN1U3L6XYq6kDUb5QZ8dKtSCqIfbFVMkN0tafRuCAdv536mcCP6mgNNaM13o8mlvHN78njNwhCpBGBG+TyuWSlD3NLmfwbosoG2fh2m+2VzjtPccg5UJAQcXjPVJ293kGEeoKk8T0l8IefFYCzfjA/McGpYEAzNEbOQBePpyhkc4cSn0AXkWLLytTAWeepgdga7A1bFspu2x1rXx3ILfsUVHPn4W+PYEU2Z7c/qkBk/TPJg/NOek0+5Pfmgg4YQSkp+IUh1E0L7HhZpoGg+9KTWGhOvwMTV0vY5sEHLlYjNbsQpt0D2E5GDXBQXoXPoXSFA2UdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+hjpS7AnkX3u3yruEgVi5z8ey89UjKNoE/n1FRQ+Wk=;
 b=OTM6sQ6gHYUtqKVOJgqm02JZLyxStfdLeUrpGhBvlia6JZppV0SLowlgE1PIFFQga/AI0WXCK2VlNtPKaKiI8WU091e8/x/c4mz4HSBmeItt3TmTaraMeaysFWwlwceSDKEEIE5rBKHo6ykR+Ia/4KgQWIt3vLksuQaJmeHQskc=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 20:04:13 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::34de:5470:103b:594b]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::34de:5470:103b:594b%7]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 20:04:13 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
Subject: RE: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Thread-Topic: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Thread-Index: AQHZckNXQR5Q3QWOVUGW9PDmA1R9Ja8ym8+ggAASTwCAAFxhkA==
Date:   Wed, 19 Apr 2023 20:04:12 +0000
Message-ID: <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
In-Reply-To: <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-19T20:04:11Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=e1e295b5-69fb-47b1-8a13-e3a05bc337a0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-19T20:04:11Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c5ee1994-e7dc-42eb-aeac-8483891befd7
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|MW4PR12MB6899:EE_
x-ms-office365-filtering-correlation-id: 91e01609-a6de-41d7-3a38-08db41113ef1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVJYSPhxftY1vInqc3sY89roIqhemqCin1jbRjyVUjkcAPhCI9iaa9bXMHzzVILoff8A20DMOTglLqMPlKpu9wDV1suqtM4O1cKIub8ylSh93Tgi8wfwYhDu8uEdiWX1ISrXpwght/kPBAZ6vfvIZqFH8krGM9h4cUYBlxAPxXSWKUJiyXoI9NUyAdA5EpsIJ8W8MB2GK9H6ZHjTQLV+XBUbw9SKRRxpIw0jG7tGn5fOzV0aVT+eSQt9O6Ajid1mwDAqqqAg5VfWTKwoZq1AG4s/KFTJXgbaL94+uB59OgguPMbfvAJ5D8UNA2Lzjgi3mzUklFUAedVeni1LUpUoJ2lR9UVaqr3B1cXFVHWhM1RMqs/a/CrvUGpq2LbjeZHkMJOkir2OOdwMkYnXG1w6nZC1gfVN5CvTfrx7Pxw6Z8aKLir7THo1NqwNq4gE0wds4tfCxtaFsOjVaMjD7Qsm+5aKGRII70xcX/hvKSRetj8k/f+biCDYyRyjwwCXlMnzicw98iVThN0r64TgRGn4A4TRHmyf1ddGoOuD+Gv+6Kw0D9UuMtaMFt2lY5DUyKypFy4duSwEKaDkzDwsxLqKV4d9NZ4JFq/RSnTG1k877Mmmoi7RSKlVnl5NN+EOZWOG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(38070700005)(38100700002)(2906002)(8936002)(8676002)(122000001)(86362001)(66899021)(52536014)(5660300002)(33656002)(41300700001)(7696005)(55016003)(71200400001)(53546011)(9686003)(6506007)(26005)(54906003)(478600001)(83380400001)(186003)(316002)(76116006)(66946007)(6916009)(4326008)(66476007)(66556008)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bElZZHh0ZDhaRjlOZVFQbzFNUkE4aGdDNjdhcWhSQzREM3BOVzN6Z2g2N3Fu?=
 =?utf-8?B?ZENtTXhFMXl1TlBhS2ZmVmQ1QWdnZ0ZTZUIzN1FXdmVzOFF1MEQvcjRTUWVT?=
 =?utf-8?B?Q1JuUjdOS1FoMTFuTU16ZHcrZFNOc0NUZm9RcExMaHR2a3diaFlIRXBVMzNj?=
 =?utf-8?B?STRTK3JWVTA0OXRXYWIxTHVud3pDNFRTQ0MwamY1cE84d2M4Z0YvcjBIYlBj?=
 =?utf-8?B?ZlYvSXlMMzlTbldHNlkzbkxaZ2h3R3lQT1grZlFVQWVaNjdXVnl0YUVLbzlH?=
 =?utf-8?B?a0RXbVYxRm8zYTJUVW9COTdHc1pueExrQStvclVjTUFodGZyWjFKWmhxbkdn?=
 =?utf-8?B?bzgwd0pGcXBZaFpPemJxL251UHFSWjliMUg2MFNQM3RiRVI4SFp2L1lsYWlq?=
 =?utf-8?B?RytWc1k5bnV5T2JKWjZaYTcwUEN2YWF6U2ovY2VzWlF1dHA0NHFZRkN0eDJs?=
 =?utf-8?B?T3dFazNudXFaUEpsTmtobFI4WVFCUXljWkFtNmIrakEwMGdiQitob0tKYkpv?=
 =?utf-8?B?OGthM28rMml2aDJMYXA4UHFkNTZrNGRybUdwQW5vM1J0ZG5JTmtwTSt4TjV6?=
 =?utf-8?B?bmYwSnF1VEFleDVQSmFPSjdZRktQU3NmZDlNbEFsekg2VXRaZzROdFd1VlJB?=
 =?utf-8?B?V3BJNmgzTVdLa0Y4d2dNTTYxTkpVVk5FVzRZUnlrK05NamF6aUxjUGlJWHND?=
 =?utf-8?B?MElXRUtwTGN0QmFxZVlMQVQ0V1FYdUhoT1QydXI3dnFyMmhHZ21WT0ZnelVp?=
 =?utf-8?B?SVU1bXhKRGE3UFRnaHVqekxwK2VuV0pqQ3VZaHBVYXFZUXNwcjlFU0ZiQVdh?=
 =?utf-8?B?aC9qenphZ1JPVDZ1RnBqenRxMzRyOU1VMXpXSkdqVDZuTjhlVnB5Q1d4d3oz?=
 =?utf-8?B?OXJNQXQyODUvVzl1T0xWTkhtQ1lyNHNoTTZTSWMyb0hqcSt3ejVXWnBRaXpq?=
 =?utf-8?B?cVhVcW5lcU9oZmV4L3YzVHk1eVdkTWgyTTkyVXVJSG9OTWpBSHltNEQ0WFdq?=
 =?utf-8?B?Y2pkckM1VnFNdjVuTzMvS291YlhnRXFvRmJwZ3FiQmpsTVpPRy9iV21taHp5?=
 =?utf-8?B?eFYvUEVDekk4U3ZzR3drTFQrdnZOUThtSlhJUzkreHJIdC9XNlhXbGtGUXpY?=
 =?utf-8?B?akFUU1IvVkJrOUNlSlB6cVlSV3RGRDducVdINFduR3BUblBLTHFaYzIwOGk4?=
 =?utf-8?B?a1RwOWNKdGhuNEY2SGdMZ0xudTVLQTBwd2FCckRKYWdub2RCSUFyNWhEZERi?=
 =?utf-8?B?VGM1K3RuZmR3RUJralNPQlVSdlhxaGRHcVVDTVByQmhjN1hFMk1yYTJ6YU1V?=
 =?utf-8?B?WEY2eWpnRGJ1SzlEdTdNUnh3Z0tlckhKOEJjdDE0ejVmWTI2bzRKTDZxaVd5?=
 =?utf-8?B?bE5EQWlyNGtwcnhWUU50ZzZLSGR2QjdRMEdkN0JRbjJXSWw4SVJVeFVRbjVJ?=
 =?utf-8?B?ZllRNGVQbDErWUZQMFhHcnZjOUJ3TERXVVU0Z3B4dExuQlJ3ZGdBdWdKUVdU?=
 =?utf-8?B?dUo5MzEvY2lNUWdkd0JPTzBXR3hpQk9rS2NwUVdhUllrZ1ZkY3E0bDhCd20v?=
 =?utf-8?B?QUNNN2NLeWZBSGNPczZBUlJYKzRJc1JPMDBmSTVxbzR4UDJ4VENNNnNhaEwy?=
 =?utf-8?B?ZEk3djZlQm1jOEVGSDJrT2JMNmJzTXp0VHMrTUFIckoyakV5VUw2N2gzL21u?=
 =?utf-8?B?eFh3SVFNQWJJcWQ5QzNiWHJjbG8yaVFEdGc1WVQzUHZneTlyeU5XVXZweW9u?=
 =?utf-8?B?ZzVLMGpHMWg4ZDJ4K3Bwd1JTeTNZbnluRHRXdThDTTBvYmFxZkFyU2tIc05v?=
 =?utf-8?B?YUY5cEhBalAvMzErMURpUmJTd2N3SWpQalgxVldYd05tbThyZ3BrOWV2VzRh?=
 =?utf-8?B?amp6R01pcmRXa3RJUUFZaVEzb3VyaEw3Nm9va1RLS1ZiaXBZUVpGdExEb1NC?=
 =?utf-8?B?U2FLVXlYUVFtMEdjamk2WHIrNWhIdC9XS3hYV1Fnclp6cEtFbmYyNXUwbEI5?=
 =?utf-8?B?YU5NcUp3L2g3SzY2ZGthMkZGN3NPeGM0azVreXMrSVd4NWVUMkVsaEE1bFFY?=
 =?utf-8?B?SDkrNlg3a3BkSkV0SndYOXNaekNDN0x0TDlLczRRR1pxMUt0NjdXaVFiNXNE?=
 =?utf-8?Q?v+cg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e01609-a6de-41d7-3a38-08db41113ef1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 20:04:12.9146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wXWmQAcDBY8rkANfKWhe+Ut4Sy1GXWC7MEPsAAqV6UIFH6+hC7sfXlPcHzIoC8k02kerP0AFt4COYxAergtEAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHdWlsaGVy
bWUgRy4gUGljY29saSA8Z3BpY2NvbGlAaWdhbGlhLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBB
cHJpbCAxOSwgMjAyMyAxMDoxNSBBTQ0KPiBUbzogRGV1Y2hlciwgQWxleGFuZGVyIDxBbGV4YW5k
ZXIuRGV1Y2hlckBhbWQuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgZ3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc7DQo+IHNhc2hhbEBrZXJuZWwub3JnOyBhbWQtZ2Z4QGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZzsgWmh1LCBKYW1lcw0KPiA8SmFtZXMuWmh1QGFtZC5jb20+OyBMaXUs
IExlbyA8TGVvLkxpdUBhbWQuY29tPjsga2VybmVsQGdwaWNjb2xpLm5ldDsNCj4ga2VybmVsLWRl
dkBpZ2FsaWEuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggNi4xLnldIGRybS9hbWRncHUvdmNu
OiBEaXNhYmxlIGluZGlyZWN0IFNSQU0gb24NCj4gVmFuZ29naCBicm9rZW4gQklPU2VzDQo+IA0K
PiBPbiAxOS8wNC8yMDIzIDEwOjE2LCBEZXVjaGVyLCBBbGV4YW5kZXIgd3JvdGU6DQo+ID4gWy4u
Ll0NCj4gPj4gVGhpcyBpcyBxdWl0ZSBzdHJhbmdlIGZvciBtZSwgd2UgaGF2ZSAyIGNvbW1pdCBo
YXNoZXMgcG9pbnRpbmcgdG8gdGhlDQo+ID4+ICpzYW1lKiBjb21taXQsIGFuZCBlYWNoIG9uZSBp
cyBwcmVzZW50Li5pbiBhIGRpZmZlcmVudCByZWxlYXNlICEhPyENCj4gPj4gU2luY2UgSSd2ZSBt
YXJrZWQgdGhpcyBwYXRjaCBhcyBmaXhpbmcgODIxMzJlY2M1NDMyIG9yaWdpbmFsbHksIDYuMS55
DQo+ID4+IHN0YWJsZSBtaXNzZXMgaXQsIHNpbmNlIGl0IG9ubHkgY29udGFpbnMgOWE4Y2M4Y2Fi
YzFlICh3aGljaCBpcyB0aGUgc2FtZQ0KPiBwYXRjaCEpLg0KPiA+Pg0KPiA+PiBBbGV4LCBkbyB5
b3UgaGF2ZSBhbiBpZGVhIHdoeSBzb21ldGltZXMgY29tbWl0cyBmcm9tIHRoZSBBTUQgdHJlZQ0K
PiA+PiBhcHBlYXIgZHVwbGljYXRlIGluIG1haW5saW5lPyBTcGVjaWFsbHkgaW4gZGlmZmVyZW50
IHJlbGVhc2VzLCB0aGlzDQo+ID4+IGNvdWxkIGNhdXNlIHNvbWUgY29uZnVzaW9uIEkgZ3Vlc3Mu
DQo+ID4NCj4gPiBUaGlzIGlzIHByZXR0eSBjb21tb24gaW4gdGhlIGRybS4gIFRoZSBwcm9ibGVt
IGlzIHRoZXJlIGlzIG5vdCBhIGdvb2Qgd2F5DQo+IHRvIGdldCBidWcgZml4ZXMgaW50byBib3Ro
IC1uZXh0IGFuZCAtZml4ZXMgd2l0aG91dCBjb25zdGFudCBiYWNrIG1lcmdlcy4gIFNvDQo+IHRo
ZSBwYXRjaGVzIGVuZCB1cCBpbiAtbmV4dCBhbmQgaWYgdGhleSBhcmUgaW1wb3J0YW50IGZvciBz
dGFibGUsIHRoZXkgZ28gdG8gLQ0KPiBmaXhlcyB0b28uICBXZSBkb24ndCB3YW50IC1uZXh0IHRv
IGJlIGJyb2tlbiwgYnV0IHdlIGNhbid0IHdhaXQgdW50aWwgdGhlIG5leHQNCj4ga2VybmVsIGN5
Y2xlIHRvIGdldCB0aGUgYnVnIGZpeGVzIGludG8gdGhlIGN1cnJlbnQga2VybmVsIGFuZCBzdGFi
bGUuICBJIGRvbid0DQo+IGtub3cgb2YgYSBnb29kIHdheSB0byBtYWtlIHRoaXMgc21vb3RoZXIu
DQo+ID4NCj4gPiBBbGV4DQo+IA0KPiBUaGFua3MgQWxleCwgc2VlbXMgcXVpdGUgY29tcGxpY2F0
ZWQgaW5kZWVkLg0KPiANCj4gU28sIGxldCBtZSBjaGVjayBpZiBJIHVuZGVyc3Rvb2QgcHJvcGVy
bHk6IHRoZXJlIGFyZSAyIHRyZWVzICgtZml4ZXMgYW5kIC1uZXh0KSwNCj4gYW5kIHRoZSBwcm9i
bGVtIGlzIHRoYXQgdGhlaXIgbWVyZ2Ugb250byBtYWlubGluZSBoYXBwZW5zIGFwYXJ0IGFuZCB0
aGVyZQ0KPiBhcmUga2luZCBvZiBkdXBsaWNhdGUgY29tbWl0cywgdGhhdCB3ZXJlIGZpcnN0IG1l
cmdlZCBvbiAtZml4ZXMsIHRoZW4gInJlLQ0KPiBtZXJnZWQiIG9uIC1uZXh0LCByaWdodD8NCj4g
DQoNCkVhY2ggc3Vic3lzdGVtIHdvcmtzIG9uIG5ldyBmZWF0dXJlcywgdGhlbiB3aGVuIHRoZSBt
ZXJnZSB3aW5kb3cgb3BlbnMsIExpbnVzIHB1bGxzIHRoZW0gaW50byBtYWlubGluZS4gIEF0IHRo
YXQgcG9pbnQsIG1haW5saW5lIGdvZXMgaW50byBSQ3MgYW5kIHRoZW4gbWFpbmxpbmUgaXMgYnVn
IGZpeGVzIG9ubHkuICBNZWFud2hpbGUgaW4gcGFyYWxsZWwsIGVhY2ggc3Vic3lzdGVtIGlzIHdv
cmtpbmcgb24gbmV3IGZlYXR1cmUgZGV2ZWxvcG1lbnQgZm9yIHRoZSBuZXh0IG1lcmdlIHdpbmRv
dyAoc3Vic3lzdGVtIC1uZXh0IHRyZWVzKS4gIFRoZSB0cmVlcyB0ZW5kIHRvIGxhZyBiZWhpbmQg
bWFpbmxpbmUgYSBiaXQuICBNb3N0IGRldmVsb3BlcnMgZm9jdXMgb24gdGhlbSBpbiBzdXBwb3J0
IG9mIHVwY29taW5nIGZlYXR1cmVzLiAgVGhleSBhcmUgdXN1YWxseSBhbHNvIHdoZXJlIGJ1Z3Mg
YXJlIGZpeGVkLiAgSWYgYSBidWcgaXMgZml4ZWQgaW4gdGhlIC1uZXh0IHRyZWUsIHdoYXQncyB0
aGUgYmVzdCB3YXkgdG8gZ2V0IGl0IGludG8gbWFpbmxpbmU/ICBJIGd1ZXNzIGlkZWFsbHkgaXQg
d291bGQgYmUgZml4ZWQgaW4gbWFpbmxpbmUgYW5kIHRoZW0gbWFpbmxpbmUgd291bGQgYmUgbWVy
Z2VkIGludG8gZXZlcnlvbmUncyAtbmV4dCBicmFuY2gsIGJ1dCB0aGF0J3Mgbm90IGFsd2F5cyBw
cmFjdGljYWwuICBPZnRlbiB0aW1lcyBuZXcgZmVhdHVyZXMgZGVwZW5kIG9uIGJ1ZyBmaXhlcyBh
bmQgdGhlbiB5b3UnZCBlbmQgdXAgc3RhbGxpbmcgbmV3IGRldmVsb3BtZW50IHdhaXRpbmcgZm9y
IGEgYmFjayBtZXJnZSwgb3IgeW91J2QgaGF2ZSB0byByZWJhc2UgeW91ciAtbmV4dCBicmFuY2hl
cyByZWd1bGFybHkgc28gdGhhdCB0aGV5IHdvdWxkIHNoZWQgYW55IHBhdGNoZXMgaW4gbWFpbmxp
bmUgd2hpY2ggaXMgbm90IGdyZWF0IGVpdGhlci4gIFdlIHRyeSBhbmQgY2hlcnJ5LXBpY2sgLXgg
d2hlbiB3ZSBjYW4gdG8gc2hvdyB0aGUgcmVsYXRpb25zaGlwLg0KDQo+IFdvdWxkIGJlIHBvc3Np
YmxlIHRvIGNsZWFuIHRoZSAtbmV4dCB0cmVlIHJpZ2h0IGJlZm9yZSB0aGUgbWVyZ2UsIHVzaW5n
DQo+IHNvbWUgc2NyaXB0IHRvIGZpbmQgY29tbWl0cyB0aGVyZSB0aGF0IGFyZSBnb2luZyB0byBi
ZSBtZXJnZWQgYnV0IGFyZQ0KPiBhbHJlYWR5IHByZXNlbnQ/IFRoZW4geW91J2QgaGF2ZSBhIC1u
ZXh0LXRvLW1lcmdlIHRyZWUgdGhhdCBpcyBjbGVhbiBhbmQNCj4gZG9lc24ndCBwcmVzZW50IGR1
cHMsIGF2b2lkaW5nIHRoaXMuDQoNClRoZXJlJ3Mgbm8gcmVhbCB3YXkgdG8gY2xlYW4gaXQgd2l0
aG91dCByZXdyaXRpbmcgaGlzdG9yeS4gIFlvdSdkIGJhc2ljYWxseSBuZWVkIHRvIGRvIHJlZ3Vs
YXIgYmFja21lcmdlcyBhbmQgcmViYXNlcyBvZiB0aGUgLW5leHQgdHJlZXMuICBBbHNvIHRoZW4g
d2hhdCBkbyB5b3UgZG8gaWYgeW91IGFscmVhZHkgaGF2ZSBhIGZlYXR1cmUgaW4gLW5leHQgKHNh
eSBEYXZlIG9yIERhbmllbCBoYXZlIGFscmVhZHkgcHVsbGVkIGluIG15IGxhdGVzdCBhbWRncHUg
UFIgZm9yIC1uZXh0KSBhbmQgeW91IHJlYWxpemUgdGhhdCBvbmUgb2YgdGhvc2UgcGF0Y2hlcyBp
cyBhbiBpbXBvcnRhbnQgYnVnIGZpeCBmb3IgbWFpbmxpbmU/ICBJZiB0aGUgZHJtIC1uZXh0IHRy
ZWUgcmViYXNlZCB0aGVuIGFsbCBvZiB0aGUgb3RoZXIgZHJtIGRyaXZlciB0cmVlcyB0aGF0IGZl
ZWQgaW50byBpdCB3b3VsZCBuZWVkIHRvIHJlYmFzZSBhcyB3ZWxsIG90aGVyd2lzZSB0aGV5J2Qg
aGF2ZSBzdGFsZSBoaXN0b3J5Lg0KDQpZb3UgYWxzbyBoYXZlIHRoZSBjYXNlIG9mIGEgZml4IGlu
IC1uZXh0IG5lZWRpbmcgdG8gbGFuZCBpbiBtYWlubGluZSwgYnV0IGR1ZSB0byBkaWZmZXJlbmNl
cyBpbiB0aGUgdHJlZXMsIGl0IG5lZWRzIGJhY2twb3J0aW5nIHRvIGFwcGx5IHByb3Blcmx5Lg0K
DQo+IA0KPiBEaXNjbGFpbWVyOiBJJ20gbm90IGEgbWFpbnRhaW5lciwgbWF5YmUgdGhlcmUgYXJl
IHNtYXJ0IHdheXMgb2YgZG9pbmcgdGhhdCBvcg0KPiBwZXJoYXBzIG15IHN1Z2dlc3Rpb24gaXMg
c2lsbHkgYW5kIHVuZmVhc2libGUgaGVoIEJ1dCBzZWVtcyBsaWtlbHkgdGhhdCBvdGhlcg0KPiBt
YWludGFpbmVycyBmYWNlIHRoaXMgcHJvYmxlbSBhcyB3ZWxsIGFuZCBjYW1lIHVwIHdpdGggc29t
ZSBzb2x1dGlvbiAtDQo+IGF2b2lkaW5nIHRoZSBkdXBzIHdvdWxkIGJlIGEgZ29vZCB0aGluZywg
SU1PLCBpZiBwb3NzaWJsZS4NCg0KDQpObyB3b3JyaWVzLiAgSSBhZ3JlZS4gIEkgaGF2ZW4ndCBz
ZWVuIGFueXRoaW5nIHNvIGZhciB0aGF0IHJlYWxseSBhZGRyZXNzZXMgaGFuZGxlcyB0aGlzIGVm
ZmVjdGl2ZWx5Lg0KDQpBbGV4DQoNCj4gDQo+IENoZWVycywNCj4gDQo+IA0KPiBHdWlsaGVybWUN
Cj4gDQo=
