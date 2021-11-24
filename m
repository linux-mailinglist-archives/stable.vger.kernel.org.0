Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D045C2DF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352095AbhKXNeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:04 -0500
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:36068
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349492AbhKXNbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:31:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF+fFC1IzM1YUpKPiH/y+54tFEzkGJ+rhEdQf6k3eU1b09wZG9gdREkxEPt+7iQR0OdR/w33JlEw4HKi2xhaIbyg6xMHHYzH86BJUmjWrb922OxtFQoKMntP0BpVvyMYC73yWb218tW3RN7u/BW/qVVh1TRz/qNOOySevtka4CVaaQKb0RtQ4IunLC9fu0SlJ08LAvQMbYXMeeKNRPJgznynUaGUkUpEYVwC5l9mIBDk/4+r/X7x9tTYYZFx03IvnGJOKvYFxEOBY2LrwMIy17J/KM/2JjpDAgf3aFgyCmqhGhf3L0psVCLnEDLBYiC2kSME6AVSgMm3NN+dRh4HZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dF49bDpDHAwxMeu5ItFTKxpK/pqj3abqT20hYYE+S+g=;
 b=R/zhuRDG7zzrOAGIMXMHibx1qzVwkNKU6HvDC5fWRKD5YKKIl8XelI5bh2bHCd3GZrYHlpyHY8EKtwqi3k7WiXAyoJtdaYhiVJz6gKiojOJcFHAM0xG6cO3bge+OIUmfIbwPRwt3pLBOaBwUEObXh3tmFqVAKtoY092lK2yG122BcZ1nW5gmw4TD4VCk/st2jdVS+U7C6ZnXUSqrgnrXOERHXh65IWQqBZyL1kMBgi2HHN23AQsejGRWyf6IkeuvRytwmfl+KZzSDzFMoEo0dkrC7K8eBjEhzQtmI7NP1XhkFPxyk74sML9XUQXCUa7rNYg359qeWisLFUxmBqXT6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dF49bDpDHAwxMeu5ItFTKxpK/pqj3abqT20hYYE+S+g=;
 b=fKSQm8pBlb4u1fSBJOY9+/TNpFT6U9OQGtNms+O7sl2xOExObhpA+rxx9ciSLFdGCd2Gi2NxxGM/7XF3wb/U4N5a4G2SoLiIcYyBEmDKoJ0mPZw9/O3aSRVtuhv5gnHqa6vxxjPpFZj3DwAKti8zcCmlTUXJEincKZfnHtXuA1hkifc7lSr1IsIvXlqtcnsaYrQF5yLkppt2IS7RYxMKu861vnfRq3UHAD68sZXoaicAGsEOWYl2N2B/aNDUjGBGAPTxH1C2MO5GdukJTk5XpxcnJD8YRYqvma0g1DCyuvyu4UMuHR9+EN+9XHKN1zGeit5+TKV9zGdNxf65YEGOnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 13:27:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 13:27:58 +0000
Date:   Wed, 24 Nov 2021 09:27:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 181/251] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211124132756.GH4670@nvidia.com>
References: <20211124115710.214900256@linuxfoundation.org>
 <20211124115716.547727004@linuxfoundation.org>
 <20211124125018.GG4670@nvidia.com>
 <YZ463j6mlk/UUwar@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ463j6mlk/UUwar@kroah.com>
X-ClientProxiedBy: BL0PR1501CA0034.namprd15.prod.outlook.com
 (2603:10b6:207:17::47) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0034.namprd15.prod.outlook.com (2603:10b6:207:17::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 24 Nov 2021 13:27:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpsJY-0011FQ-TD; Wed, 24 Nov 2021 09:27:56 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2832e2ff-cc86-483f-5ffb-08d9af4e3ac8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5158BDF0F519CA83550DA8D0C2619@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:85;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrRvKLsr/0zM09bJ20oMVIKNNc3VQWPxMOGd6e2R15yR3jYBpx23g5xB11ggUdChUb4gi8nQQdQsMVyoAQwrncEyFTAEaFAPwXRSWe+Om4wZnCSKW9XnLaAga5myJ6+hvRSKaxKswFQLw9ac5jl/jhS89unCnq0CBFoXucMgtIBlm9J4XC6jqqIh5mCIgCfgJUZtraQuJP3Y4WbME1HCThey5DRQn+G8MStlMKWHjmFGQBmwbwTkLaVKUf5IBXwLaJmTuP7EPHK/1lnDThzEI/K0nohe8XzvypXYck+xyqd0i390eO5GwZ5dYpcYGgQVmMLt1ujY+9nhuS2PFygEE1MeR7KFLM0uJpeERp566l5EAtWN0ATqF8vBW/ggQjMDvPX/hKwgB7h6mALsUqq8V2CHmcYxbp6baB/eJzsoPbXmLpBSXClIlFuA/0eMhU5eTOKXMvSLy2xOWgEUZPJymBwbCm+Lgr8IO5y5e1mqZXWWpaLPhdMWX0zc9kKgKHRWFsAQHGXuuf3SWUk3E4T2wNuvBNui+fKEGrlzen9+FeBjmKq+7Bi9tKQyAh6yUkb0AKXfb5n7ij8aIvDM8I9u6Pg6tuH4WIuCWox8FbtscRS5LVbkkfPdz7QTYJut9UrGYDqR/Wo4HNUXy1TwJ9MJIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(5660300002)(33656002)(86362001)(186003)(54906003)(26005)(4326008)(8676002)(38100700002)(8936002)(1076003)(9746002)(83380400001)(508600001)(426003)(9786002)(2616005)(66946007)(66556008)(66476007)(6916009)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cGo4vFQ2qxJzhGDCn13V8rEhnYjeXr/gGzU3ASS1SJabuv2dx2XpMHnqSN+0?=
 =?us-ascii?Q?GbMpHkfPZgDVucwUzNK8zFMCAem/zqtPLr4nrnkksxDP7WsFxTCkrp705QU6?=
 =?us-ascii?Q?U+2BJbNbUdH4qYrLPAvoNANlDe4SbAYtOKV1K1vHBljjg1SfnmM/ElCcPLGo?=
 =?us-ascii?Q?P0iv7HEY/Y+nxJtF81PqxTeSF/B6KCA8tbVp/+atMl2USAjespv8aeS3f4GY?=
 =?us-ascii?Q?s6UBBLTBhoLfnJO85eLj8WAzNRHPgezTj/x8NonpZuL4TU6RhycsUA/MI+sL?=
 =?us-ascii?Q?9BTLLszeJ7swpP0DXpwGxUcYa/02070aG5ATruW3GuL1IhxTXrKwBFu3DgWS?=
 =?us-ascii?Q?JokVYPtuBCz25+juBAIPOj6mLBX6N/lmpn8Nw1wFWTo7Ew5bNa26fQQmETf+?=
 =?us-ascii?Q?4XFyCbGPu9pivSPBY1Pvz997YCLk949c05h4eNgHXYM3kpIzDIMA7CEVrUDe?=
 =?us-ascii?Q?1jORGeHLogm/GAS5GG+GRpjfuf+gtrzgVxfA9iTDa62pZGy+zt05nlIrUkav?=
 =?us-ascii?Q?y42CVDIlA0sjygLdsxkOToVj3zc8gQ5QkIxPIheAkYE6cypbay6im0Oq8KeY?=
 =?us-ascii?Q?JvNlyGqnEfiO8HAnDycEKtAJQbT2kmAALkJsfk1etoW8JEG0x0BVaAWlPYai?=
 =?us-ascii?Q?RcD2Ov1EJE+6j6YOiw7D8HsXkPx6J8+zld4oxwR/vTqxjQ4cVcHKdCmPLlbG?=
 =?us-ascii?Q?4h9Z/VONMSkCNhCnuP426rNBMQ6Ckf6r2BiIdun2e6BdiQFbhRmKdhDpoWde?=
 =?us-ascii?Q?V0RG3+aNMPonIU2vro3gOtgtKLJ4TruXRmH6cKkW21KyjT9TosBMxT10+sst?=
 =?us-ascii?Q?vf1L2nZPo5yCTfaVu85cjnhs7pCdIpxR3835HKub+ez6/8MZhKb0BgXHbq+I?=
 =?us-ascii?Q?OyXI7nfWrJfO9iOTVdBOmdXf5FJvWLrF3HvOZjEnU9VVuEeaLrcuOmMW+LN0?=
 =?us-ascii?Q?0FOVdmQe5r072MqOnTheKlSfQ43Skw8ZKjBejqjthFLvb6uvJnLEZcCsyh/8?=
 =?us-ascii?Q?CGTua/HO40SE2V+EjobSWILMkxyQlBNYatCu56wbKA4KaIYAIkvCzgw+wfMI?=
 =?us-ascii?Q?zZb12me2nLF5HUGLShBnvpzHhTP7CfikoVfVDVB2VWFSELAPoAd383GnefNZ?=
 =?us-ascii?Q?3HpSAVfwjWFGWdtKVBwdgEI543nYzn0v9IEDOkJ4J/Yaxk2I6CAoyTDG2MRG?=
 =?us-ascii?Q?245chB3sWSIolPOMXvJQXu+mOMM1GGyBu2sLs3sIwTyj01dHv3VDQjQR2C8r?=
 =?us-ascii?Q?7a1wQ4VFruzyEwx5wbmaR7/ide3u43bXYQCEx0j8nZtlHabmshViyeVfeCX2?=
 =?us-ascii?Q?VRDHGcPAEiZpMSgTR08FFlTYBPhvW2lSbV08PQPVjeTWA2Zee9kG744d7rU4?=
 =?us-ascii?Q?XqqpU8NiVS8MiCPGCYA+AnFFj1iq8dA3619h5iA+xfp15MoVbT3a1ylLOETg?=
 =?us-ascii?Q?n26rxeArfEytMx+CkEhndDxMaDMGf+OGnyy/nKnQ91IR6re+sB95AwWhxHcy?=
 =?us-ascii?Q?r3VcdfyDKmR2wL/X3haLRaRdnsW6DC6iRRtKiyr3YTzVTeMCEf9IbMtJdMkk?=
 =?us-ascii?Q?iaG+S6P7rqFTRq8+u2Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2832e2ff-cc86-483f-5ffb-08d9af4e3ac8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 13:27:57.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CecyDv+Wt7FhSKhjzgPnwOtcXuYDsw3t8OK95S6NAN60osUSotyNCru4KQ4PSNpu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 02:15:10PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 24, 2021 at 08:50:18AM -0400, Jason Gunthorpe wrote:
> > On Wed, Nov 24, 2021 at 12:57:03PM +0100, Greg Kroah-Hartman wrote:
> > > From: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > 
> > > [ Upstream commit 563bcbae3ba233c275c244bfce2efe12938f5363 ]
> > > 
> > > The real_dev of a vlan net_device may be freed after
> > > unregister_vlan_dev(). Access the real_dev continually by
> > > vlan_dev_real_dev() will trigger the UAF problem for the
> > > real_dev like following:
> > > 
> > > ==================================================================
> > > BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> > > Call Trace:
> > >  kasan_report.cold+0x83/0xdf
> > >  vlan_dev_real_dev+0xf9/0x120
> > >  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
> > >  is_eth_port_of_netdev_filter+0x28/0x40
> > >  ib_enum_roce_netdev+0x1a3/0x300
> > >  ib_enum_all_roce_netdevs+0xc7/0x140
> > >  netdevice_event_work_handler+0x9d/0x210
> > > ...
> > > 
> > > Freed by task 9288:
> > >  kasan_save_stack+0x1b/0x40
> > >  kasan_set_track+0x1c/0x30
> > >  kasan_set_free_info+0x20/0x30
> > >  __kasan_slab_free+0xfc/0x130
> > >  slab_free_freelist_hook+0xdd/0x240
> > >  kfree+0xe4/0x690
> > >  kvfree+0x42/0x50
> > >  device_release+0x9f/0x240
> > >  kobject_put+0x1c8/0x530
> > >  put_device+0x1b/0x30
> > >  free_netdev+0x370/0x540
> > >  ppp_destroy_interface+0x313/0x3d0
> > > ...
> > > 
> > > Move the put_device(real_dev) to vlan_dev_free(). Ensure
> > > real_dev not be freed before vlan_dev unregistered.
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
> > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >  net/8021q/vlan.c     | 3 ---
> > >  net/8021q/vlan_dev.c | 3 +++
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > This patch is known to be broken, it should not be backported
> 
> It is already in a bunch of branches :(
> 
> What is the upstream revert of this commit in Linus's tree?

It isn't in a Linus released kernel yet, Ziyang and Petr are working
on fixing it.

Jason
