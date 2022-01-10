Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF0D489D7A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiAJQZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 11:25:54 -0500
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:61025
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237311AbiAJQZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jan 2022 11:25:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPxM3vs3NeK+CLoqJxezeFMJC7ze8R2a61a7izd5jKbrN0WQ9FFSL6ZoAk3wzdDbaw95vPZAvqsIJnMJNuDV+JxnXuOBAbx64RnuBPk7UIp+Kf59rYfhZJtvhCoAfA8YIwm95sX/3VAYOQQ+PRu20ScqaLKPLfyLnl+VUUlMR4/75NfoCYO6fBSdazDvWyXceuWxRTNfcQmhasiVyVgU3uHExhjMu4qIMX4sFcZTe8q8XJBg1TQa6srqDqPaeFzTd24NQWVWkUhWaJ2lluaSaENbjS+ZOWZgTJq2kMvUrqt+U6+hCpN2GDE9M9s9OoMTKjKcIhuqBspZOp1Y5hAKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdOzlfujB0WpQ5ZBItUWClzS/13Xb2X3aYoeZ4zLEbY=;
 b=jiVpNd38pOM+UEK+qpkXPRgjj6DEm21jqHiwhlctilDY1HLnCtVD08MmQNlB4dRN4uP/xHXL94hjMHl+WSdXuHa09tv1ZzykBCPe5KRdSImRjQcfhwBQG46F6gbfVhGF6OnkG74QdRgN2K0K1ZFAEVB404z26O+bWmlTC6zsVaKdYrK93UQ2yj+Nz6I3RRtJ/LUFM/j77frS4dPzQIz6W66GsUTYXpxA42Rg2tSYbjN36kyZ33RjYHIVo5y/r502N/3hx+hFa/SpJ9kqlV1E/fbT5GuS3ReG5q5pRZoOPzrE/mVpauSvXSCqyxLfRSFWeUBXuZlo8XvTXxTmSBGV9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdOzlfujB0WpQ5ZBItUWClzS/13Xb2X3aYoeZ4zLEbY=;
 b=PfihkSpEf/MRfkSW4M3B/NK/zXpowavRygO6OMg5u1UgX3/+90kmCckm/Nt4K60TAVIxm2E6b89brrwbfTIUEyjZthtaNfNkwPs+yJKP9S2QDhdi3x7k/ZFQy0fOpYB2QxqPJk2XKszR9ylKP8kZLErKGorhvF5Dcjyl4/XHRZ8=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 16:25:51 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::99d4:4d4f:653f:61be]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::99d4:4d4f:653f:61be%4]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 16:25:51 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        Len Brown <lenb@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Chen, Guchun" <Guchun.Chen@amd.com>,
        "Grodzovsky, Andrey" <Andrey.Grodzovsky@amd.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Topic: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Thread-Index: AQHYBYR7VOg0MzhXpUSaIqoHT+4q4qxcbLeAgAADCQCAAAJBEA==
Date:   Mon, 10 Jan 2022 16:25:51 +0000
Message-ID: <BL1PR12MB51441B895F9846A11D6268E2F7509@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
 <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2e3fbfe8-e7a1-2483-dbbd-ebb3824fc886@amd.com>
In-Reply-To: <2e3fbfe8-e7a1-2483-dbbd-ebb3824fc886@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-10T16:24:38Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=90ae8098-4147-46b6-a228-648f64a07498;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-10T16:25:44Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 643ccaf7-cb87-4b8f-bbe5-ac598c4c05cc
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9498e8a5-33dd-43d7-429d-08d9d455de46
x-ms-traffictypediagnostic: BL1PR12MB5239:EE_
x-microsoft-antispam-prvs: <BL1PR12MB5239239558D013EC0598006AF7509@BL1PR12MB5239.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:407;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +It9uuMfe3K4hEOWf4QwRJhTxQi/Fx984UtVhGKj+zVNSplR7Q7IvXDu1b7Ova53fa6Ks2nM59XNMgtQR6cHECkzOdE+XNV+gBTpjvGYJiwAY//cgLfYcHYl/V1jiSPeJcwTVGx/1jMTiIMPiQ/yIyx4iE29mSDjdQmhAXnJmC20OOgvFjnNE7dt7bA2aN21ishsl5rJe9CbEpWRawy15NX8oKTBpcltSu3YSF02ktB7kUvgS59dLJx/i0L4q9/68QbyRi7QHLC+kaizVMlWh3C7nevUgk/nvVYsftKhSdvcYI7Nij+3NMMtcRzh8hjKf/z8rZ/5QMBNc3auhVbLiAIr7kMbh85yzysPwybZYzrHHI3w1t+cxDpA4xP6ALMna3gjAvPThPaNpT72JobNJPIjkp0gAsBdVEFdNlSzFf4DWjv2iMXI9T7N1oVdnSPw+H35T3mx7ymrla5xUfDfc2BZh/T5ovrHyUT3+DyZV66b+LfdtMZxKTQS3DbyjVPC1ScFAJCbALg2xzsR2l6BjJ6DomiMldrQT3rGIVAzM48lRtiKJF+0Kpnhtk4CD2OxzWKH4jqLinPGc1mF6l3ZSkmGjK6ROer/jl+lUBUjQd9kUARsEGKjk4h94YFQqRE/YB+vCRz640XWv2PsWhPgDcmQnE8lFoAgigw1O1fhQSUG/5y+QHFKwF4MEM92YnoO3omOkPRy7huB0DuSCYCWQzmUfvHWVXc5lyIBeuA9JbZiIDEC7Pugvt4roI9D/5+hQMnR6FgVAR0xrz8m+8EPmG/m0ToZHdpoWoZ5monrKZo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(110136005)(45080400002)(8676002)(966005)(71200400001)(33656002)(38100700002)(5660300002)(86362001)(54906003)(8936002)(122000001)(9686003)(66946007)(66556008)(66446008)(64756008)(6636002)(76116006)(4326008)(66476007)(2906002)(7696005)(38070700005)(186003)(316002)(52536014)(55016003)(83380400001)(26005)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG85RGpvNTBrSk1Hai9mWnppYlVPYmM4QXRUVEVPYk1ZbmF1bUtHSFVJaHZQ?=
 =?utf-8?B?dmViOEtadVZ6K09BQ2h4R3d1NmVob0MvY1BIRzViMFN6U0x5QStrODZXM01E?=
 =?utf-8?B?S0NqVlFDNTcxOStSVGhud2RnS2d4bFJNWVZ3WkE3L0ozOTQ3K0FKTnFjOWVS?=
 =?utf-8?B?c1M4b2dSaG1kalU3TGwzVytWMEZCazRlVXNmTHBlUUpwYUhlV1dkN1czellh?=
 =?utf-8?B?N2tXb1Jyb3ZmK09oK3JZR0tnWEo5YkF2T1VDUFBRajI2T0FaWDljMFJMNFUx?=
 =?utf-8?B?VnhXMnpQbnBObkFUK2NzWE1oNGQ3OThHNjBsTkVvckhhc0x3YWxmTmk0TEFJ?=
 =?utf-8?B?eFhGZ0hacjVGYWpUS3BYRGoydTZFZjBuNndEODF6enY1ZnNOb3p1TFRZMzl1?=
 =?utf-8?B?RVpGS1phY3AxYU5KTldGUWFlVnZEUTR6bE9UeXhHeWFTTUZ4R2FqcGF0d0dj?=
 =?utf-8?B?eEI5RFZZWFhlbFJWK0dZMHoxdHo4WFRmVVU3V0o3WW9jVFNuQXd1dDhheVp4?=
 =?utf-8?B?a0lCRzY5Y3RGQ3cvQWFhaWdSUngzbnptMGNwYmNhanBCTVJ6by9aSFcxQTcy?=
 =?utf-8?B?cGVRTUw0dVRUbFU3VnRpdVNBT0hxclI5L0svbnVIdURZRXFuY3JmakRHU2Vs?=
 =?utf-8?B?ZWFtUzlQWk9lS2x0NFRSblJuczV3YUJOMTZSOG81eFdBbzRhQ1NvRWV6YmIx?=
 =?utf-8?B?TW9YWTVyVUdzdkVHT1FLNHJlVDI0VnhhTHRhUTFBcjlIdVRPMWw4RG5mWDNY?=
 =?utf-8?B?aEFLNjZSWXRtSmVqbFk0bEZaVDJneW5xNzlFUEUzejBHM1VWc2V5aGlSVnlP?=
 =?utf-8?B?WW5EUFprdS91YTEveWkwc29HS0lEbG80NC9zSVlaTlVJTm5iOVVxVjdwa252?=
 =?utf-8?B?bTgyUWFYWXVmU290Umk1K1JreDYrbXFVWlJIR05KYVh3VzRYUXljckduYXh4?=
 =?utf-8?B?akVmbGlSajlwM29LbXAwVWxwM0VCRklUUVNVMk8vU1BCNkFFdDlUSzIycnVE?=
 =?utf-8?B?NkJvbUxwWnVvRFFIbVp6a2FVR3JjRVpnMy9vSWtBVGFQU1dSTzFNQ0NhR2Rv?=
 =?utf-8?B?dm1RWXVjUkNLVXpBMHRJSHpwZHc0MmlCVHE0TDZWZTFNb0NuL1FDNDFWZ0lC?=
 =?utf-8?B?bFFSNmd1TmVBS0pkVzdnbFVTSmhaZkVKaUZjbzJKMFZRL2VCUDhRenlSbnEz?=
 =?utf-8?B?dWQrZkVDc2owcXN2TGtMT3F4OW4zYms4MlNOeXdVT05FYm1iUytKVnBkd0RT?=
 =?utf-8?B?MDVWd2lDZTRMTEMxL3Y2TnArRjVRNHl0OXYyTkpsb25PLy9PVzEyYTN0MmRT?=
 =?utf-8?B?TDU2blVya2dpQjN5SU1qM0tFVU5jM0FaSm9DMncyeVB4Y3N3RzQ0bk1XSGFs?=
 =?utf-8?B?blVGQlZBM0NxNG03cmRvYzdJZ2s3QjFBbGwxR2RZUXdrdWhBUUpONUc1TFVT?=
 =?utf-8?B?NDV4R01RT0pDVkdZM2xQbUxGRHlYeXBoUmVIekJqdTdDaGxiNXdYUlJ5Ky9D?=
 =?utf-8?B?SWJFU3JQd3VwQloyTFVlMGQzanROUi8vWlhCNGh5TmNQQlE2bVgrUWViUTIv?=
 =?utf-8?B?L3JGRjNtT2R2cWNvK1BhYWplbWlvcVFsTkY5U3BKQktJZ2kzdFRnS3BCME5M?=
 =?utf-8?B?cW9HaEJLaFBEWmtCRllHRHpQSEk3UFB6NzI4d0ZTYVlFWTBxVThBUGlQWCt1?=
 =?utf-8?B?MXdIb1NWT3h0N0tLWGx5OWZrelN3eWdydVZVUjZDazd5TlZXNGhkdWlRRGFW?=
 =?utf-8?B?MlpSeEFuVHlOY001cExSZEJuRUpGTERKbnRYYWl0R0pjRkw4WjFrWFltbjJl?=
 =?utf-8?B?ME1pbEhnNG9ScFJoUm13ZmtOYU52eG9hOTVleXpJbXVQeUx5REtrQTJRa1lU?=
 =?utf-8?B?U055OHhodk95NGRnTENDMDdxUW1sSGluQ3RqelE2V202TDYrYXZNVTBWN2pM?=
 =?utf-8?B?Tm1XZjFxa1ZRL2hXMlhnTWQ1RkRqOHNnNXBPaklrTkFkZFVhNGR2dFRxZmxL?=
 =?utf-8?B?VEdOdFd6ck9yQUNNSWVaZmh5bzFBZ29EeDEzNXUvY3ZjWW9pRVB1TmhLRjYr?=
 =?utf-8?B?SG5GTjNMM0ZOZHNTY3o4cTB4TnA3U2xQMFFDVEowenVTbFV1L21aRGNYV1dZ?=
 =?utf-8?B?UXlTMU5rSHYvWmtxa0Y4eTNCek1CM1NHRWgraTVKKzNsTU4wdTJyUFlVWHVy?=
 =?utf-8?Q?J93xiJXPmHTSlKNLcr4GXtA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9498e8a5-33dd-43d7-429d-08d9d455de46
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 16:25:51.4685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKWmILJttPncbMcYcLGXTtjRUUtvL+XwSXqmYOv1G5Jxia5arLOFFGZevlLE3m/BR7eznJaQluJXBT3DT7vhRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLb2VuaWcs
IENocmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPg0KPiBTZW50OiBNb25kYXksIEph
bnVhcnkgMTAsIDIwMjIgMTE6MTYgQU0NCj4gVG86IERldWNoZXIsIEFsZXhhbmRlciA8QWxleGFu
ZGVyLkRldWNoZXJAYW1kLmNvbT47IExlbiBCcm93bg0KPiA8bGVuYkBrZXJuZWwub3JnPjsgdG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc7IENoZW4sIEd1Y2h1bg0KPiA8R3VjaHVuLkNoZW5A
YW1kLmNvbT47IEdyb2R6b3Zza3ksIEFuZHJleQ0KPiA8QW5kcmV5Lkdyb2R6b3Zza3lAYW1kLmNv
bT4NCj4gQ2M6IGxpbnV4LXBtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsgTGVuIEJyb3duDQo+IDxsZW4uYnJvd25AaW50ZWwuY29tPjsgc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJFR1JFU1NJT05dIFJldmVydCAiZHJt
L2FtZGdwdTogc3RvcCBzY2hlZHVsZXINCj4gd2hlbiBjYWxsaW5nIGh3X2ZpbmkgKHYyKSINCj4g
DQo+IEFtIDEwLjAxLjIyIHVtIDE3OjA4IHNjaHJpZWIgRGV1Y2hlciwgQWxleGFuZGVyOg0KPiA+
IFtQdWJsaWNdDQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJv
bTogTGVuIEJyb3duIDxsZW5iNDE3QGdtYWlsLmNvbT4gT24gQmVoYWxmIE9mIExlbiBCcm93bg0K
PiA+PiBTZW50OiBTdW5kYXksIEphbnVhcnkgOSwgMjAyMiAxOjEyIFBNDQo+ID4+IFRvOiB0b3J2
YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZw0KPiA+PiBDYzogbGludXgtcG1Admdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBMZW4gQnJvd24NCj4gPj4gPGxlbi5i
cm93bkBpbnRlbC5jb20+OyBDaGVuLCBHdWNodW4gPEd1Y2h1bi5DaGVuQGFtZC5jb20+Ow0KPiA+
PiBHcm9kem92c2t5LCBBbmRyZXkgPEFuZHJleS5Hcm9kem92c2t5QGFtZC5jb20+OyBLb2VuaWcs
IENocmlzdGlhbg0KPiA+PiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgRGV1Y2hlciwgQWxl
eGFuZGVyDQo+ID4+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiA+PiBTdWJqZWN0OiBbUEFUQ0ggUkVHUkVTU0lPTl0gUmV2ZXJ0ICJkcm0vYW1k
Z3B1OiBzdG9wIHNjaGVkdWxlcg0KPiB3aGVuDQo+ID4+IGNhbGxpbmcgaHdfZmluaSAodjIpIg0K
PiA+Pg0KPiA+PiBGcm9tOiBMZW4gQnJvd24gPGxlbi5icm93bkBpbnRlbC5jb20+DQo+ID4+DQo+
ID4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgZjdkNjc3OWRmNjQyNzIwZTIyYmZmZDQ0OWU2ODNiYjg2
OTBiZDNiZi4NCj4gPj4NCj4gPj4gVGhpcyBiaXNlY3RlZCByZWdyZXNzaW9uIGhhcyBpbXBhY3Rl
ZCBzdXNwZW5kLXJlc3VtZSBzdGFiaWxpdHkgc2luY2UNCj4gPj4gNS4xNS0gcmMxLiBJdCByZWdy
ZXNzZWQgLXN0YWJsZSB2aWEgNS4xNC4xMC4NCj4gPj4NCj4gPj4NCj4gaHR0cHM6Ly9uYW0xMS5z
YWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGYnVnDQo+
ID4+IHoNCj4gaWxsYS5rZXJuZWwub3JnJTJGc2hvd19idWcuY2dpJTNGaWQlM0QyMTUzMTUmYW1w
O2RhdGE9MDQlN0MwMSU3Q2FsDQo+ID4+DQo+IGV4YW5kZXIuZGV1Y2hlciU0MGFtZC5jb20lN0Nj
Zjc5MGJlNDgyN2Y0ZGY5ZjJkODA4ZDlkMzliODFhZiU3QzMNCj4gPj4NCj4gZGQ4OTYxZmU0ODg0
ZTYwOGUxMWE4MmQ5OTRlMTgzZCU3QzAlN0MwJTdDNjM3NzczNDg3NTY5NDQyNzE2JTdDDQo+ID4+
DQo+IFVua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJs
dU16SWlMQ0pCDQo+ID4+DQo+IFRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCZhbXA7
c2RhdGE9QVgwVFhreW9NaHklMkJacUUNCj4gPj4gVmdSU1dNa0tkNW5QYTRXT3YlMkIxRlpITFNF
clN3JTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4+DQo+ID4+IEZpeGVzOiBmN2Q2Nzc5ZGY2NCAoImRy
bS9hbWRncHU6IHN0b3Agc2NoZWR1bGVyIHdoZW4gY2FsbGluZyBod19maW5pDQo+ID4+ICh2Miki
KQ0KPiA+PiBDYzogR3VjaHVuIENoZW4gPGd1Y2h1bi5jaGVuQGFtZC5jb20+DQo+ID4+IENjOiBB
bmRyZXkgR3JvZHpvdnNreSA8YW5kcmV5Lmdyb2R6b3Zza3lAYW1kLmNvbT4NCj4gPj4gQ2M6IENo
cmlzdGlhbiBLb2VuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gPj4gQ2M6IEFsZXgg
RGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gPj4gQ2M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPiAjIDUuMTQrDQo+ID4+IFNpZ25lZC1vZmYtYnk6IExlbiBCcm93biA8bGVu
LmJyb3duQGludGVsLmNvbT4NCj4gPiBAQ2hlbiwgR3VjaHVuLCBAR3JvZHpvdnNreSwgQW5kcmV5
LCBAS29lbmlnLCBDaHJpc3RpYW4NCj4gPg0KPiA+IEFueSBpZGVhcz8gIFdoYXQncyB0aGUgY29u
c2VxdWVuY2Ugb2YgcmV2ZXJ0aW5nIHRoaXMgcGF0Y2g/ICBEaWRuJ3QgdGhpcw0KPiBwYXRjaCBm
aXggYW5vdGhlciBzdXNwZW5kL3Jlc3VtZSBpc3N1ZT8NCj4gDQo+IEkgdGhpbmsgR3VjaHVuIHdh
cyBqdXN0IHRyeWluZyB0byBhZGFwdCB0aGF0IHdlIHJlbW92ZWQgdGhlIHNjaGVkdWxlciBzdG9w
DQo+IGZyb20gdGhlIGZlbmNlIGRyaXZlciBodyBmaW5pIHBhdGguDQo+IA0KPiBOb3Qgc3VyZSBp
ZiB0aGF0IGFjdHVhbGx5IGZpeGVkIHNvbWV0aGluZyBvciB3YXMganVzdCBhIHByZWNhdXRpb24u
DQoNClRoYW5rcy4gIEknbGwgd2FpdCBmb3IgZmVlZGJhY2sgZnJvbSBHdWNodW4gYW5kIEFuZHJl
eSBhbmQgaWYgdGhleSBhcmUgb2sgd2l0aCBpdCwgSSdsbCBhcHBseSB0aGUgcmV2ZXJ0Lg0KDQpB
bGV4DQoNCg0KPiANCj4gUmVnYXJkcywNCj4gQ2hyaXN0aWFuLg0KPiANCj4gPg0KPiA+IEFsZXgN
Cj4gPg0KPiA+PiAtLS0NCj4gPj4gICBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVf
ZmVuY2UuYyB8IDggLS0tLS0tLS0NCj4gPj4gICAxIGZpbGUgY2hhbmdlZCwgOCBkZWxldGlvbnMo
LSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2Ft
ZGdwdV9mZW5jZS5jDQo+ID4+IGIvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X2Zl
bmNlLmMNCj4gPj4gaW5kZXggOWFmZDExY2EyNzA5Li40NTk3N2E3MmI1ZGQgMTAwNjQ0DQo+ID4+
IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9mZW5jZS5jDQo+ID4+ICsr
KyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9mZW5jZS5jDQo+ID4+IEBAIC01
NDcsOSArNTQ3LDYgQEAgdm9pZCBhbWRncHVfZmVuY2VfZHJpdmVyX2h3X2Zpbmkoc3RydWN0DQo+
ID4+IGFtZGdwdV9kZXZpY2UgKmFkZXYpDQo+ID4+ICAgCQlpZiAoIXJpbmcgfHwgIXJpbmctPmZl
bmNlX2Rydi5pbml0aWFsaXplZCkNCj4gPj4gICAJCQljb250aW51ZTsNCj4gPj4NCj4gPj4gLQkJ
aWYgKCFyaW5nLT5ub19zY2hlZHVsZXIpDQo+ID4+IC0JCQlkcm1fc2NoZWRfc3RvcCgmcmluZy0+
c2NoZWQsIE5VTEwpOw0KPiA+PiAtDQo+ID4+ICAgCQkvKiBZb3UgY2FuJ3Qgd2FpdCBmb3IgSFcg
dG8gc2lnbmFsIGlmIGl0J3MgZ29uZSAqLw0KPiA+PiAgIAkJaWYgKCFkcm1fZGV2X2lzX3VucGx1
Z2dlZChhZGV2X3RvX2RybShhZGV2KSkpDQo+ID4+ICAgCQkJciA9IGFtZGdwdV9mZW5jZV93YWl0
X2VtcHR5KHJpbmcpOyBAQCAtNjA5LDExDQo+ICs2MDYsNiBAQCB2b2lkDQo+ID4+IGFtZGdwdV9m
ZW5jZV9kcml2ZXJfaHdfaW5pdChzdHJ1Y3QNCj4gPj4gYW1kZ3B1X2RldmljZSAqYWRldikNCj4g
Pj4gICAJCWlmICghcmluZyB8fCAhcmluZy0+ZmVuY2VfZHJ2LmluaXRpYWxpemVkKQ0KPiA+PiAg
IAkJCWNvbnRpbnVlOw0KPiA+Pg0KPiA+PiAtCQlpZiAoIXJpbmctPm5vX3NjaGVkdWxlcikgew0K
PiA+PiAtCQkJZHJtX3NjaGVkX3Jlc3VibWl0X2pvYnMoJnJpbmctPnNjaGVkKTsNCj4gPj4gLQkJ
CWRybV9zY2hlZF9zdGFydCgmcmluZy0+c2NoZWQsIHRydWUpOw0KPiA+PiAtCQl9DQo+ID4+IC0N
Cj4gPj4gICAJCS8qIGVuYWJsZSB0aGUgaW50ZXJydXB0ICovDQo+ID4+ICAgCQlpZiAocmluZy0+
ZmVuY2VfZHJ2LmlycV9zcmMpDQo+ID4+ICAgCQkJYW1kZ3B1X2lycV9nZXQoYWRldiwgcmluZy0+
ZmVuY2VfZHJ2LmlycV9zcmMsDQo+ID4+IC0tDQo+ID4+IDIuMjUuMQ0K
