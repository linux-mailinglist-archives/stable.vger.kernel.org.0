Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4F47540B
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 09:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbhLOIEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 03:04:00 -0500
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:28641
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240711AbhLOID7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 03:03:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeIMLMncErScwTeKvkjDItPfzvpPj1DD1tVFEB1/dyxMBJQ2Hy0zsnEkOC7VtxxZRStPEXvjA+yIamxMRt+FZshlXjMbl4Od7m4COndJsIFk0qUMFw4H0U1c2tfs2GJj2r5ZCsj0VMKGSQTXFxX05ao2TIi3KciZQSWAE8GSB/u5qIWggomlKhshRcfRsjib00gmSXlKUgk4YnqCYxbXFsRlP8Zba4c0ZK/VHhLBRcpzUpBnT0srC8NjKqYRre26BZMhu4B5qRK4L6Ua9cbFDxzm455k/N1Mp7RPESemgtZZsthRIFsaA4yA8qQmy0auE+7JYqFaFg2Od1qLznhc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdeX/TdGNcL+TO3ShgoWOuwV7afZZfePb5JR3c+GLGU=;
 b=XY2luz2lKBSagjTZdprrZ7SwBiuPP7p63UPhDP7DO8+hSkIHM2JvPVTtsjkg9QxiIzXV8Ng7ENs0WDeBET0cuAyTxh2AKeoPensB9TQdxoo72GGXqgkXbKU/JYgrG+BU62xdHTaIf/mCifDxxyjYK68Z42vzYxA+89Qhl8ZEewSvpaDKSvDmLYxZcH2bBavgclVz6eodONHz2cwgOGkG6qENVzGlRiv5zq5IVRDStx1Xh6k6Ei0FUljayCh30YRoy2RjOwdSeDkF2OXKMs4W/emeXYk6Sf5lh9bnaDouO5DH3UtfdNvVXMbSZpT79Ml9HihQqalInlzW/+3WtsLpbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdeX/TdGNcL+TO3ShgoWOuwV7afZZfePb5JR3c+GLGU=;
 b=Tu2LtmHJcS7NMH7MlGs4rA7zQhU3LU6xxgBu5xQqV9nEAAsKe/0PXDvqwhQkKXxEWYJujMQiT9rrq7s39mrVXg2+B+ev6yy1hoK/BJ0sBfZNMNlN/YlZX1ss/gznwuk1V7uWsL8+YOd9qGWQF9K6s4FKv8DmBEIrogfHZ2QsGr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DB9PR04MB9355.eurprd04.prod.outlook.com (2603:10a6:10:36b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 08:03:57 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::872:b248:c9e1:151c%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 08:03:57 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, dongas86@gmail.com,
        linux-arm-kernel@lists.infradead.org, jason.hui.liu@nxp.com,
        leoyang.li@nxp.com, abel.vesa@nxp.com, shawnguo@kernel.org,
        linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org,
        shijie.qin@nxp.com, Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH 1/2] mm: cma: fix allocation may fail sometimes
Date:   Wed, 15 Dec 2021 16:02:41 +0800
Message-Id: <20211215080242.3034856-2-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215080242.3034856-1-aisheng.dong@nxp.com>
References: <20211215080242.3034856-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d9ec65-4e56-4452-dd4d-08d9bfa171b7
X-MS-TrafficTypeDiagnostic: DB9PR04MB9355:EE_
X-Microsoft-Antispam-PRVS: <DB9PR04MB93557EBB39790C5F43BEB8B880769@DB9PR04MB9355.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fb3/wc1KocUwZLS11FaE0Nrm89xppNZ+c/+dl4okZbwe399x1YQ/T5kSweWGvxbjmJ81kEvU3pzdD1rtXlYLr2hqKg1hTxJTx71lmi42iF3SbkOMT2nKrpkgv+vvJvfrmuWu4VdOAK9FPB4F5fL+WLHkWTIPGPmLkyRztdN1PMfOhKct2d0fYO8GuB9A45v/d2Xt2ercIaX4L9pBbVO6JH5Z8rwloAu/MT7nCx2kmOuY4uZMZp5omuLg5pxqyYzXKZtrELLZiy9xeOpLYYmMwiSeJvs+McigmQspusEfuaUcfvD0s8usMfq6DLb0JtFhToNdHj3ixf7uThdm9irtZSRxpz8cbPzb0ok4SDdCpc24Uy8xRHJxXdOwFIfxAbbG1ebm+H623iLlCWNPokKwjhiPV7vCnP5mgXz/390ICzpo8mQqLil2z8/ZLGMVkx7yn6SaZcpXf3E2/Sv9keMhF3St4OrylnVAU9sMMCw/noEaSoH6z7l33Rw8OhRpVoBBFe7PiEWZDRvux6vyTdKeE0Bs8U+YCEr3aM+rjgAhvH4uAFV7DLAQz21FRgiT9YhsVTKx53nvs6crxtu7W8Oj7c2brgYqgeWDdoXZnb96hvsdNEwwffiEKja5H5AmaBDcVqJrvb8tTAgyi9OOgiYJjQuePoLcR+tkSTPEPtOhFyZYH6ndRnMw65DYKSaC0dFIBNAz9uhzWvgwt/8zGnkiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6512007)(6486002)(2906002)(66556008)(1076003)(7416002)(8936002)(4326008)(66476007)(2616005)(6666004)(83380400001)(26005)(66946007)(6916009)(316002)(38350700002)(38100700002)(36756003)(5660300002)(508600001)(86362001)(52116002)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H/6K/LhkH80hwVZMuhSJt0xdfcx/Ag0Q3KsXZ4DiLrScQFCHBN7sU2Yqzvch?=
 =?us-ascii?Q?NTw77augvuTJzwpBGniTm12VSyx3HszZpI5m+br9Nbck7TIvTdHuilP1z2uv?=
 =?us-ascii?Q?whlBTOq1Bo8/3ozDtD79o3eppPNX+edr5slXaF0cVsEmt3GcjKB8o8psVno8?=
 =?us-ascii?Q?LBkvHs5YHZ9A12Wos5MWYMO4smaH71B2UUrlGaIV+Mh5QRU4d7OjUENhenP8?=
 =?us-ascii?Q?n+O+Vb3/zwgeo7Hmi+9fja4cFyNALK1QbpGvGmZhRRiavAQfXNw06lEwl9OQ?=
 =?us-ascii?Q?zYoDpHgBH2YkmrL0f0tf8OMmBPHHyjF+JnMANrm0IQUE2kKwyanJSfLe9Lp+?=
 =?us-ascii?Q?iqcgfADtsCfCJmB+fqfNxTznZpJUM6v9wuuZevQJFeKiT3ghFWPd3mRKtzsC?=
 =?us-ascii?Q?9a2HkRhNBBXKdv70r/UGQBRJqJWj4kcyabHbpabrh0q+jpar0BwyyCuIEUs9?=
 =?us-ascii?Q?WpKnEM6gQBAdyzsl4KnCzTumFOtL/LZ3KP7iWO/uJXDT+qN1DDkmU3YdNDqj?=
 =?us-ascii?Q?IjWQ3yH5tRpg3X5JjdkPHEW4b57M8EstpGvO3//q2/KFUWrLLhVWX0Coqpcr?=
 =?us-ascii?Q?+lNBbs/vnmqeC2qpFmVgPpWfJgI3KlgJpA5bcHilDEGHTqfF8j5r0rZka/l8?=
 =?us-ascii?Q?UCRj6O9K4Pzr3WyWMX33XBF9EVXj5uVqptMUFWbBREozs9w5ftDBVEteoB/C?=
 =?us-ascii?Q?mDr1T5GJKB8lOq2yiy0F2d4KG/SN7GD4goxWEc8gzzDj4j7xpDDErpo50ayx?=
 =?us-ascii?Q?p+s58Hkaax5Coky1QCz8gIga8nea6WCwHmRIITA4rFPv06328JqWgMBAnQvB?=
 =?us-ascii?Q?gWgUEBN7v+QVrdjDd/0LgKXAKU1mH6hgoiHMGkcb08o/80B9Xw5BLzn7LnBL?=
 =?us-ascii?Q?A26rckvihOaLIURtiYK0XcXvpXfFgFmbclv8PD/b13oJSXMXevijbxDq04W6?=
 =?us-ascii?Q?6euEZtR63LvhaFGM8YbxD4b7dItpUEtYj0+aDOcIHGwEt5Y5sBmv8Br9m50X?=
 =?us-ascii?Q?5wVt5vYX9NMptRk3lPej4xlXcaZhwl58+1a7oEeGS1hzUwm9Pa5rDXugCb8B?=
 =?us-ascii?Q?ncviLPqMkxzRNb6ik+RwLwKer+bqoH63DLB9xxbc2mNIRUpm5X8zb3aQ7ypS?=
 =?us-ascii?Q?nzg2+g0DiRTrp5i2VGDxEAQ8TuhE+F5W3vKCYWLI2oxYdpDDX/uG9qkrFe13?=
 =?us-ascii?Q?s7yC30LKL043nVj3VbVrZYS3vCy73jRqIAzCtR6KNw27lRaCzPxZ8sLYgsEW?=
 =?us-ascii?Q?eUn7CMbRBTBdPmCq7csE+YsCTFdJLxGuiLXeZpOA/NqSR0o44Zduhg/9rXlv?=
 =?us-ascii?Q?/hfroP0Q57UML/3rzhhICjfH2lQsXMEyAdH7JoNU+E5uqhC0XlS8YfUpYkf8?=
 =?us-ascii?Q?vEYu73GDa+lId+XVsObtYLcwVsqU4cSafvS/LAJK+j9Pi6Y9HNXfmT5X6oQP?=
 =?us-ascii?Q?I0788u/QVC57iTd8Rlv1gENcqnwSnCiXAZwy+mTp9CfBza4gl7tAOJVMzuwv?=
 =?us-ascii?Q?Jo7NzNYpQm8rBEc3oGmU2jyAg/Y+axeM9d66lG2wOkWV8RScEjZc1ny4/X5V?=
 =?us-ascii?Q?erlkw6XI2RCEVxWc8sfFnd6P2HA7s7tKB+WdxEZaJHh9jmBJ3VX7x85CG42U?=
 =?us-ascii?Q?SH3bwy4pPptqDpgB6e9X7ak=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d9ec65-4e56-4452-dd4d-08d9bfa171b7
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 08:03:57.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfz/hEG0KgnUYt2+hcSIb22oTXPKONQAu9GfG5HgGqYUkwPfXyDiUpF4IFf+ftIMeUwAt6s5c1Qda9wIz048qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9355
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

