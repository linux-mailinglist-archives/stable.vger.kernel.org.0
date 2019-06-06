Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347E537F47
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 23:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfFFVLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 17:11:47 -0400
Received: from mail-eopbgr680091.outbound.protection.outlook.com ([40.107.68.91]:13792
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfFFVLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 17:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=concurrentrt.onmicrosoft.com; s=selector1-concurrentrt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ga2w1lvislvs/1ugMXQXPRQsUJmQCa3G+UvlfkS/Cj0=;
 b=pXXIskcMU6eh1vbo+torp6zCjOEl0BzblbLWPS3Xt0nAFiaPMMl7mdJ3+zCU8Qh4j77rWiaOjelpgVoHlWp9vsoqhEgdMk4kbBBDNPE+Wc7oh3pEE5LoIHakZV4BEEBQs+dwgR9Ejxy6PZPJPLuP9CXneYFmlsYdvuvXb96wZn8=
Received: from DM6PR11MB2570.namprd11.prod.outlook.com (20.176.99.12) by
 DM6PR11MB3420.namprd11.prod.outlook.com (20.177.219.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 21:11:43 +0000
Received: from DM6PR11MB2570.namprd11.prod.outlook.com
 ([fe80::91ec:580:13d5:fe72]) by DM6PR11MB2570.namprd11.prod.outlook.com
 ([fe80::91ec:580:13d5:fe72%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 21:11:43 +0000
From:   Joe Korty <Joe.Korty@concurrent-rt.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Alistair Strachan <astrachan@google.com>
Subject: [BUG 4.4.178] x86_64 compat mode futexes broken
Thread-Topic: [BUG 4.4.178] x86_64 compat mode futexes broken
Thread-Index: AQHVHKxw/Uv5M9zAE0qNS0uTrHGe4g==
Date:   Thu, 6 Jun 2019 21:11:43 +0000
Message-ID: <20190606211140.GA52454@zipoli.concurrent-rt.com>
Reply-To: Joe Korty <Joe.Korty@concurrent-rt.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:404:f7::28) To DM6PR11MB2570.namprd11.prod.outlook.com
 (2603:10b6:5:c6::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joe.Korty@concurrent-rt.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.220.59.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f9b85b1-dad5-431a-0399-08d6eac39344
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR11MB3420;
x-ms-traffictypediagnostic: DM6PR11MB3420:
x-microsoft-antispam-prvs: <DM6PR11MB3420D249707E5C1E6E0BAD51A0170@DM6PR11MB3420.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(39840400004)(376002)(396003)(199004)(189003)(25786009)(2351001)(6486002)(486006)(316002)(7736002)(86362001)(71200400001)(476003)(3450700001)(5660300002)(8676002)(44832011)(8936002)(54906003)(53936002)(1730700003)(99286004)(43066004)(4326008)(2906002)(6916009)(26005)(81166006)(5640700003)(68736007)(71190400001)(81156014)(256004)(66556008)(73956011)(64756008)(66476007)(66446008)(14444005)(6506007)(386003)(14454004)(66946007)(33656002)(102836004)(72206003)(508600001)(66066001)(6116002)(186003)(6512007)(2501003)(3846002)(305945005)(6436002)(1076003)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR11MB3420;H:DM6PR11MB2570.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: concurrent-rt.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BptdrQIAedtDhww6anPnNGqX5UkfEiCRcvpROGAJ3TFnR2Q7OkyE05XvQsXNA8Xn2SOncFCi6cqFLZVpzT4TmY3qgyM9KqUcKzSonihbSO1eNSFBe7ITapWVUVsYLzL9t74atfN1OvScLwzo1mPfZ1rDguQfVm41Q4RGBMzaw/VzTokBPY6ywdQV/6YxXRJq4DisQDdSDVC8NK2TMq0hxVDDxbP1VOpjjykgwHS5nHteofJXZW2SgLz4TqP446YjLZ2TbnJLrrN8dHU3BDldFiOG1bES+HrKOKfs4wmrVknNhzzQszVqYc5n8b5SgPoou56xelldkB+Im7Bd+4kpnT7JJX5IvfGCGul81oIiUOnrRwHEqNpkgK3mHVwS96L70C1/4EvOiXZMh1fkQnEHYEr3fb2ab6s8+RkV4Te5qRo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2662EFE61A369469ED068D1758CAA63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: concurrent-rt.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9b85b1-dad5-431a-0399-08d6eac39344
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 21:11:43.2892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38747689-e6b0-4933-86c0-1116ee3ef93e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Joe.Korty@concurrent-rt.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3420
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Starting with 4.4.178, the LTP test

  pthread_cond_wait/2-3

when compiled on x86_64 with 'gcc -m32', started failing.  It generates thi=
s log output:

  [16:18:38]Implementation supports the MONOTONIC CLOCK but option is disab=
led in test.          =20
  [16:18:38]Test starting
  [16:18:38] Process-shared primitive will be tested
  [16:18:38] Alternative clock for cond will be tested
  [16:18:38]Test 2-3.c FAILED: The child did not own the mutex inside the c=
leanup handler

A git bisection between 4.4.177..178 shows that this commit is the culprit:

  Git-Commit: 79739ad2d0ac5787a15a1acf7caaf34cd95bbf3c
  Author: Alistair Strachan <astrachan@google.com>
  Subject: [PATCH] x86: vdso: Use $LD instead of $CC to link

And, indeed, when I back this patch out of 4.4.178 proper, the above test
passes again.

Please consider backing this patch out of linux-4.4.y, and from master, and=
 from
any other linux branch it has been backported to.

PS: In backing it out of 4.4.178, I first backed out

   7c45b45fd6e928c9ce275c32f6fa98d317e6f5ee
  =20
This is a follow-on vdso patch which collides with the
patch we are interested in removing.  As it claims to be
only removing redundant code, it probably should never
have been backported in the first place.

Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>

