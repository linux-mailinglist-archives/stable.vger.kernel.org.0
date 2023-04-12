Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24276DE90D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 03:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDLBma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 21:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDLBm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 21:42:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1517444A3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 18:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwmAU6qbWb7JCAHgJJ/XMgYUZx2oFnnpMgcw9aEAJzM11pw0r+wMnBxk3kbVf9/b1yPpcnvrqIB/T9pF+7KzHxYnbyl8rhog9NRgS9tyyMXT1hjbwtfZWBUKbD1Nr6eBSaxoLmRRqWvv+ZSIHNxQZ+FTot+JR6Db2pSAJpTjqe368/pXHvOlz8VRVh+PO1uPXNSJtYXRLihskLq/zg4gbvTl31P93+7b0JigEpydQgyhL35c9KxpTN0yhXqRfQdAcdm0tvXgjuaG/E2xEhma3nZHGrmMQGRySUz8/qbj7c/Y33B+s5tDvTywxfdnL8h7zWd18E1rkfL8UTEm6PRkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6I3olPdxhXAJXqF479tVNo1zFbDPdLgLhviaJyyK1Y=;
 b=ZpbyYcO7updc7Nkr+WMITppaF3eq9zrZy8UCVQNJmjQsbJt5b4q3mPtGqihJkoped2xzFvKP1BppRPbaYaSrLOcJFdrxurRk3h139qFtqik4MmwBJixbhhY/lSJKPz2wDlqg62c66AWPzOwHTu9CoRu2VRpD9DEnmardQ1ipdKzUJgLSZZefQkKKmd+NCjL9SKGESQXHEzHXBe0B+owM59B8tVZmqgTrvOBptUbwvSFMnZ/jifIuvVpfe9xRaEJBs/dZUrag438jUcPthdYQb/pHk5wBzG60lnCpDVIawF/X7zDjRCuGB88gJ3zl3/8G+4FhPWywBnIlLldadFV7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6I3olPdxhXAJXqF479tVNo1zFbDPdLgLhviaJyyK1Y=;
 b=OSLifnCw3DHEQuIxcOI+ocfRVFVU6LROIibWKtI9xGiLvb7SoQI27K02uD+Njbxpm8hQ6TjQXwikJlByjdhZft09hT84jP1Is6BXJPM/ssTgnvqRT57c8LZOnz4xAOMXjwxBL7uXTjBYPtyCetl4daooy4HJeGUHUs3AeXNgZo7FOIOTOQfihCvSVO2EAoswdFYlnpHeyWSUe52Z0KRl63t/5bYs20SYDWw+c8xHsK8/IMXWWLT7S1+5dXRk/dJtnD/8L/oP2XImc7B/kCDM/HXdJ9+kIfWJoAkCT26BD29AIb/CK2n8iylPIeK4FvafglYQ8BxwR21bbCxFeSV8Og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SJ1PR12MB6361.namprd12.prod.outlook.com (2603:10b6:a03:455::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 12 Apr
 2023 01:42:26 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7%6]) with mapi id 15.20.6277.031; Wed, 12 Apr 2023
 01:42:25 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     stable@vger.kernel.org
Cc:     Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15.y] mm: take a page reference when removing device exclusive entries
Date:   Wed, 12 Apr 2023 11:42:07 +1000
Message-Id: <20230412014207.325071-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023041157-hyperlink-prognosis-e6db@gregkh>
References: <2023041157-hyperlink-prognosis-e6db@gregkh>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:a03:60::24) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SJ1PR12MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: 9647b72f-305f-4f9c-c51a-08db3af72b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CtgM4jVLs47lPJWIx+xSa0q01JB7T03XvKMAJnCx2W2fL7F3YZc3bJHvj9m8m9wBdmJD+3Kddne/1r+BX8dG7dO/x1yABQFcuNmxBIHJPeQ9yLm3U+SXG9aAh67wDkLqCfVarQw8avhNSitcRsHW6z5z7SXHwxf2JQwzCwTQVMcI0FuamLCbqSMCMv44F1WRBc262XDQqGH9pdf9BW8FNA4r2CtCJmcxO/H1UBwZpnS37pBqq776dNlzQDFhDgjYRSOGIp38+5PWPulG2RyvVQJ3/ZBY1RheixdJ2P6+XLcHc06YG4k/gJdOiZuF4mDC153ObuPuUeTFzJBE8q50ZCntWZfoSeHP0gI8sOScKHkxB0BHTUKzs9YUbNQO6NhPqrpMSgAZAINDVovFHCFOCwfH7dWrlGWtsRdVUuNluSNj3cvPQKPdcUlkbDbytmw+y11DhWmMDhRUf7O8oTLyH6QAMyjJo7xHMtdNqYamF4Q8JoN2lgrN8iXE3qbo3TTV8LI0gnNdJtCeL6zsbKistq+L3hnvhikps/w3/1iOzDaH1QUoT0smaaG9QeRmnH6fGKqcmCilPCqw7m5LnptOsM4BWbpvWWD7VnHGWf/Hvc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199021)(41300700001)(54906003)(4326008)(8936002)(86362001)(38100700002)(6916009)(316002)(5660300002)(66946007)(66556008)(8676002)(66476007)(2906002)(478600001)(6486002)(83380400001)(966005)(2616005)(186003)(6512007)(6666004)(6506007)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/iiz4+fKfhRqTUDZ8MsJ6CVHO78LX2udjJV98P/YQMkdj60pxmxgXjSFFvOa?=
 =?us-ascii?Q?rqW/7l1YAuAwh3rXCj0ueXZir1BKgoA7v2lWshaS6JafuhVz7SZiFsHK0327?=
 =?us-ascii?Q?yYd2t5m3qz8a9KEk58uLo1UUAPT9DYukde32aeqHs3mx6QbT0Zj3cNNFmzGE?=
 =?us-ascii?Q?Q3Z+R0KY9pHcp6L+4l94Tae6ojFSn9e9fivjMRGXgBcShG5lJVN5HefFDn9s?=
 =?us-ascii?Q?WcI/KMmQp80TMHogYibmcJWmR1bhhNMPUnvD6vJTQUuTOgASAcjUIU2P9brH?=
 =?us-ascii?Q?ZXmOEPPHe880PJEHodnEXFotyocf9cDTXHUQvuC9KvjPOJXPj+xjtOTYyAMf?=
 =?us-ascii?Q?6ixWHk/S8KJ3mkcAJQ5E8VmkSjsn95QV8XykaTP8EWCzMqpolCFN7QP4AGon?=
 =?us-ascii?Q?kALUG29JsoWlehvj+auyCzJ+4GYVdKE84q8qeoNpka+JfQgHNKzXcJYeppwh?=
 =?us-ascii?Q?NTi5Ptse+zSzs/Y/UbclaH/Amkz6Vc6v96IWk3c/k9WJ5Te9tLSF5pih9BHj?=
 =?us-ascii?Q?M0W0ApE/pPQXRw1+ykfx6q0240oVGAtm68wz1DfnLCCkP2Dm2vc7wFZ+8mtw?=
 =?us-ascii?Q?HgjHgPZjs151gvGVhCgFmkXZhSl04GejDh3wuvIRyVqxqPR/R7Ocj2rWv3hZ?=
 =?us-ascii?Q?Sbnkmsx07ny5EH+ChT/d7jQrm1ZBTKdieW4mFp3W2UUiILAFyWsY6xuEAWMd?=
 =?us-ascii?Q?86DpzS5XVZzOysm34/OlTgOKQbIzF2kN3q8XlENcpXRwVldoaw0KHXeZk1DU?=
 =?us-ascii?Q?i8Ir8+2teZ4kfi8MJ6R4/KZ8niy3IX6YvdW1e2C1lkWYakBJF5vTaiGD38FP?=
 =?us-ascii?Q?fjcr3k1W8JyJGcXjK/IXM3f4p5wRAs+XKZ+5Yh2pkXbyhb+Wx4suYrtFTTml?=
 =?us-ascii?Q?gtZHwMYZp/tEQLhFK0f5mqF2aPNHnckRqEvrM5DaX2BRpMwB0/BW6TsvkFN7?=
 =?us-ascii?Q?65eDkr6x+lWJtcdN5vYhXqLt/oDNhsCBaLTEy3ZMsBmDEwtL2e/GorvALTJ3?=
 =?us-ascii?Q?f3IBDhyufuqZpI24A0h/Swhivjixl92eD531XBuGdSl16Sk6NXRoCrLvboDQ?=
 =?us-ascii?Q?fzkq331g43+qVwigEdcS2o5eO75bkDIHjz9JDM3YyaoYRQVbAstq8JeVLtr3?=
 =?us-ascii?Q?hPhOndJJo5rUq90wyhBA9NilYY4Hi4cBICyttyAB8rNtAgSy4D9Eb18WFgTc?=
 =?us-ascii?Q?7087HAg5tZvfn4WF6Y8Zj/UaKRxTaOOF9dot08FWDJZAr2hMHvy7Jh8u/gyw?=
 =?us-ascii?Q?LcCS+QvZ52zXpWstnvxZSIung9tyes1KB5uCr1hrc6kIn/dAHt3cFaKC81vL?=
 =?us-ascii?Q?RoTqwpsWOBkLTGB12KLuNpvyMDqh0P1HLoSLIJbuApnTZ33666zrT9kWzj19?=
 =?us-ascii?Q?jikxYzjaQVDCTkJjKXgQuJX72/Sm6A+VKSnfsya/q/eB5cZ5lJa9IFGVgtS7?=
 =?us-ascii?Q?lZQuuiG3+95Yn3MZJPDrmM6wC2q2PDU6pqGzGgOaDk2m+PaAgsA2J0L5TYj7?=
 =?us-ascii?Q?sZjG1DbJKTfwXARgA7kAwdD4dgbugZA8AvoHjeCLa38pxedtzxT/Hcj+uBeX?=
 =?us-ascii?Q?bycbjK38iVi1dYej2XPOFRm5Zwk/t0TxAJLZ7tLZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9647b72f-305f-4f9c-c51a-08db3af72b08
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 01:42:25.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVxwj/N9kQxcSJD90s8X76AGBYoREP+iOlKjO5n+bFY7axyUio5t8WxJ7D+dK8xHFH1U7NOvLYK/Hp7i5FP8cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6361
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Device exclusive page table entries are used to prevent CPU access to a
page whilst it is being accessed from a device.  Typically this is used to
implement atomic operations when the underlying bus does not support
atomic access.  When a CPU thread encounters a device exclusive entry it
locks the page and restores the original entry after calling mmu notifiers
to signal drivers that exclusive access is no longer available.

The device exclusive entry holds a reference to the page making it safe to
access the struct page whilst the entry is present.  However the fault
handling code does not hold the PTL when taking the page lock.  This means
if there are multiple threads faulting concurrently on the device
exclusive entry one will remove the entry whilst others will wait on the
page lock without holding a reference.

This can lead to threads locking or waiting on a folio with a zero
refcount.  Whilst mmap_lock prevents the pages getting freed via munmap()
they may still be freed by a migration.  This leads to warnings such as
PAGE_FLAGS_CHECK_AT_FREE due to the page being locked when the refcount
drops to zero.

Fix this by trying to take a reference on the folio before locking it.
The code already checks the PTE under the PTL and aborts if the entry is
no longer there.  It is also possible the folio has been unmapped, freed
and re-allocated allowing a reference to be taken on an unrelated folio.
This case is also detected by the PTE check and the folio is unlocked
without further changes.

Link: https://lkml.kernel.org/r/20230330012519.804116-1-apopple@nvidia.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 7c7b962938ddda6a9cd095de557ee5250706ea88)
---
 mm/memory.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index a4d0f744a458..8d71a82462dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3462,8 +3462,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a reference to lock the page because we don't hold
+	 * the PTL so a racing thread can remove the device-exclusive
+	 * entry and unmap it. If the page is free the entry must
+	 * have been removed already. If it happens to have already
+	 * been re-allocated after being freed all we do is lock and
+	 * unlock it.
+	 */
+	if (!get_page_unless_zero(page))
+		return 0;
+
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+		put_page(page);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3476,6 +3489,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	unlock_page(page);
+	put_page(page);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
-- 
2.39.2

