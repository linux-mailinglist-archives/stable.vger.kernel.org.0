Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673E44D9DFD
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 15:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349337AbiCOOpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 10:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349400AbiCOOpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 10:45:05 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4D764CB;
        Tue, 15 Mar 2022 07:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKfL7F3DwEiN1xslfhWGu8/zvVUQ12oUnSTn0ccCh3re2fIPGsmMSOu53Vgij1tbwBJF6rJsWo5CYlYWyqn8T3qwvHMMNCDOGyCNmQydclyOQb9h64WXu35eeB7nM3LWOAbTvMf4slNexe9GIPRzcczHepgCVjzk6A/YleAMrhWrv8SxzMASXPV0Tgta9yYYcfrwQswFhjb4ZTP40mrdSx0yJ7Hi0TotTw6DL06zj6DYIVKfcfZ0A+cnSlzcqQR/78E8Gvk8sgVmQS5jdYwfX2KAyCF3u9Z4TD2XFvizo3gRcy35meoRj2YqlfcVN8Saf/yLNghLTaXKzKLYu1sdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izGVLYxZV8/3oohYdJEG6xwzGwx4SIhUIF/AD/5v1pY=;
 b=iT4NcOimsnCJrUCgZMJ1ExSDdq263Em+0+Kga70lXcp7xmAVLjKHuygdY8UElrf6VNCJnk2O92ylYT8j2krEVPNCVhwn8IgtDs8QobUweGRR1O8kAeIvTLE+T7pb9ZSbn4mOIt2n+LnMJ+Ay1o4tBuo0tNTqmH0vIrd+EPdzRRBFC6oyAhmdfdoZrs5xqSHga58GYJ+ymRkrm7Q0bKyvwqTNlYw8g8rHwqXkR9ynGkMcVhUXVfMq5cEk0dKVBl2y9mHmsZCcLRcSdlLVgsO90B5VZkujXU55nstwNPRmWtq9HJ2bWLMYn80/TLw9vVXtb68tq5GG6NLdyj1JAht+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izGVLYxZV8/3oohYdJEG6xwzGwx4SIhUIF/AD/5v1pY=;
 b=P428L8A9FWH76I4k3NOxeAedMnMMY1F16C7YctnbUTtFvk8K6rB6fNez79ZCzjSuCMkRF8wQLaBy38lLa+1968Lo2a2M2FSew/LYsmwbK8fVaIl+b3gfa91g64oAQPfgieE9otijWJGWJRKO17fPNCSClyuBUVxRSXsBg3toJAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Tue, 15 Mar
 2022 14:43:50 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 14:43:47 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v3 2/2] mm: cma: try next MAX_ORDER_NR_PAGES during retry
Date:   Tue, 15 Mar 2022 22:45:21 +0800
Message-Id: <20220315144521.3810298-3-aisheng.dong@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8adc209e-1ea1-44e4-c3d4-08da0692365e
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281420071B1F5AAE4D5B4DC80109@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Kn/rIeC3a4I1KeqfJ0qgHTHAVPe8e7l1Yfkaa6mWrwcFND7S2KC1Zn+zLmaallmOeGyeTMQOkYSq5L4c0+2mRpFTewmBuPBceHG0oNThBa/1+HlKW7ho4EVsrtJA9dpWZuiFOX3lxZayjsFDO3LebcSUuyhyZEX4H6isIZQIH9TdrHTOMQ/k9y3qFAvMrFupaBpcnc5QuN+I9ey0qprXpbRVEigP5ZEajgYDNkR4ie8VgIIEHcUw/4UYqfTT3BKYqFKAY2tt9BwDh4camojFnE6zdDXNPrk9u3i1jhop1qhyCtsWdNVBTB0oGgM4utlL9EVXuPFgE6xNDkpmxAfTwLXBv8usCmvM13kmLlgtdsMXGlcKClHBi6AqXT2AjVHmyqdZpmGy4Qflimu4ZOxjKF3vKcQW9kRdw6TjmEGYphaXwgPVJ4UIbF/MYXL4ldkOl7AP7AHHAxVdcH0sORNCpZgzPnCk/jw3ZH4TuNU5QzaNcGQZUoZ6hhWktsJvXCkFq16bdUOsZ/ZJxNqeBoHlmcbRAkL0ePM8kt62PhqnKd/vTCzM+kZmrPEiNlZ03X2yD4B+xXHQbz0oaeuOfrWVlv8K8axlLRZbaIz0ZvcamrpKVOBupvqbGydpR6XW9+TDVJ5hiRxfX4F9nyZP17ylpvKxEUcNVEySX1rQ/Ey8J1rYH7HzzwG4rcmCetiQmd4RflYDnUiAFK/pvI0kZztkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6512007)(6486002)(2616005)(26005)(186003)(508600001)(6666004)(6506007)(52116002)(38100700002)(38350700002)(83380400001)(86362001)(316002)(66556008)(2906002)(6916009)(8936002)(4326008)(66476007)(66946007)(8676002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rmc7fOiAsNc8E1LambyW0iSa1qqtXr2CZc09cMoA9uvjHwVfIWOSNEkL4vlM?=
 =?us-ascii?Q?Xvg5NwTD0QnZ8EhVBb+oUlnF2fY8G1PLh9wQOgrIIHJu+PMq24C8jqndn5Aq?=
 =?us-ascii?Q?CEu31l4us+d6YJ7k0wNQZSgU21rC5YxXpVg9jRQV3OwJXLpcF33fJg3NT7s0?=
 =?us-ascii?Q?QoehHhQpib7C5c6TTJJl434HH4EoY17SWTsFskuPDTQNNGpTE+Sd9h1lIyoe?=
 =?us-ascii?Q?7zb12Io57aFT5PdBeIjiwJd9kWsrL1qCRjSSdgNQio/jAlQz+5nW99rfgRd8?=
 =?us-ascii?Q?LAA7tGYtdLh3XmgNx/+IfZgXNczogH649NSfPdZKthCoiezDoQa15gI8DNgQ?=
 =?us-ascii?Q?XxhAq5mykvr17yVDN1d0OUtt6704OPn+trOcC5rtiW30k8G8GUv99UFqmv9t?=
 =?us-ascii?Q?X/4LySVZu4jLo/2rn4vUV0ADNdd1NCiYHEq6iCDu777g2OlocZNvT7jX+O9x?=
 =?us-ascii?Q?V0RlBAX5QvgZ8TBQO83TReakYBytassxQvxV0IgdTvW57VqyljlQK6bIwUcR?=
 =?us-ascii?Q?ldRNKhcrczWXo3tDOMdcjBmauubM6eJQ0LUIhlRxdAPvTHdg+TjAi729YUIZ?=
 =?us-ascii?Q?fbsMzWz/97SHlBJ6sWRqrywxk1lBYsrfJYCIpLq3Oh6dPDmx4I4GasUPyjAe?=
 =?us-ascii?Q?c/gdHqatqzFBdQ74k5LSDGhueSw7J4zIYhdW5ZjK1yIy6LIEG6LR40Fp4roI?=
 =?us-ascii?Q?Ge4SxGCccFVCzMlquygEAQmHLy8THrdISm5pVSn3Zjix9OWJWWum31cg1VrP?=
 =?us-ascii?Q?pr+kQ7aDUhPJ5i7mvzVLPnAyNuTYrvVzazSFP2QZIcO1Uhoxfrv4SzzEqB9Q?=
 =?us-ascii?Q?zTTqYkZuCDtghvTBRGoCvyZnFdqX/KZj/nmjxzu0XThnSYEFzS2RWCkp0UEz?=
 =?us-ascii?Q?xDysQOG0JzBe7ufwRrfGzggqkZpb0e3WxLfhJZnwGKh61toiA5F5/pXm+nss?=
 =?us-ascii?Q?zdYjYH90h7peUs1tcZ5jTkdrPH3qNpdKcSu4MvTMrERT7vf4u8O0GBDoIz/+?=
 =?us-ascii?Q?tT0xp7Gdhh3KjEnfl5UYe+fezENVQQRI8DXo5WxcJnxXY1hOW9TsCfVLOIq+?=
 =?us-ascii?Q?twpRvH3yflruffXs3V/aQOKxXSLFuvEqOSwFZjctIE1vWoqt7uOa3t9OiUJj?=
 =?us-ascii?Q?Io+owCqvNEhbtGu7aell2DIdFMRRB3XDAvw3wvhq2Y6TTidQp3vYjO6/2/Ma?=
 =?us-ascii?Q?6A9eNVzBG5QzxDDHqPhZ06Rgk0P6QfdJaRanWBgHwuh6asZa2O4tTtmSLP4F?=
 =?us-ascii?Q?h4LQEWHwA2zs+1P7rGDvJY+bS6HT5vlRu07hF5w7oJpBdpq1i/74ou6x6DKy?=
 =?us-ascii?Q?o8njkVBPla4GrRz7hzNvQ2IxFb1YKwoVVLrkjNJ4KtcopvZTH5/PF8/RWDz7?=
 =?us-ascii?Q?9ZVL4+NnA7PmU6XGf0zkl6lGvMtz3uxXP1wAjg8PmP7bau07PexpXRWxcil/?=
 =?us-ascii?Q?oqJp/jvQy+j/2HwsWox+4k5GU+3hhv8j?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adc209e-1ea1-44e4-c3d4-08da0692365e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 14:43:47.8205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyxyVO7ttJf2MoOJsPFNY45iVKO8Vb90dPQ3N/7I730l11r44CfMtQrTxPcqbTrxae1fr0bjINN2C2GU5n70KA==
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

On an ARMv7 platform with 1G memory, when MAX_ORDER_NR_PAGES
is big (e.g. 32M with max_order 14) and CMA memory is relatively small
(e.g. 128M), we observed a huge number of repeat retries of CMA
allocation (1k+) during booting when allocating one page for each
of 3 mmc instance probe.

This is caused by CMA now supports concurrent allocation since commit
a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock").
The memory range, MAX_ORDER_NR_PAGES aligned, from which we are trying
to allocate memory may have already been acquired and isolated by others
(see: alloc_contig_range()).

Current cma_alloc() will retry the next area by a small step of
bitmap_no + mask + 1 which are very likely within the same isolated range
and fail again. So when the MAX_ORDER_NR_PAGES is big (e.g. 32M),
keep retrying in a small step become meaningless because it will be known
to fail at a huge number of times due to that memory range has been isolated
by others, especially when allocating only one or two pages.

Instead of looping in the same isolated range and wasting CPU mips a lot,
especially for big MAX_ORDER systems (e.g. 16M or 32M),
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
Another test running 8 threads running dma_alloc_coherent() in parallel
shows that 1500+ retries dropped to ~145.

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
v2->v3:
 * Improve commit messeages
v1->v2:
 * change to align with MAX_ORDER_NR_PAGES instead of pageblock_nr_pages
---
 mm/cma.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 46a9fd9f92c4..46bc12fe28b3 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -496,8 +496,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
-		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		/*
+		 * Try again with a bit different memory target.
+		 * Since memory isolated in alloc_contig_range() is aligned
+		 * with MAX_ORDER_NR_PAGES, instead of retrying in a small
+		 * step within the same isolated range, we try the next
+		 * available memory range directly.
+		 */
+		start = ALIGN(bitmap_no + mask + 1,
+			      MAX_ORDER_NR_PAGES >> cma->order_per_bit);
+
 	}
 
 	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
-- 
2.25.1

