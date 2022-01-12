Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6868A48C49F
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353468AbiALNRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 08:17:31 -0500
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:1344
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353461AbiALNR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 08:17:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYWWC2YRWo+kkKTptcmalqZo07vBMbbklssOQ4uxJNL8MiZ+tH7XsCEMm3HlKUBu2kc5tAy5WdJTvNVRvs1/KWYldeSwsw3iwL8Lz2B6xt7ITuTI2KhOp+rfmhKE78V7ZFT9D8te3e1GsCT2SuGSzCJuYrf4SyCtWb5RPKdxsKkXBVvX7j0v3neTOOI1uURGYZAPJfgE07sh5iocbLaGd3OwbfZnEisPoGth+hBiq7EBmNekkOADGVg9uBBvfjaz6AOiKZc2H3TK1GMTq5ECCvuWfBEhvmznINkvqq2z7fb/w6b2uujbGARLqx/ejUdrvzw1HR3unbneCaZE4CVctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/propddTSYB2GVpDx93GkLZkuiZGv/WwMQEuQU5iXz0=;
 b=WXEeIn/ZqL3Z8ROFt0g5owdo/HLPpw1M4RHn+WARF1jak1TdIUK5m6EVdxonmkk9pyxcutnvvrsCVitiCuinxNBtuQP/tTxqJQ8vW2qMntduNb808K3CJnXQm6jmwClhXZwDx9+BHST8o1YoiK0XSiSDMJ3sjq1cXuRgx9/fPXfN4t92wzCfwffMVHPSjRguZkVlEN6UJgZhc7/ynY8AE0Y44pVo3gdmiuorLKeRXZ/yil0BHlwn8W8RuzE+6asErlqpFSoKJvYqVvEnsHuG68ViQkjSLs7xeC2WtIImV2vxsZEh6Y228bfenxx8cJ1wLjlGHodoY6mppvLQT9ZqfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/propddTSYB2GVpDx93GkLZkuiZGv/WwMQEuQU5iXz0=;
 b=Ejbq9ULa5BbnmCL54BfRCHjpZvgP4kC1EEzRWeZbVjN0YHfTThp3AvhRE51MfL1ptTA2iVvLFvu3QKtJQ3Xjl2lxXR4DcCXSp3Z1nh7Y+Xey5X8tOxvFeSA0KQEtCC5TzUAwylTaw1PlzEBsowIzpsMKBjdRRELR8Y4H1LrzAuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
 by VE1PR04MB6383.eurprd04.prod.outlook.com (2603:10a6:803:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 13:17:27 +0000
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10]) by AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10%8]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 13:17:27 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, jason.hui.liu@nxp.com, leoyang.li@nxp.com,
        abel.vesa@nxp.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v2 1/2] mm: cma: fix allocation may fail sometimes
Date:   Wed, 12 Jan 2022 21:15:51 +0800
Message-Id: <20220112131552.3329380-2-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112131552.3329380-1-aisheng.dong@nxp.com>
References: <20220112131552.3329380-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 368ad0ee-8bc6-4fb7-b125-08d9d5cde0e5
X-MS-TrafficTypeDiagnostic: VE1PR04MB6383:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB6383C5293B70D8351A3E120580529@VE1PR04MB6383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JidDj4N2lxYbJzdnpQkXqvamXztB0IArZgy82HRKLjsyAJCaBpYfYoJcvn1BrE6mvfSBCTj1PdwLgsvHCkNxgAzFPx2bcu18qwsxSwyIckTUqzcIUcccrR5szmDXj5E7UfhEeY4+dTT+KxLZ/RAAnaqYKZeNS/iAFfowkeyPQ9ciH2jVMZMJrnPlPMcL5Cvr2z1K3Dh8P2T9agzildAjng8tfMXa2IbBpEDFHIuuLL2skquVf9Y66pONh3tyKhIBWt3sxUfWzoOuFM5ryNqW9EF2d5/evV5jpMu2uEJT0MmmvzlO3Azb48kDnmIjjTV2XctwGt3yF3SlVeYWuBEK184rOn7EC0OyJaS2ittZAbI0sNL1aiKZbg+kNoIS9YWfgbfH8UipmFcYuibAidlAHCILvxapPiOG9EvXCMj2wyUdDCRGXrhAkmN1pYTqP1kMwtr7GUiIL6ytTCUN8X7RBEhWCf5FvSYeUwEoRzsP80ffWY6AvkyjZV7xKuGDMtVRS41tVFwwM062VjsoOrej+q5n0oiUhnR0eP3RZJ7lY4zWvF4aBpYc95z+Gn11q6m+a1+k7L1SHOaF8IaBuBH35H73FJg/asguh6ZedbUZEYVEezUr0w82MRwfsz6iPIBN1dxZUdcpKVjrTNpnXvlC+PD9GMiUhJFXaufg6qtwXiMzQxG12vJ0FXklPnOU0RsVYr8PNPcRc289OvqpPL83DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8466.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(83380400001)(316002)(1076003)(52116002)(508600001)(66946007)(66556008)(66476007)(6512007)(186003)(4326008)(26005)(6506007)(5660300002)(6916009)(8936002)(2616005)(2906002)(8676002)(6666004)(6486002)(86362001)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rewOFXvIOvOfnfBc39wjyBfrCus/cKCx9SHTSBqAMBg/99O2uQrngWDSS1fm?=
 =?us-ascii?Q?gHfsWp2IlzaHilvbEhuPRCMQlHj4ERg4fs2i3HCnF2ebjcOOhKqg8Cp7kH6r?=
 =?us-ascii?Q?fKVyc9dHQr9C71Dz1mOqYgQJ1XkzKZVSyFtyz4Bz5ONSqrFK1bygI9osnt4w?=
 =?us-ascii?Q?wZwuRAyFG6p9oNt4rUpYfxH++q+4P+vOT42Znk6mQCQ0N+aAeO1jPu1tnIwA?=
 =?us-ascii?Q?oxVChqm3BGo9NaaMeeFBkss3azQpAAe6Xkt1vmaRLc3vMIWH1Mrz42aUgiLE?=
 =?us-ascii?Q?5yRpGey4HtYMgbYxkLssMPcN50ROhUnd5DZqT1wXQB4u4UFEE4FEeG0syfAG?=
 =?us-ascii?Q?6dv1lqY8W7lqNOaIMepwMjKCpCKQmz4zi61rYnRE4b0nevIlrwY/DG/miBD5?=
 =?us-ascii?Q?k0wxsOVWM5CykUUPIY0q7LQwA8nO0hLg04ra4yNqhN60tq61zGLvshe5jTHn?=
 =?us-ascii?Q?TwTAtonegCFCCz3jgSujRRNgBhKpQLE7UhfIi2rE4piorRNyLzeYNowbsnSE?=
 =?us-ascii?Q?XbxTQH8b2opcubLlHVKqqsl7XySNVK+U0fcpeetXAcpG965IFWLh6iJO+nxk?=
 =?us-ascii?Q?tw1t/bTHM6eec2MPx+fu3aSJpQmtxovCr+qKu+MwKO0riB/3DWsM5RKwcDhe?=
 =?us-ascii?Q?7GAkFo9dmEqq2m1vdcwjGADq3GAwqtdbAgU7BSkmE5fm4fgwk+Y3BFxWKVkT?=
 =?us-ascii?Q?1//WuynHJ1lO9J/I3rd1L7PDYFTm1OJXh442nNWBUokbAjJPBFO01msL8N1s?=
 =?us-ascii?Q?+RGnnu5uySSpqt+Z5XwakBdVpqqEqQgiJwz6B5dAUFlMudYMlkLWTqhNZgj/?=
 =?us-ascii?Q?16iUSlrCtKXxciNirQPbpU58fYxsuD3FGTUXbo8Smj/VFLUdeLizVGusg+Oj?=
 =?us-ascii?Q?pzaXv4uP48ClvOcrzoAPRRl7Jbafdv9Cr7kbwsnSUkXTS0uAtHwhvoer+ewo?=
 =?us-ascii?Q?nNOz2zFUw+HwDiVN323KG/AaQCJiEwcxdMlUa1hZtP5vewHv9L/pD1pWNzGq?=
 =?us-ascii?Q?MW2r75eMvhg8W/kkkuzdKxCW8HAEOhK6HdG6MY2HFk4W/z8+DC2LlSzFMVKv?=
 =?us-ascii?Q?vqDSMNE+hHPY9xNKH6F+X+KKIEjqFHTtgFDGYET2v5jc4NO2Hkfomuj9gioD?=
 =?us-ascii?Q?Pzl5tmvu+56q4VxtmQvFL7kSlolkvOA0q89jpQ7tKyYpKR1MiVefsG0n/3am?=
 =?us-ascii?Q?UjVfNbXZPk4GvBqXHeZ44hrpvGv1BO2wWU9OvCkPhUrZ3RagIPf4fi3Jmc80?=
 =?us-ascii?Q?SOw2xKkJSOIZci6nfSGEPZ4oAL+/5oHv+t5EEs1Wc3w7tFxYbaHVEXq236WH?=
 =?us-ascii?Q?8c+1RVZAA5BStYB+2bKWNUq2nLA3Ya0Ge6AaZ0fR9ka2CTlybksdpklxFTx7?=
 =?us-ascii?Q?/Qthh9h6uv3F8GaqTBXtMfTJXuZC3Yi3Z1Sr+VNN1CGmtvlSKPjX8yimohE4?=
 =?us-ascii?Q?0z4Y3dFsMh890XCRLDxdIyUyoSGc5n3mWCMZmg5cUDgZZ2BG0TqAbvMdrULf?=
 =?us-ascii?Q?KJotgccGfuWqCxFiBeVkatcFD4p7IyAOlxjOVwEv//nX2vQOyewl47cVjF6U?=
 =?us-ascii?Q?ocJbUWwqkzJL6mPQ4FLodBHPxQkLP2RhaEz5Y0+nbtXWWgup9IWa9epLuZFX?=
 =?us-ascii?Q?O12OW+W9eW8QYIR5+nW9raY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368ad0ee-8bc6-4fb7-b125-08d9d5cde0e5
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8466.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 13:17:27.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3oCdZLPh1YQ4lcrjB+Il1HaMAFxIFSHWCf2d1fs3uuY3eXQUJo4XfUTIW242U1awkg+uMTEGDcJvw1/dMCPtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6383
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We met dma_alloc_coherent() fail sometimes when doing 8 VPU decoder
test in parallel on a MX6Q SDB board.

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
memory allocation. It's possible that the pageblock process A try to alloc
has already been isolated by the allocation of process B during memory
migration.

When there're multi process allocating CMA memory in parallel, it's
likely that other the remain pageblocks may have also been isolated,
then CMA alloc fail finally during the first round of scanning of the
whole available CMA bitmap.

This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
error in case the target pageblock may has been temporarily isolated
by others and released later.

Theoretically, this issue can be easily reproduced on ARMv7 platforms
with big MAX_ORDER/pageblock
e.g. 1G RAM(320M reserved CMA) and 32M pageblock ARM platform:
Page block order: 13
Pages per block:  8192

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
 * v1->v2: no changes
---
 mm/cma.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index bc9ca8f3c487..1c13a729d274 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -433,6 +433,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	unsigned long i;
 	struct page *page = NULL;
 	int ret = -ENOMEM;
+	int loop = 0;
 
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
@@ -460,6 +461,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
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

