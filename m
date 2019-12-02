Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB310E998
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 12:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfLBLju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 06:39:50 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:43658 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726149AbfLBLju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 06:39:50 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2019 06:39:49 EST
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 87A1640492;
        Mon,  2 Dec 2019 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1575286212; bh=krwSBqHJAqZ1evEHNomR0kyHL9+utzVU9vjgQb8Apc4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kv0WZIwNpSwmHa0Db88pA0m+bKrF7QLWV4xe7YLaFF04W11SsraF2EoI7hpR1u924
         EGpTCQabgCIbJZnsu+Pfp84daqQkMaEGK9U8J7aLtpuIl/jUo/58e364v5Fwx4vbbX
         RabsTVFdS3V0tByNOBQlBYD+N28OrV7UEyKgaKcjncyjR4RTI8i6MzH3tWnX7mzIXg
         pM6yv/0xdJzFv4LNl/dkXVDa08UC/yjAqUeISh39/9kasz2bqHW/VwjbE0mGy7ChbQ
         vxpGsMom7K19/JfXmfYlwI7GehlgBXfhd7gcmZsFhEVkzQbmXZqGBeKJzK/Ago3pDJ
         KB18n6LaPTe6Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id F26CEA0B1E;
        Mon,  2 Dec 2019 11:30:11 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Dec 2019 03:30:11 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 2 Dec 2019 03:30:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7D5dhOJ+73eaY+tZ1qF5ddVfQlxYE2erUd7RSv9Inm9FUMVy3saEL30jGdoT3zSMa2cK1vOpPQQWFf7sEhPLpAU88/BiT3spS5u2svuk24YA651h1l2vxM0miuqXolXtpJ+MOFzg+J/10tNK4AScVSY9UKJZFoEd068x63P5zHgZDDh/hiBisXRAM439M4E3c5/PlwkiHogIroMrpLI6KCYWoFI+zfXkEqS9SE3kKhZEPKPFD67+s8cTDp5hAtQjyJQPlCXi5vqMfzypNRSZPwglMJfi4n59kyXfR8YRHrZQz2hDY9AyLGQsvGl7YdGrQ01JCZx0lT6gDJMPLTDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krwSBqHJAqZ1evEHNomR0kyHL9+utzVU9vjgQb8Apc4=;
 b=J7iopRc/m7iU/rvadv69J6mEN1j2bsOSZKsw7yLdJsohOievAyOD1OUjA3uh+u0n5b4CINb15pKQw/YVgmoN5EsLa1fEjjKzB5Pq14U4y82M0DYcfR2OhrDCNJYpLyj/kSsHxg9vGNoM9ZkzpHP0JZ8Tw7gveBB3MZAVOlWZMp5wvZDBaJg2Y5QX6G6aYVvlDj9P4SPXa1kE4IVN3rqwljgwQWKrFFtgpSTTHwWEybIpHgSIkwQIHCtt6pIfIej0Dx9EPWnjiwWRMh6bjPQq4x2NfTbkPifFQXCr5rqN6EmkyEmjT9eluZdRr3/24PbnGaug1eL6LtwCkfr1BXhnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krwSBqHJAqZ1evEHNomR0kyHL9+utzVU9vjgQb8Apc4=;
 b=HC89+jGz+/4tSJ5yYWFwElv3yVAtXlAwYFHYzVQ2RxHkHzAxDj2BOV+cqmPAxoVHywP7T1x7oRpAq0yFSjUbLLg0hSjovPZDFaKTYhl0ghcqJDLIFFAGbZaiauFtZh1spfuEoCxOWasGK3GoQp5umgNPpQEnr5KoUtv0gZMfgPs=
Received: from BN7PR12MB2802.namprd12.prod.outlook.com (20.176.27.97) by
 BN7PR12MB2804.namprd12.prod.outlook.com (20.176.177.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Mon, 2 Dec 2019 11:30:10 +0000
Received: from BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::9859:2c51:52b9:dd1d]) by BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::9859:2c51:52b9:dd1d%7]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 11:30:10 +0000
From:   Tejas Joglekar <Tejas.Joglekar@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix logical condition
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix logical condition
Thread-Index: AQHVmel/GHfEKCMYIkmSDWBktmuPEaeWntgAgBA1CYA=
Date:   Mon, 2 Dec 2019 11:30:10 +0000
Message-ID: <3c556728-2934-a6f1-0093-4eec56fef86f@synopsys.com>
References: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
 <9dcb74d7-17ed-c81e-c723-3f4848532b8b@synopsys.com>
In-Reply-To: <9dcb74d7-17ed-c81e-c723-3f4848532b8b@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joglekar@synopsys.com; 
x-originating-ip: [198.182.52.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1afcd290-1775-4f79-2c2b-08d7771afd8c
x-ms-traffictypediagnostic: BN7PR12MB2804:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR12MB2804FB9240FBD9BD75A350CBA4430@BN7PR12MB2804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(346002)(136003)(376002)(199004)(189003)(99286004)(76116006)(26005)(36756003)(66476007)(66556008)(256004)(64756008)(66446008)(305945005)(11346002)(14444005)(14454004)(91956017)(6512007)(66946007)(478600001)(71200400001)(71190400001)(66066001)(31696002)(86362001)(25786009)(316002)(229853002)(54906003)(4326008)(76176011)(31686004)(6486002)(110136005)(446003)(5660300002)(2616005)(186003)(2906002)(6436002)(53546011)(8676002)(6246003)(81166006)(8936002)(81156014)(3846002)(6116002)(7736002)(6506007)(102836004)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR12MB2804;H:BN7PR12MB2802.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MtoFg9hksAImj+0blGnrYx8IoO7RkFZkA2vreKWST1fm5bekntSsC7ppl9YZutatjpyr/0MpTSYVv8E8UUXosrOYYtMzQIpw0z6HgbwAqG8jtS+Z8XWXtoNPQIi3/6u2Ur9Gh533I4AxTOPsXqWaHvJBWwdhksSLpVk+K4Cd/UyFE6yvxEoFjrtU++StWF2oJl5rAQkzNP0X1pnZhHPmhr6w3zwB+cbngaLwH5ugyMckHnoijsc/oFeyPLbtcfOFbgAcpGtYR83pC+lv/nUdMTOUaFEjmqPY5K8xx5s29N2Eun3TlnS36liFcO7CEpjotmYBzMmwGBtjwQkK2OIZ0tMkT3NSnmdzQJKQ9TBOOw+HNSnE+ICrqX+YleFCCTbhFfuwYku5nc1a++DiJhsE7yb7y5irFEnTtHkl1lznQmsi0gqM7lqpmLXM1Gv0Q1Hw
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA03D552CFA46442B9740DCC2C1A803D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afcd290-1775-4f79-2c2b-08d7771afd8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 11:30:10.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GFGoAI2gigOSciFrRtFA1mHGJnMCsTZNgjcU7qwkxYPNVyhPzWJBq1KFchFMaGMnMiddiRjpOPynuCwXpvFKng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2804
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQpHZW50bGUgcmVtaW5kZXIuLi4NCg0KT24gMTEvMjIvMjAxOSA5OjMwIEFNLCBUZWph
cyBKb2dsZWthciB3cm90ZToNCj4gSGVsbG8gQmFsYmksDQo+IMKgwqDCoMKgwqDCoCBUaGlzIGlz
IGEgY3JpdGljYWwgcGF0Y2ggZml4IGZvciBkd2MzLCBjYW4geW91IHBsZWFzZSByZXZpZXcgPw0K
PiDCoMKgwqDCoA0KPiBPbiAxMS8xMy8yMDE5IDExOjQ1IEFNLCBUZWphcyBKb2dsZWthciB3cm90
ZToNCj4+IFRoaXMgcGF0Y2ggY29ycmVjdHMgdGhlIGNvbmRpdGlvbiB0byBraWNrIHRoZSB0cmFu
c2ZlciB3aXRob3V0DQo+PiBnaXZpbmcgYmFjayB0aGUgcmVxdWVzdHMgd2hlbiBlaXRoZXIgcmVx
dWVzdCBoYXMgcmVtYWluaW5nIGRhdGENCj4+IG9yIHdoZW4gdGhlcmUgYXJlIHBlbmRpbmcgU0dz
LiBUaGUgJiYgY2hlY2sgd2FzIGludHJvZHVjZWQgZHVyaW5nDQo+PiBzcGxpdGluZyB1cCB0aGUg
ZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdHMoKSBmdW5jdGlvbi4NCj4+
DQo+PiBGaXhlczogZjM4ZTM1ZGQ4NGUyICgidXNiOiBkd2MzOiBnYWRnZXQ6IHNwbGl0IGR3YzNf
Z2FkZ2V0X2VwX2NsZWFudXBfY29tcGxldGVkX3JlcXVlc3RzKCkiKQ0KPj4NCj4+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2ZmLWJ5OiBUZWphcyBKb2dsZWthciA8am9n
bGVrYXJAc3lub3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy91c2IvZHdjMy9nYWRnZXQu
YyB8IDIgKy0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyBiL2RyaXZl
cnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+IGluZGV4IDg2ZGMxZGI3ODhhOS4uZTA3MTU5ZTA2Zjlh
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gKysrIGIvZHJp
dmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gQEAgLTI0ODUsNyArMjQ4NSw3IEBAIHN0YXRpYyBp
bnQgZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdChzdHJ1Y3QgZHdjM19l
cCAqZGVwLA0KPj4gIA0KPj4gIAlyZXEtPnJlcXVlc3QuYWN0dWFsID0gcmVxLT5yZXF1ZXN0Lmxl
bmd0aCAtIHJlcS0+cmVtYWluaW5nOw0KPj4gIA0KPj4gLQlpZiAoIWR3YzNfZ2FkZ2V0X2VwX3Jl
cXVlc3RfY29tcGxldGVkKHJlcSkgJiYNCj4+ICsJaWYgKCFkd2MzX2dhZGdldF9lcF9yZXF1ZXN0
X2NvbXBsZXRlZChyZXEpIHx8DQo+PiAgCQkJcmVxLT5udW1fcGVuZGluZ19zZ3MpIHsNCj4+ICAJ
CV9fZHdjM19nYWRnZXRfa2lja190cmFuc2ZlcihkZXApOw0KPj4gIAkJZ290byBvdXQ7DQo+IFRo
YW5rcyAmIFJlZ2FyZHMsDQo+DQo+IFRlamFzIEpvZ2xla2FyDQo+DQpUaGFua3MsDQoNClRlamFz
IEpvZ2xla2FyDQoNCg==
