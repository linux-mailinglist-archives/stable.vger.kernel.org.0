Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD486CB39F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 04:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjC1COr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 22:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1COq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 22:14:46 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C2170B
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 19:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2gpUF00smSnjDM/fWptovg7mtNnegIEqbjhxhf91Hps2RbMwc2A1h44leW8ywGysrADeOemw2I2f3NyBU7t21Losex1vPoubE/HlIfNlvMnUMQFXe6+lpww/b30pjN+/e2Il6GEMQ4+xDByscKfnh8SdwivAz5S8ECbgt712yKCaJZbglZ60LNJvN0dAg9vXIlgZCAg1QrNK7sSHm/X6Ts8lhrilRz8p00U3+OwXcFnqIsu+9/pRikXt55ogvuJv4iWj3DtWaa9iIrITgXfUSmdzRRI7s1wzsPsh7LmKxcGk324oLDfHpt29P5dX0bCON6aHDd8DjIze5jWcGSnBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB/pMG0Ct6b5YIoLZCDIjS6jkfqnJOjUc51ozxc71TE=;
 b=U1PJE0orhN/Ucpg0wU9Xk3SSOuK1bRpRIoGHuWFpHFElx2SK1Mz5HT5wHR6Bwi2rjO/n5rRdYBH1296MuGTBBUMJUpoGnJ+rMpU9VZZgSQKcdbjZluvcEFgtxdgDjawzzaCaLfcEnG73T4N+Dmat63boNJErCivXgo4K+ZV8UslBNimUOOCHZrX2rxKR6byPyH73Hxj+3F8PB9/I6RhzEF2iRfE/0etjowFRM288pZnizV1bWfSWLRjmPSaPRN/6tADyCzyjtE40R4Q99AiAuCioZWhrJ6YHXtpOqCluNijCIijitXCcZMlUhmBGk1BI+2XVsXoZlHEI+gdQyYXB1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB/pMG0Ct6b5YIoLZCDIjS6jkfqnJOjUc51ozxc71TE=;
 b=aCZVxjjuyhqvHjGVyqBcIhlkLgsuFOkpEf/srUKUUVFdTcCQxg6g9ZjfOlb8AhsqWjtw1D1Rut6abrqwdHVdeOcFej4+ZYDaGUBsXnDsKXAuH6+bIUSLeMDMjBMrU9SwyuOWwA2HfXI5WCCbCebJjSIc7ha9ZScL67HBL/mm7aRmb49V6XuLglTPh05AEzvH/bYv6gplqQ3w1E6aAXcQXT1+3J7zFY43swGt6npmaIHCLY4NgJw1pxH8z5ots6BW6qy8QQgBdxdE59wP8+vfrlfuzli0wW4zxfseuaFEor8i8nzEBXDS9jlOxnjd6VcJqq6UxknigfG+PWG2TAWyjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SA1PR12MB8643.namprd12.prod.outlook.com (2603:10b6:806:387::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 28 Mar
 2023 02:14:43 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%6]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 02:14:43 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        nouveau@lists.freedesktop.org,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH] mm: Take a page reference when removing device exclusive entries
Date:   Tue, 28 Mar 2023 13:14:34 +1100
Message-Id: <20230328021434.292971-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:332::31) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SA1PR12MB8643:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cff133f-1cf9-4fba-549d-08db2f3231a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TK1SUWJWh+VfBH1GnEbMpJF5e24im/o4WfJZGKitARIQSCnukLabNmqVpEpzn9hmA6sQe8s7l8slsSpQoIuPi36ZB4zYAjAqQRC4/k9hHeViKBIA+PjMNF/s2d3Kab1mL+7UHRv+efeBMHyFHbgtf2lN5a56EmX6W1e3W/cZVzx0z0M2ds9POkrSK4HOpZ/BxQFsAB9jddBKsiQzJhJ23fp7TByeugWOMMVgacaIMRjEqJjVsWJSZS1PZlMck30fGR0wQchwhAscjHESU+7YWj/cpjurc6rg1qTEg9yhxGrVZDZ2hGwthLjzeLjUMvwJqbzaDZtGmJFkOBYwpB77ed8aUmEVNz/sC+mQ7T/pZulgXkE1Ek6IrIUEB7FlPWkjyjUAN8cyqQf7v56Puu52GNizTrhMZ6mmOtAXyffqk2K5mKYR5tat5/ptrLJ4nxCe440wbHpGaN5SEUhd1GMBXo8Q4txIttZFVjje/4GTTvi485oqOidwyOXSaA+yGnD6zBlo2BVWuc3G+tNpwexZehelnFKGNjOFFz5UVbPeqgfkNbo00dIvmb2VzHuRKLuX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(26005)(1076003)(83380400001)(6512007)(8936002)(6506007)(186003)(36756003)(6486002)(6916009)(8676002)(86362001)(478600001)(66946007)(66556008)(2906002)(66476007)(41300700001)(316002)(2616005)(38100700002)(4326008)(54906003)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkRF8mmdPwyRERj5KZSiZzP/yP9TSUlEnC5bksaesQbaqcMeUL40wr7ASCqF?=
 =?us-ascii?Q?UD5oSPB7r3GACx5b+meWynIHjVxSqrBVvmYPED14vN7yz9b+2Lb1FpDc2cou?=
 =?us-ascii?Q?98Aep3TVpTpykPb+pYp8MEDIvNsNgd6HQMOHClYO75M+yKQWxcTHxxHIDBCU?=
 =?us-ascii?Q?kAGefm/dh87vjyJ5/+3rsS8SqtZC4YO5FVXl8oSb2S6thWVjTW1Q9mWu4I/W?=
 =?us-ascii?Q?L5iwfK7C3Rm9/7QBOBT50QIbkqJ8neOptJknLXyNQvsd3wGQT0aLn6QOPdFI?=
 =?us-ascii?Q?4DX5W7Jw/aD9319NwRM7Pn2ILLu7H4JA84ywOUxdeD9Qb41d4sAZMTX9rayC?=
 =?us-ascii?Q?mSe9DQ5ICMV4vpsT7wiUDK+PovgteXQGEx0DXX44uLpWFL8k1qucp/MDOIil?=
 =?us-ascii?Q?OE/w7ItkBdUdkxpJPqPLZikJ1+nAK8B3KQ7Y0+FY1emm5K49fUwFWwpIa9jK?=
 =?us-ascii?Q?+5SwhR1DWQao4czdDKh2E9IJRkiV1nRGofgjGu0ZOoYcBz5jp88nUadMtX93?=
 =?us-ascii?Q?Sz5AHYNK/VsDeVRX0NDzSnMxtyOw5mVAL6yysL7aBsvqmiNkIdXVtDB1ERfm?=
 =?us-ascii?Q?bhLXEMPe9677qQ86GX+GKG+4o9BB5YfP9tJ/dFktau6DbTQPZnqmt6YfAT4q?=
 =?us-ascii?Q?tDMObqrnRrkx6nU5Y3X+QJjxZnBqUa+WAmcVK3hqU0fpCMa78t5L1iDkLIYs?=
 =?us-ascii?Q?RHtvB0Bwl3gButsjBQZJ4TWQt4OEKh9q0/aUOF/tIuSZTXG8K4nmfC+eFFHv?=
 =?us-ascii?Q?9hVrZvaXS3Z5QVkNMpBt8paFd5VQUPvQYRnH17SYDGwRl7wtoQeWVnufRpbb?=
 =?us-ascii?Q?dTwxlTjM8PuJO+jZ9FaJMaBRT7/x2QaYGqG103bz2OMeYuCCSJJiMzvrdp4n?=
 =?us-ascii?Q?Y6rWaVLBOMR9S+danYzWOWMEWGyYb3rvOciFEvl1IdjejFDf6Lk+gV/3ie4r?=
 =?us-ascii?Q?lnHQjSG3haekm02fTxoko5D3TgVEIZrjOIwydXgvxAQcOaag0qcIENDYs2+u?=
 =?us-ascii?Q?k41NpwTO4OMiVYBIg9VYNGPirjENM4O+xgdRdpuM9bTkNjJSKxZKHjGHSLeF?=
 =?us-ascii?Q?sN5EO+Vvv9JK/6hJDjCRtCtd0rJIfZchW0tqDTbO1+oo+OuhU8gzO8hEyvxs?=
 =?us-ascii?Q?r7c2f2pxixk85kSCXdLeROhxQxdstXgGzNn7H7ZVzLkj2RTdFVmfYrzxy0qN?=
 =?us-ascii?Q?whG4wuLFDwy4dVaBM8/Qy+FnMy1WGAwWxJ7S9zbmVIx4gXGd0CE+ZXe77oyV?=
 =?us-ascii?Q?TCppvLRefIO8Dd2cj3vjlmOkp+tusnFZmnoGof1bML+lXsE3JeF3pzOUoTkF?=
 =?us-ascii?Q?dy4H+wj/JTIxCZSbsXaSPyhmn8Qa/70irtSG9wS2brblasX8NKAqQh0jGEzi?=
 =?us-ascii?Q?iyOEYC4c5PaupFLqxnQiDfNvT6o96eaeshcOdfGT9/713zqoMxbkKEQ1HvBX?=
 =?us-ascii?Q?Y1JF4EdbwRW5V5Zc26lWjOcEm6WMBmv3Mlo+DTm0qG+EqscpozLi7NCf/Z4D?=
 =?us-ascii?Q?k7Hxl9a0LiSoOfppnV7E1k2vpgxyXKnk3HRvVptpG4sH95+/AmZADuLerL4o?=
 =?us-ascii?Q?lRAj+ao6B3ckkU5KKzv4IRI4Ar3B7NCFG7CDxylp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cff133f-1cf9-4fba-549d-08db2f3231a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 02:14:43.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oObOjz5MeMe18XyqjRKDaPTHP6YNwHGUAQPh4rlVZwkzYfkmJI0iQOfUBK6NK3cXdc+jfajlOoKcPSvOULtbrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8643
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Device exclusive page table entries are used to prevent CPU access to
a page whilst it is being accessed from a device. Typically this is
used to implement atomic operations when the underlying bus does not
support atomic access. When a CPU thread encounters a device exclusive
entry it locks the page and restores the original entry after calling
mmu notifiers to signal drivers that exclusive access is no longer
available.

The device exclusive entry holds a reference to the page making it
safe to access the struct page whilst the entry is present. However
the fault handling code does not hold the PTL when taking the page
lock. This means if there are multiple threads faulting concurrently
on the device exclusive entry one will remove the entry whilst others
will wait on the page lock without holding a reference.

This can lead to threads locking or waiting on a page with a zero
refcount. Whilst mmap_lock prevents the pages getting freed via
munmap() they may still be freed by a migration. This leads to
warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
when the refcount drops to zero. Note that during removal of the
device exclusive entry the PTE is currently re-checked under the PTL
so no futher bad page accesses occur once it is locked.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Cc: stable@vger.kernel.org
---
 mm/memory.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8c8420934d60..b499bd283d8e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3623,8 +3623,19 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a page reference to lock the page because we don't
+	 * hold the PTL so a racing thread can remove the
+	 * device-exclusive entry and unmap the page. If the page is
+	 * free the entry must have been removed already.
+	 */
+	if (!get_page_unless_zero(vmf->page))
+		return 0;
+
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
+		put_page(vmf->page);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3637,6 +3648,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	put_page(vmf->page);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
-- 
2.39.2

