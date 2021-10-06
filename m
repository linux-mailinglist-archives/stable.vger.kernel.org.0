Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6800A42387A
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 09:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhJFHGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 03:06:32 -0400
Received: from mail-dm6nam12on2115.outbound.protection.outlook.com ([40.107.243.115]:34433
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230227AbhJFHGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 03:06:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0VXOXEX5nm1c4KF93eJNpD0B4HqW0a0qgc0OnBhDGr6y2E3nWjvRg0+kPTQt1Pv+e0KFKWIubVKyrV7VriWrli7Ph06ST2zHQ2wIduzc8IQawyi5ZOWQOM+Smzy0kgOLnTf88L/hYf9mkFSdAgFSr5dH+6TTIVdygYbvxy4jrJ6zYnImhg0RbytaxrkKVXGuBKpCiLhxv+zNNEK6uguKrHTrEGY490cpROYNm4Q/XksC9vG5D9IdzV8UFY9fg+zzOHtqUrWxs+73WsEj15+H1p9sjlpCwfp2oTP15e/jaqJZ628SLnXqst2qMKvcjyYP9svQqY+uZHHKVp+dyqCFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNgkG0Owpmzxi+ZwZD16lLHp+miIjC0VpSKHOiw4HmM=;
 b=PJwhmf3i8pBCKyRwGX0PCybz1LBjn9QQ7lc8Dc6E1nm+K6AAwu8EMBbsit6oxZ3u3kDqkohNMd0HX/Z6M+4n9NcuavRLBA+/0I4C3OBxzf37KG0Ms8LpcH7qBpvWlWO2j4Y1zdeIZQ78ICeELMrsP75RDMGP+ZBPpc0kERH9rtpqLf7f7ly0ehz4keSoWcR2bY7SFU/kEVX8s1KSET1mmGsx7WlX7M0UQ59gZFeYLUX7870xL3Pw5U/l/2ms0JFub+IzU9bRM7xSp5bahRetJQmvsjm9hi/EFJzOeXMjrB5oNbFkDoMEbeYwpTtLvT5dC691PyPHPH52Ge6v0VLeyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNgkG0Owpmzxi+ZwZD16lLHp+miIjC0VpSKHOiw4HmM=;
 b=DdWUBk+3hXs2x1k1k9FVf4YvANT2ngfIfCmaWrnuW7UQ48TyjQA17CxV584BRd8KnaO/o3ZOXTDYNzxzWahydclK3s1WdqnHeOcRWoXLe1yRxdp3UZvc9J28VWgwz8KDBQex2yWZn+FIQJstpM2ibPCfVqFJwuUuw3DfxcSsa+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1747.namprd21.prod.outlook.com
 (2603:10b6:207:35::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.2; Wed, 6 Oct
 2021 07:04:36 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567%7]) with mapi id 15.20.4608.003; Wed, 6 Oct 2021
 07:04:36 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, ming.lei@redhat.com, bvanassche@acm.org,
        john.garry@huawei.com, linux-scsi@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        stable@vger.kernel.org
Subject: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang issue during boot
Date:   Wed,  6 Oct 2021 00:03:45 -0700
Message-Id: <20211006070345.51713-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::17) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:b:822b:5dff:feb8:fa01) by MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Wed, 6 Oct 2021 07:04:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d21c8a49-26fe-4e43-5c84-08d988978e29
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB174733EC14FD4E1B11552096BFB09@BL0PR2101MB1747.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMsVgZyouo/Yt/Fru9+rLOizx3WBB52BJguwfz7+2VhYSvNDxIsymiFwyHLOPh2z8d69ga34xDVrUHWDWXhxqsdToDNrpol7jEA150ORNiBZZudfC46pfmTs5AhNs0prrYfNSoob6DzEWbqrr0/lx7b3nBqzJ4pJCLg7Vs4LqjFUGMzXH3vzU0EQNLWb6a/447GKRrQB912JDF4sRSZYYfJoPW3OHXX+REi5m0EQblZVHu+yjUdzV9vpJB6+GCJ9vNFehoQgzDHMewFVgFmDn9R+InwBVZ2gw85phGiipzCK0MSK0WXt47IvmZneHcpJrzYXX+YZ4zPsEavXcRHHB9z+HahXOQYVh0VARfb3Ko2wAfBPAb/xs7uDKRCadRzWcu9Xg6IcYtyfxwDSLj94Nc/5o3kEtv9pMPLgsdcP2K/WmvJ7n/1EfBqWtJhGjTM2FjDpP1InXHxHbHBBPRkfZ49EOpUsIlhm2777R5q6P8+hrIq3qFq9EasRWY3t0ArjDBhaByML6tgT2IcaykqE7RF7w+Dn++VN21BDwIgvn5NuXSGqknxCOeRPxA9ojWuZOP46yXo7HuVUNvyHlr1C7fRUpZyGrvgGQk94B7MxVsv6q6LLnQ1OyE/ULjIJ8GeTIPtNKeNXq5sjfHf3qfyYBok9A6tYE4FhfouGaSkHzRgGmumtdqyqqVS096Fbw3pI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8676002)(66556008)(10290500003)(66476007)(66946007)(3450700001)(2616005)(4326008)(316002)(1076003)(38100700002)(7416002)(6666004)(186003)(36756003)(2906002)(8936002)(508600001)(82960400001)(6486002)(52116002)(86362001)(921005)(7696005)(83380400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iglu+84bRQT6U/V6LrxkVwhOCKthgFsWyIj59e1/zek7GjDHcXTVyUZ6MuBM?=
 =?us-ascii?Q?5N0pqyfO4Sm5ZKAaHngpu5FWScfWG9qpqaJbJSZzMfGG05pcDcND+rQTaJtY?=
 =?us-ascii?Q?hSP4Y5Nvw3p5t6XfcwjeSF/H0YOP+CTEIRCFMTDVdgvBiqZ3/S9cA5TluRIS?=
 =?us-ascii?Q?KftS2Oaq3tdmjfx19eUoEU/+DtLyIQ1OQPV6uH3Qgaei/QosMnq2iidrSKTl?=
 =?us-ascii?Q?f1dK30RZTysaSCoM8lWFg5k5pys4dQvOrjD0QxhavpCR/jTRdues5kt7GgnJ?=
 =?us-ascii?Q?pofjcryCSyfQIW3FBTnZLGW4rP6J6gqz9f3K022dbfPwTGtbMesA77pxPct9?=
 =?us-ascii?Q?XdpE50+BfFDz5RCD9VsEPphIqd9fNwtpwbyALkXYBUX3L3vVNlDCPDyP9CIZ?=
 =?us-ascii?Q?1YOGyI3VX5y1tx2PoXZZBTfwHjDQBZz73GMNPIDPo7O+9zLaAiazFOEoCbpj?=
 =?us-ascii?Q?ll6QTcNmm7SGvhduUcQx0PokrqvXi/bp/fSYa8b7NA2OCedodcWC+zhFPUav?=
 =?us-ascii?Q?BKV5r+wlAdFWr8GbRZAoC70pbgiSpErjCYnHu6zRu6l/RPVWU7VbeJaMLyrF?=
 =?us-ascii?Q?yy0z5xptjyZN6ImlcrhsCCvcEJpcRZxhgDUBw6NOPWR1jrMVDOXMoXjufwfe?=
 =?us-ascii?Q?/eItT93cbXKnRuhluI2oW6v4qBp5vWrJgk/9S0uR8pTuYEYlKnnrjHFv6xhK?=
 =?us-ascii?Q?eVJcid70F2N+iEZ8VPh5I8iJWhXLoWTEqNYGpDGXuz+4iNqH4qAY1kVXzb7x?=
 =?us-ascii?Q?obEhz2FmFOok08JDvOWTZJmTJ0TohLhGSuDRxJadnrwpWQL6EkmHvVhgAOep?=
 =?us-ascii?Q?fR4JgGPyoQzo2b86ovIIee0cN0kt+ULIK2/2kNVhDc2GpP2SPkMoX76hyvhc?=
 =?us-ascii?Q?cxk+0Hht6bBd7XIj4BpAV7tjSUeztgHfO6LY9dS0td0l/biUpYV74Y0vo3+a?=
 =?us-ascii?Q?EJyqEtsKCRiBKK5dLdDFy+aPmIPQDQgZxPtXudDyy6H+8sXjvvr+jps050Ts?=
 =?us-ascii?Q?n4sHAJ4SS0xa2Vn465wnA+AtcKtiW4uMim+Yl/XH7BuUMw15wnsRa6XhEYBo?=
 =?us-ascii?Q?mKKUD+3q9B/oAY5KOKvx47SkvdO3XVinwTxfoSdHeWC6kdXIi/1XuXQUJ4LM?=
 =?us-ascii?Q?wdL1lD5kwMI9Eh7+VWLstSmqRgUh/NRLhNcwOE0ZZHfLTj8Z4O9QmIhhr2A6?=
 =?us-ascii?Q?v6NAH3gASzUDWeJnma5lGfepVQybkFLJFhmQX0s27fbq2hkGdoVQ4aBTQjhu?=
 =?us-ascii?Q?WMb8AHhMU6HFYQtNPYf8hDhXWGImmdx2mQkkOUDvE/cIZmobw05kXeZlp5CV?=
 =?us-ascii?Q?HPQ66dm/CoB0EZpCoofL/23VUbBJNSsjHtessIPpH1/dhp7f+H+X+rn4W6+g?=
 =?us-ascii?Q?xtxYgg3k25pkeGz6Sx2ihr6iF3eP?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21c8a49-26fe-4e43-5c84-08d988978e29
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 07:04:36.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpBuQAXiBUvIyPk+V7cRPqGiY8sy/5OGRngOvDuXTB3mG3O6yVcYd+mj1RtxmQla2b4x2Tl9v+B7wQGj6sHFeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1747
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
negative number:
	'max_outstanding_req_per_channel' is 352,
	'max_sub_channels' is (416 - 1) / 4 = 103, so in storvsc_probe(),
scsi_driver.can_queue = 352 * (103 + 1) * (100 - 10) / 100 = 32947, which
is bigger than SHRT_MAX (i.e. 32767).

Fix the hang issue by capping scsi_driver.can_queue.

Add the below Fixed tag though ea2f0f77538c itself is good.

Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ebbbc1299c62..ba374908aec2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1976,6 +1976,16 @@ static int storvsc_probe(struct hv_device *device,
 				(max_sub_channels + 1) *
 				(100 - ring_avail_percent_lowater) / 100;
 
+	/*
+	 * v5.14 (see commit ea2f0f77538c) implicitly requires that
+	 * scsi_driver.can_queue should not exceed SHRT_MAX, otherwise
+	 * scsi_add_host_with_dma() sets shost->cmd_per_lun to a negative
+	 * number (note: the type of the "cmd_per_lun" field is "short"), and
+	 * the system may hang during early boot.
+	 */
+	if (scsi_driver.can_queue > SHRT_MAX)
+		scsi_driver.can_queue = SHRT_MAX;
+
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
-- 
2.17.1

