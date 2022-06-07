Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B226253F534
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiFGEqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiFGEqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:46:08 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2997C15B;
        Mon,  6 Jun 2022 21:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaRoz9z+csCkIuYj4cIKkZM+qeitaGzWR1FgD07QTnk8lh0P9aovGn/Oc6nIrk7wlwr6n+DimoQFtPVFuspajB9XnQWKfQmmsHkhIjnKwoRvfK6wvXDjuH2mf7dC8OkeppLzwb7b1K++oIpkSQ4jvzivMg5R2nhtZfTBdN5K/tpNVyL9td+t/pQC7jwNz++/fSozy8rN+Y6eRloW4gf0PA2iNcVMJQHWUXVRFa3ov1ohc/FO6phuVfez0lxdo3vPKPL+RZk/E/m0CGwbV7gTqWWD31GzTdhiinDRBpbJ63HNv0TssFnRHGmwe1zZqfjpLiXRPY7rVQtJ/xOUB2zwmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKnucxXa3+7n9mLhrkY97tpmPKHgUsHJSs4+sdhNPR8=;
 b=Zljo3dvzamccL4+5A/BA7qsEH/lAc92aPBw/ZNgBlUzeHixseiHbEpLNYu7unkAA+Krj+wQrj8Y30/HWtKfW3yRELDRhh3zNK2IYoaG/Wh45nZiA9vv5txFH5cc/1WUdy+v9amA8aoJF9cPrJU7WfOy5kNYS9wlB2wojCqxDwwCOoZ2kTx2VcdcPCxAHhoOYXOaPZg/j8Z43A3Ys7kVhnj2wmLeqpJ0+ARZ1GFyu4BobBXgIK4FXbJMI/8zcIxBVrytxNT28IoatiXbOccic7blTDyo41rbtcQoHUB/061RroqFw+CcoRe9FancTbsOpfYnRzA4O9qVosr5Z3J/u6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKnucxXa3+7n9mLhrkY97tpmPKHgUsHJSs4+sdhNPR8=;
 b=wYXSZi+JF7c/GbmX5jB117/qKuzwl/aL9hmKHQ7Wu6AiwTPY2kj5KvgxSa9eK9HiSJoMyStNYQuws+z4mVXjnkD7hnHEjStqd0SH6xQu33C7VeohJSq1t0VOh5lXLDZvHJ4lMtNfRhDspTSTsTf9/Bl/8N0kghdczvQW808PScA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by SA1PR05MB8470.namprd05.prod.outlook.com (2603:10b6:806:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Tue, 7 Jun
 2022 04:46:05 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416%4]) with mapi id 15.20.5332.009; Tue, 7 Jun 2022
 04:46:05 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     stable@vger.kernel.org, pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v4.9.y] netfilter: nf_tables: disallow non-stateful expression in sets earlier
Date:   Tue,  7 Jun 2022 09:55:21 +0530
Message-Id: <1654575921-2590-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0144.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::29) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ef0b993-2c3f-4922-570e-08da4840a14b
X-MS-TrafficTypeDiagnostic: SA1PR05MB8470:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-Microsoft-Antispam-PRVS: <SA1PR05MB847004D52E5C15E8C80BF4BBBBA59@SA1PR05MB8470.namprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4IlMnRr5v3Kr+ZRaxxnTEdwrsk4IUTLxOfDX13yP6TwbgUHFb2zMuqFA6DofB1P+2floZwqJXlxEbaTdAKN5Z28Z7OT7ZRp3WA1W9mhsfd+qReAgDQZgJYSpyL44/qWfFXlxRn6p0t2qTNdRV4hdPh5I3sUdFaA32coRY3pSfQHopBb9O+RyO4uQhL43mZ5zO0P3zgJjm8LLSpJp4Zw/uDz1eN1xe3RS/V6f6wBOxez1BkLBuysiR0/kOJUjjdIGLRWp8OkHd+3VXNIZcPOEbPjUpTDDP49iG7h2TloMH85P9JzETZMbS3ckdnij01croFnHj6izQIOLaezcVPzrkPeSEcupG0P82ff9pEN6U2lN7bDGZeJF0qFSGSaH1d4kYjQpFFxFGlPgnVCfm8yLC9Pm3yG5ibNSMeEk04ubwJpU6WcgR8TKIorMSjhXTP2L0EO4evW/Lpn4B1xW5IsTUgG5Bn/vh+eyDnoM8WZbbML0m0Q4ABUbRaUFxXZFFx7x7kXjB2o49iekOtK1styZwX8EFjpZSKTGyMKL3+c/6lq0exYV7MeJsL9nodIiUa6ynsrIKgrMX6tiCa9usn5dviWl8qAbwNRJhzj2tLjlafEm6IbRQjyAA5P6IBlpUrWGf25ivHmhpO5GJLcjf3nUMk8K2818/JIoBMIhIir6QMePxW9xBms+Z93KOJlJYJe8TxZPSRV7vi9OzFlbqsSgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(36756003)(2616005)(107886003)(186003)(2906002)(83380400001)(86362001)(6666004)(66556008)(8676002)(66476007)(66946007)(4326008)(8936002)(5660300002)(316002)(6486002)(26005)(38100700002)(38350700002)(6512007)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ONeV54vM98kLgb7FUcNL7P3bO78ZEgwTrX/LSxMBqC+hcZeKcBh39srIDOkP?=
 =?us-ascii?Q?Qcu3HlDdS/1AjVK6URcdsN8Oi7GLdVZWt6GPv3MYBl+rYzeOgMBVwCJSOfQO?=
 =?us-ascii?Q?A5RCplgn07sX+TbTIEsDLaTAVWa+gCGh3KQaoOmrt1KzqISO4Yv0zMtJroaA?=
 =?us-ascii?Q?ujzijz2brxE4SwLaNkMw1byySSHNQhc79jzj7l79wM7w15960jcHaW3t8teX?=
 =?us-ascii?Q?GASv0hyoRsl5kOLcMnszqsF4QlfU6I61TyzFi2gcD4wgQHOseg2p08/wzCb0?=
 =?us-ascii?Q?+JafXUFb9FaU8G160qYCWec+/cdoZJQ4nhnwtcy5uK0h/nKIkT4rPOURwa2Q?=
 =?us-ascii?Q?o8Vrhobs1i75Lpa+KBKhVtW5BU60HK1Bf41S8IgB6GEwvT92EJ1krTdc8Gn/?=
 =?us-ascii?Q?Q7tZBtr9rgcDMlYpeUyyZ/l4jSvMDeYCTI1v8O3HFf7fAc3A5IT7iJQekXeU?=
 =?us-ascii?Q?Taa2XBP8mtCwc2TqXCVieVxsqOMrzB29CgIcRdbz9UH/N9fOW0+IAPLPGM1w?=
 =?us-ascii?Q?9wJXVIo6q+/iVyGCmpIJPtVGYD2QAbKpSLew+F1JDYTlIJ3jDlxkI1T/NSZG?=
 =?us-ascii?Q?9WDmBG1PanPx8f+BChfwE1gHY7muIiQRrqrSxqKvDvMHBp+sKsbcsOX4EHxc?=
 =?us-ascii?Q?62i96pED/XGLKlA90nPRLSOkCfeNaUT/PipnGvF0D2DDELzkAURaC5Ba6irF?=
 =?us-ascii?Q?wsOQimYwmvNwxx+xXn5zpNm7Dj9+ccJAsxa5CwdOXYgfNVU/gaIgYw9vqUa3?=
 =?us-ascii?Q?8FEXBj88vG0nAAx6/fz6dtg5XzVVn/kWJOsZAuZUeYPgQ6MRpfX8aB9MCrfs?=
 =?us-ascii?Q?P0yOrbTXBz5XsNqDl8SOvrrY//WSX9X6b20E4l307tzhfUq6NFnkGrdH4ek1?=
 =?us-ascii?Q?veC6DvlJTW37Fds5QiMlJjYcXzoo6CbHzl6xorysbmURIXDZ4pE8Km9Yx8Hs?=
 =?us-ascii?Q?AkBhYZ3LxhUdFv8Qs/O3sfOsNegwNzs+9mgJIVV6jyokzDnULAmLF1aswKlC?=
 =?us-ascii?Q?p6CeLMhhrkpgNq+jZ2NCskdse7aacOozJDZun/R7nFK9CVe0DaTL3AwSDjGt?=
 =?us-ascii?Q?xty4GYT1Zgj/1f1Jyc/Q9phhuCrzYG6ihQTsiyHmp8YCFVIAKbBvN5T02wkh?=
 =?us-ascii?Q?of5/epPxYt/0y1P8Shrqxpk3vuoJlai/dfqj/FPjHGe98ScABSv7URxsQb5A?=
 =?us-ascii?Q?Ak0l4O5H37ZwleDZoXgl9rCFQnHIAmSONXKc2dSPiHeRrh4+UBsNFQ6Lpr0A?=
 =?us-ascii?Q?CJ17Cw/iEghNkhfZ/n6Mb317U4uXid8ERGZTh06cRM+OM8abkRF7DILD5reY?=
 =?us-ascii?Q?lYVICHtEQVelham4QPETtdeNlpw0oi4qxzE3bxw75/w1wwu3xHMv6zWul9pz?=
 =?us-ascii?Q?2c20buHnTuzszsT2N+ePsIfH4mH85/G7+9eJlFugoyWBPno/ufBwXgJ4TbBV?=
 =?us-ascii?Q?eterI268nWsXnSUeaPQ++apX95b4j5yR7IdwXTlaDWHJiPSm7D42hdnP5s2w?=
 =?us-ascii?Q?Ds77+oLpeh6a18UVCKrYcgBi0YwM7xNFZA4m2kqNBHoJ2X+0jB25r/3VVlYb?=
 =?us-ascii?Q?rjiUSdIC2R7FFlYVWoHymrqICN+SxqSnerOUPRMsJNiwGb2E7ptcxHlh8sr9?=
 =?us-ascii?Q?9l5yvVKSXpXqUZDocIGZz7n85j7HJHWiNWS8a5QEr9N4nTYnVydv9ge7w65a?=
 =?us-ascii?Q?f//8bpoacXhNTBDhfpi/j9VH9V5mveEnZ+Gf644KBUs3RH9Gk/q6K65VUfW2?=
 =?us-ascii?Q?rUH0tDcMFQ=3D=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef0b993-2c3f-4922-570e-08da4840a14b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 04:46:04.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94nSbZrqdYPAQlk5Hp3rNTuZbSslgjf2tU1mfiBEALxFRkzhX7y3YtsnEF34PI0E7TJtKOtZ4PTLq0jkVlGIqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8470
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 520778042ccca019f3ffa136dd0ca565c486cedd upstream.

Since 3e135cd499bf ("netfilter: nft_dynset: dynamic stateful expression
instantiation"), it is possible to attach stateful expressions to set
elements.

cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate
and destroy phase") introduces conditional destruction on the object to
accomodate transaction semantics.

nft_expr_init() calls expr->ops->init() first, then check for
NFT_STATEFUL_EXPR, this stills allows to initialize a non-stateful
lookup expressions which points to a set, which might lead to UAF since
the set is not properly detached from the set->binding for this case.
Anyway, this combination is non-sense from nf_tables perspective.

This patch fixes this problem by checking for NFT_STATEFUL_EXPR before
expr->ops->init() is called.

The reporter provides a KASAN splat and a poc reproducer (similar to
those autogenerated by syzbot to report use-after-free errors). It is
unknown to me if they are using syzbot or if they use similar automated
tool to locate the bug that they are reporting.

For the record, this is the KASAN splat.

[   85.431824] ==================================================================
[   85.432901] BUG: KASAN: use-after-free in nf_tables_bind_set+0x81b/0xa20
[   85.433825] Write of size 8 at addr ffff8880286f0e98 by task poc/776
[   85.434756]
[   85.434999] CPU: 1 PID: 776 Comm: poc Tainted: G        W         5.18.0+ #2
[   85.436023] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014

Fixes: 0b2d8a7b638b ("netfilter: nf_tables: add helper functions for expression handling")
Reported-and-tested-by: Aaron Adams <edg-e@nccgroup.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Ajay: Regenerated the patch for v4.9.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>

---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 net/netfilter/nft_dynset.c    |  3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec460ae..0aad9b8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1756,23 +1756,27 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
 	err = nf_tables_expr_parse(ctx, nla, &info);
 	if (err < 0)
-		goto err1;
+		goto err_expr_parse;
+
+	err = -EOPNOTSUPP;
+	if (!(info.ops->type->flags & NFT_EXPR_STATEFUL))
+		goto err_expr_stateful;
 
 	err = -ENOMEM;
 	expr = kzalloc(info.ops->size, GFP_KERNEL);
 	if (expr == NULL)
-		goto err2;
+		goto err_expr_stateful;
 
 	err = nf_tables_newexpr(ctx, &info, expr);
 	if (err < 0)
-		goto err3;
+		goto err_expr_new;
 
 	return expr;
-err3:
+err_expr_new:
 	kfree(expr);
-err2:
+err_expr_stateful:
 	module_put(info.ops->type->owner);
-err1:
+err_expr_parse:
 	return ERR_PTR(err);
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 81adbfa..5c25ffe 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -196,9 +196,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
 
-		err = -EOPNOTSUPP;
-		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
-			goto err1;
 	} else if (set->flags & NFT_SET_EVAL)
 		return -EINVAL;
 
-- 
2.7.4

