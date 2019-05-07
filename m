Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064A315E7A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 09:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfEGHrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 03:47:00 -0400
Received: from mail-eopbgr790111.outbound.protection.outlook.com ([40.107.79.111]:11392
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbfEGHq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 03:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=K2ZaIQ+jPnzdTaE9+0QDAe4pZohcCkvsA5mgNjvhmg6yEqz5cfubb7ZIFwfBj7CkDKxqrMm8T9ehhGJtnREttfxxc0sjIqu+ubmJBfyITvQc8gEOm/BgZ+8mU1XRgkZZl34BmCaP+hZKdnQnj/T9nPVtjsVIs+0/cPJH8mMUlnU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvC19Yf40mYc0pYEteOzJeS21p6geKK+URR5jdlV0Ic=;
 b=VrcYiDd/4NeLdX2IL9zdmiHHklrRnnTqF5SNDd8bD8OOL2BO7B3HwqdOU3qOvnVYCpvfnzUt3p8ulRVIcZ5zexCJt2GP3nlkHmRu0/UM0bh+MrGOLVJafvyVuGaEfbCRpeMnqxH3hcO0OXuPwjL7gISfDbuJq5PxaR05z6jPxfE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvC19Yf40mYc0pYEteOzJeS21p6geKK+URR5jdlV0Ic=;
 b=VNFb513o7IVVO7jDPPHVdKbvYTjTMXKzUd3qFpJreGz8DoN452UaHk2sLz6k08PmhVrkH01FdQNJgSpThUYLTfQlOh9RAef4A92lD+/+vVCkeQHDxGuFjMh97g+F3tvy1PGjtpPPcLCdxz9z/b5IUIQj7noI4BODLv6Oo4+T1P4=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.4; Tue, 7 May 2019 07:46:56 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::453:8268:2686:4cf]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::453:8268:2686:4cf%8]) with mapi id 15.20.1900.002; Tue, 7 May 2019
 07:46:56 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "juliana.rodrigueiro@intra2net.com" 
        <juliana.rodrigueiro@intra2net.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Thread-Topic: [PATCH] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Thread-Index: AQHVBKkKTisq9OloE02W7qrjLXJSBQ==
Date:   Tue, 7 May 2019 07:46:55 +0000
Message-ID: <1557215147-89776-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0038.namprd22.prod.outlook.com
 (2603:10b6:301:16::12) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a664109b-49a5-41d0-4e66-08d6d2c02cda
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN6PR2101MB0942;
x-ms-traffictypediagnostic: SN6PR2101MB0942:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SN6PR2101MB094278C89534CE50B17A0B5BBF310@SN6PR2101MB0942.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(376002)(39860400002)(189003)(199004)(68736007)(7416002)(53936002)(10290500003)(10090500001)(6436002)(6486002)(476003)(71200400001)(2501003)(86362001)(66446008)(64756008)(86612001)(66476007)(66556008)(73956011)(66946007)(1511001)(66066001)(3846002)(6116002)(305945005)(71190400001)(4744005)(6512007)(25786009)(4720700003)(36756003)(6506007)(386003)(54906003)(2906002)(186003)(99286004)(478600001)(256004)(5660300002)(14444005)(2616005)(4326008)(52116002)(102836004)(81156014)(8936002)(7736002)(316002)(81166006)(110136005)(50226002)(8676002)(486006)(26005)(14454004)(22452003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0942;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mN1U5dTKpJoC4gWAVZJstFwDud/bS6FJp8Ysvr2q6dhztk7F+mHSMruVCfukPWAgvlj6G/4U9nRFIzO0w8yhMTyPdMa2x0FvxrFcfBsZwfxa0INnNY5fSfOXUkaj7zo4kzAQwe1zrffI++bqJay753a3MGqsAEKElK7ng3DoF+zKkKIJIIyxnA/gMp96XMg7LcSTGGDu1oADmeszS1+wpbTy3QBqZafedsFAAyL5+0aRamh7yRzds7IxrJbM1lf2nYrAts2LYXQXhZ6uDicQzI+oyYKEwAdUN8CpFjQ4gpWLVsKdl2iSoriT+6C9d5cNX6YZfuGhhrmzQHyphG435QpIW92tX6Ue473f6JmYUQqbrLTARzCNtwKOlD155tfn21+2cvMZPT0AkzHnZj5u2T4f0MH2qNEOrsZ1yr36+vk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a664109b-49a5-41d0-4e66-08d6d2c02cda
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 07:46:55.8980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0942
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SW4gdGhlIGNhc2Ugb2YgWDg2X1BBRSwgdW5zaWduZWQgbG9uZyBpcyB1MzIsIGJ1dCB0aGUgcGh5
c2ljYWwgYWRkcmVzcyB0eXBlDQpzaG91bGQgYmUgdTY0LiBEdWUgdG8gdGhlIGJ1ZyBoZXJlLCB0
aGUgbmV0dnNjIGRyaXZlciBjYW4gbm90IGxvYWQNCnN1Y2Nlc3NmdWxseSwgYW5kIHNvbWV0aW1l
cyB0aGUgVk0gY2FuIHBhbmljIGR1ZSB0byBtZW1vcnkgY29ycnVwdGlvbiAodGhlDQpoeXBlcnZp
c29yIHdyaXRlcyBkYXRhIHRvIHRoZSB3cm9uZyBsb2NhdGlvbikuDQoNCkZpeGVzOiA2YmEzNDE3
MWJjYmQgKCJEcml2ZXJzOiBodjogdm1idXM6IFJlbW92ZSB1c2Ugb2Ygc2xvd192aXJ0X3RvX3Bo
eXMoKSIpDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KQ2M6IE1pY2hhZWwgS2VsbGV5IDxt
aWtlbGxleUBtaWNyb3NvZnQuY29tPg0KUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogSnVsaWFuYSBS
b2RyaWd1ZWlybyA8anVsaWFuYS5yb2RyaWd1ZWlyb0BpbnRyYTJuZXQuY29tPg0KU2lnbmVkLW9m
Zi1ieTogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaHYv
Y2hhbm5lbC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9odi9jaGFubmVsLmMgYi9kcml2ZXJzL2h2
L2NoYW5uZWwuYw0KaW5kZXggMjMzODFjNDFkMDg3Li5hYWFlZTVmOTMxOTMgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2h2L2NoYW5uZWwuYw0KKysrIGIvZHJpdmVycy9odi9jaGFubmVsLmMNCkBAIC0z
OCw3ICszOCw3IEBADQogDQogc3RhdGljIHVuc2lnbmVkIGxvbmcgdmlydF90b19odnBmbih2b2lk
ICphZGRyKQ0KIHsNCi0JdW5zaWduZWQgbG9uZyBwYWRkcjsNCisJcGh5c19hZGRyX3QgcGFkZHI7
DQogDQogCWlmIChpc192bWFsbG9jX2FkZHIoYWRkcikpDQogCQlwYWRkciA9IHBhZ2VfdG9fcGh5
cyh2bWFsbG9jX3RvX3BhZ2UoYWRkcikpICsNCi0tIA0KMi4xNy4xDQoNCg==
