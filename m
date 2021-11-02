Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98258442BB3
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 11:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhKBKgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 06:36:49 -0400
Received: from mail-sn1anam02on2051.outbound.protection.outlook.com ([40.107.96.51]:59646
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229720AbhKBKgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 06:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zs4hJvGbu8qvo2D1MBd0DJpZwAWSJmtSyHpW4RkaYoFBSdrOwz7E5FO0QshqBo4kRbZNoMeP4vZAdm0+bxwXcdPkvaQWMhV9ZierzgN5vNn74WJJvAtbOCIndoXAlom96Lqhd78f1SwDJcuvDPQuJa+xT7YF63L5f/hQv4kBN0asglpD3576/ViANuQwQX6b7G85vij713EhqG4mUtXnvhVdPNilFI142nq3ZIssQbikbbBay+tcfGm6UlJdqjnfK9y9vxgOrk8jFz+qIoHl1pdYC7n02VV9AJuplZga2vUSAusoDlQmi4387wvw5pZek9N0fnCUo0jghW/+Qt/hDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/BghD/Nk+NS2tf/SVcEd+Of1XczGwfRGg+7dDUe+hI=;
 b=MQ4P169c2z1Th8Zz431rMaDlFoZZYGe4prRYV7F8GXjZtdYjI8Fu3a7wOXWSnYKkpQnlI+UG7Jy2AYTYPRr1FLM1RlU69UMJHhxU64DzQ27VAy8EdxE5vbT688By0d9/ui+3XBctz9ZtHzPLwsootgatrt2a5OGb7/fDJ6inznF2nAqcLly29Ii9GFaSoWDNMDj3SxDe9X/U3pvYlFS12rirvusgUfj6dvi6bDHa9yZArDEFyOpPhtFLxVIfq5p3+Dm8zAd+ZPrsrUkgHbeA2aoHejnWLz/pCqA7iuL8A84cn3n/Y2D/G6a8ekqhN/3wTtNURscYaFOFuYHgYcmyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/BghD/Nk+NS2tf/SVcEd+Of1XczGwfRGg+7dDUe+hI=;
 b=zjNHWMexfxHWDq8biaKR/DmyzBvFkVmZy1jz7RvUZ/6fYrzlf0ch31+Dqrz+NZvxR8i4e2x9M+F2gznOXG2EKcgLzxbkxXu9kzBP1GniwB1MpyjUIO9cICFpriKXcA7RpDeKnF4GkFLWvPEV+yj6Ts3Mtjh33Z6fSkShKQFmT3A=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MW4PR05MB7826.namprd05.prod.outlook.com (2603:10b6:303:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4; Tue, 2 Nov
 2021 10:34:10 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 10:34:10 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     David Hildenbrand <david@redhat.com>
CC:     Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH] mm: fix panic in __alloc_pages
Thread-Index: AQHXz1zvSxS/i+mFgUadpM+6bJvGtavv3QcAgAAG4YD//5TPAIAAec8AgAAFsICAABNmgA==
Date:   Tue, 2 Nov 2021 10:34:10 +0000
Message-ID: <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
In-Reply-To: <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96d8f6a7-d770-41eb-0375-08d99dec4e60
x-ms-traffictypediagnostic: MW4PR05MB7826:
x-microsoft-antispam-prvs: <MW4PR05MB782692F63C47F6AEF7FBA8B0D58B9@MW4PR05MB7826.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: acUE4RTrITU24Vw3lf2Og5v5ZaMwLQv9QwU1xfNQxL6sr3kWjGSnQpmdp6do6TM4TJRy7aUqc8MnIAkjltWXzHPLY8YhZiB49ZYBrhlbmlhr0tmlD6RX9gkJ2N76UyMBLmWFf02TdQTFXsDNx5wzvCu7L6hdaXLRyshYT7CJ2HBfUurbRf4Pv78NKU4+o/d8c0++Ywiz+eFd2YNmvkOQpGDSWWfOL9KA3aM26AyNlMFOD8Tz47qBhxGwZKbf6emcZcaz9TCT8z5lKSqy6mR9fHrf8e7xCXxdlNkc4vPvQtW05hXlWSckVfbBpLMFmDx5UgWtaGEfVLs8D7j9vCB/x6OPMHl8ef+TgwGy1BPcPjH4TcPiEfadosMbHRjJ4pcipc1DZGq7Wu93Z1dbt521JbG7RWiLYmrMWeEhYxf//pMCW9wYHAruBXEc5SKDyT+FmTmli0+AOzskS6rp4PoWZ+8Jg8JnOQhdfy3ig0DjIzMIZBqqwmxysuHKQHujbVQUihZTjlQjCK1RBqqQ83rCCnMLeVNanMOiAj4NcDhTevBo4PVYvV1/ubUpsANPkVzvNCtQjYxNbJ6nYTH7rnm4Khqg6BqUqTMIwO7ActcjLYkV16bTSkQO2QyRpjlXf8ASSj35PW7EfvOjCQoD8rcU6vgWnFkgexhZTqLxIxAWUJjdD0saetjQE6HLDZzv3dmxmTHDXCi2wgunasTCoZpNd0zKoMAQamlgTxEeiBDB++w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(36756003)(66476007)(38100700002)(2616005)(122000001)(33656002)(66946007)(26005)(76116006)(66556008)(6512007)(66446008)(83380400001)(91956017)(2906002)(186003)(71200400001)(6506007)(4326008)(38070700005)(6916009)(316002)(8676002)(8936002)(5660300002)(6486002)(54906003)(508600001)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnFrV0VKTTFWNFcraDV1MlQ2b0ZZRTJhNkhEK3E1WG01RHFweVlHVlMxOWxE?=
 =?utf-8?B?NDFQL090N0VXNkZsM0hZNGhTVEVmQVdsTTI2cUJudXE1N1EyWFJUWEtpamMw?=
 =?utf-8?B?bzhLZm8yRFlvSTRReW52b1RZd2c0aEFuRUhycFJoVXVpNms1bWhOQzU3c3Zm?=
 =?utf-8?B?bzIwSFFlMFBpdDhrSmNjK3N0SlpidXhqUmV2SlNpK3NBbnpEa3dwWjhBT25s?=
 =?utf-8?B?Ui90ZGpWb1BEWUUxNElLQUhQU3AzK3ZscmJFWGlHeWVHTzBMaFhzOUQwOExk?=
 =?utf-8?B?dVdSVy82SjlyVTQ1ay9oSHJBaXoxYmMzSVArUm1QNmEraXE2MlYxLzhSODBT?=
 =?utf-8?B?akVRQTdEUWtYWWE4WEIyY2FxWjZUdFEweDlEd0hGcVJTNDdkRXBkeXdsdUtX?=
 =?utf-8?B?TERvMVBNVm5ZdklCR1JmTjAyZ2NxWGF4QlRGVmF5aXhKcnpweFF1dG50UC9p?=
 =?utf-8?B?Z01FVmFXd1c4TTRlQStnTEpUbjdLOUsrOFJPOWdrUytNbGVkNm13K2hyTFI5?=
 =?utf-8?B?TnBEc2JaLzNWbDZodzZaRlVRMzNkQzBONi9ENzVocWNxVjJQNzdFSGs4a292?=
 =?utf-8?B?M1ExY2xKdGo3UFlOSHpPS0x5VytTTGR3L2RnaEUvNHpzbVFPN3Q3SVc1UUtk?=
 =?utf-8?B?YW12ZFB1c3VwWlFHYU9DeHNsRDBCTWZ5UzdzQithbnRhV0dVb3B2THRSNTNw?=
 =?utf-8?B?aUVtVk0wNWlNd1VMamtlUDV4VXBLbThYK05ZUkkzTzlaeSt3TnhBTDVzRGJj?=
 =?utf-8?B?N3JLSytnMWdnd0xic1pWbnlHSVg5NldLUG1TVlZMLzF2UVloWlNZMW9FZGNF?=
 =?utf-8?B?QmhoOGhidGRzeWk0ajZyTDBOV3BxQ0IyVmN6cGJzTDIvQWZKOFJoZ2luelFs?=
 =?utf-8?B?a1JlR1VQOFBFUlUyTDJvMHRPRkdnbmkwbFEySmZ0K3d6YVdmWm9CWHhTSnd3?=
 =?utf-8?B?M0tkcVlJcUVNZHE4L0JMOEpESC9sNnY2OGIzOSsrYlcyY1p2a2NXS3BNNG0y?=
 =?utf-8?B?Zi8reTcxMnM1Y09zVmovRWl5UGhGYmRoMGduQXowcDg0S0xBcklUV3BLR0hi?=
 =?utf-8?B?MkhYQnNFZTV1dUt4UzlJOUdNTmFIZ3JhZlJwREJYay9qbnh2SzcxWVpRbENS?=
 =?utf-8?B?aW5BSE1YUkZxUUtGSXRoTFAwUURoR2pqZmREZTM4RHA1VzQrYjZNUW9iSUxm?=
 =?utf-8?B?Yk1seDkzMWh1RUJ6Qzdmcjk3RGFHMFRLRExXZFlRaWdkWnpaUCtpVVQzVFNk?=
 =?utf-8?B?d3N4S2ROTWc1d1g2c2dsVzFPV2w2MEI1TEVkeTVvK0Z3SnhpMTVQeWpmZ3dt?=
 =?utf-8?B?VG5DZlQxRVBUNHFqQ3hlQk4yaHZmb3lUN1V3N3NhV0VLd01DZkVxVkd0b3ZU?=
 =?utf-8?B?WDAzbllUTmxEQ3ExWU9ZM3h2SWZ3Y2t4VFVpZHRLZnhWSmFPWFhzZkhoNlox?=
 =?utf-8?B?RVNOcVI1ZWRObkVZOXFFRHdTUWY1azZpc0xOYk1RcDBMcWNyUWdDMHBKZ28w?=
 =?utf-8?B?OGRFMURhamVITk1Ta21FeGlMTjRXMHY2VU9pbGtsb2VvVEQ3NnBhQ2VZbmgw?=
 =?utf-8?B?THpnRXArWlRZdWs1Q1hQZU00dlp4MlIvM1lsaFlIUG1BcjlnczBHSTNSWklY?=
 =?utf-8?B?MUhyaUEwS2VtWjRDMHlBaWxheVJ4Ykd6YlBZVWVGM2V3T1F2UFZYTnFzaUUz?=
 =?utf-8?B?SWVRMURMdVFIMGt2RVpGa3d6bkszZGM3TTdJTm03RmE1Rm5MR2lscm16ajYy?=
 =?utf-8?B?bFR4TEVkaDNZMFU4cENGN1hxVGZPUlUrTmZCeWorakVTd3NPNDY4bzY0dmNp?=
 =?utf-8?B?NEI0eGFteEJqTmZxUTF5WVRZdGJDa0JRcWtzaXRPRjhZd2lKOU1OWUUreHI3?=
 =?utf-8?B?c01UdmZRdXlLdy9yKzJVRlZKVHRYSFZTelBySEhJdW03MnFPQWs2WkpIZG9m?=
 =?utf-8?B?dkN3dDBlRmIvTzJJK0NGeStON0VoSGN2WCtFRE9ZZXJ2K0pQZFFHVkt1SG56?=
 =?utf-8?B?Ky9MV2ZyYXQwWTgxU2VVUlZOTnRQcGwxS3o3TlU3eUZTVW9sZmtEV3pKa21Q?=
 =?utf-8?B?WkdJYW5lVTB2Zll2SzdNcnpIRU5vblRNVUtIeUl0WjFWYnduaGwyNE9aS29k?=
 =?utf-8?B?L0VCWElaSEtxOEoxMDBrSFpGbXp0aWtlZUZ6YVF5QzRVcFRodDk3bUV0d0pr?=
 =?utf-8?Q?57TxVhU7s/LKOiq23pJMG3U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D016BFDDA13FC43A35D7D5114B1754C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d8f6a7-d770-41eb-0375-08d99dec4e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 10:34:10.1774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cu5B3j7uA1B+imAGkbhXW40JWMKsxjKefZ8K56r8sNCKjxOuJaXerR2ZudMbERvJsTVhY8/9tXQa1Ws88MyswA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB7826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+Pj4+IEluIGFkZF9tZW1vcnlfcmVzb3VyY2UoKSB3ZSBob3RwbHVnIHRoZSBuZXcgbm9kZSBp
ZiByZXF1aXJlZCBhbmQgc2V0IGl0DQo+Pj4+IG9ubGluZS4gTWVtb3J5IG1pZ2h0IGdldCBvbmxp
bmVkIGxhdGVyLCB2aWEgb25saW5lX3BhZ2VzKCkuDQo+Pj4gDQo+Pj4gWW91IGFyZSBjb3JyZWN0
LiBJbiBjYXNlIG9mIG1lbW9yeSBob3QgYWRkLCBpdCBpcyB0cnVlLiBCdXQgaW4gY2FzZSBvZiBh
ZGRpbmcNCj4+PiBDUFUgd2l0aCBtZW1vcnlsZXNzIG5vZGUsIHRyeV9ub2RlX29ubGluZSgpIHdp
bGwgYmUgY2FsbGVkIG9ubHkgZHVyaW5nIENQVQ0KPj4+IG9ubGluaW5nLCBzZWUgY3B1X3VwKCku
DQo+Pj4gDQo+Pj4gSXMgdGhlcmUgYW55IHJlYXNvbiB3aHkgdHJ5X29ubGluZV9ub2RlKCkgcmVz
aWRlcyBpbiBjcHVfdXAoKSBhbmQgbm90IGluIGFkZF9jcHUoKT8NCj4+PiBJIHRoaW5rIGl0IHdv
dWxkIGJlIGNvcnJlY3QgdG8gb25saW5lIG5vZGUgZHVyaW5nIHRoZSBDUFUgaG90IGFkZCB0byBh
bGlnbiB3aXRoDQo+Pj4gbWVtb3J5IGhvdCBhZGQuDQo+PiANCj4+IEkgYW0gbm90IGZhbWlsaWFy
IHdpdGggY3B1IGhvdHBsdWcsIGJ1dCB0aGlzIGRvZXNuJ3Qgc2VlbSB0byBiZSBhbnl0aGluZw0K
Pj4gbmV3IHNvIGhvdyBjb21lIHRoaXMgYmVjYW1lIHByb2JsZW0gb25seSBub3c/DQo+IA0KPiBT
byBJSVVDLCB0aGUgaXNzdWUgaXMgdGhhdCB3ZSBoYXZlIGEgbm9kZQ0KPiANCj4gYSkgVGhhdCBo
YXMgbm8gbWVtb3J5DQo+IGIpIFRoYXQgaXMgb2ZmbGluZQ0KPiANCj4gVGhpcyBub2RlIHdpbGwg
Z2V0IG9ubGluZWQgd2hlbiBvbmxpbmluZyB0aGUgQ1BVIGFzIEFsZXhleSBzYXlzLiBZZXQgd2UN
Cj4gaGF2ZSBzb21lIGNvZGUgdGhhdCBzdHVtYmxlcyBvdmVyIHRoZSBub2RlIGFuZCBnb2VzIGFo
ZWFkIHRyeWluZyB0byB1c2UNCj4gdGhlIHBnZGF0IC0tIHRoYXQgY29kZSBpcyBicm9rZW4uDQoN
CllvdSBhcmUgY29ycmVjdC4NCg0KPiANCj4gDQo+IElmIHdlIHRha2UgYSBsb29rIGF0IGJ1aWxk
X3pvbmVsaXN0cygpIHdlIGluZGVlZCBza2lwIGFueQ0KPiAhbm9kZV9vbmxpbmUobm9kZSkuIEFu
eSBvdGhlciBjb2RlIHNob3VsZCBkbyB0aGUgc2FtZS4gSWYgdGhlIG5vZGUgaXMNCj4gbm90IG9u
bGluZSwgaXQgc2hhbGwgYmUgaWdub3JlZCBiZWNhdXNlIHdlIG1pZ2h0IG5vdCBldmVuIGhhdmUg
YSBwZ2RhdA0KPiB5ZXQgLS0gc2VlIGhvdGFkZF9uZXdfcGdkYXQoKS4gV2l0aG91dCBub2RlX29u
bGluZSgpLCB0aGUgcGdkYXQgbWlnaHQgYmUNCj4gc3RhbGUgb3Igbm9uLWV4aXN0YW50Lg0KDQpB
Z3JlZSwgYWxsb2NfcGFnZXNfbm9kZSgpIHNob3VsZCBhbHNvIGRvIHRoZSBzYW1lLiBOb3QgZXhh
Y3RseSB0byBza2lwIHRoZSBub2RlLA0KYnV0IHRvIGZhbGxiYWNrIHRvIGFub3RoZXIgbm9kZSBp
ZiAhbm9kZV9vbmxpbmUobm9kZSkuDQphbGxvY19wYWdlc19ub2RlKCkgY2FuIGFsc28gYmUgaGl0
IHdoaWxlIG9ubGluaW5nIHRoZSBub2RlLCBjcmVhdGluZyBjaGlja2VuLWVnZw0KcHJvYmxlbSwg
c2VlIGJlbG93Lg0KDQo+IA0KPiANCj4gVGhlIG5vZGUgb25saW5pbmcgbG9naWMgd2hlbiBvbmxp
bmluZyBhIENQVSBzb3VuZHMgYm9ndXMgYXMgd2VsbDogTGV0J3MNCj4gdGFrZSBhIGxvb2sgYXQg
dHJ5X29mZmxpbmVfbm9kZSgpLiBJdCBjaGVja3MgdGhhdDoNCj4gMSkgVGhhdCBubyBtZW1vcnkg
aXMgKnByZXNlbnQqDQo+IDIpIFRoYXQgbm8gQ1BVIGlzICpwcmVzZW50Kg0KPiANCj4gV2Ugc2hv
dWxkIG9ubGluZSB0aGUgbm9kZSB3aGVuIGFkZGluZyB0aGUgQ1BVICgicHJlc2VudCIpLCBub3Qg
d2hlbg0KPiBvbmxpbmluZyB0aGUgQ1BVLg0KDQpQb3NzaWJsZS4NCkFzc3VtaW5nIHRyeV9vbmxp
bmVfbm9kZSB3YXMgbW92ZWQgdW5kZXIgYWRkX2NwdSgpLCBsZXTigJlzDQp0YWtlIGxvb2sgb24g
dGhpcyBjYWxsIHN0YWNrOg0KYWRkX2NwdSgpDQogIHRyeV9vbmxpbmVfbm9kZSgpDQogICAgX190
cnlfb25saW5lX25vZGUoKQ0KICAgICAgaG90YWRkX25ld19wZ2RhdCgpDQpBdCBsaW5lIDExOTAg
d2UnbGwgaGF2ZSBhIHByb2JsZW06DQoxMTgzICAgICAgICAgcGdkYXQgPSBOT0RFX0RBVEEobmlk
KTsNCjExODQgICAgICAgICBpZiAoIXBnZGF0KSB7DQoxMTg1ICAgICAgICAgICAgICAgICBwZ2Rh
dCA9IGFyY2hfYWxsb2Nfbm9kZWRhdGEobmlkKTsNCjExODYgICAgICAgICAgICAgICAgIGlmICgh
cGdkYXQpDQoxMTg3ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KMTE4OA0K
MTE4OSAgICAgICAgICAgICAgICAgcGdkYXQtPnBlcl9jcHVfbm9kZXN0YXRzID0NCjExOTAgICAg
ICAgICAgICAgICAgICAgICAgICAgYWxsb2NfcGVyY3B1KHN0cnVjdCBwZXJfY3B1X25vZGVzdGF0
KTsNCjExOTEgICAgICAgICAgICAgICAgIGFyY2hfcmVmcmVzaF9ub2RlZGF0YShuaWQsIHBnZGF0
KTsNCg0KYWxsb2NfcGVyY3B1KCkgd2lsbCBnbyBmb3IgYWxsIHBvc3NpYmxlIENQVXMgYW5kIHdp
bGwgZXZlbnR1YWxseSBlbmQgdXANCmNhbGxpbmcgYWxsb2NfcGFnZXNfbm9kZSgpIHRyeWluZyB0
byB1c2Ugc3ViamVjdCBuaWQgZm9yIGNvcnJlc3BvbmRpbmcgQ1BVDQpoaXR0aW5nIHRoZSBzYW1l
IHN0YXRlICMyIHByb2JsZW0gYXMgTk9ERV9EQVRBKG5pZCkgaXMgc3RpbGwgTlVMTCBhbmQgbmlk
DQppcyBub3QgeWV0IG9ubGluZS4NCg0KSSBsaWtlIHRoZSBpZGVhIG9mIG9ubGluaW5nIHRoZSBu
b2RlIHdoZW4gYWRkaW5nIHRoZSBDUFUgcmF0aGVyIHRoZW4gd2hlbg0KQ1BVIGdldCBvbmxpbmUu
IEl0IHdpbGwgcmVxdWlyZSBjdXJyZW50IHBhdGNoIG9yIGFub3RoZXIgc29sdXRpb24gdG8gcmVz
b2x2ZQ0KZGVzY3JpYmVkIGFib3ZlIGNoaWNrZW4tZWdnIHByb2JsZW0uDQoNClBTLCBlYXJsaWVy
IHRoaXMgeWVhciBJIGluaXRpYXRlZCBkaXNjdXNzaW9uIGFib3V0IHJlZGVzaWduaW5nIHBlcl9j
cHUgYWxsb2NhdG9yDQp0byBkbyBub3QgYWxsb2NhdGUvd2FzdGUgbWVtb3J5IGNodW5rcyBmb3Ig
bm90IHByZXNlbnQgQ1BVcywgYnV0IGl0IGhhcyBhbm90aGVyDQpjb21wbGljYXRpb25zLg0KDQpU
aGFua3MsDQrigJRBbGV4ZXkNCg0K
