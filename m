Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D309163FF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEGMv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:51:56 -0400
Received: from mail-eopbgr780114.outbound.protection.outlook.com ([40.107.78.114]:48320
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726348AbfEGMvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 08:51:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=E+hA16GAMRZHIHZAs4CR/MpAVOXzHu/EmLXlhi/ZbQPJAz/TI1cFlkxrEtq6w4LRB6VJHds8DlzkR2ACgbdRHSLGPpZ1ytJc6RcCXjkwJa54VOWsUKLDg0jR/6XsY5+5HjTBR1lNxLnlYn5sLLIl8ppbeSNYVpw5zsK0vZd2A/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Ky181NJatpNjnAsO3YPhF0oKBEzAmcIwNcbi6h5yY=;
 b=CVawSngQnpKP9858lGqPvgCpRaelaXy2NtVUVYCOgaBs1owCKvrvL9RESmU7xltnnuRIY5sG+p2/quLYonzzWNJe9EpQeWqxcSVB4gwaLL3xOS11uVFA3o8AMjAa4JgkEZBpPSnTD3VVYAN93U81/hAVNwe+7MotlW96GDBmzRM=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Ky181NJatpNjnAsO3YPhF0oKBEzAmcIwNcbi6h5yY=;
 b=J4MSG3Ty3FYAGby5SNsEF0eAVXGWZOOOvQetMdJBR47DDt58DIlDnGcI6VAZdqxxqR8kzDaXyHcfE6a9wISKOwtXcx0PEqu9Uw4IAAfPpq+tG6wWn25Fwkm47epb7NUPWjofp61aIgb4KkvxGNFnt1WE+TmYf+AOn2Lnrk8NZBM=
Received: from DM5PR2101MB0918.namprd21.prod.outlook.com (52.132.132.163) by
 DM5PR2101MB0902.namprd21.prod.outlook.com (52.132.132.159) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.2; Tue, 7 May 2019 12:51:52 +0000
Received: from DM5PR2101MB0918.namprd21.prod.outlook.com
 ([fe80::25b3:455b:5e85:3c60]) by DM5PR2101MB0918.namprd21.prod.outlook.com
 ([fe80::25b3:455b:5e85:3c60%3]) with mapi id 15.20.1900.002; Tue, 7 May 2019
 12:51:52 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "juliana.rodrigueiro@intra2net.com" 
        <juliana.rodrigueiro@intra2net.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Thread-Topic: [PATCH] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Thread-Index: AQHVBKkKTisq9OloE02W7qrjLXJSBaZfnaGA
Date:   Tue, 7 May 2019 12:51:51 +0000
Message-ID: <DM5PR2101MB09188A7DB0777CD50333F94ED7310@DM5PR2101MB0918.namprd21.prod.outlook.com>
References: <1557215147-89776-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1557215147-89776-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-07T12:51:49.1646513Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=98dfddef-5679-453b-aaa2-4ac33bc314a9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 038d20fb-c55e-4c35-44c5-08d6d2eac710
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR2101MB0902;
x-ms-traffictypediagnostic: DM5PR2101MB0902:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR2101MB0902F772A4FB05CCF3A0844CD7310@DM5PR2101MB0902.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(396003)(346002)(39860400002)(199004)(189003)(4744005)(10090500001)(71200400001)(71190400001)(86362001)(86612001)(7696005)(256004)(33656002)(186003)(14454004)(81156014)(81166006)(8936002)(22452003)(1511001)(5660300002)(99286004)(54906003)(110136005)(66066001)(316002)(8990500004)(8676002)(2201001)(76176011)(53936002)(9686003)(55016002)(6116002)(7416002)(229853002)(74316002)(68736007)(3846002)(102836004)(7736002)(6246003)(6436002)(2501003)(305945005)(4326008)(2906002)(446003)(6506007)(478600001)(10290500003)(486006)(476003)(52536014)(11346002)(26005)(25786009)(66446008)(73956011)(76116006)(66476007)(66556008)(66946007)(64756008)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0902;H:DM5PR2101MB0918.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b10gQ6SjZVqoPEjp5oLD2AbPp/q6XqYXeFaPDuA6O92UH03zjJh6oYy3OT8xkCHo73+GSWYhoVvh5vnJXlgB60uHFQyfQZJGHbGOF6ziYMagdlyxC3iDop91gzGqPzrzlBXkhaZWCtzjckD/+E6nwc2eWuANlnsVg+kkrKPJZbGo/fDDE6FG/jU+8jSu904TtlR+ogtnruzOALlgghJff4m8zuv2cNvktGRNbBmUXko7m/VdKXg3cipuX0xxqWrvPfxZahk9Li4FFv60Ly7qYwRVT/Q7NMsTIaH7NqFJnBnT0Ygq+J0MfFWLC9VO1ZZZwFsPL3pAIkIr9RByD9qyasBluycADonSmrdu2mN2IHpJD+M3vGest/amGj4d0XUJPICCqM7LkiJKy5hS7hg04ccVFFgW+ANMXJa0xjAArkg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038d20fb-c55e-4c35-44c5-08d6d2eac710
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 12:51:51.0333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0902
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4gU2VudDogVHVlc2RheSwgTWF5
IDcsIDIwMTkgMTI6NDcgQU0NCj4gDQo+IEluIHRoZSBjYXNlIG9mIFg4Nl9QQUUsIHVuc2lnbmVk
IGxvbmcgaXMgdTMyLCBidXQgdGhlIHBoeXNpY2FsIGFkZHJlc3MgdHlwZQ0KPiBzaG91bGQgYmUg
dTY0LiBEdWUgdG8gdGhlIGJ1ZyBoZXJlLCB0aGUgbmV0dnNjIGRyaXZlciBjYW4gbm90IGxvYWQN
Cj4gc3VjY2Vzc2Z1bGx5LCBhbmQgc29tZXRpbWVzIHRoZSBWTSBjYW4gcGFuaWMgZHVlIHRvIG1l
bW9yeSBjb3JydXB0aW9uICh0aGUNCj4gaHlwZXJ2aXNvciB3cml0ZXMgZGF0YSB0byB0aGUgd3Jv
bmcgbG9jYXRpb24pLg0KPiANCj4gRml4ZXM6IDZiYTM0MTcxYmNiZCAoIkRyaXZlcnM6IGh2OiB2
bWJ1czogUmVtb3ZlIHVzZSBvZiBzbG93X3ZpcnRfdG9fcGh5cygpIikNCj4gQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQu
Y29tPg0KPiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBKdWxpYW5hIFJvZHJpZ3VlaXJvIDxqdWxp
YW5hLnJvZHJpZ3VlaXJvQGludHJhMm5ldC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERleHVhbiBD
dWkgPGRlY3VpQG1pY3Jvc29mdC5jb20+DQoNClJldmlld2VkLWJ5OiAgTWljaGFlbCBLZWxsZXkg
PG1pa2VsbGV5QG1pY3Jvc29mdC5jb20+DQo=
