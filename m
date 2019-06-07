Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ABF38257
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 03:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFGBBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 21:01:40 -0400
Received: from mail-eopbgr690131.outbound.protection.outlook.com ([40.107.69.131]:7174
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725784AbfFGBBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 21:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=concurrentrt.onmicrosoft.com; s=selector1-concurrentrt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HM2e9Rp9K0t4VVNSTmbyT0wUlp1pIV8AOfGL0EekRTc=;
 b=MGjxTtNzznCkIKj+hKngKOlDVnZX7gi6pxj/xrjjuk0BtG3zrFfvrrtu0l+EkVD+kdWacRzR5u53Q/IO9CQ7mFMRFIE/u7APeH5VGPuaExVek9XWwZKzO14fMo6Vv6SoY7mout45ixIwXKF50vqBgQ4va+y8Dh+b//ndxX1mo2w=
Received: from DM6PR11MB2570.namprd11.prod.outlook.com (20.176.99.12) by
 DM6PR11MB2602.namprd11.prod.outlook.com (20.176.99.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Fri, 7 Jun 2019 01:01:36 +0000
Received: from DM6PR11MB2570.namprd11.prod.outlook.com
 ([fe80::91ec:580:13d5:fe72]) by DM6PR11MB2570.namprd11.prod.outlook.com
 ([fe80::91ec:580:13d5:fe72%7]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 01:01:36 +0000
From:   Joe Korty <Joe.Korty@concurrent-rt.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alistair Strachan <astrachan@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [BUG 4.4.178] x86_64 compat mode futexes broken
Thread-Topic: [BUG 4.4.178] x86_64 compat mode futexes broken
Thread-Index: AQHVHKxw/Uv5M9zAE0qNS0uTrHGe4g==
Date:   Fri, 7 Jun 2019 01:01:36 +0000
Message-ID: <20190607010128.GB24007@zipoli.concurrent-rt.com>
References: <20190606211140.GA52454@zipoli.concurrent-rt.com>
 <20190606231130.GA69331@archlinux-epyc>
In-Reply-To: <20190606231130.GA69331@archlinux-epyc>
Reply-To: Joe Korty <Joe.Korty@concurrent-rt.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN3PR03CA0061.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::21) To DM6PR11MB2570.namprd11.prod.outlook.com
 (2603:10b6:5:c6::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joe.Korty@concurrent-rt.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.220.59.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a7615d2-d35a-4336-8953-08d6eae3b071
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR11MB2602;
x-ms-traffictypediagnostic: DM6PR11MB2602:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR11MB26020290F09B00EDEDC5496BA0100@DM6PR11MB2602.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(6916009)(1076003)(99286004)(186003)(26005)(508600001)(966005)(486006)(53936002)(44832011)(43066004)(6506007)(76176011)(3450700001)(386003)(72206003)(14444005)(52116002)(256004)(6306002)(6512007)(102836004)(5660300002)(446003)(71190400001)(2906002)(11346002)(476003)(71200400001)(3846002)(6116002)(316002)(54906003)(6436002)(86362001)(1411001)(6486002)(4326008)(6246003)(25786009)(33656002)(68736007)(14454004)(8676002)(66066001)(7736002)(305945005)(8936002)(81156014)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(81166006)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR11MB2602;H:DM6PR11MB2570.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: concurrent-rt.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QKceZSc8ei7fKQfsKmybSkzwH6cYpzVYHv9cd6pLInIpkFn/4aTz54rTOR5ev7t+3lctIAtLGgjDF2t3iJzsT//gjuQ7c1UxHD3w68huvU9ZnO5id3v6oyLQVDBy8ywqvAQIvUZbwUVq44najUYkpQAGvTbDeY9hvVDjkSsLUeq+CKNRhrszViW4cwNNs6hMMExqjimGwwvHzmUfe5EqQl+UnZR6teegsAoaGDnaSotZDjsF4OH7orYxNXcjtr5r4/TxpNpbdimrv20FLm+hA43KNe3aFXKbC4Dymlg3w4CkYZPy87UHxkwCcQBABlpe+j05kG/qtpYLHnYzEGF82mC8WO8xmP4JeFL4M+amQ12ryqXTHmBzCqbYp9KfPSHJTwT0q0slF5M78ypT1fGF6cyNk9pl0029aSbbAQbpHGw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E26024FD0DC36741851E2BC138571CA0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7615d2-d35a-4336-8953-08d6eae3b071
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 01:01:36.0858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38747689-e6b0-4933-86c0-1116ee3ef93e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Joe.Korty@concurrent-rt.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2602
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 04:11:30PM -0700, Nathan Chancellor wrote:
> On Thu, Jun 06, 2019 at 09:11:43PM +0000, Joe Korty wrote:
> > Starting with 4.4.178, the LTP test
> >=20
> >   pthread_cond_wait/2-3
> >=20
> > when compiled on x86_64 with 'gcc -m32', started failing.  It generates=
 this log output:
> >=20
> >   [16:18:38]Implementation supports the MONOTONIC CLOCK but option is d=
isabled in test.          =20
> >   [16:18:38]Test starting
> >   [16:18:38] Process-shared primitive will be tested
> >   [16:18:38] Alternative clock for cond will be tested
> >   [16:18:38]Test 2-3.c FAILED: The child did not own the mutex inside t=
he cleanup handler
> >=20
>=20
> What is the exact build command + test case command? I'd like to
> reproduce this myself.
>=20
> > A git bisection between 4.4.177..178 shows that this commit is the culp=
rit:
> >=20
> >   Git-Commit: 79739ad2d0ac5787a15a1acf7caaf34cd95bbf3c
> >   Author: Alistair Strachan <astrachan@google.com>
> >   Subject: [PATCH] x86: vdso: Use $LD instead of $CC to link
> >=20
>=20
> Have you tested 4.4.180? There were two subsequent fixes to this patch
> in 4.4:

Hi Nathan,
I started with 4.4.179-rt181 and worked backwards from there.  Per your
suggestion, I tried 4.4.180 and it does work properly.

Thanks,
Joe




> 485d15db01ca ("kbuild: simplify ld-option implementation")
> 07d35512e494 ("x86/vdso: Pass --eh-frame-hdr to the linker")
>=20
> > And, indeed, when I back this patch out of 4.4.178 proper, the above te=
st
> > passes again.
> >=20
> > Please consider backing this patch out of linux-4.4.y, and from master,=
 and from
> > any other linux branch it has been backported to.
> >=20
>=20
> So this is broken in mainline too?
>=20
> > PS: In backing it out of 4.4.178, I first backed out
> >=20
> >    7c45b45fd6e928c9ce275c32f6fa98d317e6f5ee
> >   =20
> > This is a follow-on vdso patch which collides with the
> > patch we are interested in removing.  As it claims to be
> > only removing redundant code, it probably should never
> > have been backported in the first place.
>=20
> While it is redundant for ld.bfd, it causes a build failure with the
> release version of ld.lld:
>=20
> https://github.com/ClangBuiltLinux/linux/issues/31
>=20
> Cheers,
> Nathan
