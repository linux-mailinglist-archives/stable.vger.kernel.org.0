Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3BD3B714
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbfFJORa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:17:30 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:43232
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390777AbfFJORa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VKPV0tzhnrabZGKNCz1su4wa9sEz27AcIfx17kUjTY=;
 b=hLyPgrWNr+SEdM7P7UWUBP1RwT+zGT4xIuA6yQr8FZua36SL6oQAh0oBIIEet7L5lnAakOwz6yffdkS66vqYx9dCqGYsAs9H/7wkB07H3QXpPYEjSnvdLgtQNsQ/e6S9Yb8L9vpL99JTPX6SnfmTuaZuezwutQI4fnsFyzTMemk=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5245.eurprd05.prod.outlook.com (20.178.10.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 14:17:25 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1%6]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 14:17:25 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     Stable tree <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH stable 4.4 v2] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH stable 4.4 v2] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVH2CnxFwP6PSr9UaRiZwKrYERwKaU6mGAgAAFSwA=
Date:   Mon, 10 Jun 2019 14:17:25 +0000
Message-ID: <20190610141720.GB18446@mellanox.com>
References: <20190604094953.26688-1-mhocko@kernel.org>
 <20190610074635.2319-1-mhocko@kernel.org>
 <20190610135823.GI30967@dhcp22.suse.cz>
In-Reply-To: <20190610135823.GI30967@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQXPR0101CA0034.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::47) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c06878eb-7dee-45e3-cba7-08d6edae5cb9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5245;
x-ms-traffictypediagnostic: VI1PR05MB5245:
x-microsoft-antispam-prvs: <VI1PR05MB5245B11806650E702117EC83CF130@VI1PR05MB5245.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(52116002)(66476007)(66556008)(64756008)(66446008)(66066001)(73956011)(66946007)(36756003)(6512007)(446003)(71200400001)(53936002)(71190400001)(6486002)(1076003)(486006)(186003)(2616005)(229853002)(476003)(6506007)(102836004)(26005)(76176011)(6436002)(386003)(11346002)(99286004)(305945005)(81166006)(86362001)(4326008)(81156014)(25786009)(14454004)(7736002)(478600001)(68736007)(8676002)(8936002)(54906003)(6916009)(6246003)(7416002)(14444005)(256004)(316002)(5660300002)(2906002)(6116002)(3846002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5245;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5Na//MXe9sjEuP/oAreM90Sxf3FbqOSXVchIZVJxjBSVTlnYlzmCyyQGCSkEmawoRtZCgra4CzlN5vllOSRxHmF1gURfsiTtyU2HpYoCF7wFiwfsmw65MW08VPB/RDAO/V/St4fRfcpudsWK3A9Q6BGEJpwbRu6n+yOHf8CUcZCxBX9LIpFXWEOMcjpvQNS5AV3fz//VvKv+D/fnm6NozIXsT5vfE2k/AZy3RMnJR4APMMfynppHz/TCQvoQFm+eup5dh8E/ucljoQt/zQ2noso5yMISsnmGAnQls1Cei2tBOSe2/+cT68BJjbADRd0JamzT1ObnGSko1mRkY8Wq1A9eCZqs2Z89FIqYmJveA3KcEQd0ibRpRBB1s2TCS4/uN62eCFgLJ9gnbV1+3POG053vh/ZiQwHlnDb1pNCLQ48=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C459E5B916D523459E5B13C14F2702AC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06878eb-7dee-45e3-cba7-08d6edae5cb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 14:17:25.7844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5245
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 03:58:23PM +0200, Michal Hocko wrote:
> Just a heads up. Ajay Kaher has noticed that mlx4 driver is missing the
> check in 4.14 [1] and 4.4 seems to have the same problem. I will wait
> for more review before reposting v3. The incremental diff is:
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index 67c4c73343d4..6968154a073e 100644
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1042,6 +1042,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib=
_ucontext *ibcontext)
>  	 * mlx4_ib_vma_close().
>  	 */
>  	down_write(&owning_mm->mmap_sem);
> +	if (!mmget_still_valid(owning_mm))
> +		goto skip_mm;
>  	for (i =3D 0; i < HW_BAR_COUNT; i++) {
>  		vma =3D context->hw_bar_info[i].vma;
>  		if (!vma)
> @@ -1061,6 +1063,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib=
_ucontext *ibcontext)
>  		context->hw_bar_info[i].vma->vm_ops =3D NULL;
>  	}
> =20
> +skip_mm:
>  	up_write(&owning_mm->mmap_sem);
>  	mmput(owning_mm);
>  	put_task_struct(owning_process);

Looks OK to me

Jason
