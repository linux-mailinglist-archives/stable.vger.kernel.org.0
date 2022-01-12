Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB848C4A1
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 14:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353484AbiALNRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 08:17:38 -0500
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:36705
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353489AbiALNRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 08:17:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEGVcu5j+qaS5m+wAeuW8/OBUHO65BCK+EQihFMD1puOHqsg5jSStoKD/Zfd5hWI09ExfMpCyDRT07MdqEHbW7Swp8/WBHJVc2NaSYjoh72kFGwck8bxP21Gl3CDp0hqj2U7fAwxdUdBoiS/7ZNaTrZHzZHxETX0AntNQ4x4Az1eQO0FOovxTqMzxntT9U81eO83zUlrXemEXGt0BlNrXyOrMaA5Q0BNWrZmLnwIB16Q1lUB1Uwsjx9yNdDDMQzqtLZgR4htlqX6cnNAD9/YDnTrmFIZFeux+WNHEhIiP7uYttmYwnvLlkdfqZczlk1KeY5JIukJCrVo6ARUqZ1/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Flj59rK4Hz6g8apMzUcbQv8leW0I9ut242J9Usox/Dc=;
 b=LtEfVX9S34QReU1LtCq3kWtvhUri6FLNkysCVpSKKY0zMBJtO2phZCt0QRDuVz3dnrtTL5BaDDxMP41e5/4fiHp95d0GPBGtnwm/aNAF2R5AzzGWMGurwp+RoKucS3fRlvCMkk7yyoiQ3+V6YpW/6AuFfnA5wKsBrZEO5ixisEq91ujR2UT9x9VS2AtdUS40BftmY2mYW824JdE4tfkGIQ/rIYXygvRFkD4pcZanPCWjECeE8X+KFJvn4JX4TO8zosux7nzC8mhAJAMpIWMZGwEDuFi/4bcps9SOC4dkvEATGsGVHyMolVp7sGY56kUBvRXtY1E6Z/QYg9wYXaksEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Flj59rK4Hz6g8apMzUcbQv8leW0I9ut242J9Usox/Dc=;
 b=Cb2em2tiONmU3ZjpCqmGr7hOiB+C6D45fpYJ2aE+IYECFuEohkj9CfCvwtBI/yjPcfdGf72fKZXGB/9k3ygRJY5sapmPlK/EVgmfvRNY+zwTZRgA1jQJOnLkcF8vlJYSiNMNvF2I5jeOfa829CvHpz93JXfdh6+tobQb8+CIv5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
 by VE1PR04MB6383.eurprd04.prod.outlook.com (2603:10a6:803:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 13:17:32 +0000
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10]) by AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10%8]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 13:17:32 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, jason.hui.liu@nxp.com, leoyang.li@nxp.com,
        abel.vesa@nxp.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v2 2/2] mm: cma: try next MAX_ORDER_NR_PAGES during retry
Date:   Wed, 12 Jan 2022 21:15:52 +0800
Message-Id: <20220112131552.3329380-3-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112131552.3329380-1-aisheng.dong@nxp.com>
References: <20220112131552.3329380-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5d4a31-f7dd-48d0-0019-08d9d5cde42d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6383:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB638392949A59FA172DE6565A80529@VE1PR04MB6383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPqd4XIdiYB0TexTQBW6OaB40g7pPcG+Bz03kFv7Uwm147nE/Z/rt/R9Aptp9HDqxUMZUSRjhPVZwDl0qcK1iRDjWlgMav5DEvfb3AK8cqCZ+5cxwWAu8x8OjvJJmGz+J7MKywrZprdW+gFF9QzwxdSUoNXyqt4+TN1ILg4VTVIE/068Etx5p8UktE0Ngi6G89AuTB7jq4iU9wYMSVaTMVyBVUHu0d5Wmiboolnt+5ZOOU0iZnMKza5OCbDkEJce2yFYn6aLOkhToG8KvQRU74Kuc7Rghi0tZPPTwkON9PjBtwT1uG8q5iD5U7L0wAgzhQzupRkBkvBlORJpQFZM5U8CsU77apvRE7FstoKR4czL3NChA+lRhV24Xbow74T2gRr3VOPFwK2wAitjq+9+ZjJuZrHLDB9SWjAOOoL2D34ZtwVsE+U95iRlFhLbq92BLa6Gun1w1E8bRVskGqAl0Z6oesKBpEFGVRNGu1AlVTd8Z4uoJhZ5T+VhKOJpRYcSE9ioqUMJjHpQOmcMDt1XXeRuI3TgtLtwBs6n6Pg6iLzL9XHtfqwQ0r7R8q8cUr2qz8oXowi9WdSsEwvjeY/wTKbp3immIIX3kUTB8SPGG8s8Yi7D9l2ZT9okq7j78x9AzAaEyl7FYSqLvbQszDBudy1hn0kyUtfTZVO4VCLXdjkUx9obawGmHKb4RQAvnyI42aTtWcTqdcEUkg4TH/j0uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8466.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(83380400001)(316002)(1076003)(52116002)(508600001)(66946007)(66556008)(66476007)(6512007)(186003)(4326008)(26005)(6506007)(5660300002)(6916009)(8936002)(2616005)(2906002)(8676002)(6666004)(6486002)(86362001)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5O9ABib1jxXDXN/c9p+x/wSwdVEEwztfVxpJL9n+OywhfYOvF7A5Ts4a6th?=
 =?us-ascii?Q?/ET5Q1RR+OSBn+cKP7Msonzo68OrhU8rYdB3vETY8K4jJUvomy1jTdasah78?=
 =?us-ascii?Q?/Wk+JBEfUBalxvkwf9ZTLFBnx28HMRjw7UPprj4Xs9crFngeY9dv6u9kuf6e?=
 =?us-ascii?Q?Y13lbdGQvUyuppLAtKwvEB9AQEuVKCQ4WchEFJSD1XAt61wBwgEBAcAzAKnK?=
 =?us-ascii?Q?GZ6qvCVSXjUTbUyYHPuKq0D2GhDWNLo6QEei9Z/gRk5e0UB3s/g8hc6wsl3P?=
 =?us-ascii?Q?7AFRht1gWuV3w7k0a6+5WPWIIyfy5OfyRVoi+2dCS2cFYW1irQwCCkBb2nn3?=
 =?us-ascii?Q?Nxk85BEltnh+0sFyqM/P4OrWE8/a+SMpOpm1vnUqdR/Fsj3DKxusA/V3pHFR?=
 =?us-ascii?Q?UNUV+i+Yms5wISqP4uBETB9wj7C6sYqbIy7ayuq13Iyit7UgPKh2mAGeThU6?=
 =?us-ascii?Q?SVSMu8jCqy6TT/eqe5sP9YvfotxnetJJSvfe/ZWKDY3CxbrqNKO4NIdtohdZ?=
 =?us-ascii?Q?ciOrH3Fu5iNe+tL9a3ZKnSAg3vFKN8+pTd0sChBCD9LdmFY3pOThCN8tspIs?=
 =?us-ascii?Q?7tvepWgBsDZy/wQ53CMu85qmvr53E3CKmJPzKF12Qwm44LuyHHXTuqG2FO0J?=
 =?us-ascii?Q?6zW0fX3+GX31DQtolXCYrpZE+e4Kw02GXghqNHDpU5e/engeJM2bFMX3a/+Q?=
 =?us-ascii?Q?zoCtWJMyP2J7Ps/xkhYeGyPCGeYAAL6pz7F3ulhbjiUQ4Az1QX9BeogJEF9n?=
 =?us-ascii?Q?t9Z6EJE68Vdbwr6m1PGVWhAFmw1spSFOKJOS1GhZkXvyrGKsiwM+3Ni264KF?=
 =?us-ascii?Q?hTedhHeu8JMkkb+5ODiTwmr7o2O2COLWbITGDZTAkfme9vSs2S1cU/DlGi5V?=
 =?us-ascii?Q?8juqooaVMs9o4ZNl7QKhkhBNhufGZUXLkWtqqSFKTbE25tg/CFiIv45lHZqp?=
 =?us-ascii?Q?ggWKWPrXxolrAFpor/cwq8+OZmnwrgHpsLKQYl6Fmkoi+VjrjKzmqFl//qx0?=
 =?us-ascii?Q?3H0w0xEsJrGjxEmpcpdO4OypmS0RCG2HPUlSY5EpaFJ0gCmlAhnDGRZO+a7F?=
 =?us-ascii?Q?e7q/eHjwhzGXKbFsPYzIc0Fi4KV/msB2MK/CRqVguu7AuDhjrit19zYP+ULe?=
 =?us-ascii?Q?FRmiJi34Lvc74VLwQBu8LvyFXvWkc1mBEoatj7931zMkBEv8BzcX2/KbcPBC?=
 =?us-ascii?Q?yL8fzVDdi48HASRbNMmAapem4DEpVMxzhSAIE+UjxnhY0q6x/uUTDzvfCPgV?=
 =?us-ascii?Q?AlwZKD+TXP2jhgn8VJ1NHutJXnhDdbODlrUbFiRrbbfMf4mvZdEM2eo1995t?=
 =?us-ascii?Q?wfao/aNxfnNZhfQMr7iWorwfvBT+NsjuvPzBsCz0rKvulWpQ4Zru9OAjHMf4?=
 =?us-ascii?Q?SBIavQhjO8byonWdUyCMkdaQaov1uGVGZF984ISBa9zbx77n6vcJZ1CqtK/G?=
 =?us-ascii?Q?+szwKAI6jWJLyDg6CVqoSlJrN4aY7zZVH6uXd7R7/fWHRvMgCMkqGSL5o6bh?=
 =?us-ascii?Q?MvlXzjpNTHNFeRb3KL+BZywpolI6Nq6/aVlC0FcEtfLDLbfF3He3jyxKWLrY?=
 =?us-ascii?Q?gVjvcxJ+ZITH3pXdqg6+Nq1COj8dBeT7+2vteMULQjQs/9YdlTCiXi5irnDF?=
 =?us-ascii?Q?Tz1lXnH3Jyy1cRTO92Xcp2A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5d4a31-f7dd-48d0-0019-08d9d5cde42d
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8466.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 13:17:32.6094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7NPwfUKVeDZMO6gbjil7OVW1QJd++hnexD9c3OdJNLSElhJ43Ym/9HDmvj3DLhYFuJC3XvBOIHvkA2c0a2nhKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6383
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On an ARMv7 platform with 32M pageblock(MAX_ORDER 14), we observed a
huge number of repeat retries of CMA allocation (1k+) during booting
when allocating one page for each of 3 mmc instance probe.

This is caused by CMA now supports cocurrent allocation since commit
a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock").
The pageblock or (MAX_ORDER -1) from which we are trying to allocate
memory may have already been acquired and isolated by others.
Current cma_alloc() will then retry the next area by the step of
bitmap_no + mask + 1 which are very likely within the same isolated range
and fail again. So when the pageblock or MAX_ORDER is big (e.g. 8192),
keep retrying in a small step become meaningless because it will be known
to fail at a huge number of times due to the pageblock has been isolated
by others, especially when allocating only one or two pages.

Instread of looping in the same pageblock and wasting CPU mips a lot,
especially for big pageblock system (e.g. 16M or 32M),
we try the next MAX_ORDER_NR_PAGES directly.

Doing this way can greatly mitigate the situtation.

Below is the original error log during booting:
[    2.004804] cma: cma_alloc(cma (ptrval), count 1, align 0)
[    2.010318] cma: cma_alloc(cma (ptrval), count 1, align 0)
[    2.010776] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010785] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010793] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010800] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010807] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
[    2.010814] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
.... (+1K retries)

After fix, the 1200+ reties can be reduced to 0.
Another test running 8 VPU decoder in parallel shows that 1500+ retries
dropped to ~145.

IOW this patch can improve the CMA allocation speed a lot when there're
enough CMA memory by reducing retries significantly.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
CC: stable@vger.kernel.org # 5.11+
Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
v1->v2:
 * change to align with MAX_ORDER_NR_PAGES instead of pageblock_nr_pages
---
 mm/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 1c13a729d274..1251f65e2364 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -500,7 +500,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
 		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		start = ALIGN(bitmap_no + mask + 1,
+			      MAX_ORDER_NR_PAGES >> cma->order_per_bit);
+
 	}
 
 	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
-- 
2.25.1

