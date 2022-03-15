Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78BC4D9DF9
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 15:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiCOOoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 10:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiCOOoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 10:44:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2088.outbound.protection.outlook.com [40.107.20.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A6D6476;
        Tue, 15 Mar 2022 07:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os3K7rj5V0+KyXpyUz+0fQQxF7EWrjA1/AndH3pBcC/jcxH1D+D4vTnsl96XrKNiVX0beGqw5B1T9VB/Sp0vtAa4BzIPF/Hcy/tBUJkqvkcQRfrpE8AnEcHCaYiFY699XeH/GvUKoRfOwPnepVlsmDgq7ZyfDI/7JfHiuvtksH0arQaj5f24opjj/y7kGvq1CNUJvBL2QF5YdR8trKkSsNd9RRtHz4zEYck4W4XakTt5GO6F2ujGzFKNWOUl18yqZc6TX8x66tSfJG95x9XmHEqM+ePLxEZiR/9QMDSIjPFoBxA0NWE1wgjyj0LlZaiPyhZ1UPI4AGquSmSsyhnQSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4wW79Abih2ZFPjhr3jdqzW+tjHFCjQq022uwBzEBlY=;
 b=Mpp2anwOwv7Z8amAf1AWgw9zZ5f4Etp6XwD07nmCc7GfwWjYJhbSXqGFVU/CuRRLs4WM04pJ82H/7FFON9PjWJJiF+O80rm/ibsrIfhdZFJqbQw81pV7yLto6TNAj7afOOxUWppsna9jcICFGmJfPzyCEaGxM4GTom8mw2CRU51zZXF85HROsWpoinEkY1mOHVycle3n6ILDmPUnpA7q8VT4Km6aRXIE7ZcZRODMv6mB7itR29fJ0RE8isRGErpv1RTOxJPe4IgyaHcEwQSCD1E8sTWFDt4AWhJD3+mngExHv6FBd6kb+D2JjIZ2fw/yZdfSld/8myN+WB9vkVMosw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4wW79Abih2ZFPjhr3jdqzW+tjHFCjQq022uwBzEBlY=;
 b=nrYVt0IdDWxJbdOGnqlDdmQpThDDV9thafrSaK7+gwxbu2UN+IW91Fjg8F2l5eIDM8/I4md1uHN933TotXBKRaCzqpFSoaVurIcsuYPa4ZFSgoak/+zDE3eV8iPX7IMCnPNU2g0NYKQ5GXeOoX3JS8BaHolFAkTHhTUwT7c9Ny0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by AM0PR04MB5041.eurprd04.prod.outlook.com (2603:10a6:208:bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Tue, 15 Mar
 2022 14:43:38 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::110a:dc6e:bd9c:3529%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 14:43:38 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v3 0/2] mm: fix cma allocation fail sometimes
Date:   Tue, 15 Mar 2022 22:45:19 +0800
Message-Id: <20220315144521.3810298-1-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To DB9PR04MB8477.eurprd04.prod.outlook.com
 (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d27096f-6d2f-4c54-96b8-08da0692307c
X-MS-TrafficTypeDiagnostic: AM0PR04MB5041:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB50412A83B54353F99E495E9980109@AM0PR04MB5041.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7tsFN9nQqhiH/Fa7fcs8/lxe7qovlCRRA0/XS9km6H1QWVMPtv3wV3MfXPKFpLGcg9qZe0er0DUgEi6MzdHEWYLH9zaCyz/hwg8Gvly4pi5WXw9EqHa0WTilAIdlJhz+ERVV+0MeiuwFMeskPIsSZok1SYYQonU04h7nroS8bz1+0XD8LP6Guq+4cnEughJwhSDyPCfwTvzo06MrBdBvgd30+kR3/VijIYFVIJJCmdKuOmR8LJeQlZeEZBH1j4d4gWXvDjAu4Hv/x2Cm4/DSGpB46x6aKNHsDJ0C6BqtpPJLnVDDUYxZila+eQHcPI2/h0wtpH2r70wy7awBLO8rjdK8wiWf1vE0k/YqHGCnOSntecV0rIhfqbs4vzy3JANOpnaRj9ofRxq2m/nD3tN3Zk2viqL7NrEj+TK0Q/lxs9DtyDsEuaSdzlJocaG+QWARgtU2z4GOQe9/ImMR9UZGDoVIEwAjlMWkMr0DcNIqPAWLg5uXQTxnr6knWV/MY2MIybPFzQtSvrlc6/SQZS58ByCZaem65GRq00ZQz2hFE7yGxvcD1dIEGIg8kWIJtyHbxdUK3eA9ADuAKitE68RknyG6rPSDMpcyoxtg9AXgagW3rUtgMNLwTrY12CFIeGfX5Nv9jeD4vxH3ZW7wc/S8iqoYK01MDq90J8PeuQbLdKoEHHYxayOcKlDXxcouSq0THMDNuvBMa2jsUMB16+ACxPQ1qQvhL2RDOGrhR9yqsf4RBhCB1pV+3FmfcEMuqeZUooPWhSvUV73gK/vxtsEDMafqyAh6pVII3u25TPLUzOsa8xym4ycpo8l7Brvic/XRCZAch3lgM3bAghqrdHGYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(36756003)(83380400001)(26005)(186003)(52116002)(7416002)(5660300002)(6916009)(86362001)(6666004)(8936002)(6512007)(2906002)(2616005)(316002)(38350700002)(38100700002)(6486002)(1076003)(66946007)(508600001)(66556008)(66476007)(966005)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fR6yxbm0+6kIDJPvvehN/XMlQAZGOaRYctgEFXv17Zq2AmatuTWM635R2vkb?=
 =?us-ascii?Q?gmMmMxXRLTj10eHUJy1NphZ5NV8vLHAN8axPWkTwaFTfMLYe79zibqVfXb0d?=
 =?us-ascii?Q?R7fCaB2zhMZQdqSlpk+5VBPVYVNjufa7NWCeYVUU1nflCANC/uvush/+jwvX?=
 =?us-ascii?Q?cbIBndSDtkG6rwfIFaWjloP4nOkymF0BJEsWCGdjYgtxJ6ZxhL7V7qZ6mFly?=
 =?us-ascii?Q?oV13EBcPfxAua/B54b7oVJky+Sig3/Sx4Ei6S3GXPysa7xOGozraG4SpftF3?=
 =?us-ascii?Q?WDWd5RidZmlV+xyAkgaq/wFKEukc1bsKPwF1KICMZ8Mk97lb/eEwTRDVPNGn?=
 =?us-ascii?Q?Uzao2eVHwyFPY2sDOidTmY33jVE2VwfSe7AdGP2eDTS55vkdkHAuI1cQzOU/?=
 =?us-ascii?Q?k1ZtmnIdiqwPGdAaQ9RCPw0jFop/8rzKYwN+8FtsBo1fj5OcCFkOM5ogCSTG?=
 =?us-ascii?Q?EAD62tAmuOnRXYm7Tz9ntX3FCatOuN0DwoZC4ctctFrWMZupnXxN+whD53js?=
 =?us-ascii?Q?yMpVyBCKxt4UppckxBZr+sdjOsPDIabVebnUvbCHLIzOh+yweCf7589lWq3f?=
 =?us-ascii?Q?mL5wnXe/K//4Ahf5PMowlwTS3ORe9GzJDeU7wpgKVxwsMNYG/DGxdrLuOAvG?=
 =?us-ascii?Q?BUBbXmEgjrZF6SOqmZfTsQvItp0g+LezbcRhUiJCQjGJqCZL13SZ4ma9gdSD?=
 =?us-ascii?Q?h/6v2VeR8GQrgZqKQ0nSv6BahBmXmjJuhYh1cqmhj10tM3Vl2lopwEYc24oi?=
 =?us-ascii?Q?RPS4JdN5hXgBe6AsJ2qEjxxlUWBp5+Bk4/0NdOwweA9kqjCsMYu4QimLePVq?=
 =?us-ascii?Q?y8VghsAfjisuwqZlMWh/1+yu94hA+yuLIFS2NEYTC781YKMU1C5PNTBalZqC?=
 =?us-ascii?Q?tH3CPcedF+qJaIugo7quTmsElckge1TJsucy+wllKjbTL+kK1jSznf5CyyF4?=
 =?us-ascii?Q?VzbR+bvnewggREOeTV5RSJpBVQ9ROv7w2A2C08IcTbF/6iZs3gBHeS0KpH9I?=
 =?us-ascii?Q?U4ny9i1wOHl0jF9iKO8xaGvrSXKTNugnVimNchEVYkLzOFg5/JIJkqbo2Wg8?=
 =?us-ascii?Q?q3BI/Upd2OUvf5FNXqYvyVp2bDFEKY9R4MMvTMkU8DuUmx2NpHPNktk8QFWz?=
 =?us-ascii?Q?cPTlQke6h+K2DN8kIQ58tCWJUKP9EZco6O2a6JAtLghw4ETSFUcjnn3FmTg4?=
 =?us-ascii?Q?soatlOANIdv3b80DOtyjjauCPz2VkBW5pOC2wlKbDk8d6uKoJ+g+LOhsOX5W?=
 =?us-ascii?Q?JT//aJ46sIKWc1Oy0JhoF75bMkeeypIquT2Dzb44D6r34iytEnBHK2kQvOXX?=
 =?us-ascii?Q?GeK22HGXbRBCLhVw1RcISF2aarQSfIy26og1fH0mJtKJuWV+RBd4kVZNmR/9?=
 =?us-ascii?Q?fcuvXemWcbJs557tU0lrxcw+K6E/ZLWVRUrUWQZZx4lqJcMP4mUS5IChibBx?=
 =?us-ascii?Q?Mfvi3QIIUgwT9U913WDfzE078EwmF27I?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d27096f-6d2f-4c54-96b8-08da0692307c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 14:43:37.9172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7Qgf/x05IPvBdQGYcYiUa1TSSQbA4FKg3Jx6+yQMecfbIHfh1HmSs6srT4O6hyktg4xfUcyWGbK5ulJpuNh1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5041
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We observed an issue with NXP 5.15 LTS kernel that dma_alloc_coherent()
may fail sometimes when there're multiple processes trying to allocate
CMA memory.

This issue can be very easily reproduced on MX6Q SDB board with latest
linux-next kernel by writing a test module creating 16 or 32 threads
allocating random size of CMA memory in parallel at the background.
Or simply enabling CONFIG_CMA_DEBUG, you can see endless of CMA alloc
retries during booting:
[    1.452124] cma: cma_alloc(): memory range at (ptrval) is busy,retrying
....
(thousands of reties)

The root cause of this issue is that since commit a4efc174b382
("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
memory allocation.
It's possible that the memory range process A try to alloc has already
been isolated by the allocation of process B during memory migration.

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

This patchset introduces a retry mechanism to rescan CMA bitmap for -EBUSY
error in case the target pageblock may has been temporarily isolated
by others and released later.

It also improves the CMA allocation performance by trying the next
MAX_ORDER_NR_PAGES range during reties rather than looping within the
same isolated range in small steps which wasting CPU mips.

The following test is based on linux-next: next-20211213.

Without the fix, it's easily fail.
# insmod cma_alloc.ko pnum=16
[  274.322369] CMA alloc test enter: thread number: 16
[  274.329948] cpu: 0, pid: 692, index 4 pages 144
[  274.330143] cpu: 1, pid: 694, index 2 pages 44
[  274.330359] cpu: 2, pid: 695, index 7 pages 757
[  274.330760] cpu: 2, pid: 696, index 4 pages 144
[  274.330974] cpu: 2, pid: 697, index 6 pages 512
[  274.331223] cpu: 2, pid: 698, index 6 pages 512
[  274.331499] cpu: 2, pid: 699, index 2 pages 44
[  274.332228] cpu: 2, pid: 700, index 0 pages 7
[  274.337421] cpu: 0, pid: 701, index 1 pages 38
[  274.337618] cpu: 2, pid: 702, index 0 pages 7
[  274.344669] cpu: 1, pid: 703, index 0 pages 7
[  274.344807] cpu: 3, pid: 704, index 6 pages 512
[  274.348269] cpu: 2, pid: 705, index 5 pages 148
[  274.349490] cma: cma_alloc: reserved: alloc failed, req-size: 38 pages, ret: -16
[  274.366292] cpu: 1, pid: 706, index 4 pages 144
[  274.366562] cpu: 0, pid: 707, index 3 pages 128
[  274.367356] cma: cma_alloc: reserved: alloc failed, req-size: 128 pages, ret: -16
[  274.367370] cpu: 0, pid: 707, index 3 pages 128 failed
[  274.371148] cma: cma_alloc: reserved: alloc failed, req-size: 148 pages, ret: -16
[  274.375348] cma: cma_alloc: reserved: alloc failed, req-size: 144 pages, ret: -16
[  274.384256] cpu: 2, pid: 708, index 0 pages 7
....

With the fix, 32 threads allocating in parallel can pass overnight
stress test.

root@imx6qpdlsolox:~# insmod cma_alloc.ko pnum=32
[  112.976809] cma_alloc: loading out-of-tree module taints kernel.
[  112.984128] CMA alloc test enter: thread number: 32
[  112.989748] cpu: 2, pid: 707, index 6 pages 512
[  112.994342] cpu: 1, pid: 708, index 6 pages 512
[  112.995162] cpu: 0, pid: 709, index 3 pages 128
[  112.995867] cpu: 2, pid: 710, index 0 pages 7
[  112.995910] cpu: 3, pid: 711, index 2 pages 44
[  112.996005] cpu: 3, pid: 712, index 7 pages 757
[  112.996098] cpu: 3, pid: 713, index 7 pages 757
...
[41877.368163] cpu: 1, pid: 737, index 2 pages 44
[41877.369388] cpu: 1, pid: 736, index 3 pages 128
[41878.486516] cpu: 0, pid: 737, index 2 pages 44
[41878.486515] cpu: 2, pid: 739, index 4 pages 144
[41878.486622] cpu: 1, pid: 736, index 3 pages 128
[41878.486948] cpu: 2, pid: 735, index 7 pages 757
[41878.487279] cpu: 2, pid: 738, index 4 pages 144
[41879.526603] cpu: 1, pid: 739, index 3 pages 128
[41879.606491] cpu: 2, pid: 737, index 3 pages 128
[41879.606550] cpu: 0, pid: 736, index 0 pages 7
[41879.612271] cpu: 2, pid: 738, index 4 pages 144
...
v1:
https://patchwork.kernel.org/project/linux-mm/cover/20211215080242.3034856-1-aisheng.dong@nxp.com/

v2:
https://patchwork.kernel.org/project/linux-mm/cover/20220112131552.3329380-1-aisheng.dong@nxp.com/

Dong Aisheng (2):
  mm: cma: fix allocation may fail sometimes
  mm: cma: try next MAX_ORDER_NR_PAGES during retry

 mm/cma.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

-- 
2.25.1

