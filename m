Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32896B87A6
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405922AbfISWut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:50:49 -0400
Received: from mail-eopbgr770073.outbound.protection.outlook.com ([40.107.77.73]:48772
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404705AbfISWut (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:50:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ueq1/4bI8deKu4Jp5kUew29HRMlLlrJL7jyeJKGYpUBxNx0h3dJm0jd+1pb3VnylBLK96iLowrYyVlonIyT8ktz/A8GGHwZE9OIPaSMI2pVwC672AIM1swmsNNYcq1juTzEYt/A1aQbGJei3bM53LMqmkHo9GES1Biy340i/uXV0oHmyP2vsETjigSDAucreV/bpdES7W4/YgQRJhSB3cy+9H6EnaRfpPkkNhXfcj4dSIg8JFb6kpWzQhxw4KKT0Syf8XuzOnGf/h/4oVnkHn3SlrEgukmGUveOQeSxgWZxuO4a60gP+Z5sZgT6XhH8WFNyF7nC2/M2y+GHusBmCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucn8UiPp/vfHwj1bCz6EI7Ykcgb5iZ2yfwCJAhWHpXo=;
 b=dGnw9s+8GcKNKLpPdj/hj6nQpV9jsSxjYO68k0vsnl3lemXyuYIGQ6RHBP4KJzO+BxE4rMoDKwIYeaUVqsl/rybwRy2d95VRXvF6g8MoGfDLgKDNMi1HvbzhZIUjWKwkjqAUmwgag8TO3dHRumcVIM7xPx/4a9SPyFJ5ko8bFVrctYyOsRxn0IULAwCqT33goXoe6IUsNps8BI55F8UAe+RDCq096raOr6ApTJqAUalXm1cn7LYsCAjbUMLV7HszzvfipeQ3ScUOnz1RGM7i9G4AtpdhNYvgcJ6xMpNwDHBIhCqQVKqZ1/CDPjoIAnjMMEK1h9kObwH3igCucUclCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucn8UiPp/vfHwj1bCz6EI7Ykcgb5iZ2yfwCJAhWHpXo=;
 b=Ph/fwCM7H2AdZVOCPd66oKToxMZVgIsoEp3AnrCKcVVZbXq5LWy9eMoTjt4v/pegWrdWHUQ0dXAj2ve9uRU72L3elrWBeGHjXkR6QSXgbVB5h4NJOI1Pwb/CiZOADEM8Rgg2eldoISmGCHUwKsTbpYz64CRfVeV4Cgmiz2dB6z4=
Received: from BYAPR05MB5048.namprd05.prod.outlook.com (20.178.0.210) by
 BYAPR05MB6247.namprd05.prod.outlook.com (20.178.196.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.10; Thu, 19 Sep 2019 22:50:46 +0000
Received: from BYAPR05MB5048.namprd05.prod.outlook.com
 ([fe80::3cb6:324:ff4f:fbaf]) by BYAPR05MB5048.namprd05.prod.outlook.com
 ([fe80::3cb6:324:ff4f:fbaf%6]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 22:50:46 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Adit Ranadive <aditr@vmware.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Pv-drivers <Pv-drivers@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] RDMA/vmw_pvrdma: Free SRQ only once
Thread-Topic: [PATCH] RDMA/vmw_pvrdma: Free SRQ only once
Thread-Index: AQHVbnXq/ZdDcwSMJkWe4MH4kt57+6czJxOA
Date:   Thu, 19 Sep 2019 22:50:46 +0000
Message-ID: <FEBDCEA8-CCA6-450A-B2B2-CCEAF082D4AE@vmware.com>
References: <1568848066-12449-1-git-send-email-aditr@vmware.com>
In-Reply-To: <1568848066-12449-1-git-send-email-aditr@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1d.0.190908
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vdasa@vmware.com; 
x-originating-ip: [66.170.99.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c407ad2-3603-4eb6-85b4-08d73d53cf69
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB6247;
x-ms-traffictypediagnostic: BYAPR05MB6247:|BYAPR05MB6247:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB6247F4D15A8FAC2DC06E233BCE890@BYAPR05MB6247.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(51914003)(189003)(199004)(486006)(11346002)(446003)(81156014)(305945005)(316002)(54906003)(58126008)(110136005)(476003)(14454004)(36756003)(99286004)(2501003)(25786009)(2616005)(8936002)(186003)(8676002)(7736002)(33656002)(81166006)(4326008)(478600001)(6116002)(26005)(86362001)(6436002)(6486002)(53546011)(5660300002)(2906002)(3846002)(66946007)(76116006)(2201001)(6246003)(256004)(229853002)(66446008)(64756008)(66556008)(66476007)(76176011)(4744005)(6512007)(102836004)(66066001)(71190400001)(71200400001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6247;H:BYAPR05MB5048.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WE7KDwgsdjaNdD8iFRQqe8rmfNcgnOQ5nn+ykVqeZho0yVy0t1kbDkZj7mBt2b78vVsVZtNH3Usl+IKDSKqLHkz3IEgFXLFgvGpVwhBBlfQtH8bHjT81kK9AE7SnD3agmQEQpBlCVRiZybMqP62VTP+INNjOMu69QdcYroKs2kE1kmJazDDaAOhK5wr4Hv9PWTRykTytxSglfQ7dj8r6V5h1DJwSXw8R2hC1h73nrQ31vIxGTwgKrCWsFTsSYDuMtNvA9CbAOTdbevxovlUuWPbz4vN5sQjhs3Ng9bv2GAOevHnFgJQQQAY9IE8mkhyIZnmXdVzagsLqJ8xLIZOnoLvzrAHg/yngGzEbGM9X683xG5hxOVu+l9GtpM2egFSzxveJcjyxGzZIq73JWuUhqcf1Ec7TsgwhAkpEOAPZ3wI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6391FEDC0AFB9408D30F24DBC63ED1B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c407ad2-3603-4eb6-85b4-08d73d53cf69
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 22:50:46.5275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vftHbycMwMkEvdS5HF9vsUpFuvnXb2kRbDEKlE4UQN9ozAnsLL34QQkkxDzNqD2fmL7yBDsWqbm/Wa4FFMh8jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6247
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOS8xOC8xOSwgNDowOCBQTSwgIkFkaXQgUmFuYWRpdmUiIDxhZGl0ckB2bXdhcmUuY29tPiB3
cm90ZToNCg0KPkFuIGV4dHJhIGtmcmVlIGNsZWFudXAgd2FzIG1pc3NlZCBzaW5jZSB0aGVzZSBh
cmUgbm93IGRlYWxsb2NhdGVkDQo+YnkgY29yZS4NCj4NCj5DYzogPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+DQo+Rml4ZXM6IDY4ZTMyNmRlYTFkYiAoIlJETUE6IEhhbmRsZSBTUlEgYWxsb2NhdGlv
bnMgYnkgSUIvY29yZSIpDQo+U2lnbmVkLW9mZi1ieTogQWRpdCBSYW5hZGl2ZSA8YWRpdHJAdm13
YXJlLmNvbT4NCj4tLS0NCj4gZHJpdmVycy9pbmZpbmliYW5kL2h3L3Ztd19wdnJkbWEvcHZyZG1h
X3NycS5jIHwgMiAtLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4NCj5kaWZm
IC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L3Ztd19wdnJkbWEvcHZyZG1hX3NycS5jIGIv
ZHJpdmVycy9pbmZpbmliYW5kL2h3L3Ztd19wdnJkbWEvcHZyZG1hX3NycS5jDQo+aW5kZXggNmNh
YzBjODhjZjM5Li4zNmNkZmJkYmQzMjUgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9pbmZpbmliYW5k
L2h3L3Ztd19wdnJkbWEvcHZyZG1hX3NycS5jDQo+KysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3
L3Ztd19wdnJkbWEvcHZyZG1hX3NycS5jDQo+QEAgLTIzMCw4ICsyMzAsNiBAQCBzdGF0aWMgdm9p
ZCBwdnJkbWFfZnJlZV9zcnEoc3RydWN0IHB2cmRtYV9kZXYgKmRldiwgc3RydWN0IHB2cmRtYV9z
cnEgKnNycSkNCj4gDQo+IAlwdnJkbWFfcGFnZV9kaXJfY2xlYW51cChkZXYsICZzcnEtPnBkaXIp
Ow0KPiANCj4tCWtmcmVlKHNycSk7DQo+LQ0KPiAJYXRvbWljX2RlYygmZGV2LT5udW1fc3Jxcyk7
DQo+IH0NCg0KVGhhbmtzIGZvciB0aGUgZml4LCBsb29rcyBnb29kIHRvIG1lLg0KUmV2aWV3ZWQt
Ynk6IFZpc2hudSBEYXNhIDx2ZGFzYUB2bXdhcmUuY29tPg0KDQotLQ0KdmlzaG51DQoNCg==
