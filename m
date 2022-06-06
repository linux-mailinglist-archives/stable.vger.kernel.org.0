Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B68553E3B1
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiFFIfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiFFIfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:35:31 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2041.outbound.protection.outlook.com [40.107.96.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B27D144FE6;
        Mon,  6 Jun 2022 01:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJC32oNUyvnEt8Tv7YghWVNtyMkrk1AHyPYxZwVFdVAykB8wt0y6l7URsZgw8LKoMWsD7sbc5sIK8Th3f1vVJFAxSrg33A/8WL+jo4EeD1zAGqqCeQFLlSEj4eG81RAUJJQtKMmJhVpxdTqoahueRjLwxxbYC11876DDSpnTzvnh6JpsoVgXeQ81izJod6IbvgjfrBdMpPgX80GonUrQ9ehUe4azYm9L79Q3sCtW7FU3RSdqFv5mGBfSqas5wk54QuWB2k24/tSHU5FWWOfRoM00pMnY5KG3Ho0JBcsLashFeIOwO+NXbPyXCYiQypvkcnI3D1RAPbGxgsDX3rRs/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAqgIJGPiU+voygiloM7UVc/jaACPIco8Ny/GNC3YqY=;
 b=I7RXfXSBIYVZSjBQ2vxd5JiM3OXSv9SEey+YWqUHF1ziLnL6fGX1SX+enwZrOVzBIxgsKD0R3GyNg43t3BBJsR7TS+DAlu/A70AQihyLgj0BvmZ8u6St1n5KHAcUCJZMZjVzlzEbWaFTM38ZdF8zKXvaKdG6PN7SvjrOn5wp8eKd+gzeCTcWjnHA9JOIuxfSw4gUNSMjtnQwG3NIcLXD55L/bFSI27PuzmUqr0ft7yuGxIdkLOrzJxK5GLTIHp8vuTgxw3ItXlDh2EUFyffJwXSVWFR8n/Wo4FGZZ2WBLfMXbdssEwJKuNE/mg13rXnwt4dab/amFrsR/Sz+WiSFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAqgIJGPiU+voygiloM7UVc/jaACPIco8Ny/GNC3YqY=;
 b=B+Ex33cqTYc6OjqAOUzwZFwlaV+f9F3nk1FHniT2qOKtRMBqoogaeOUVo8S1BSzH3ayLbw3X9JblzZs89r4l91cEtbTfquO9bYc6ybbY9jKnlM/o1CAbKPfdVClNwV86QWUAD/IUWHRj9i2gpRUpiFO15Dwol1gRZyMAoRyRn4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by CY4PR05MB3447.namprd05.prod.outlook.com (2603:10b6:910:59::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Mon, 6 Jun
 2022 08:35:25 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416%4]) with mapi id 15.20.5332.009; Mon, 6 Jun 2022
 08:35:25 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     stable@vger.kernel.org, pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v5.4.y] netfilter: nf_tables: disallow non-stateful expression in sets earlier
Date:   Mon,  6 Jun 2022 13:44:24 +0530
Message-Id: <1654503264-47182-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ee871a8-8a6f-4c09-5f7e-08da47978025
X-MS-TrafficTypeDiagnostic: CY4PR05MB3447:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR05MB344764E2EC2F1E875C48F680BBA29@CY4PR05MB3447.namprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EOYf4/DMZVu0H10vkzlN8D3o+I9l4NfSQwtKyOXh4JFXq4oKc1IrbQdnugDJ0O3+OptMdxH2MkxyKclM9zxors1E+Vi3Mka2nD4lxFCWIH1jVLbCYrS/tlQEPhV7x+0UGXxEAqU6AAKJFwELMdb6XUlXa10sMYELbU6YWSnCEiT2D6xxZB15/Ua9Uh1D/51MBGj5Zoj4kKYnFYHwQ87bj9bZWHfZ7KsXN/lP2RqpZQQbZxWITIRr3/UVzoAuzo523oWDfvAHqo8eJBIJzI+SmgjL2lBQJha7VMF0LFQAamZA3mzgmlBJDJhOr9+AkGUZ+iBPD33uTqNNvhgb+hoCADQiJVGRxnDgKDzzOTAr33aT16Qv+5pZVP7T9o2iR/E+IJkbMEPcjfIywlZG8yd+wtaC4Zo8Ec2sS38ARmUcAz8FZWW4SP+C8Hk6ukf2ioXHaoyCivYmO8AUIgmEewCGD3YvdQQu5Wz8zo1Gpi+f61V/li0P1ci07oym5XKmnUtI3oak9yyC8+9bDY5/5jsFnzr0+ePh8Q9xtNauQfM7/qEU3J/cOKYZlTfErVFNmx8wnpNIJ+kAW5FTjU1FfvGMo2gj/+6laNeM2acBSMbXCQ00VRiFHLnWbgmqiE2VLR116ST38qRwFoDuHw8GuC2uR+7xDZzUv3jE16m9fCIV2QMaboGLcNjUOe7F5MT7gf+KQx94GwnNZCOPjc8bQiGoF59wjTxv0+AEGxQGbD60fwtbaWtC5XK5Hb1Jn3bLz9hM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(4326008)(8676002)(52116002)(2906002)(66476007)(86362001)(66946007)(66556008)(36756003)(83380400001)(107886003)(8936002)(6506007)(6512007)(26005)(2616005)(38350700002)(5660300002)(38100700002)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2rqbuNxU/k1vBgmrI8aZfguv927HvPYnBmDwKGQ5ObNywDvEE4I6HCC8el73?=
 =?us-ascii?Q?Phaxtps4JyBG8uHKabELFg0DzxdGan2tiGCPdKEpPjvMCyRTJP51H6iT3XIE?=
 =?us-ascii?Q?si+vBSsVfxiVHUN56HD7GZfyGvGHcbxwXL8coq0N+tid/QA5xt44C4LzfXAK?=
 =?us-ascii?Q?wBeJQEt398d+/CyQjAJ+//8czvF4esyB/q0j9QfDKtMN+1HFknq7PiBjo1+B?=
 =?us-ascii?Q?yPHvr7roWPQGhClntVz1fshycVInQZ10D4DbaIdgLpwFl3NvCTgOFt6/IrlC?=
 =?us-ascii?Q?/eChTmehN4eioHjOSyGJ2yTv4IhDmPYT6+6iA9jCAxZvZjZBOC9HC0veOMZE?=
 =?us-ascii?Q?Sdy78wn8fwKbfyGgNubmL5hWc8wsHH9y/zjaSU4yiehq/RC4R+JM/6Fpvtq0?=
 =?us-ascii?Q?100fSqm7c4GCgU05O0Cs7dyV2tA8nQh+JHt0dyeAiX0wv0KJRhM9Fw17G3jN?=
 =?us-ascii?Q?RB23QdQgN+AeXROpNK9+8bL0Ba7NVFX/JADgU42LYQasTCPskG7tT/6BbFYu?=
 =?us-ascii?Q?UcDjC2xwsP8KNKYuN7MlfiyjOoy1j8dQgbHbSf5unXGZ0dTz46BXTybwGdNj?=
 =?us-ascii?Q?YwqVh5ao8bkU7tjjntPcSdwk7g80q3CeGmYKTulhuA2utDGSK6TqblnWhFA2?=
 =?us-ascii?Q?kBjTp+qc3y9Oj1NNAHhxf0c1YC1ivxfKemHRZ0fGAsE5Jk7vXovd+fumLGht?=
 =?us-ascii?Q?YDCP9ckmszp7ZNIV8RSSpKNmDCuJz09jyhJ/c2TSMUyiB+/gBxgvNqiwlHxP?=
 =?us-ascii?Q?cTZocF7+fiiicnTdVzGXkBfGvWHRr5KYGD0Uyk4SwSqTEIEtwizBbUG1bn+5?=
 =?us-ascii?Q?nisKb/8linL89WySeWx9yKhdNdtZHuWUE6cTYJdC3LC8hv+EF0vttPpuRDwv?=
 =?us-ascii?Q?NlBlgJVctmdeWkOlFk9864fIqL86+5jUAffKvcGmbSA1LcpPA8GbHbBjh15l?=
 =?us-ascii?Q?3YNszMRoOEWDFP9y7zEYBL/ptqtDq+vxa7uIIULGPaAhf3PB88DbWtdLDDCQ?=
 =?us-ascii?Q?Lp5GePVY/xl6IdV4gIFSfofxwuvzgAA2jhZB9LJGKLItTNpOeqAB/Q2a5MTG?=
 =?us-ascii?Q?GQoeHQC26DmUQYZhLC/eRnehllQH1mq91NyRXDevUwoLAf9rSngX9xaGnsLz?=
 =?us-ascii?Q?PBYrxVGOnrflaDJakwRRxYP4pzbTEpHJvDBppFbqJ2Gcx5Ao+n3chFZ7oXVp?=
 =?us-ascii?Q?+fFOmwM8EjYhklPGtkLbegVVUrcoQqwzVhHAo6QJOi9GhemWQTbx2GFpIUOb?=
 =?us-ascii?Q?bbzy7kNgfxTZZdJugdJQjuBVxltflIf6ZMW3lxLlzna2HnRuXzX0WzxYyMkr?=
 =?us-ascii?Q?QyI7hQulsK8wI043cA1NW4nAwFMPnvi81+2I5euvuRepv8OKNG+iZGuiix8m?=
 =?us-ascii?Q?fGf3os4skEbBYM9n9yJGLA8zn7LLt9SPGbNsJ64nc8MPPtlPYc2M95Ws+DiH?=
 =?us-ascii?Q?CcYgKBp0oxKfY2xuujUDS7Mt36WwD2jfyHHj0XkjrZ80MU7ipn+gJx7UuMXP?=
 =?us-ascii?Q?tr8qWWOAVE1uwG0za3AhEFE4m9yPctqaZ6RJ+q3s8xAthfIJyWdbVWSuw/Gk?=
 =?us-ascii?Q?X9w62ZsaHJUPe6VO61cVz4g+jXAdNHNXajk1EsRlFOuCjIWBykzb658FAz7N?=
 =?us-ascii?Q?FiQ7J+puu7OOkHJ9O49namRLmqhndyotjVnCZQA5ydQUWIIfn1WYikp5g0Py?=
 =?us-ascii?Q?GT3v4vBXtaM518aL9mTgkvCOlSZWQ28AA7msPktN1HCMSGEgu+cz5iRFE/CI?=
 =?us-ascii?Q?kNolprSPKg=3D=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee871a8-8a6f-4c09-5f7e-08da47978025
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 08:35:24.9424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSJpGa8zjiXInV/QhDErg+mN3TcRDcrvxkWFFiV+VvzrHMMsd87ZbmOQUvj9IYDP1czsTlHHFD6jssrKtE+VGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR05MB3447
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
[Ajay: Regenerated the patch for v5.4.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 net/netfilter/nft_dynset.c    |  3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 545da27..b51c192 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2267,27 +2267,31 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
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
 	owner = info.ops->type->owner;
 	if (info.ops->type->release_ops)
 		info.ops->type->release_ops(info.ops);
 
 	module_put(owner);
-err1:
+err_expr_parse:
 	return ERR_PTR(err);
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6fdea0e..6bcc181 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -204,9 +204,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return PTR_ERR(priv->expr);
 
 		err = -EOPNOTSUPP;
-		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
-			goto err1;
-
 		if (priv->expr->ops->type->flags & NFT_EXPR_GC) {
 			if (set->flags & NFT_SET_TIMEOUT)
 				goto err1;
-- 
2.7.4

