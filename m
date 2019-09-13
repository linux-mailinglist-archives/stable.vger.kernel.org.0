Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC0B1D0F
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbfIMMFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 08:05:05 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:48945
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbfIMMFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 08:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnrIhb0flyF0edmo2vHNqMaryqoWjdtYAMqL/e0nIh0JpVaoPS41uKH/7x7WAcYeRlaw+cFigct5KKh0GMPI3D8GOmEoMt+mVgvvZrnli+RV4Gd0xbjFFg7/0JHI9DIkLv0oHc0Ikg2PjVxrfod0RI+1RxWA2CB0IZycrSOAsbpiT/pa32tTjQooowmfmVLdNAF6GjknUed5Jvla3sd9gQuaMHUSm/iIeiM7hcJgVnnnsgIozrFgnu1Txh/29e0eTtgbtMUn0Bx8zAkTwWQPXqmLACZJ1JshKiSc6GeW50PrISt8iOxDS7ts4PZOm+oqymhafVzzum8OQYybq0NCtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJwsrBFcEujPBfndGMI0ohHlxeZEiQpfFnN93C+E67g=;
 b=CVD0ytrcI6A47wu431G/yVyVtDlQ930RyBFRDIpzxcdD4r5H0KZy6V7m9P3u4iKLUF+XE/QgmEXM3amSdmMrWdkjepUZKMH7vt8i+pzXO7UB6taK/biif4JEn3sgV79ZbBXdCZKlXm4hSxLICMW9WWrywgxuNlxquUMj/c6dyQ3KGkMK2V/JIsOKnt2mlLdkjwsTpgSdMurm4vMxSYEOG5CTBbabMD5oQECJtakCPwDn/hvPU+X3TNhVN4Gunb2ZZr4kD1V1R/GLtmWtIn2V7NzqbW1/Gx3AJKa0IyyFF+XRBCBJyl1kqvh6gdsYBmqvik4UKvCoBmEKWaX8wocWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJwsrBFcEujPBfndGMI0ohHlxeZEiQpfFnN93C+E67g=;
 b=CMSY25T2FP5LOjAsvlH+A+plkma1qQwGAHLLM0/Tfi3E2lMDM+plrPBm8OR12F+MQlAW2JxsHECSl36OIYivij/Le8bSbWDnZ9z0Hk2u9rmW8CCiMCAjYgc6cUw8NhnCuS5L5UOLeiHWFSZCp48gCmyvkn2wvVbM+k31s/SKNMw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6765.eurprd05.prod.outlook.com (10.186.160.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Fri, 13 Sep 2019 12:05:00 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f%7]) with mapi id 15.20.2263.018; Fri, 13 Sep 2019
 12:05:00 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-next 3/3] IB/hfi1: Define variables as unsigned long
 to fix KASAN warning
Thread-Topic: [PATCH for-next 3/3] IB/hfi1: Define variables as unsigned long
 to fix KASAN warning
Thread-Index: AQHVait3EaVPICs7REuV6A43RCBA0A==
Date:   Fri, 13 Sep 2019 12:05:00 +0000
Message-ID: <20190912161219.GA15092@mellanox.com>
References: <20190911112912.126040.72184.stgit@awfm-01.aw.intel.com>
 <20190911113053.126040.47327.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190911113053.126040.47327.stgit@awfm-01.aw.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0063.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.167.223.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dafdfc9-b79d-4a03-95b8-08d738429a0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6765;
x-ms-traffictypediagnostic: VI1PR05MB6765:
x-microsoft-antispam-prvs: <VI1PR05MB67656B90A36BDB75AE713504CFB30@VI1PR05MB6765.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(199004)(189003)(51234002)(6116002)(6246003)(3846002)(53936002)(64756008)(66476007)(5660300002)(86362001)(66446008)(66556008)(66946007)(76176011)(99286004)(6512007)(316002)(4326008)(52116002)(6916009)(478600001)(36756003)(54906003)(6436002)(26005)(476003)(81166006)(8676002)(2616005)(25786009)(102836004)(8936002)(11346002)(186003)(14454004)(305945005)(7736002)(446003)(256004)(14444005)(66066001)(1076003)(33656002)(71190400001)(71200400001)(6486002)(229853002)(386003)(486006)(2906002)(6506007)(81156014)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6765;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZZyA5KWjF16GEi4zUg0LAbauZ17hK7k3a9zYH5UqrhX5Bwu5Tu68TuPLxThTKWErzlDNz1sZC5vHF7crPlEvEpwYtbcrQBx7fdPk5A+xVo0wVldMsTYFCPjgqX/Q1b+G3Qu1WH2r7ByBtsIwqBOn9N020NJ+lIbFjn9yBk7XpRR7dqSe4RFK3z1fBGAsUB6JUV19Fo6PEkCvy1oCbAI+5HSi2VjR4piPIg5V5BRJZKZTVzwsbsehFbauF88s10JQe0Bqn2wRHy7BsCc43VWADj2xA5rxv7OSiYo8r8oOseARsk67MGd/s9iGUr5FF0XbtL2O6UU2ZqHEGqQvpCgtqiqWqBAZDk7IrobkTd7nhwvNQUQG1RlV3AOANke1dHyRiU9Y1D1qadEBsUtEIJZt8k6XXb2axGcdDMmrl2BmlJM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF4B41526C622A47A3BD7926A04B4BA7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dafdfc9-b79d-4a03-95b8-08d738429a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 12:05:00.4161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXaJlKJ4/aPfRuVMmjgqhgfF9AMehNj63E+hFr4/0Rnx4WKkc/f7IkRqLox/86n2h1ted9C9cIhQoD194wcXBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6765
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 07:30:53AM -0400, Dennis Dalessandro wrote:
> From: Ira Weiny <ira.weiny@intel.com>
>=20
> Define the working variables to be unsigned long to be compatible with
> for_each_set_bit and change types as needed.
>=20
> While we are at it remove unused variables from a couple of functions.
>=20
> This was found because of the following KASAN warning:
> [ 1383.018461] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1383.029116] BUG: KASAN: stack-out-of-bounds in find_first_bit+0x19/0x7=
0
> [ 1383.038646] Read of size 8 at addr ffff888362d778d0 by task kworker/u3=
08:2/1889
> [ 1383.049006]
> [ 1383.052766] CPU: 21 PID: 1889 Comm: kworker/u308:2 Tainted: G W       =
  5.3.0-rc2-mm1+ #2
> [ 1383.064765] Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5=
C600.86B.02.04.0003.102320141138 10/23/2014
> [ 1383.078498] Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
> [ 1383.087314] Call Trace:
> [ 1383.092211]  dump_stack+0x9a/0xf0
> [ 1383.098074]  ? find_first_bit+0x19/0x70
> [ 1383.104546]  print_address_description+0x6c/0x332
> [ 1383.111986]  ? find_first_bit+0x19/0x70
> [ 1383.118443]  ? find_first_bit+0x19/0x70
> [ 1383.124882]  __kasan_report.cold.6+0x1a/0x3b
> [ 1383.131808]  ? find_first_bit+0x19/0x70
> [ 1383.138244]  kasan_report+0xe/0x12
> [ 1383.144169]  find_first_bit+0x19/0x70
> [ 1383.150413]  pma_get_opa_portstatus+0x5cc/0xa80 [hfi1]
> [ 1383.158275]  ? ret_from_fork+0x3a/0x50
> [ 1383.164583]  ? pma_get_opa_port_ectrs+0x200/0x200 [hfi1]
> [ 1383.172629]  ? stack_trace_consume_entry+0x80/0x80
> [ 1383.180097]  hfi1_process_mad+0x39b/0x26c0 [hfi1]
> [ 1383.187420]  ? __lock_acquire+0x65e/0x21b0
> [ 1383.194081]  ? clear_linkup_counters+0xb0/0xb0 [hfi1]
> [ 1383.201788]  ? check_chain_key+0x1d7/0x2e0
> [ 1383.208391]  ? lock_downgrade+0x3a0/0x3a0
> [ 1383.214906]  ? match_held_lock+0x2e/0x250
> [ 1383.221479]  ib_mad_recv_done+0x698/0x15e0 [ib_core]
> [ 1383.229187]  ? clear_linkup_counters+0xb0/0xb0 [hfi1]
> [ 1383.236977]  ? ib_mad_send_done+0xc80/0xc80 [ib_core]
> [ 1383.244778]  ? mark_held_locks+0x79/0xa0
> [ 1383.251341]  ? _raw_spin_unlock_irqrestore+0x44/0x60
> [ 1383.259086]  ? rvt_poll_cq+0x1e1/0x340 [rdmavt]
> [ 1383.266362]  __ib_process_cq+0x97/0x100 [ib_core]
> [ 1383.273822]  ib_cq_poll_work+0x31/0xb0 [ib_core]
> [ 1383.281169]  process_one_work+0x4ee/0xa00
> [ 1383.287822]  ? pwq_dec_nr_in_flight+0x110/0x110
> [ 1383.295047]  ? do_raw_spin_lock+0x113/0x1d0
> [ 1383.301880]  worker_thread+0x57/0x5a0
> [ 1383.308138]  ? process_one_work+0xa00/0xa00
> [ 1383.314937]  kthread+0x1bb/0x1e0
> [ 1383.320643]  ? kthread_create_on_node+0xc0/0xc0
> [ 1383.327822]  ret_from_fork+0x3a/0x50
> [ 1383.333928]
> [ 1383.337640] The buggy address belongs to the page:
> [ 1383.345080] page:ffffea000d8b5dc0 refcount:0 mapcount:0 mapping:000000=
0000000000 index:0x0
> [ 1383.356490] flags: 0x17ffffc0000000()
> [ 1383.362705] raw: 0017ffffc0000000 0000000000000000 ffffea000d8b5dc8 00=
00000000000000
> [ 1383.373530] raw: 0000000000000000 0000000000000000 00000000ffffffff 00=
00000000000000
> [ 1383.384321] page dumped because: kasan: bad access detected
> [ 1383.392659]
> [ 1383.396350] addr ffff888362d778d0 is located in stack of task kworker/=
u308:2/1889 at offset 32 in frame:
> [ 1383.409191]  pma_get_opa_portstatus+0x0/0xa80 [hfi1]
> [ 1383.416843]
> [ 1383.420497] this frame has 1 object:
> [ 1383.426494]  [32, 36) 'vl_select_mask'
> [ 1383.426495]
> [ 1383.436313] Memory state around the buggy address:
> [ 1383.443706]  ffff888362d77780: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00
> [ 1383.453865]  ffff888362d77800: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00
> [ 1383.464033] >ffff888362d77880: 00 00 00 00 00 00 f1 f1 f1 f1 04 f2 f2 =
f2 00 00
> [ 1383.474199]                                                  ^
> [ 1383.482828]  ffff888362d77900: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00
> [ 1383.493071]  ffff888362d77980: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04 =
f2 f2 f2
> [ 1383.503314]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

This needs a fixes line, can you tell me what it is?

> -		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
> -				 8 * sizeof(vl_all_mask)) {

Well, that was obviously wrong!

Jason
