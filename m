Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0E145FBA3
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 03:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhK0CK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 21:10:26 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:26516
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236655AbhK0CIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 21:08:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJgczmkctn0K9Oz4pXrIZAq3/MhvJCZpkpJubyLtEte5QEVLvuo2DyL8mX8cZaZ2KYd4zUrpb0W+bFCBS1GZGRmix4mk/vJCpJmK1LA+D41vAnWbCqCg4Td42fnodKsvNgqjK6fFCtQuAam2Sni9aK6G8zX8dvq3XkBZalsyh6Ph4rlIKdMwbAJNGhFYHyTEUs/RWXCjMu0gEPQimnixZEtmdkLhGKzwSdRhYxD4Hcwc9whr+0rSQENq5S5/8yQGkIFdqv1X50+nmoDfOHrmRDDIqHbe15FukEqAnDmP8P7xwTqAUxXVB1yiJpJsQPdgqBEy/i/F5embNd9tvgzZaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXqeVDCPnI81WwSNwzROAqeb5GxOFiLWrntAmK+Vi3c=;
 b=GDNHXkQtymJykf/YxJ4BRtPymNRjowVGiGI9f2qZh+RufnpN9uAyBBGUVWABV4Gkn1FzlcRytw0AEu90xBzslHqZSqJhbYAKjsfei2xdKrw94a4VZoIiZstE7jx3Ymr95R5HGCVmUB5MSDS70RLjnvbm4SbtHcDr1oJgNDV8QZESwRSzs3efp8PcIjpiej2ffsF8Ql0zROfFIYJ3Bqi/t71L+EHM5SYoEVLeT77dNDA6//VWvB0JqoGXBzAvMKGww/4/XBpCzOWsKsAueyzUkTEBIa/lnvcW6f3nvBbJOiU1xkJib6/RlM0jimYRxlPxf56EVeTEdvQisdPspo79wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXqeVDCPnI81WwSNwzROAqeb5GxOFiLWrntAmK+Vi3c=;
 b=Zv8sQ5VEXrgfjYk00AhwLGfh4rz88HsMTxhzqsd7XPjygDgW5Eel8eOg43oJAueWLRY6tAR+aXDYNJVBUePCmzBOT6q1+odlmpZmBvcKGkwHIxWGXzNfOLiFpwmYqiEaAahiD1ehFlRiDjqZ2YUGQFvtzFzdOJWdP9UuuxX7m5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3837.eurprd04.prod.outlook.com (2603:10a6:803:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 02:05:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 02:05:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] powerpc/mm: fix early initialization failure for MMUs with no hash table
Date:   Sat, 27 Nov 2021 04:04:48 +0200
Message-Id: <20211127020448.4008507-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8P189CA0024.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS8P189CA0024.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Sat, 27 Nov 2021 02:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fcac5f0-ab56-47f1-2125-08d9b14a54b1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3837:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38373BF853444D35D71A7EAAE0649@VI1PR0402MB3837.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6gOQptM3hp+YmbWVDcUfguwmSYmS73pljeys2pVxqXur+KAcLaQRxHo3MzH4/nsnfcvOuuW7FmojdDOzfz8WBAEwcxjXbdt+iaLQv6Dd8wA4H/4cGNaFkwUK+3KbKxHe8I0P4ZQ9/vDg9QR+KMSR9TKwka3qYuMxrI5Co/JZ97i99K/pYScwbtOBcaWisheUDndHp1PVytsCZDvW95QXhieeNCOE/JL2jJupj3Oa/luB/cVjPgqKz+2xJhXGQaFjvwWGLvc7LmYcFo8wTpvmOQ5Lo2dTiPimDqs8HtDduQjODcSmcTbu7czlyi/OIDSzC2WGxRvJotFJITmM9STqYxc/7g8a57gfgzW93F0uMh9H4VCpMrrinIdYEZTxk+/GRzjo7q54cMKs5FCv1OxEkFZz5Tpxzf7b0smWHmLMl53vOcQwiPC8BbLQ/mVZ2obptrqBNs9GeElzNkBey4+sCMIaU4YmDahnWo+veoON/cm5Lu4X9133cSyAsB6by16HCDpoO1seRJxZkguz48Wl68oDEPuvU76uJ3V3wR2R92BHquykHDcqo5Ibk20RWcif0VGyhYr1Q0+4IcDqU87jDnILzdVFObsdmQ8WIBWV2lNNVDxAVLIvzGG29EaLizsE+haztQFSQQjcgaqm6uI7FaLUik76pvXkxbM5JQrbb5siQjRbcljDpVqn6TTHk5q6U3Rdjo08KB8ArNAUp3xDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(508600001)(44832011)(8936002)(86362001)(38100700002)(2906002)(6666004)(38350700002)(54906003)(26005)(8676002)(5660300002)(83380400001)(6512007)(956004)(4326008)(316002)(52116002)(186003)(2616005)(66556008)(66476007)(66946007)(6506007)(1076003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WvwTsNWPZOcXKO3EBF5CPu3knaStr7cYJHoVYsVCS1p6hF7NjUAWASTQ8J24?=
 =?us-ascii?Q?brnH46xKwj1gVFlM2zpPzXDJZI7DyK2GFR8XKt0uQqKOjSd5TYky+Cav6J4W?=
 =?us-ascii?Q?fvlMu7eWCSsd8TbM/uIVwwlmDlf0QrKVOv9KbMe6Lhn37ot1X/9wCRVVQfMG?=
 =?us-ascii?Q?adh+djYB+7BmgwnirdfQGB/qdmLL5Bi7q4+1cYD0nNveq4w+skcoHBYWkXD7?=
 =?us-ascii?Q?GEdj5uMUA41r9YPXVAsgBdIvNsoBY8W/UtI4yPtqsoV7BhaA1wP8Qg6KQtUm?=
 =?us-ascii?Q?toytpSFI3jQY4rumjsWPjpEGcoJyzVUon0YauMSmpXjMuHuq3T1GxtYXtIJn?=
 =?us-ascii?Q?k7NcI44tRcU1BOFFdfdWPrTWmSRhnjJRyoCHeklCzAq6agb1fzCu4007bJ9C?=
 =?us-ascii?Q?deNORPgt5fsy0D7KgJuEfqh5oIT5fcAvcVtfU7bON+F8RUOCgZZopLZinP3J?=
 =?us-ascii?Q?E/rFU/VkdDtl5q8WipkkVbSpqqGJh0dkfUz5tIuOxS5PXsAOheIi9oUThBnx?=
 =?us-ascii?Q?gacA8kTpw+YNC0UZXm7JN6MtjjAUQQazzS2pCFIWtM/u5Yx0vIiaz2Q+iPxv?=
 =?us-ascii?Q?FCXssB2i/z5FkbOuPv3/krST2cyS75HwI0wkiQA6F85uLRLFUlAQSqOpRlTi?=
 =?us-ascii?Q?eTNcjj/6/kqXNV4l0MiiSWfktbG3Zm1sdRMFVlbXyquURobWf7TpOFo8Pl9I?=
 =?us-ascii?Q?EBJf2N4jqpzrM0BD/65fyHpl8EYkb1QxFuf+8HcM1gxz/GEIRJfjZbkqkcNE?=
 =?us-ascii?Q?gN2i4Jkj/tqVgXMpTCeKokFnjCCRDgwrACHOVd51p+IAGo+Gd7lsV9wr8Zc8?=
 =?us-ascii?Q?OYCjyx+mEO0vrtYfJu8d+XSU8eEk5P3B/lgrhQ7qknVAQWMIEV1d2NmE/nNw?=
 =?us-ascii?Q?05CGa/AnEtHRpF75lFWYjPkFaPU76Dymp28mfTFGwSKiskWc3aXzRIWbYvlo?=
 =?us-ascii?Q?CZ97RdWgGEGuQdFwAcLizeS60STufG+OBrFU9GYGJcpmNCsne7rWAVbstwp2?=
 =?us-ascii?Q?6sv9O6YaYdPMBQdZWI4WuWQxSYDQ5k3rUHUApdW6eBhRso0Cj4vHCvKrAE3P?=
 =?us-ascii?Q?f7pKtvb6jDqNUt1Jb2KAvtVLJyqONW2DfQDpfx2AR9LjFG3XDZ8A1JAeTf7n?=
 =?us-ascii?Q?N1eY/A32ZDHNMbV+4InuPzbAUFiTbXZo15ThDHFCsZHjq996sckiLyOGilmJ?=
 =?us-ascii?Q?9vHF61/f2QuLv3DNwnnDrfCwht722TA5TZmXiJ0q+T10ynCWmSSGr2m06Xf2?=
 =?us-ascii?Q?Xpw+7d54gracnhTw1zyW6Bu9lAZ2tXKfxTWnQrUhgz/pFM4C9kqsIFhhwYSz?=
 =?us-ascii?Q?Uhstyzv8AupqPFn8zU8TzOy39X7LfXB4UuFLq6GfvyHRNnGlgoDdVwYptT4A?=
 =?us-ascii?Q?m1gKg9RKTUoUxQqrr8pfly77XrHqkh40gNCwYmWP+2+e7hL8m7d+HJfBTREh?=
 =?us-ascii?Q?UmtTeKCCR50YcPEpZlPhdS2tCuEqjH2eW2MgnnCbAIucDlQOO6BKI8yWyRdk?=
 =?us-ascii?Q?lTlsh2PhDHvrWdSsN0Vetm2lCk66RTRozXanl5JcOy7JOFoQVeFd8zsI8kiQ?=
 =?us-ascii?Q?DvKlaRr55BwK2IXc788BcGOrsKzT1B1BAkP30NpGy/EBZ441W5RIjzos4Au3?=
 =?us-ascii?Q?mL4Tpw8QhnKPylZ6JTRQYvM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fcac5f0-ab56-47f1-2125-08d9b14a54b1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2021 02:05:05.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXBnaSSwfLsvxtrDJO81avrw4tyabe77EmRVmz9HkIMOM3tcdFRBm7Ucsgr05FNt+2xVgTF5aJ8d3o9KchdF4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The blamed patch attempted to do a trivial conversion of
map_mem_in_cams() by adding an extra "bool init" argument, but by
mistake, changed the way in which two call sites pass the other boolean
argument, "bool dry_run".

As a result, early_init_this_mmu() now calls map_mem_in_cams() with
dry_run=true, and setup_initial_memory_limit() calls with dry_run=false,
both of which are unintended changes.

This makes the kernel boot process hang here:

[    0.045211] e500 family performance monitor hardware support registered
[    0.051891] rcu: Hierarchical SRCU implementation.
[    0.057791] smp: Bringing up secondary CPUs ...

Issue noticed on a Freescale T1040.

Fixes: 52bda69ae8b5 ("powerpc/fsl_booke: Tell map_mem_in_cams() if init is done")
Cc: stable@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/powerpc/mm/nohash/tlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/nohash/tlb.c b/arch/powerpc/mm/nohash/tlb.c
index 89353d4f5604..647bf454a0fa 100644
--- a/arch/powerpc/mm/nohash/tlb.c
+++ b/arch/powerpc/mm/nohash/tlb.c
@@ -645,7 +645,7 @@ static void early_init_this_mmu(void)
 
 		if (map)
 			linear_map_top = map_mem_in_cams(linear_map_top,
-							 num_cams, true, true);
+							 num_cams, false, true);
 	}
 #endif
 
@@ -766,7 +766,7 @@ void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 		num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
 
 		linear_sz = map_mem_in_cams(first_memblock_size, num_cams,
-					    false, true);
+					    true, true);
 
 		ppc64_rma_size = min_t(u64, linear_sz, 0x40000000);
 	} else
-- 
2.25.1

