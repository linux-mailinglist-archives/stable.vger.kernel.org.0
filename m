Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65EE493963
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 12:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354097AbiASLTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 06:19:11 -0500
Received: from mail-eopbgr90059.outbound.protection.outlook.com ([40.107.9.59]:22354
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354094AbiASLTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 06:19:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGxpMKwkoRZ0BN3lclnqlM3FI5DdwMQ1cEkkBiNooBsWNfi+NoJXbnkQpimXp7iGbwfJt6LxGyvnNN56amS4loVcFeBXMLCounwjvxfL3oO39QsbJHO4d47V3C+oYfYxYe5++VMYYRHnB1pFejhP8nAZW5Edvpy5Nqtpa3nhLwgX8m3RB6albsNVTeCD4DADevgCdmSX9Intm3DnSXG9fompoTeG8QD4at+C21xFzgwgYhSJk3SGHVwza9isZVIsFZQ1VYU7qA8iOulNSCi3BkBXcdVFtM710UC6WwfCtReBfdk230rE/abRDhVqJH8z0bbXV/1dIz714fS97vrusQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csE11w2y5lUEHM6qYCEZgaGCTI0VngDJAeSJGkGUAjg=;
 b=ZDArei2his25ikkQ5rB8N19sPqa3xqIy9H+a64zJwADQyPk0U9XkjF5svKeMs/1bqdglGOG0yevMcmEblne3v7D44D2iAEkESj5dRo0sjRB3lpA7E88zIx7MXiwm49ay4xK4Ra1aUYlDduYlGGwD1PDIeTHa1IfBRls2nncT6yHYPBgRObacZnG6LBlnznDNLIOilOtrOZrIwucp4qfLRBMF9XnzGFV9+Arx+E+OGqheV6Io2TDcuvltOmQThF1Z9Ogc0tdnP62EJe09+ptBl5xBHKyOGz14c3wNzKNL1E6f6cvhfaBHuxES07sF+3R1TtYI52PBAq5DXHhVFjbo5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3267.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 11:19:06 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::9d4f:1090:9b36:3fc5%5]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 11:19:06 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Michael Ellerman <mpe@ellerman.id.au>
CC:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and
 KFENCE
Thread-Topic: [PATCH] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and
 KFENCE
Thread-Index: AQHX6zEUm45+sm7WYEq1/qYEgOJsjKxqdlsA
Date:   Wed, 19 Jan 2022 11:19:06 +0000
Message-ID: <abe73aa3-8f4e-45a1-033f-428fd67a7570@csgroup.eu>
References: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
In-Reply-To: <aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b911a4f0-eba4-40a4-f2d2-08d9db3d81d5
x-ms-traffictypediagnostic: MR1P264MB3267:EE_
x-microsoft-antispam-prvs: <MR1P264MB3267ADD457C5B79D1AEBB520ED599@MR1P264MB3267.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FIgTUw+GyuLsQbj6d0LV8uioTdk66sTdhvxIk3yRNv5wkc932IgV8LYRZhE5qWqrnl3iXNSuIRQ/3em0/22NbZd03o9ju90J8fvsxkxl/9tW0i6ZrBYy5f1Glm3IbtQc+Hl5EkUIf8TR/71755t12iEXVQxnj3qJktfswp5Vuzq1Vr4cUXW7O8HtrZYkr0Cs9vyg3SFzUnDdBH2PUN5xUZppifpw6RFLGbx2etIXUdePVgjpGBPVVBSutC+O/dXPtMVCPwYgmaOEN7v9lfYtByB0rMLURUn27p0zYse86FzCpM9bZ3oASEYWGegDJQtMUPZkln5u1epsTS/6Gw1OHFQ8KmPSWQ9fFqt36bA2nIJQWgqB+VRzbUdOs3seCxBgyw2CvLhVeEH/ywm1lwzNw4SyJfghN4E+bskGGCKygNZgLi23Zz9Z8wXmtalo4Cnb9Mtg48BEMJbuUGrcg/T0rT8Ix8x0K71xuaAc4fd5WXuOj6GG8goCyxctxYivn/lW1w2dYPdZtGtBc6JWmNDYeNAdia49xvODE/M1cOX/Mw9CgNKVKRt55zTpD2YHl9dbZVdJewsxtpfAL8UPEMJAIl+iESEhTNGf+EXM5rCYyrs0+x3AhOqkx6nc70FRMJyOAPL0sMaf/aJys6WIhKLCRnMoPBAHl6k2B1iXk4JgnrqwQSp0DgxnSBLNyREBC6ghBggzxnGMe1VrKVmrzt/369Neak57QMHD7+D0lTCJ5N1bbvKoEWY/uBpZwW0cPrU1KrQrPpwHBFyXfgmdO269Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(6486002)(6512007)(44832011)(86362001)(31696002)(2906002)(54906003)(4326008)(316002)(66574015)(508600001)(71200400001)(8936002)(122000001)(38100700002)(186003)(36756003)(31686004)(5660300002)(66476007)(26005)(91956017)(76116006)(8676002)(66446008)(66556008)(64756008)(66946007)(6916009)(83380400001)(38070700005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkJJTGVpU2JHbTRYOUl3dmVuYVVibHhGOU1yaHZNRUNnTW84ZVlJTWhKTVZ0?=
 =?utf-8?B?SnBYcjZOd1p3ZGROaGZvdmhjYVFwQXloYmQyMDRvMkdva01xZjQrSVVUN2h6?=
 =?utf-8?B?R0VId0xKRzdWTXNRQ1UyY05FRkpFV2hNbEN1Z29jdkdyYWVmSlRFR0NtVDJP?=
 =?utf-8?B?c1VDQWgrTlM3a002WGJpb0tobldpUnI5eTFSeGlkNmdySXFiYlhHYVFoQmNN?=
 =?utf-8?B?WUkzcXhCd1NLK0s1MllCZTFqRWlBSENObjM0ek12MkFaWFYrOXhnMElmeUFU?=
 =?utf-8?B?THJWMGN4bmxnZHJZNXhHRTNWSFd6bkFKek9VNHNxRGVEaUNKNmlmekYvZDNz?=
 =?utf-8?B?QitwNFlXR25oT2ltTGVkVkNEc2ZQY0JOTWxadm00NW4velEyZjF1S0g0VHNF?=
 =?utf-8?B?L0NmVmRmS01Jd2NZeTd3eEVVZHFVb1VNTktlRWNNclNPclBvUGhpa1plcWdV?=
 =?utf-8?B?RE1ZM1pDd1R4Z2VmMStlMXdLakxLRkFRck9Pa2Nmd0E4ekQ0cGhFdHV0NVNS?=
 =?utf-8?B?RDlQSThtQzEvQndNWlZCSDkxOTN2eDJINnVUa2I0N3FWb1lNdWVSNjdyWm5F?=
 =?utf-8?B?alFNMWdqQnRCUUFSeGhrT2hqMXpMYk5hZTdPZVFZVjhDNS9NY0FCTFQ1RDlt?=
 =?utf-8?B?TXZLcWJKQW1PTHZTWkZNQkhQTWpYT0FXWHJocm5IOENtVEJtK3llSFNNUXhv?=
 =?utf-8?B?aHpNVEpSbDdBRFduNDRxdlk2NTR2dXhHQkEyVjJ4MHNSbW1Qb1NDTWRhb29C?=
 =?utf-8?B?ZHZ6c0d6UXFVbnA0ZkY3OVVncVY2bDltWmZpbkpGcTRtdFZLaTg5WkRlejFO?=
 =?utf-8?B?ZllPTTRNdDdCUG9kZyt5V0YwVTV2Zlc5cHNYek9BMU5wK2lRT3ZlMk9ZU2dn?=
 =?utf-8?B?anVTZSs5dGlzWGZZYXp4L2gvTG92SVMvK3RoZVBNay83bTVyU01pYnZMZkRY?=
 =?utf-8?B?cU5USkRKR0hTSlJubEJlYythL0VidVBpZ09KK1YxYVIvOEpHbCtvVTdrVzFu?=
 =?utf-8?B?TTEvSFExUnAwSXZmUVRpZzNCQ3p6NHhEZUE4Z0t3ZkJJVGdzelVSMUVndm82?=
 =?utf-8?B?ODkxeTBzYkRHSGxHSU94NUdmaXM4d2FPYlZuV3RBRXUzL3BNeUQ4Z2h1azU5?=
 =?utf-8?B?NS9FREhHejVwRE1lUU92V3BBQ3k2bGVJRHppYzB1UE1mWlhnU0x0K1pFT0Vl?=
 =?utf-8?B?Q2hHejU2b2x6UUFqUEszckNWRmNjamdUYjQ2d2JzMzlWNFNuZWlxdzhtdnI0?=
 =?utf-8?B?bW5yU3lQODVOTnRkVFI3Wm5tU3lhTFhJV2NDMzQ4aENtZGY2YzRTMCtBTlVq?=
 =?utf-8?B?R1ZYTXVVNkxqMzdud1RidnBRcUNEVHlLLzZYbHRuZXNrcmthOHQzK3dmUm5W?=
 =?utf-8?B?RVo0VXpGUUU4VzdlRjhnSzFCTUxqbkdNRWpUVFhKUXlmYWJxbGNIb0pmQnY3?=
 =?utf-8?B?YVpZb2ZGMUNTOTVvaWZhTHpEVjBZZ080d1FRd0ZoeG9kd3JMTnZXd0NTMHdi?=
 =?utf-8?B?aFdvZk9hakxMT1ZqU2V6MFlEV291M3VhMDdQeC9RazNXWmkrbkdOSVlrS28v?=
 =?utf-8?B?YVhuSjhSK0cyY3NVaXZIL1pweG10ZENISkRERWFsY2loMzdIUVVLQmVrS2Ez?=
 =?utf-8?B?akd0ZUx6VW8zQ0dBQXVPTy9SSENoUXZmd1FqYTRXdkR4MWVRSGFCVDdLODQ2?=
 =?utf-8?B?TEpBY3ZnZnY5dEF2aEFYRG1lTXNwVElyODFWM3BKc05HSXkxQUVHTVNLWTJn?=
 =?utf-8?B?ZS9BY1BYTU9vV3V2R0Zxd3Btd2NuL0JoSU9vd1BURC9uWFhzNENaZWVlQzFs?=
 =?utf-8?B?K0gyOWxiT0g2LzAvdUVJc0ZpNmh2RzY1Qjh5MkVLUVBpZkdaK0xDeVVzUTdS?=
 =?utf-8?B?RUhtVHpNY2c2S2pzQy9NK1F6MjAyM3ZkWGxJcFZxSWNNZWVoR3V4ZHc5aU04?=
 =?utf-8?B?cTdhVytURDViQVVaajBLVVFLUkdVQjcvUm1Ld1BoRTB6ZkErRDhoYW9SSVdn?=
 =?utf-8?B?RW9PSCs3MWNFYkZMaTBGVFc1UE9sWTlKdjhLS3pISU5lTy9JSE9WSmsvc3dw?=
 =?utf-8?B?UFlySXEwZDQyNUpmeEJlemVBZEd0cFphUmtCaVV3c1FrUlBBU1EzaHhObGxH?=
 =?utf-8?B?UkZHYVQ0WDMxbDh3VnNIRStidnY2bHh2SEZiTzRZOGxQelMvYnBqdUNaU1lz?=
 =?utf-8?B?L2pLQUZyZUgxQVk1d1ExMVgzTGRqNEtwSHFQSHlIa2h0TVJQNHMrUkRrZy90?=
 =?utf-8?Q?hlOsshsBO88ADx+B2Hh3kYW1ANYdOPQ9b15pBUZTEg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00728BD280CAAA489A5EC8AFF438B776@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b911a4f0-eba4-40a4-f2d2-08d9db3d81d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 11:19:06.6469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywz3N+6CyhNw4P4Q4fHq8sifuOLJL2PaP95voX/KheZfllYdfxlrZyP5B8Q7K8uknZnt2u9DU0qhknkI3YqMmTvag8+9smkO1ULIhjdk0bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3267
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TWljaGFlbCwgcGluZy4NCg0KTGUgMDcvMTIvMjAyMSDDoCAwNzoxMCwgQ2hyaXN0b3BoZSBMZXJv
eSBhIMOpY3JpdMKgOg0KPiBBbGx0aG91Z2gga2VybmVsIHRleHQgaXMgYWx3YXlzIG1hcHBlZCB3
aXRoIEJBVHMsIHdlIHN0aWxsIGhhdmUNCj4gaW5pdHRleHQgbWFwcGVkIHdpdGggcGFnZXMsIHNv
IFRMQiBtaXNzIGhhbmRsaW5nIGlzIHJlcXVpcmVkDQo+IHdoZW4gQ09ORklHX0RFQlVHX1BBR0VB
TExPQyBvciBDT05GSUdfS0ZFTkNFIGlzIHNldC4NCj4gDQo+IFRoZSBmaW5hbCBzb2x1dGlvbiBz
aG91bGQgYmUgdG8gc2V0IGEgQkFUIHRoYXQgYWxzbyBtYXBzIGluaXR0ZXh0DQo+IGJ1dCB0aGF0
IEJBVCB0aGVuIG5lZWRzIHRvIGJlIGNsZWFyZWQgYXQgZW5kIG9mIGluaXQsIGFuZCBpdCB3aWxs
DQo+IHJlcXVpcmUgbW9yZSBjaGFuZ2VzIHRvIGJlIGFibGUgdG8gZG8gaXQgcHJvcGVybHkuDQo+
IA0KPiBBcyBERUJVR19QQUdFQUxMT0Mgb3IgS0ZFTkNFIGFyZSBkZWJ1Z2dpbmcsIHBlcmZvcm1h
bmNlIGlzIG5vdCBhIGJpZw0KPiBkZWFsIHNvIGxldCdzIGZpeCBpdCBzaW1wbHkgZm9yIG5vdyB0
byBlbmFibGUgZWFzeSBzdGFibGUgYXBwbGljYXRpb24uDQo+IA0KPiBSZXBvcnRlZC1ieTogTWF4
aW1lIEJpem9uIDxtYml6b25AZnJlZWJveC5mcj4NCj4gRml4ZXM6IDAzNWIxOWExNWE5OCAoInBv
d2VycGMvMzJzOiBBbHdheXMgbWFwIGtlcm5lbCB0ZXh0IGFuZCByb2RhdGEgd2l0aCBCQVRzIikN
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3Bo
ZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KPiAtLS0NCj4gICBhcmNoL3Bv
d2VycGMva2VybmVsL2hlYWRfYm9vazNzXzMyLlMgfCA0ICsrLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvcG93ZXJwYy9rZXJuZWwvaGVhZF9ib29rM3NfMzIuUyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwv
aGVhZF9ib29rM3NfMzIuUw0KPiBpbmRleCA2OGU1YzBhN2U5OWQuLjJlMmE4MjExYjE3YiAxMDA2
NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9oZWFkX2Jvb2szc18zMi5TDQo+ICsrKyBi
L2FyY2gvcG93ZXJwYy9rZXJuZWwvaGVhZF9ib29rM3NfMzIuUw0KPiBAQCAtNDIxLDE0ICs0MjEs
MTQgQEAgSW5zdHJ1Y3Rpb25UTEJNaXNzOg0KPiAgICAqLw0KPiAgIAkvKiBHZXQgUFRFIChsaW51
eC1zdHlsZSkgYW5kIGNoZWNrIGFjY2VzcyAqLw0KPiAgIAltZnNwcglyMyxTUFJOX0lNSVNTDQo+
IC0jaWZkZWYgQ09ORklHX01PRFVMRVMNCj4gKyNpZiBkZWZpbmVkKENPTkZJR19NT0RVTEVTKSB8
fCBkZWZpbmVkKENPTkZJR19ERUJVR19QQUdFQUxMT0MpIHx8IGRlZmluZWQoQ09ORklHX0tGRU5D
RSkNCj4gICAJbGlzCXIxLCBUQVNLX1NJWkVAaAkJLyogY2hlY2sgaWYga2VybmVsIGFkZHJlc3Mg
Ki8NCj4gICAJY21wbHcJMCxyMSxyMw0KPiAgICNlbmRpZg0KPiAgIAltZnNwcglyMiwgU1BSTl9T
RFIxDQo+ICAgCWxpCXIxLF9QQUdFX1BSRVNFTlQgfCBfUEFHRV9BQ0NFU1NFRCB8IF9QQUdFX0VY
RUMgfCBfUEFHRV9VU0VSDQo+ICAgCXJsd2lubQlyMiwgcjIsIDI4LCAweGZmZmZmMDAwDQo+IC0j
aWZkZWYgQ09ORklHX01PRFVMRVMNCj4gKyNpZiBkZWZpbmVkKENPTkZJR19NT0RVTEVTKSB8fCBk
ZWZpbmVkKENPTkZJR19ERUJVR19QQUdFQUxMT0MpIHx8IGRlZmluZWQoQ09ORklHX0tGRU5DRSkN
Cj4gICAJYmd0LQkxMTJmDQo+ICAgCWxpcwlyMiwgKHN3YXBwZXJfcGdfZGlyIC0gUEFHRV9PRkZT
RVQpQGhhCS8qIGlmIGtlcm5lbCBhZGRyZXNzLCB1c2UgKi8NCj4gICAJbGkJcjEsX1BBR0VfUFJF
U0VOVCB8IF9QQUdFX0FDQ0VTU0VEIHwgX1BBR0VfRVhFQw==
