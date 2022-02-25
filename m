Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496A54C500F
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 21:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiBYUvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 15:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiBYUvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 15:51:02 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6542028BF;
        Fri, 25 Feb 2022 12:50:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4zE7JcTLAwiqMwutgp7g8aZbBB4i4oog/kzEWf+LK4nb4VIaeMKQdTKMjsJdxQeBu6cETD8sXgbf2UiyavNC+It62VK+O9zJ9PB4eIT6IsSAxhyPATdtfHMVUG4hPPFpK22h9KdKfYH9h7rpLTQ12woxjzeHi2oFD0httX9snwZKvy9P86GXfOzAwO5fHOYvUeBWjlqntQQF6fBNeoRqWtDMsd4Mcoc9MbDkzJ3lqdRyHk92vFPHenRFwkF9f4jiM5z4YlHDrylwHGmO25qd3O2bd8A2gYFRdSTJc/NM7T45/TFnps4xEeUand7h7/zi5mRjqIIn18MKVt0ZfYVSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EivldWO3M6ptXc6cX31agRswFjNtyn4aJTFXcjHKBqw=;
 b=e645XP02bzZxYnKMGkM66z/rwIz4f/MDk2gY3ndiCXGosfMMlkJWRSmuufJTMpHbZ6BCtJvZgNxVDXrv2tPFs0P3xhhxeIcsZfoRdwM3Lr92ashZIGPLubpp/yjpVcas9D1JG08NFYM6+AuE+95a2YSA2FFePvxCgDZDB24Iq6strdD+2hDIqRpqI8d9W+myJSoxfNSzR4mfjx+z6roZFZT48H4IP3PFzoBeqRanWqfFdkew5iomxbDm/AMHZbIerKYTLVOi/IAftA4m13qAnQXUtijeTC/Zps2dX2rniq7gxLtyZsZJ7N+zMRoD3bcSw5Bqq1wfQDa/t1Lwz3/cVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EivldWO3M6ptXc6cX31agRswFjNtyn4aJTFXcjHKBqw=;
 b=VhCe91lcAXASY6hr30hIeixjHI+4kJ+HK6cSuxV01EYwQ/3Kuq915ppUCURrs560BXMG96fXXMZ45u30oHCpErHTbHyb9hI+hgiUPh9dqHfyVkMLSZzJnXqBtnEKT5XNr5OtWozKiVcopJumciW5ZtihwL690KXt8yjvVG6htMRuIWhkgh8dqO0IVju8o0q10RX0QXJy3n727C7iBF3PJ+GuVxqCXqsHHkjUslJ6c9wiFMpcswAVnHDP0n8PXFdeRvD9z3UIymrUW/q8/FWxDcAALO62dryffOKsfUKhjV931SYXRAlTeqqb/qvVnU/1OuJ553usJaSCp/9qtPHc5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1345.namprd12.prod.outlook.com (2603:10b6:404:18::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Fri, 25 Feb
 2022 20:50:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 20:50:27 +0000
Date:   Fri, 25 Feb 2022 16:50:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>, stable@vger.kernel.org,
        syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com
Subject: Re: [PATCH rc v2] RDMA/cma: Do not change route.addr.src_addr
 outside state checks
Message-ID: <20220225205025.GA307408@nvidia.com>
References: <0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR01CA0066.prod.exchangelabs.com (2603:10b6:208:23f::35)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94631ad4-0caa-40db-dfda-08d9f8a073c4
X-MS-TrafficTypeDiagnostic: BN6PR12MB1345:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB13456CAB442444FB6847521AC23E9@BN6PR12MB1345.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: al8OD6GnG1z72bvunce3v83KwrtsSXcrq9u+G86An8ccuM6kDHBc2+ac28MKkcGJ1hKU9OHOjwvbJGs5wrZ5e1q+e3nWKtEmjqn5xEvgA5LDK+LsI7oaYaD/HshCFdfF3T5xs3Rt7Su2uI384sdB+i+eptbz8aUJtQaN/9rPiLUjqZdfzwbrGMuUl9weB8gy1N1bRyYfwQIIx3Ehgd1EFwU1CXNvviYx0QCZXhW1PXLWDCzZ3EvaiCmz6IMz5YT2AwwAkX4RPuAhIrouBVkqVJlU8HPC/ngLi32bI7+TYYU5eJcacEJNqnfutVEO9H6OUMZp0BK6N/awhvglNQy2VJRSG7zu9WBg1eRm31dDafmo+renZkoIbi38kKCO2jR1wCL8xO3p5Qmi31LWHtgEaH0CUDf9ySkV485vKbCFagoUbf5o3oby3zSuHSzWR/epVWLdZB6Mejqoffni+hSRYNIHPQVvUd3e//v0murb4goiTcKgAhJ7rLnXVUQf5sMRm8owQ47zl9jp4TvRXIQziBg8plC8a3ZSFlNs1UJDlQz1yJAxAgkNsr/Z3OgbOF29/14LDLpQtI5LR22ErVUDtUYAaqKdUWJe7NpMTa+rgkJAF1IFEZ4OdVfbjGRZEI5c/zcCFxRBz2e169NRlS9Gy9os/eO/bbr6+INfUJUXzGR57BHYEvDl8OH2+sgfsRPL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(1076003)(26005)(38100700002)(2906002)(86362001)(8936002)(36756003)(6916009)(6486002)(316002)(8676002)(66476007)(66556008)(33656002)(508600001)(186003)(5660300002)(2616005)(6506007)(6512007)(66946007)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1CxWl2ltxp4K0WUVbkbjbaVHrM0GIpo+ndRbqDxDV5wdnLkMCbCXRoaE215?=
 =?us-ascii?Q?+HQDDwQFqPc8J3yDY+5DFJ7ZMVv0UIDWSPPAOcrJnuTNkb3KsNeAlQkWd9gP?=
 =?us-ascii?Q?klNkDZ6FLDVCJ2zEMN8tTpZQ1veW2xKnjTPrMUNwNfdRWk16soal+KXsClZk?=
 =?us-ascii?Q?jq7bxDVBslBkGSVaRuTuzgHpOupMwWNEq3a108MxzCGXHbMm6xYPiIge9vn7?=
 =?us-ascii?Q?r0TTF3/vWYb9f7ACbYq9DANB/7VVNtwZnE3pKH4QX3I1xw7+uDArgbhwedcS?=
 =?us-ascii?Q?um4dHJl5flj7PY8A+K3qBCjZExLmw+1IhRerB9zutUHxj6nl5LvF8TrdgvwE?=
 =?us-ascii?Q?PrMszn0cKDIhrAe9NQw3hBxsbnVMq9UZZoCyr67XUdo/8wkEgoXrtRfN2L4B?=
 =?us-ascii?Q?yy+W/ClmliO3942ubuROzI5rAhr5BDVgxkqBi3ni5kMlZcSEQecFxTXbRQ00?=
 =?us-ascii?Q?7Gj7iAZ6H1DcEwMp0aNtFa8GNdDo5D97tP8ekL2pCIIjcFr/3o3CqBlcqDvw?=
 =?us-ascii?Q?WJkk1zjthS1W1WrqgF99u/i05JdGDCQ2I8XBdosP2ra/FDw+6Wl7f4adiU9/?=
 =?us-ascii?Q?c5cGFeygias/b+4B1Tzqjek/WT1HkiEzZvDoWVZN9Gv72se/EL6gq4DjK2oB?=
 =?us-ascii?Q?LXh+96G4Ol2+fLFlkXmYUiaOvq4zXiZIi4QrLHPKVbTDiBNqk/3Uo8OlsQ+5?=
 =?us-ascii?Q?7GpmGV4TbTP2NJB4v02q73bufm022INWAAklYPLyvbtja5q5i8qE0qd/+On4?=
 =?us-ascii?Q?roTwfTAKReCfpng2iQjMvgdOhtECRkS0MKj7Yt1iBkWAnIqhYUIPf6WxW1RI?=
 =?us-ascii?Q?33wo5iIRXqji9JR5ydrd4yO1iITg8IHYANDyD6j0EkvdYcb4IebXKbGJpqHw?=
 =?us-ascii?Q?kheyZAKti9RDl40LBFKfOQsigks1cDLgoG5IF3mh9q3p//cwIqueYsl9XRJT?=
 =?us-ascii?Q?qh8Nv6trHqmeiF75TGucU58w46ROuogkgjSPZk8WVrVmJ3d3uNCaHs38Pqmd?=
 =?us-ascii?Q?0VHgNT3ylx8JUDhBUTlm3GdW4zSnU8h3pCT6mQJARi/wxOBekiYUb/PXD3S1?=
 =?us-ascii?Q?kJJOduAUG6QC+LtKx8IG2BIF7RyAJXs9LpcVZCpISfB3hDD2dVrDmYtIcj8v?=
 =?us-ascii?Q?CJsja4vFe9Lr2Useg+rOeEUqH/A2FLdGYk0Ps9c1atK/hJc6TsuMzQzfuSju?=
 =?us-ascii?Q?Vyp7Ij+NXyROqMkLA7As/omfEfvHuq48cZVFHTwudhzCcC0mkFeqmEHTcdQP?=
 =?us-ascii?Q?g6gDHf4D3Dcum5R83OVrZ/qiaS2ah31uZFic4xJ106kIUPnH8uq3goA/H1DW?=
 =?us-ascii?Q?fmP8d0eun7ZS8BBvlrdUCbMrwLtdmUF4mrv8yAE7HfI4AFSZhj+6Ys3CJfiV?=
 =?us-ascii?Q?jcILivG92eQpqqp/RawVR13konMA3Bk3PpFAORriTiOgdGkCRk50GGJLqnrR?=
 =?us-ascii?Q?4+3BKeTkMy6clsKzp5LitrFNr6mQFe/8zmDSL0XmTNnO7HQL8ooGxkpFYCLe?=
 =?us-ascii?Q?lXD7wfx879bnIC0ozt6AVJlzUtZQhSGyORmUTHpfexbIWEBK6ypK0lB06fXR?=
 =?us-ascii?Q?tNyj+Q6Cgbc8wy7XNfM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94631ad4-0caa-40db-dfda-08d9f8a073c4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 20:50:27.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o+bzEc5NJzNFQ7p9KBPhMnhQJ/KYgOSJV45EdJ6yyvN1HC5zisBk8c2k5hieA7B2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 11:23:57AM -0400, Jason Gunthorpe wrote:
> If the state is not idle then resolve_prepare_src() should immediately
> fail and no change to global state should happen. However, it
> unconditionally overwrites the src_addr trying to build a temporary any
> address.
> 
> For instance if the state is already RDMA_CM_LISTEN then this will corrupt
> the src_addr and would cause the test in cma_cancel_operation():
> 
>            if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)
> 
> Which would manifest as this trace from syzkaller:
> 
>   BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
>   Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204
> 
>   CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Call Trace:
>    __dump_stack lib/dump_stack.c:79 [inline]
>    dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>    print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
>    __kasan_report mm/kasan/report.c:399 [inline]
>    kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>    __list_add_valid+0x93/0xa0 lib/list_debug.c:26
>    __list_add include/linux/list.h:67 [inline]
>    list_add_tail include/linux/list.h:100 [inline]
>    cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
>    rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
>    ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
>    ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
>    vfs_write+0x28e/0xa30 fs/read_write.c:603
>    ksys_write+0x1ee/0x250 fs/read_write.c:658
>    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> This is indicating that an rdma_id_private was destroyed without doing
> cma_cancel_listens().
> 
> Instead of trying to re-use the src_addr memory to indirectly create an
> any address derived from the dst build one explicitly on the stack and
> bind to that as any other normal flow would do. rdma_bind_addr() will copy
> it over the src_addr once it knows the state is valid.
> 
> This is similar to commit bc0bdc5afaa7 ("RDMA/cma: Do not change
> route.addr.src_addr.ss_family")
> 
> Cc: stable@vger.kernel.org
> Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
> Reported-by: syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied to for-rc

Jason
