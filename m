Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507FC59BA7B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiHVHoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiHVHnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:43:52 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11013000.outbound.protection.outlook.com [52.101.64.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDA4B7F5;
        Mon, 22 Aug 2022 00:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOQB7amzd9w3guAFNIbmf9slgvnO9NzGRmXtxLZUK7FYM3rBrIMqybW7P4xDYAoyU3Sqw9xz6GfpdHP0TOcsLwzQWcX5ZRrSC0oawmgJSTccY508SVP4RedSDOT3Pn/b3VpNQeDTCkY4LsYaF9s0T3iojLmZ/K7ChfjRp1SSx7ZpFHZl4mYVo6QvLG1SeS2It66xgUmaFZ2O+3NJjmArfxwX4KDQMW8+AT8nX5l25wvGGQysa34QAOfo30ovDwWO+ozk/SZDAvinYvDqfyERChOGetKzAwn7IbedPXNTuefPviDBaZ+6ftQikcJnyN5YoHBMWYIfUeRm4mSXVr0X2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeXTxgoLvAHEIWwEwsaMzAMVhJQahuQl1xi9lYC4LKY=;
 b=JfuMTUb72FOKIrd1VLEv2bVK6Yop9h5jvgvXtr16ZGmCs46rkrbk/XShn7PwwvS0zkvOJXLNMbBVY/ihO0pbOfGThLyi3mMXnkpFxZV0jL1S9lT+8o+sG67xF/Xb7gqL5XOggwhvyuRmq9UT3LwdXijMsnuYxOqc6orKdxAcDSyN5k5ELWq7ahIaJANQ4iNQSdjz0Ro/onkUO5o+cEy2tt1wI3CN5beXjXfQDgqTR4ib81uPzwh8l5Ww1MpS3e1FQMKJPh6vAfRxzUnMY0wfZ3xyBegnJQ13gkzhkaREMtEcpIXd+ToKqLdBn4G/l64PWf1DaOKTmjhMmSftQ5+jPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeXTxgoLvAHEIWwEwsaMzAMVhJQahuQl1xi9lYC4LKY=;
 b=qm3g86Z6VbUc3JIyj7YvK4pU6IQGNNR+f7Uw8GecDJJDTvWq+MO+8xmJ/DeFKILUxLsk1cwFRhjo9dfqwx5DaehGHGpMHjzQK7dYGRVIyL7BdjtI3Bcgrp+Wgj7CHHxrz6MK3NABW80FKZe7TbKCueHHMH1iaxJeaj/K74soj7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:43:39 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:43:39 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v5.4.y 4/4] kernel/sched: Remove dl_boosted flag comment
Date:   Mon, 22 Aug 2022 13:09:42 +0530
Message-Id: <20220822073942.218045-5-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822073942.218045-1-ankitja@vmware.com>
References: <20220822073942.218045-1-ankitja@vmware.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a95f5ad-18ca-497a-01b2-08da84120760
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/a19OO2NSZHZ8yMqOxIrGd2oWXGgNNT5J5rn+NQnbl3qzltSiZhxcHQPNDT0YufZGTWoFkV/dL6AIrGFudB8YlTHJr82O23LnZCRPX//rkNGZVXU4sui/F9MHJcGc7s5wOgDS6OS+AOaK3uX+9yjhxCvRu+FkU3AofF8CBho/eJe38MmFVJWsNuyTfJy5D3a2/omrj8s/ZROouJ8NSOMKvhVRZpwxpBsszSMBHnHf28oy4vCBlrb8kHlmpUUNHhY6YWJGEbLrFLEl59St4yCC69JUf7zFV2mMCQo7eFhU4bZsTNVN1R4RT13h5Q3hU3QEAvQgH5OGTavzMPf5PQ7iXGnigzhLSZQV3eOUT2LF2U269pmykvIYXnEtzsqADmqX+erDnVOqROZDbCtAyHdukYqWrNLj0K+/4JV04+wp9SdN12l1iLXSDKVobmDIXQN90uoXP7zNl9rUez9TilBgMOGPVQ7jD/tca7AYuJf9oJJCCZQCdGeDKWEr/zwelGjKLyhMd76324uQWOwQa4EFI11UpOA/iI386abT7ABz3qywqWqZ7768GbtkrhvWXuToWZoELEv0VbDv5R/I3xb+hqg/2RxDnTX5C8jCAw2/Ozob4fLRcLsv89Ck2gxHcqMhAtjumDl+xM2EKAdBkQuV+3uROaYw7c4kyerqUmc6aiNSzSGoI2xg/EAnBr1tMWtgFQgsIBLJwAiREgJoKC3e9mV9RBM1DqhvYmwqigz/R3HaxorBZDWHPFjiOOP0UGtQTKTfP0I7gAi3f/jLKAVwXI8XHnKCiJRnOlScmUzbeoS7PFoyBPLsCfX1MT+OvASKOYEV/DL62AaEKp8qssO2F8XdHoxJi44zITfMp1ii12eTnRTlmK0TV5d8PxWqVIiLm8HDi6WPNJ5H6z6MAtTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GqP1QKmNBJv63ZDwRsbjNxwH+SwYu48h1prK8Gczsy/MhURgnF1EhnHFOVt1?=
 =?us-ascii?Q?+HVbFLY+0HOqv1U6zuC+9eNj8Sfr34W3UH1UUxosSZXfV8hmn0Zvbj4wE/W6?=
 =?us-ascii?Q?WQL+fZkx5XwauCsyQNp6dtnDb9ymcNJSq1Y8dHsuwe9D54x7rfz11SWmOXYm?=
 =?us-ascii?Q?1krg2sIC4BQSENBTkn78ET1DDUciL9MzufhOIPBz7FWFhfe6EeLl3iZAearB?=
 =?us-ascii?Q?lxhoaMrNht0etlA29dbjpNxi2I264h2zZRHDlvqZ/kFf1u+RAshU0Qf6a3Hh?=
 =?us-ascii?Q?8dmU5ZsI6m4LOG+IgYnf5oXOcR6rZoPngjwTCUb8AeLOnDfOTjWpT233djkN?=
 =?us-ascii?Q?AE2bdwzbTyDD6Db6O81mFZc4Haur1BXSjFpeNaHaprGWwPvnacWRMG0EmPeg?=
 =?us-ascii?Q?hHCrX8sLK5yzShyX/iY5q6nfo894OzMNf2kPpPw0H8zKpIxAM0yYSGjHQWPG?=
 =?us-ascii?Q?qg/MoJWxSVjm4NtykhzylQrBCWAZLpSMjw5QBYyfV8otwkYBv5+tvIXEAte5?=
 =?us-ascii?Q?CTaf07X1vAVONFuw7Qyncrb6SIWWbxM4TEItCMsavly9k56D43tQsCe2APKW?=
 =?us-ascii?Q?lQll73H9RT94iiZqN1CMwuOhChXHKCU7BkzTPFsiorCpMMAiTY4/fk3LHQEN?=
 =?us-ascii?Q?RF6c9MRO/a5zM4O1NVkKFgpo59Ga1mgCJQJwVf6ke2c7SsAvW8ZHyo2hy//i?=
 =?us-ascii?Q?AI+jy5gvhdQJ6+ubMWpGqzpfItqlkDX3uaHJS8hs74r0aj76cyujE1wJmNLX?=
 =?us-ascii?Q?vhfGyuXhh8NGhnfKz6tWltuPVhQ8+UMgdc6KKlnO3Tz62JcdzNqs3+8tPi4P?=
 =?us-ascii?Q?l5R8aMYJZ2crwxBIyzht7vVNK98JZk7H4AqivVbX8qm26uBu1+weXIA0umS/?=
 =?us-ascii?Q?Hn0y9bjQMPdT4QYXjRP/B/mODuCdlU/a3r3UFzsIop8AX4kAFbUHK6pCA3GV?=
 =?us-ascii?Q?4S6gpfiARrGq4GNrK9vg3A0e8M3AhSVwmVmvg8/ZpY8DJKILMA0/Ksf7jcBX?=
 =?us-ascii?Q?xbFU3KnJhDvWiYoYV1sS66hGxvpcSytpomd86ITMaCWmyChciPbDJQinCiSd?=
 =?us-ascii?Q?1PmtfR1Y4rG/tr/8SgIh5opJmuljaFeZYGgYLMbuZjkJVQeW/kuikoAmzbRX?=
 =?us-ascii?Q?1v20daQMsohdAbFp9Iv4Y6yDIKtuRaxvyXkBlLshe/Q1mWMfeeNWwT6xfp5W?=
 =?us-ascii?Q?rZVtX4JQqctzG/3e1DBfyTNCRR9ObMLrSB/eJhGI0AIIYA0qXU+q9F5fcpDx?=
 =?us-ascii?Q?vbEZJq11fKWYRhPxMGehZ2zJ2ORjLzUKOSRccIsSBSg49a8PPoQ/SbnqjK+Q?=
 =?us-ascii?Q?8ps8OrWkLO/c2udAN/xAUa2nydMnIwC2DOAAas1aJrRo3c7xaVd3z3JYsS6f?=
 =?us-ascii?Q?kpu6KkLzrBjyulAtv6BUNrjHhtnG7EOiTzWUVHbLv9auvP7gadCyXBXNNmOj?=
 =?us-ascii?Q?S0cBy+t3ZDuE/ue1UPsPcWCOi5vPKtRTttw8B91t/+mBQO743nGIqZV+SoAe?=
 =?us-ascii?Q?yrVl9Zl61+B0pTBpZgTL1j2H/cw6sfysQVQAwkUDkBEpTt9UxpZ5t20R4LWA?=
 =?us-ascii?Q?oH4uq/dKCXyJf/Nyp7ltK3jFJWJMrBXH7QNQk4nL?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a95f5ad-18ca-497a-01b2-08da84120760
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:43:39.6543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtiMELwRgAcwCj+xlDqmApVWMecTylMI6elgi5EvVt2D6qXuSlec9p3hZrGlvctUIwDo58qHognLFw9rTh1lSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Su <suhui_kernel@163.com>

commit 0e3872499de1a1230cef5221607d71aa09264bd5 upstream.

since commit 2279f540ea7d ("sched/deadline: Fix priority
inheritance with multiple scheduling classes"), we should not
keep it here.

Signed-off-by: Hui Su <suhui_kernel@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Link: https://lore.kernel.org/r/20220107095254.GA49258@localhost.localdomain
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 include/linux/sched.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b15958388672..d0e639497b10 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -526,10 +526,6 @@ struct sched_dl_entity {
 	 * task has to wait for a replenishment to be performed at the
 	 * next firing of dl_timer.
 	 *
-	 * @dl_boosted tells if we are boosted due to DI. If so we are
-	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section);
-	 *
 	 * @dl_yielded tells if task gave up the CPU before consuming
 	 * all its available runtime during the last job.
 	 *
-- 
2.34.1

