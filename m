Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141AD477298
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhLPNFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:05:02 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9774 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237207AbhLPNFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 08:05:01 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGCJnlU004317;
        Thu, 16 Dec 2021 13:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7P1zOUWejRpKWGMzps/xmDJu3V6UD4OS3VRWhStecjA=;
 b=Qi2fH1ggoGiC2mB5HJIa691Z+5NAexDIr8rlxw1hrW39tnnG1DieLJcppqW7XgHwgaK6
 NDh+1JLtGClC8UVgF4ZgKNcUdM83JX8H4YS/GfHcUnLtuZWuY1CQ3l3tTHmpbNnXcywX
 oH864lHrrSJ1vt7RvXBv4bgfWEB9MLU8CqbbmN1o+5sNhHmOfuagOAgOMGyF+wJiRo2O
 1NCGkYJYhLF4zTr+I+NoEZ4d8a68PXeuFNgbliV0vrk03ahc9stluCWXhh7qvCEdegA+
 iOpwuODuA7DjboqXyTyekC1hGyie0dpYgWi7ABQWNTvrCh2gQXsRdue7hO7EAVAAv1LB tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykm5aqnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:04:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGD0abn058084;
        Thu, 16 Dec 2021 13:04:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by aserp3020.oracle.com with ESMTP id 3cxmrdbmyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 13:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2mhN+BHEnDRl7uOS5rtvstkLjQzlz3HhWfhmi6Ytj7iQiI+q9kHrhB/PMRO0BcXo+54weNQDvLQk2Dm5GEHBbrzn4u2AuT0Er1Vrkr++j/3Nnw3KK8yJ00tNveV50L5zgVXRikckVYePW9Jqk023L8n5vaTNsqH5ZVpFU50A/lQ1MShY0EOuITu5gGVD2VlmzC8xmtKygfEgu32KYqo524PKos1PmSAsrOxIxx9bpAlp2QzBjx1f8QK0BYxZAQ4e/QbKNjvjLkGMvuzHtERHrrZJxUb4ZgdGqnzTMsApGseecWm3J72dqNYaHBw5yeVBtRy55JN7TxjUsIXYB/lZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7P1zOUWejRpKWGMzps/xmDJu3V6UD4OS3VRWhStecjA=;
 b=kiSvk4V+LHT2I+mg7c7IUzx0BqligM8m0arQIm0oN8A3fQkrexkkhpWRUc7njeLxRt6WmmU9Tv8wW1wAEvZ2b9a5qsp1B7ZuxHNi23MuX60s4HpJQexYuyAa8dTWuaHg7E7jLUwb3od/woC9kgsH6aio1A/nrbvxtSPHB9AaU6u3GJgM823yhOG/3HDYMnkyLsXLeZ9Fz8CFNSpPEkqkOEgpId7Hx1HYF1sobEQ/wjEToB9Fvh47vWELYIjEt+f5vAHHg2sNgpImhQUwCaNJnQECSkd0JrLM66VJJb6ITgUgcPBgKeNQU6nYagFpsf7Z9WJU8Wdnnm5qORiCp9rrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7P1zOUWejRpKWGMzps/xmDJu3V6UD4OS3VRWhStecjA=;
 b=uqYCCI0gMAa8oVs2yHjrEzj/xeWbiRdlf/kF85kVnE8t/f2VnYVgpdG9jx/WE7qSuJtKW67rfJL+c01rFPPPN1u1xZ07iNZBbTFg9ZJGOT4gOg4Sn2jHVK4nKwyfXLYyMnb1YK1aTGhOfFw89QS3ekyBSvyPEqk7ZmR5wRh1om4=
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4093.namprd10.prod.outlook.com (2603:10b6:208:114::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 13:04:49 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::f450:87d2:4d68:5e00%8]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 13:04:49 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.15.y 1/4] btrfs: convert latest_bdev type to btrfs_device and rename
Date:   Thu, 16 Dec 2021 21:04:10 +0800
Message-Id: <b3a61db6a89cdbdcc9bd7505bfd19241324326b6.1639658429.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639658429.git.anand.jain@oracle.com>
References: <cover.1639658429.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feed8ee8-4f11-4d15-d548-08d9c094a413
X-MS-TrafficTypeDiagnostic: MN2PR10MB4093:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB40933E43123790BAD67E8AEDE5779@MN2PR10MB4093.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpgahFFmJv8hMDjhVpa7QrG0/PBj7YgzREcN7/IXQzLYlSqw8by+sBCEGu1nh90dgRTAWTHmbDOwL22MjIZYGbRtawzCtSsWFhu3RjdfmavwVBHj785N+GyLae0NnzbADPEQ5JOvXi6Stmz3B9W7FD0zZ76sPCzcgRpQbovoH8UtP8zE2+D9xkfg3Cpq7+xrle5DpQQ/BRjeU8MhizlgBFGSd8iWbarI4qd5SveSXpGPBKKZW8nVroHj9no1uH4ZZGFiEwe8k8b8kquAbWk29mErIOF6jVYjF1XBGPI6JkOjNNhu3NmnU37zrSx6qsNjNgqb09IJbI2hEOwO0ysj2guPFupPnB65zv9dN+vKkqT9qpScLMCxO3pyM/aXZa3nJOSDtJke979aH9ybEU8wpe73iLp+qpeJuKo02ryKk6WZgBVY6koJA6t1qNu+HmQnC9GH6gbTq3tTZWCD3dyEJ0TqNG96b9StqzpmnBgI8GfejRL6L3KUotAa+SPr0dVgvsrcw//ReOFwE3bdpa/ePiSLhclFA8Thl7BRHOZ3DkC5BAAk8Me5LP/pfo1xoIMMA4PPoQrn6wNLOzYoU9pk4kGHsyz67ipQ8kAb1wMAHE0dau6bpPpi7rncEqOU4f+ttDLkvu6cBF4ZkXYIyQvSRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(316002)(4326008)(6486002)(5660300002)(83380400001)(38100700002)(186003)(86362001)(2906002)(6512007)(508600001)(8676002)(6506007)(8936002)(66556008)(54906003)(36756003)(2616005)(66946007)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1bRWZr1JaQqkYnaO4QuLTxlmTWL1WzFNXdsn5O+tc1xF7BVr0u0+f7bdfSpp?=
 =?us-ascii?Q?4E0n/YiVfHOr7sE27Wod+6mMrMbzru+6NicferrESMbxOGXzjt2AupPDv4sG?=
 =?us-ascii?Q?O3Uo79R+x4M3p4Yf4mxtKa1sKSGpyESojh0/iqn0I3Gzn3M2Lm6TGiCmG805?=
 =?us-ascii?Q?KIsio+KHu9wVaVFVcmTbgB1mZy2e9CHHg/WZl6Ug+q1neQLq/6OTtyYDkqrB?=
 =?us-ascii?Q?RZxuVpGNRvE+VbLX9mTrqLEOtMXoFl4AIwK5Ddcv81PchY0SIoL7vJbQPVmA?=
 =?us-ascii?Q?Vp9w52sqW6lt761cHRUWJQpfinoZDVhw3GQOiYJSsGvH5xQPzmQg1bswuWpl?=
 =?us-ascii?Q?4Zz9GHHJO04vUJLxMQjWrAJhzhJvlXN1alVsF58z9M9c8yE+sRUz/Mhx1U7Q?=
 =?us-ascii?Q?5uVa++pcljKC4WFHlVLP10k3IDod4UaoKSNf0z6NKtTjJL+LQgeobMrShpWh?=
 =?us-ascii?Q?LIx7vSzb5zxmnxjZJQ7ozEw+GymhUQ0+lDHqXgDi4Ip7oVXoxt6jxF0GbBqp?=
 =?us-ascii?Q?QShkqTg1j3KhaFwiQNi3wTkYa5Dci55ocXjngj2AcJYeAogFbtdcZQ1/1Jia?=
 =?us-ascii?Q?z+dNtsfqi+L4sOV8oiBfDibXyHhLVUphokekIJUVwxaGaQUIoYa5wc0Xj/Ji?=
 =?us-ascii?Q?pwEJ7VwdhbQ2ibkQmoFpRk4baZXHbN7pjOMKc6paKxoqwbbDwVAxHLiU1IYU?=
 =?us-ascii?Q?gAW5QPseiFnp+kLqBX1gbQqR+j8yN76+sVv7Se9tAFrAyk4G0YmFx8dgaaJ2?=
 =?us-ascii?Q?f9Fz30w9PSgotMX8TO/uV/KDlLbOZnmsVo50pHWsWxjEJwxZnkj97Io710z/?=
 =?us-ascii?Q?Ce+6NxcIysSfU1Glbj1UMflPoByythIqOpRX9qsj0caDFrlRS7o8jJx1CcqZ?=
 =?us-ascii?Q?4smEinhEhtuG5CdDMrN5Y6odSjWZnR0VtBal+IA35k2GnpjOSywo9ja9zTTF?=
 =?us-ascii?Q?uwNKc1ITssF6TByBWzqpib5m0Ggfp7k337eeBkfcUP04rvx0hbk0uJr9vbLq?=
 =?us-ascii?Q?XBYo4q6WRFyCvWsT0ZbULjKdBymy7h1BtnFU9UnVrSQomJGdk3uXNPu7wrGu?=
 =?us-ascii?Q?+c8+d/lgTr1akQfzTnTjL3bp1YgtjHYWg3bg0IytJ8tpklvpmZiKEI/+oO2L?=
 =?us-ascii?Q?gegUyH5gN4pQAwq1lBaoVGJRKV4HoLh9VUsz4RlNPmkXPhyuRA8CMz1eA/Vs?=
 =?us-ascii?Q?jhIP3fFNo133bvHqS+hNJkEwEEde4+idbjWiEhVO2kvgOcWCma1WeYENlTzj?=
 =?us-ascii?Q?zc62Xj1D4fZfS2KiFDa71hNa+tosFpTZ1BMi1p9zEq6W8NLjvf7zk8FKj53G?=
 =?us-ascii?Q?35TDu8ld5OXusoG2+CA08vviKSTeLWmX9RK+pVaQ2nGtrnHyYjIbNVbNtsN1?=
 =?us-ascii?Q?+7VvtIM2jnFfYAQL3kZ8JG/7OXWLDCY4ICiJ4IcfWdqGCWR/9w8qBHi/nMOn?=
 =?us-ascii?Q?Idr8mrC7Xz18K+ehF5mwcWtJGVkuGvn7AWcjGiXucGPs84k4WX4YzzEGEZZ/?=
 =?us-ascii?Q?9TPoTWLgaWlmmOyXSkr6jWY1YM0xshgkQvfySR6UhvJ9G2vHxkJI35dTgizD?=
 =?us-ascii?Q?6FXAtkvYTCPulebmlQsUM0mC+SYyXpBhqkFV5A59X+rErwwrMVOjQptYaSVz?=
 =?us-ascii?Q?c4YMFm+tiTjHeAEHzzIm0td/kCaXV7R3wL5eIuMil/cCOF0/u8HcOy75rT4K?=
 =?us-ascii?Q?J22WEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feed8ee8-4f11-4d15-d548-08d9c094a413
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:04:49.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaymNV0W96Q7WxmaeD9DWRgc3c6RJBsPYTBzKzzypMyD0UySQdIb1vbuIuSpRvbxkDhunWtn3FshYIxdkTUnNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112160073
X-Proofpoint-GUID: EiFVMRz_Gny_c2_UDtlVEY_KKvSm6HuS
X-Proofpoint-ORIG-GUID: EiFVMRz_Gny_c2_UDtlVEY_KKvSm6HuS
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d24fa5c1da08026be9959baca309fa0adf8708bf upstream.

In preparation to fix a bug in btrfs_show_devname().

Convert fs_devices::latest_bdev type from struct block_device to struct
btrfs_device and, rename the member to fs_devices::latest_dev.
So that btrfs_show_devname() can use fs_devices::latest_dev::name.

Tested-by: Su Yue <l@damenly.su>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c   |  6 +++---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/inode.c     |  2 +-
 fs/btrfs/super.c     |  2 +-
 fs/btrfs/volumes.c   | 10 +++++-----
 fs/btrfs/volumes.h   |  6 +++++-
 6 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e00c4c1f622f..244cddf050d1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3229,12 +3229,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
 	btrfs_init_btree_inode(fs_info);
 
-	invalidate_bdev(fs_devices->latest_bdev);
+	invalidate_bdev(fs_devices->latest_dev->bdev);
 
 	/*
 	 * Read super block and check the signature bytes only
 	 */
-	disk_super = btrfs_read_dev_super(fs_devices->latest_bdev);
+	disk_super = btrfs_read_dev_super(fs_devices->latest_dev->bdev);
 	if (IS_ERR(disk_super)) {
 		err = PTR_ERR(disk_super);
 		goto fail_alloc;
@@ -3466,7 +3466,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * below in btrfs_init_dev_replace().
 	 */
 	btrfs_free_extra_devids(fs_devices);
-	if (!fs_devices->latest_bdev) {
+	if (!fs_devices->latest_dev->bdev) {
 		btrfs_err(fs_info, "failed to read devices");
 		goto fail_tree_roots;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a40fb9c74dda..3c7ee83e9199 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3327,7 +3327,7 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 	if (wbc) {
 		struct block_device *bdev;
 
-		bdev = fs_info->fs_devices->latest_bdev;
+		bdev = fs_info->fs_devices->latest_dev->bdev;
 		bio_set_dev(bio, bdev);
 		wbc_init_bio(wbc, bio);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b4651f008d..4af74b62e7d9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7967,7 +7967,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 		iomap->type = IOMAP_MAPPED;
 	}
 	iomap->offset = start;
-	iomap->bdev = fs_info->fs_devices->latest_bdev;
+	iomap->bdev = fs_info->fs_devices->latest_dev->bdev;
 	iomap->length = len;
 
 	if (write && btrfs_use_zone_append(BTRFS_I(inode), em->block_start))
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 537d90bf5d84..e4963da4dd08 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1705,7 +1705,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_close_devices;
 	}
 
-	bdev = fs_devices->latest_bdev;
+	bdev = fs_devices->latest_dev->bdev;
 	s = sget(fs_type, btrfs_test_super, btrfs_set_super, flags | SB_NOSEC,
 		 fs_info);
 	if (IS_ERR(s)) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bc2e4683e856..4afa050384d9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1092,7 +1092,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices)
 	list_for_each_entry(seed_dev, &fs_devices->seed_list, seed_list)
 		__btrfs_free_extra_devids(seed_dev, &latest_dev);
 
-	fs_devices->latest_bdev = latest_dev->bdev;
+	fs_devices->latest_dev = latest_dev;
 
 	mutex_unlock(&uuid_mutex);
 }
@@ -1225,7 +1225,7 @@ static int open_fs_devices(struct btrfs_fs_devices *fs_devices,
 		return -EINVAL;
 
 	fs_devices->opened = 1;
-	fs_devices->latest_bdev = latest_dev->bdev;
+	fs_devices->latest_dev = latest_dev;
 	fs_devices->total_rw_bytes = 0;
 	fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_REGULAR;
 	fs_devices->read_policy = BTRFS_READ_POLICY_PID;
@@ -1993,7 +1993,7 @@ static struct btrfs_device * btrfs_find_next_active_device(
 }
 
 /*
- * Helper function to check if the given device is part of s_bdev / latest_bdev
+ * Helper function to check if the given device is part of s_bdev / latest_dev
  * and replace it with the provided or the next active device, in the context
  * where this function called, there should be always be another device (or
  * this_dev) which is active.
@@ -2012,8 +2012,8 @@ void __cold btrfs_assign_next_active_device(struct btrfs_device *device,
 			(fs_info->sb->s_bdev == device->bdev))
 		fs_info->sb->s_bdev = next_device->bdev;
 
-	if (fs_info->fs_devices->latest_bdev == device->bdev)
-		fs_info->fs_devices->latest_bdev = next_device->bdev;
+	if (fs_info->fs_devices->latest_dev->bdev == device->bdev)
+		fs_info->fs_devices->latest_dev = next_device;
 }
 
 /*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2183361db614..4db10d071d67 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -246,7 +246,11 @@ struct btrfs_fs_devices {
 	/* Highest generation number of seen devices */
 	u64 latest_generation;
 
-	struct block_device *latest_bdev;
+	/*
+	 * The mount device or a device with highest generation after removal
+	 * or replace.
+	 */
+	struct btrfs_device *latest_dev;
 
 	/* all of the devices in the FS, protected by a mutex
 	 * so we can safely walk it to write out the supers without
-- 
2.33.1

