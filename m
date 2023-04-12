Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3639C6DE8C6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjDLBS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 21:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDLBS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 21:18:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CBFE41
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 18:18:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6/6sBfUXnw4kKxH9bWm9osUJkzvT2J0AALvqjgLmxaf2JGdtOEOodoAksI2Ujz7CxOvz4oXLyXsxpEmcWz/a1MebiD+/Zw7ASArMOUJ4h/ZFVJ4rsS2YIJZMVVxXhrE1n+9jtgECR5OGm/5sZVy5t+wpdTD9CYxW6tF4f4Tu98Wyb5FFrwoNWAiaKwc5TYUixqSA4ZwYKLf8PjUsIVwUtTrsHxCFbldJAtAYtcoOWSHleuNpYlAz3WLyukvBgXlIzjKw7EZ4XQRSdY7wPSmbYC1Xgodcn2lt3XnIbsoNkvzeMKd3Z9RzbN5EBL2ApFMpNquFByUsjjAmeD3pRozkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7R6Uo7XJd8r+s85TruOcOe7BfKxeutFxcVPc+bB1RI=;
 b=kBkQ4HndzR4IxYGNZsazwqkaYrAkCcIubNhys9Dx+0TOVfAae31qpgz5Gb/gOXi+ripn/BQxMFyI9eA/+41Pr2KP7zS/IWggKZghReuBlLS7w96qbrEzHmXjuheJMfpVBVKcMVfq6WV9f7MLfl34+VRYABLyzETcvI0Vxiv2v7LpBz4U/h7LUN6ZOHlA0K8el4NC7y/YFA+rFCazMHFqsHOm7NtVB41Tf2kfVKHx7XKssI3gAZj4ppTmZxjITnPHGLRuYToTWIsPqmtoj0wspnSUwVA/EsLzPA2GU1IqkvT5TXuGap6TiHuGmRH6LSqJjaEQ/MIFiZjE7xh9LxVoyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7R6Uo7XJd8r+s85TruOcOe7BfKxeutFxcVPc+bB1RI=;
 b=Z7oyAxAAdYyVkL5R+0R/lVr3YIHRx/rLkFc3+5wI08IVu3QWCimX6W5R2zTlHmiHsPsxaXY1Q5sqU38pru7SYLxjGCW7I7sEJDTAYF4UsppXK/IT0lDTgNQaFi6bY+2StpWmEYIwwMyCWMK7YUnxMsTErhqHcFF+sJGmvPmp5NRglpruU/YUJfLiO3g+CD72j/SAEeqfxcAF099zCkwtSNZSqBWIvvuj6uz5ExOHEpvj/rGQhNAgQUcwvHsBgcwK2ZhuSvQa8/Gfo8rnIOux8F1viwJs5HJbRnnglLGucSj8HtZ953NTM5EEQSAt1cNgNDn3RsYDAC3AeIhigJCWEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM6PR12MB4976.namprd12.prod.outlook.com (2603:10b6:5:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 01:18:53 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7%6]) with mapi id 15.20.6277.031; Wed, 12 Apr 2023
 01:18:53 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     stable@vger.kernel.org
Cc:     Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2.y] mm: take a page reference when removing device exclusive entries
Date:   Wed, 12 Apr 2023 11:18:31 +1000
Message-Id: <20230412011831.152625-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023041153-unlikable-steam-cf2b@gregkh>
References: <2023041153-unlikable-steam-cf2b@gregkh>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::31) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM6PR12MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: a4fe5e97-60ac-459f-8f9c-08db3af3e106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmT6sAq7o07SOyfBVngp6bFgBKM8SpUDvj7jweo9l7JSnTmZBV1CZ1v2LJPGYcBZkYV7vfx6L6TpHm7hCkEY81Hrr8+nv5jw0NLC7Z8bTEV/IZwHKQOQLxyZp4gY1+A+yPo6FIQO8CqkcyJNbcjAwCbkYfBMphdW/hqKQbQSs88344VGpFht5fN1IR2Jh6YH7/RT4p/R0f9BFUi3CKBYYHm4COau1WUq5EdpPn/5+Z67UvSgdyUKtxD79RJNXCb+RMFDvoFnVJy8JCZHIGI16xN9lO+pUPVMU9lHqw2us8u95Q0q0uiQQ9Fzc5RDl59KtgIDnVHSwnThn5D2X72y//QGx1X5Yg8oKVUzHbNB1xLse6/xU0f9iSAK+PUzh3rM4yT7hs7IQw6V8wX3omU37S0754As5erh4jsQ0TZ3z5YnrIgwdmB6rbA2WCe9MxFSNHAb/QnPaitvjtI3plb386LAvxN/AhfCWyLWf8iBiBQb4F94dnj5v5VdEYDm8Nnd1kDgo+PzC5ys+1T9XQSVkp5FVzoEPtkmWgylB8j4hPkbxu6wmJ7SpZgs/T+/GdB5pICakEye0Lo2ro7zUjM2TQxuDQ8LNsy3z5F3HQWvN6M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(26005)(8676002)(8936002)(186003)(38100700002)(6512007)(6506007)(1076003)(316002)(966005)(478600001)(54906003)(86362001)(66946007)(66556008)(66476007)(6916009)(4326008)(36756003)(6486002)(6666004)(41300700001)(2616005)(83380400001)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zIpVe+3HZc2iF6WD27f1qHP1VGJ0kFgkJpkQ6iyTiljYvjSCH8EblW7WjlD4?=
 =?us-ascii?Q?CM53mxB8g/I+dcZrwr2ZbPNW2EbL3A8AMs/aF4UwsZ4PRdXvBUaIQFPfhUbo?=
 =?us-ascii?Q?u7B+GdvoUF+3CxoYsaWkS7k4cZ8rhJQDArDYscV8wH8uyl0ysT/y3cU15jj/?=
 =?us-ascii?Q?iw/RImSX+35ZyNzT3rlIfju6RMUPyvGEViMJtIWBRkm0gE2G7WPEOhie5ORG?=
 =?us-ascii?Q?YdRXVEGfxKNTbnx7RG/sjTSJQzbv7XbgQdtZpmZ6jICF94SFqdvDtH+yHC7S?=
 =?us-ascii?Q?c2vFH1PcvuWjZf20xtq/eBizg+N8LRo8qNpjuU/F1XMfqa7EmqGluGDTuAOM?=
 =?us-ascii?Q?01FL3caj+wuu9BE907PptL4/buteQ8HaOTtJY9AoYiHip7C00IkkvM9GyO+Z?=
 =?us-ascii?Q?ZfPf4ZIMXcrY+TC0P3yTdRWDOU4uJzkz+elWXVBR0feNieXyu+7B437CTb3n?=
 =?us-ascii?Q?f20WOs+TgOUQHEAk/5Epl1AuDB9z3FlzZfxRoYzXWzhioKjgnsr0FLi7YuRJ?=
 =?us-ascii?Q?pyg/hs8KtLey6UI7jXeJ3tkZeVwgQZUUl+iec9AV7BmylQyJ9dDtZHeCVbuC?=
 =?us-ascii?Q?2BVuJLrcsxAkFSJhYc00slzU6WlhPJETjH0NjeEvo7Nh2M0nOSupHpvW6BmA?=
 =?us-ascii?Q?1nUXvtJsJg67O7Lbo76hT0GR45SQcdnBO2xhO756lJhiaxtHQOGzXyuJ9ONK?=
 =?us-ascii?Q?6aw1zXryD2wu9IlHDgi0tj+c4Ky2qbrm/bxMHOGTM3c1LTYkS7Z3roFaLFPv?=
 =?us-ascii?Q?OgJ2Y0Bis7rhjpKQK+wCOOlolRcf1H4+CZv0CuSQey7wq1clrdYlTAcEKSdn?=
 =?us-ascii?Q?I1X6FhHUTs2AH01+MC/XGVKGAYRGYLx0W71IGou5yzR0WWho/0CqXa8pzB3Y?=
 =?us-ascii?Q?Airw8MM6WzjMh1S9K2brxnzhgPeozc6KT5wjTvhQW6Odg36tBLX3LeR5eb+M?=
 =?us-ascii?Q?MS2SUJdH/70P3MGvers0jRx3MyUgswLnW5roDlJ+uGQL1nC6i0ALDpT5Ab2t?=
 =?us-ascii?Q?LyCPGPF7+Ne4GhEeHcYa403EvLj8RWo0ZX89uMGigfXZfkUzOXPRo1vbveDl?=
 =?us-ascii?Q?7NXzEB/PQXHxSS/1LvtWThLzGC3osL+j2T1IgVUpfvp13awV3Pox1DB9U9IX?=
 =?us-ascii?Q?YZ8YWe3yYf9EmZz22JEnqhzD75EYwzDyto52pmK6B06LDDnalj/5aBgMz6PZ?=
 =?us-ascii?Q?M8Lr4r4DiKDfoFzBGnhN74xMf2wZ9SGLZT6x4xj+gJ8g8bqnZyzONLkQdbz5?=
 =?us-ascii?Q?nefNz9Yju5SGXYPBaIfgHaX2OzzhJPFI73xL6tLpksx25yWtXDjL6tLWq1IT?=
 =?us-ascii?Q?3oso24QA/yh/qX7YPFS78vZdprCzZBRXk2JNGaCpJE0kcms6gAzdugFOXPi7?=
 =?us-ascii?Q?XNsxd785qN2WuNAKgbAZhEafVVAmMJLJiMSKiYuA2RAnc/RfRuuDbjXFKQRN?=
 =?us-ascii?Q?1vPCimBPm/eFbRbejIMhD5CxggCxApoMYRv31kDlvd+KFnHRI7juFdiZxYEn?=
 =?us-ascii?Q?jcvWJnKdsCcZKccfL2nichW3GTCtyDWahc84yP4dJlOCcM0ZCIE5y4kt8BzN?=
 =?us-ascii?Q?vlFKC/2GLZdzgQpN/LGS23OvknohZlZVmkPdriC4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fe5e97-60ac-459f-8f9c-08db3af3e106
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 01:18:53.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kvjJ/bfMpNgd1WmUkLXZ0bEwoEa2PLH94ZIxj/QxjqOPaV7lsoBHxTbAbh6LyUSWUdtbNFSpS+wIIQ5YeFD4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4976
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
index f526b9152bef..6a99e9dc07e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3580,8 +3580,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3594,6 +3607,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	folio_put(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
-- 
2.39.2

