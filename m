Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833BD46E594
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 10:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbhLIJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 04:32:33 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:65344
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236281AbhLIJc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1OI4mifG6hpEcwwtK1JHwzwZbW61UWN4ibTB/rqPY+xu824+Ri8ChBhJf2GEpwqMqdZ7ukTxvi5EuYCL5IpXht5DG+9MMoEPl9BMCnH2myRVPQbD5t7OSHIlgDOqKzhqe3ZAqQabvZXzj6IIoDRRXs2RpSmKSGGHz0BS9Wodt+cG2K0ER8RtyJ/+4sHIsrx/5dtmLKrFBHd1ARMine25+nU2hCtmFaRCpDAQzAeYyRR38MIOpE4s9ZoMJaqPXL9vgESu9QK60wI3FaKeWuEwX8R39raGFANhnf9lYTs3IxfZOhGYkAI7Rb4Ar7UJ9q0OUsL4pyP3Vu6plMtdtC6NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPSFa0cjaUeU7WXlO/OwiIgkqFaCywE+K9MtOlr9jtg=;
 b=SoAu+Rd2dAEs5wz3WK7++WUza15pYptmfr1fpIpkVBKCMruklGG1uBJG2Mytc/bDOoj7f22/p7GXQF5EIxCTUZgNAb8AsnuvnrpSkDWgvyF5ZwXqUS8GjMxSof02PSQPNGfYkdWGcZTH5MGOIeQKojJVcOn3ACRNL9IK4jxhnorfz7cbvV3PBFvAa3XOFJl8OAf5TYfmz25Dd5h9DuhXYjACWWENkvH1xF13NW2HqVzD5SdwfeDeJ2gIWzBtYsDHTqjxAc4lFrFAsQIImuHyw3f/UkRA56GpTrI3QzvY13QXiR6kijgwO7/QRAqMfuCMBVYmgU2G6a5Aa5VcxMC7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPSFa0cjaUeU7WXlO/OwiIgkqFaCywE+K9MtOlr9jtg=;
 b=hwogLDS2KWrvhaEZm8UeaSx2+V3jA5VV9vrCH77IoLA8gQaTGiqIqnbBO2woNZNsXw4vrrNW9eJmo07zvdQB1JJmXWr13sg3ZJ/PFXndQinow+naZHgWxhYxeiwFqXsTY69kJ09bkIidBmbuX8BjDj8qBVD8L0IC4fHRGQbwYwQ=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MW4PR05MB8233.namprd05.prod.outlook.com (2603:10b6:303:120::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.2; Thu, 9 Dec
 2021 09:28:55 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%3]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 09:28:55 +0000
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
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAEjF4CAAGztgIAAC/IA
Date:   Thu, 9 Dec 2021 09:28:55 +0000
Message-ID: <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
References: <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
In-Reply-To: <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc30c766-2196-4e38-130c-08d9baf6524b
x-ms-traffictypediagnostic: MW4PR05MB8233:EE_
x-microsoft-antispam-prvs: <MW4PR05MB8233A299A4E7F6FEE388AC65D5709@MW4PR05MB8233.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2pSLUVxWmmyGWOkUQGqQbs84UO1LoLoVV5SQM9tatbVzAP8XJbhj5aHVitOkiKtnNeYzPaeJhIyXqYDsrCkvoICFwZ6VmxlPtVGfF0aTvvrf4D0uoSAKn2V/y0K1i2NyJBZQlFOOOyQHsCCE/DeQf2B4KXZCV5erjF9PVpXPH9hoQfmvJnA78qBU0MNvyD4FZ/j2QlsbofEzZuuS8rlhXHXvZ17Tzrk0jFNtuiLcr8tAmjE5neEaZ63/1rB89+DVQ8yHEtO5G4LBlnEpoYq/mhIiIaeht0Dk4Kr4PbxQ20+/bSxCPamvzbc90T2wLiD9tlPKTGx6O3kSgDlyQRaEBQJWtGFcG86/EK3EUgfRSUCvsCuDOMtw/eSxvgp6cEsYTovT0Ycsf6UUHnnREvVyZDKMDRssNoJF/mQlSrqzXWsvkJQQkZSltxdft8TYVly1jtuCQgdMEXj2/8oq+Pyw9JRCT/RrND/idzWRjOEx0ELFu3v3zbGd03nD5ULdLWFWjOgLTm5WgpKrUmUbxs3pFzNOGhKNsa0+c3HY5fp4+O0ySRIhN68w5HNg/BvFL/YcSR8556LK6oA8m6dwvrjT7M3fdUXJ4d3u8qULfeSYo5ezWkseByd6zQ97OJQWHS+luogTSe3DGvveXy84r68qQMUzeegXukZ98AKfPhs1Te1XWj2JLFFX1Ma4mUcnezha12qe/scVNtnhozuookv01e6lw+HPLSCN7yg8g0ooj9IGHOoGROHtUl83c85tlg/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(91956017)(122000001)(54906003)(8936002)(66946007)(38100700002)(2616005)(36756003)(83380400001)(38070700005)(76116006)(86362001)(7416002)(6916009)(6506007)(66556008)(6512007)(26005)(66476007)(64756008)(33656002)(2906002)(6486002)(4326008)(71200400001)(66446008)(53546011)(5660300002)(316002)(508600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2hRWlJzaFo3ZVlIaWRabUlOUkVYL2Nqbm1KVU1kdVVrYTdtNWRTMXVWUGtM?=
 =?utf-8?B?bHpjZnJKdXNzZ0RGYnFLT0t0ZHlsMUlTS1pVa21zOWlvOVd1bEM2ckVqU2Jv?=
 =?utf-8?B?dWI4M09EQVJPSEZBR2NySkZScWxZSjVtYnNBa2NTZXNPbnlkOG9SZUN2SFRC?=
 =?utf-8?B?SmtkZ3BzUEhvbk1wRTVlTzBwRDJrS2JjbGFhaE1JUnVjV1hQdFdyZ2N0WkRB?=
 =?utf-8?B?ckc4dUQ1NHYrbjZjMWVuZHEwcm1YRXJ4TmsyRjZqR2J1QVo2MU1RNncyN3BO?=
 =?utf-8?B?aWg5STZqMUdkT29idHYzYmlraVJRQi9ZTG5Gbjdwd0dnVjJZWVpEWDZhODNP?=
 =?utf-8?B?SVBMNHV2SkRlbGVTZE1reHZiSU85MkllaXU0SHR3Rk9ucWVrSUhQMUNudkEz?=
 =?utf-8?B?M01tZGdCejZFUW9EeU5pL01pTllpZ2FYTFRNd0hTNWZjVy8vaTRwT1ZWTmhP?=
 =?utf-8?B?enprak1zcTRtT3Z1NUVldFJoMmw4R09PNkhuZFNyd2gwZnYwZFNEYjU4Z3Bu?=
 =?utf-8?B?UjJZMWo3Z3JzcFRQRzdYYWg1cU5RUWxVU2ZuWnNZOE51dmFUaVdWTjJmbnBy?=
 =?utf-8?B?MDh2YWpUUDgyM3dVd01SaCtqNlluNEUvZzNjRytqVEdvb3VDeEM3dlBINDNL?=
 =?utf-8?B?NTgzNExHbXRmbWtXM0dVQjBvNjZIQklkQzB0YnNzdnVWanVKcEtHbFNScVpN?=
 =?utf-8?B?cnFiSm91QS9MN3BLRjFDbFZkM2o3K1IyYjJxakpBcUMrWXhSSk5HL3ZBaFdj?=
 =?utf-8?B?cXUwenYzanZOOWMwbjdUOSs0TGc1VVdDR1ZCbG9GTDY5R1Q3RlRlSm1yOGV4?=
 =?utf-8?B?VWRFUDlSSUlDcXNyYzNaTzdibFB4VktXMVUrNGN1bzdVZ1FaZGdydTYxNmNy?=
 =?utf-8?B?eDJwY2doVlFyOVBFdGNaMVYrL3FIc3B5ekkzZ0FLc3JQbHpOZWxGaGpoQkN1?=
 =?utf-8?B?NTZvRC9VTFBGa1B2b3daeVh1TFlhc1VMRzVSUzhBbG1QQzZuWThkNm9BbVhB?=
 =?utf-8?B?WTlqdEJ5ck5rR0Z1cVpyeW1wL3RvN2FRNmhmaitwclY4cmwycjhuUU9jZHZI?=
 =?utf-8?B?ODBHUUhYTU5vRkp0TmM5UWNZeHlWNDN1dUhQd1RoN1REamJqeENlWjVRYjha?=
 =?utf-8?B?VmF1S3dBWWo3clZPRXZJTjZtNVNkYnYvR0gzY1lIRVJYOEtxbmhYZ3QxUGk4?=
 =?utf-8?B?ZTdpT0RsVHU0am8wU2pXMk12ajBEcDVIdEhUbkkxZWZpQ2gvK2o2eDhHUUxr?=
 =?utf-8?B?SGRyR1VKWlhxZFRpNU1ZM0JNTzJwZTFmK2Y3a3daZ1JZVy9DYktyQlhTR0pE?=
 =?utf-8?B?UDVwMWFKZ3lMbHJDMVNHWjhLcFVtTEhwNUgxcmVpYnlXQUFNWUYrYjdQMWw5?=
 =?utf-8?B?NFBGSHNHUlpEeUJOUXZLUExaZjllOFlaclBPYjlLaUlJMm5QRkZOUC9sRWdv?=
 =?utf-8?B?QytIVmdVQkRIUGNlNlhxayt6SHcyTWN6RWVNbTRlSy95dXNsdExiQ0pjUzRz?=
 =?utf-8?B?TUVVaHMwTVc1ZU1zN0VaVzYrVlpjaUllRXROVmhhMmJidHM0a2c4aFRVdkRZ?=
 =?utf-8?B?QXluYjF2aUFZUTVNckczQzJ3SHB2dGU3YUZTRldkdFNqTXpNeElOM0RZT1Qr?=
 =?utf-8?B?OHFWSjY2VHNiL0VZcmdGQkNOWmVieTB0N0k5MVE1QisrbjZGZ3p2Z0tOMnRi?=
 =?utf-8?B?a2p1VUhXKzZHUlJkUTNpdTFhdm5vQUkrcnRXNUpPS21qMitZT3pLSENIQVhQ?=
 =?utf-8?B?NkMzTFhRdjdaNGhEQjN2WE90dFhCdU85N0tuekVxdXNxbis4dTB2blIrRE01?=
 =?utf-8?B?UGQ4U2pmNnZ6MTc4VTBkdGxFd3ZORzhyclBLMlBZck8rdkpEVnZwdXlvcDJt?=
 =?utf-8?B?MHZaOXlvdVhnUG93Z2x2dGtPTXhDZ1UweDZDeWhuUGk2K0RCNXhZdVR1cWpu?=
 =?utf-8?B?UkVpK0xBSWVHN1Vydll4VEY1N2ZiWkczSnJ5RkhzMDhvYlV4bjJwdEJpaUdt?=
 =?utf-8?B?RlhMY29vM29lZDltUFg1WkRGdmp5MmhvUHByVHdVN1ZoMEZWdVRkMDhLOHd5?=
 =?utf-8?B?Z3E5VDVQZmQ5MGR5bFFJZHVPMUN2cG5yeEJnTlhqRWFrQjhMNWFWVmhrRzlG?=
 =?utf-8?B?bkZGYnI0UHgwTSs2b1dQcFRwLytJU1NsT1BnZXpOY3FrbzN2ZGp2dDYyQURT?=
 =?utf-8?Q?hLqkQ2wDd5PYX6lNtc9LOLY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E78C132FD583541A4A5365E8C1AE3D2@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc30c766-2196-4e38-130c-08d9baf6524b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 09:28:55.4383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JlmS6Lbg58SihWKb/dt410IuXOOsBUboRDH7j5L79JBFqwbZ0MrkoT8VtKUy5FLTW7NEnQeX53AFcPOR3N/QXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB8233
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gRGVjIDksIDIwMjEsIGF0IDEyOjQ2IEFNLCBNaWNoYWwgSG9ja28gPG1ob2Nrb0Bz
dXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUgMDktMTItMjEgMDI6MTY6MTcsIEFsZXhleSBN
YWtoYWxvdiB3cm90ZToNCj4+IFRoaXMgcGF0Y2ggY2FsbHMgYWxsb2NfcGVyY3B1KCkgZnJvbSBz
ZXR1cF9hcmNoKCkgd2hpbGUgcGVyY3B1DQo+PiBhbGxvY2F0b3IgaXMgbm90IHlldCBpbml0aWFs
aXplZCAoYmVmb3JlIHNldHVwX3Blcl9jcHVfYXJlYXMoKSkuDQo+IA0KPiBZZWFoLCBJIGhhdmVu
J3QgcmVhbGl6ZWQgdGhlIHBjcCBpcyBub3QgYXZhaWxhYmxlLiBJIHdhcyBub3QgcmVhbGx5IHN1
cmUNCj4gYWJvdXQgdGhhdC4gQ291bGQgeW91IHRyeSB3aXRoIHRoZSBhbGxvY19wZXJjcHUgZHJv
cHBlZD8NCj4gDQo+IFRoYW5rcyBmb3IgdGVzdGluZyENCj4gLS0gDQo+IE1pY2hhbCBIb2Nrbw0K
PiBTVVNFIExhYnMNCg0KSXQgYm9vdHMgbm93LiBkbWVzZyBoYXMgdGhlc2UgbmV3IG1lc3NhZ2Vz
Og0KDQpbICAgIDAuMDgxNzc3XSBOb2RlIDQgdW5pbml0aWFsaXplZCBieSB0aGUgcGxhdGZvcm0u
IFBsZWFzZSByZXBvcnQgd2l0aCBib290IGRtZXNnLg0KWyAgICAwLjA4MTc5MF0gSW5pdG1lbSBz
ZXR1cCBub2RlIDQgW21lbSAweDAwMDAwMDAwMDAwMDAwMDAtMHgwMDAwMDAwMDAwMDAwMDAwXQ0K
Li4uDQpbICAgIDAuMDg2NDQxXSBOb2RlIDEyNyB1bmluaXRpYWxpemVkIGJ5IHRoZSBwbGF0Zm9y
bS4gUGxlYXNlIHJlcG9ydCB3aXRoIGJvb3QgZG1lc2cuDQpbICAgIDAuMDg2NDU0XSBJbml0bWVt
IHNldHVwIG5vZGUgMTI3IFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAwMDAwMDAwMDAwMDAw
MF0NCg0KdkNQVS9ub2RlIGhvdCBhZGQgd29ya3MuDQpPbmxpbmluZyB3b3JrcyBhcyB3ZWxsLCBi
dXQgd2l0aCB3YXJuaW5nLiBJIGRvIG5vdCB0aGluayBpdCBpcyByZWxhdGVkIHRvIHRoZSBwYXRj
aDoNClsgICAzNi44Mzg4MzhdIENQVTQgaGFzIGJlZW4gaG90LWFkZGVkDQpbICAgMzYuODM4OTg3
XSBhY3BpX3Byb2Nlc3Nvcl9ob3RhZGRfaW5pdDoyMDUgY3B1IDQsIG5vZGUgNCwgb25saW5lIDAs
IG5kYXRhIDAwMDAwMDAwZTljN2Y3OWINClsgICA0OC40ODA0OThdIEJ1aWx0IDQgem9uZWxpc3Rz
LCBtb2JpbGl0eSBncm91cGluZyBvbi4gIFRvdGFsIHBhZ2VzOiA5NjE0NDANClsgICA0OC40ODA1
MDhdIFBvbGljeSB6b25lOiBOb3JtYWwNClsgICA0OC41MDgzMThdIHNtcGJvb3Q6IEJvb3Rpbmcg
Tm9kZSA0IFByb2Nlc3NvciA0IEFQSUMgMHg4DQpbICAgNDguNTA5MjU1XSBEaXNhYmxlZCBmYXN0
IHN0cmluZyBvcGVyYXRpb25zDQpbICAgNDguNTA5ODA3XSBzbXBib290OiBDUFUgNCBDb252ZXJ0
aW5nIHBoeXNpY2FsIDggdG8gbG9naWNhbCBwYWNrYWdlIDQNClsgICA0OC41MDk4MjVdIHNtcGJv
b3Q6IENQVSA0IENvbnZlcnRpbmcgcGh5c2ljYWwgMCB0byBsb2dpY2FsIGRpZSA0DQpbICAgNDgu
NTEwMDQwXSBXQVJOSU5HOiB3b3JrcXVldWUgY3B1bWFzazogb25saW5lIGludGVyc2VjdCA+IHBv
c3NpYmxlIGludGVyc2VjdA0KWyAgIDQ4LjUxMDMyNF0gdm13YXJlOiB2bXdhcmUtc3RlYWx0aW1l
OiBjcHUgNCwgcGEgM2U2NjcwMDANClsgICA0OC41MTEzMTFdIFdpbGwgb25saW5lIGFuZCBpbml0
IGhvdHBsdWdnZWQgQ1BVOiA0DQoNCkhvdCByZW1vdmUgZG9lcyBub3QgcXVpdGUgd29yay4gSXQg
bWlnaHQgYmUgaXNzdWUgaW4gQUNQSS9GaXJtd2FyZSBjb2RlIG9yIEh5cGVydmlzb3IuIERlYnVn
Z2luZ+KApg0KDQpEbyB5b3Ugd2FudCBtZSB0byBwZXJmb3JtIGFueSBzcGVjaWZpYyB0ZXN0cz8N
Cg0KUmVnYXJkcywNCuKAlEFsZXhleQ==
