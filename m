Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F23159F1D1
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 05:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiHXDFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 23:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiHXDE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 23:04:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D098001A;
        Tue, 23 Aug 2022 20:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvrhnmJ6FNTPQbCslVVU2j/0iw+JUFf4gWQsVHCsNQeTH/xTGO6qf98I+pryxoKxx9eYoKoXX6q98HMaDAu1mPa6l2GVzpaNk5wVzGwp3y+1rZvIq3LaG6YCY3k/3sPdAFUDBfONdnl/O7oCHRbmprGWfos9lC7PVXeaawOOJ/mQVIksAceZdygeDVotA+sR5StVhMqptamoz/EiDd8qZ0dxiF1NbAzh8lKHGJ5e8ysfwoMGxX9VCSdo7YIq+0wwmjYy+GfMHWhZp01gPimfSjI6zqv3iId51fXLLIMwwk8zhZlx0HlUQoidUrONFFOJgXA28MXdubDf0yw0KENz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbxR+OCYU2G/04rFdWWgpbEcYTHFk46Ar6Hr4DZBQf4=;
 b=H1YQUgvxNBOG2c82Ai3GhdJk/c5GtrLEOO1d/sfqW1PA1BYpWa9IVYjVSJtprJUwNxNxySEvp5HzSWZBvBJWlKek/2i0NQu61eZnI55PnhIgC1DVSAFy+t4bxBAAAqdmKjYRqEKVw0ue36Fq2Y6VTso8wR5kJkI9dlHafG6eJAmBgQgFzGdtCpPv5nma8Fc/0n1AcwMYfGi+9EpGXij3NA1FGkGCy4gLKEvq1BxGBpsmmDMVAsG0LOihlul4VdjmyzJfXeLVwa5gAcFbWxMWwSTC1EZ3DRb/42IdNcnI2VjFO0e/yNJDMH8RjsFk72tDqV6kGzJcQxVsO3HCJzkp2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbxR+OCYU2G/04rFdWWgpbEcYTHFk46Ar6Hr4DZBQf4=;
 b=gEvu/Dl56U9nMwHvmxxVdo3BXjnlGBXHhgWiGa5FuV1/7jym1emr8qFAt4Cxnbn8YL2eL2SgAoNTI0w9cZt9DzjyhYOzfh1c7aoJezhidx4GcSrzMU966GyN1a+PUi1sYONxcuCWyT8Cr1Aqf+cGVoAOs0LQEdEY7IVu1HwIrZTBShHzTwgwbOC0KQECMnR+E0g9b2oqo6ydMUez9lwY9gm7USCJCQMGWC0PSJuRMsCaZjDQXqZ+jdCeiSDcJXhN84J2V+L3ytPVIhDFX4/+XDu+ee0NcOKb9QW4/q7NStg/DmHKxJv/G4Ufs8EBbtBbktilTEKJcELX3lx4A660RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.23; Wed, 24 Aug
 2022 03:03:47 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 03:03:47 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Wed, 24 Aug 2022 13:03:38 +1000
Message-Id: <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::7) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ccdb7f2-72f7-4c0f-301f-08da857d430a
X-MS-TrafficTypeDiagnostic: LV2PR12MB5774:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZWgOnCDZpyEhnPPQeuL5XCEWKrcOcEDEARbMQf1CvtZmwmGm6FsIODMTt43Zwln2zXSyZSjQoOrrV9uMKuEq8/ZXSa4kFi+Is94GaVBuMKUUkAYFQrmoxkfJofuW8cHkWQndF+MjZFEuWNHEN1pMxo/C6VzWR3TZVFgL+7yTu3240YvzzyvP2g4LwMs2nC7tWCSUb7J+Uh4dIzIWxsXedCJJSkk9aoQBr8OFiy7lv9BR1XAtG2liEsACb906j5TMuGpukat60DYfAFCnaECWcBBF8i+B6XsPvIyKXbW8XnucW2ioij0oOMGwXz7Icrrq7evsBzlNR+KaoCHygL+/VwhX624sL52HO6rttT1db6pZmghoawWNRxxAnoRgN0tcV2zK5GFtwZkHzXvWKsNkWzaJTxILknFb4cgkKvPxEbkkPrF7HYl/ljrBPKmFUay4TGV6esjpuk5SHuuj+M5A44fuAn9bwWPXjPHNYa7/ac9viIba4SEtI628ASSTNywWG0znSOgc934A6Efe5F28zi16qgM6HZWpqDzw5tizvy2QPuUMe0seJVIZEzbrfWR9+Bkp+/cc2CLwnzCObd6NPR9uGC2gfaGetiyPc7CFLB6+ix1gDx+6cBBLft0StyCyhuqxl5eVw3GPJ7wlLew96mvYkjV9c6WaRS+oHGjpmWmzJdU/lG6SDguDbKNe3X2LowREvYqiZuMgX3y3z1yv8Kkt/VXu+tu+jNHCbFaFoE/YgaoEJHhmhNIieaVKurJYDbPHpkZffSN07WTYDql0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(83380400001)(478600001)(66556008)(66476007)(66946007)(2616005)(4326008)(186003)(8676002)(36756003)(8936002)(41300700001)(6666004)(6512007)(2906002)(6486002)(6506007)(26005)(86362001)(7416002)(5660300002)(316002)(54906003)(38100700002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wl5KCcNKEwPWlwnqBs30F+D+TJEqdhGP0ITdzW9wpSEWDmrmxmqabXJwq64T?=
 =?us-ascii?Q?O3zD7nVVfydBb84+qJYmNtLyHqipykVykAN+JBwaRZpAl8unYubB2R4Rvjef?=
 =?us-ascii?Q?MWCjkvmZ/EoFp6Bk3aN2+YzWAshnCabpGtLWnlaKVW6VINAf1bq8txXwgO4C?=
 =?us-ascii?Q?ZUdLYec14Vy+R4spe6bf7Apc8cNbR+BbUiHGGFh5SaxxqkI9COqibH45jL7Y?=
 =?us-ascii?Q?XSl9ZnsyYVgiYssFgWz9JoSHHo+s5yl/Zwea0HECuN3V+nZViOC70lhitW9b?=
 =?us-ascii?Q?VCfmxTQoX94Vnyk+pnq+yDzvrnDMeJKpifTqml6mcbVB+tIFJPDORFbGVzUq?=
 =?us-ascii?Q?PrGBfdyLurK7Z2fVxC2aP/cNeVG4STxA4HQQ6fvKRICgSICG3nUWE8tuHsX7?=
 =?us-ascii?Q?2HOE5QNzCxD9q195FdRbLyfgNs++DxEfQth1VHWKCwDazCUOZt1r0g2kzIdD?=
 =?us-ascii?Q?qJx227LroLX5QP9vk5L7dmqapfrD+nhHU5WiOQOYhS0vgVKXeL9fyY3t/D30?=
 =?us-ascii?Q?R5u4QhfdllbEactyEXCfPHyTQqN831gFzJF98DUCAfqqZ0Gz3O5clPnKikw8?=
 =?us-ascii?Q?1e2P1SE3mP7ovvvKJzVKLXKSCOf0NTX8hbrGBXS8TkpoZwvHbbQZRQdYGx7m?=
 =?us-ascii?Q?y06jbY9SKOBgISYPOgzh/m02O3LP90ixWxASj3dKGL2E3J8hbLoBWMMiidyG?=
 =?us-ascii?Q?K6S9RX46Yu+S8UAWAOCu0LdgZhm8uRl5xtjG/nuq7HLQj0HtFnR7jslM/aae?=
 =?us-ascii?Q?aRChccZGPhHi/3MLlaFRYYBZyvOFmZH3xcNWHPpezhaA+/MBEMN9J699/TAG?=
 =?us-ascii?Q?bzZ3iuieuD+jv776IQvhEyiij5uu4Wmk+0AsiTIUN0rE59V2ptLmeV6+IvZQ?=
 =?us-ascii?Q?agBy+XE97mNFHRbmvqP1am9CTR87Lu7q44YG4ahPZ/V8DO6DJj+9weLDKeVP?=
 =?us-ascii?Q?n4wFpodsygzcPG091X1DJLk4SXJIuPdI4fky6bAxt7WUxRf/JO+f2YDi71E+?=
 =?us-ascii?Q?nff07rLthww7yJuS5dJFBiWMt87AS9oj23Kj9HKpBl6YaX18f5Kqr0EXbBKI?=
 =?us-ascii?Q?J01FHEHcnbvXXtIIYuACaOk8WneaKSlAEDw0bpNaWS+2ezf8hbhtTR7nTW6J?=
 =?us-ascii?Q?azcbP/ubO4p53nxVHeQ8VbRgzFPdMrQlbJnqAgx1qGhlvpmkU+iiGO7qm80N?=
 =?us-ascii?Q?PRXemqO+Al5eA3NEmSFfxzBp2goXKy4FJ89C02pDB2O4y3UEktdpN+xXAnLm?=
 =?us-ascii?Q?C6kwa9UP+TChf8pSWIjTcu+JvWfnEpMhUayzLH5WFJP3s8D7F3/6qD0dJBZ2?=
 =?us-ascii?Q?9cF61KIkrudk8g1Wx6yQ59reIu9sTTaqr9ZQPJUanRBzHsww6c8i8Lou41Sy?=
 =?us-ascii?Q?kzGs2wILg34iAZbXVW91ZHblcSPeFWcuoAknyQFQl5cBgl+WWXii1fN7v5r+?=
 =?us-ascii?Q?r6HiJ7Dz1bQ8K5HcJK5tc9Pg8UIWoJ3LC8tHTmWELxLy5koUsKBDwzxwnCUy?=
 =?us-ascii?Q?HCqyFOLuW8WHthi9j+3cWC5coODKXAyjRNK4C76UuZQ65msJqwYA5j9PlHAM?=
 =?us-ascii?Q?TGJyGkkc16NymwDBJBFVZAIRg8vGLTlTNXSmkpcL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccdb7f2-72f7-4c0f-301f-08da857d430a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 03:03:47.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csHTlJV/69iQt7MWQfo2oXOdJiWyqOC1jq7AUPl2m8IBwdiGEyWbAD0duRtfn0ZF0hhkAcxbe/6hLa1oylXdAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
installs migration entries directly if it can lock the migrating page.
When removing a dirty pte the dirty bit is supposed to be carried over
to the underlying page to prevent it being lost.

Currently migrate_vma_*() can only be used for private anonymous
mappings. That means loss of the dirty bit usually doesn't result in
data loss because these pages are typically not file-backed. However
pages may be backed by swap storage which can result in data loss if an
attempt is made to migrate a dirty page that doesn't yet have the
PageDirty flag set.

In this case migration will fail due to unexpected references but the
dirty pte bit will be lost. If the page is subsequently reclaimed data
won't be written back to swap storage as it is considered uptodate,
resulting in data loss if the page is subsequently accessed.

Prevent this by copying the dirty bit to the page when removing the pte
to match what try_to_migrate_one() does.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reported-by: Huang Ying <ying.huang@intel.com>
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Cc: stable@vger.kernel.org

---

Changes for v3:

 - Defer TLB flushing
 - Split a TLB flushing fix into a separate change.

Changes for v2:

 - Fixed up Reported-by tag.
 - Added Peter's Acked-by.
 - Atomically read and clear the pte to prevent the dirty bit getting
   set after reading it.
 - Added fixes tag
---
 mm/migrate_device.c |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 6a5ef9f..51d9afa 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/oom.h>
@@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
 				flush_cache_page(vma, addr, pte_pfn(*ptep));
-				ptep_clear_flush(vma, addr, ptep);
+				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
@@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					goto next;
 				}
 			} else {
-				ptep_get_and_clear(mm, addr, ptep);
+				pte = ptep_get_and_clear(mm, addr, ptep);
 			}
 
 			migrate->cpages++;
 
+			/* Set the dirty flag on the folio now the pte is gone. */
+			if (pte_dirty(pte))
+				folio_mark_dirty(page_folio(page));
+
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(
-- 
git-series 0.9.1
