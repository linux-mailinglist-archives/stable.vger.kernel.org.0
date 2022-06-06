Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5C753E26A
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiFFIu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiFFIt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 04:49:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52FC14AF77;
        Mon,  6 Jun 2022 01:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4hUZbGx8xJWHi4i2QLnWm7E4MxLake3dhNM8nBjp8SdBXgD80Vi2qrt4dribPjrH2B9WzeyKnmIjWrus1xpZGdCXkfBXXP4C7MHYc08imhLwV+U/z7E57HisXBnq1bV0Kja7OjLmknfY88U1cWmrZA7GO/BabFF/f32hDTmPYfUHYZI9um32X+NCIf9xe7v7+wHW81IxDCDyfZXPvJ/cIB7hHlVU+pHxXX//JgRvLLQAOm0sSKvFdXLhwpgWEOCQRHGSQ6UMjUA/ZDwxI81hRZRfO8wmxJa1llLgD2hiD9VW5Q/IYOe2i+cdw/XHOFWzmcEoQQsXTsLTW3Luq3uLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8O2NGTR7JZOkFDIHd7Opprx7x3VyGPswlxoO0wmqPA=;
 b=QIA3QJHnmdmuN6tYzmbatFwxT0odeo/WUc6OxLOSzTOPhuqLhR6chzHNDkT7IJg/mFKvZV/Ja44qxzVIxx/z2M9RQs/qP1pH7n7AtH4cWEaOYzOknpM+V5XEhzSqSJX/AYen9Yleif8Lnej+TA7y1lfzGaeWxNE/VunmxWzrkWix4o6OX7exPObl6yWgUe1V9ABAq7Y7j8cdQuoK/sfNIH4UeOl+G5AQ2erXiQiQQ+oap94UhD2rZVPqeD782XrFEkdfI+yyXm18/cgC85IitcY/Tx0xcEB8+cQY9vwBPLojn8PkvE/FD3JDRx0yu8kMjiJk7xyBA2PunqOCS7jVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8O2NGTR7JZOkFDIHd7Opprx7x3VyGPswlxoO0wmqPA=;
 b=bt6T7Nvipd6rZg1q4sQJSs/aRMbHZlE3HkplF2wlvdJqCJITwBtAcZ40+RmaWh9ncuMmVsiuLr3tn6jR4kEjhLbHZWCi+Ft40iZOp0ym2szAiWbuaY4Ug81Jb25wygvn1vju04IqY1kwrE2pyUxFQr7vMwsXGYFDanvBmkOWaZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by BY5PR05MB6931.namprd05.prod.outlook.com (2603:10b6:a03:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Mon, 6 Jun
 2022 08:46:50 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::958e:56f9:8283:4416%4]) with mapi id 15.20.5332.009; Mon, 6 Jun 2022
 08:46:50 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     stable@vger.kernel.org, pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v4.19.y] netfilter: nf_tables: disallow non-stateful expression in sets earlier
Date:   Mon,  6 Jun 2022 13:56:08 +0530
Message-Id: <1654503968-47310-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::19) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f81ba18b-a8c7-4324-194c-08da479918c5
X-MS-TrafficTypeDiagnostic: BY5PR05MB6931:EE_
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR05MB6931EA7F517A024698F8E9C2BBA29@BY5PR05MB6931.namprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /nUm72B2ArTVmRiVcQTRvHumBQZrxXZt06hEgyhb0WppdHbIxqBX8J6ic66Pz28McGNBEjLScY2Tfzlt5SeKad+9F3gIDnB1PqNwWbE3GZAbQfeMia31veuQfNL9IUcvtZKpnNq/HwjqrsiRcbBvC699+0pWip/FojnaiEyi5VcDvbY+4jFbtFjIE572jwhT2LdrJhCDfp/Cr1EIibNVYVMDmc/xyH4YSqTzJIs151MuWm+WlTZ+9aKv5iEVEALV3IN+2P6ApjT11gnfyVDsUfOOAzSBP5E6oSfN+ll0XIniu8m2WmIUQXbUYzyvlKid6kVOy9WDJlAcBFQVrn2YPwjbESMtN1f9EJcYilwR+OrVnbvWt4PYlhnmexBTTrhL1cVnHjUUNgLmNGrn3xMckQ6rN4QOWvtnM4zFRv+vF80dTZlzVdF6NC/zTILD6rDF2FPSRjM8Uow9DpPAUguXXXCLcq5li2JdmOEEHAJo8BMI79A3exaq8h8PwwzmEeRCLzvuHgGGURiENX6qYQk/X70rcy0q8/l/fnzzqZ90fZhr/i9Owca96lw+xhyTBIO4mdTg0Sb62ghxi/ldP35pt9UmH9eGyFt9mBIzQ095IvR8YkB56fqS/5Nx0o+t4o3cySXG7/WzNwpc0awQCPllxo/9g+mjG9qYLq9BVkvERsxLNQMLCvWLs4grdNUwMzvS3cpVlHbG/yj0wrua8H7VqsO1pKo4VRRGMHaex3Foih27zpeBfpaLZGWyRPoHZqxd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(52116002)(6506007)(107886003)(66946007)(83380400001)(8676002)(4326008)(66556008)(66476007)(6512007)(316002)(26005)(38350700002)(38100700002)(2906002)(508600001)(186003)(2616005)(5660300002)(86362001)(36756003)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QEjFXoEZajeG9Qf6gZeirb6joXuKgCd3j8MZPR0R+B8FkBYgzuTuQazfdZWD?=
 =?us-ascii?Q?0FZaaDAcUCmY6CmnRBoyoGdVAOxmKfT+YeqXnxNxA581+FKqceYgouDI9Ssf?=
 =?us-ascii?Q?D6Wjqoc09uKJvDUzCO7+1Hnv8tvhGV2mKaon4cQOT4HW74a2P0iMOeMkee0Q?=
 =?us-ascii?Q?lShoC5FFNUsP6y7LXQGrMXXpqBBnpmPNlUrIBeLTBWNPMMZp269wYNnPdWwv?=
 =?us-ascii?Q?FRdBk52GSq4owuiJwf6TNCCqiDejIwmmBmPa7KyjjSh/qEniYFeyFfK+NZfH?=
 =?us-ascii?Q?8pFtS/C4tEq+Kh79JO1nfvDppJyEysgRGK6jvzrdD95HjLXc8V9hFA9FrO0/?=
 =?us-ascii?Q?LbqIHhQGxzkrs2v+F+2ytxpEPPeKa2mP2QkuOjHW53PmWGwgurRIPYGIUUFP?=
 =?us-ascii?Q?1ZOWXsUYpRBDHROkgxTCFTlBNxGspRgiyDK8xJmGrAZfNNUjMO01GefgOwTi?=
 =?us-ascii?Q?FFtN0xgercohra3cCNQrOny8eZWvO3GmzI6UO6U/zP2q+a623wQC89iKBDyj?=
 =?us-ascii?Q?uVeLt0UWcsRhmwhf3meQssLmj806kjpQ71KF8rFrSJFBPkBApfm/PRc82dMc?=
 =?us-ascii?Q?PmMYKbOVsQPFOM26BqO3RssFKsaj2mohmUQcscJfMN4TCmY6zIf8gvrVi7hW?=
 =?us-ascii?Q?DZ4Bsxw0iYtKzCeWWrDuAJXmzsNJdPY8tDvWDcnu94o2PDjGSLTCNGMsrks4?=
 =?us-ascii?Q?d3BMKOvHcN6xVXZzmmMQ7uN5e1E+XmPDa2UtAZosJv0hWFVVjioow65DjUr2?=
 =?us-ascii?Q?a5qquFWkwSXSJ4jW9MOK8j/yQPrIsI5+uJYyPU2BdrAz02brBMu8DNCN4zj4?=
 =?us-ascii?Q?hqMuDfdLyubRj4/heoq0AOAIWUMQYeaHUDQpQK6A1JhW++gDCIEv2qoAzh7o?=
 =?us-ascii?Q?gUwBT8wjg4mFNfPEr/Mkbtdb3Oc6GZK/zROgqVZWVmJ6sNcqaAvstHj5TcWN?=
 =?us-ascii?Q?56/LMd4xw5Hi02cDtZc+xiFUgp1999jCE5uialac9pFGLUt/nOETRE+f7/Vn?=
 =?us-ascii?Q?jKX2V3ye1C5PGH+UuJ73fNxyxgxmjwTMR2SAofkZv1YBZph/twMC0yogQj1W?=
 =?us-ascii?Q?YqbuYjf+ReSVHXjjs7DUl3ceAuDEp/eYn1qFAAHm2WkuYChHuonyqqncQiuW?=
 =?us-ascii?Q?fZPKj7OvgGpRfUpyGNFfE5Dcks2UoEJgdCZfjb9wL1aI4MDb+kS6oT/cRibJ?=
 =?us-ascii?Q?omwIAhXLiIeQpb80SCVe/2pw7rTcH4nW02DAkNfKFMJCGoV7HiV12tBxmsxs?=
 =?us-ascii?Q?MqV5qjye8+3wK49xDDI8g62CMzQZDBpXv9BWurMwCVUoki6rlmCY9mk/oT4z?=
 =?us-ascii?Q?CW6HoPWNqJMH4IX5+pjzuxpvd94f39mUs9GdiHdgefrR6nZAV0fVNRy5skct?=
 =?us-ascii?Q?gn6WUPm7yC5dv7ldUVzs1t2tBYrqS4A9nEMZJe/N2ak8JwDUPzQlFOgDNEKr?=
 =?us-ascii?Q?CBpjT/LnStMIp/koqqFIptB5g+H+BNlMNkT2QnGlCkUCSI625u683xTRo9gO?=
 =?us-ascii?Q?VWI08t0uXLOe72MrtXE5nOjpaRPYR+hxcaSOcVDOLW1O+5/0GynVuUOFgAet?=
 =?us-ascii?Q?mBBpgB+sF5tkd1yvdGK8cY9kHh02b1T5Zkksiq9i9gqkNf6r7izrBjeDxHWT?=
 =?us-ascii?Q?iDW41elk7LZ+boa6AZwNkk/AKqAEUanzjiW6BhrFwozal+p1QN0JX0vohq46?=
 =?us-ascii?Q?ZNeiQeum8tFI6orEjjRM4sST2JNg4/dkijdmUUt9lhFIniSKts8jc6GpPNMG?=
 =?us-ascii?Q?2c6ufDFiZw=3D=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81ba18b-a8c7-4324-194c-08da479918c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 08:46:50.2171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0F5KBhrLAoew3ZKpile1U071IhnIMlabnrSboD0Tf1/K1V2sw5bY4M7dawbnJ2v4ZL9Xr5GY/4xAdQ3Nbnifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB6931
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
[Ajay: Regenerated the patch for v4.19.y]
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 net/netfilter/nft_dynset.c    |  3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9cc8e92..ab68076 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2167,27 +2167,31 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
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
index 4e54404..cc076d5 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -193,9 +193,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
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

