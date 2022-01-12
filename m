Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98C348C49D
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 14:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353440AbiALNR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 08:17:27 -0500
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:43166
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241124AbiALNRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 08:17:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PINe/kBL1EZHgAq7tdHYlCMpz4pp1lPva95T+its6gvLZRhB1jQD1vHpx5kUG+MBR4SjHAQ+xq4k0DHIUXpHlR85bDWXNWG+r1S7JxKfZvE7lXgDOXAaqicRhcWXHM1X6PJKbl5G9pgbrbS5VzHNQRdG4wIj1vNH6hs2tFLJOCOLb31LLcQh5z/5Fp5pHCAWeN4y52NtlUZmqk+wA4DmsNKTnMIJWP0SGCYOa/SzPSghsiaHeqHg9mFCiYxzjiO/K07iGeSqYYTXDKbAWHwDfwMdq/rT6KP75gytOmOZOYzNELGB2xZgeoUAsTPZTZneYukAYOzooLwSLIspK7EFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1tj/y7RO0JuXX2QKgbYe4B5IoaePBE1ksmcHEomXEA=;
 b=UKUSEukvcFL412isLPOkN/iI7K2M6dqdN3KxCC+nQ1GUpOHPspzSAnWCRqtPrnkAYedxneRmEEi4dUpphoIQfGJv+qR4BxEEhWMVFKbQZxOgMlLlktA3fvkA0Q1T6YsIRA2M2I8z+R1vMGBAikX6c25FKVYuM+kb6G+F/JirmYfnUV5pUxhs3XP88LqO7HHqN2+OQrPVUR1I0SVI7xmhsgShPEaXoyyBB5lhl5D9JRMvtcfNv7RI9Doeu6GoQujIzw0jLP2G57Bk+Ohoe0c7YjuyeG5c6mPSeltwY4bIN4Q8Tjgl7S2BMZhRSVexFwk/xnj7KafJ9uEFYOc3rm3L6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1tj/y7RO0JuXX2QKgbYe4B5IoaePBE1ksmcHEomXEA=;
 b=HM8VtpBaTxVgZyXCkYxTXV3KR6zQ5A0OZ4cMTkOYfUMD8NDX09DQlx5yfznzjC3EP76w/9+u5yh/PqoDd9zWiUmWegDAjTLHF3rZuq6WiEdHAACr4bhW/zz/h3GTF/p1PzWyV3G/p1/cm3MbD3eQOP3sdh7QSBDmWz25EO8IPTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
 by VE1PR04MB6383.eurprd04.prod.outlook.com (2603:10a6:803:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 13:17:22 +0000
Received: from AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10]) by AS8PR04MB8466.eurprd04.prod.outlook.com
 ([fe80::5c1a:a024:4c5c:9f10%8]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 13:17:21 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dongas86@gmail.com, jason.hui.liu@nxp.com, leoyang.li@nxp.com,
        abel.vesa@nxp.com, shawnguo@kernel.org, linux-imx@nxp.com,
        akpm@linux-foundation.org, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v2 0/2] mm: fix cma allocation fail sometimes
Date:   Wed, 12 Jan 2022 21:15:50 +0800
Message-Id: <20220112131552.3329380-1-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To AS8PR04MB8466.eurprd04.prod.outlook.com (2603:10a6:20b:349::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ead5d79a-0718-4f2b-3587-08d9d5cddd75
X-MS-TrafficTypeDiagnostic: VE1PR04MB6383:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB638384DC5F8D771FF820FC5780529@VE1PR04MB6383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TF4KO7S3xWupUNqKvD1OllXaI4d051Bw97bfMue0m80K4xeJvgfvAzB0anwSVYQT6hVzhLtekHlLMXcFXBT5ZEdn8xQO1YAVK8tbU9X8R56zRrpj7Uwj+RKq7pjND10h8K93zCM1RZV7HGX82dl0Rx2E5tuzzOGZeBdwxOiAIT50z5P6uCY9rzwePSF9tvjgb+tyn0BvtIwOhgnVQz79kmeck9JsGbaoaijVMdkdUaflcqQbYZPUir6Z8ckfWwTR2iyIHxBSxHM66ynaT+iKQaiJX/qzi3HGLczz6swli15Q+YTsDJC/tvC8nRHOfCeD7oE76jQJKA8LmrQ8wW++7iIcCRK4OIEE/YeyZTFBX1lEczHLOMAPj6ePCfNMPig7ZRIxBDKV9ytx4mVsjQwfH3k0yXm4p/PwO5uUiB+Bod2izuM80+azVea8e0kUgt7oexPVMi+oONMgJNyhmcTfBKQH+UhuMsf299ZgAggrfxXe9X68b40rxQIsyvzh22xE/vrxKBh2H9EABXnO/XgU2eNfSmEcFkKsHL3QxDooo+MJ8OAooEAV2myoX+KvBnVGH+vyR4RJF0ZIH84HgLIdv2swqmFgwe+4yne7VYjacK1jMhxbag/O5gdrqp8k1+nHD/wyyZUakI8uIpS0WPHvTyvGlOLtgr1Tnxb26zRrnu7uKmFnJdCCgeLEV/5PbT9XckVncqZg7p47ToEp57/Jk1Rn9SnAxwzhqcfMpR7dfyU31oxaGSk3lp8CwAX21n+AV3TycqHOENRtFYdaFZ2OJf9a/CnpDnrtTNYsQoS4mb0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8466.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(83380400001)(316002)(1076003)(52116002)(508600001)(66946007)(66556008)(66476007)(6512007)(186003)(4326008)(26005)(966005)(6506007)(5660300002)(6916009)(8936002)(2616005)(2906002)(8676002)(6666004)(6486002)(86362001)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mwYQNkMkfSL71c1OtewDUKDrntWTi1d/cZnd336+mN2HVQYK3F6pJZeRCoa2?=
 =?us-ascii?Q?CsggqeuJTUpe2q80757Bt5JT02sG+0elElCfwuwda+rW8Co3iUNNNs4zp098?=
 =?us-ascii?Q?AhongHdf96f/hY7DWlHTQDDzKHeviyg8x7c7d0KdCRmiJYK9XGz2189rnrx0?=
 =?us-ascii?Q?ur/M7HYA/+fOmw60Ql8nq34VBwNTNZmlBYhJoZU2tOfRQ3ehHlG1FRz94Wam?=
 =?us-ascii?Q?8o735GwF9zUmfXqyeAFfI6xzQiwUMJgS1rlX1cag7V2VBuZD9KVcXety4hCQ?=
 =?us-ascii?Q?x0eiVoGS3ZQjrNEATriEiIbWaKV94CHrk532JvY5SLRK5pH4ozn/TyVs0T7r?=
 =?us-ascii?Q?utbuXZpunC7LKLredbrRxsumqwH3hrfJd7i4E+y2Q1iH1sMe5GnYmZLEYci2?=
 =?us-ascii?Q?4lt7n+c+YYDUfrCXlp4/ySL5ZGZ9Dt8qhl312RhbECIJm7Fredt0QstUfsTd?=
 =?us-ascii?Q?I1fNOPV9/TZTl7SEDU4aPim0jy1+BaAqFxsoGNCb7SNsu1JafzjsnlSqwp65?=
 =?us-ascii?Q?4qp2WDV4ZmHR7YubMaX3F/pnVc/goz6Qf6QGOUPkkkL1k9QNQ1U91PzRW3wR?=
 =?us-ascii?Q?GkPQWRiJajnvoW0PuL+tcntzVBIgxPOFs8BUTjrq4YbSQdvV+M0IKp2kElcV?=
 =?us-ascii?Q?TSzLcul/tKDcxAFGTTMhSm9s2f8v4FC2N4rVONItn3lxpWwaYalvMRJLmsO9?=
 =?us-ascii?Q?iGPSLqKh6VJYI/HLWZ1dRishHFRjwOD57qEgzxKhCan3I0n/6tul5etvTMO0?=
 =?us-ascii?Q?C57Kfmjn4k24goZlBX0/cMO4RNg3XqVfCgDCRDOpNyVI08EUIfuXvEJQJgRd?=
 =?us-ascii?Q?P2cHNknTZrp50z1BEY86c4KcX7AOetAoaNhlW52M2FNrVmEF3pDkE6wcxB1R?=
 =?us-ascii?Q?BTT9KlWENtvbKdgNe1zROJk7vW4gekcx1g/+J553TwiItgqPQ/NwK09BQNf2?=
 =?us-ascii?Q?l4vqVcvH7A14X1KoGbC2XfD/jWPZI9Nfq4sltGLvtnCFacjF3xkuTTY+SzOX?=
 =?us-ascii?Q?igkS2CF8j21Mt8RZ8Uo1e2SZa6lufJatklyFX8glaiuzFq7B6cPW1OU8x9QN?=
 =?us-ascii?Q?unqyMl7pZ9Iu0uTN1JX2bKPBSIF2KWdXbem0nTmSivBo/+pN0rNQDfbjtFU4?=
 =?us-ascii?Q?w8qVjOnMWlwuYc82BffTXZzgcMhMpg25rAXFFHHtV8XDmnhmR4ue7CNc4RKS?=
 =?us-ascii?Q?1qR7lia8iUX07An23ef+ildjPaGSkyIB2tFL7nOKd8LinCV/6ARbhefhC1uw?=
 =?us-ascii?Q?Gmrk2Vofx+dcQf7Uw7DBKOxj3WsaPnQr8omGlymEtFZkFQI6AMSdZ6ADwsob?=
 =?us-ascii?Q?1DL5bqmrAxYuu9tY6B9EB+0nIoF8THHgnHWDPN/PjivzS78xokyaPAtkAnU4?=
 =?us-ascii?Q?U4SiPXNBzU9jSvthbAhItWSIENm6q8ufhZPtlS5xxVgbdV4zaInN0YDkwdYg?=
 =?us-ascii?Q?JPfJ/EqEaIXRpG9bqZAO1COiUjrqNRm8uZovTPh+gqhvUgiwqSMvmX3ziN4J?=
 =?us-ascii?Q?FRUzpwca8atMxYjLhSUhgwLZO8LrQJKLo1tu0AtcEp/OwN9BMK0L00Aq5U29?=
 =?us-ascii?Q?PzgyJOD0TqdTQkgzoX/5YwI9cfyyQCWhxXPucCEtvHtyqwmqRcYDDjPB+k8G?=
 =?us-ascii?Q?6NuTfaOKIBN3q3LlmS0Ewuw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead5d79a-0718-4f2b-3587-08d9d5cddd75
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8466.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 13:17:21.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skjM426jlEO7HW4CF+/aJNYToshDZn/TLLOcer0dRqfkwPLxVsHJHd7yXOaZ5lrStTWzBKzapklGr6JYAvsK/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6383
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
NOTE: MX6 has CONFIG_FORCE_MAX_ZONEORDER=14 which means MAX_ORDER is
13 (32M).

The root cause of this issue is that since commit a4efc174b382
("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
memory allocation.
It's possible that the pageblock process A try to alloc has already
been isolated by the allocation of process B during memory migration.

When there're multi process allocating CMA memory in parallel, it's
likely that other the remain pageblocks may have also been isolated,
then CMA alloc fail finally during the first round of scanning of the
whole available CMA bitmap.

This patchset introduces a retry mechanism to rescan CMA bitmap for -EBUSY
error in case the target pageblock may has been temporarily isolated
by others and released later.
It also improves the CMA allocation performance by trying the next
pageblock during reties rather than looping in the same pageblock
which is in -EBUSY state.

Theoretically, this issue can be easily reproduced on ARMv7 platforms
with big MAX_ORDER/pageblock 
e.g. 1G RAM(320M reserved CMA) and 32M pageblock ARM platform:
Page block order: 13
Pages per block:  8192

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

Dong Aisheng (2):
  mm: cma: fix allocation may fail sometimes
  mm: cma: try next MAX_ORDER_NR_PAGES during retry

 mm/cma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.25.1

