Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07EE40CDE2
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 22:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhIOUXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 16:23:06 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:38112
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231490AbhIOUXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 16:23:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/+7gGHMiHxWCpzrb/a3CiDTlXkUaY+uEYABTZBMBzHaM0vqHUfrmiWXqZ/0HLTznCO8ry2PE7I+N3CZKKq+7jzl2+BAU5sCHK6TJgJmTGe3IkxJYHEfE7S4lzN7M84Z9TEOVa7IpcUxSPuipnLK/HoLHB6Lu8OyFUJtG63G1eSJNI4C6pFWgHUVqhL+zNVq3x6sgwrj6cXr3BaDzLeT+kph8htHtuZyL9kQNQVkrVfA1QGMo6lIJrt232PTyEancz2OBhEYXI5uBfr6ppHp72crHTfEVaXjSWP1v6jYBUySBYJp/sQ5W8gXfM2rzDmBvO23XVxZXx8G6HPWl5W9mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=09FsUCrOiWP3k/P5SbaF8aRMdTZV7nXQuqaPyGx5gbY=;
 b=a4PgjNr6KFSIAgiITZCE2I0Wonpa1TPYvlFZaasVpt8RKAwTy8oiEKBUPHQdoEpma/zo4t9kOxb/ZwdgBHe++8nPw+iv4ohhRVdqwiLnhUIU9cUiR3eblZuU6yLE2cjkKiNJMXwZN65YmxK2iIyFwOk+HYrwTzzJuqDqoGEmvSrN1BAYPMTr34khDWExLULll6pzCWfu911E4Fos7krHjJBeTWNz4cJOD+nJgEtraI0TZg/q37OxTd+hhyUeH0XvwFhZJ6yHQuzoB131M9NEectar8ca7Rd7SHcYdK5Hh90KjioS4+HM3heAfjxxb/lrIrw6qvRTNompZEwko+tg+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09FsUCrOiWP3k/P5SbaF8aRMdTZV7nXQuqaPyGx5gbY=;
 b=VwFHywoOVFiepO7VhKXENerBZH3rkHU5gz9AbtLZ5iIPlqeSLejyqA0TGl6MqjrqKsqtVVD+S3o8Ss5PHEsdWqgQUevu8KbQF3a7CshUQ0jNx0U3G4Hj4mjCiJWecc8WoJMCrvihIfJ18AkMPVKA71pp5pitVQ9ZcjCqeZkZQm8KscjgNgnPgkmtjsc7EdWdQ/3CEraXkR5TAViNHfGPW6W/AkuW6NbqIhXlzC5ErieBT1f0w7omEWy8PkbiyqfJAphN3TdL+PrilUmDUCbZEzpRfclea3/V7UQzVeBSMXLINz61cqGjGxgykhxFQHixxSwfPsxJyE2dNEtKUaKnfA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 20:21:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 20:21:44 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>, stable@vger.kernel.org,
        syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com
Subject: [PATCH] RDMA/cma: Do not change route.addr.src_addr.ss_family
Date:   Wed, 15 Sep 2021 17:21:43 -0300
Message-Id: <0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:610:119::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0366.namprd03.prod.outlook.com (2603:10b6:610:119::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 20:21:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQbPb-001ApK-B4; Wed, 15 Sep 2021 17:21:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49f45fdc-4a02-4ad8-29f9-08d978866fa2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53493CF69D9E27E4F78D56FFC2DB9@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXoecfg2p3ErL3Q3i5GcXDNbObjLxkeTAtGJOViqj2lJwddzFBa4A3GRiIG2d++vbUO5wCyCAsmOaTfdq8gKgCJUzxxTSJF3/JpCYZzVW4L5LSXcaZZSGEMW0fRiC4KxuuKYvzRH8D9DjaAb4OvylchsT5HYhUafkYX4Yi2t4wT93Ze1tWQBb2LJZhT2zYd+MFAcyWCrBE/VNJco6/urtzBgMKDwf8EUWGqvxJ0pC0VmTseF6cAOd0+50T67t5Zc5OlD9Hx8KtfSPT3/0OtslMYV8A48O1LN6T5efjetuWOSa4ZZ/xU80T8VdLTYM+ou7mS76J3/y8JcPDuWtuzkiMZEJX6kbDQkQp/lhImoZ2TkrbPAGT+Haey3ew5LVkiJfJeVAj6RmU9vQxHUGYtrc3JzlET5uixMZlSzLL+aQMzPTaQ3V/0ru3bePC6wbE7SwmYJ/tgDSRJyMlVpTP1DaLomsu216f6v2lk9obVtdFVqGK7NCNGDKrB9lLUFnc95IuNazd0DlRGpNWGg/KkiVcNhlTHBEjTZRA0k8FXjBMrOHGkqOkL7uTPSOMUY/sjsyoS2hR+A42hPqsGMXv8VT3P5GAG7huKKBvyGix4dUtOzjdMLOj2FJEG786IWWhAAaSDEkqYh3+xGIyWsXQysKiteESDt4cyJrdm1C4cCmBZsvzIDp37ii1UFAXV088uc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(4326008)(186003)(9746002)(2616005)(9786002)(36756003)(2906002)(26005)(66476007)(426003)(316002)(478600001)(38100700002)(8936002)(83380400001)(5660300002)(66946007)(8676002)(86362001)(6916009)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GYwbxbNOcL46BsFQZaYhoYSqhXJZOmzsKEJu8HAbIy1p1OTeMSx8C8b4bjgw?=
 =?us-ascii?Q?3M3yKj87T0kvsMgOxr4vlv7g0cYSHYaeUDy+WM1cHIrJF0vu3zUgax6cC2f3?=
 =?us-ascii?Q?DRs+rfKsEjqepCbao43iUkMvishsg87AC+umv1wPZsdpHpotvNyGaDcTon1h?=
 =?us-ascii?Q?Pd7kbf+aJbqTPyvbt0XFTtPY5RlvbeJ2l0u3x8arNwCHN431Ynl2o2loSm8H?=
 =?us-ascii?Q?1m+l4dMWMY6IgaetiUtCkwinSt/kuU6yVWCgQeqXMR4mgu1F7i3nmLqg8Wha?=
 =?us-ascii?Q?BYnM3sNACd9EXjZbx3oDEZki0Z39jvOWjOdip5dDu6rFm/zleDSVjLt9FaL7?=
 =?us-ascii?Q?Q/k9ijIALuXYYfz2LJrbFi4MGX+Z50cmc0rdc+aQ9fOmaYcYAE3VmT9qn7Nk?=
 =?us-ascii?Q?NBR9tDB7/0/zGGGowTNXo7cqrS97H//GAVFn7poX1GkAfHJ18vNSO/yXstzx?=
 =?us-ascii?Q?lLvkvr/8zoItyu28GlK2qrGGX3884EcA2j2GGcyD8y4FQMnFUxiquMulXGqi?=
 =?us-ascii?Q?LOX2ngwzpAyeiZCpLEbXjZ4Douhlkw4sELAfIM0PwX/lUV+ABnQGC5xAY9No?=
 =?us-ascii?Q?Z2ptmTmNbFaLSFw4YivdnbsUDG2dNkr2u9Fi0UrP8z1AthDWdBAOr1iCC/WS?=
 =?us-ascii?Q?0O7+K7DbIoxwoqxNGrzLxb+WsgJVRMoOMLodz/V+7lYCLo341LLCpcqFO7Ut?=
 =?us-ascii?Q?OGh3O8FTpSWWy2ICu8G6C4P8fy/OvBL4UeGwIkWRJP1+zh7ttKFXFsXhRKlV?=
 =?us-ascii?Q?vPizqsWD6/sB/2EB1QJk904/o4qSQG39DtCOLtZHR4ijCJy27mpv4zD77aO8?=
 =?us-ascii?Q?61DeP3h5PcfaQU7Pi6JJexB7qO6ngpMzIGX9PUMbSyABmm1TqGplenohmlL6?=
 =?us-ascii?Q?US8YvAhceqKl4sdR/O/sQNCxkNVKXkDTKrutt7R6p1gx3Gu2s/d+QeTaLT/E?=
 =?us-ascii?Q?BDr5GDwElEjtvj9WUVtz9bURJbmC+hlOg4uhEnww1ktGX/GRHj+ZUsJRpR/0?=
 =?us-ascii?Q?F92NxeC1DAOhMKo17LOeGkBfw7Rihb7uxFPt6cj0+jLjx/YMcOtbQbaNzIn+?=
 =?us-ascii?Q?+kuClJjkudymjvaVcywdFrm35QXVsNVMH4YEtzlwzLbI2smLb0qirCu+3R1B?=
 =?us-ascii?Q?+YYNSePKoBXVmpVbOH/bsXfwmm0JBkEpMMJDkXK9Px0VJzgc4zsGBTu76KDg?=
 =?us-ascii?Q?saqflmeyXDVPF896rBFKGrPVj1ZrlleQpInLTosWwsg2uWbPHttliGx9PCSu?=
 =?us-ascii?Q?pQMTvoCaMiUnMzx47aLe0KrXdNlMdbcIWezilnGmG7QQyFjuWcUfnSX/pMhL?=
 =?us-ascii?Q?m9f6nTXChOgIsNoOed4h7puU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f45fdc-4a02-4ad8-29f9-08d978866fa2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 20:21:44.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdMfYqjdRVx4M3kgzPKh3um9+YAsW4cUtVTuGnu/JlbmIBafKgBukkqJp6exjR+z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the state is not idle then rdma_bind_addr() will immediately fail and
no change to global state should happen.

For instance if the state is already RDMA_CM_LISTEN then this will corrupt
the src_addr and would cause the test in cma_cancel_operation():

		if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)

To view a mangled src_addr, eg with a IPv6 loopback address but an IPv4
family, failing the test.

This would manifest as this trace from syzkaller:

  BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
  Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204

  CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:79 [inline]
   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
   __kasan_report mm/kasan/report.c:399 [inline]
   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
   __list_add_valid+0x93/0xa0 lib/list_debug.c:26
   __list_add include/linux/list.h:67 [inline]
   list_add_tail include/linux/list.h:100 [inline]
   cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
   rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
   ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
   ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
   vfs_write+0x28e/0xa30 fs/read_write.c:603
   ksys_write+0x1ee/0x250 fs/read_write.c:658
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Which is likely indicating that an rdma_id_private was destroyed without
doing cma_cancel_listens().

Instead of trying to re-use the src_addr memory to indirectly create an
any address build one explicitly on the stack and bind to that as any
other normal flow would do.

Cc: stable@vger.kernel.org
Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
Reported-by: syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/cma.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index c40791baced588..a1315b4da1a6bf 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3771,9 +3771,13 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 	int ret;
 
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
+		struct sockaddr_in any_in = {
+			.sin_family = AF_INET,
+			.sin_addr.s_addr = htonl(INADDR_ANY),
+		};
+
 		/* For a well behaved ULP state will be RDMA_CM_IDLE */
-		id->route.addr.src_addr.ss_family = AF_INET;
-		ret = rdma_bind_addr(id, cma_src_addr(id_priv));
+		ret = rdma_bind_addr(id, (struct sockaddr *)&any_in);
 		if (ret)
 			return ret;
 		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,

base-commit: ad17bbef3dd573da937816edc0ab84fed6a17fa6
-- 
2.33.0

