Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A66552A4
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfFYO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:57:06 -0400
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:44800
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730701AbfFYO5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 10:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3uZaEaKtXahH+0FTybYxrM9NJpYd0hj3KS3wtOMB+o=;
 b=0BcmpjN4np1nUAId9JKreLOIUz3E/muoqV+dlryoITdU1arWcD44qZzJ6td3BKWTbDRCHy384wM9N5rDCL8OPVTMLRUQUOsUwcHG20/OjMrcF1a2xi3tKrRqwhSpD5OZtM/JVhbsVW6+g4uHwJYjCQyT3UTlcx+sfBpV74E7Nc0=
Received: from CY4PR12MB1798.namprd12.prod.outlook.com (10.175.59.9) by
 CY4PR12MB1832.namprd12.prod.outlook.com (10.175.61.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 14:56:23 +0000
Received: from CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44]) by CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44%9]) with mapi id 15.20.2008.017; Tue, 25 Jun 2019
 14:56:23 +0000
From:   "Phillips, Kim" <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Martin Liska <mliska@suse.cz>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH 1/2 RESEND2] perf/x86/amd/uncore: Do not set ThreadMask and
 SliceMask for non-L3 PMCs
Thread-Topic: [PATCH 1/2 RESEND2] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Thread-Index: AQHVK2YojefsBpqvIUqV/vgdz1UgXg==
Date:   Tue, 25 Jun 2019 14:56:23 +0000
Message-ID: <20190625145548.11600-1-kim.phillips@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0015.namprd07.prod.outlook.com
 (2603:10b6:803:28::25) To CY4PR12MB1798.namprd12.prod.outlook.com
 (2603:10b6:903:11a::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6562aed3-028c-4dbe-ed42-08d6f97d4a5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR12MB1832;
x-ms-traffictypediagnostic: CY4PR12MB1832:
x-microsoft-antispam-prvs: <CY4PR12MB1832A6A1DECCF6518F019A3A87E30@CY4PR12MB1832.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(366004)(396003)(346002)(199004)(189003)(53936002)(2906002)(50226002)(66066001)(14454004)(4326008)(54906003)(305945005)(6486002)(71190400001)(5660300002)(7416002)(14444005)(256004)(1076003)(110136005)(6116002)(478600001)(3846002)(6512007)(386003)(6506007)(102836004)(36756003)(68736007)(66446008)(73956011)(52116002)(86362001)(81166006)(186003)(66946007)(81156014)(486006)(2616005)(6436002)(476003)(8676002)(7736002)(316002)(8936002)(26005)(99286004)(64756008)(66556008)(66476007)(71200400001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1832;H:CY4PR12MB1798.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6Gsk++hVwjeOS7CmmS3335IX+wq7pmADA109nspKICZdq2mwNGY2n6DRmz6T0fNo2vT3aNGoE/8Y0TFMItZvazOQPTMB/jZnjr7zetV7LFkqPCcc9UmxxNwMS1z2PdcKxY4vuGy2Ug2/NyyuaU7zL4EuQcjG0/rMPgLbhIM8b+czwqVhh3TnThBFL5ufZKx2xZoEV+OoT+vyyVQoYt2ekeemTli/4wGxbZdfKsHqhim5wNoTEUS6BNr1qqR7hrRFrHpJBTVXISOIKpRXwSVN2GA4mcEBYSaXAP/pRtADxUfBcJA8Qpl7JAiB8FZWWXoodC+UQYhAuhFADsp6IdtFsrKv94AcqoUHaQhYzMkVaqoFSwwA5v9zPwnKYks9x2NcpWHfJaffe4wCsC4PFpxvXcn9BENX66Vr9E6IUxGlOFY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6562aed3-028c-4dbe-ed42-08d6f97d4a5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 14:56:23.7214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kphillips@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1832
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
IFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4NCkNjOiBNYXJ0aW4gTGlza2EgPG1saXNrYUBz
dXNlLmN6Pg0KQ2M6IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCA8U3VyYXZlZS5TdXRoaWt1bHBhbml0
QGFtZC5jb20+DQpDYzogSmFuYWthcmFqYW4gTmF0YXJhamFuIDxKYW5ha2FyYWphbi5OYXRhcmFq
YW5AYW1kLmNvbT4NCkNjOiBHYXJ5IEhvb2sgPEdhcnkuSG9va0BhbWQuY29tPg0KQ2M6IFB1IFdl
biA8cHV3ZW5AaHlnb24uY24+DQpDYzogU3RlcGhhbmUgRXJhbmlhbiA8ZXJhbmlhbkBnb29nbGUu
Y29tPg0KQ2M6IFZpbmNlIFdlYXZlciA8dmluY2VudC53ZWF2ZXJAbWFpbmUuZWR1Pg0KQ2M6IHg4
NkBrZXJuZWwub3JnDQpGaXhlczogZDdjYmJlNDlhOTMwICgicGVyZi94ODYvYW1kL3VuY29yZTog
U2V0IFRocmVhZE1hc2sgYW5kIFNsaWNlTWFzayBmb3IgTDMgQ2FjaGUgcGVyZiBldmVudHMiKQ0K
LS0tDQpSRVNFTkQ6IDNyZCBhdHRlbXB0LCB0aGlzIHRpbWUgd2l0aCAtLXRyYW5zZmVyLWVuY29k
aW5nPTdiaXQgdG8gdHJ5IHRvIHBhc3MNCiAgICAgICAgUGV0ZXIgWi4ncyBzY3JpcHRzIG5vdCBs
aWtpbmcgYmFzZTY0IGVuY29kZWQgZW1haWxzLg0KDQogYXJjaC94ODYvZXZlbnRzL2FtZC91bmNv
cmUuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2V2ZW50cy9hbWQvdW5jb3JlLmMgYi9hcmNoL3g4
Ni9ldmVudHMvYW1kL3VuY29yZS5jDQppbmRleCA4NWU2OTg0YzU2MGIuLmMyYzRhZTVmYmJmYyAx
MDA2NDQNCi0tLSBhL2FyY2gveDg2L2V2ZW50cy9hbWQvdW5jb3JlLmMNCisrKyBiL2FyY2gveDg2
L2V2ZW50cy9hbWQvdW5jb3JlLmMNCkBAIC0yMDYsNyArMjA2LDcgQEAgc3RhdGljIGludCBhbWRf
dW5jb3JlX2V2ZW50X2luaXQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQ0KIAkgKiBTbGljZU1h
c2sgYW5kIFRocmVhZE1hc2sgbmVlZCB0byBiZSBzZXQgZm9yIGNlcnRhaW4gTDMgZXZlbnRzIGlu
DQogCSAqIEZhbWlseSAxN2guIEZvciBvdGhlciBldmVudHMsIHRoZSB0d28gZmllbGRzIGRvIG5v
dCBhZmZlY3QgdGhlIGNvdW50Lg0KIAkgKi8NCi0JaWYgKGwzX21hc2spDQorCWlmIChsM19tYXNr
ICYmIGlzX2xsY19ldmVudChldmVudCkpDQogCQlod2MtPmNvbmZpZyB8PSAoQU1ENjRfTDNfU0xJ
Q0VfTUFTSyB8IEFNRDY0X0wzX1RIUkVBRF9NQVNLKTsNCiANCiAJaWYgKGV2ZW50LT5jcHUgPCAw
KQ0KLS0gDQoyLjIyLjANCg0K
