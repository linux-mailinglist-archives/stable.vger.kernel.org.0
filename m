Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B924047729E
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbhLPNFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:05:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33452 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237235AbhLPNFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 08:05:12 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGCE7ZG004312;
        Thu, 16 Dec 2021 13:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jEsEFEw9l1np6ispEoGgySgHzt2k/1uN/MjwzB5lHnw=;
 b=OZvM/1XWF+wK++I59SVy0lndzAfwnfKJEMRnDLWPOQChgpOtVyJIg290bKt+q3DLXDUu
 yIkoPV4CDz3Dh4TYbu9RmrHeNGUCg+UXAax5EUpMFnGOPPrE1F3gtUY6Pp1oe5wpHzPS
 0TSIIAbHaCSUGD5CH05mnPLMb+7/jdwCJQ4T2/tQDpVQWv9V449bpUvNwKJKUuddHkbp
 IRfN57i9dqsRaoTuP0zmm86jPHmtLBTtySGctFa67K2DCXIO2f7uuwd3YtY7IlfPCbR8
 H04XEb3h+FcHxSKsELuI6GVSjsNdBdF/Um4l4J+5lStFNK4IBgFtDJoFhHNCfVHlU2jA 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykm5aqpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:05:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGD0goI008286;
        Thu, 16 Dec 2021 13:05:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3cvh41xn9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:05:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QECX3fWjo1DKCeWJPbIa5hh6NF9YMnkK2dfR6sA0jBZTZv+d3PtI/RUiByIa7zoJ7orj91Y0b02nmPWZbaJSka/DjNGsNBy376sBUAJfzLHTayDRMpAELg/bRtoknkt1f3xx8LcXSnXezEQlqti9bfGHoQaiG6X+1wPpHT8PyYaKSbZ7KpAv1tdSP9yUfe3QUEUvV5b+Km6EFEsRqHxa6kVmtvK31S8ndGe1f6an4QPde5MoY3SqcqhmsxR/ZiKOiW5DZPCnsGX3LSRZmTjPnBuY3eeX58zgbVx/6T3Xnv9juJEy19o7a+mdenAXQALfe5tl5AbFTPt+Si4Fq5/S1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEsEFEw9l1np6ispEoGgySgHzt2k/1uN/MjwzB5lHnw=;
 b=ICaiwsml2h0jE1wdm1UjCaQjcNLE19bOBdxI5bu59vn09X+e/2gxtU4GLA0rVhTUYo+8s6zq/RqTtPH7kBCrJAGo0NQ1Q9WvQ6YYMCZtmO0f4A0fXZwGfCdUGK/4y+d4PAiivMCCrWdCytZnmaU/HtJPadVnvM2oFMljCDozwcjpf7Z42y2ZAY0Ek2U2ooKJ57qZVDOBm2Q8kh5tYD2XOWLppH7tqQ40bOHtYIr3saSnZ3z8NlQ1kftnA/Kjb3ROcqTdVOLXu5BNIXo+d9Kx8PugjBvxB5835unLiV2p1XLUeHQMnifkDjnMsssouyRl7JEeUEQYDkGzej4vHSHhIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEsEFEw9l1np6ispEoGgySgHzt2k/1uN/MjwzB5lHnw=;
 b=wcBEpVBIXMWsfSm6QEu5O29LH95KRmS7FQWIUjhmFYRwmUIGOHPYSYetkkJyYHFLRGdoJwbxgD0tKfjDCmve3VuNxqsHNZ7KtfUaEErv/UvaO6rOr3pDYYMBoqB6Y4ED1KDk308a8s1HBIiCvwcv74BmDClBo+1RbuIVTapSgxk=
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Thu, 16 Dec
 2021 13:05:03 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00%8]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:05:03 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.15.y 3/4] btrfs: update latest_dev when we create a sprout device
Date:   Thu, 16 Dec 2021 21:04:12 +0800
Message-Id: <3cc9f5d26cf29f91b3a87df814ff84420e31080a.1639658429.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639658429.git.anand.jain@oracle.com>
References: <cover.1639658429.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93e57bd-5d7e-4e5d-2637-08d9c094acd0
X-MS-TrafficTypeDiagnostic: BLAPR10MB5186:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5186C548C110074B7C754EB1E5779@BLAPR10MB5186.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NnQLw838PSEdCMd6sQSNvs/ooc7XOrMlCJ51Ysf57XwKA8sGQqPaFCLfVJIm3G7A5adBhMfGLgxtO1aEuMtD9uhjdZ0qToN7Mf9E9v1IJHtrFRt6lWugPR7PJlAg6y5O3Sbbb4ZyzaYJhtDWRop5/Hrpar6eqm1+GYXgJb0RadAjgvEDCs9P1eXvBMnc2WAbzmuljsPjldpfzJ9j2zUjkfYFFAfG9MJhxyYcYncJ19QcmoFycxc8g0kRZlCzguY+fbpQsdt5vopSC8X1wF8+RQbQwBmujUQ6HumFW/oA66L3Qx52eHoHJ8rNe8Ek59JnRPvFG/Yx4Y3phACY0pmw7V3c/qnWE4ooo1N2Sj3c+PgGcuKCBlBR9MKGeaf6feMW5MdT5oQCBx5ZsLvBb2RpYjfgrn733+PtKs6cnt3fJGv1aT93P9rFv5O1+cpyC533Eu0DM7o+uGUFsBXAWGfMb+IQ3PgijiJzrc+IOCxhpF82qggU+WZw+lkET2+UeNhdU+b/1KYBUIasvo8mrqIYbok5IN1+if9mErVBnKOFBlIqFtXdgYO73XPV7yyJpRtEriD1gBDwF+NdmzDWq6iWHbhf+9j7CGm1njm+0Fke/YurirzKXBs3iX8a7tOJkA2Wf0h9k2v4CMMtojjrqLzg+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(5660300002)(66476007)(316002)(8676002)(36756003)(508600001)(2906002)(15650500001)(86362001)(6666004)(4326008)(186003)(6486002)(8936002)(83380400001)(6506007)(44832011)(38100700002)(6512007)(54906003)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uerNCjVROE1DnMOXUvkeqhhF229CEjubnofAwhN6LYnfCJzwxH8jD/G+27MX?=
 =?us-ascii?Q?/XFdAMipIXmH3hw7LhOfBfns+DutLGZBMz3Hq5rtQgKMopjw4Y3xCG9w2vwU?=
 =?us-ascii?Q?/GRKkM4PitqH8vPkjxl0Y/7bB5XJJVOD4ivnekCcJVb6C/kaoKOK2NoyI2xG?=
 =?us-ascii?Q?KxovxU/w+HaI82MyD9itmLid0hIcf4Rg1X8D6tWRE4nZW+Cb7HMIdyqwVXKM?=
 =?us-ascii?Q?YxHwSrHQV4/2zKdSjmNv0MKt0eMyGWE/E28wZsj4ziatpK5vPF6xJEnXa+ZL?=
 =?us-ascii?Q?zx4hD8CYwlkArzzUiG42nIkAi+O5C6bLB2IawaaDtyWeBXaOxZOqDwXUyDry?=
 =?us-ascii?Q?AaX/A46POTgByMczDE8t8dV6FpN2lE3K9YMmo0o/uV1VnCiUbPjcWb0UXXRc?=
 =?us-ascii?Q?jM0r4QCTLjrO0C3Fj5gzTMBmBOzbnopKJV1lxuDzpoZCHtYB5ruPnn9rmSO+?=
 =?us-ascii?Q?ju6EGrXNnHGkNNfJjCmI2QTQ9cFqrymYLXKz/Tjz1RX8vEROxmpwVp3mz87M?=
 =?us-ascii?Q?T3TOSB0ApL7CuaE53FApx/broaOjendRBtGiOc0iSvVQSfEG6mw4bF0IDJ6x?=
 =?us-ascii?Q?i+DH6kph4ziRyU3hJ381PowALUwLah/SGJOromM1adCLxRSFy9EWLsBtWhwn?=
 =?us-ascii?Q?uK6h3uhx5mXc0fuwU3gTiM78p155lC35fmP0NnouAvlhbl4GFOURLLoH/CU8?=
 =?us-ascii?Q?e/L4z3mHDMoyxroeo52bci5BFELZDwCnXyrUhyqQ9DruAaipeC6VZXVLcnpf?=
 =?us-ascii?Q?C1iTzIAbX4xd5QXujj+TQvRCuEtuIeJBYw0ZAfgEZ8dPdtJnk1GCN9wVz6GO?=
 =?us-ascii?Q?ncLKLV9XOm8JMu5VA4TNei0qDJDm384nnXq6wBYXRxjchLg5XiC09uMHLH11?=
 =?us-ascii?Q?+s0dNpxpSZc9Czg9U0snpv07EwcDpO8uJKZsqPGHmFC+PioY1zPM/D3/5mGl?=
 =?us-ascii?Q?5mS/yHmO2Vk2b73yoF5HTSCBRUloeeCoMUDgtrTL6UJYv6DYCyaU3EGzZS5X?=
 =?us-ascii?Q?aSW51LoUQtr3G+VV1vBnYj6I9OMqYOMvkr53ZwbMgZC+IdYKrSoT4EARUm56?=
 =?us-ascii?Q?Y8VMQ39Iu1rvOV9mpYALl0dQsGi0LspbBQujDQp6ZMIhV1osGWHDIFVVYvXF?=
 =?us-ascii?Q?a54aaim0EbgoNPjcAcZ/Ml3f6OaB8ClXuiuT7lfHRj/viv62MSywBYosIhOS?=
 =?us-ascii?Q?kk5k1DlInKJ1Nx8L/qYirnNzSlI9WSp36dYutnIW1z+n/jGV3goKU7GcV5cW?=
 =?us-ascii?Q?0HvtUdCAETj7OKyPiIv6rVqhwqcc8y+CAQHzPzBvP+fnmfEvXK1ubcegU1E9?=
 =?us-ascii?Q?ymbPR+sadlFH2a3M0AVi+WWkKuSkAPgNTd1F3ENgZnCnztcMNavqaSuDCx8J?=
 =?us-ascii?Q?Qtx781OSJ1yiAjPXKx2S7dGzqeN9WEMUzIVPRWwnyrWnn1VQKSCYktpTNNAU?=
 =?us-ascii?Q?wY7ODQyFnKXQHUks8VnjVx3oOWHnz9yXgLgsXMS7qZvzVDC08JnxxEJiK3kl?=
 =?us-ascii?Q?KXXZKA9wiVLHQWqtO/yaGRg4LJG9ze1k9FXZEexq6k09mo5uOeoKeHGXBjK/?=
 =?us-ascii?Q?chUTo2veTqodZe9rC5FTg/saKBUx2BWnUNbiQoYzec6uzsIR2eNPOrSSJnb/?=
 =?us-ascii?Q?dOlrlrKq5WnvX17eTeopz1zT7rn9o+Sm5ZrYKdL2uJVEE2m4YH95n72h7YLC?=
 =?us-ascii?Q?Zmry3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93e57bd-5d7e-4e5d-2637-08d9c094acd0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:05:03.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFCK98ZFqEdI6QP+P1VWsjDUfuZJ+KxnxsYJAW+dZ6RnVJyURm0GYYHHhXktsk1HhlqXXog8OBFcNvCsZPAtvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112160073
X-Proofpoint-GUID: k4h5F0FH_8JI7oB3VSg4X4foRRRU_mfd
X-Proofpoint-ORIG-GUID: k4h5F0FH_8JI7oB3VSg4X4foRRRU_mfd
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b7cb29e666fe79dda5dbe5f57fb7c92413bf161c upstream.

When we add a device to the seed filesystem (sprouting) it is a new
filesystem (and fsid) on the device added. Update the latest_dev so
that /proc/self/mounts shows the correct device.

Example:

  $ btrfstune -S1 /dev/vg/seed
  $ mount /dev/vg/seed /btrfs
  mount: /btrfs: WARNING: device write-protected, mounted read-only.

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-seed /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

  $ btrfs dev add -f /dev/vg/new /btrfs

Before:

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-seed /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

After:

  $ cat /proc/self/mounts | grep btrfs
  /dev/mapper/vg-new /btrfs btrfs ro,relatime,space_cache,subvolid=5,subvol=/ 0 0

Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4afa050384d9..b996ea0dc78b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2634,6 +2634,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
 		}
+		btrfs_assign_next_active_device(fs_info->fs_devices->latest_dev,
+						device);
 	}
 
 	device->fs_devices = fs_devices;
-- 
2.33.1

