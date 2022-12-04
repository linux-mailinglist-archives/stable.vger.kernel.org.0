Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3751B641FF6
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 23:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiLDWJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 17:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLDWJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 17:09:05 -0500
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11022022.outbound.protection.outlook.com [40.93.200.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957B012602
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 14:09:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLtkoghx9Qimx8efF8LjFs6SEoro/gME9UKiuk+C+E95CXrNgQSbc5r0HMvOn9FPxngaqc7rHjyjUdk43igpe7LZd0sgSMojKG81fPHEv7I6E2OV6PuTQXGWmumCZhLbaGThEcBMceoZ3Ij/WoqMWw/gyJEFhBjfSAvjPeiRrA992pKkWKrQFQhsKa8ke456mg72e+ajFCjYT73URT24YBZsEf8FJbjLQWd38jlk7eHuEjiik5rL0uMYXyAypa4lPJM494msmbWG3AHGHmel5/niODOWCATQnfKEa1izWVEtRoxP4hhXSuwMNNY9pN4O1cVeU3pk8wTMmtnxbagXjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKK4IvdDzUR/uTka9aFCHbC9yP2285jheC/LMabrsqw=;
 b=LD+eeprpYJI80QbDw2NQq2mdBL0LplYt0mjYBKktxgFpcwaBg3QicfmdUNvxsnCQ1RNT1Q0cX7z9sXZBxcadkDiQQqEhp6Z0wRuygC7ZpNUxQQ+RSyB1sc/iGLcWN27vTWauNLBHDlBz+cq8oPGd2WDItf6KPQKG60SJiB008Y7K04RmhNhoGUAm1iNB6ol75uPEIeKZAUBW5Dw5XbmMc8bS+1ZdO6qZQ3Q6qAPnVI0XF4CJgdHEp9G/cvbOx2RmLEKiZR337X9kzYHk3ZL/B6dVgSSMk5SpbzWGy4yJr2vDG/Jt7jfhzAh1fZNthhvKrZjSxuUYg9XXGScLXQi4xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKK4IvdDzUR/uTka9aFCHbC9yP2285jheC/LMabrsqw=;
 b=Dw5qNu++SGPWdSZHtLrDrwNhwZSymLVrmZnkBfHfuTei53aFsOgQFYxLfJgsIw3B7DTjwloO7xtlS6hF7X4PgVBfzvYfxYmu7Ah6plWcHPhFXz7jEekfjCn9QITfEaSaclkAbg+CGRoucO9l7gHzB20pmxBJ1qb3XAaV/5ycOEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BYAPR21MB1320.namprd21.prod.outlook.com (2603:10b6:a03:115::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Sun, 4 Dec
 2022 22:09:00 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%8]) with mapi id 15.20.5924.004; Sun, 4 Dec 2022
 22:09:00 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     mikelley@microsoft.com, stable@vger.kernel.org
Cc:     bp@alien8.de, dave.hansen@linux.intel.com
Subject: Backported version of upstream commit 4dbd633e90e0
Date:   Sun,  4 Dec 2022 14:07:08 -0800
Message-Id: <1670191628-83759-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0003.namprd16.prod.outlook.com (2603:10b6:907::16)
 To DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BYAPR21MB1320:EE_
X-MS-Office365-Filtering-Correlation-Id: edc56d1b-e106-450a-dcce-08dad644255a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hk1TWydJBrSLhnl4zFhmmUIyvRxjSY0ajc7FRax0SWUKeV9H/jJDNvnzWyEl4ETH4xd/xFUOe7baPNn5mWJf9l7zeohuweTP1nlpSQKNg+MJn+QXrPtJe4UlSqDf2sDQt520lVd0Gb1BZrOe91wN1dS+Cw0SNakUSkQ2/cWL6W1fdfi6OjIhZdIVwYYoGA5Uf3nTnXreRUSWPyaQyVllWUuw/KGsJfbX1ijkD4g8M3C5UPQed+PJCiRbVHHSrQpXrmUe9NBLS6muQ7rZwlp/mc6L+/K035dtBFMLk3Oyli9tYsXsWgNOuOT//uO/39tJZjKGdGaakMufU1V8skvGoBuHlx+9StFkyUAKYbjI6TUANN61a2WLPnhyGhT10CA3OF0W9Z0BjQkfiZ7oh2tjZsPx7vYvNCoIHMbbD3rDiejgJSts8g8Q51I5Y6/CrpBoIrihgcXOcPhJqte811jVXcP/yBTQq2XkB1JOpTtDG6u3VLTooRmU7JSDDC8LMYsgCeF+//YapqebygUGuqbgO4UMLUhl/6vVwnIloNUiAK7iazfxMZEWZSCXhaOdA9rjVlzeP9yUXtjly9MpMITqdKSh+EPWnoINFGz2rmZTa6ler5ftQk2jS64iCq/mE6YU8jcQnY0Q5TWi5/jGSLluXdqZ8w63AfYqk+dft3KRNjJmzp3F+aisYo+RdCvIxHz7jUfLFx44hiTN12OxmFEZfhyHU423yXO1ezoMNBLOVrN41b3C0npdp80c+x5S62wx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199015)(8676002)(4326008)(41300700001)(5660300002)(66476007)(66946007)(66556008)(316002)(2906002)(8936002)(186003)(82950400001)(36756003)(478600001)(6486002)(82960400001)(53546011)(6506007)(10290500003)(52116002)(6512007)(26005)(2616005)(83380400001)(38100700002)(86362001)(38350700002)(98903001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPAmXvYqd7vpCPUEUHJ5Og3tWXrmO4ytSEC93cCOR7L+85ufXP7mvwdqinS2?=
 =?us-ascii?Q?oLXpcrtk56mSa3BeaI6UVqIaOYtCf22DaxbDgpmHkKVaV44QUfilSueFAYNL?=
 =?us-ascii?Q?oK2Da8EgV41rpgTeGHiXjzIchOz19RwU7Rcu3b9QIOfpmdenzucskMcQM5lb?=
 =?us-ascii?Q?laHOCdU+a6kgUnbju66Q19pmuhcyOwTZIKjoHqjQrSjHZirKOS4vgz8bCHHn?=
 =?us-ascii?Q?dqL15FPBpW8+GSLtE4PB4DxO9vHNGN8/YQvNIgyzF/3pFL5EtMRRjSA+aUYr?=
 =?us-ascii?Q?6SgY4BtMQ2RhKif7ZdHmcXN33dRWKFJu859E/VOOZw4HisehsX1K2WlBkB2J?=
 =?us-ascii?Q?NXzJBNEDO4+1qulJZa6ytFKw0D3JNMK4QnpgxRcdoiZdUjv53nxkFBU5M5Nb?=
 =?us-ascii?Q?VvHrfIvx99hB2KNh0xVZcCmQC/BvjdqNALD4LeD2tCdfVK22ovbYIuqY96OA?=
 =?us-ascii?Q?JcVaL9qg79wlbGHcT0aisZYynKpkQmtLQkCFBiebwsRO8GmnEhW/XgO6QwJo?=
 =?us-ascii?Q?V6kkOTJnjLyTtuJ3vrv079yGMRYnzdOW3syrpTvBpZO5L2adbGmGlv6FAYgA?=
 =?us-ascii?Q?HkU7HcDoz7rsC3WrCl4c0L1JX2xdRoNjTz1St/LkwPmv3gghGoQd+4lha7D5?=
 =?us-ascii?Q?6IYhIj/nI3DugIakYglP4xfa7u6pgHbhyFBi3sLySR7iv+E1/UVkt3KOjS6Q?=
 =?us-ascii?Q?rjluZmerYydeuLMpCZx+Weu/OzGl/QFfPrjwCr8W/x9gBjxCpl4UvlO0xkMw?=
 =?us-ascii?Q?c9rHTRK7m+LR4mhzVu0fylBXJy+3Xwd/GIfwKO8qdfg+2LzIDOQjOWtlWy1l?=
 =?us-ascii?Q?R2VLcZjRKdQF/kIER8ALce3KtqzX2IH90LtfvMDt6Vp7Qdw1UdiIORKw/U2h?=
 =?us-ascii?Q?Ufm1yu2K/vA8/6U6O1zbT/4iTTnA4xpkjovRZSTgLJZmMXcORW2e4V6vWRPY?=
 =?us-ascii?Q?fNVqiLbUnBjaeq6a4nnb7yu209tu3OI5DBw5IgO5xtdKuykSKiH3waSAsLkU?=
 =?us-ascii?Q?l3XTUBW8Z4+CqLS9IBDWRaX0LsHWHi7Ueg4CuzWeFNTLEtg5GicP+6zLfxfc?=
 =?us-ascii?Q?yMW+zbO4I/y2AJ5fh3Bw69cdVKqj8kpQA6iZpMXYkeQvwLDF89vvEIDm+6Uw?=
 =?us-ascii?Q?VljZwZGB+o4uRVieeRUerYDZcJ+tvXGX4zvejL/3cfHqKTwQ+j9q4NQ63qm0?=
 =?us-ascii?Q?1NURJFJrFKCR4nWwXiUkNZFMXpo2+flNlmGy4AuhG7+02a54Z3b0wxOvzvjU?=
 =?us-ascii?Q?z0GqdGBip8RcMLUCSsBAu91PBoPBzliP9I8WGdtG/L1nLXFT0IHkd6L+72z2?=
 =?us-ascii?Q?8/LBOKdCfe+a3flfni1VxRLqgzzITdHN0tmSvFJ/J6UJ5jo+MMo+pqNJC92t?=
 =?us-ascii?Q?EfHiqsw2EzUHKPYzp8E/e02dCjEq6B7de88E6o3XUD7Ednioujpde7lU0nv7?=
 =?us-ascii?Q?ozwKBSuuBj0ictH5yheYUqgU3W4DkjUgszM1MLuBKQ6aBmz+2x1W27zOT8lG?=
 =?us-ascii?Q?7ZL1pHXXdN3Z7tjfdVexi4mlxzPdNReJEfblakzNKMFfdaEeDU3SwGjxPwp4?=
 =?us-ascii?Q?X6337/M+5xoO1BDHXcq+DqEenrwwibw6oETMhp1G4cPhP47fmPjQdt0OUTd8?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc56d1b-e106-450a-dcce-08dad644255a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 22:09:00.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0WYOmqhWrmo9pDFFwFy1Dou/nbtZOq33ctkfIW0iBbeBQE7SMFkRMLR8XQvfW11BRt4S7ZhZE8rfesNEIBDpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1320
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here's a backported version of upstream commit ID
4dbd6a3e90e03130973688fd79e19425f720d999 that will work with
5.4, 4.19, 4.14, and 4.9.

Michael

-------------------------------------------------------------------------------------------

6f2e8eba629d29ffae0fc71c0cfd6b694ac4a5ec Mon Sep 17 00:00:00 2001
From: Michael Kelley <mikelley@microsoft.com>
Date: Sun, 4 Dec 2022 13:52:01 -0800
Subject: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in
 __ioremap_caller()

Current code re-calculates the size after aligning the starting and
ending physical addresses on a page boundary. But the re-calculation
also embeds the masking of high order bits that exceed the size of
the physical address space (via PHYSICAL_PAGE_MASK). If the masking
removes any high order bits, the size calculation results in a huge
value that is likely to immediately fail.

Fix this by re-calculating the page-aligned size first. Then mask any
high order bits using PHYSICAL_PAGE_MASK.

Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/mm/ioremap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ecae9ac..696fd6f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -126,9 +126,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {
-- 
1.8.3.1

