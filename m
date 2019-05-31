Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142363121B
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEaQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 12:18:07 -0400
Received: from mail-eopbgr680040.outbound.protection.outlook.com ([40.107.68.40]:19181
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfEaQSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 12:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjQIMLT0BPHAP9oMnn26jdK95qMYDrnG1fGx3kzjQHM=;
 b=w9WuLrYX2PQi68BNmGeHz1En0FLH3j/k4nNFsWbjbNmB/nnlJhpuAJ4x3XNE6l1OhLGq/BdX9XeTuHUWap6kjaKT+3T+zqB8nrWYXT1hq/2ZlaYREaJtyj4+rJgLnIO0DzLBFfsU+764nfK+IX7zebwwFC1NYG1GLLcKoxmCqbk=
Received: from CY4PR12MB1798.namprd12.prod.outlook.com (10.175.59.9) by
 CY4PR12MB1800.namprd12.prod.outlook.com (10.175.63.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Fri, 31 May 2019 16:17:22 +0000
Received: from CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44]) by CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44%9]) with mapi id 15.20.1943.016; Fri, 31 May 2019
 16:17:22 +0000
From:   "Phillips, Kim" <kim.phillips@amd.com>
To:     Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
Subject: [PATCH 1/2 RESEND] perf/x86/amd/uncore: Do not set ThreadMask and
 SliceMask for non-L3 PMCs
Thread-Topic: [PATCH 1/2 RESEND] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Thread-Index: AQHVF8xTHG5ZWCfMUkuk5b2HQ8kFlA==
Date:   Fri, 31 May 2019 16:17:21 +0000
Message-ID: <20190531161708.25658-1-kim.phillips@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0127.namprd05.prod.outlook.com
 (2603:10b6:803:42::44) To CY4PR12MB1798.namprd12.prod.outlook.com
 (2603:10b6:903:11a::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33712e93-9cbc-46f1-94b8-08d6e5e375d3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR12MB1800;
x-ms-traffictypediagnostic: CY4PR12MB1800:
x-microsoft-antispam-prvs: <CY4PR12MB1800BD3F2AEB72686312725B87190@CY4PR12MB1800.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(366004)(199004)(189003)(68736007)(71190400001)(2501003)(7416002)(305945005)(14444005)(81156014)(256004)(8676002)(81166006)(71200400001)(478600001)(7736002)(8936002)(186003)(5660300002)(1076003)(6116002)(25786009)(6512007)(386003)(52116002)(6506007)(6436002)(102836004)(36756003)(110136005)(50226002)(486006)(66556008)(66446008)(66476007)(66946007)(64756008)(73956011)(66066001)(316002)(66574012)(54906003)(476003)(2616005)(99286004)(14454004)(53936002)(3846002)(26005)(86362001)(2906002)(6486002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1800;H:CY4PR12MB1798.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /MQ2RZFZ1EYBZoy6DFIzvITHOBgmzTF2GQAxzWrVk6Jnc6mOg4mUi3OdkPLaEm/kJWqMPjkL+FG/13xO8HPlb4iLxWUqnKOQUQ94ywC0Kvo2OCUuqDwyH4nwekUVkwWhiRA5G+LV9XiRq3/iMvzPkvBCf3WxuiIoIe2+Rr4DBfpKsiJH53xM9W6oAVfD1gItqGYsSCPegauolWXMFCuSOmZupkT/go/N/OSuZt8cRBDtHXs/ZPAi7vnhQId9DtGLf2w/pbLomgYb4rx/6FA9EgAbW9KhmVailJfoEXHZB/ebZ5DzST21ueE66Tk2KaUYvtEOvONfllU1vTQSZ7ZCJFL5z0vqOvqLZHj7Moy0W3u73AN4Yes4ijoiKDXYsC+iKxvbP6WFQZqUP9Urk7/HDG+tAxJWB1a9K7pt4wrTHT4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF18F6493B04D5489B582EEC71AEF44F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33712e93-9cbc-46f1-94b8-08d6e5e375d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 16:17:22.0164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kphillips@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1800
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
