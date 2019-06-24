Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2993750B8B
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfFXNMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 09:12:38 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:16288
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbfFXNMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 09:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJKNsiWuopGsFiwJtfSmHwT6t9upZDeCWjBmCmeA7XQ=;
 b=Z1jEVJMZeA2aVFeQjyVX7/o4DJ+7JCvRf4WB7j5DitZp9Eec4o34k6ZMPdBc8DRs9251E7fBsr40IgTR+/qGaLd5Ce2yN5fUuin90BVN/A4n61Dlhc8rIJpghdvWQbcEo+NvAKhD6BjynMtbuzDfvbufD3a3XZFwNSOsl4cwFyg=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5662.eurprd05.prod.outlook.com (20.178.120.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 13:12:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 13:12:30 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Ajay Kaher <akaher@vmware.com>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "riandrews@android.com" <riandrews@android.com>,
        "arve@android.com" <arve@android.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        Matan Barak <matanb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "srivatsab@vmware.com" <srivatsab@vmware.com>,
        "amakhalov@vmware.com" <amakhalov@vmware.com>
Subject: Re: [PATCH v4 2/3][v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH v4 2/3][v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVKo0oRBGkKYxOxkqZ7SBtAl/moqaqx9UA
Date:   Mon, 24 Jun 2019 13:12:30 +0000
Message-ID: <20190624131226.GA7418@mellanox.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-2-git-send-email-akaher@vmware.com>
In-Reply-To: <1561410186-3919-2-git-send-email-akaher@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::23)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1279592d-f3e3-4d7c-f79c-08d6f8a59cb2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5662;
x-ms-traffictypediagnostic: VI1PR05MB5662:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB5662688FC277DCA3E4A171D3CFE00@VI1PR05MB5662.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:407;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(189003)(5660300002)(478600001)(6506007)(53936002)(33656002)(2616005)(6486002)(81156014)(86362001)(14444005)(3846002)(256004)(8676002)(81166006)(7736002)(229853002)(2906002)(446003)(66446008)(11346002)(68736007)(6916009)(486006)(66556008)(66476007)(36756003)(71190400001)(71200400001)(476003)(73956011)(99286004)(64756008)(66946007)(54906003)(76176011)(6512007)(102836004)(1076003)(4744005)(52116002)(386003)(25786009)(6116002)(6246003)(6436002)(316002)(66066001)(14454004)(4326008)(7416002)(8936002)(186003)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5662;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 40jUzpU9CguJn2eIvgacEOcIi2CYrA0fIWmsrZEo49I+3EgVJp2pRrgkltjExJd0cjLBr/ZjZlNwxkj3odOMuDp291oxCEbrf3qoTyS3t50EwIjNffVdqGTeH6SCwGNP75qu35Wfr9Fgt5LrVmv2KNlC0hj671ZjeDtCZGFuGl7uZoYiJsrZdi4d6ionXc5Hiw4AyN1GqbfMpsRhTIk04KKLL4BQOMw0SERrzFPOOZ3ElIE3NiCP6fv0/k+bGED0ir5nSBe1nGavp8idteCEzizj2yiReEGiw+Jv1jpp3+eI21DhvKqarSVs8wjJQAGdjWFsi/LMX1xvw6PCN8mBZivSW/3TKHejjD7JWQl00Jp9rHUnCy4wwss0fSFbTacnV6ybN+BzydI38iRxeDsA2x+8r0/iw5rWc1H41b2zd7M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <626B17CC09D07E449465C19358AB7DB5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1279592d-f3e3-4d7c-f79c-08d6f8a59cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 13:12:30.5998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5662
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 02:33:04AM +0530, Ajay Kaher wrote:
> This patch is the extension of following upstream commit to fix
> the race condition between get_task_mm() and core dumping
> for IB->mlx4 and IB->mlx5 drivers:
>=20
> commit 04f5866e41fb ("coredump: fix race condition between
> mmget_not_zero()/get_task_mm() and core dumping")'
>=20
> Thanks to Jason for pointing this.
>=20
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 +++-
>  drivers/infiniband/hw/mlx5/main.c | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)

Looks OK

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Thanks
Jason
