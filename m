Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343DF2636F
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 14:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfEVMHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 08:07:44 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:62531
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbfEVMHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 08:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bM1HxC5hHzb1+mCxdqjIg0925cT4MVoaik/utDEePQc=;
 b=Y9anb1coeAtYj98AqPc4xUz7KIuCBv3rijhi0SCJ9gQc+T9n5o/510X2jZ87WGmw3t1OGRnxWXu4s89N06WqiI53WRytETAeDAANW2nHiSGNdoJWjP+FmcZgM+R5ynzOC0JMrbUTJwDZrPCSirQuXemIA/qbzAISTT57GAxloWE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5455.eurprd05.prod.outlook.com (20.177.201.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 22 May 2019 12:07:39 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1%6]) with mapi id 15.20.1922.013; Wed, 22 May 2019
 12:07:39 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Ajay Kaher <akaher@vmware.com>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        "amakhalov@vmware.com" <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVEJKtcd31BZJBuUaA08iiqIL6fqZ3DLqA
Date:   Wed, 22 May 2019 12:07:39 +0000
Message-ID: <20190522120733.GB6039@mellanox.com>
References: <1558553850-27745-1-git-send-email-akaher@vmware.com>
In-Reply-To: <1558553850-27745-1-git-send-email-akaher@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:208:a8::42) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.49.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae87f690-cb3c-4c7f-4bdd-08d6deae1597
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5455;
x-ms-traffictypediagnostic: VI1PR05MB5455:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR05MB5455238587700E8C47C37A87CF000@VI1PR05MB5455.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(199004)(189003)(476003)(11346002)(6306002)(6512007)(2616005)(2906002)(52116002)(68736007)(1076003)(8936002)(86362001)(446003)(6436002)(3846002)(66946007)(6116002)(33656002)(73956011)(229853002)(486006)(8676002)(81166006)(81156014)(6486002)(66476007)(64756008)(66446008)(66556008)(54906003)(7736002)(26005)(4326008)(305945005)(316002)(478600001)(25786009)(53936002)(6246003)(186003)(14454004)(966005)(36756003)(71190400001)(99286004)(256004)(71200400001)(5660300002)(102836004)(386003)(14444005)(6506007)(76176011)(66066001)(6916009)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5455;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R6lm9j+Y+2nPSPAd4GPDGMMDk9HMdpeMiXz9NDjHigP3y5yrvAxSSoVDgS38PxqEvv5WH5vMNx2jjfEOIqZwjDQQPnqP7QmD0ECo8DI5amiUprqDXN54aSynvbacWMCln3/kefyqWXR5BTjIVG94GtYtaS8taHNl1PbRZXu6KMeD1dWDReMxewxgto0DMCj6d8IAyMAyBDWpScQbS0e1dcprilolJMRPBAf35vIaXRUg2be9WERjJHmc3BQxDp/ZQB39NRZKaIKdR0CRFJco0I9zOEvo9NO9XRe8mS6Aen9f5kaSpogBjC8nEjSTk3+Sr30xqvdhcnA75/JQREXoKjUKu7YUh5nu5yQxdCtCRgTDMskLGESNgzgr/62LNNY/uuVX8T/DQ7arLKKhCZVToPZ3PyQ+2Ii2onGZrFdyjSU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <971F76578A04D24DA0B4940AEF0EF19D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae87f690-cb3c-4c7f-4bdd-08d6deae1597
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 12:07:39.6641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5455
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 01:07:30AM +0530, Ajay Kaher wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
>=20
> commit 1eb719f09f7e319e79f6abf2b9e8c0dcc1c477b5 upstream.

This is not the right commit id..

> The core dumping code has always run without holding the mmap_sem for
> writing, despite that is the only way to ensure that the entire vma
> layout will not change from under it.  Only using some signal
> serialization on the processes belonging to the mm is not nearly enough.
> This was pointed out earlier.  For example in Hugh's post from Jul 2017:
>=20
>   https://lkml.kernel.org/r/alpine.LSU.2.11.1707191716030.2055@eggly.anvi=
ls
>=20
>   "Not strictly relevant here, but a related note: I was very surprised
>    to discover, only quite recently, how handle_mm_fault() may be called
>    without down_read(mmap_sem) - when core dumping. That seems a
>    misguided optimization to me, which would also be nice to correct"
>=20
> In particular because the growsdown and growsup can move the
> vm_start/vm_end the various loops the core dump does around the vma will
> not be consistent if page faults can happen concurrently.
>=20
> Pretty much all users calling mmget_not_zero()/get_task_mm() and then
> taking the mmap_sem had the potential to introduce unexpected side
> effects in the core dumping code.
>=20
> Adding mmap_sem for writing around the ->core_dump invocation is a
> viable long term fix, but it requires removing all copy user and page
> faults and to replace them with get_dump_page() for all binary formats
> which is not suitable as a short term fix.
>=20
> For the time being this solution manually covers the places that can
> confuse the core dump either by altering the vma layout or the vma flags
> while it runs.  Once ->core_dump runs under mmap_sem for writing the
> function mmget_still_valid() can be dropped.
>=20
> Allowing mmap_sem protected sections to run in parallel with the
> coredump provides some minor parallelism advantage to the swapoff code
> (which seems to be safe enough by never mangling any vma field and can
> keep doing swapins in parallel to the core dumping) and to some other
> corner case.
>=20
> In order to facilitate the backporting I added "Fixes: 86039bd3b4e6"
> however the side effect of this same race condition in /proc/pid/mem
> should be reproducible since before 2.6.12-rc2 so I couldn't add any
> other "Fixes:" because there's no hash beyond the git genesis commit.
>=20
> Because find_extend_vma() is the only location outside of the process
> context that could modify the "mm" structures under mmap_sem for
> reading, by adding the mmget_still_valid() check to it, all other cases
> that take the mmap_sem for reading don't need the new check after
> mmget_not_zero()/get_task_mm().  The expand_stack() in page fault
> context also doesn't need the new check, because all tasks under core
> dumping are frozen.
>=20
> Link: http://lkml.kernel.org/r/20190325224949.11068-1-aarcange@redhat.com
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory exte=
rnalization")
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Reported-by: Jann Horn <jannh@google.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [Ajay: Dropped infiniband changes to get patch to apply on 4.9.y]

I think in this kernel the mm handling code for IB is in three
different drivers, it probably needs to be fixed too?

Jason
