Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B377D05A7
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 04:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfJICoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 22:44:09 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:35872
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730354AbfJICoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 22:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5afQZMbA4ItJyTNTioqKzpVkhQg9F6v16DkIAMK2XHLA+UWO2L7K7fHaIdJHTkLdJn9QuJY6ujVVrQhZoieyaXdeA1vZU+n0eWZRwMg3Seu4SvaPSGgJLJD8UenbZ6JcJzN2zBlagLzFiZM0v0FzTZpNZ+Ga01nnvodjMz/nk/V03iiBaIMLLDtD3zTYZtRvmXQVTVBb9z3NPl8QtZ+uFAva8rAv5Gc1Idbc6Foiqvc1wXXWPhcd9sMwymThU6p2HcOQELBxC0eoNkTae8NyKXn0knl+tKCWyWojBiSYAKz+xZITKkLOVkVg9oLpC3C2P6SJ2SDilCil1LmmZLLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQ9ZijLRqhIP7+UKDUPnHP/K2r4W7Z/V1aw531tISSA=;
 b=JPhc8RpijfpYkm/mvrN2TjzJjg424EY8SgRgW38bOVT/r/bVGhFbucN1npvZgdrWh7Pr8SWMdRr/8IopcMPO0puDw+ZeCjzh0n/rNmEp7KLpNLjdEH3v0NEeZACanUyP2iuDjjubgAUs+jNNSizC3wIWN1HmK8K1nsLFHjblrhgi7kV8X42xhRnDfs1YucBfOT9TuOFBoafu+78Wq9Yz835lqX97IauccQlnGrkNdpfu9rVnLVd7GICMxZ3Kq815j6N0TOPKOM9Uead9Bd880orV2IVST7SF59h7es63uUMNX2cF/lI/SYVGtvmT2T1KW/vIxwQ4sYwMhe8kva+PsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQ9ZijLRqhIP7+UKDUPnHP/K2r4W7Z/V1aw531tISSA=;
 b=pSzyBoMw7sw54xb74G3DoDthSCSYNaMqqYVcITZR+pCIUvEbmZT3JHtbF/QjyjN01oBuvRuXmdYY2vkgJ9GvS+SVPOg1r4wRQGm6E3XFpLNDcofG0cuDuy8fmXNCZDaj89GyGn1MQaNBIxUdAcYP7jXbVhAd8yrkfaWCCo6cOZE=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3662.jpnprd01.prod.outlook.com (20.178.138.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Wed, 9 Oct 2019 02:44:05 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 02:44:05 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] PCI: rcar: Fix writing the MACCTLR register value
Thread-Topic: [PATCH] PCI: rcar: Fix writing the MACCTLR register value
Thread-Index: AQHVfcGtff3+BjoJJEeBF0T/hedvKadQ6yGAgACv//A=
Date:   Wed, 9 Oct 2019 02:44:05 +0000
Message-ID: <TYAPR01MB4544A787E2FC5BDE45FF7816D8950@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570529884-20888-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <2ae9793a-2500-496f-2e18-927237fbd02a@cogentembedded.com>
In-Reply-To: <2ae9793a-2500-496f-2e18-927237fbd02a@cogentembedded.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 509c3936-22dd-4fcf-a8de-08d74c628d21
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TYAPR01MB3662:
x-microsoft-antispam-prvs: <TYAPR01MB3662E22E6F81B78F9270184CD8950@TYAPR01MB3662.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(66476007)(186003)(2906002)(54906003)(110136005)(4326008)(14454004)(76116006)(316002)(33656002)(99286004)(256004)(66446008)(2501003)(64756008)(66556008)(26005)(6246003)(229853002)(76176011)(8676002)(81166006)(81156014)(486006)(66066001)(66946007)(86362001)(52536014)(74316002)(4744005)(7696005)(2201001)(7736002)(5660300002)(3846002)(8936002)(305945005)(6116002)(478600001)(6436002)(71190400001)(71200400001)(9686003)(102836004)(476003)(53546011)(6506007)(11346002)(25786009)(446003)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3662;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LjHidq3O1mkF+a+rAf6M2yo1PpT2Jh7vyVYlW0TWVFO5Jb1dsJOuE0F4VU/016vXuw4QrCJ6PDQ/ZMTvmIH/4tOXrHDUCTRYwMwVpbnxE9ihCoiM2MBIBU8MECC9UvIQVo8XMnQ5JG4BP6jX6DXq33Kx1XfrF65ZSS5Iw84ha+0pNhR4qB0Y8PAPnlDQ2bxoqR6iK91M5cJ8FKROGhivGvP3jWyRMQ/yT0TuZPzGjdQypAYe/HXUW+UYwj350C/DWRghUZSKfv/05A6KaFgB9TkeiddFB97FOYF+BYXbUCu7Rgpw+1O+vc2ERj6WyJfA7X6+fI7UqfgrR8Y2e/nfKZl7vcq1Yr6f+NkVIZKlGBkSE6rZDcYjs0gQivM/mghEh5sF5fvHIH28AwOV6VHGbnz1w8vUrjN9QFCphqfXfS4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509c3936-22dd-4fcf-a8de-08d74c628d21
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 02:44:05.3154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70cidffmCbtqebBeVeYfDTRDgdT/mctYL1ap/BDe98uVI3mWMTF3xIJfIPCngYtXJ0unMmZQXeACh5UaDBaMjSSq+UcvkAP9NC9Gj20GHmESCxfnRhP9Lr+arNZK1w5M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3662
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gU2VyZ2VpLXNhbiwNCg0KPiBGcm9tOiBTZXJnZWkgU2h0eWx5b3YsIFNlbnQ6IFdlZG5l
c2RheSwgT2N0b2JlciA5LCAyMDE5IDE6MTMgQU0NCj4gDQo+IEhlbGxvIQ0KPiANCj4gT24gMTAv
MDgvMjAxOSAwMToxOCBQTSwgWW9zaGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+IA0KPiA+IEFjY29y
ZGluZyB0byB0aGUgUi1DYXIgR2VuMi8zIG1hbnVhbCwgdGhlIGJpdCAwIG9mIE1BQ0NUTFIgcmVn
aXN0ZXINCj4gPiBzaG91bGQgYmUgd3JpdHRlbiBieSAwLiBUbyBhdm9pZCB1bmV4cGVjdGVkIGJl
aGF2aW9ycyBmcm9tIHRoaXMNCj4gDQo+ICAgIHMvYnkvdG8vLiBJJ2QgYWxzbyBtZW50aW9uIHRo
YXQgdGhpcyBiaXQgaXMgc2V0IHRvIDEgb24gcmVzZXQuDQoNClRoYW5rIHlvdSBmb3IgeW91ciBy
ZXZpZXchIEknbGwgZml4IGl0Lg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0K
DQo+ID4gaW5jb3JyZWN0IHNldHRpbmcsIHRoaXMgcGF0Y2ggZml4ZXMgaXQuDQo+ID4NCj4gPiBG
aXhlczogYjMzMjdmN2ZhZTY2ICgiUENJOiByY2FyOiBUcnkgaW5jcmVhc2luZyBQQ0llIGxpbmsg
c3BlZWQgdG8gNSBHVC9zIGF0IGJvb3QiKQ0KPiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz4gIyB2NC45Kw0KPiA+IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhp
cm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBTZXJnZWkgU2h0
eWx5b3YgPHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+DQo+IA0KPiBbLi4uXQ0K
PiANCj4gTUJSLCBTZXJnZWkNCg==
