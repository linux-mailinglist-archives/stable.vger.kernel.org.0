Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046519D32D
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfHZPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:41:28 -0400
Received: from mail-eopbgr690076.outbound.protection.outlook.com ([40.107.69.76]:59810
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728221AbfHZPl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 11:41:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqotKOh7cFeabxtTt50EFIJtKs4HlDwD1oluQSXmAV1F/bJoe+rdXvgRyT2c4XWNtwIik1HTVMxJVLWtZvS4JTqEp+tspeyiOFOsL7XF8LI8c6kwBeB+5y1vtwVeJXfPeVNGIsM9Pl8K/halKuKturzUPv56vsY5AHD2oKakw2R1zckaCy22XdkXjxUv0Ise5N7SM2FZGKV8LF4dWEzUL2Jk6Cw+01ZAvXDFwhfqMBbHSYtguSYucu+LMnSZWMkNCdHwchWBORFnluKlSIGKZHVAXKBNYDt1nxxVp6Ar1oUFkArwJkulETXjDlT99DDafeNOtWQjW5SGX9ZRII7+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0JJHz3HY6i3AxNm/oO73HdD9AJQy1YjdoOvDzHZEvA=;
 b=jQhi52xtiG/4rtLJDUE6UmwcejGBPoR1aEBspsbgFB2pJzMqqiZnCiaji0uOKDIx9+mYp9+et/Uoh2gXlu+xJ6YO+JOA1/O0uBOn79gCH5zm6SC1IgEUFuyRCys4HCA27/z6nWETjzy/c3nX1hkyYXBxjYdnDT12BxVkAtO6j/0+RuglI+UsxcKnepEQhqfm0cS5lUcY5lq7u5ZTp1fPO9iOK7PXfY0G7uVAz8EIdyxDm66SQWq0NLG336voVUnMsOZa7y2R8ER2w0PoW0CHc3BA0JZCiDLOY5UzcRdIFFlrKBuRfz8cI+kShmpiOfx9o+utGepUupzgzfQJUHV91Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0JJHz3HY6i3AxNm/oO73HdD9AJQy1YjdoOvDzHZEvA=;
 b=fu4SRoSPXT9LPvfPg4m/mtR89IQLk8/g0C52Xu4IQhzrQRwmaDcpYwumCBUP7dMijFPjoiTrEGHTPxfCvbPps3aCDvjkqgHPT0qcwR3bjVzlybBo4CvPSMISun/lxpUpKlnGA6BZVD5DlYsCKlYNeI8x4KhHyJz3+5m3uUauF5Q=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4408.namprd05.prod.outlook.com (52.135.202.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.14; Mon, 26 Aug 2019 15:41:25 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::5163:1b6f:2d03:303d]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::5163:1b6f:2d03:303d%3]) with mapi id 15.20.2220.013; Mon, 26 Aug 2019
 15:41:25 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <songliubraving@fb.com>,
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
Thread-Index: AQHVXAINMlzHgko6mk+L3YlByguhN6cNkWoA
Date:   Mon, 26 Aug 2019 15:41:24 +0000
Message-ID: <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
 <20190826073308.6e82589d@gandalf.local.home>
In-Reply-To: <20190826073308.6e82589d@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24b52faa-4845-4822-9c55-08d72a3bda62
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4408;
x-ms-traffictypediagnostic: BYAPR05MB4408:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR05MB440825FDBCF40C087391DB2FD0A10@BYAPR05MB4408.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(52314003)(189003)(199004)(14454004)(6246003)(8936002)(316002)(76176011)(33656002)(66476007)(81156014)(81166006)(478600001)(53936002)(966005)(110136005)(476003)(54906003)(66946007)(8676002)(2616005)(5660300002)(25786009)(66446008)(64756008)(66556008)(256004)(6306002)(7736002)(6512007)(305945005)(71200400001)(4326008)(36756003)(71190400001)(26005)(3846002)(102836004)(6436002)(6116002)(7416002)(6506007)(6486002)(446003)(53546011)(99286004)(229853002)(2906002)(86362001)(76116006)(186003)(486006)(66066001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4408;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CqnQkwLjN4MD3dv1nbbLaGfrdUdnpHH8dgyMT7fGNaxOl5IWb7v6XrjOohfXnzVFQ+Mi1TfAwMfWv9Cv4CY51Kkr9uqouUO4K4StAKa0taggEikGkmrcK/zY3ALuf9Cyhh+Pu6KeRb5Ch1x0EUe+DUgd5YVoTLBuYRdt0gun8/YlVShgon6M9G4SNdIuDsZH2ug64JUf4zGvDgYx8vEnXX7Hr5PQx5Nf2hfOTfssUkTOvPAwpuoW4Tu2bUMR5oHqioJWqyiSLFwEzm/mcgvYX+GiG/YSFKyfBbZgG+HJxCYeuuMI6NsOJfAufr0bIz/zCYaLb8OLasg27Xm07ur/ygp62Edmphx+lFd3ja9gJVhoz3vqsXv/Fi/D1EOx6PjxcL9xGxrDweFg8zUyA+v5+0N4DTwrmUOeUaJ5qPx0vU4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <793DED38C3ABEE4F8A70996B1D0EA79D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b52faa-4845-4822-9c55-08d72a3bda62
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 15:41:24.9898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFNWVggkMwc2Yu4Sjy/1LoPHlwZA1ySYciNGlleX3iH0h4VitQybF219sXTBYtJhpaC6UomC1KAN1FvA/eybFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4408
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Aug 26, 2019, at 4:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Fri, 23 Aug 2019 11:36:37 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>> On Thu, Aug 22, 2019 at 10:23:35PM -0700, Song Liu wrote:
>>> As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads =
to
>>> split_large_page() for all kernel text pages. This means a single kprob=
e
>>> will put all kernel text in 4k pages:
>>>=20
>>>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>>>  0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd
>>>=20
>>>  root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
>>>  root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>>>=20
>>>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>>>  0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte
>>>=20
>>> To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
>>> in static_protections().
>>>=20
>>> Two helper functions set_text_rw() and set_text_ro() are added to flip
>>> _PAGE_RW bit for kernel text.
>>>=20
>>> [1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check complete=
ly") =20
>>=20
>> ARGH; so this is because ftrace flips the whole kernel range to RW and
>> back for giggles? I'm thinking _that_ is a bug, it's a clear W^X
>> violation.
>=20
> Since ftrace did this way before text_poke existed and way before
> anybody cared (back in 2007), it's not really a bug.
>=20
> Anyway, I believe Nadav has some patches that converts ftrace to use
> the shadow page modification trick somewhere.

For the record - here is my previous patch:
https://lkml.org/lkml/2018/12/5/211

