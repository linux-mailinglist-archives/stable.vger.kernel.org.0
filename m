Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AF147C835
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhLUUZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 15:25:42 -0500
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com ([104.47.55.100]:11488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234060AbhLUUZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 15:25:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8l2RMwU8v6YtL9k0rbIgs93KQlCWjbrjG/eScXrz/XqkjBywzp9Sx/Yc3XXq3hKgYoM5E3zXRp6G4ytRn4/8PfgJ62ZvFGyrwKTwspFMBgkd7ao5pOtgJ7W7kxkRWh/LTHG2WIkLw9tBVs1/m5XDXPTuDGTj2O/PfbQZ30asqocpGqiXq/uRQYQYAa+NwEWrCFY9QNOTHLskDK805kvGV6xH0WtIsXW/hseL+rMEFLraflTIha7qu30N66Ol9xXP0KSmCBExzZW+laofwRl4XTJEsQ5w09nFOLdqf8E0vwdQvGDfyWQFjFgAu7+xzGqTfOPg0ot3SwsQ+XKu5A15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsjEXCvWlFRjPfjC5YohSvGgYh1wbE/6Zj20Rg+fBe8=;
 b=BGdNNHTC9A9GtgYJ6jOGfqZRaYJgT/X8SWyzEw2S+EWodQ1/fHu0YpKd7ZzFsFc1mXBNjvIuqNGbYhPUh98hh07RphhzEUopl4Z4X7kbfqtme0KBdq3bcBp7PgV5bgRtm9T6/8HkETz5bru58yrsZdmBtRnEhieYKaf9RTI2H2GlQMUuU2ag961creIJGzvx51yHJRVYHtlMBfW+NAhSpndY0tE9G5WFeoaxIcgHg5TTm7nJmb5RxiaMZOMI4fy+X+ChPmlGdTyDWir1+tIrtvNnka5AyJ/S+il9ntvV+ttrsrF8/W6iV72PrqxeCKbiqoPPpTLQ4AI9aO3yEWuVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsjEXCvWlFRjPfjC5YohSvGgYh1wbE/6Zj20Rg+fBe8=;
 b=ZjyUHr4JAPbgROnkQZ9qpDXErQvSf1MC2WXy1b87xivm+ZxFIFGeqGe5QOi8RX/AaTZ8/vf6iJHVyKqXOCtrJ/UQKg+YT9nvB6Zmdn6+q4p6aUQkdLyWxvpSET+z3HdYQ0hi5Zbc2y4u3lLf+wambSaa49OK8R8NjKhQKZk9wkk=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by BL0PR05MB4626.namprd05.prod.outlook.com (2603:10b6:208:59::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.10; Tue, 21 Dec
 2021 20:23:34 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%4]) with mapi id 15.20.4823.016; Tue, 21 Dec 2021
 20:23:34 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAEjF4CAAGztgIAAC/IAgAAHxwCAAAeTgIAAM82AgABcswCAAO2MgIALPnkAgAVLzQCAAMlJAIAAsfCA
Date:   Tue, 21 Dec 2021 20:23:34 +0000
Message-ID: <078460FE-84C4-442C-BD80-97DB90557809@vmware.com>
References: <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
 <YbMZsczMGpChaWz0@dhcp22.suse.cz> <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
 <FD8165E2-E17E-458E-B4EE-8C4DB21BA3B6@vmware.com>
 <YcGignpJgdvy9Vnu@dhcp22.suse.cz>
In-Reply-To: <YcGignpJgdvy9Vnu@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2901c21-f89e-45be-0de8-08d9c4bfc362
x-ms-traffictypediagnostic: BL0PR05MB4626:EE_
x-microsoft-antispam-prvs: <BL0PR05MB46263842586AECD385E66638D57C9@BL0PR05MB4626.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ys7oeqXokaGOaiSMCTyg+U4bRlF7rGqu6OBdnXJN0Fo2FOK2kM5uNznJ5lbetcVN951HciVgNpMLwCDu+oRTRliGzPLgcxthfo6nWe/B+Gjlferbi0Mpy4YAG3vIMG4YVMFRFJRrK+gfcpUv3pbbjirfC5KFczUMP3tJC9onM1N7Tb4iNPG0vGyq2ZRLOjMqhWs4OpkkuiVyOu88I1a8IT8I3GgMOGzxbsVlppZNfatClsh5Z/Yk5qkscZCL/gQm2TdVXI+vsybNHtzP7J2RAsYYGw6ahrVerjiBQ4aVX2ER0tMTnmWuqhqxDLCKvV6DHsF+VEgWvyvachCakTrxA2gtC9Hd+5rA6WPgdOzhoskzCI9CR1/4dLDWkjqCaX+Ho5Qa/xS9qMxSLkR2EPv5t+25rCzE3TixdVmw6rcfOEtlBhGKFWWwHHIcjDOKEj9OTvYoonx7lvUUbvWgfjwMCyegbqS6LVPhmbhngeFrXNqudpit1BFDRW8p2CxXsNQU0Zvjumwu9FsMF1ozbtbthJ/9GraF1dukWM1MwfIbm/aSamEI4j5l2LZIsmNIga/yOO3p/ZfV12LjiQnC8Aqs3a6IVNK19YsUHMMdZaoBl31TxCkCYPzJkbU6ekzGCkm5JXQ97NVirN7o23zJb4kK/dCjVKw9bUp55MhnTVtPN0o3sOfuXGxYlA9EAdUfD+LCQ4ImwviuflTZ8Ajjt8++nnXNEEqWhIOtmb1UdgOQcE4i1PoWBkXnTK3oQguTKvFR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(64756008)(66446008)(7416002)(38070700005)(2906002)(6506007)(66556008)(86362001)(186003)(26005)(36756003)(8676002)(38100700002)(8936002)(4326008)(33656002)(6512007)(122000001)(6916009)(6486002)(76116006)(91956017)(316002)(5660300002)(53546011)(2616005)(66946007)(508600001)(54906003)(71200400001)(45980500001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2ZYTXM3VW9rOTJuVW9ybWtmbEd0alRBanRMOGhlZG13K0xNeFhldjQ3UHlj?=
 =?utf-8?B?d05peG9DeFVLRGVnVEM5bmh1Y1F5N09PTkN4NlhiMkVPUmp5Nk5FQ0FVN1dl?=
 =?utf-8?B?cTM5eGE2dnFsMko0T0hRWFlSMTZhK3dnd09Bak4vby9MSGhuRS9nbXJzcm94?=
 =?utf-8?B?ZnplNU5WYTFnTDlvei8zL1B0cFpuU052bzFWVDJLMmJQSVRYZFNlRFYwVVY4?=
 =?utf-8?B?Z3NmUTE5NTJnLzFIdWZ1K2Jhazc2aHNXV21qdnVXa3hoc0RxdGRzZnNLL25R?=
 =?utf-8?B?Wms5Y3dTNS9talJUajQyUm90eEVVUU1PZ3k0aU9ZbENtYnhKNnBtK2lvR1N0?=
 =?utf-8?B?OHlYR2srVjdMUWdMZjBMRStPdDQ4MFVhNVVhaXgwVW1Rb0JacEpIREZwUUlH?=
 =?utf-8?B?aVpKbWJ5R3BpQmtDenBuWDB6N2JoYVNYTDJqcnZ3RTU1anh0OE9semkwdUpO?=
 =?utf-8?B?TndZQld3ODZpWVNiMlozeFgreWd5VG0zR2I2UXdmWHAwY1pXdXpDQWMySzZu?=
 =?utf-8?B?cFY3c1Nya3JaaFVhd1g3b2tCQnhVODBMK3Z1TCtFdEpHYkVjWGlwWnRSUVZh?=
 =?utf-8?B?cEFZRkE1c0NqQXl1Z3NqWTUzS1hRYzJYbVhyZExyc1Z1aEZlWmpRbW9uZS91?=
 =?utf-8?B?STE5dVh3MUxkMTVTcG56LzJ1UDJKWG03dWtaS1d2aUg2bG5IdVJUcDFkWmh4?=
 =?utf-8?B?d2JFYVNKMGdWdVhlY2lGSXpkZlc5dnBWeG4wbFhBRFh3MnRuOWVHUVErSG1x?=
 =?utf-8?B?N2FsRkdkVnJRSC9wQ1FPVTBzdnkzY2lkbHNKbk9LK2tGNTRTQk4xK284T2tR?=
 =?utf-8?B?NDdSNWtSb0xRN2RnVmRub0hoNngvS3IrK1FvZGE2RnhKcWFZTkswU2ZZSW82?=
 =?utf-8?B?U2Voc2hIYW5VdE5USzI3Q0psK21ING5lYmtrdDBkQSt2WVo4S093b1BiVUht?=
 =?utf-8?B?Uk9wdG1FMDR2aUlZL2IrdGwzdE9FSXZ2UFdybDU5NnFqejF4UE1MeXhYNVNK?=
 =?utf-8?B?L25ObEozTkVwWnE4SGhkK3A0ajdIaDNDM3VrZkw2bG1iclRLM0w2QkZpSVhN?=
 =?utf-8?B?NHVnUmtYdXBGUWZKcWVqYURKdWN2WWFyRHRyYm5WNld2MUxWU1gxcnlOM1ho?=
 =?utf-8?B?L2RTL29ESTFVZzRzQ2VPMjJHbW5sZWVXRWE3OTg3MkpORVFpUFhzNnEzTVVu?=
 =?utf-8?B?WmdkYnR1VUhXM0VhS2M1R20zMUdzUjNEdkRvalA3MjNlaWVqc0E1bW80K09H?=
 =?utf-8?B?Rlg4YUM0ZE0rRmd2YkVVYXhYbG8vMU9XemxrRWY0Y0QraDdSQ1JuV0NGbHJI?=
 =?utf-8?B?eEpDUGlXdXYvcitQWHY4RVhkVXgyUklJWW1ST0ZtZ05ScGdlS0UvdHhTOU5I?=
 =?utf-8?B?end1c2xqT08yNU5sbDZuaHlOdytjREF5TkVGTytFRDBzYUNSQTJaa21RZWlZ?=
 =?utf-8?B?eVo0WlV2N2gyMWoxU21pWWtoVHdnVGVuODAwLzVrVzVrQlFuREhDMyt4R3lp?=
 =?utf-8?B?YWNOWlpGSXJHeHpSL2pnc2IvRGNQWFk0WlI2ZWZjUTI3bVViM0dCRGh0QWVo?=
 =?utf-8?B?WXVRNzdLcmF1cXoyY0JlZUFRMGRWL1FBZ1QydlVpblVtdTRBRVV6c3Z0Yisx?=
 =?utf-8?B?QjRQYmgwbjBDTjk5SjJmY2FoRW9Bb1h0RkxQakdCL0IvZmZFZ2w0dDlRWEY3?=
 =?utf-8?B?aWd4c0I0c3pFNjhPanJhSk9ldG50eVdjNUtGem05ckNSeDJEQVJSSXVCTzlK?=
 =?utf-8?B?Q3BGeWgzcW9iQVZCZXNXNkRkTWV0bkJSZ0FOV0tQT3RWQ2dMOHNBQTdpbkFu?=
 =?utf-8?B?MDBVcWw4SGovaXFPdjd3Y0ozQmo1K3lMTVdLZ2dxUWZIYU51OElqREtianJL?=
 =?utf-8?B?SVhHNnd2Zmh6S0pLRTdMeGIxOFl5WkRETWQ3MmRmdUErK3NWTjVuYUdnRkE0?=
 =?utf-8?B?dGxFSE5QNzNnTmtOVFFRNDhvazRMaVhvTVIrMzZ2U0p4eGQza0JzbFEwdmtx?=
 =?utf-8?B?Vlcyd2NKNHd0YjFQSlo2SWM0cko0M0VVL0l6UytnUE5PdTVrSWRqVU1aWEVY?=
 =?utf-8?B?Y243Sm5YRzY2QUtpOVEvMHNCajdEdFBUUkI2dFhYdjhGUWJnVWdxWG8rWCty?=
 =?utf-8?B?UVg1YThMNjJOWGpFU1dSWERibjB3bXdibEQyeTJ2cUJsWUU0MHUwWmdDWlE0?=
 =?utf-8?Q?1NR+9MNRKfm0wiRSO3olH6JmSI8ErCsoofrN4IV5XMH0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3919CE2FCFE9A544B5782956288C1641@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2901c21-f89e-45be-0de8-08d9c4bfc362
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 20:23:34.4791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R35Nl1c43s18K0PZ/D9bYe+6O5212aZJaM8ynX4ocby7Qj3zX4UhO49qdhDegPH9MjuLyEnfRZaPMsar2bYeFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4626
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gRGVjIDIxLCAyMDIxLCBhdCAxOjQ2IEFNLCBNaWNoYWwgSG9ja28gPG1ob2Nrb0Bz
dXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUgMjEtMTItMjEgMDU6NDY6MTYsIEFsZXhleSBN
YWtoYWxvdiB3cm90ZToNCj4+IEhpIE1pY2hhbCwNCj4+IA0KPj4gVGhlIHBhdGNoc2V0IGxvb2tz
IGdvb2QgdG8gbWUuIEkgZGlkbuKAmXQgZmluZCBhbnkgaXNzdWVzIGR1cmluZyB0aGUgdGVzdGlu
Zy4NCj4gDQo+IFRoYW5rcyBhIGxvdC4gQ2FuIEkgYWRkIHlvdXIgVGVzdGVkLWJ5OiB0YWc/DQpT
dXJlLCB0aGFua3MuDQoNCj4gDQo+PiBJIGhhdmUgb25lIGNvbmNlcm4gcmVnYXJkaW5nIGRtZXNn
IG91dHB1dC4gRG8geW91IHRoaW5rIHRoaXMgbWVzc2FnaW5nIGlzDQo+PiB2YWxpZCBpZiBwb3Nz
aWJsZSBub2RlIGlzIG5vdCB5ZXQgcHJlc2VudD8NCj4+IE9yIGlzIGl0IG9ubHkgdGhlIGlzc3Vl
IGZvciB2aXJ0dWFsIG1hY2hpbmVzPw0KPj4gDQo+PiAgTm9kZSBYWCB1bmluaXRpYWxpemVkIGJ5
IHRoZSBwbGF0Zm9ybS4gUGxlYXNlIHJlcG9ydCB3aXRoIGJvb3QgZG1lc2cuDQo+PiAgSW5pdG1l
bSBzZXR1cCBub2RlIFhYIFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAwMDAwMDAwMDAwMDAw
MF0NCj4gDQo+IEFGQUlVIHRoZSBJbml0bWVtIHBhcnQgb2YgdGhlIG91dHB1dCBpcyB3aGF0IGNv
bmNlcm5zIHlvdSwgcmlnaHQ/IFllYWgsDQpGaXJzdCBsaW5lIGFjdHVhbGx5LCB0aGlzIHNlbnRl
bmNlIOKAnFBsZWFzZSByZXBvcnQgd2l0aCBib290IGRtZXNnLuKAnS4gQnV0DQp0aGVyZSBpcyBu
b3RoaW5nIHRvIGZpeCwgYXQgbGVhc3QgZm9yIFZNcy4NCg0KPiB0aGF0IHJlYWxseSBpcyBtb3Jl
IGNyeXB0aWMgdGhhbiBuZWNlc3NhcnkuIERvZXMgdGhpcyBsb29rIGFueSBiZXR0ZXI/DQo+IGRp
ZmYgLS1naXQgYS9tbS9wYWdlX2FsbG9jLmMgYi9tbS9wYWdlX2FsbG9jLmMNCj4gaW5kZXggMzQ3
NDNkY2QyZDY2Li43ZTE4YTkyNGJlN2UgMTAwNjQ0DQo+IC0tLSBhL21tL3BhZ2VfYWxsb2MuYw0K
PiArKysgYi9tbS9wYWdlX2FsbG9jLmMNCj4gQEAgLTc2MTgsOSArNzYxOCwxNCBAQCBzdGF0aWMg
dm9pZCBfX2luaXQgZnJlZV9hcmVhX2luaXRfbm9kZShpbnQgbmlkKQ0KPiAJcGdkYXQtPm5vZGVf
c3RhcnRfcGZuID0gc3RhcnRfcGZuOw0KPiAJcGdkYXQtPnBlcl9jcHVfbm9kZXN0YXRzID0gTlVM
TDsNCj4gDQo+IC0JcHJfaW5mbygiSW5pdG1lbSBzZXR1cCBub2RlICVkIFttZW0gJSMwMThMeC0l
IzAxOEx4XVxuIiwgbmlkLA0KPiAtCQkodTY0KXN0YXJ0X3BmbiA8PCBQQUdFX1NISUZULA0KPiAt
CQllbmRfcGZuID8gKCh1NjQpZW5kX3BmbiA8PCBQQUdFX1NISUZUKSAtIDEgOiAwKTsNCj4gKwlp
ZiAoc3RhcnRfcGZuICE9IGVuZF9wZm4pIHsNCj4gKwkJcHJfaW5mbygiSW5pdG1lbSBzZXR1cCBu
b2RlICVkIFttZW0gJSMwMThMeC0lIzAxOEx4XVxuIiwgbmlkLA0KPiArCQkJKHU2NClzdGFydF9w
Zm4gPDwgUEFHRV9TSElGVCwNCj4gKwkJCWVuZF9wZm4gPyAoKHU2NCllbmRfcGZuIDw8IFBBR0Vf
U0hJRlQpIC0gMSA6IDApOw0KPiArCX0gZWxzZSB7DQo+ICsJCXByX2luZm8oIkluaXRtZW0gc2V0
dXAgbm9kZSAlZCBhcyBtZW1vcnlsZXNzXG4iLCBuaWQpOw0KPiArCX0NCj4gKw0KPiAJY2FsY3Vs
YXRlX25vZGVfdG90YWxwYWdlcyhwZ2RhdCwgc3RhcnRfcGZuLCBlbmRfcGZuKTsNCj4gDQo+IAlh
bGxvY19ub2RlX21lbV9tYXAocGdkYXQpOw0KU2Vjb25kIGxpbmUgbG9va3MgbXVjaCBiZXR0ZXIu
DQoNClRoYW5rIHlvdSwNCuKAlEFsZXhleQ0KDQo=
