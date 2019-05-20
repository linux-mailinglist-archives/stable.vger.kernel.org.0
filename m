Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D026E24341
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfETWAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:00:16 -0400
Received: from mail-eopbgr820048.outbound.protection.outlook.com ([40.107.82.48]:58726
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfETWAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 18:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjQIMLT0BPHAP9oMnn26jdK95qMYDrnG1fGx3kzjQHM=;
 b=BpoAomcsrxS/md7dZ27Os2+BpqepdP4IVye5TaI5S4LjLpSt4eQwf79ScY9bqGaFbaJsTzu6tVC/GXu/li+RXlQTXtwBPoT17epfNpcj0F2yvt0aKLXP6XNwpu+79XjT0g6ufiFwkxFcO74tKRp50s3qJBltRPH4IXTCGdx07L4=
Received: from CY4PR12MB1798.namprd12.prod.outlook.com (10.175.59.9) by
 CY4PR12MB1269.namprd12.prod.outlook.com (10.168.168.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.22; Mon, 20 May 2019 22:00:12 +0000
Received: from CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::c84c:8885:45d3:fb52]) by CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::c84c:8885:45d3:fb52%3]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 22:00:12 +0000
From:   "Phillips, Kim" <kim.phillips@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Phillips, Kim" <kim.phillips@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?utf-8?B?TWFydGluIExpxaFrYQ==?= <mliska@suse.cz>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH 1/2] perf/x86/amd/uncore: Do not set ThreadMask and SliceMask
 for non-L3 PMCs
Thread-Topic: [PATCH 1/2] perf/x86/amd/uncore: Do not set ThreadMask and
 SliceMask for non-L3 PMCs
Thread-Index: AQHVD1dlRSFRdWkw5kyhngmaKBmD/Q==
Date:   Mon, 20 May 2019 22:00:12 +0000
Message-ID: <20190520215955.24343-1-kim.phillips@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:805:de::29) To CY4PR12MB1798.namprd12.prod.outlook.com
 (2603:10b6:903:11a::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcdba520-ca05-43c7-ddf2-08d6dd6e8818
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:CY4PR12MB1269;
x-ms-traffictypediagnostic: CY4PR12MB1269:
x-microsoft-antispam-prvs: <CY4PR12MB1269C089A31CEA9658B563E187060@CY4PR12MB1269.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(376002)(39860400002)(366004)(199004)(189003)(476003)(5660300002)(68736007)(5640700003)(36756003)(53936002)(486006)(2616005)(86362001)(99286004)(14454004)(102836004)(52116002)(6916009)(478600001)(6506007)(26005)(186003)(2351001)(54906003)(386003)(7416002)(6512007)(66066001)(7736002)(316002)(305945005)(2501003)(2906002)(14444005)(8676002)(50226002)(6436002)(71200400001)(71190400001)(81156014)(66946007)(81166006)(256004)(8936002)(64756008)(66476007)(25786009)(66574012)(73956011)(66556008)(66446008)(6116002)(6486002)(4326008)(1076003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1269;H:CY4PR12MB1798.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jZKfWzsZl6ZV8qq4kJdsc2T9bCR3DkYM1FQRG/JE/puM5bnG5zV5CygwqPYTUrt2wUY+mxrIXv+BEj/U3mB51EV+mYnDx3lxcq/mAOc37OtXr3pJxOwFhA4W28Xl5G8VffTHEZlznpSxGPbmN/OTBv7Oxk63KRSw8lPiGc/Bq7Zs5IGqIygDku4X3escmLGc5RCA8xh0Us8ngjU/71xj5MMfeqeEDcdYRf+8YMmqoHFm0gdAqcnyqGyVmwAZyHZhsz6z2RVANRWPKGXQhPH10hqnx6759jStvuKVEWXLgjPu0K1OaYDpmSHPpD8Fpp66mUfQUDw1E+0sz0ZfSnez7C+pdPDV+mPAUU6eu+JmfmPO5fJ4Gktf/XPNhKacpBJ5saA8fn8aUfv1V8Sz//RSMgfs/9ChcLCvKKY43NfYH+U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C13FDEA12D48647BC61822D8598243D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcdba520-ca05-43c7-ddf2-08d6dd6e8818
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 22:00:12.2779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1269
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogS2ltIFBoaWxsaXBzIDxraW0ucGhpbGxpcHNAYW1kLmNvbT4NCg0KQ29tbWl0IGQ3Y2Ji
ZTQ5YTkzMCAoInBlcmYveDg2L2FtZC91bmNvcmU6IFNldCBUaHJlYWRNYXNrIGFuZCBTbGljZU1h
c2sNCmZvciBMMyBDYWNoZSBwZXJmIGV2ZW50cyIpIGVuYWJsZXMgTDMgUE1DIGV2ZW50cyBmb3Ig
YWxsIHRocmVhZHMgYW5kDQpzbGljZXMgYnkgd3JpdGluZyAxcyBpbiBDaEwzUG1jQ2ZnIChMMyBQ
TUMgUEVSRl9DVEwpIHJlZ2lzdGVyIGZpZWxkcy4NCg0KVGhvc2UgYml0ZmllbGRzIG92ZXJsYXAg
d2l0aCBoaWdoIG9yZGVyIGV2ZW50IHNlbGVjdCBiaXRzIGluIHRoZSBEYXRhDQpGYWJyaWMgUE1D
IGNvbnRyb2wgcmVnaXN0ZXIsIGhvd2V2ZXIuDQoNClNvIHdoZW4gYSB1c2VyIHJlcXVlc3RzIHJh
dyBEYXRhIEZhYnJpYyBldmVudHMgKC1lIGFtZF9kZi9ldmVudD0weFlZWS8pLA0KdGhlIHR3byBo
aWdoZXN0IG9yZGVyIGJpdHMgZ2V0IGluYWR2ZXJ0ZW50bHkgc2V0LCBjaGFuZ2luZyB0aGUgY291
bnRlcg0Kc2VsZWN0IHRvIGV2ZW50cyB0aGF0IGRvbid0IGV4aXN0LCBhbmQgZm9yIHdoaWNoIG5v
IGNvdW50cyBhcmUgcmVhZC4NCg0KVGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBsb2dpYyB0byB3cml0
ZSB0aGUgTDMgbWFza3Mgb25seSB3aGVuIGRlYWxpbmcNCndpdGggTDMgUE1DIGNvdW50ZXJzLg0K
DQpBTUQgRmFtaWx5IDE2aCBhbmQgYmVsb3cgTm9ydGhicmlkZ2UgKE5CKSBjb3VudGVycyB3ZXJl
IG5vdCBhZmZlY3RlZC4NCg0KU2lnbmVkLW9mZi1ieTogS2ltIFBoaWxsaXBzIDxraW0ucGhpbGxp
cHNAYW1kLmNvbT4NCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC4xOSsNCkNjOiBQ
ZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQpDYzogSW5nbyBNb2xuYXIgPG1p
bmdvQHJlZGhhdC5jb20+DQpDYzogQXJuYWxkbyBDYXJ2YWxobyBkZSBNZWxvIDxhY21lQGtlcm5l
bC5vcmc+DQpDYzogQWxleGFuZGVyIFNoaXNoa2luIDxhbGV4YW5kZXIuc2hpc2hraW5AbGludXgu
aW50ZWwuY29tPg0KQ2M6IEppcmkgT2xzYSA8am9sc2FAcmVkaGF0LmNvbT4NCkNjOiBOYW1oeXVu
ZyBLaW0gPG5hbWh5dW5nQGtlcm5lbC5vcmc+DQpDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxp
bnV0cm9uaXguZGU+DQpDYzogQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+DQpDYzogIkgu
IFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4NCkNjOiBNYXJ0aW4gTGnFoWthIDxtbGlza2FA
c3VzZS5jej4NCkNjOiBTdXJhdmVlIFN1dGhpa3VscGFuaXQgPFN1cmF2ZWUuU3V0aGlrdWxwYW5p
dEBhbWQuY29tPg0KQ2M6IEphbmFrYXJhamFuIE5hdGFyYWphbiA8SmFuYWthcmFqYW4uTmF0YXJh
amFuQGFtZC5jb20+DQpDYzogR2FyeSBIb29rIDxHYXJ5Lkhvb2tAYW1kLmNvbT4NCkNjOiBQdSBX
ZW4gPHB1d2VuQGh5Z29uLmNuPg0KQ2M6IFN0ZXBoYW5lIEVyYW5pYW4gPGVyYW5pYW5AZ29vZ2xl
LmNvbT4NCkNjOiBWaW5jZSBXZWF2ZXIgPHZpbmNlbnQud2VhdmVyQG1haW5lLmVkdT4NCkNjOiB4
ODZAa2VybmVsLm9yZw0KRml4ZXM6IGQ3Y2JiZTQ5YTkzMCAoInBlcmYveDg2L2FtZC91bmNvcmU6
IFNldCBUaHJlYWRNYXNrIGFuZCBTbGljZU1hc2sgZm9yIEwzIENhY2hlIHBlcmYgZXZlbnRzIikN
Ci0tLQ0KIGFyY2gveDg2L2V2ZW50cy9hbWQvdW5jb3JlLmMgfCAyICstDQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9ldmVudHMvYW1kL3VuY29yZS5jIGIvYXJjaC94ODYvZXZlbnRzL2FtZC91bmNvcmUuYw0KaW5k
ZXggNzljZmQzYjMwY2ViLi5hOGRjMjYzNWE3MTkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9ldmVu
dHMvYW1kL3VuY29yZS5jDQorKysgYi9hcmNoL3g4Ni9ldmVudHMvYW1kL3VuY29yZS5jDQpAQCAt
MjA5LDcgKzIwOSw3IEBAIHN0YXRpYyBpbnQgYW1kX3VuY29yZV9ldmVudF9pbml0KHN0cnVjdCBw
ZXJmX2V2ZW50ICpldmVudCkNCiAJICogU2xpY2VNYXNrIGFuZCBUaHJlYWRNYXNrIG5lZWQgdG8g
YmUgc2V0IGZvciBjZXJ0YWluIEwzIGV2ZW50cyBpbg0KIAkgKiBGYW1pbHkgMTdoLiBGb3Igb3Ro
ZXIgZXZlbnRzLCB0aGUgdHdvIGZpZWxkcyBkbyBub3QgYWZmZWN0IHRoZSBjb3VudC4NCiAJICov
DQotCWlmIChsM19tYXNrKQ0KKwlpZiAobDNfbWFzayAmJiBpc19sbGNfZXZlbnQoZXZlbnQpKQ0K
IAkJaHdjLT5jb25maWcgfD0gKEFNRDY0X0wzX1NMSUNFX01BU0sgfCBBTUQ2NF9MM19USFJFQURf
TUFTSyk7DQogDQogCWlmIChldmVudC0+Y3B1IDwgMCkNCi0tIA0KMi4yMS4wDQoNCg==
