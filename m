Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B45D172C
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfJIRyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:54:40 -0400
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:29216
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729535AbfJIRyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:54:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5z2L+1cegp+ptmwv+n0LM46kQsKbp1dS5TgDNPSiGcx540vXrk/XsMtuMI2yI2B8jcbj3at8PoEJw9iNf65nZ0TozYGMiwBK7yIwsPs6P31Hro6s9IwxtUfjMl4r0gbn6v/CfALDL/9fwUjRlEa0O2SUKNhFtYGkuMbMYEKg5mLMhuRXAw9RRhABSYZANuUpMYa27F2d9r7lnfbq3ONfrTMy+P/jfYIdvzXGFolCLS+Li0ItlFrKc96ZBYNQ5VmmVY1veLfxKBqmQ2UJr2LLs311m6q6YxVBer+pNg2RqJAlFFlAFKDpgBxixK6xMHPCrSTmslF/az5pfYyZ+KSfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNf19uSaFvRzlK3URGGqk9nMg+f4MCHVMMiTQ+Jg87U=;
 b=ATnNew/nnYTZEzdXkY9yQ4YEoGFd9g+FY1bqOspZHCDuYyHqDL8qrJY+X5UkaJ6WqhqhT/pexf1VdTvCrgzbrJBjW7FNP/VUxfvgoTKwKFhpvjsH+Epg/MDzILwyZwOZw8Tr5FmzBdBmzC/aywRG7FzbAgHbx31QiWqPfl2Tk5a1tzixZd+12UZjJqQ8FvrGEBUwsPrUhf0nn2rqLT0XqOTAEarFFySmYh1a+hCpedYaDuBhTHJMg2Ul5GmbWf8DJ95CV1J9bu/RYHthfABTC/JiQsswV/DzxYfYaDFEt0F6pSQYZfuVhWG8fL/M8+8AWitqSo22+su6ajPaRw4myQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNf19uSaFvRzlK3URGGqk9nMg+f4MCHVMMiTQ+Jg87U=;
 b=Xkn2ElUeUSWwZ7AWkkzP7i2UOllhK/t+JvRl5B0SUspk4kxp6nDTTRRceblRlme+xsP71yER1PpTB+AubODLEBFiWFHymzPV5ulr167bWK6mHA/IvhhLBlKfNx6V6iBGsa/aPiNPAzGlTiiaDkkCUtnyCDuoC6E4cDbKZP780mY=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6992.namprd05.prod.outlook.com (52.135.37.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.13; Wed, 9 Oct 2019 17:54:37 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5%6]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 17:54:36 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "dchinner@redhat.com" <dchinner@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steven Rostedt <srostedt@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Thread-Topic: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Thread-Index: AQHVeJ883Cj90kJZYkWUHWw9u04UBadRD8wAgAHwX4A=
Date:   Wed, 9 Oct 2019 17:54:36 +0000
Message-ID: <F4C3D25C-A8FC-4A31-8CC2-1ABBA6CDF1C1@vmware.com>
References: <1569965031-30745-1-git-send-email-akaher@vmware.com>
 <20191008174758.GA3013565@kroah.com>
In-Reply-To: <20191008174758.GA3013565@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [2401:4900:3315:f731:3d2d:917e:c072:18bd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ced001e-1ed8-4f75-2dde-08d74ce1c00b
x-ms-traffictypediagnostic: MN2PR05MB6992:|MN2PR05MB6992:|MN2PR05MB6992:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB69927B80FBDB916E8C5ABFB0BB950@MN2PR05MB6992.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:289;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(199004)(189003)(476003)(54906003)(102836004)(8676002)(486006)(6506007)(6116002)(14454004)(6246003)(11346002)(446003)(478600001)(36756003)(316002)(81156014)(4744005)(81166006)(86362001)(2906002)(2616005)(186003)(46003)(229853002)(76176011)(66556008)(64756008)(66446008)(66476007)(8936002)(6512007)(33656002)(76116006)(91956017)(6486002)(6436002)(66946007)(7736002)(256004)(4326008)(99286004)(305945005)(25786009)(14444005)(5660300002)(6916009)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6992;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mqzhw+6DnvWFe0ehF4AWs4WarGOuFl8SmKs/Dlrt3g05QrHMx+QtjEkszOLNGui4VqAqmo0EjN+RGrNbaqLPCpFwMQeksM/SYFbJ5pR5l3d3zLysNCDXYe42WZxkhMicYDZgwaW7Zx3zJgpaBISvGZljUJP9F8P5d/hXg+fjvgElk82CKudAJdrh6VHgKl4hFHgHoSl+JSgw4HEmjUf3nSyziG0BJEG5+TsrqOfDG71eyPZOuvlxxJI8zi+VjOyvptYPdD+03N8F3+9dosTBuQ8/utYlvjvhBsbLI0ifMBIYe3nEhBOuYA800eB9592GCU9n/uxVKqJGaK5OWLsgL72rJt3pZrRaZgAXj79q0/RdMiKYeeTK2B/6mlAwzf8c7QcL3jAW5OXY8uisGkjWnBedVyP4nfbmNu6cgElEJoI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DCC45E6566CF74B9E8AF37797DD65E6@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ced001e-1ed8-4f75-2dde-08d74ce1c00b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 17:54:36.6876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QMYjJfwXGgVg9G3FPXgY+hsuFm6HMmOeDnvMTAjLowsmUfKrk7L2W+vo751jfLSrKw/w4m8IisciRFq59kzBFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6992
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDA4LzEwLzE5LCAxMToxOCBQTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZz4gd3JvdGU6DQoNCj4gT24gV2VkLCBPY3QgMDIsIDIwMTkgYXQgMDI6NTM6NTFB
TSArMDUzMCwgQWpheSBLYWhlciB3cm90ZToNCj4gPiBGcm9tOiBEYXZlIENoaW5uZXIgPGRjaGlu
bmVyQHJlZGhhdC5jb20+DQo+ID4gDQo+ID4gY29tbWl0IGM5ZmJkN2JiYzIzZGJkZDczMzY0YmU0
ZDA0NWU1ZDM2MTJjZjZlODIgdXBzdHJlYW0uDQogICAgDQo+IFlvdSBoYXZlIHNlbnQgYSA0LjQu
eSBhbmQgNC45LnksIGJ1dCB3aGF0IGFib3V0IDQuMTQueT8gIEkgY2FuJ3QgdGFrZQ0KPiB0aGlz
IHBhdGNoIGZvciB0aGUgb2xkZXIga2VybmVscyB3aXRob3V0IGEgNC4xNC55IHBhdGNoLCBzb3Jy
eS4gIFdlDQo+IGRvbid0IHdhbnQgYW55b25lIHRvIHVwZ3JhZGUgYW5kIHRoZW4gaGl0IGEgZml4
ZWQgYnVnLg0KDQpTZW50IGZvciA0LjE0LnkgYXMgd2VsbC4gVGhhbmtzIGZvciBzcGVjaWZ5aW5n
IGFib3V0IDQuMTQueSBmb3IgdGhpcyBwYXRjaC4NCg0KLUFqYXkNCiAgICANCj4gdGhhbmtzLA0K
PiAgICANCj4gZ3JlZyBrLWgNCiAgICANCg0K
