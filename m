Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F24240AA
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbhJFPDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 11:03:18 -0400
Received: from mail-dm6nam11on2090.outbound.protection.outlook.com ([40.107.223.90]:22176
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239100AbhJFPDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 11:03:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXY2cogbzfaJ79bc/RvzeUyqqNH+L1BEc0wJ/HDZY1q+SgIMun1x5aPbkmXvMguMBhsp1aFm5KuWCM/g6sRhRBGg6246f1HRNQFZUM3qwpk6yrS6xl7Wyd/BHAxTJsVnuqfHIYLyKhluFf2Y8d5QLt9I5n0OrSMXWF1aKKJbc437x1L3DiR2nECBeYX1W8MFgm9Kg1W1HVZHfMUFhXzRU0oMj26BGYbETDi3yyp/BNQJMUGykkxH8+ZH/6mkTnzpEDhOCrApI0b0ZMcpaiMnqKPohbxJE1E81x/fgiuYa9WdFUVF2PnkEnB3L6bVClvvV4gOyfYnxhkNxP+1uTeedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAblNUsKj0ltj03DnRSxNXCSu8tnGxkmjRsjpukj2ZQ=;
 b=avXJOJ5iPHDZJ4+ymwaTQcsvHPfWDG9bdLuV2nZldidzXp7hRAyehZk7KmhqKLn9nq92SjYEhD7PblIRxb8ucdRvdbKICLaBR+jJ660COcdAX6bLwmTFlva7DU/O+rFRD8XG5pnl+VB+TsK6qKBvjnX/dn1N/YkGV4eK+/DxUVK7S0ww+IFZeBCddAmY2kKTh4BUInAIaZbhUkYd5ZRjjVZ96bD9bXtXIq5I10rJ4CooF3Pu5OT3qOpbDb6zOw0Uohc70Bqx0jA5TClm9Mzg6nYXMZjd6SDzt7fp2PKLl2kaq0Od5ScuVYJKr1pC5AqCXNk8fouQtxD6GIjZvytQdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAblNUsKj0ltj03DnRSxNXCSu8tnGxkmjRsjpukj2ZQ=;
 b=a87aHFTVnjdceJTI1PSAvdueQUUamsowsT17JGSZmKwejK2BI5RVi1iyMjM1x2QtnW/+o8LF7rPGi1tAS7imZWRNFgNRdl3ABd4I/OnroZ8KGRRnHzz2YopIhC3eWALoahRnXjOlplB+txADfvXpzbTNsF8vL9CSOwGitnjCf24=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB1580.namprd21.prod.outlook.com (2603:10b6:301:79::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1; Wed, 6 Oct
 2021 15:01:20 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899%4]) with mapi id 15.20.4587.017; Wed, 6 Oct 2021
 15:01:20 +0000
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
Thread-Index: AQHXuoBy/NlLBxf5z0auumIxPhrPF6vFoByAgABqc/A=
Date:   Wed, 6 Oct 2021 15:01:20 +0000
Message-ID: <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211006070345.51713-1-decui@microsoft.com>
 <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
In-Reply-To: <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d58b5deb-bedd-47fb-b078-6ce48f1a721e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-06T14:38:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23dd37dd-2653-4bf0-74fa-08d988da2822
x-ms-traffictypediagnostic: MWHPR21MB1580:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB1580C92926C29CAC1386B279D7B09@MWHPR21MB1580.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYMCA2nCyWYJPfLSmv7qeevxkEmN4fvUFS4NaeuSo0LsTyN64V4xjAC1QrJiLJ2iCyAChKb0hd6inRrjcI3ryx59eL+XtitPou09We0eIzXl6pU0at6Qkavv1w9X11nNZpF6niM7FwbOTsDKf2P3BYy2VyXQgZhlzs5uBLMA//GzPbhUdHbSeBEK8AMzpijHzDunBcQa8KNOI9PRGhTNSZ/3Jo9UZ8WREhgYB1tmXP/vGoMtBlA7DpCX//T0Km0ygk06a3LKsfWTAPB+ukFmFNl7vg12JtSN1EM5FiLB5O/OBawaqO8E8BBIhYiNApt38PWXWNKBmltA5QOce0saMThQbiBBXxsPAq2uWJfiaFRgAQQhMqWvMaK4k2MRwQNZtijP+aH3ZQn3yjAKRzxb/g8IM7rCbE2DI/YojXCXadZYz4wtXsOEzZMqhgjOF0fsrqOMV0ObnuGgrn78M3fbA5s2+jF48TsUISaD6J9czMQ6QiRO+49dCL9rH3d5n1en+odq07qEWOHuXpN8iRy7v368rVXuxSC0M+LznQIXYW2BH074Umv4mGOLyFIJyxUxJ1IyMSPb6bkCCEC3TbMRb1LBOqPjH4n2vpWymF/y/B3YDSLNsNiY7wnMqNRXnqQDci1/U42ivKV/ADiDUOUv/VeygCvFYHKlJTU0G6pgvDiHw3oUMmZAB1nHm4LP1xCLOL/6Bj37pjrtuywur4O7/nZ6lmyImMI2wTGvFGhxZNI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(4326008)(66476007)(5660300002)(54906003)(508600001)(66446008)(9686003)(83380400001)(8676002)(2906002)(64756008)(186003)(82960400001)(82950400001)(71200400001)(66556008)(10290500003)(316002)(33656002)(6506007)(8936002)(53546011)(38070700005)(122000001)(7696005)(66946007)(38100700002)(7416002)(26005)(76116006)(52536014)(86362001)(921005)(110136005)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGh3L25UWFgzYXNicmQwdUhIQldaR3dsM0gyMTNYYUUvWEw4TW93UmVWRVBl?=
 =?utf-8?B?NWVDOWZlbWpaVE80aVdlSUd6VWRaZXI5bllxeTRzUlg0d0NsQm5GWjlyT05Q?=
 =?utf-8?B?T0VMcjRLWG9DdUQ3Qmc5Mm5CVHFFcTJ6SEQzL3hoSnlDNWtXek45RFJWN09O?=
 =?utf-8?B?U2EzUWlQTFJYUFlsVDBHdGRNNXdhcnpUMjQrQmRZTFNzelZLNjZUaVpyeFgz?=
 =?utf-8?B?MEc0YkJxQUhOTEpQemxpQlNWT1lQWnNiczZlQ3ZoVE5zbUdIanNrakVVc1lO?=
 =?utf-8?B?ZE1aV3E0N2RCR05jb2E2Qi9UK3Q5OWFXdnBtWStMWmRSc2owbTlMb29tQzNO?=
 =?utf-8?B?V0kydGpVOCtYWjV2ZndpcmcwM1gva2dpWjg0ZHRuMTFDWUpOTU9tZ0VCUVRm?=
 =?utf-8?B?MEN2SHNzVVpjUjIzVFAvUGovekJveE9kRWhPY0x4b2lMMlZrRWs5emxIQVNC?=
 =?utf-8?B?aGY3OFUrOENZYmFiQ292R2d3YVdpbTBmYlErREtHQ3RIN053Wk5GL3ZxM2E4?=
 =?utf-8?B?dlJ3ckJTUUEzbHc1YlFVMXJjb0lkVWRlV1BxRytsMmNSa2w2MXpHeDBlNHdE?=
 =?utf-8?B?U1V0NXJtTmtLaGRoQzUxZEx0bnhtclJyUjlOZzlDUmVabU80Z0lEZHpaN2c2?=
 =?utf-8?B?bUVkQkxNY0pBd1FneFhuVGsrM3I2RDBsdlFNeWc3TmNNWVJrT291bVI0cllt?=
 =?utf-8?B?THNhUWxmWm1lSXpqZGZsdVBIUXFBTURzV2dhK2lzTlFwUlpjbmpubkdFcE91?=
 =?utf-8?B?cUppaXBIcWIwSU9oMmN2RTNobHBrTjdUQndNdUg2Y1BJQ1lLeTBvRmdsei80?=
 =?utf-8?B?NEs3eitmRFBGc0lIcDlNa3lhbUI0WjBnQnVZR09IbW1ocjB0d0JJcmFOZW1T?=
 =?utf-8?B?TXI4eUo0WjZGY01DbG01OGUyblAzNzhoc3BySzBhYmdUMTF3NGhnRWFaTXlj?=
 =?utf-8?B?bDdNTWtiMmh3UUdCRjdZRnFCVGJtb1BsT05CSDMrYVZxMUNYTjkzTGdsdnFq?=
 =?utf-8?B?UjFlbFdDMG4zR1ljUCtQbkVtNGVwdTVNeHN4N1dWU05iaVpRb1lxemY0N25h?=
 =?utf-8?B?bU82eHRxUWJIcEZBL0FhUFJnNU1iU0pPT3p4WWtrblovWSt2VFR1QUtJZ0tG?=
 =?utf-8?B?emRqTWFPcFZ1VHNBMi90eS9LbmxhOXAxNm5NdzJCY2hKSTE5U1lFQU5hR2U5?=
 =?utf-8?B?OXFrR05mRHcrUDZmNGFBOFRCbE5WTDRJd2dtWjkxUHJYQXdLL2Q3cXpnTVR0?=
 =?utf-8?B?WnRJdzJXaWNsWk5DZDhxZzhoMlRCMlpnSm5VeDFNL3ROU1BNcERXKzR0WW9I?=
 =?utf-8?B?eCs1cC9WV1R3UnR4ZmxHU1lhbWFBMld6dWhJc3hMWkRRRWk1eXh3eVozVzA4?=
 =?utf-8?B?SFdxZEtJRnpwNy8vTXQ5VUpmVGZrQ1hGNXlvYk9CUGRpUWlVQy9EVmROZlY4?=
 =?utf-8?B?VjZ5RnM2YmwybGo5SlhUMThmbEtuNklVMWQ3ZzllVjZlbmVIdklIYU55WWdi?=
 =?utf-8?B?ajhmeFNJaXhleGxScEhZQTJaRDU4RWpJNE53MlZrR0N1S1dUT09OY3AvWDV3?=
 =?utf-8?B?bVpPTGkya3RhNlNsT0NBRW9Cb2w1SDc5UmVoSjZQSG5SR2R4SVJuWjN4U0c1?=
 =?utf-8?B?SzYzTnM1NmVvQ3k0NGZWbjRUL3F4c1VjRVRQSW9RYUNvZTNoYXZnc1FUK2Fp?=
 =?utf-8?B?K3hnbVlSeVBxK3BUOXlGUXBYaXdSTW9aNHE3UFZINmdZRTN2MnJwaWZXbC9j?=
 =?utf-8?Q?uV8lH688kjI2VBFYIFQISG998GzZpD9vE9PWm7Q?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dd37dd-2653-4bf0-74fa-08d988da2822
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 15:01:20.6131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hsdRZ/LA+s0PTlGmO+5yIE9LUBnfFFWKS7MQN+YksNNViDBekx0ep9On1qptylJl5/3DgGzHxRClUJWHi9U0pZ/dxl8japp1XEpzCO8kTio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB1580
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSm9obiBHYXJyeSA8am9obi5nYXJyeUBodWF3ZWkuY29tPiBTZW50OiBXZWRuZXNkYXks
IE9jdG9iZXIgNiwgMjAyMSAxOjE3IEFNDQo+IA0KPiBPbiAwNi8xMC8yMDIxIDA4OjAzLCBEZXh1
YW4gQ3VpIHdyb3RlOg0KPiA+IEFmdGVyIGNvbW1pdCBlYTJmMGY3NzUzOGMsIGEgNDE2LUNQVSBW
TSBydW5uaW5nIG9uIEh5cGVyLVYgaGFuZ3MgZHVyaW5nDQo+ID4gYm9vdCBiZWNhdXNlIHNjc2lf
YWRkX2hvc3Rfd2l0aF9kbWEoKSBzZXRzIHNob3N0LT5jbWRfcGVyX2x1biB0byBhDQo+ID4gbmVn
YXRpdmUgbnVtYmVyOg0KPiA+IAknbWF4X291dHN0YW5kaW5nX3JlcV9wZXJfY2hhbm5lbCcgaXMg
MzUyLA0KPiA+IAknbWF4X3N1Yl9jaGFubmVscycgaXMgKDQxNiAtIDEpIC8gNCA9IDEwMywgc28g
aW4gc3RvcnZzY19wcm9iZSgpLA0KPiA+IHNjc2lfZHJpdmVyLmNhbl9xdWV1ZSA9IDM1MiAqICgx
MDMgKyAxKSAqICgxMDAgLSAxMCkgLyAxMDAgPSAzMjk0Nywgd2hpY2gNCj4gPiBpcyBiaWdnZXIg
dGhhbiBTSFJUX01BWCAoaS5lLiAzMjc2NykuDQo+IA0KPiBPdXQgb2YgY3VyaW9zaXR5LCBhcmUg
dGhlc2UgdmFsdWVzIHJlYWxpc3RpYz8gWW91J3JlIGNhcHBpbmcgY2FuX3F1ZXVlDQo+IGp1c3Qg
YmVjYXVzZSBvZiBhIGRhdGEgc2l6ZSBpc3N1ZSwgc28sIGlmIHRoZXNlIHZhbHVlcyBhcmUgcmVh
bGlzdGljLA0KPiBzZWVtcyBhIHdlYWsgcmVhc29uLg0KPiANCg0KVGhlIGNhbGN1bGF0ZWQgdmFs
dWUgb2YgY2FuX3F1ZXVlIGlzIG5vdCByZWFsaXN0aWMuICBUaGUgYmxrLW1xIGxheWVyDQpjYXBz
IHRoZSBudW1iZXIgb2YgdGFncyBhdCAxMDI0MCwgc28gdGhlIGV4Y2Vzc2l2ZWx5IGxhcmdlIHZh
bHVlDQpjYWxjdWxhdGVkIGhlcmUgZGlkbid0IGRlZmluaXRpdmVseSBicmVhayBhbnl0aGluZywg
dGhvdWdoIGl0IGNhbiBiZQ0KcG9vciBmcm9tIGEgcGVyZm9ybWFuY2UgdHVuaW5nIHN0YW5kcG9p
bnQuIFRoZSBhbGdvcml0aG0gdXNlZCBoZXJlDQppcyBmYWlybHkgYnJva2VuLCBwYXJ0aWN1bGFy
bHkgaW4gVk1zIHdpdGggbGFyZ2UgQ1BVIGNvdW50cy4gIEkgaGF2ZSBhbg0KZWZmb3J0IHVuZGVy
d2F5IHRvIGZpeCBpdCwgYnV0IGl0cyBwYXJ0IG9mIGEgYmlnZ2VyIHNldCBvZiBjaGFuZ2VzIHRv
IGFsc28NCmRvIGEgYmV0dGVyIGpvYiBvbiB0aGUgcGVyZiB0dW5pbmcgYXNwZWN0cy4NCg0KPiA+
DQo+ID4gRml4IHRoZSBoYW5nIGlzc3VlIGJ5IGNhcHBpbmcgc2NzaV9kcml2ZXIuY2FuX3F1ZXVl
Lg0KPiA+DQo+ID4gQWRkIHRoZSBiZWxvdyBGaXhlZCB0YWcgdGhvdWdoIGVhMmYwZjc3NTM4YyBp
dHNlbGYgaXMgZ29vZC4NCj4gPg0KPiA+IEZpeGVzOiBlYTJmMGY3NzUzOGMgKCJzY3NpOiBjb3Jl
OiBDYXAgc2NzaV9ob3N0IGNtZF9wZXJfbHVuIGF0IGNhbl9xdWV1ZSIpDQo+ID4gQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTaWduZWQtb2ZmLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBt
aWNyb3NvZnQuY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9zY3NpL3N0b3J2c2NfZHJ2LmMg
fCAxMCArKysrKysrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zdG9ydnNjX2Rydi5jIGIvZHJpdmVy
cy9zY3NpL3N0b3J2c2NfZHJ2LmMNCj4gPiBpbmRleCBlYmJiYzEyOTljNjIuLmJhMzc0OTA4YWVj
MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvc3RvcnZzY19kcnYuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvc2NzaS9zdG9ydnNjX2Rydi5jDQo+ID4gQEAgLTE5NzYsNiArMTk3NiwxNiBAQCBz
dGF0aWMgaW50IHN0b3J2c2NfcHJvYmUoc3RydWN0IGh2X2RldmljZSAqZGV2aWNlLA0KPiA+ICAg
CQkJCShtYXhfc3ViX2NoYW5uZWxzICsgMSkgKg0KPiA+ICAgCQkJCSgxMDAgLSByaW5nX2F2YWls
X3BlcmNlbnRfbG93YXRlcikgLyAxMDA7DQo+ID4NCj4gPiArCS8qDQo+ID4gKwkgKiB2NS4xNCAo
c2VlIGNvbW1pdCBlYTJmMGY3NzUzOGMpIGltcGxpY2l0bHkgcmVxdWlyZXMgdGhhdA0KPiA+ICsJ
ICogc2NzaV9kcml2ZXIuY2FuX3F1ZXVlIHNob3VsZCBub3QgZXhjZWVkIFNIUlRfTUFYLCBvdGhl
cndpc2UNCj4gPiArCSAqIHNjc2lfYWRkX2hvc3Rfd2l0aF9kbWEoKSBzZXRzIHNob3N0LT5jbWRf
cGVyX2x1biB0byBhIG5lZ2F0aXZlDQo+ID4gKwkgKiBudW1iZXIgKG5vdGU6IHRoZSB0eXBlIG9m
IHRoZSAiY21kX3Blcl9sdW4iIGZpZWxkIGlzICJzaG9ydCIpLCBhbmQNCj4gPiArCSAqIHRoZSBz
eXN0ZW0gbWF5IGhhbmcgZHVyaW5nIGVhcmx5IGJvb3QuDQo+ID4gKwkgKi8NCj4gDQo+IFRoZSBk
aWZmZXJlbnQgZGF0YSBzaXplcyBmb3IgY21kX3Blcl9sdW4gYW5kIGNhbl9xdWV1ZSBhcmUgcHJv
YmxlbWF0aWMgaGVyZS4NCj4gDQo+IEknZCBiZSBtb3JlIGluY2xpbmVkIHRvIHNldCBjbWRfcGVy
X2x1biB0byB0aGUgc2FtZSBkYXRhIHNpemUgYXMNCj4gY2FuX3F1ZXVlLiBXZSBkaWQgZGlzY3Vz
cyB0aGlzIHdoZW4gZWEyZjBmNzc1MzhjIHdhcyB1cHN0cmVhbWVkDQo+IChhY3R1YWxseSBpdCB3
YXMgdGhlIG90aGVyIHdheSBhcm91bmQgLSBzZXR0aW5nIGNhbl9xdWV1ZSB0byAxNmIpLg0KDQpJ
IGNhbiBzZWUgdGhhdCBtYWtpbmcgY2FuX3F1ZXVlIGJlIDE2IGJpdHMgd291bGQgbWFrZSBzZW5z
ZS4NCkFuZCBpdCBhbHNvIHNlZW1zIHRoYXQgYm90aCBjbWRfcGVyX2x1biBhbmQgY2FuX3F1ZXVl
IHNob3VsZCBiZQ0KdW5zaWduZWQsIHRob3VnaCBJIGRvbid0IHRoZSBpbXBsaWNhdGlvbnMgb2Yg
bWFraW5nIHN1Y2ggYSBjaGFuZ2UuDQoNCkJ1dCBpbiB0b2RheSdzIHdvcmxkIHdoZXJlIGNtZF9w
ZXJfbHVuIGlzICJzaG9ydCIgYW5kIGNhbl9xdWV1ZQ0KaXMgImludCIsICBlYTJmMGY3NzUzOGMg
c2VlbXMgaW5jb3JyZWN0IHRvIG1lLiAgVGhlIGNvbXBhcmlzb24gc2hvdWxkDQpiZSBkb25lIGFz
ICJpbnQiLCBub3QgInNob3J0IiwgaW4gb3JkZXIgdG8gcHJldmVudCB0aGUgdHJ1bmNhdGlvbg0K
cHJvYmxlbSB3aXRoIGNhbl9xdWV1ZSB0aGF0IERleHVhbidzIHBhdGNoIGlzIHRyeWluZyB0byBh
ZGRyZXNzLg0KVGhlIHJlc3VsdCB3aWxsIGFsd2F5cyBmaXQgaW4gYmFjayBpbnRvIHRoZSAic2hv
cnQiIGNtZF9wZXJfbHVuIHNpbmNlDQppdCBpcyBjYWxjdWxhdGluZyBhICJtaW4iIGZ1bmN0aW9u
Lg0KDQo+IA0KPiBUaGFua3MsDQo+IEpvaG4NCj4gDQo+IA0KPiA+ICsJaWYgKHNjc2lfZHJpdmVy
LmNhbl9xdWV1ZSA+IFNIUlRfTUFYKQ0KPiA+ICsJCXNjc2lfZHJpdmVyLmNhbl9xdWV1ZSA9IFNI
UlRfTUFYOw0KPiA+ICsNCg0KVGhpcyBmaXggd29ya3MsIGJ1dCBpcyBhIG1vcmUgb2YgYSB0ZW1w
b3JhcnkgaGFjayB1bnRpbCBJIGNhbiBmaW5pc2gNCmEgbGFyZ2VyIG92ZXJoYXVsIG9mIHRoZSBh
bGdvcml0aG0uICAgQnV0IGZvciBub3csIEkgdGhpbmsgdGhlIGJldHRlcg0KZml4IGlzIGZvciBl
YTJmMGY3NzUzOGMgdG8gZG8gdGhlIGNvbXBhcmlzb24gYXMgImludCIgaW5zdGVhZCBvZiAic2hv
cnQiLg0KDQpNaWNoYWVsDQoNCj4gPiAgIAlob3N0ID0gc2NzaV9ob3N0X2FsbG9jKCZzY3NpX2Ry
aXZlciwNCj4gPiAgIAkJCSAgICAgICBzaXplb2Yoc3RydWN0IGh2X2hvc3RfZGV2aWNlKSk7DQo+
ID4gICAJaWYgKCFob3N0KQ0KPiA+DQoNCg==
