Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7133B344
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCONGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:06:14 -0400
Received: from mail-mw2nam12on2136.outbound.protection.outlook.com ([40.107.244.136]:49953
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhCONFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:05:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSrOsSkSNgqVIr5hLrHjjfdDOttFxz1vh116zRZ0fO26QXiU91fCmsaJlLef9xcQTyzUxqPC7imoCmV8WbJq4sahkDg1mt4HsnO5Y/WrA0PSWALeTs6xpIkYBWON09HcOqS5bCbD/uLR057CK8haA03s7qGcYMMb1UMiz5v3fANMC87qkUsH0geFcyaAA6Aa/kR46Bs2wCWEUXoVqElLf0lOzQK30se5UiTFZ/GYRcEV92NwqKUM46kxX+OjFnYR10kn8l4LNwj/FO5dlQ2LvxctJPqQ52dvT8pTO0s2fDDhuNn/uNv/N/IqGSdCy9zDSx4fMoJopuhCE9WFAOvHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSG3hHITJVyVRVZDy4vx46Ub/eNzM6ktdOlUe0ivDm8=;
 b=Arvyz8KYk4LEA1XtGHxSy/uOgRLpBjc4xsHFSSpMxUGlOtMBTo97SeyPJbuniFWMRNyqaugt33XldZQN1Tvcef91t40rjIGVN9TTaOw612YuYMw/4OYGG7w6f+ekYbVJvx3o7/uac7fiDe79qKe9ikfJqtpy/SsZp6Ao9Zx8o+vUv+LCobHIyTqqzF7A2Ob8/AHMBnuk4u1VcV1Q5y9yuZgfnr2H99TATLVfeAVyoY6/lHk7icDR8ddo9GYcPBKsCrccL7tzoPLS50El9lJietJmmiITSUZsGk25UvJwIpd+2tJCd3kOsafBeL0vCjrRJoeOvtc7aMgiJp0DaWUIEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSG3hHITJVyVRVZDy4vx46Ub/eNzM6ktdOlUe0ivDm8=;
 b=LiYnpYs5Wlmjzdz3gGJzQxNnijBi39aSiM43aslZTFm0UZL7wlhmND2zLrog+qnZmAmvrjx3iX2dOZfXP8f1/5nZefK43Jg5QoxaG6XoCj3yKasivuf2KQ8cC1UKWdi/w/g5fYuJWUt/leI0XbUy9R9dt0ABZs++ipRY6RcvRLLCRgCEIFt+vdYY9bEPChJK1u+GB/FcRQeCRJn+uGQzwZAxsmMvrqml6ZQpuNV/m0TTuyzpX+ACNqgQw8r5uq8KcZcbLqPc340/LtxEzfNHfjV3kvpDeHBFLjoCMJRsr/GmOER6gZf3j3R8jL31f+P+8DSiYZHaHU5ESuftc2lRLw==
Received: from BYAPR01MB3816.prod.exchangelabs.com (2603:10b6:a02:88::20) by
 BY3PR01MB6579.prod.exchangelabs.com (2603:10b6:a03:355::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Mon, 15 Mar 2021 13:05:44 +0000
Received: from BYAPR01MB3816.prod.exchangelabs.com
 ([fe80::3994:8cb0:991b:cc60]) by BYAPR01MB3816.prod.exchangelabs.com
 ([fe80::3994:8cb0:991b:cc60%6]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:05:44 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: rdmavt panic in long term stable linux-5.10.y
Thread-Topic: rdmavt panic in long term stable linux-5.10.y
Thread-Index: AdcZm7ibRvRNomYSR3a6qhxfAsPNoA==
Date:   Mon, 15 Mar 2021 13:05:43 +0000
Message-ID: <BYAPR01MB3816509E2A5824045B110099F26C9@BYAPR01MB3816.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none
 header.from=cornelisnetworks.com;
x-originating-ip: [70.15.25.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b54f04e-97b5-4dde-006d-08d8e7b30aea
x-ms-traffictypediagnostic: BY3PR01MB6579:
x-microsoft-antispam-prvs: <BY3PR01MB657973AAC591802B85EAE93FF26C9@BY3PR01MB6579.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6K0W0VBSbLtpebeFU68hdzTYDEN/RB9/9IG/Q72/KgEM7R9DHlg/oGREkTpbg487pqIX0vGDjn+AcyZ52OLfMIzy3gSNWzvSTuWcToadz4Ozt37kes2V0T0WzeV3+Bavn+XRNOalK1BZ30y9GV3gBzbloqYDKn/s2JBb4z2JTIDpoyCDsCkqndLsHhH49J2I+UO/RiOTAHst+jf0R/uhAUJmRBzOA6EFMvDtpYMTt5XN0S2NqS5zIIZTJKe/HqmtS/9dcxemWOLEU/7ssExbmn0CRrT+pt4BFKvUHR5xRDAWGm+72bqGKp17hyzTSOIw4645tIS0flEvyzTL3bijy4nST0+/vV9veifA7VTgrsnEqpWeXVfS5qe4lZeGFE4uu1AUYwLDko+fqqnj9CNJnvi4Z6w8ysbevrhkpzxbLW78RI4pCy7LVfBPumtGcwpOhxtCM7EPuGBO6W3uktthRFP9Q+j2sZg+pPDHdssolnceAoEQsWwDd6+K26XQDbJ0B/pTj3yl42vpAt4yuLoTwwh3OwTckpB1bW1jdFj0mmj/NKmSttMtWIN0BNdpCEEXmPqdR11xGAq+O2SBYA+rlWsWzVgCneeZexe6mcpBD9J6SuHygnIbqDT8gAgfMk7lK1CPWQ41GvfMcQy6jFftlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB3816.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39840400004)(136003)(376002)(366004)(7696005)(6506007)(316002)(66446008)(54906003)(8676002)(64756008)(478600001)(76116006)(6916009)(52536014)(5660300002)(8936002)(33656002)(186003)(4326008)(2906002)(9686003)(55016002)(26005)(71200400001)(86362001)(66556008)(66476007)(966005)(83380400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nxJTEwFgx48L60GYYMoG9u8grAtsnjXxaRz8uVtXL5m14XH/GdjNEhnywPEC?=
 =?us-ascii?Q?zvUB/tIMtl3EM8lPdhLEJYCwv5CGUJEvD/vlSePM8m9TLfmXYqldNjbl7XCg?=
 =?us-ascii?Q?nuiBQo+NkArnP44tdgQHjBSKZ+BAVjujtC07EZke3y292pSyVRwHPsHZFLXI?=
 =?us-ascii?Q?JpoKoT1UfCg0+GwHVdAJq2IPEET9sugYGjv4wrNOy9JrJ7m15MUKVHG2UrOj?=
 =?us-ascii?Q?HKd9iTmy+c4bjNDZ1K+48o1iozpP2jRzVSmm0w3IetnTsidXGHaqBkUrEBID?=
 =?us-ascii?Q?ngzjy+/B5GQP8lqjIdEY4WAe7nGah+JELkn5I2DjN1tRn9ai/AtbvMuGtCy4?=
 =?us-ascii?Q?CmqWakYfTKqNtW03dFV3hynmHjbivt76SE9YmDJIh0tlTHuncFSlqpGDfchO?=
 =?us-ascii?Q?nO++i+9NRVCzW5cMnC/IWRWu5YB2/j3XLK+MGayTKjw+3Y7B+2rrYJqOOLho?=
 =?us-ascii?Q?Ve3uxE5eUTUBk6IVd6Wd2QWGHOG1yO2ksx5qAyrExE2LdpN9rFEIDGSAWx1+?=
 =?us-ascii?Q?0k4INNJxTuhkhsJ84Q/LOeaA5SiYOq3Sq07Uth9yQE33F13sOYImYfPP24i7?=
 =?us-ascii?Q?U9ta+zKc2U2Ciea6qu0T4q1Wc3S+YhOlKhvm73S3oiSFFCBqWJYxxI2nS1cv?=
 =?us-ascii?Q?fCyTgpgaw1rcPPabyTc2FatraHlpQ4vcyElKvHx1KfafzVHK6R4CEbRYAz/7?=
 =?us-ascii?Q?bKLY981iTWnd6XzzgLCX+TkVJT9HtXPWGs6mrsyPjrpG8F9dyNID3+5g+Vwh?=
 =?us-ascii?Q?XbPoKt1D92In7tl/zuWtuyNxNvI41whNii44B2dkUQ8lNlUNBfkSNNrGnMsI?=
 =?us-ascii?Q?P5KOrsUzK/Dvbyq+Sa9LuxVgYWqHlM4DBE9iwy6Ft4acrcndQ1kHhLW0Xm4T?=
 =?us-ascii?Q?VWGMct3KZVjDeqwLJwQnAgXI/qMI/pbNeVNqsNGyXTS20+rVuKXQEI4qxL7j?=
 =?us-ascii?Q?Za6uXdpUzpMw+hm6sOXSIpz6AiUXck+9+oJllghu6XlRmb2n6/WQmS6lTYup?=
 =?us-ascii?Q?F1XtePHEDgaFaL7vTSkksti7ro+sF95ec4tigdw03GpOddG8dJUqt9KtW/gO?=
 =?us-ascii?Q?q0uo7L9wTAe9Es60ehM4YQ6RVYwqHQhdqQMYH2cWu6vRxbrrmCuZTEbG9jRe?=
 =?us-ascii?Q?DWI0UvLcBuGAEyKtoko2bjR5JptVhL7fm10HP9/TUGY5o0JA9db88ITenjLw?=
 =?us-ascii?Q?3vLFtvzufVAdOIOvoCS2pGL8lcp5V3Nws9jtCquiA82hXPuWSGQ3ro0qKXjD?=
 =?us-ascii?Q?bWT/59O1tX60yY8W4eKuT+Z+vBAJiRGdz57Pv0+bV8RLnQsTWT0bBKiYOOEa?=
 =?us-ascii?Q?ckM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB3816.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b54f04e-97b5-4dde-006d-08d8e7b30aea
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 13:05:43.9576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RI9cNzST1KLpFCeN9G7WT/CLZXU7ZPDJeMQNCThkg+s6uE/ZhuKt2fd4D+tQWleeX/pYa1zNRp64iLvaTCQqRnuLbc+9WtjJtD4Kt4tOymGx/eIj6e9+C19IDkLhsO/r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6579
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following panic happens on the 5.10.20 long term stable running qperf w=
ith rdmavt/hfi1:

[ 1467.730495] BUG: kernel NULL pointer dereference, address: 0000000000000=
268
[ 1467.738940] #PF: supervisor read access in kernel mode
[ 1467.745052] #PF: error_code(0x0000) - not-present page
[ 1467.751159] PGD 0 P4D 0=20
[ 1467.754350] Oops: 0000 [#1] SMP PTI
[ 1467.758621] CPU: 43 PID: 42843 Comm: qperf Tainted: G S                5=
.10.17 #1
[ 1467.767370] HISS-219ardware name: Intel Corporation S2600CWR/S2600CW, BI=
OS SE5C610.86B.01.01.0014.121820151719 12/18/2015
[ 1467.779357] RIP: 0010:ib_umem_get+0x233/0x3d0 [ib_uverbs]
[ 1467.785811] Code: 02 00 00 48 0f 46 f5 e8 9b 67 27 ca 85 c0 0f 88 40 01 =
00 00 4c 63 f0 4c 89 f2 4c 29 f5 48 c1 e2 0c 89 e9 48 01 d3 49 8b 14 24 <48=
> 8b 92 68 02 00 00 48 85 d2 0f 85 5a ff ff ff 41 b9 00 00 01 00
[ 1467.807715] RSP: 0018:ffffb7ba87303aa8 EFLAGS: 00010206
[ 1467.814026] RAX: 0000000000000010 RBX: 000055ad89f11000 RCX: 00000000000=
00000
[ 1467.822457] RDX: 0000000000000000 RSI: 000000000000000f RDI: ffff8954bff=
d6000
[ 1467.830888] RBP: 0000000000000000 R08: 0000000000031443 R09: 00000000000=
00000
[ 1467.839322] R10: 0000000000031420 R11: 0000000000000022 R12: ffff894d509=
30000
[ 1467.847751] R13: 0000000000000000 R14: 0000000000000010 R15: ffff894d4a2=
fe880
[ 1467.856193] FS:  00007fb12f44c740(0000) GS:ffff89549fa40000(0000) knlGS:=
0000000000000000
[ 1467.865721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1467.872657] CR2: 0000000000000268 CR3: 00000001c0534001 CR4: 00000000001=
706e0
[ 1467.881136] Call Trace:
[ 1467.884398]  rvt_reg_user_mr+0x70/0x200 [rdmavt]

The panic happens in the call to dma_get_max_seg_size() because the dma_dev=
ice is NULL.

Here is the stable patch that causes the issue:

commit 404fa093741e15e16fd522cc76cd9f86e9ef81d2
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 6 19:19:38 2020 +0100

    RDMA/core: remove use of dma_virt_ops
   =20
    [ Upstream commit 5a7a9e038b032137ae9c45d5429f18a2ffdf7d42 ]
   =20
    Use the ib_dma_* helpers to skip the DMA translation instead.  This
    removes the last user if dma_virt_ops and keeps the weird layering
    violation inside the RDMA core instead of burderning the DMA mapping
    subsystems with it.  This also means the software RDMA drivers now don'=
t
    have to mess with DMA parameters that are not relevant to them at all, =
and
    that in the future we can use PCI P2P transfers even for software RDMA,=
 as
    there is no first fake layer of DMA mapping that the P2P DMA support.
   =20
    Link: https://lore.kernel.org/r/20201106181941.1878556-8-hch@lst.de
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Tested-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

The stable backport missed a prereq patch:

commit b116c702791a9834e6485f67ca6267d9fdf59b87
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 6 19:19:33 2020 +0100

    RDMA/umem: Use ib_dma_max_seg_size instead of dma_get_max_seg_size
   =20
    RDMA ULPs must not call DMA mapping APIs directly but instead use the
    ib_dma_* wrappers.
   =20
    Fixes: 0c16d9635e3a ("RDMA/umem: Move to allocate SG table from pages")
    Link: https://lore.kernel.org/r/20201106181941.1878556-3-hch@lst.de
    Reported-by: Jason Gunthorpe <jgg@nvidia.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

The missing patch adds the necessary RDMA wrappers to handle the ib_device =
dma_device member being NULL.

The missing patch picks clean and fixes the issue.

Do you want me to send the stable request?

Mike
