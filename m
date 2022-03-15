Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBCA4D9DFE
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 15:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiCOOpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 10:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349398AbiCOOo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 10:44:58 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00078.outbound.protection.outlook.com [40.107.0.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0DF64C4;
        Tue, 15 Mar 2022 07:43:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5FFNQuW/gbrx9qFZ8RV75mCCc47VsLZB7llWOjbPDEm1le0oZ14Ar3hexOTjxFvaBNxgTXA2Gc/ssZwP0J4X2gqfOuYOmuYpq+4EmuCzgPV8z/f2oCsWMjvml0Fo4SHQ+tBWU2RcHq4KaRffkbxOR6jdcsqd9Q0UAhOl94giPdP/QvW//Eqf6xg7euGBtFqSth6hhMsJR08jSL5uBbb/0egeZ7XYAmfNCsK8YH0gvt0Kbn95VRK/vnZBi3PJHdvexxYm3D5FajdbYZ5m0fMqhIvoM+hgeZ805o6UJKocSQzDVOt4pnovt0wCaNmNkP2u3rdXN6tqLxvtEJx1IOh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mF6Bgp3L5rKpQa74lnxQEwNgjqflRId4Re63fK+mNk=;
 b=caGOWnTeF0BeD9fd7iQ5Vm/o23IY1gBwTFVsbMjlafOMywrkAHu0WDKnW3o0oSix/LG54DAcdl/Q/Jc8GKSVJNbGtLl/Iq1IOq8C3fHY9KZDEtkyNc2D61Mviwi8crDT1hGWgMsqQN/7Nh9yh/AJYy0W4JmDDICb6xglj8k9axeraaIqT2clAljqNkxPOyGDyiaRM7ylah0exjIBLd3ZxS5hH+uQvzJPb5Hz4Z032JQuFsSnZJs8YOqLVrBJPfu1fpF/Wz1LitYucjWtECYyh0iE6z7Sb6SKQRCUEWNOWunHwVaNVovDFsunhFgk0cjbDDq9kzQ7YFZ/eUN9mVakZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mF6Bgp3L5rKpQa74lnxQEwNgjqflRId4Re63fK+mNk=;
 b=N4/CaKyBYRPPkQeHswWLJ5DrI6fY/P3EhwW3XPH4BI7upagqnzPx4cyGn+dqAHNJ88qwR0KRglyQd7NlnYvA8JVpVmLHCfzKISK0/AS96Rbuu7VsW3drhmhYBzU4ew6DRGezAFjgfRpU9kQUlBDM7e5wL748AgZ6qEvNhLrS6os=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Tue, 15 Mar
 2022 14:43:43 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 14:43:43 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
Date:   Tue, 15 Mar 2022 22:45:20 +0800
Message-Id: <20220315144521.3810298-2-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315144521.3810298-1-aisheng.dong@nxp.com>
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To DB9PR04MB8477.eurprd04.prod.outlook.com
 (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4adc1f6e-867f-4efe-4681-08da06923387
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281DE8074D539696F64B4A080109@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPW5Fx2mOB0xXqYulUzRgaMdHimteV0S3TL4vUxiA2vsusY6C2ZApr1rN1M3G7EKvz70fF+w5sff7YAGfbSaT0WaH15KYxXtW/sIX3VJsexjwyXWBqR0Fl2tf4Pvg+PxFXmmb4jBFxm/9xlgYZDghwu+rlxGZWnyTnhBkcHq9oo3IREgFtNuZlQmKYzzVeQgZ45XRJlZjZQPfOkjq7IX3cgzhLn5n6apmpk+97zlTzmQjG4HYRVBTJNqR/TpzsWPbW9jVcPUdz7a6FFnaZpPVeCmQJkOXTtDtb3P4uT6srRh+pUyPej+GXkcXekRGLe7sg6nPAPSLknyiuxwRY6Re7FberDW/Lu5FHaYpy3NDTInFpG4NveE/IvhElTKpaErlDNJyZQuYej/XGuZL+D8dMg+OXuKmgV3ACvOwhphzC3lnYFQv6bl9S6igqOHoZe3RwllLM0li+jqCvZ3WNtWXV/BuHVDw0xCVCvKId/nH+zjB/gaKjNazK0tn92DZFh5f6EfCBGzgvsovkTxKmQWN/hAod5lprXMDbJwewZpdgbuKjJc1U6xnAPsdL7I1T5bRlXo2Liy/IeaeSYCxUdz1RtvJWEPSI7O9Wmwopvw8Q9Erquz5KzE+HZJ2X5lNhzaeu6wtV0NyiDEroqVgBaqu9JTbI50fPNaso2hPDak97THE3/b+n+qWSyqhpC50tC62xi6izMtIVWw44zpkJpV3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6512007)(6486002)(2616005)(26005)(186003)(508600001)(6666004)(6506007)(52116002)(38100700002)(38350700002)(83380400001)(86362001)(316002)(66556008)(2906002)(6916009)(8936002)(4326008)(66476007)(66946007)(8676002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48B2KY0tLa3PRIpiMeTswaaCKnxaosNoBcJ+dVN+Q7g8lFuPPBtp4F4t9t+Q?=
 =?us-ascii?Q?lCnAhVWn+N9R5NBfcMzdpqr0qINxN5ehgfXlnfx4mtT4insV9emHieBp+DdW?=
 =?us-ascii?Q?XaVxZ1vBsYY4E63tpmNVHsgdTtMHYesVPwqOdQaLKZvx5ofqkyK21q69kYTs?=
 =?us-ascii?Q?DnM5wpuVm5QNGPcbR83Y1a/B6N7F4RU0nSQ0nU9ygDHnBOdtRVx7jhc9zw5L?=
 =?us-ascii?Q?hydW2Hm1/NjWuZ9XkE66CeFz/yqM7vDFtuKKNiBIAyVDV1LeoAt98ZLMkXAv?=
 =?us-ascii?Q?cAIPcUdC8OG3ah+wma74hPFgACVxyj3BDCTd3cvDt335LIYeVDP8LhQIAsDu?=
 =?us-ascii?Q?MBHHXUQQKLZVigA94In8NZdo+66Nck7NScJ0zQUowLqfCoTTs3sXRGrIzhbR?=
 =?us-ascii?Q?FxXfkvd/sxuAO9KnGQhmI4s0bVxX9p35s3UUGrIGyP/aUmtFNfcIrDAisEW/?=
 =?us-ascii?Q?OOG9KnxW7ePxhSAV+psZ3Ejuu+HL21ATMy2sTbBL12DxRu9kGWV6n07xuLrr?=
 =?us-ascii?Q?yBGSqLsj/J6oXhezcIO0fXYF1tmwCj6PGQbuI57Os09ONagvCiQCUi5hqG3Z?=
 =?us-ascii?Q?shRm/iHlr+h4alsG0Gn/4XwMC9tuWstLE0Wr6Vb7AmgwwsxI6Tw63iYPxLtg?=
 =?us-ascii?Q?r8fBf0PzhVlwM7YW4PmQAQGpu0En57sXYnuMKmlb2XrwLUrao960lZCBEzvz?=
 =?us-ascii?Q?4kfgMvGXp/TgXg8XPjE+FYQ7zkkX/cm+sZlWJur9SSfnjo87c90qXLr3k9tD?=
 =?us-ascii?Q?7+mNiJUlqOW+5y3Xn1XdiWXDNofmzLhUz+z9UpbgjhkuybtW8vnyHMF5v27V?=
 =?us-ascii?Q?OR/dPGDcbVL9S7DliG7eUHeRRY5TZz8wg07zXpquWyTqK3I62ledNHTTmXzw?=
 =?us-ascii?Q?OYbOsiQlK8TvVSo98/Ts0V/Lnj54pDe0AjnJhCqZG7ZDjPByyeFMZ/eoAVBT?=
 =?us-ascii?Q?jsewOvaZ5NUt08dvg7Xk9oFvOg3eQbsSZcMtJTToRi0/oNSlGot3BB4RnJya?=
 =?us-ascii?Q?QjvcFi0hzpgFNZfD8dh6qx4U7WOQPsu6jC/3YxgyhIzpg06ZLaMIPBVW81wT?=
 =?us-ascii?Q?HlyrQRaocFpsntHyVF2gg9ZlTagGGJLa++BDZfGOMd326JYfK45AVuHUUn28?=
 =?us-ascii?Q?vhx62DZ4v4Dbt1jbsufyCiTUISaaN2v+hWeCfl5hq42VyfMQuPsuf2OA37AO?=
 =?us-ascii?Q?uMxDou5IcIMoOUgBs+CuXeJAnlgZQTW9fJQjMmZMOI8EIOu9MeVGoh3e/GGk?=
 =?us-ascii?Q?zm2Z3wzR0PyJ/14MPj2vOdettjw/VKfRM1LmUvk25cMtH+nI3jTD96PWJE0D?=
 =?us-ascii?Q?VjIgTqLAS+koTd4cKdAqHcm12oH+O6sm1bI1yymnEcvdWCHJwJPA6LFILyU+?=
 =?us-ascii?Q?J82kin68PTcp9JyE1B8PxFbyuP4h7/U+IJG5gQx7ApEncHgnJHh3FlyTBK34?=
 =?us-ascii?Q?TTCf7qKdWCnCfIRZSV0FjhJAu4+KU7bYx96nSD51PfqC0YFey/NOyw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adc1f6e-867f-4efe-4681-08da06923387
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 14:43:43.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Smcucb1YRcFgyjWl+LVIVzzeZ4GYtMYZbWIsnMJRlxks83oH/UJg04zAxobW3NwTuBVdBLYFRhcgMfABOdE9Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When there're multiple process allocing dma memory in parallel
by calling dma_alloc_coherent(), it may fail sometimes as follows:

Error log:
cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
cma: number of available pages:
3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages

When issue happened, we saw there were still 33161 pages (129M) free CMA
memory and a lot available free slots for 148 pages in CMA bitmap that we
want to allocate.

If dumping memory info, we found that there was also ~342M normal memory,
but only 1352K CMA memory left in buddy system while a lot of pageblocks
were isolated.

Memory info log:
Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
	    active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
	    unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
	    bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
	36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
	8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB

The root cause of this issue is that since commit a4efc174b382
("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
memory allocation. It's possible that the memory range process A trying
to alloc has already been isolated by the allocation of process B during
memory migration.

The problem here is that the memory range isolated during one allocation
by start_isolate_page_range() could be much bigger than the real size we
want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.

Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
is big (e.g. 32M with max_order 14) and CMA memory is relatively small
(e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
all CMA memory may have already been isolated by other processes when
one trying to allocate memory using dma_alloc_coherent().
Since current CMA code will only scan one time of whole available CMA
memory, then dma_alloc_coherent() may easy fail due to contention with
other processes.

This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
error in case the target memory range may has been temporarily isolated
by others and released later.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
CC: stable@vger.kernel.org # 5.11+
Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
ChangeLog:
 * v2->v3: Improve commit messages
 * v1->v2: no changes
---
 mm/cma.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index eaa4b5c920a2..46a9fd9f92c4 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -430,6 +430,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	unsigned long i;
 	struct page *page = NULL;
 	int ret = -ENOMEM;
+	int loop = 0;
 
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
@@ -457,6 +458,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 				offset);
 		if (bitmap_no >= bitmap_maxno) {
 			spin_unlock_irq(&cma->lock);
+			pr_debug("%s(): alloc fail, retry loop %d\n", __func__, loop++);
+			/*
+			 * rescan as others may finish the memory migration
+			 * and quit if no available CMA memory found finally
+			 */
+			if (start) {
+				schedule();
+				start = 0;
+				continue;
+			}
 			break;
 		}
 		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
-- 
2.25.1

