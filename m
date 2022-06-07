Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76953F532
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiFGEnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiFGEnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:43:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF2B872;
        Mon,  6 Jun 2022 21:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkVz6xbgpeM0JYThbPtHN4MAPTPCZlZYqNIsEpt+5ldThSlDanVLWN0/XZsRp7WWFc+qkj3EXpbPEFOfT7/eoZVsqCFo7c64vEC+rmCEgIGBvCV5HW9+zVGHS5NpMmiy5eEKEkfSmAA94xzRDBqkjTSXxyHCaJ+EoxYHVfeFMO35iKUqf/bZUZkcqQlwhNA+NqEVGDYZKbjl0g0NrYFItGyyUUTIzLczg2DTwwFVqBiIxAqJjqkGAa+SYQ4OJb46EC8cQ/8ODHbre2FDC7SH0io+n8twZwZIzxIaZ2nqxTuOVH8RqUC5nxY28G231FQvidD5+5pkE9Z0EEIWqXL2pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsr3z2c2LJ2J03TwLDj8lv3XYz87IodwxGNKiTP3QFU=;
 b=VYlRGI2puzNrzQIDOiSB7cleVjd06m952RbTnaOIhMmpsrdgVwL9h5cC3K+pdTmQtOICJNE1pDzmx3c4WEWgMJoSXa8Ls53PSsr96Fw4jzHbxSMx01jd0LGOAEFsRhC5BlO0K7kC5FSOr5HoswKg39m4KXG/+urWSaG+J0pPgz2ohKRu8Br6C0SNFjt+6ddAuxxaczZw6AWFznGl/aOZBpsHDAWZaM+G2vnW+4+5AljCCzKAgnaJuAKH3Z3Kn+91EQk1liaIc9jKxwHoGxBt9MyOVd3jibqC+wTJZWcBw47V2wh++2XIs7W7z2ldg1quCNL6pXAihSF03ZPKMt/NPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsr3z2c2LJ2J03TwLDj8lv3XYz87IodwxGNKiTP3QFU=;
 b=edOwk/v4j9Y9rxj2XkM4BnbKy9+XkKysmrbYFtY42DrbbojKu7Bloz+WD8BUEJsQ3P67x+cwY/PFdzLdMBtPxluUvSZDA3L73injBykjFuHCsCLPsaKRFkloUpHRM2DK7MSOJ0n192m2eZz2QFaog5OeThkyHwz5CWTOg4rd4gA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by SN6PR05MB5277.namprd05.prod.outlook.com (2603:10b6:805:e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Tue, 7 Jun
 2022 04:43:10 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416%4]) with mapi id 15.20.5332.009; Tue, 7 Jun 2022
 04:43:10 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     stable@vger.kernel.org, pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v4.14.y] netfilter: nf_tables: disallow non-stateful expression in sets  earlier
Date:   Tue,  7 Jun 2022 09:52:23 +0530
Message-Id: <1654575743-2500-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::21) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd70505f-d240-4e11-2fc3-08da4840393f
X-MS-TrafficTypeDiagnostic: SN6PR05MB5277:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-Microsoft-Antispam-PRVS: <SN6PR05MB5277E06537176BE476962432BBA59@SN6PR05MB5277.namprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEiR9swfaeigggAJDUTcCLSuvsF55khT/RfaMTMenDpiT/EvzvK3usT8KOvnpBjrC7dskQHGzdfXK4nNAwHI3LeiyTzDH8VQ0ULfoJ1JsXWjFArYbxpn5Yrm0V+v5ebMXK2xiM+rYQa0wFo6VbYx7woPR5jpJQu0C553rxPN36fbmTqtUwmj1zhCqfojEF0PgB25kM2PeEWWyvRmfpCcfXzBvZjF/zDO2p27DLw6uunPyM2o0/fQ3D2yYtt6m59ERayD8vC6ph73YR+pCp0kj7Yy4cRioBVwI1Oc/RAslLqM9gGrHoILkNQYQQVtxg9EwBIMaAkXaU0DItmOEcPpLFfNvu0FjlnBIcnVH09ASQ3uvpGxf1jRHujwrlUwXwZqF9Hl3CMI+j1Gh6qJtJ/aD5XoGO89l3lCZLGWrKRReYuaEcYEqVytOmD9Eq5HKyHUJ+Spydwxehnf44IH+3RxlxQq/HiOvdu0j7jh9EPI4eSHnw62dI4O3mUtXG/z1e6wCKmRzEmRCI8CzQGz8wcc4b0c3fdNrxEtuYOXvARROoqMM0DF3SZhN9qLzKZEc8qZGMzzXFFG1S5VB8dRKpdGX45WVaqFiMyqyK+vatACCusPVMH/UyBmskra/w0cF8z1zY9/3uiaBuD16SFlMtjdOYGqw8lbs9RxUHaLe9fsMqJOrXh3LSw1BqvGyzSi15CErfoT5mo4a94SIb8aa40Cy9Oxhn2fkNZKgqQgY1EUw4Dauc4e4nPCKLMr5TVuZ5O8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(107886003)(6506007)(83380400001)(36756003)(38100700002)(186003)(66946007)(66556008)(6666004)(508600001)(6512007)(26005)(5660300002)(38350700002)(2616005)(4326008)(8676002)(316002)(66476007)(2906002)(86362001)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYlf5HGVShWfW7UOH+T9tTthWlzuU8Lh+KTR57OsxLslzGS6pKx2vpXmS+wB?=
 =?us-ascii?Q?PFdGbvBHpcpI1UXHr3z9gULosxeEeSVloyeauJ9oynUnNChvKR07XxLWzdSq?=
 =?us-ascii?Q?wi0n/UjNCQmQ6a10rsw+oOJqg4Gw7qIiPBUKDigBbZ/fUQryUFDLPjeCDrmQ?=
 =?us-ascii?Q?BlMeKijfC1TpXGysc3K/9kc24c08wrmSY5InnCcukk7hM2JuFsEUP/MxE3Ip?=
 =?us-ascii?Q?PhcECr8/qJanJS8nLoF3h5piXtNYeF+ymPRWTML6j/UpXeZ6oCBfbxWm7sGv?=
 =?us-ascii?Q?/INdCAdOVRWnx01Pk+m5hwBYiidh3cqwJQfGRA1oLCyRw3QdtwzJ7bRAUfuk?=
 =?us-ascii?Q?cHL7y3gPnz3XeBZ1p5qR9NeRjWj9nhLiQei4/KVKCzSz8+9CNdVDNrBfQQ6Y?=
 =?us-ascii?Q?ZnmQOlcExtCznrxuUIjYmWg2fQYMl0Cr0jVp5d19Fe8GeQb3zFX9pG8UJ3DX?=
 =?us-ascii?Q?/AEbYqp/HuQir8DOiwJ0YXmTlfDq5y5bbkRGvQdU9zLHUXeNjCe4PLUtxe2l?=
 =?us-ascii?Q?8m+9LIw9ZE7u8IG2TZG4behWdYi6jbBJALS/b6AbgFeCpDPzWJ8mh5jeEfAf?=
 =?us-ascii?Q?Wo+jQ6UrBYQ2U04uJFJLkj6YN9mbdjHc+un5Fk8xAozlR3JrTfmZ2ycZGGir?=
 =?us-ascii?Q?gl8v7gQZtuDfETfIVCPXnsm9k0EmttmIwG7T9lOe7hcz9OooWDYhswmqThse?=
 =?us-ascii?Q?KVettyTgXHCoiLzp+0PhlMnWD+hdKRoMeq9knFRNvtRBpG/weFshKxNfq5eG?=
 =?us-ascii?Q?7hB1Wj/cw8YB5iuSMWZHL/SJ+Pg34U/l0Dm9wWxu/0isgdBF+jAFks6lpFbM?=
 =?us-ascii?Q?ULiKlYkNK+4iRGW0aSMLE9RrljgbgwBbUVhdUz624tqewNKdYM7E8BkzC/Tv?=
 =?us-ascii?Q?4Q94416JmZX/U6LhW28DUeMBgFc38E68+PFxbGL2lccjBaiMFOm1FMr/tqNa?=
 =?us-ascii?Q?SYOJIJBGhzErEhxH/c3M8x3R8m7ruDODb0WKXyUWLPF0VqSznMKgKKKguQsB?=
 =?us-ascii?Q?ydrYOoKtQj7gglS01OyWrRGEWWfNj+PE/RpRuUyxQlWZ3XtTnHMkY31C0s0h?=
 =?us-ascii?Q?rD6WyVVwGXsao7EozFxirwVj0cB/2b7Ho+dLVw9/geClWNPL5nrBCnhksi0O?=
 =?us-ascii?Q?g/9hjayfMnord6yj1Nwt8lX4HpezzrJuz0HLU2SWWmS9Vgu4MU+Z3QXpHont?=
 =?us-ascii?Q?aaUoN2TUtvG+3q9WKXFACUTO7SztEgZqJwVtUq+uKWYOjPiEdBn/QXKt+7C3?=
 =?us-ascii?Q?e3T0SuV1MO6kmdznNZAPLkVrllh62uv9FNMDdnYS4ScPWsRPtwgr0CaQ4O8g?=
 =?us-ascii?Q?g3cKd2AQVb0EBx5Vb0Q4SiMPLNwNlgszDOnD81ycpkE2ejenYOSg+xlMtLgC?=
 =?us-ascii?Q?ID7gYXlMMFZPVT2SxrDq67M+04ViTYO7oKPIEnwS+8hshDNlcSCe4kcPpKpz?=
 =?us-ascii?Q?FFxpHezh2YSkDvsEEkyeOcfMMkymxFWuzxyZyIrb8uGCmg5Y1nn5qlGXOV+z?=
 =?us-ascii?Q?T4mqrOv5PA6pNR1hauTjYwfjyAHi+OFWcVCt4VVjMGvZtKx1lBlbBiBjZk/V?=
 =?us-ascii?Q?wJRV12xo48VR4DXPo2V/IoU9tE5an9sBsV92F7psy8aGK3+uhUeGIyMBexow?=
 =?us-ascii?Q?C9h0PFG1LLOOQIqKBJK6d9GwF3i2d312+5LhugWGh9B7afhSPT9RUGO8Wh2D?=
 =?us-ascii?Q?UpBe2qP9/UP7qqTOoOzgWg2j8d6rx8lNZbhAlNpSS4kEX7+YzgkOh+r7tK/f?=
 =?us-ascii?Q?b8nBjp6UTg=3D=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd70505f-d240-4e11-2fc3-08da4840393f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 04:43:10.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QO/W5yo7Y0rmd8Z04FtfgcgnVnZZOUq8gmaU7GH9HgBzdLh1tkvMflaIqVHXsBaQX8azImDMHRn4tZErRg3w8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5277
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
[Ajay: Regenerated the patch for v4.14.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 net/netfilter/nft_dynset.c    |  3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7c95314..28fc44e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1952,23 +1952,27 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
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
index 278d765..f8688f9 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -191,9 +191,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
 
-		err = -EOPNOTSUPP;
-		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
-			goto err1;
 	} else if (set->flags & NFT_SET_EVAL)
 		return -EINVAL;
 
-- 
2.7.4

