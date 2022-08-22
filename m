Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1C59BA8C
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiHVHrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiHVHrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:47:33 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11013000.outbound.protection.outlook.com [52.101.64.0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDCA2A72F;
        Mon, 22 Aug 2022 00:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWY2rA5LcThtrR67l7UnXd0o9nSzXkA0etOVJ4t8CKDmgxxqGuz08gQD0soNhL7vmTFWqPpiT4EYszTIxrJ/7Aawvl4jQqbz2FIzq/cNow233tfno0ADYDX1ccjxejcgcr840FPdyAM+YH2RujPRvxleMR/sqDq8d9w/tXBEjmKoU17FN2Nwa6dM6nJO+/qwxo7rkxxQVvf7oeJ7J7H3rov/Zm5JGsoEwPh1Or4peLSrHvZjnWnC2Uhu8cC2J5yG5PTr8IKfYgrKAKTIDddex/1da+wcegDx/f6Qe8dgvHx9Xu0HlS3ap+vrVWBWjYsHllkbddEBIW9+gad1RvrDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuZouGWUi2fldirclhIeEIDVRnLhj+WXUg4DXNZjsKw=;
 b=Wnc8b3mavJtwJvmlh3FN2OGXj8ginuwZTdJY7jrWQcjZWvPaMGlMaYwVu8CIgCmpZHh6mXK2NEnpsEaJCnqIog3w24+t/X4oJmEp8Hxlg3MO6/V+k8b6PnjQfEyHVKOx4ziZwiDJNuYNfuQdATESsuXaQVIOyff3lhoSDfZWJORWkvTKhiJItaOsw9XkRO0Ze9IrB+9Xx7EnxfML1CA54ZzTsW+ssnK9mSB1z3ucRtU013SOHyA2eSd4UrEPfUrGSIwOKF0DPmoPxrS84uiuiPqo6INyTgBnmxj4A1ZqklTL/PHvMUXUVuySCWfmTFWmCJDVGE07Uakzhdlg++uIHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuZouGWUi2fldirclhIeEIDVRnLhj+WXUg4DXNZjsKw=;
 b=u4bRlYEzR21Pr3KXdtody6s/X161a/S86gwTRn7U3B4p6Tl0ti5VN9csOOtKklcUMafqY/YNBhRvKEw0Wsn+c14qtTkMOUtKK9QA122ekmHtolNdjeWPw1gLcKR3w98lL6kdEgPQoXFIiTFmu3RUxTV4HzcvZyDIpvmh31p4fwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from SA1PR05MB8311.namprd05.prod.outlook.com (2603:10b6:806:1e2::19)
 by DM4PR05MB9253.namprd05.prod.outlook.com (2603:10b6:8:8c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.8; Mon, 22 Aug
 2022 07:47:28 +0000
Received: from SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d]) by SA1PR05MB8311.namprd05.prod.outlook.com
 ([fe80::c0a2:3165:1ca9:254d%7]) with mapi id 15.20.5566.014; Mon, 22 Aug 2022
 07:47:28 +0000
From:   Ankit Jain <ankitja@vmware.com>
To:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com,
        sturlapati@vmware.com, bordoloih@vmware.com, keerthanak@vmware.com,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH v4.19.y 4/4] kernel/sched: Remove dl_boosted flag comment
Date:   Mon, 22 Aug 2022 13:13:48 +0530
Message-Id: <20220822074348.218135-5-ankitja@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220822074348.218135-1-ankitja@vmware.com>
References: <20220822074348.218135-1-ankitja@vmware.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To SA1PR05MB8311.namprd05.prod.outlook.com
 (2603:10b6:806:1e2::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ad82378-a18b-42f8-d783-08da84128f97
X-MS-TrafficTypeDiagnostic: DM4PR05MB9253:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c6wEgWug2dILzUZq53N1iXm6l0OTcBsH4GDt8coX3DnDCta0llFnyozaNSnxczq+f9pnsKocqj9kj+tJKQtBstun46kw6rim5qKRWPOltoT9lvqf+rbgsNPgQH7cvVRT8YrEacmrDeh4/SfKtwXoKOrAc5lXxZomLxganKMnlEUGmic5lGgEnrdl34LGG5sN+6C0uxrnv0idGQjr8uRpszbFJLMbxsnUmbjFvTmDA2aGQBJxOfcH3Zqc9rNSoRhK8Z8iQpjrUU+9KKo49JZ/w+hqA+fVV9QLBZbCEcsCLD3zdYhvECB1QY6cC0b4rsb3QED2Qa+Cyy7krPCG3cQ1tdwfii8rxjUC3jk+Yyfih4cHffu+j3ec/IepB5p4sK/9FsGb7rPG79IjhUZlsP9m32FMGs3Ca2ZK8ifrgjCTaEOnO4ML7pZc7JRxAZlfBRYSV8i/+gnRiuvH5hL/OkoVCKaWYGD3KYDm+uGVQkXk26BbbiIZyPprigYFUSqzIyen/U7fjnHqcPAdvU/+1UpQ1bdIsulsuAT4HiuWbFMThj1f+l9bodVz0Faf3vYLlp7HVABXWhcz6BZSRUylX8X8n0c2Cl+pHwDILaq8IalKft3W1q8Y//E4FMASUQJlZvsnrAfskyY+/dm9gyViemG6m687v0MIl59PnD7R/ViBw8nkz0bQ1zKfRBbEeTUdth5SddXgZaMTcvSp6Ptq8Xew9U17w1qTXm6TEgztOpIpvlbUlPIuJ1vgUW+jDU1BXruqqAXDN90eeXbGLsssOERzBcnVCeELxlZw2NyQNC/LJUY+zuMzYNO5uSIjSbaN/7L7/qUPBCzjoK4wFA7HG8Fsp0z4QZ7+/8P53QbjTYp+lDwe1KncFPXgL0uYB2gZ9+8EYrX6qI8EWcUGZ3vH06ZO9zoQ/qo2ClsYpIrUBq2zZRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8311.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(86362001)(6666004)(83380400001)(36756003)(38350700002)(38100700002)(2616005)(52116002)(6506007)(26005)(921005)(186003)(1076003)(6512007)(478600001)(6486002)(107886003)(966005)(2906002)(4326008)(41300700001)(66946007)(5660300002)(7416002)(66556008)(8676002)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AvW7F6P4acz4refLeXFjI/yYrUaQdhnTbnB5Bsst2u9U1l7g/+hELsNT9mcs?=
 =?us-ascii?Q?4OWDd4o5SWrM2HH2SELfQp94Aoad97SUFGntv62lFB+ns7OREJKhXNsMdfJd?=
 =?us-ascii?Q?gXADKvSZQdG2+p8MRzxVPZvjFsfczSsfyP46p3S819csbnHd7nw/YuZ7AySh?=
 =?us-ascii?Q?tB49ubi0Zc0+u3LJY8v1Vrvo4LzsUp8r+ekl1CxD6OC3dfdk+ihwU6sGurGf?=
 =?us-ascii?Q?00otxTvCmgXXDiDLrA7SFkQrKon05r+pqs5IWPFu8940oaXz614UPQqojXZG?=
 =?us-ascii?Q?B6t3xOVV0dqCsQ3USiadKQvI3iXaaP4+MeGg2WNEym7UfG00wx25FM/7Id4e?=
 =?us-ascii?Q?uA8sWgqW7Mx8mqJk6J77HmJ/1NiEu2PD8dZP3LsXPXkuOjqnosbQuk2m9bxk?=
 =?us-ascii?Q?hza9apYn4SDvhBZ27c4zprbt1QfA6YhfG0clZVXwCB1v82z80IkSo123b+um?=
 =?us-ascii?Q?peh10WY2j6o3/KIKi+jliYSlPWtOzkY4FhHooPD0VsjFp1/UZBTIdph2og3g?=
 =?us-ascii?Q?anP1gf4TuolqmTDiJtyndWTpCjEt8Ie5cGQpAiIRQaHjZGda5kiSvOkDTiWm?=
 =?us-ascii?Q?4EM76d+mNfYz06Hc0U9EkcX3F/BZuqyuKi/8KjVed26+TIJBj6aX6ZN40EZN?=
 =?us-ascii?Q?c+CEEgzoki4q/djKTLfsPjsDI6bJxcZPzApCQvJWXqJY3xY7jU5wQTYs3HRa?=
 =?us-ascii?Q?pX8qDt4pAZu765W4fQK3dRI8recf7tQFx9iq+oFXH6Pu1hO3l2pOiFXxpRg+?=
 =?us-ascii?Q?OaaLbDfFrdomSJ3d4kNEswOhhxa1ac06VyTjm+Qnf1P8lvMdWTprft26P64l?=
 =?us-ascii?Q?2vAeOqovQME2nWUk1jBeUXrKrcCrpmOTs+/5FEPJEhXpF899gjUoSn77viQz?=
 =?us-ascii?Q?MKNvAuFv4YW8UZBVpOv7+NHzxO4WS30jDq7KO0zLDF+w+j9KZnD0kWyBbVDl?=
 =?us-ascii?Q?45RxNCMkg8dE9mXw+hrmvo5Urs6p+BdrEjcRtwrBk/B8ULd58YqNtBVrlb7u?=
 =?us-ascii?Q?wgOu9BYPAs+ok4m6H1ZYXBlMpPvOIE40mU9Z7VJpsbguQuyJNwRLD9XQD8u3?=
 =?us-ascii?Q?9XNN8O9J/2xfGjq2k8q7dWa1t4SLTqJlGOg1kX74ElUm9jx7IXamZLmKP1SK?=
 =?us-ascii?Q?C2a2wwrlfQssrOwBuUE8Fgg4ScJF5BqBqSduu+hSg+q3q/dWB2O46aGn404N?=
 =?us-ascii?Q?VSaK6rwawImSW7cCHStNp57K0wbqTCgqNg+1nzFO7I2awGBkqNZEvAQ8DdYJ?=
 =?us-ascii?Q?0/SSNjOX7qs9rPH9AGdGaSQvY/CeHLEtJEqhzeGUYveB4a0AU2LsVOisaRxO?=
 =?us-ascii?Q?Wm6hNisu01ZesFSBzzhQ/jKATjoQ3BHpZFHQzBU90BALCl5pgcXgxUM8cE6Q?=
 =?us-ascii?Q?DLLz+stdl5yCILPZpkpMOYGCZdP8UoBYX5/TM28ZF8Z8j3ChtkyFChYPKtoI?=
 =?us-ascii?Q?XlHNxXw7RyemyEF5m8bH4gej1cgwBofOUA+vLkVE79MyDzdFGCJ+KQY8ywQf?=
 =?us-ascii?Q?1SuojoOQlclavKusz1hj2hodHEnqKIMORM3TUxU0hhQZtkGwztA3QwJXZxRR?=
 =?us-ascii?Q?29vOTMTgv0juzPiCKQG0CPusppIYcMIoSkx2TGFX?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad82378-a18b-42f8-d783-08da84128f97
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8311.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 07:47:28.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKE8XW2qFxZ3qiuBji5ZAu+hO/ddppD6M9v7FLDuldOUs7hLm0aRU27BG3hmTbNc6qfmvWLvWZoyqGPbIqcYPw==
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
[Ankit: Regenerated the patch for v4.19.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
---
 include/linux/sched.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2ed820558da1..bc04745da6c1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -528,10 +528,6 @@ struct sched_dl_entity {
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

