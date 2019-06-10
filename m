Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826343B8EF
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 18:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403958AbfFJQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 12:05:32 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:21553
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403847AbfFJQFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 12:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+VzdtUPNs0Qsr8q4rBSwfK18f19SNMd3ZofZrRSFwU=;
 b=P6xSAZNkK3OGIMOvqppZt3JQ5OwYdewNtk0i/ZvKptQFrhz9ZYum1xZLodbwPHTcY21vIZ3RFnt6XtJnuLwv0Tw7fazpLUVn4gqUhU2TZWLgvwkPqGBSIU4jEOXD8zzq6YyH6dF65c2tWj7fXVFzHe24vOFWMHWx4a8FMWn0gjk=
Received: from AM0PR05MB4130.eurprd05.prod.outlook.com (52.134.90.143) by
 AM0PR05MB4387.eurprd05.prod.outlook.com (52.134.93.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Mon, 10 Jun 2019 16:05:27 +0000
Received: from AM0PR05MB4130.eurprd05.prod.outlook.com
 ([fe80::4825:8958:8055:def7]) by AM0PR05MB4130.eurprd05.prod.outlook.com
 ([fe80::4825:8958:8055:def7%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 16:05:27 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Ajay Kaher <akaher@vmware.com>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        Matan Barak <matanb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "srivatsab@vmware.com" <srivatsab@vmware.com>,
        "amakhalov@vmware.com" <amakhalov@vmware.com>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Thread-Topic: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Thread-Index: AQHVH4tSEyCAUrGWFkaDJIPiIklE3KaVDYWA
Date:   Mon, 10 Jun 2019 16:05:27 +0000
Message-ID: <20190610160521.GJ18446@mellanox.com>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
In-Reply-To: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:14::34) To AM0PR05MB4130.eurprd05.prod.outlook.com
 (2603:10a6:208:57::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50b390ed-c575-46b9-9608-08d6edbd73f4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4387;
x-ms-traffictypediagnostic: AM0PR05MB4387:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <AM0PR05MB43878D40173CE641A9CBE923CF130@AM0PR05MB4387.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:407;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(396003)(39860400002)(376002)(189003)(199004)(316002)(25786009)(2616005)(476003)(486006)(99286004)(76176011)(4326008)(66066001)(478600001)(52116002)(36756003)(11346002)(446003)(66946007)(186003)(6512007)(66476007)(26005)(6486002)(229853002)(66446008)(64756008)(386003)(6506007)(66556008)(53936002)(102836004)(73956011)(68736007)(54906003)(6916009)(6436002)(305945005)(256004)(81166006)(7736002)(8936002)(2906002)(7416002)(8676002)(81156014)(6246003)(71190400001)(71200400001)(14444005)(6116002)(3846002)(86362001)(33656002)(1076003)(4744005)(5660300002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4387;H:AM0PR05MB4130.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bp4pf/ZhjjpDCrnkLAHxQYc8bmcaqUIuLJmZgCW7sSfE04lwuE87VB1mBe+PB0Tp8EmTRGPcSDvzC/AJu6LXSC+Acn2axArpNOkw8ZsMBnteopEX1TaCl8ODKJFuRaQCescMNcQxBFgGExq0+X0BVjctxO2NNKSnO09/8S6Crc17Y8MlxcIVG8EZtPJ5DlcSiOh+zdls1RJY5vFLZ070loEyup1PKKgNRZswCNWhc0bW2BPQmMdbPcEYkIXIW6g1N7O+WtqIxaACXLZbI1HkBpvPV8kNK3TajxsrB9MqFAf5wzrEx1p/Ekw/d2EzhZ9Cvad1jBDH184KJV9mDBIjvRc5iBTEzaOV1fn8N598QuCnqj1lW1Fqtb9T52mIG6fDvWQUql3gDS1Py50taMeoTUBy5BMC19UqKu4Yh8UqrIw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ACA6821CDC8397409049C57892C1C405@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b390ed-c575-46b9-9608-08d6edbd73f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 16:05:27.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4387
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 02:22:17AM +0530, Ajay Kaher wrote:
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

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
