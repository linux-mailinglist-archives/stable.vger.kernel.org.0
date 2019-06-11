Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0574185B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 00:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406846AbfFKWnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 18:43:52 -0400
Received: from mail-eopbgr730116.outbound.protection.outlook.com ([40.107.73.116]:31686
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388277AbfFKWnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 18:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFUo8KsZ//Iljw1bk5KEFdmtygtVYJ4THbCVnjjBviE=;
 b=nXq2T2JZ+MQnshxlKb5aeqycFQHh8D+TyEN4bOWQqp7vqaU9Qxf5nlTwUP0yVS/ZiopndixLGEApY3Hx+oTan6NzGikkx3Zt0SVh4VaajM4sk0bSSwQweYHvrKiEdkMKM7PpPFVwsP69yxHc4tsugGUxMC+qQYCsSMcX2sUn8ao=
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com (10.171.214.23) by
 CY4PR2201MB1368.namprd22.prod.outlook.com (10.171.214.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Tue, 11 Jun 2019 22:43:49 +0000
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::d571:f49f:6a5c:4962]) by CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::d571:f49f:6a5c:4962%7]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 22:43:49 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC:     Hauke Mehrtens <hauke@hauke-m.de>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Julien Cristau <jcristau@debian.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Topic: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Thread-Index: AQHVFXd9GkRqXxEIYUuNu8zTlmfmBqaVoRSAgACQ2YCAAPFmgA==
Date:   Tue, 11 Jun 2019 22:43:49 +0000
Message-ID: <20190611224347.zo4ulzyohrkhbyyu@pburton-laptop>
References: <20190528170444.1557-1-paul.burton@mips.com>
 <9e5c6f1a-b4a9-dbae-6314-aeb08f31c8aa@hauke-m.de>
 <20190611081947.GA11513@alpha.franken.de>
In-Reply-To: <20190611081947.GA11513@alpha.franken.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To CY4PR2201MB1272.namprd22.prod.outlook.com
 (2603:10b6:910:6e::23)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 291d69d0-1c12-4619-7ff5-08d6eebe450b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR2201MB1368;
x-ms-traffictypediagnostic: CY4PR2201MB1368:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY4PR2201MB1368D5FF9C872BBF096BBAE2C1ED0@CY4PR2201MB1368.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(7736002)(66946007)(81166006)(73956011)(33716001)(81156014)(8936002)(256004)(64756008)(66556008)(68736007)(66446008)(8676002)(66476007)(52116002)(6916009)(4326008)(44832011)(1076003)(25786009)(99286004)(5660300002)(14454004)(9686003)(6512007)(54906003)(478600001)(58126008)(16799955002)(42882007)(966005)(71200400001)(71190400001)(316002)(6116002)(476003)(446003)(26005)(66066001)(6486002)(6246003)(186003)(76176011)(53546011)(6506007)(6306002)(2906002)(6436002)(229853002)(305945005)(11346002)(386003)(102836004)(486006)(53936002)(347745004)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR2201MB1368;H:CY4PR2201MB1272.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S4noukOT7x5OrXB5ucZaOpHsyQ17EXfLciIw1ElpO5rzHXt97QBvTOyT6nuwVKhncXPKPIxNsvmvV6Fi3hGRF4KUtYxtBzg5vWhxoXaUmyp7JeyeZ7J/vEK3QUn0AvsztWE0B5GzPJUJ2l1lB56U37rh3ilD8mum8KY7jTzuarnd9IHNMMxZmvcv599rPhfBjici8XF4PSF3IuUKUWylzDFeNH3Oyt6Q1TYU00USmnPgxp1hZ1T27+lPWxj9CAYJMCUibDkCWf+HHHaP48q1zI9hAqQrL4nqG3tX+XAvdfQFg54wZDxozsJNIdpsnpMxK5x12DiKM7Fo20ZKI3BBQ//eMqDxXQoXUNwSx7cT/gmfUR6wvnOd1sqJYzTlkBJGvnViSHyVrcimsve/ix8Z448by7behS+dxsqGDKKxfLc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D7AECCCC17AB34E9C0CCEDE0FF92E44@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291d69d0-1c12-4619-7ff5-08d6eebe450b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 22:43:49.5217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR2201MB1368
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hauke & Thomas,

On Tue, Jun 11, 2019 at 10:19:47AM +0200, Thomas Bogendoerfer wrote:
> On Tue, Jun 11, 2019 at 01:41:21AM +0200, Hauke Mehrtens wrote:
> > On 5/28/19 7:05 PM, Paul Burton wrote:
> > > diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
> > > index 2f616ebeb7e0..7755a1fad05a 100644
> > > --- a/arch/mips/mm/mmap.c
> > > +++ b/arch/mips/mm/mmap.c
> > > @@ -203,6 +203,11 @@ unsigned long arch_randomize_brk(struct mm_struc=
t *mm)
> > > =20
> > >  int __virt_addr_valid(const volatile void *kaddr)
> > >  {
> > > +	unsigned long vaddr =3D (unsigned long)vaddr;
>=20
> the second vaddr should be better kaddr

D'oh..! Right you are...

Returning false all the time is enough to silence the hardened usercopy
warnings but clearly not the right behaviour.

> > Someone complained that this compiled to a constant "return 0" for him:
> > https://bugs.openwrt.org/index.php?do=3Ddetails&task_id=3D2305#comment6=
554
> >=20
> > I just checked this on a unmodified 5.2-rc4 with the xway_defconfig and
> > I get this:
> >=20
> > 0001915c <__virt_addr_valid>:
> >    1915c:       03e00008        jr      ra
> >    19160:       00001025        move    v0,zero
> >=20
> > Is this intended?
>=20
> I don't think so. Interesting what the compiler decides to do here.

Yes, this is equivalent to using uninitialized_var() but I'm surprised
the code got discarded entirely...

Thanks,
    Paul
