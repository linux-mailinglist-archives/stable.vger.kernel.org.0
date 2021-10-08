Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D624263DA
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 06:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhJHEiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 00:38:12 -0400
Received: from mail-oln040093003001.outbound.protection.outlook.com ([40.93.3.1]:2467
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhJHEiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 00:38:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCxgKcNq8wH9SFmNVVEKwEjLwEzTeQNBuEZHZtymcq5qfYU+w3RPwcS2BzeiaYxPtDUeNdSS6eL40AUn8JAl+LINyUPaoGXx9UPTNU++TCWNr2Cq6rkee9G0L+YQK9iD9XGSE9tjEAif3iqNYbmmi++JGTZ459t/IUhjA5OYAuZ44DoXVF1DJzMK0iAROm2og2R506C3ZUJ3e5Qb8iADzbDci2KqqAqwsk5J4+hIx+7IJRN8Tztt/ktOqXQ7dsQY5XN1QqI7JsgM4SGQv3acs+YAwMAbPkPnYEntBFP9YGXc5xNNV7CRvQr2Ao/okw7JgC5TiBeCYYDjNXNqt78czw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTfSVJuHxsRQEg7350bkqzb3HrUIqKLF+hgcQcElCJY=;
 b=eoiOrxG5krnZ9On0qKa8S3PPWQGiWVPxq2DRNFog6XKYi7BgZOqctz0MYMsmpjCynEIokAaOfcIQadPAeViiJgYp0/AXJ46pvgkZAZ8171y46cVoXoUt8nUnbBtpVBZ37XaDBD1AyPQyJMijBN3S9B9+EXnqBckAXU4nnQddI/EWpYplX29bkfiItOwWgyOjZNp4TxRUQcyb5Et6lGYMRyE7TQ3h0gm1OvFJxr8obLfUBDkOvxzNk3a6rWAHv0PgpJcB6dRjHHJh1GXpWsalNzBHiHmpUtnbTUkfzaIexos79F2ks4hFkFRdCzUl21jT7H8bIlX53FVDM6dhyJyjZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTfSVJuHxsRQEg7350bkqzb3HrUIqKLF+hgcQcElCJY=;
 b=MGBmguUpSinfGN18A7qiCbiROM/WBmaQUZV3G/dPK+nzQzA/BdH9X0jvPvEUXsPuaLkv29oSR4bcD9tC+hgOwtZcrNHuSe8Y0fwzX6PTkEPzKM7yNJ7n8MjQZFr6O75VnRFDpKxBgdmnfeX3bvkpMjs+gXWOOS0wdhGEOQGKBok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1747.namprd21.prod.outlook.com
 (2603:10b6:207:35::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.2; Fri, 8 Oct
 2021 04:36:12 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567%7]) with mapi id 15.20.4608.003; Fri, 8 Oct 2021
 04:36:12 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, ming.lei@redhat.com, bvanassche@acm.org,
        john.garry@huawei.com, linux-scsi@vger.kernel.org,
        linux-hyperv@vger.kernel.org, longli@microsoft.com,
        mikelley@microsoft.com
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
Date:   Thu,  7 Oct 2021 21:35:46 -0700
Message-Id: <20211008043546.6006-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:2:8234:5dff:feb8:fa01) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 04:36:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ad3d59-ccb9-4041-36e7-08d98a1527e0
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB17476A3E951A00BFC5A9A4B0BFB29@BL0PR2101MB1747.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+CTcYOnZJT10MtFVxOLFuvwEgzwe804e8M83ux7NzNv3QQ2yzpHNF7WU+1u7zmPx9Y17UBjP64Wm4Lar/kyAiE7gWE1PN4TatAYLfShAH4y2fXhvWgO6uw2PgqaPTrECDi1pMNYN4MpxewDvOFOiiAWc3kJQzf9TxZyqGy6yjC+jK/hcc7iYA6Koiv4M58NdTfF5TAPlepcILZy+i50oBvsTsKN3ltZRIKfW0B/vYHzikwcRpuPmLsp1yc5zF83ctoCQPoO+T7o6VfePd+DxEsvR0SiU0VUZX5G+JM4eyHwITJPpFob6rSclLS/s0+aY7AfFqokBMIpXfuHGRCpk7xMugjp2E/NnaHJhfXM2P9EwJbPPTJCS9K4WwWyt/mVnFAUpdEcwnGmNoJaMDWeNZbIFqzjyTUis/Gl6PO/4GvjNTp1df4eHFoU+T5Bb4a7C+tTzFCqRa3XgLCzMaaRLZOCormsAyEj3i/ZS3fj5ZSADEcYZj2G9n534GpJvPmK6ugIhtEu1qRZUb3MrmGuGWzjJ1n0GNkcAgyZFpOPLvIaLYMIaJ6TXQ+RZ9sbkwbsU++w/fW9uKtHb57AyP7AZd8QUxCU/3EB6jwxClvcZ8J/vRZLAeMyJiyodq56VjD4w1UUfO3URYxQLt9p6wMxc0n4LzAdsNgdyWFU4v/bpAHCP/tcHEvNSqvqn9MmIxIpQSYp+z2DwnbH9LRmNS4cV3/xtu95kGqb0s2WMp45t1D8MYZYL3Ebyvg7lRQiPvVYs9/eZy0ViOdfY/y4U8UBWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(83380400001)(66476007)(5660300002)(2906002)(38100700002)(6666004)(186003)(1076003)(86362001)(10290500003)(8676002)(966005)(921005)(52116002)(7416002)(6636002)(508600001)(36756003)(82950400001)(66556008)(316002)(4326008)(8936002)(2616005)(82960400001)(66946007)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r/nZBmZXm2HtRhBXTv6ugEp/w4uGo/jGN9okU/wmzLhuipnX6CAq3LFciK2u?=
 =?us-ascii?Q?kQja5Hf6bRGWM7RZktH+641hzzyWRR+xBlyk8xh+JOjc/A4HKBCLga/dm4m2?=
 =?us-ascii?Q?tXoPmovpVC3/dLpaF4M+in9yjCkxIOGnWIdX0X6HO+hiJuhAoqrWLJVlATC/?=
 =?us-ascii?Q?DsXj/tSx9T+UBJCQ4htIoeaYDqvTOdni25eVWrB0rpLTyx2QDH9F6CIH9wPv?=
 =?us-ascii?Q?UhSpiOAXvYh9p5yqGHX2PJHPVCcLftHolI3rY9zjd2uHcRifnXP91plhU+79?=
 =?us-ascii?Q?GKfVkJRh6hzbfMCHRZoC6qa/vUwaPT014cZ5fCMGIwZuxUUOgWoGhmnFOnkb?=
 =?us-ascii?Q?VZm2pJygizjrPsIhIjxWX8lVtOWAkwgG4AiBJCfvIFLt17z54MohaGZwTd1h?=
 =?us-ascii?Q?1M5PcCKz+7YeHN6m2ZjrLMOIDyashIIYvUhg/Y2gV5qhWt5SPB8cOwUWRVzo?=
 =?us-ascii?Q?A5A1ty/GNhz/34olV5HQeDV4bGhR3XxFJ6ytW9irLJ80HibSqGbJXE5VslzW?=
 =?us-ascii?Q?/06u/Uvqx+J3gd+WtQGbLNyABkjC1zmwzWry9H5CZTBt23Tm0h+9EXacpzXq?=
 =?us-ascii?Q?NJ9JXC/UH5PSf0YP7vdMnxYFbU5fWEfjDyx5/O1cQVEzIrXGnTfI5wh5TYcn?=
 =?us-ascii?Q?N2Z3TXvUNgOWuLc8TmFp2NwbAZlDWmmnyCGam++s8hQtBlLHgDXCGbJRLcOt?=
 =?us-ascii?Q?NodBiS06brmLUaICaM6xUB42u5MPJ+T6OjkrdpD1yffqo5mdEIe3HWu9iYn8?=
 =?us-ascii?Q?WjDg25v9LkvgTly/SB0jUUkQZddO8bSu2a52DiNExwU9cpNGtWtsySJZF8Y3?=
 =?us-ascii?Q?5dHEuAHD70EBKTmXdfhqz0zgyk3Q3xIP0WtrB+Jz+TZ8+51ENuv353MJAki6?=
 =?us-ascii?Q?udOAzbxaHRwNoISzzjlf044it2qvBH/bZ1Gn0dFwE8kaHny2HbtntoecLbpI?=
 =?us-ascii?Q?19b0gDaEMVOVwwRCHmj4gLoc489FDmZ9ak6r7fOPJdsOktyIOD7erOG/kAi7?=
 =?us-ascii?Q?cvnk42KDaiZhehyXzzzUzTG+Jwv1qWQCMU2Vt7lF2Od48y3Rm2WB8VnTQOVN?=
 =?us-ascii?Q?l6YS6OX6/SikS+Y2BtN4JLuJBODtROvsJqVfB4qnjkV30ZjeAhjb1lgepp6p?=
 =?us-ascii?Q?dDuR4ZgHh5byw24LYHMNSIoMcjvK4ijlYVQL4Cu1N+zxMRETmjkVVn/M1mJF?=
 =?us-ascii?Q?W65uKD1FOlfBtzCN74vgpoq8KmnMIzLmcDRZG5ULzKVvLVGNIRX1r+22vQCN?=
 =?us-ascii?Q?TtParlKRc6SHz2B34VhQ8Tpddn7BPWBb3YZaCR8RFqivdHLN1i730pPFsh/A?=
 =?us-ascii?Q?7gIqXuV7HeRAGV0LWEzPhUBkaxt+Jpksoa2Yy9Vg/p8rryhGWXWz9iXGvMGv?=
 =?us-ascii?Q?48/+RCCdZiOQJnAPbTZnExUQmqDq?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ad3d59-ccb9-4041-36e7-08d98a1527e0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 04:36:12.5802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sKBdRJhRLqY1jwj/PG1CSXUgjjlUD6uemtSUslsl0SlNWa4FrrfVXuobfDp1VCwqaGF9aFTR/bN5wdGpabd3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1747
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
boot because the hv_storvsc driver sets scsi_driver.can_queue to an "int"
value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
shost->cmd_per_lun to a negative "short" value.

Use min_t(int, ...) to fix the issue.

Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---

v1 tried to fix the issue by changing the storvsc driver:
https://lwn.net/ml/linux-kernel/BYAPR21MB1270BBC14D5F1AE69FC31A16BFB09@BYAPR21MB1270.namprd21.prod.outlook.com/

v2 directly fixed the scsi core change instead as Michael Kelley suggested
(refer to the above link).

v3 simplified the commit log, as John Garry suggested.
   Added Haiyang's and Ming's Reviewed-by.

 drivers/scsi/hosts.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..24b72ee4246f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
-	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
+	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);
-- 
2.25.1

