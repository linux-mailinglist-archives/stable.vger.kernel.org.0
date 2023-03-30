Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1AD6CF8AC
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 03:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjC3B0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 21:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC3B0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 21:26:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031FB524F
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 18:25:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaeHwtcJHuwb/5Qo0oDEIdrrBWKgUJj4l3QPYCuNEPpefKjyrVDI8V9UL6rGbXHUbJ9aWf7Izz8+80F4TL68Sg4pblrP7nrDXDftABFTIoNbKSIu/4ECnAjcZb8YnFmaWRmwdfBXbwAS9gyRqRszW8hbFtHPco/262GrZkzzCMzPRXB4QsrSRGbBthSASLHlUo826js6bHsgPp4xWlG58HZtDAP3ELqNDYb1bd7hPG+TShfNHMM0FtJSE5IUKRW5qTZ+JHlKmWVNzVHYWeM6RAEF2RMjjZYMJk/w7xzsAEtDXyuffe9u5NjGqfjid2hhMsqkOt35wtG5Bz76qGuRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtXwYhy9cVcI/6nGPOMa1JOGakPLhFQCZ71DWmvEDvc=;
 b=GwSwtbxc4zbZad79W9KAp/T+YkDGpFUxonsCu+ReXFgRy6C+yHO1AZcE/7/2i0VL/psOtaaqC80Xd3YgNkr1/k6PcqdG5Nb6t0ln50bNVunSpfQZ7l1Q4X8y+KOS/Bki4eAOVXb96dw/2uXKKr2eVqNXDaBU6PbCFHuNoA7fPhUHmAwjLMdzCwLDZKkaBHgM1sCpCG1L+tUjef//VQdPo96h7ZIi2Ro5yZIp/fvTmvJWCFub/W1P66nAmdcq5jbJT0jf3rP5bXVV1yM4qHGprbxGKx7VAO2rijlGGUffhjbIjz/lO20ZrEkQnrwfq6WfSwYxY4nSYdm72G2CAINHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtXwYhy9cVcI/6nGPOMa1JOGakPLhFQCZ71DWmvEDvc=;
 b=kmqwDId5doDe6FVh3/4QZ2GMM/hjtefquo3f5epB/ms38A7X0z5t2HK1AqjgWzGL+WxOUMlwauyTvHnGZnbBmWZN9QcehacnWvAVLsUceYmgHXihqoPdV6NppSz2GPHNmc9AU0WeHw9Fup7RGx5s92VSnR+31oldrEBlKNJIoUUeyJEAUOIHGhYAIQWy1FW6HkBxhUkjmxKAuYe9p5f66lkmWEIhiXE3T/m96TyPa0HdheeDS3bGgGaRjZ8Bd0mK7E+PSMnJl85W5WlHzA710OLIOyHvq14zUU6131mjdvvoPYzaa9DN7umqbbSz/BlgW3m0J1XnVWSrOsrp5F1I1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SN7PR12MB7882.namprd12.prod.outlook.com (2603:10b6:806:348::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 01:25:55 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 01:25:55 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        nouveau@lists.freedesktop.org,
        Matthew Wilcox <willy@infradead.org>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: Take a page reference when removing device exclusive entries
Date:   Thu, 30 Mar 2023 12:25:19 +1100
Message-Id: <20230330012519.804116-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SN7PR12MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e5ff3a-758c-4715-68ad-08db30bdb57d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYXqahKLeEs22oMrD9d44JSgf8sVQ0Ul2QsT+kb+yEMaYS726qtuBaVLELuWg3lpAy4zH3OnxtvQSR2wbsG9a74s5HZEhUFRW1omMw0aeVcnCr2bfAr1qolzr+xDPKpGK2XItMnyAJbtG+Tp91jnI807W5IcfdvWIBezs5Bj3rb6VOps126FXuPUOeAWvQEufE3tlX8iIDvMlxONUd9UgTG3dn/SWGZH2pETw03pImYOwvDNo7iRyBAXapHQ1xNanm1QNji+E6/wXf6GfeghSmLp7X7VLyPntzvcI7ZHqv6A0tcyLSqL8+9x5S2ZUe9SXVwjwXSTx2t8sNBMJNfpdlWgnwh4TGTo2JZV0KAwHj1tBtzJyeQyBv34nGx+drNxDUp8o5o/FbI2GYaybm0mS/o7NiedXvdZMOSqOe7iHoib1YLoq0vBrC/mQe1T2xeiTQ42N9Xa140vzRL5ZO5PkU6nG3urvesa6niCvj1i7qxDtAjzyVBHzSOQE1jgBQjm1EF6oJLrGtXlenB9KeC/XQxlK5mt8XVdsC/zfet/j1f2wI/GZg3123MtftFK07qI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199021)(6916009)(4326008)(41300700001)(316002)(8676002)(478600001)(66556008)(66476007)(38100700002)(66946007)(54906003)(186003)(5660300002)(2616005)(86362001)(36756003)(6486002)(83380400001)(6666004)(2906002)(6512007)(6506007)(1076003)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8zycUDWL6ptrbSW39Zj6hSHRNQdWwyI0gwrGQ/N9SrXDWUDVAr+VsqzbiQ/x?=
 =?us-ascii?Q?uyGEBWg3GTKQFdj3HpxUgciDuAYTmButEGiZ3gQ+AJYAzB6Nay1LcmXjrCVg?=
 =?us-ascii?Q?vUZov4FUIY2c7JU0Y4IFC9PNYVWnEFbZnHTQVbo9Lsmfuj3FsNJyD4S2twkX?=
 =?us-ascii?Q?F7U0zlKJlQLG/lG+KqEoHLS812A94fdMh6yOfxYYnDp2ieAaP/n8z9Wz1FqI?=
 =?us-ascii?Q?wonxcSVJ+3uu7y8/C8BrJHfIauT9IKRaio+c9rhQzZLZvMzJzQvgXh/ZW//2?=
 =?us-ascii?Q?vFz4aJ+r07rSTfqG5/KeFwHkuOu6alWa16IQ55BO3Wws2/FuMiXlAWfEyEye?=
 =?us-ascii?Q?+zjlR9tbigKgJWdAVP1VmbQW47t3EW2H4w96dkGPDPJrqGBGC1e1NaWgkI9F?=
 =?us-ascii?Q?9LqXc4R8Oraw/Dd/h3uqUtFk8nhT11iSjUJXVY/uGJZnc5FOPqBIfTS6HbHN?=
 =?us-ascii?Q?DJM3FXmtZE4EFzdMpnoFtNPj3yuVY0Kr0Ytfd9NUR4YVcAt53Omabxt4t4hG?=
 =?us-ascii?Q?q7WcLXGSE9nE9shX1YA4gbX58rzY7E+fjF2Q0xCFsfHb4m8tW3dMFmcXg5g8?=
 =?us-ascii?Q?2RW6B+R093Sx+uc7Y9SxjhfnEb/d/okKiYTB+yvGNhXS0KGfXA0W2sL/S8Z5?=
 =?us-ascii?Q?K2HPiWKAab46LARPzrx1qK0UCslSHZJGBKLW9tynMmTnbwAma8DVZ/qFtdoI?=
 =?us-ascii?Q?kKZICpuMfwQY481v7fvkpj8lgdtzVRe+6AERRY+PJtDiXZOjxKGGBIoSAbz5?=
 =?us-ascii?Q?NZionxXy8srdu2mIHbCncs8QcEJ9HOu25RoKqyKPYLYxeKdDlLoAiRpMOtWC?=
 =?us-ascii?Q?kIulzHKRV126LuGXWLWhvvG05aMikHZwvzVcX6UIWkKb+T7OX3OP1h8wqa3E?=
 =?us-ascii?Q?GjbqRwPxuJSeEwqdQoOJauFni2eZB05GBjlEiB/5hpg8xBv9QrCE+Fn+f+01?=
 =?us-ascii?Q?2szO9LU2jzLJA4+GTTO27yreAL+FXyyvzGs/9lNBwsOVVI00Zd9mKE6MMRos?=
 =?us-ascii?Q?BTIAxnEsfi0kbRyx4dUxMf+u8cr1DVOo5NH6dlGx/yyKcJsaFbSh4IjE/BmX?=
 =?us-ascii?Q?eGWF5FSfDj/tnAMsgKIuH/4broPzvf9E6LW7qZbelSBCP3MYV8nwcNlu00fq?=
 =?us-ascii?Q?XkAPPUqerqThqaAw/jh2ALhiRHV5YW0xEbVcc2iynsy5uOzqgGYvlzsX2OMb?=
 =?us-ascii?Q?OnU8Nh/Uym/20HUkwWDy8df5lCP/rNImikgwr8s6t8uEUN6c6VpR3ebRxZac?=
 =?us-ascii?Q?4TC5pk/Y07i4fmpxFsVOEKu1uRyQy33CE8KW+kfLP8XjhMxB4M+QFR6b44qy?=
 =?us-ascii?Q?+YSzCKHKDSfH8Ox1i610SLK/nlQz+Id585iYLPSMonmj9XxhlFwNExnri0Mn?=
 =?us-ascii?Q?PnGyLu/OlKG2FwYOVlyfJxioJP5tJpml5AqcbwG2s1uzoo0wsjK3ySKZBhFD?=
 =?us-ascii?Q?i10kTHr5nYZxeoewT+Bw2DKZ4AJNXF4+Vl0oUe5lNKUTID6fMv4qkbgOkY94?=
 =?us-ascii?Q?+NDmwrFhFD7rsZtOVSuz11hfjRHjaBtnUFPvp3+QPI9hn49HdzeubiH6vljl?=
 =?us-ascii?Q?Ty6KOF/Zbzt6yld0HHhwHLvLS3IRG9j4C9f1Q8Ee?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e5ff3a-758c-4715-68ad-08db30bdb57d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 01:25:55.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMNA96RRZysJkFhOpZh8uscmsAqBf8wCPS+ESQU0CMoJNJSg5nVkBxBjElz5t60rtL8RZB3q9nbb2/LG8xz7aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7882
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

This can lead to threads locking or waiting on a folio with a zero
refcount. Whilst mmap_lock prevents the pages getting freed via
munmap() they may still be freed by a migration. This leads to
warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
when the refcount drops to zero.

Fix this by trying to take a reference on the folio before locking
it. The code already checks the PTE under the PTL and aborts if the
entry is no longer there. It is also possible the folio has been
unmapped, freed and re-allocated allowing a reference to be taken on
an unrelated folio. This case is also detected by the PTE check and
the folio is unlocked without further changes.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Cc: stable@vger.kernel.org

---

Changes for v2:

 - Rebased to Linus master
 - Reworded commit message
 - Switched to using folios (thanks Matthew!)
 - Added Reviewed-by's
---
 mm/memory.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index f456f3b5049c..01a23ad48a04 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3563,8 +3563,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a reference to lock the folio because we don't hold
+	 * the PTL so a racing thread can remove the device-exclusive
+	 * entry and unmap it. If the folio is free the entry must
+	 * have been removed already. If it happens to have already
+	 * been re-allocated after being freed all we do is lock and
+	 * unlock it.
+	 */
+	if (!folio_try_get(folio))
+		return 0;
+
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
+		folio_put(folio);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3577,6 +3590,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	folio_put(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
-- 
2.39.2

