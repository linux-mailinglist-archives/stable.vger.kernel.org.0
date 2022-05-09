Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E3551F89F
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiEIJvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236532AbiEIJun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:50:43 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4380E170654;
        Mon,  9 May 2022 02:46:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7cE+RSZvPdIDKLZ9sc4H0H/8zi3sRze9LavZSfUmc3PDZ6jUIVwY1trzuxJaaZ+GuHY3Bjd8NpVF4ckXOLzea4Jl5Ntf6GX1keIntNtbfNW4uNSi8KsYDb34fhw6AJ7hWs9gdqqhAig7bqkj7NsBaJCxQhXT4+AHNnVlNKw1CS51T7odTwBHbCmEIX1EZc1Utnk1/V/ZrLAinlskq6Y+KFwx1Q9UpENnfYsqxCNYd0qxOU/GKb/0sniUh4YAAm3m/N9H8QUAt1ANbDXHTpdnwx4Ck0Gzz3IqjMv5Cl1jS7PFnA4v+EyUGVUySdMpEHCqVq5n1Qg5CIr/ZbZCOyc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAA/JKbMlm6B23GU3+0DM6XCf+t7b+uV1B1/fLo7SgY=;
 b=FN+5YoRy/XWJy4zYMWq7692EPq1E65mlz/EE/63C9QhMuS+1pQ3raxQ0v1aqRAXFgoY6PtVqCM/iYC4KbUc1xtVI3cPRNOj/+JNEEB7ZhLxgJIr91jjWozvW+9G0rYNnJ/ljAAtV1IARM1foZ7q0w+unY2JLp9YA74OwYTWNTuNixsWFkvs0MT8lreqYRKImBNwijBy6YQMld9W56WhuJp97Fvml/AerLTIMjqz1vOAuDi5mo5OLVq7o2IbEhZgXy5aJthiA9erGycOq4knWsEMAJ6mhbHgfsK+4O3stJqRHFAwFd0f8LTXjHsgm06wIiofSSR2QBgFp5G97+d7Xog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAA/JKbMlm6B23GU3+0DM6XCf+t7b+uV1B1/fLo7SgY=;
 b=p81UWLdBMEKJ2TzBhu0zms6r7P/cO/WiHt8zxYWfVzqY911a/wUyof96fkFd9fhRNsZndwXNEqPqzkkIS3imsG6eBGqWjSFszkY+cAN6MUAjgLa161w3y7u6d1kMOviBDy5N/V72bAfI28omf3zJRiDhe89chiXM11tlTyvay20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by PA4PR04MB9440.eurprd04.prod.outlook.com (2603:10a6:102:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 09:44:37 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::1d57:4a64:1c30:a00f]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::1d57:4a64:1c30:a00f%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 09:44:37 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        david@redhat.com, vbabka@suse.cz, stable@vger.kernel.org,
        minchan@kernel.org, Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH 1/1] Revert "mm/cma.c: remove redundant cma_mutex lock"
Date:   Mon,  9 May 2022 17:45:51 +0800
Message-Id: <20220509094551.3596244-1-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0027.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::7) To DB9PR04MB8477.eurprd04.prod.outlook.com
 (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e3dc7b7-8fad-40d6-318d-08da31a087b4
X-MS-TrafficTypeDiagnostic: PA4PR04MB9440:EE_
X-Microsoft-Antispam-PRVS: <PA4PR04MB94405B51869D99F465EF843C80C69@PA4PR04MB9440.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sUyOFBZcaDvuyMeYitEugMqtjzb6BU+BlFc6NC/EboeYOIS8A90Qs8dY2N/FbKidIeuSkxXDlZXUQvhkmrGXjg3YW3uLWHkxboP1uXPQfxp5cK3rVeWDDA22J7gpz7YLD4bGYVdgGrQTZwP3kWQqVWKhe0VZ+Guod9EeUR+R/vG6qLB2Oi0cBA76hx/SLNwKSfhQWFHxcISBzR8MAEpLhCgrZilwrVg9eOf/MgtaUWpwpupEWAuguMye66AWSHS9/zzEVZAZ5HO3WoIwgBylT4cPAtrCdTuoJBIFZroA66e55r5Oo0roArUX1++yb8g84iFkQLcjILoT/C5lWSI9tE85DwHgpELK8H7YAbJSt1M6Ol8HLOfHncStUfOsMXUghJt0brVj+fcssqOq5hQxpXM7i6mQCyUpxvKjjqv79XyRQbi/oCmiDTc2Z48LxdOtYp1GpVVmDmQJourd8n/2Ym9zD5eS4Ho4xBINLxHOEBdS+PD6UZ/OBaFz6hIsI+Rmb8YNfmlUugxHufy6PefV7JAh32IyLnraJ0Ojv1B4ZGRl0Fd6lHoai1AkkP7M4KNNSOtG9RRxnEdxZIe5rZ+RS/86yQyv3ExVPxSO5kY+pqVnR+Qg3CwIk6eR9/i4ItpSX5znWc0tVko7uvBkhUrMjiP3AxYYt104glhioqdwEowp/HRdScazSejruYPimFp8i+SsfUXIE86+pWox8aK7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(2906002)(6916009)(66476007)(8676002)(6486002)(86362001)(38100700002)(4326008)(316002)(38350700002)(508600001)(83380400001)(8936002)(5660300002)(2616005)(6512007)(1076003)(7416002)(36756003)(186003)(26005)(6666004)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IKaXU0aI5tjWoMzRx3vPrE2b2sNDUIedvoAlhlhRKbydwHvaCPgxkN+HjpRs?=
 =?us-ascii?Q?ZESKsfM95x5iD5KOlBQWqYtgD/ZUtP8ZKAhNHEa5y9vSZI5Hm/aU+EuApBXW?=
 =?us-ascii?Q?uRe5X6bUW/sb9iRxKkY1uZY865vrZFabUxKbE836aKw8DWd28YY9/oHi4U+R?=
 =?us-ascii?Q?OoPIVddUcqlOluwfIKXmZVTpAeliGKr0eL5Tjq2l3sdf2G0nVvP0pPGWbB1r?=
 =?us-ascii?Q?XR1BpDvK5nK2cK8mpq+YU61SQWiVlfD3pM17JzV55jpJBlWR8TjuJl4O/jm/?=
 =?us-ascii?Q?XDLeiyaajT2emjheNDQOs/ClGYE9WLvxW4x6UAR9MMDHJEQaYbdxxGA0DmRr?=
 =?us-ascii?Q?KbRCYYw/e0v1Qvmc7tagOF+aFxH78XJVH1re5EYfyDL2H8+5pAQEGd4JaNCa?=
 =?us-ascii?Q?wejjmg9POmOnEFe47AGsZf5RSkwtxbaGYPfgQ550uX1Xp0Orco8UiZ/WIcpd?=
 =?us-ascii?Q?QT8nholxbg6qvXFEmaD8JAKKGwxdcGCku/VYFUYwINHEhz9VaIMT2RU4ykgv?=
 =?us-ascii?Q?a8HHoahmMjUKfDPuA44QxSdytdBDRjVgUJzHqAyQAjvT/BbEqYJXJlRTljp+?=
 =?us-ascii?Q?LaKDRKoT+5lqoXVdDLUCIct8acOoknyfC53xnGe9GGpUBpKbrbwho9aY0cwX?=
 =?us-ascii?Q?xATwwRCPck8gNmr6WwePiGWDinibCVdKt/Xan+sBKVDohRqBn8QCjexeqF2n?=
 =?us-ascii?Q?Z+GbjxPbaEa8/zxWWOXoFZL+43TWCmxsvZBiCqlXWLrAIaDnoPSszDefZdAU?=
 =?us-ascii?Q?mu+NQ15Brk57Fo0Ku7YortIAYL/AMtJDbLuiv4pxJPglBzIz2B65yLwy6sKU?=
 =?us-ascii?Q?bLTJO4zPB14CnqaCfshBT8b9JrHclFNqqzgKaXqS5X71iVSAHJVaC5OqvsSQ?=
 =?us-ascii?Q?0v6T56S3V7ENhBP1jNx8WWHFb1T6UZAzxfvXaqs42RfMTUKtA2CmObJEnPM7?=
 =?us-ascii?Q?R+iRXw7vQrUbWt3QG+v0V+R8dJEcSn7kFwaqoLVCvo3JZCxSYrISkj35Jltq?=
 =?us-ascii?Q?o/ZRRaY1NpgFq69RQ6/OOAE+jhR/x4AAxQTkzBa4A74pE6VNyHmMpwHywgNz?=
 =?us-ascii?Q?lekmwkrvP+A1iGRYsjAkWn8zLpKEVJCqdXjPw05gGVne3/9NWq56SD+d5Ude?=
 =?us-ascii?Q?OOZBNQPWs0eVKkKCwXNZkUMnXQSq2blW+3WeQUPFZSEJj7vbC9oki1f+UypS?=
 =?us-ascii?Q?KOHlrUtSH93f3H+6gAlHh2mvPXkiaxWJBiIBFRO9cTBFFguOsxlbFUKW/kj6?=
 =?us-ascii?Q?EdmtoIfAvj0OvHUHcxSDE2861OuGHgHyIYkkSBK7X6DxL5w/4rpyoDvow9TT?=
 =?us-ascii?Q?ivkGWqZ9zRaXBYPpqTMhYfV0ZXQJcwANl+cmI4h/SlkEvf3aFVzzAHJfkd3Z?=
 =?us-ascii?Q?IcuxZm654LYs04ulexoQjPKQ0qICpNXxR4Z3dRaUHMPGsPM3EHLvVjmKF6YB?=
 =?us-ascii?Q?5Mj7lQAXVhjJwpk834K8Eny9iKLwomPzXwAmGJMBBLkT8nM0j0w2lAUFjRaj?=
 =?us-ascii?Q?Dsb9h+123VdNVpQzPca3IV7G8gSEQFOOLRRIzPVWPrvBqHzowiD7Pqp5/BFh?=
 =?us-ascii?Q?vYnqqkf8neeNtO1d+uNWbSLZP+ISalX7n2VdJhASCidr0mPJ4dvMPuBgqWfd?=
 =?us-ascii?Q?CjBxiuPyxK2/ZlsxfrCr9BH3dyJNtoiRyv4JY7kfgqMSqZZmLo4GVhyFaacW?=
 =?us-ascii?Q?a8cwPIcwGovsZQ+FEMheD0+3+m+QTF+jT3wxQBIGdvshQLtT97HmJJDhOWXu?=
 =?us-ascii?Q?GwJsiJlpAg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3dc7b7-8fad-40d6-318d-08da31a087b4
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 09:44:37.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tx91BjZ+qLawGmvGCF9KccJ3KcrdWDJtqbI+fhqdO6GNdy28WalIU+fvj4GJkKL+qD03Mn8Q5ljDGu4DcbXAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9440
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit a4efc174b382fcdb62e2d90d39e78a274a975e38 which
introduced a regression issue that when there're multiple processes
allocating dma memory in parallel by calling dma_alloc_coherent(), it
may fail sometimes as follows:

Error log:
cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
cma: number of available pages:
3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages

When issue happened, we saw there were still 33161 pages (129M) free CMA
memory and a lot available free slots for 148 pages in CMA bitmap that we
want to allocate.

When dumping memory info, we found that there was also ~342M normal memory,
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

This patch simply falls back to the original method that using cma_mutex
to make alloc_contig_range() run sequentially to avoid the issue.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
CC: stable@vger.kernel.org # 5.11+
Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
Patch is based on
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-stable
---
 mm/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index eaa4b5c920a2..4a978e09547a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -37,6 +37,7 @@
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned cma_area_count;
+static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
 {
@@ -468,9 +469,10 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 		spin_unlock_irq(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
+		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
 				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-
+		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
-- 
2.25.1

