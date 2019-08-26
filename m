Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12549D3BB
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbfHZQJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:09:59 -0400
Received: from mail-eopbgr800079.outbound.protection.outlook.com ([40.107.80.79]:11134
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728683AbfHZQJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 12:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQhej1VzqYzxfAx6kavZWji+xPCiHaDfHyzGw11iUwdRzgiHAnuP+DfHdOyooolCmymgt2oGQ2qeoaOrS+ay4f8Q7t8GYvdLw2cvvR75Y1q3wx06YaxFNgtAYEGkeMXjz6RxPiOPGZ6++DrO5yFMy8fTFjtO398F/S5GXybySGMFOrD8q6RbYtDsXnMX17eC9low4vodRsxCDBucx5L5fFWMBjvq+QJTv8DHMzwlwgAPWUyx2xMchQbNaQCNm85Y7HNmZpFo50Simo2C5UmE5B/0dpksF4D2Pgi4mkQDqajIQwhqGSanOB8P32eP36cXnCXluDbO/j6T2pHtchOFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzvhWIrnEubBNpZXN9EiUV8CsMhsOTd5VOkWUY4oA9Y=;
 b=h3GGk64GicsLScNyKtqjXbMunHC9ezOc09GdV8YPlb67PnqLraY0fGANqVHZE2fiwzjiEDXeUlg9SrBSlI7mXhYATokE6KtKhxsdhfEDh077lWR+P6bVjaug5GQJDeKZnqPejEf6bjvKGfHj3ovWW7LDEL6Yk5gjO1c4W8c1rq3e5jppBxtcBtwowEEtdqdkIyPluN8OR50D9pAsoXJdcbm+LQfZnN7ds7yhS1FxMfGxGGihi216qEeTIQghvgRGCOPPRWc7s/0ztV2Vwi3y61AShgHEzhxOR2kbXxyTOSt9zovJIA/yLiTOo3SLPwlZITk07//CSwEb3pAPBbjLgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzvhWIrnEubBNpZXN9EiUV8CsMhsOTd5VOkWUY4oA9Y=;
 b=U27BGH9zWRCBjIdxRQLmNrq0uhYrHdGRyHHIuCzLadSsXHBrhM+fLtbVFR+46T3aMFnslYsZHesvOuRiJrdgEGqTWz4lmUun7xhPXoObBwO620Wmx9gx3ClYhFxSS6LIeh89f2e2i09s76yftC4E95mVW70KDcJzTfV+LxZN2j4=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4088.namprd05.prod.outlook.com (52.135.199.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.13; Mon, 26 Aug 2019 16:09:55 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::5163:1b6f:2d03:303d]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::5163:1b6f:2d03:303d%3]) with mapi id 15.20.2220.013; Mon, 26 Aug 2019
 16:09:55 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Topic: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Index: AQHVXAINMlzHgko6mk+L3YlByguhN6cNkWoAgAAEUYCAAAOlAA==
Date:   Mon, 26 Aug 2019 16:09:55 +0000
Message-ID: <36BC6E27-A6EB-4B25-82C0-311AA0652179@vmware.com>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
 <20190826073308.6e82589d@gandalf.local.home>
 <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
 <20190826115651.43c9bde3@gandalf.local.home>
In-Reply-To: <20190826115651.43c9bde3@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d4e16aa-7cca-49f1-8bbd-08d72a3fd5d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4088;
x-ms-traffictypediagnostic: BYAPR05MB4088:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR05MB4088D44419989FCB5FD675A3D0A10@BYAPR05MB4088.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(52314003)(189003)(199004)(53546011)(71200400001)(33656002)(2616005)(476003)(966005)(26005)(186003)(8676002)(478600001)(6246003)(2906002)(305945005)(53936002)(6306002)(66066001)(8936002)(6916009)(7416002)(446003)(5660300002)(81156014)(6486002)(4744005)(256004)(81166006)(11346002)(7736002)(4326008)(14454004)(36756003)(86362001)(6512007)(54906003)(76176011)(3846002)(64756008)(6116002)(66946007)(66446008)(76116006)(66476007)(66556008)(71190400001)(99286004)(229853002)(6436002)(25786009)(316002)(6506007)(486006)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4088;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E0yKTPVdEBHt5+V5TjnODcTq7r7KkgOmPUt/PZdKY4S3XOLOBWqBxNjBweGFK0vZFQN4IhczCW/dtnPjacULmdxo4YvAbcflozIr5TOx148fKvGpkdFkzNbN8/qcyPSDVfVbUS4tG9OWKD2nXw/6Dt3wP6oQxGZZfelDC7K9AQS7kKqxtnCW096fpp/aVzKHx1UDxPeGhz29NYM3VkIe/0G8UrMAtfQxMBBfBJAGIr0h9Drdu4ODnnskQFURrLDQygWTSYDGYG3CYhjOmyYM703Mk8cZRS5tIUJJj+I8S7imUJFSr5kjT2ifr11OxeOIBB4BLMAinrY1mCHXYi4EA5QHq87IH88QfbV19IGNQgT5wzWj7mtN9v+8K1D2ttNNCbvD0mgqihMzh0fpaZQugfL7ZBkhwsKeGI89ag11xcQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <947D8EBB7AFC73419909CCB664F5665C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4e16aa-7cca-49f1-8bbd-08d72a3fd5d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 16:09:55.3017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yo0tahBi9gyJiFttyO19ksiBqeP/lnFprnU18+rA42zYlIMO9cRcQ799scO6/FoMLXQocQAyVo8/rOR7Jl8jfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4088
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Aug 26, 2019, at 8:56 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Mon, 26 Aug 2019 15:41:24 +0000
> Nadav Amit <namit@vmware.com> wrote:
>=20
>>> Anyway, I believe Nadav has some patches that converts ftrace to use
>>> the shadow page modification trick somewhere. =20
>>=20
>> For the record - here is my previous patch:
>> https://lkml.org/lkml/2018/12/5/211
>=20
> FYI, when referencing older patches, please use lkml.kernel.org or
> lore.kernel.org, lkml.org is slow and obsolete.
>=20
> ie. http://lkml.kernel.org/r/20181205013408.47725-9-namit@vmware.com

Will do so next time.

