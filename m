Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306EC4C2908
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiBXKNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 05:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiBXKNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 05:13:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE9716FDDE;
        Thu, 24 Feb 2022 02:13:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWk0UkMgEx7DMOHVqar5a7mI2d0Okmsvgh0rWzPFcwG8hXIQa+TlpicnVKbqNtvloV1PAEf1oQHP1xpw+/GcBpNMYE2jgaEYJAIw1ZAxiNc2jrUPw8YWupD9QzFq8XtKdOJ5GX1SdphiCy4UP15bQz9aVBA0fsgyIK5EgIAG7WH/QVfQG10iqHHlm8C8ishOtzifhHiS+BV3l+l73Sg5wKpH7sU9U/YXIAadUnheSJkE0XhSFMShoeXp77EXWv0iGaFa7cfeOx6mgfveBAMiFjSbgyH1Ob8hRGaQBpuALckvTzXH/pBVu3inLWFQLu9K6aX+i+T9E9HYvIPi0IgjdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ma2FRf/G15HOgupp2+18bkoFlHwi7IW3VpIpgUYAgtA=;
 b=a8GXRvDcAgqbDGeGNmQhEGVqPTSMJ53jr7nfxGZEozyHn7IDrRhqV4ZtMm5MjmVAX2BQx5AuaJpHkmktObZTpZHK9QP2Aq7upZsy3st3slISYmiZJ3ZfRx0fJE1Tdp5+6gB9zCPnKxLGQ98DfAthbOpLlVPjS3iKWJRv3Jddv8OKbw4Gt//Q5KFZddJDIy2r/243sO3mM0FNn79erN288kFxIHA6NmLEJISUgZLpYXATgcKMTwOMJGaKaTSM2nzV0iWGCPHnXAhJaF4h9ZsaAB7v1TK+5rWNYRsrFQISBucTs2B93ptemKoqc3DDilzLfN9mql5RyxoiiglJnyDo8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=syzkaller.appspotmail.com
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ma2FRf/G15HOgupp2+18bkoFlHwi7IW3VpIpgUYAgtA=;
 b=DiubeWS+txGQ8dPN2CK+b6twn8DmJDGyHrAZD4EpAlmEsWcGqodg54S3W4EAZ4uASHKVfC/M34asVd9YJk1g3IPNEHrynIUAhHX3qNulhPpAOppMqnuqQxqhipSa0oothIOPZgq8mqG5srSe4zi9OMfqq3ZjOsojYcGfEqHtdVOSqkD6oVS5vT9J2NeYkyk5ii2Dg8ZKHFMgohYxqOkLDWTvmGggDUfk2D2dvFK1xMIILkF61jqJ0oEuO9ukTVPN58D4kG2HiL2cK+XVBijsRriCNqxME8zGjlt72pqbidFKqpwXeFmlHrBBIbcixfRd8q4LnV6YZeCEM35fu9bxYw==
Received: from BN9PR03CA0606.namprd03.prod.outlook.com (2603:10b6:408:106::11)
 by MN2PR12MB3616.namprd12.prod.outlook.com (2603:10b6:208:cc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:13:08 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::88) by BN9PR03CA0606.outlook.office365.com
 (2603:10b6:408:106::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 10:13:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 10:13:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 10:13:06 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 02:13:05 -0800
Date:   Thu, 24 Feb 2022 12:13:01 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <stable@vger.kernel.org>,
        <syzbot+c94a3675a626f6333d74@syzkaller.appspotmail.com>
Subject: Re: [PATCH rc v2] RDMA/cma: Do not change route.addr.src_addr
 outside state checks
Message-ID: <YhdaLR5HxufjCiot@unreal>
References: <0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-e975c8fd9ef2+11e-syz_cma_srcaddr_jgg@nvidia.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c948f05a-925f-40b1-e910-08d9f77e40fd
X-MS-TrafficTypeDiagnostic: MN2PR12MB3616:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3616C094C846849B86B312E4BD3D9@MN2PR12MB3616.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yGRXQ8Su5wKcIoElzDLv6fqyqyZrufZjiB+6QvwMxoS+6WkSXQtcdIkyYoLT183enNco8BLHPyPrgAbFMuRfUaMa1SQXylsHLp8NXQ39Fc0wTR5YSCGYpwz77ueGOZihStcyWwLvzgHEPni58z/fdKshVkkxLdityeGi1kQmXU94N4BfrxgHkCZBKkYmm6paUlumwB2MCHc6aICNlfw7pVBGFR09yUjfSuUFMXe8TTz4zVzKJz7nFHENGiCv99T9Aou6/3EcKXg5/hVsWvgF4m7yWapufLU5rF61apNqkKuuBSc58t8OJwuDTymdEveSs9wf0KXQwxb29Y40+MoTFJ5JAktTsI0Ov4aRxKZqRQbHAJta0Xt6cU4OAFjHc2e07tWPSK7D7TGYIUouC98mOPfZQpyHguuHIRLPmKJKa1bYn819fpEEan/G4BbE5H1jOmCIWU59saF+SIVFTctjldNjLbYm/4GukLB+9CuVLTpUFjoRMbj7N9UxtyU35ALSuWe5yGyAb4b6erz3XKFZHAiR+Pqw9bit9Vx1N/12+JmQGLZ62eqDCYnMly7ozA2/jQkELRXwII5oIwmudRYkvkYTXCgUs5FemyzQI7amS+gGbUjz/flhJ+J/sfLCNe2dlvP0Iay7vCJtp119FBWJGA6Vqz+tKnxrU0E97/SvCZzhmslKWjGr1KXSOEpaVzAwAMl1hyFObxWjId/2SSaFag==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(7916004)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(8676002)(6862004)(33716001)(54906003)(6636002)(316002)(8936002)(40460700003)(70586007)(70206006)(86362001)(26005)(6666004)(4326008)(426003)(186003)(16526019)(336012)(9686003)(2906002)(47076005)(82310400004)(508600001)(81166007)(356005)(5660300002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:13:07.6239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c948f05a-925f-40b1-e910-08d9f77e40fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3616
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
> ---
>  drivers/infiniband/core/cma.c | 38 +++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
