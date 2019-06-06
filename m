Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F964374B9
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfFFNBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:01:37 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:19460
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFFNBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 09:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/WnmgBcJhT3SSzKXOgtauV/nEVUb62EQFPYO6FBknQ=;
 b=JjATmDZJWcrdmZoJyaZuGcVpqut6Qr/z4D8NHz49b5ziX9PATYpBesbgqwSFJF4OgX6+IKwhPVANrypYFweCO9vK1Taw3rxTv5vsCp1kWaNtcHLh4Z1JK9TlbrM4YJKCKgCdmG6dY0G1b7Y2vN1nNykn+971imE1IbALISeD8ZA=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4944.eurprd05.prod.outlook.com (20.177.51.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 13:01:32 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1%6]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 13:01:32 +0000
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
        Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVEJKtcd31BZJBuUaA08iiqIL6fqZ3DLqAgBd2bICAACubgA==
Date:   Thu, 6 Jun 2019 13:01:32 +0000
Message-ID: <20190606130127.GB17392@mellanox.com>
References: <1558553850-27745-1-git-send-email-akaher@vmware.com>
 <20190522120733.GB6039@mellanox.com>
 <DE6BE512-F3CF-4847-BED0-EE2FCC31DCED@vmware.com>
In-Reply-To: <DE6BE512-F3CF-4847-BED0-EE2FCC31DCED@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTOPR0101CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::14) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21476aef-a671-45e4-dd48-08d6ea7f18e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4944;
x-ms-traffictypediagnostic: VI1PR05MB4944:
x-microsoft-antispam-prvs: <VI1PR05MB4944E00004577B6FB882352ECF170@VI1PR05MB4944.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(396003)(39860400002)(346002)(199004)(189003)(25786009)(66946007)(11346002)(476003)(2616005)(186003)(4326008)(99286004)(81166006)(81156014)(64756008)(66476007)(86362001)(52116002)(316002)(8936002)(2906002)(486006)(66446008)(229853002)(73956011)(76176011)(66556008)(478600001)(68736007)(102836004)(256004)(5660300002)(386003)(66066001)(6506007)(26005)(6916009)(33656002)(4744005)(53936002)(8676002)(1076003)(6246003)(7736002)(71200400001)(71190400001)(14454004)(6512007)(6116002)(36756003)(6436002)(446003)(54906003)(7416002)(3846002)(6486002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4944;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /w0lz7Q7rj2fDUm7YcEXA+e3iwYnMFS/Ya6w95UzxGlpMCIASUOTMB1bnmi7rCJ2nPSbA2+sa2KS6sTBbvyG2Ervx5nq0HPQOeBbVMQAMddMz6k2RHuXN80Y9LVUOed86r5m9DYXOjHrn8bYBgOg9t3VLYDexx7KM3lCF4nSMP0UScJaztB1veDtSjThkPAYZ8sh2DWEXV0CUjVPU6Woq3y2Cso0HqDMUkbInSeDcp/Y9to6uvAT2mmOCN70t1yuo0wGNfCXfYS6whEbkTgqY4cDCMwCjvoGpgry2YDKrGX3s8RD6N6Yss/OsLDghK1m126Qx0I5+EUhkiqY34Cn8RvbCllSs43sOu11bIj/x1BxXxLVaoCnoXVjh0xsb/VmvBfUq5oHL9umvfusvxlwoRmKtaHKZzpatzicmUlzj6g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED4578F884E61144B06559C8BE7FBAD0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21476aef-a671-45e4-dd48-08d6ea7f18e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 13:01:32.1273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4944
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 10:25:23AM +0000, Ajay Kaher wrote:

> > I think in this kernel the mm handling code for IB is in three
> > different drivers, it probably needs to be fixed too?
>=20
> Thanks Jason for pointing this.
>  =20
> Crossed checked the locking of mmap_sem in IB driver code of 4.9 to 4.14 =
with >5.0
> and found it requires to handle at following locations of 4.9 and 4.14:
> mlx4_ib_disassociate_ucontext() of drivers/infiniband/hw/mlx5/main.c:
> mlx5_ib_disassociate_ucontext() of drivers/infiniband/hw/mlx4/main.c
>=20
> To fix at above location, would you like me to modify the original
> patch or submit in another patch.

I think it is a backporting thing, so you should put the new work in
this patch? I'm not sure.

I'm also surprised hns isn't in the above list of drivers, but maybe
hns didn't have this support in these kernels..

Jason
