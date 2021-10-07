Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935E74259EB
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243355AbhJGRwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:52:35 -0400
Received: from mail-dm3nam07on2133.outbound.protection.outlook.com ([40.107.95.133]:6368
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241738AbhJGRwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 13:52:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b53XYUjXOUfPJX/s0fTgJI0aq3LjU+xPcM0QRln7N96aRvnBbAi+41dQLo7N3SEVTvE8UbUl+8E+cSeEOQpgHjs6lMqWP5/B3f/et0D8PSEMnQcY/R4KhMC0I1gkBjRGCuWY4tiT3JTCAitB3BWO6suuXFDMEuQYdpH1JpOL6mCmxoECTtiv6N1HW9DcTeu6wphJrB19uDTzY8LEHNGd1/c6Y5GI8rbFYxqhqX1zesQ7z1c9pMW5iBCwpYh9TfRxIxL6HnDZNzFDkdKOpi5ShvVyiJN12vnR8vv7e1JZnHCk+w/8cQ/icErxysi25ghCPBlNSdBXbiXlJXCxU+MfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWbFI9LRsaO0WhUF9AzaBaJSLHD+3GeQRhlbySBFzvw=;
 b=I132KScIFSdp+RJg/PJrus5Aq6HzbnBOBOS2PqQRXqWoKroWRbC3Eyv3ce12I509y4qg0Y3bB0KKBRgJSyP/jdh63QkeyrrPrEIZ/9ybfuW/Zv9TAjVQquUIdsHZfXjMbCA+K/2TM+pSe6Jkrjn5wBRDrnzYyprey537xwLmKCJnAfAEeDZS6Z1ln8K6Q8NrdVRF1HS6KGxAS3cOZ14eYX8bu4jovzSxfpQsLCo6V/5GOs6Y/qPoevgXVTqRTd4Pif++yQ0W4DHFfXUyZp/Ybh0UAL7pRa0bjTjDLBpTM1UqOFKESnkOH1IkzTHXkFBs0Q0FHlPHJQbJN3qIecnRDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWbFI9LRsaO0WhUF9AzaBaJSLHD+3GeQRhlbySBFzvw=;
 b=B1KZ82L6MTFVhs7LDUohtgYsXyZ6Yx62Uw3qH0aG7PI6MSodbPa30YxH3WF21dcND8NUa0nAGmpj4a1WGAwYDFnvmviG8QUw1UEWQA/zfiruP9kG3954WUY60FFVU/aL8SPd/guGo0b/4WDjv062A9XsdsgzLpcocvPN4dKOJRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB0996.namprd21.prod.outlook.com
 (2603:10b6:207:36::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.3; Thu, 7 Oct
 2021 17:50:32 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a5a1:1ba3:ae97:a567%7]) with mapi id 15.20.4608.003; Thu, 7 Oct 2021
 17:50:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, ming.lei@redhat.com, bvanassche@acm.org,
        john.garry@huawei.com, linux-scsi@vger.kernel.org,
        linux-hyperv@vger.kernel.org, longli@microsoft.com,
        mikelley@microsoft.com
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()
Date:   Thu,  7 Oct 2021 10:49:57 -0700
Message-Id: <20211007174957.2080-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::16) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:9:822d:5dff:feb8:fa01) by MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Thu, 7 Oct 2021 17:50:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 366e6d0b-f755-492c-631c-08d989baf4b9
X-MS-TrafficTypeDiagnostic: BL0PR2101MB0996:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB09964666ACA890A44E7A09AEBFB19@BL0PR2101MB0996.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5uUhdLz30YpwCwxCmXFTVoTWybwP2mjUZD4u7nvh30Ap1rJOnYFPZxcLGEUjFH1GEaoHPEIAofQKv2HqPWAlVHybzk8CYeJniE+zarLZg3OUm4zuJqB89BBIl6x2hiY1PFWumYMF8gKpNm4EJt7JZlVIhMBs+fHUzv8SUbGQ+ruYJktpnFBt+yABnk2LBzSCH5A5yBrofzttU10DxjVCDTogWXyHEfLrbY42N3Sf1aFr00X63Itqpfh8H2bFcfWWE7E1yAWmwy/4xkI0t5Eu+rKzdwQqzY5nUbIWeP5XgyzD1aUYRix+yihBJa0eX25ruWmcxwdAL08K8aW7VNUoFk3HcmdD3tWX75HHwq7/rjIzEUpiWc10+ktb9J6tvgE6inGhEkKGamCmDi5AFlt0/HQKsSaue4xKE9wxNFpL50TiDdPGcNVPCHInPJzZU5OUI8DGBwudZCzB8MJ6ft79AFLOt6ORUjg/3Vi+ynv6LycEd0pHTHzLyeLecNXVuXdtdSVCBu6yfpsHhQ35vob6xSiyOFg82NxjiO7FDBx4XpNe12QAOHuuTfYrOhY4EOia7hX459Ln0Z76nTd+nUMEcvwXWkFQNvHcNTPZO1Q+LQNl2vFJOmumin/ipltoJY8uRiALsoeCZCTh43YRlyCWPdouksIsHzP5yJnFoSwsL5NeUAd+sfzTeyAQUa5jiEDEMkCgBPLw2iFuaREP1pRblWFqV0KVFXGS6ssJrjJ5TTn1C2LW4djy5M+sng7vPIOh2b7q0QREQT1hfk0Eznk7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(52116002)(508600001)(66946007)(5660300002)(66476007)(966005)(66556008)(316002)(8936002)(2906002)(10290500003)(8676002)(2616005)(86362001)(7696005)(6636002)(83380400001)(1076003)(82960400001)(36756003)(82950400001)(6666004)(186003)(4326008)(921005)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6RJwpp1S+wyu6Tjiiq3wybmw3ug5C1hdGPvbJu3A9rfL71t9TkQ4uwzKRkK?=
 =?us-ascii?Q?EdcyvjDyIXZp5WQImU3y+0nKD9fBnz+H9igoc4bakbLvzg7ynhgjJMLiInLI?=
 =?us-ascii?Q?MaAlEsSxkhV1Yzuy+GZKf0QF3hoxW9QVAxRYPzlGb2OIluFQteTpyLEjMd/l?=
 =?us-ascii?Q?oiFYYiUZf+IRx5iwQPY3ikqCPF4JWFWp1lyNGr+gi0KP2k9xd1bXgu62Qo3r?=
 =?us-ascii?Q?S0qLylnR+mUxDyb6NE5lOykzP+iONx3gBupt2wXCXjICiVUrT4EQruWdLNek?=
 =?us-ascii?Q?EaqfvALcw5ZsGQviBd5q6Vo9HfCJeEKOhwIHiB8cQYCibnWE+K4FUCH/RPbI?=
 =?us-ascii?Q?ywcbyKhbNBIUK3jZraVThA8L59fPqezDp56QB1CkrMvGh/ejmRDvrzafXqb/?=
 =?us-ascii?Q?aqlPdLezGsmP9J8r4cLxxsnsXl0bsVtnQ+KBwAhFR/VqlLteBPV4phtc0H1y?=
 =?us-ascii?Q?mcEBauCwQhRcooLKEt9RJFhr0KUSJPfnTqZOWziMNWcrC0HXqJXH1th2djWa?=
 =?us-ascii?Q?h8ZrgumRUFA+B2KORhX1BW35rqMBmMHauxfsakM6Z7etIGk+FvWm6FlMKpDO?=
 =?us-ascii?Q?vc3pmIr3k0nzX7NGeBNJWDPsYjVLcuPQtdRtK+qSz5YyUF4Nb3CpEqqI79QW?=
 =?us-ascii?Q?xKnjsdYgmZ02EaS7GQSPKQCVCcVHN24WKuXouSiV5AQLy3PuH+t9IDMBBKMY?=
 =?us-ascii?Q?2K0PbPV/aC2FfXGutORAthOjnOs549Ibe2MP2Bdv8o4/imODm4cMPZtvCATL?=
 =?us-ascii?Q?1JzAvJkr+iG8PrWTQ3oJLAu2+q28zN8832oCpQPbMilBmFy4tbWJ6ZN9x0au?=
 =?us-ascii?Q?Nk2AJZyMuXAoGSPaXWFkbgI5KQIDh17hu1Y4TRcwNsXyg172ZRsxpTc28J31?=
 =?us-ascii?Q?uQgZVB6I39KcvZMwfsUb6ZqLyUvKJt5pLuhGZVDBfZrvL5hJAsEDxeTW241/?=
 =?us-ascii?Q?/5cVvXY3MIQit3kCVhMvz5uSW42p0F3nlYeNeIw4RhphdR0EThTcP/KoGUCZ?=
 =?us-ascii?Q?vVzHuUO1GxbyEwmd4yb5BjMCLLtkjI/4gaGvIk1Dem29ZsR6E7YrYKan8+gM?=
 =?us-ascii?Q?435B33A4vtHujE717OyETE82K2TD76C9ikV6V9km3uP+nm7aSP5dTdPEpOB2?=
 =?us-ascii?Q?bo3aJYfnwg7OXd6OAsTSxDVGtvp4v6VcwNWCOwuf+6w+MSGmj5eQRD80rTaZ?=
 =?us-ascii?Q?+SsPOMK5mRDqASDSh4KVvX1bjLxoomuj2tAmKw/7RUjd3aTDe1KB8GBGA0am?=
 =?us-ascii?Q?9YktJuqk02aIKG6b8vEj/plBu6IZEHQXulzl2C5OSEZ5QUjZhS5PMSkLH6BG?=
 =?us-ascii?Q?4tEl2iGqPnHPjPz2fOrQNwek9mkdqrVexBfoVnJzPX7nJf+wzXBlFFirdFER?=
 =?us-ascii?Q?c9EIJYrtwyhyIP0lf3ViNcuBJ1LP?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366e6d0b-f755-492c-631c-08d989baf4b9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 17:50:31.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icy51LPT+hW9MsNXj6CQIlgjzQJFIA2UYfX9MygHrB8DF5K66N8WipdIV+V2VwbgPu7Ep7l/WnTWS9AFJ8WGDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0996
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
negative number (the below numbers may differ in different kernel versions):
in drivers/scsi/storvsc_drv.c, 	storvsc_drv_init() sets
'max_outstanding_req_per_channel' to 352, and storvsc_probe() sets
'max_sub_channels' to (416 - 1) / 4 = 103 and sets scsi_driver.can_queue to
352 * (103 + 1) * (100 - 10) / 100 = 32947, which exceeds SHRT_MAX.

Use min_t(int, ...) to fix the issue.

Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

v1 tried to fix the issue by changing the storvsc driver:
https://lwn.net/ml/linux-kernel/BYAPR21MB1270BBC14D5F1AE69FC31A16BFB09@BYAPR21MB1270.namprd21.prod.outlook.com/

v2 directly fixes the scsi core change instead as Michael Kelley and
John Garry suggested (refer to the above link).

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

