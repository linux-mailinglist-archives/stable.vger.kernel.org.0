Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F272F6DE8D3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 03:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDLBZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 21:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDLBZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 21:25:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D48C3594
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 18:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5VVNCcGhbmHqYT0kGc8BUblQcffHHh+JiXyJGomCh9FVHri6FNFnKUnVLv+qM7tiXMNwW/sHtMLW3kYJr1itnRdQE1D2lcoxycjZo9QAEOPDskLaAOestnALsG8Fdc3X+hkf1s7HMulTDhaknV0SI9vxqrzNuoCXJJafs0aj+835ijbanKEHh7T6NmxuzNgDBSQUrdHA8MpXIJwi7bRXj9IBE9vC4Mbp+l63ev4r9ihPtqRFmMjhOAyp2Y1T++BzdwRpuoUDf4Fe3yiw8rvGjpkKSzLpgDOu/m6n5pOXE/zHLbwSBBzE/Bc7i2LXt/+OVwekmWmnWiFBVAD8eOObg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMkwoP156VG2zyOltBL3nK83txKdTlq46b8wF4Uno8w=;
 b=cl30emiyuLOy2OS0n4ztsX2HeRX7pcZJJRzLFNCJW1K63NHbKB7aMmGORlr5zLYfAXsCp/O1NoRC31KPjtatdxrlLh2Mf4oyjnItOCkypcNOBNr3Je/r2MrONf5Gjf689uCa1D73UXx44GeOf2tqUNep+mR6QS5mt738MRRvTXzu3zNEScP4yG3UvrJ7QPeBE1j9TkyWIcfeTDYTOstDzTCxkZjW8smHgqiWQCt2ahWlBQT0tRArnFat0b95bo7++J5XWp6SARyrCJBWsuJmrIO+Q750aEBuS4uz0wo5hIUSChU7RNJ1Gsx/IHgFEC2273zYfa3Mxy6HgwTYdnP1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMkwoP156VG2zyOltBL3nK83txKdTlq46b8wF4Uno8w=;
 b=N7U94g/yp5xWR7oyxErnZ7VyzFB4Wx+DzvLuKFf4K5fgdBB+EMqtupquLW1PMeutx0coc7AfcehLGNxE7I3Bjy3roQZ7jEO+J8WhnFJXSCUZhC02o/CShzjyJ/ICfcit7Cbb8xHZzsEGjQIGwBwNIKkLATZLVO7De+upv3XkZfQDA1Kn+Ita0/7XlD8S51WNbCDW+K1rHQryk4MxQRExPSjVx+FRMrbXtlqi+dXWogiPSXhGqDA+UNwAbMAY8C7PFR4wEvHZnh++i1SBcUH9SitovLYfQjNjJ0uB5k06Z1nrFW2IX6VXj+RrAd2Z+awDRFsDRTgl4sqW2VbA3DCvbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MN0PR12MB5884.namprd12.prod.outlook.com (2603:10b6:208:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 01:24:59 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f9e4:206e:75c3:eaa7%6]) with mapi id 15.20.6277.031; Wed, 12 Apr 2023
 01:24:59 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     stable@vger.kernel.org
Cc:     Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1.y] mm: take a page reference when removing device exclusive entries
Date:   Wed, 12 Apr 2023 11:24:50 +1000
Message-Id: <20230412012450.242813-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <2023041155-spiny-taking-d67f@gregkh>
References: <2023041155-spiny-taking-d67f@gregkh>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0098.namprd05.prod.outlook.com
 (2603:10b6:a03:334::13) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MN0PR12MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: e77bcdb9-a573-4e4f-61a9-08db3af4bb67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+afWkZusttY9QBzOkM/VI0f4sdmdw8b/wT5srtNZEpzag4yx95o+rDkm27mW72iB4eZojIy3pM3HC4AnFj1Cv3Kxh3IpRs4BjDlpUnNgZnRnaRP7HpyjLwqj1CVgc6plANd7uZIE/RB5HpLMJ9P8C142kK0hRK46JczGXqvmTi/+u/8mBP00y1ZfggRjqK+9EeETQpNK/DxEZU4fIW4oUopVlNDsACUIvp4haI5tieWsyFVbYmOd5VqpdnJ2Hpu6nytcvelvWDQ3DQLBcx8BHVQgjS9ppnApnDn3gdyjdew+Sy13n1y9KKXGjhCqsXJ5w+9OlSNfTVVKK2r/oDt/RC49MKi0apWxrEHvzG9ocUlTymP/d6GKaH7O0MRB9VYXnGk1lK5APynDqapZ25I7bfobbcK/Yq45Gny6OKcbl+sDmvoyxSo26mVS3tNRXXdTYnZBaOMDocJwOWdFV9Str+nO8CBbFy/NUbe6uYBzxBQrQhVwec+RRfI6dN8ooN3V1C2dkqXS4CPtYGVMr3fv0kYYpp9O9FamE31U0C8PRXnc5TgEMhZxBSh3GSPygOOr4uYF+a0PKUK72PZIIEIqZxJAqHOmXhDxoX/u05IvOA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199021)(478600001)(36756003)(83380400001)(38100700002)(86362001)(2616005)(316002)(2906002)(6506007)(1076003)(6512007)(26005)(186003)(5660300002)(966005)(54906003)(6486002)(66556008)(41300700001)(6666004)(66476007)(6916009)(8676002)(8936002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fS8uzTx0WPA00GO/ZXqUFyCeMT05SKZ/ezNPVcJTsXlRrpvwXZD3KGlH8JaV?=
 =?us-ascii?Q?3WH5nM4Srcu1trDetPD4U/SxGEl/aP5tqASO28ePOj4kwgH2DMawco2EAn9D?=
 =?us-ascii?Q?/4PJeRATcnQnl5y/NdX3FYBYolx+KszVlVEtUXejEl1GlMDdcNYxQnGrrP+I?=
 =?us-ascii?Q?x5V6o9/MvuAYz+P1Ju5Ogi4FgRYGO5te7tyY5FIXILGl+Hj1iLGww/X3ECxD?=
 =?us-ascii?Q?KSt/gEx67CpRFuqaN1cHUJaPcxu47EGRhhz2VP40RAWRT9RjHDiQD5vJnNKN?=
 =?us-ascii?Q?Ota5R+ADBAf3/2aak68prNQsaUsnoacX9cMmoB8215OBmJPTS5bnL0gQXfsK?=
 =?us-ascii?Q?9kZqYmqcubDLPhCpkrYArp4yFFn/en7+mWVnVnHlzxCIOs6z5NwdsjUN12rN?=
 =?us-ascii?Q?HqUHL+dL1j8ycTa/2Mze3Ps9tigadC2m7iiS92MldjiVdr/b6XhgAxOD3mDB?=
 =?us-ascii?Q?6O1Ar80UENVfaMPknnf3HULKQGuhMRDnddLEsp8988hCTMLRW17vfe0QWDby?=
 =?us-ascii?Q?Dudswr9Lwj66TcIfQAtZZ9yK7pNo6uILtWyz7odFurI1Y6K78cBxgFImrL/R?=
 =?us-ascii?Q?QzT3c8hPxT0rNr4UrVM4INGjnq7mMgqYFA94xJu6S+VMFk3aQNgIWqfJDwKE?=
 =?us-ascii?Q?GTtTxVYF46pgl3WrTdiDtNxlRhfeY1Q/wT1RZ7W/3FupFXYy3UygL5X3OtQC?=
 =?us-ascii?Q?lZ9IdBRxeSzkDYvGMtxGQ/dMbY+O6DwtF+TEsKWDDYNJsOWRSNDfO1xIXJBc?=
 =?us-ascii?Q?9djeAiKKwr1n4D0aYo3G1h5WGJpaEIG+YgtqZtuCqEFcWceNuhoFnrec+C7B?=
 =?us-ascii?Q?7db38tu94GG4tWKYgMlRBeDNb8zp1PujhyJnPrRqEuJIYvCsHZaHLMSTU0X/?=
 =?us-ascii?Q?v4DQx2cqEM0MhdIYIjV+R1EmpHbxKyXvpxiuicclUd2Ofu/YKcIMgLetLdyp?=
 =?us-ascii?Q?/A9nWktgL1xd3xJXbhMSA/yCpP6o8eozRpq6ZcOCLTV6f4LuzLDXmpVRMLf2?=
 =?us-ascii?Q?EEZPBFyHSEPeGZ/lV41k37txeMPsqg1njroDtW1ZxkjYrNfFjxYcNDBl0b7F?=
 =?us-ascii?Q?a2EPH5C5Mvg4RnGAP8YuC+UgqWXA7jigrwTO4gmZWKTgt1jE7e7BmEjmpkoW?=
 =?us-ascii?Q?aTPGAfm3aM8+A9fCxuWvFy2HiI3K6C4axZlweXNfusk4LIaBO67luIpCDrKy?=
 =?us-ascii?Q?6o9VsAeh4PhaP7M3CQUFpSSJTtwuU9cjV3bT8BpLAeBhHdlMC2nCsmLUz+pr?=
 =?us-ascii?Q?EFf9JRVe7XUkh5DJAP8xB5tM5KQbbDLVC9LPJvrA03DYOU5LtAznLYVaX35+?=
 =?us-ascii?Q?9Lw6g+yJKsdytIauHgOF1ECzJapBQA9ssJDinEbk2NatoFayUMsWWC9PXISf?=
 =?us-ascii?Q?v5TgIBgRXDohCyXIAFKQhwT6WtK+f5nmbIrtlfhnuE7lXWF+4RXjK/CRJjhY?=
 =?us-ascii?Q?vnnRDrRCnMU7qj1kpMYps/cyu7cD19kaCXBk8RyzpzyU1OMpxch1aL9nKJzY?=
 =?us-ascii?Q?l32OjO/3jB7HC+59y+7pKJ2WVRUS1253wXgbEYd+V4TcTnHFgWyLobxt6HyU?=
 =?us-ascii?Q?NGKnnf9ng4M4kK32zXd3NBfN6wABFrOvsm2O2rBP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77bcdb9-a573-4e4f-61a9-08db3af4bb67
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 01:24:59.5532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBG6Stu4yubl3lLVc2Oa0E+8oi3+1IihQjehA6v2mphpiaQ1Jd2k1O+13gchvp2T4L9kzxQK7ZU5bQXhP+7HGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5884
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
index f6f93e5b6b02..747b7ea30f89 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3619,8 +3619,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
@@ -3633,6 +3646,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	folio_put(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
-- 
2.39.2

