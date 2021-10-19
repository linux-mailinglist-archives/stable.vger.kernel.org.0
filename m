Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1655A4333AD
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhJSKk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 06:40:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29310 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230123AbhJSKk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 06:40:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JAaVT8010378;
        Tue, 19 Oct 2021 10:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iArUNgSW7wg5vF0G3exdVVyPjWDRm2tqmFGPAANWwVI=;
 b=SY11+oCG7347QDgEb5iQNLUSOKZfNI29bkVjQ36QWmdLkPxHOMUGy2F7Y0euElIv0Jrx
 /4GG9TmzaM2rSJY9ZtEyzfjpCrkkvgxAP7a2hreIJXkFRjxOnHU1zn/SMMWDxY0Jz0Ul
 KdVwnSzedHF0TE9m6lqxIuiuXezoqsreksDqKRPVE6QVmFQM411KvgUtOAyh9DtLfYOz
 EBZ2svVcgNTJdsnEH7V8zGpsX2URhUPuZhFfQb9+p69W9CxP9/IVx/SDNiDjJ6NxX3tV
 QnHDOKjI/Yx8zUYbkquNAPE5AuO50CCoBlC2LMTKCliOiNkERN8VAGnrKmGnXqb/YzHi Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsr451c40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 10:38:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JAUnY4021132;
        Tue, 19 Oct 2021 10:38:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3bqmsehh3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 10:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mp8Y8qdOXYGbjjcnC0lQib6ALszL2qTV76b0j+zRVBMey2guaZqTuB33xMZ/9LHJIAy5uwQip+inIncDH/Q+9IolCol2q6wU2PIl8+6jRUeoj0bbn9Wn3Umg9kXz8nr3TQm8rQAFaMaMHOkLLunSA0VXYRrpr/jXQ3B5Qu5hMYILaUSXNBpFLi0u0TLl1VIC7PYSl8VV+wFNUi76PJtcNE6RMCGMzobKZdL9tVvYnmcc6XztDk9Jgm3sBujp317jBXi8PTwPuGNOYkzLi/D8MmvspZyNhHaidukP6inJDaJpJWLI+T/UVgtNS/fW7yN+/HG4yTiLB0udEXcgFW9arA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iArUNgSW7wg5vF0G3exdVVyPjWDRm2tqmFGPAANWwVI=;
 b=Q0+iooiKrVs6jUXRpD2skXsFp8xMvEUwRr84tstCVHntxp4z8t6JIyxr+e++mWzzFFIe5OnIAto95npRP3X0/Q6wtbqOPngk/phEcBS2jq00aAvGu2l35keCj2pyP2JPTtl5HZKSB99DLGhJFoZRiICrmutIi6UogFnyWUvuG/syYC4zB98mtdC9gJJhqR2fB1T94rbev8mgq8eFIuh/lXMz6ezqU4ZHxtX0RWHstF61BkVuUlf1v4G9q4rokhuAwKbjrVmi8/qtv9itbE5SXTODGyOwl4ezsxAFTLVOx+sofX7nokDmnI+2HqsGbfdT1k32xtmjt7MPRsUN6FYMzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iArUNgSW7wg5vF0G3exdVVyPjWDRm2tqmFGPAANWwVI=;
 b=FFhEk80wVep/rl4394BQ09Eo8iezAQ9hsrOhpD3uhZtAwVmEE9t8T/FL3vmn9f+WQJm7lJxJ//xCZQcpk5oqGZHqTohZfv1U+bAvdVDJgQIyiQ/F4jJlXPvwhIk0k06yu8M6AkHCuJDjf2KUECrcJ/fOoZ/8GaVSJMavfGnbpXk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4867.namprd10.prod.outlook.com (2603:10b6:208:321::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:38:37 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::49a5:5188:b83d:b6c9]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::49a5:5188:b83d:b6c9%7]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 10:38:36 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-4.14.y] btrfs: always wait on ordered extents at fsync time
Date:   Tue, 19 Oct 2021 18:38:20 +0800
Message-Id: <4fb0d755f4265d71b2a0d314232e53b22067fb0b.1634624427.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
Received: from localhost.localdomain (39.109.140.76) by SG2PR06CA0244.apcprd06.prod.outlook.com (2603:1096:4:ac::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Tue, 19 Oct 2021 10:38:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b443b619-b853-46ba-de58-08d992ec9b6b
X-MS-TrafficTypeDiagnostic: BLAPR10MB4867:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB48672419872D9FED0613B210E5BD9@BLAPR10MB4867.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obMBX7u6Rrr73qi1ugFhh6TqD0gwaA51esjG6AZ4KqRHg8p1H/j800gYsIZHnihHZ+BwqnlA38Wfnokw6cWkat7pUH96HzK4K6oOM5jknWqaEA2w+cn542/4BL2/H29Cwj/iBerKnd5HkkxNQKC0D59OJgKpM+fAVN6rq0rye3EVidqQKQyK1zMEbsjddlkdD/tfPXFYuAcHZhzIvwtXUSKg2DafuKE+f4r1bjwJRx4vJH6NlDNLx/l6OAv/tjI7CTDlzEgVh1AogWzGR3RczqiOuoGvVWR/+RtorhJAvegu1CWTexe1Bg+fuuQZPdOJtecohdo/5mmj6y7nAlmFgOuijjk84z3CiIkwzlxNK+H8yVFPZ7ZF3irsmlhIzRTbcLsQZN8LI6XHKI62STRlyv0GoFuT3kS1b7ItENg7k++jgCTAy8Df0RYSdLstxyWvcY2T9RqGc/0efq4siRnyoSmWvBiscCr1KmGP2s3otr2hk1H3wN3pEj8MAfMHJ+cW7zr09q0msxK0UC6PZcHFL458LbBM4eiE6z8WPBUGQKLjaLEj+l9ZvG2/Zh0ZkfTA+LdrM2J+ZKOPsIkEJCYbrhQUCQMnm7gVhsEYirL6yhPZSjkYqpwga6waOKAEe7fYDpn0xlWFZH8MWFlt7DJhp+6vWzx/ti6LCNtmF4I68Lm5ZRBV4DRsT/ZBIdLuTjK4umPnkfv6O/pwxdp603u81A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(44832011)(8676002)(2906002)(26005)(8936002)(52116002)(186003)(316002)(54906003)(956004)(2616005)(508600001)(6512007)(86362001)(38350700002)(6486002)(38100700002)(83380400001)(6666004)(107886003)(36756003)(6506007)(66946007)(66476007)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfa7/meg28jIVqDSclf9+bmKQLIzQQJaxF0D7M3hDRUTDs+gqFO/7XMWuSff?=
 =?us-ascii?Q?KrDA9M/rY6OboRe8Qe0x6jQlrZSmShjM8l0gaKkQ3eg/2WQb3FrrLj+lgKXu?=
 =?us-ascii?Q?OD0kM/g9aJbKUtDtoFtdWRLh80KLqKNtPA90rUu8JKpygCArl/r4JFqsU/zb?=
 =?us-ascii?Q?DPXYuU7PcqVhq47EVKWPyIh142jbgklH7QoaH32/7/WjJPqkt11iRDZh+xJy?=
 =?us-ascii?Q?pNABHWxIZVFNry7xK8SYSe4yAbJEjuLRCNZH8x6YJ9oqw6mVgo1hRO37KO7p?=
 =?us-ascii?Q?8fsKRaqRcRmIKxtGtVrzqFu8MnaLxgEEB1+VvNrxjLfkz3UAE95w3TEJ/AVu?=
 =?us-ascii?Q?jdb64ZBVdml3elGh1gstnHjLeDTXzWXXq+UOGCcuvyNHjaSj9lt8YjD1nIuC?=
 =?us-ascii?Q?O3IuNRZC7uWSIBNsRYmn0R5pVvXnL7/nEKN3SCRDb4MoxDUR3Am2P8JaoGxA?=
 =?us-ascii?Q?pUWzQr+PZlj69syJyPLfXfrYoXoxplYOrKpJeHZBve/AvFGSQi1RS1DR+Zmo?=
 =?us-ascii?Q?wewpY0t7mqZbdfei1nu2sqzjTOH44qroL1nsRaIUnC1n+hb56TkyI5qCUiMj?=
 =?us-ascii?Q?R7jCmJUJQHjPmXoSqE+gqrI5hF0wjWmXmgWtQ9Drpeuq8NIzEUrQ4hFGsLFM?=
 =?us-ascii?Q?lu71Qy/xLvQU93/mQsKtLGKcznM1JsQZaqhZe1EAEDq6pewmbspmmHYWtIM4?=
 =?us-ascii?Q?NSL9qr1sZn7/UWBTah1HKJ6lZL1FM27uaTasLT+rB6J+Ar8y8QhlBOtIFdYi?=
 =?us-ascii?Q?LC4uz0vEC2jGCCb+HQEY9CdmsD/4P6Jdge0oMFDT1DsDlbyMVzyeRSuXaYim?=
 =?us-ascii?Q?1q1iGkSExYEn2sc5E7CU7SH0vZRWwGWKAKfNnB58SxvppoRT3aV+6mPstp7R?=
 =?us-ascii?Q?Ka2mRBhhJcBc92nUAvtzrv2aUHGSdr5XdSEr4BBY01+sHn6S7bCF6vPLNt8x?=
 =?us-ascii?Q?ezjWE/h96mULNZDQY//RM3ZSgMEq2a3c5FgxgOBPUE6kihqKrYsV2B8lLZvX?=
 =?us-ascii?Q?F/2DZxWO+BAqbPReNQPWGJ2ubSPfSgTvdcdWhhz9+MZR9+OFGF0QhhtVKg1n?=
 =?us-ascii?Q?h4zP/OiFr+X1zTFzrKMwxCnMHyBdDixOAXZHtkqN3D2fBbyaGrT3SDjc2EMa?=
 =?us-ascii?Q?qHckc6BKnQNnM1c/Yq+lZU+F2tJ/jjtpcNruTzEBhNvLLBUlWoprTfXlPJr+?=
 =?us-ascii?Q?8nVpp1JgNaU1TB4Wmki8vnHeX4FQmR7JLW+ybp/2QpE/eI0MbZBsLlWwHMqQ?=
 =?us-ascii?Q?7TvTPtdS8qlnA9piZgdwKkbl8ttGT5dQn+0iRgRvEf/bocbilbSbmytJ5Uyn?=
 =?us-ascii?Q?SiPtoqd4bA8lOxG2aJV7Ss3k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b443b619-b853-46ba-de58-08d992ec9b6b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:38:36.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCQVN3EvOmvV9HWQZqigVIbmwRLNVuqdJtOpipTZ+c/2VvRqcl3IbHgIqwl6rQ8ElW/D+2EGIIX83fejbLgNSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4867
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190064
X-Proofpoint-ORIG-GUID: Wu9cy2XsaWk3rl-KpUBr6n0jJlKCqfhZ
X-Proofpoint-GUID: Wu9cy2XsaWk3rl-KpUBr6n0jJlKCqfhZ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

Commit b5e6c3e170b77025b5f6174258c7ad71eed2d4de upstream.

There's a priority inversion that exists currently with btrfs fsync.  In
some cases we will collect outstanding ordered extents onto a list and
only wait on them at the very last second.  However this "very last
second" falls inside of a transaction handle, so if we are in a lower
priority cgroup we can end up holding the transaction open for longer
than needed, so if a high priority cgroup is also trying to fsync()
it'll see latency.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c | 56 ++++---------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dd2504322a87..2f386d8dbd0e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2102,53 +2102,12 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	atomic_inc(&root->log_batch);
 	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			     &BTRFS_I(inode)->runtime_flags);
+
 	/*
-	 * We might have have had more pages made dirty after calling
-	 * start_ordered_ops and before acquiring the inode's i_mutex.
+	 * We have to do this here to avoid the priority inversion of waiting on
+	 * IO of a lower priority task while holding a transaciton open.
 	 */
-	if (full_sync) {
-		/*
-		 * For a full sync, we need to make sure any ordered operations
-		 * start and finish before we start logging the inode, so that
-		 * all extents are persisted and the respective file extent
-		 * items are in the fs/subvol btree.
-		 */
-		ret = btrfs_wait_ordered_range(inode, start, len);
-	} else {
-		/*
-		 * Start any new ordered operations before starting to log the
-		 * inode. We will wait for them to finish in btrfs_sync_log().
-		 *
-		 * Right before acquiring the inode's mutex, we might have new
-		 * writes dirtying pages, which won't immediately start the
-		 * respective ordered operations - that is done through the
-		 * fill_delalloc callbacks invoked from the writepage and
-		 * writepages address space operations. So make sure we start
-		 * all ordered operations before starting to log our inode. Not
-		 * doing this means that while logging the inode, writeback
-		 * could start and invoke writepage/writepages, which would call
-		 * the fill_delalloc callbacks (cow_file_range,
-		 * submit_compressed_extents). These callbacks add first an
-		 * extent map to the modified list of extents and then create
-		 * the respective ordered operation, which means in
-		 * tree-log.c:btrfs_log_inode() we might capture all existing
-		 * ordered operations (with btrfs_get_logged_extents()) before
-		 * the fill_delalloc callback adds its ordered operation, and by
-		 * the time we visit the modified list of extent maps (with
-		 * btrfs_log_changed_extents()), we see and process the extent
-		 * map they created. We then use the extent map to construct a
-		 * file extent item for logging without waiting for the
-		 * respective ordered operation to finish - this file extent
-		 * item points to a disk location that might not have yet been
-		 * written to, containing random data - so after a crash a log
-		 * replay will make our inode have file extent items that point
-		 * to disk locations containing invalid data, as we returned
-		 * success to userspace without waiting for the respective
-		 * ordered operation to finish, because it wasn't captured by
-		 * btrfs_get_logged_extents().
-		 */
-		ret = start_ordered_ops(inode, start, end);
-	}
+	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
 		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
@@ -2283,13 +2242,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 				goto out;
 			}
 		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start, len);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				goto out;
-			}
-		}
 		ret = btrfs_commit_transaction(trans);
 	} else {
 		ret = btrfs_end_transaction(trans);
-- 
2.31.1

