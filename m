Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04A25D58D
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfGBRq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 13:46:59 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:31008
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfGBRq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 13:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKrxzGEfgC/NFJCq6+fmtSWANUJEAldqOq1UQ2lA/xQ=;
 b=ZiOw17Oa9ynZHDMUx6RiEulW7DxPd2FEVvAUePXGQ9G1l879OZHCimmq7Rygrp/20AI3tKZwuu5Z0Liy0KM8VFHfnR8CVoy+7B9bTfEAgt+LymTlfqGD8vBTm5mtkFQjMByX+z1kCw1Ou94WyrM2Lvo9a74Q7GmxUqRhy+xrUTE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1420.namprd12.prod.outlook.com (10.168.239.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 17:46:54 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 17:46:54 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Cfir Cohen <cfir@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp/gcm - use const time tag comparison.
Thread-Topic: [PATCH v2] crypto: ccp/gcm - use const time tag comparison.
Thread-Index: AQHVMPw13VShZb2ZG0mtCEYORUtnoKa3mkoA
Date:   Tue, 2 Jul 2019 17:46:53 +0000
Message-ID: <aa19bd59-7b76-b8ad-3f25-42efbfb7fd29@amd.com>
References: <20190702173256.50485-1-cfir@google.com>
In-Reply-To: <20190702173256.50485-1-cfir@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:805:3e::33) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e50e804a-1b8e-49de-b36e-08d6ff1544ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1420;
x-ms-traffictypediagnostic: DM5PR12MB1420:
x-microsoft-antispam-prvs: <DM5PR12MB142050A723D046C9C3672BB4FDF80@DM5PR12MB1420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(199004)(189003)(66556008)(66946007)(66476007)(73956011)(68736007)(3846002)(99286004)(66446008)(64756008)(6116002)(4744005)(7736002)(478600001)(66066001)(72206003)(36756003)(305945005)(8936002)(31686004)(81156014)(5660300002)(81166006)(4326008)(25786009)(54906003)(76176011)(2906002)(11346002)(6512007)(186003)(6436002)(446003)(14444005)(486006)(53936002)(256004)(102836004)(6506007)(386003)(53546011)(2616005)(476003)(26005)(8676002)(6486002)(71190400001)(52116002)(229853002)(14454004)(31696002)(6246003)(71200400001)(316002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1420;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z+Yntg6EzFCNnvQX+L8Jtnw8J1z4q/dpq8kBLudSBCPOwjvQr6heESzRjLzvKoOcLrEoCLVyj4OVnLkYLSCBoW+J52CIQJNHdODYVN6QVtyvBkf7GvVMSrmJiwSldZW3zCFTmJTBFyuYuI+EnnU4gI6i14PFz2E5YWq29+nbKfs98o7jmtlD6lw7pUt1FJIdJ91b55p/Q1By8fz0CJno90DVt8rJLpHF8iGb6pE00oPzk6mQY9IVufdchgq41K/km0jx+RocpB53cDVFIfVhGwSBxYK+uuNF0ZIaA8nOqtH+sfqB7Ttn9dOOouIeGXJfJH7isMfbDxgYO3wQZ8IOFHDgo8uYRIDJSC2oCPTDTa0Iz/1w2vznDC0kxk8MWxqvXY8Vtf/o/Nf1OyQDXli4hkfWnBZd84xuQkmlC0ZXgHw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3383CC4B34FCFC47B2A45BEA5C4D5FD2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50e804a-1b8e-49de-b36e-08d6ff1544ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 17:46:53.8955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1420
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8yLzE5IDEyOjMyIFBNLCBDZmlyIENvaGVuIHdyb3RlOg0KPiBBdm9pZCBsZWFraW5nIEdD
TSB0YWcgdGhyb3VnaCB0aW1pbmcgc2lkZSBjaGFubmVsLg0KPiANCj4gRml4ZXM6IDM2Y2Y1MTVi
OWJiZSAoImNyeXB0bzogY2NwIC0gRW5hYmxlIHN1cHBvcnQgZm9yIEFFUyBHQ00gb24gdjUgQ0NQ
cyIpDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC4xMisNCj4gU2lnbmVkLW9m
Zi1ieTogQ2ZpciBDb2hlbiA8Y2ZpckBnb29nbGUuY29tPg0KDQpBY2tlZC1ieTogR2FyeSBSIEhv
b2sgPGdob29rQGFtZC5jb20+DQoNCj4gLS0tDQo+ICAgZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1v
cHMuYyB8IDMgKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMg
Yi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+IGluZGV4IGRiOGRlODlkOTkwZi4uNjMz
NjcwMjIwZjZjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+
ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMNCj4gQEAgLTg0MCw3ICs4NDAsOCBA
QCBzdGF0aWMgaW50IGNjcF9ydW5fYWVzX2djbV9jbWQoc3RydWN0IGNjcF9jbWRfcXVldWUgKmNt
ZF9xLA0KPiAgIAkJaWYgKHJldCkNCj4gICAJCQlnb3RvIGVfdGFnOw0KPiAgIA0KPiAtCQlyZXQg
PSBtZW1jbXAodGFnLmFkZHJlc3MsIGZpbmFsX3dhLmFkZHJlc3MsIEFFU19CTE9DS19TSVpFKTsN
Cj4gKwkJcmV0ID0gY3J5cHRvX21lbW5lcSh0YWcuYWRkcmVzcywgZmluYWxfd2EuYWRkcmVzcywN
Cj4gKwkJCQkgICAgQUVTX0JMT0NLX1NJWkUpID8gLUVCQURNU0cgOiAwOw0KPiAgIAkJY2NwX2Rt
X2ZyZWUoJnRhZyk7DQo+ICAgCX0NCj4gICANCj4gDQoNCg==
