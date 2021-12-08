Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E655E46CF8F
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhLHJBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 04:01:01 -0500
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:51675
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229933AbhLHJBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 04:01:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekWys6zjm6nyyNa9/ZhaPl4waw92sj6Kz2zNyHLFgSJhydPwjRnaOwCYRpmFa8lKfxOP4PUWTqjQ4X/XU7yxfUK1KHfDocX6TSvHE3z4oxOZ0bkFsf3bL7z3rwl48ycZsi1bVtp7yftCilYEkm85gcoNOR2NwNUvEWyjceUJESjMH9uLIdYPscliC9+Ecounqul/hQcmRJZijeHBZ1boCrwWgsXxZFlD4y7ShdhmbDZLHfwKJzxWE4Z/83/NBP5Wpp85WQ3zPh0tKx8MPTMWH7/9WfoIG4MKgl9AC2fyYFHeciCC9yxHJBIc4jSSaNzEP342jRuI1b5E6N4lUawLmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6X2nglACD6c8G1F0/0xEZ5hVl23D7je+3SUkMcavaQU=;
 b=Yy41cz/xICP+xmcExF3PHaxZcw/TkWu+GQkEDmd4aFZKjyF8axSRotRunycpmjsZcPLh5ds/iZVf+73gxRyiMtIbVeAohNsr/8xEuQ+5ehdpIwQLPDgESVjeG6+84qE3vFxT/DVjSsVH7mW2CFsGAjYg0COSIKMnUemtn4FzbRltJPJ0paZnn0Df9lfNde3nY9Jx5983augE1MsZYJ9nkcTBMiUr6qEhSd9NsL/GBwaI9yai6vxfABEVcNbkgxdZWTt2GMjrK+RFmgD9N0T7VxVpTUB3WD9dKKREvTYwauDLzALMR+yPDPSQxICyJLReuIPHyca5qB0scz8wObykWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X2nglACD6c8G1F0/0xEZ5hVl23D7je+3SUkMcavaQU=;
 b=Xkj6uqzxgEoNu6HCOG9+P0Ywl3cGyiZUBWbYGeA3mLU4kNA/qCfGIEo3sLCYwhBb7OEOKzWqUYcoWCTmkq2lbCUBowbP9htz1J9tBsCmCrY+uNt8noju+Si/jsSymxDjt/86c0NOzO7hGt2EJPNUcd3EfpQSxYWwBObP6LYL50o=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 08:57:28 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%3]) with mapi id 15.20.4778.012; Wed, 8 Dec 2021
 08:57:28 +0000
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
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAAA2QA=
Date:   Wed, 8 Dec 2021 08:57:28 +0000
Message-ID: <9DA4ABBB-264F-4AD7-A4D4-DCBD371BE051@vmware.com>
References: <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
In-Reply-To: <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e98e231f-faa4-4829-3a72-08d9ba28c2ff
x-ms-traffictypediagnostic: MWHPR05MB3648:EE_
x-microsoft-antispam-prvs: <MWHPR05MB36486ABA4DD33B15176FCA9DD56F9@MWHPR05MB3648.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o5SNiXhFYF0TIbkxHloebz2o8sk8Dz1soPqHWn2c6r6My1JKdl+mDhOmU0o17Mt3/Rh2NBamw/6XKROKAYgFlSKer3bOLvtezjpUzYrWISwXrT24MNrNr3dw/VVCDPg56Lm1s14erafCD1sjt4UV355/aXsh5br4z/f/xt5y75gVyiCxL7RpHEdpFe2f33wmqgFbObybEzIkYtEcQbhp7IGkGQSvxcwWYHyQreNTZsZBl4NxzriC9iXV5J+Fan/JxV/jIP8O4ls5w9+57kFjiKsQUIEfBxU7/QE6bBKcmbi2qNxluCISNk+Bnsqc0M5qtbFqjjaKHMh0URbG0bSaDfbKzgs+Xxd0RZm+Fq5Q50/+tMO2GumKS5OK4/351XUPERFBWY9yMJMKeJc1P8q3+/XqBraUp+uakcH6yO2K2a63TsUwXyOMc9MYz0FfiTJkVB42TGWmTujPpRmthElABFz7OAIZ20PRRaucGOHKe767ViqX0w7plp8T6TnGOkv+jSClb49ErUTsDo9FbgR9T//BpKJ6mg76BTmU4/90kJYTPKYavEPMUD7pMfMBav/Xx2GyRIrFdT4gdbcA5kQQ14ZrWd4uuIc9RIKVfz+22hRztdDEqLqZ5BNLN1ZPDbN7UMevK2IwXXPl+TtQiPyzVv9oodnJWlFDYzstymEFnInJEje8DkV6M7PWLDQNvNaSsPYyZVYay4h9aue5s0TBv/LfWULM0iwGX2uHd9RhQKBWAftnsZ6NHUedhlDaRfduDP0Xu3mX0dOGr1TMuRgPXTnigpRO/o7hKtJbOD0S3pQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6486002)(2616005)(33656002)(316002)(71200400001)(6512007)(54906003)(38070700005)(2906002)(7416002)(38100700002)(76116006)(91956017)(86362001)(5660300002)(8676002)(6916009)(186003)(122000001)(26005)(66946007)(83380400001)(4326008)(66556008)(66446008)(66476007)(64756008)(8936002)(36756003)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDhlZ05kTTFuL2tNV1greWtTYWhSZWlmeXdZblJxQ3h3LzVETTRET0hBMStl?=
 =?utf-8?B?QksvTEVaQ2NyUitTTmF1VEdKUXNLeHcrbUZmUlJwbDAxaFhLejhFWXdNYTE5?=
 =?utf-8?B?cVZGTWdEVzc4RjhrY1Y2Z1ZFZFB3SXhyeDROY1kreGFjTFYrYmh0WWpDTVpv?=
 =?utf-8?B?NFoxNnJLSHhGRG5xcUVwN1NGc2RTWlR6MHpidWNKWnY3MU12K29iQ0dLbi9S?=
 =?utf-8?B?MHFPa1FKU3YxRGJQOUlRdWdZUUpjK2ZEazZNMFd5ZjBMWHVjSXZCTFJUS3Mw?=
 =?utf-8?B?NlU2Vmw4NkZNM3NtRDBlMENkL2c2WEJ2V1VLazVPUlFHMTFETktQMitWZmxH?=
 =?utf-8?B?ZitqQVdPMVBRVHNyMjNxbEtlWUo2YnFhdVQxRHRwTDF2NUlTN2xvaEhPOVBE?=
 =?utf-8?B?blJoaTU5Q29zZ2pRdVpNNkZOOW9VUFJWdUpKR2JEblZmSkxDOUtaeHpRVWJR?=
 =?utf-8?B?amx3SndnZkhRdi9Kdm1Fd2VxOFljT3l4ZkNpeWdLRHRGa1A3cE5sSVRyaFcy?=
 =?utf-8?B?MzRXUHFZZFBzMklRZlczYjFtd1BraXlTalMvYUtkQjBGL2l6RzhHWnRaT2hi?=
 =?utf-8?B?SHdkSjFKWVozR0daZC9QTzduSkxNZ2Ixa1kyTkdkRW0zem9WWC9IcDFYeGVu?=
 =?utf-8?B?dDg5SlVDcEFUZkJGbmw4S2dDcVAvQVB5bkJTRldFVmFwSUIveVFEVWhoN0NT?=
 =?utf-8?B?NE9IczhvUGtNZ0sxazV5bTloZy80aVFPQTF3VW9ybG1FM29rc0E3ZTVNK3Jm?=
 =?utf-8?B?cTdnQ2R1bmVsaGtqQXVtSjJKcEJsZTdPQlduZXZXZERtOGJ5elRQRys1d005?=
 =?utf-8?B?bXZLOEpkelJXd1Z6SmJuaC85MlVXSzdFRFRlRWtnTkJzdURXQVpydVhERDBS?=
 =?utf-8?B?eXZrbXpjRmxrMzRyOTdXN2l3Mmx0cVRaOVNnVnUyOVhzcU9sOEtVVDNjL2F0?=
 =?utf-8?B?R1paOGlxM3V5ZEU0akNERFJEU0Q0Sm05ZmQzVEI4cHMzMkNsRU9IVW5BMElL?=
 =?utf-8?B?c1BjblNMdU5kYUFkU2lzdUVVc2ZwbkdMR0tWd1FmUlBpUDZmTWV0SmdobGNB?=
 =?utf-8?B?d0lLejdZUHNjQ2FOZHVNZ3QrOCtKR05wcDQwMXUwcklmaHRsOWNBNUxrdHZh?=
 =?utf-8?B?TDZDOG05Q24weTVLZjJrTG1wTUhyTktUd1RlQjRrNWJTYS9ocjJqK1FtelhE?=
 =?utf-8?B?LzNIcFQzbFpRT2c4Y3IrWjRvbGt5MzlLRysrK1NkNEh0OEs1QTFoeCtCbm1S?=
 =?utf-8?B?UHBoNjljU28zMmVPbVNKTnNjTk5aWlBBT2ZrQWZMSDZERkV1YjdWR2o0RFFy?=
 =?utf-8?B?OCtqN05OYS9GVEhrZGRFS09ZV0R0NnJZeG9JQ0JyRnlGakNsM3NUdkY4QXFO?=
 =?utf-8?B?ZGdNR0pidXZKbW91MUV1VTJGMDZzU3MyaUpKYUY2a2h1d2hFWS80OGNKZ0oz?=
 =?utf-8?B?MEkwSUJodGFQOVZzTVZsTG44N1RHT3lWbVlNWldOcjFlUm5tMVNQc0FGU1Ix?=
 =?utf-8?B?bkZjTjlCa3ZUQWlHalkrbnQvZkkrUU11TGN3TkwyN21FTk5xcVJNWnlySEtX?=
 =?utf-8?B?RzB4ZVExaGFXT1RkbkpoRS85R3pZVUlVZ3psUkpKNVhMMGlLMFBmVlVWRnkv?=
 =?utf-8?B?YmJ5d3lrcDlIaEF0SGpubzRtQjFFZlFSZS9XOGxUNE9BZmZBWU4vSlVnOHFO?=
 =?utf-8?B?WHpOci84d1Z2bjJIdDI1cm5DbUhDMnBuQXMvcVl2YjhHRGhmcGljbWFQbGIw?=
 =?utf-8?B?UHRMcHBIRVNkQmNyWTBMMStQTTluMVEycDQwRWhTVEhtRGoxcXY0N1lTaXJE?=
 =?utf-8?B?Zk5IaWV4ZzZLZ3JXNVNhVnZlQTlZdjMxSFFpeGVzWUtNVW9rWU4xMnlMeTM2?=
 =?utf-8?B?UDVtcEl5UkNJUTI4SjA3YlpLZCtqSGw2ZmZVamVvMXV6QWt3WU9pWXVHditY?=
 =?utf-8?B?dmF4RVdXVUdBL29zRml5NmNocjROeit3ck5vb1NvbjI2WXN2dGoxclpuclY3?=
 =?utf-8?B?QVRzTkZYRVByajJET1pXdmNlZWlMUUF4bWVhNkRBNS8vL1N4TUhLL1BOMkNu?=
 =?utf-8?B?dGNVdDIxcXNWMFJ6NjdjTlZiMmhxSHlBaWNVcmg4L3Q0c3pNMnlBNkF0K3VK?=
 =?utf-8?B?Z2NaVGc4M1krYUZhQTBRRzlZOVV2OVFqR0JJTnZKTnozcGM3dlgvdUt2YVE3?=
 =?utf-8?Q?dCgN2I5ozc+EaKT/+2P4PrE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C17D811E0111A743B7F07B56954DC8A2@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98e231f-faa4-4829-3a72-08d9ba28c2ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 08:57:28.1350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nz0g2hR7hezSzkTn299bVYT9ah0Qcrf09/e+nGFS1Fp4LQnd9ExLfL0G5B+FtllmeSUOkVUWwCWH4+GhNTbnbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3648
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gRGVjIDgsIDIwMjEsIGF0IDEyOjU0IEFNLCBNaWNoYWwgSG9ja28gPG1ob2Nrb0Bz
dXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBBbGV4ZXksDQo+IHRoaXMgaXMgc3RpbGwgbm90IGZpbmFs
aXplZCBidXQgaXQgd291bGQgcmVhbGx5IGhlbHAgaWYgeW91IGNvdWxkIGdpdmUNCj4gaXQgYSBz
cGluIG9uIHlvdXIgc2V0dXAuIEkgc3RpbGwgaGF2ZSB0byB0aGluayBhYm91dCBob3cgdG8gdHJh
bnNpdGlvbg0KPiBmcm9tIGEgbWVtb3J5bGVzcyBub2RlIHRvIHN0YW5kYXJkIG5vZGUgKGluIGhv
dHBsdWcgY29kZSkuIEFsc28gdGhlcmUNCj4gbWlnaHQgYmUgb3RoZXIgc3VycHJpc2VzIG9uIHRo
ZSB3YXkuDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbW0vcGFnZV9hbGxvYy5jIGIvbW0vcGFnZV9hbGxv
Yy5jDQo+IGluZGV4IGM1OTUyNzQ5YWQ0MC4uOGVkOGRiMmNjYjEzIDEwMDY0NA0KPiAtLS0gYS9t
bS9wYWdlX2FsbG9jLmMNCj4gKysrIGIvbW0vcGFnZV9hbGxvYy5jDQo+IEBAIC02MzgyLDcgKzYz
ODIsMTEgQEAgc3RhdGljIHZvaWQgX19idWlsZF9hbGxfem9uZWxpc3RzKHZvaWQgKmRhdGEpDQo+
IAlpZiAoc2VsZiAmJiAhbm9kZV9vbmxpbmUoc2VsZi0+bm9kZV9pZCkpIHsNCj4gCQlidWlsZF96
b25lbGlzdHMoc2VsZik7DQo+IAl9IGVsc2Ugew0KPiAtCQlmb3JfZWFjaF9vbmxpbmVfbm9kZShu
aWQpIHsNCj4gKwkJLyoNCj4gKwkJICogQWxsIHBvc3NpYmxlIG5vZGVzIGhhdmUgcGdkYXQgcHJl
YWxsb2NhdGVkDQo+ICsJCSAqIGZyZWVfYXJlYV9pbml0DQo+ICsJCSAqLw0KPiArCQlmb3JfZWFj
aF9ub2RlKG5pZCkgew0KPiAJCQlwZ19kYXRhX3QgKnBnZGF0ID0gTk9ERV9EQVRBKG5pZCk7DQo+
IA0KPiAJCQlidWlsZF96b25lbGlzdHMocGdkYXQpOw0KPiBAQCAtODAzMiw4ICs4MDM2LDMyIEBA
IHZvaWQgX19pbml0IGZyZWVfYXJlYV9pbml0KHVuc2lnbmVkIGxvbmcgKm1heF96b25lX3BmbikN
Cj4gCS8qIEluaXRpYWxpc2UgZXZlcnkgbm9kZSAqLw0KPiAJbW1pbml0X3ZlcmlmeV9wYWdlZmxh
Z3NfbGF5b3V0KCk7DQo+IAlzZXR1cF9ucl9ub2RlX2lkcygpOw0KPiAtCWZvcl9lYWNoX29ubGlu
ZV9ub2RlKG5pZCkgew0KPiAtCQlwZ19kYXRhX3QgKnBnZGF0ID0gTk9ERV9EQVRBKG5pZCk7DQo+
ICsJZm9yX2VhY2hfbm9kZShuaWQpIHsNCj4gKwkJcGdfZGF0YV90ICpwZ2RhdDsNCj4gKw0KPiAr
CQlpZiAoIW5vZGVfb25saW5lKG5pZCkpIHsNCj4gKwkJCXByX3dhcm4oIk5vZGUgJWQgdW5pbml0
aWFsaXplZCBieSB0aGUgcGxhdGZvcm0uIFBsZWFzZSByZXBvcnQgd2l0aCBib290IGRtZXNnLlxu
IiwgbmlkKTsNCj4gKw0KPiArCQkJLyogQWxsb2NhdG9yIG5vdCBpbml0aWFsaXplZCB5ZXQgKi8N
Cj4gKwkJCXBnZGF0ID0gbWVtYmxvY2tfYWxsb2Moc2l6ZW9mKCpwZ2RhdCksIFNNUF9DQUNIRV9C
WVRFUyk7DQo+ICsJCQlpZiAoIXBnZGF0KSB7DQo+ICsJCQkJcHJfZXJyKCJDYW5ub3QgYWxsb2Nh
dGUgJXp1QiBmb3Igbm9kZSAlZC5cbiIsDQo+ICsJCQkJCQlzaXplb2YoKnBnZGF0KSwgbmlkKTsN
Cj4gKwkJCQljb250aW51ZTsNCj4gKwkJCX0NCj4gKwkJCS8qIFRPRE8gZG8gd2UgbmVlZCB0aGlz
IGZvciBtZW1vcnlsZXNzIG5vZGVzICovDQo+ICsJCQlwZ2RhdC0+cGVyX2NwdV9ub2Rlc3RhdHMg
PSBhbGxvY19wZXJjcHUoc3RydWN0IHBlcl9jcHVfbm9kZXN0YXQpOw0KPiArCQkJYXJjaF9yZWZy
ZXNoX25vZGVkYXRhKG5pZCwgcGdkYXQpOw0KPiArCQkJZnJlZV9hcmVhX2luaXRfbWVtb3J5bGVz
c19ub2RlKG5pZCk7DQo+ICsJCQkvKg0KPiArCQkJICogbm90IG1hcmtpbmcgdGhpcyBub2RlIG9u
bGluZSBiZWNhdXNlIHdlIGRvIG5vdCB3YW50IHRvDQo+ICsJCQkgKiBjb25mdXNlIHVzZXJzcGFj
ZSBieSBzeXNmcyBmaWxlcy9kaXJlY3RvcmllcyBmb3Igbm9kZQ0KPiArCQkJICogd2l0aG91dCBh
bnkgbWVtb3J5IGF0dGFjaGVkIHRvIGl0IChzZWUgdG9wb2xvZ3lfaW5pdCkNCj4gKwkJCSAqLw0K
PiArCQkJY29udGludWU7DQo+ICsJCX0NCj4gKw0KPiArCQlwZ2RhdCA9IE5PREVfREFUQShuaWQp
Ow0KPiAJCWZyZWVfYXJlYV9pbml0X25vZGUobmlkKTsNCj4gDQo+IAkJLyogQW55IG1lbW9yeSBv
biB0aGF0IG5vZGUgKi8NCj4gDQoNClN1cmUgTWljaGFsLCBJ4oCZbGwgZ2l2ZSBpdCBhIHNwaW4u
DQoNClRoYW5rcyBmb3IgYXR0ZW50aW9uIHRvIHRoaXMgdG9waWMuDQoNClJlZ2FyZGluZyBtZW1v
cnkgd2FzdGUuIA0KSGVyZSB3aGF0IEkgZm91bmQgd2hpbGUgd2FzIHVzaW5nIFZNIDEyOCBwb3Nz
aWJsZSBOVU1BIG5vZGVzLg0KTXkgTGludXggYnVpbGQgb24gVk0gd2l0aCBvbmx5IG9uZSBudW1h
IG5vZGUgY2FuIGJlIGJvb3RlZCBvbiAxOTJNYiBSQU0sDQpCdXQgb24gMTI4IG5vZGVzIGl0IHJl
cXVpcmVzIDFHQiBSQU0ganVzdCB0byBib290LiBJdCBpcyBzZXJ2ZXIgZGlzdHJvLA0KbWluaW1h
bCBzZXQgb2Ygc3lzdGVtZCBzZXJ2aWNlcywgbm8gVUkuDQoNCm1lbWluZm8gc2hvd3M6DQoxIG5v
ZGUgY2FzZTogUGVyY3B1OiAgICAgICAgICAgIDUzNzYwIGtCDQoxMjggbm9kZXM6ICAgUGVyY3B1
OiAgICAgICAgICAgNzE4MDQ4IGtCICEhIQ0KDQpJbml0aWFsIGFuYWxpc3lzIG11bHRpbm9kZSBt
ZW1vcnkgY29uc3VtcHRpb24gc2hvd2VkIGF0IGxlYXN0IGRpZmZlcmVuY2UgaW4gdGhpczoNCg0K
RXZlcnkgbWVtY2dyb3VwIGFsbG9jYXRlcyBtZW1fY2dyb3VwX3Blcl9ub2RlIGluZm8gZm9yIGFs
bCBwb3NzaWJsZSBub2RlLg0KRWFjaCBtZW1fY2dyb3VwX3Blcl9ub2RlIGhhcyBwZXIgY3B1IHN0
YXRzLg0KVGhhdCBtZWFucywgZWFjaCBtZW0gY2dyb3VwIGFsbG9jYXRlcyAxMjgqKHNpemVvZiBz
dHJ1Y3QgbWVtX2Nncm91cF9wZXJfbm9kZSkgKyAxNjM4NCooc2l6ZW9mIHN0cnVjdCBscnV2ZWNf
c3RhdHNfcGVyY3B1KQ0KDQpTZWU6IG1lbV9jZ3JvdXBfYWxsb2MoKSAtPiBhbGxvY19tZW1fY2dy
b3VwX3Blcl9ub2RlX2luZm8oKQ0KDQpUaGVyZSBpcyBhbHNvIG9sZCBjb21tZW50IGFib3V0IGl0
IGluIGFsbG9jX21lbV9jZ3JvdXBfcGVyX25vZGVfaW5mbygpDQogICAgICAgIC8qDQogICAgICAg
ICAqIFRoaXMgcm91dGluZSBpcyBjYWxsZWQgYWdhaW5zdCBwb3NzaWJsZSBub2Rlcy4NCiAgICAg
ICAgICogQnV0IGl0J3MgQlVHIHRvIGNhbGwga21hbGxvYygpIGFnYWluc3Qgb2ZmbGluZSBub2Rl
Lg0KICAgICAgICAgKg0KICAgICAgICAgKiBUT0RPOiB0aGlzIHJvdXRpbmUgY2FuIHdhc3RlIG11
Y2ggbWVtb3J5IGZvciBub2RlcyB3aGljaCB3aWxsDQogICAgICAgICAqICAgICAgIG5ldmVyIGJl
IG9ubGluZWQuIEl0J3MgYmV0dGVyIHRvIHVzZSBtZW1vcnkgaG90cGx1ZyBjYWxsYmFjaw0KICAg
ICAgICAgKiAgICAgICBmdW5jdGlvbi4NCiAgICAgICAgICovDQoNClJlZ2FyZHMsDQrigJRBbGV4
ZXkNCg0K
