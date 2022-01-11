Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ED748B117
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343649AbiAKPll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:41:41 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:17127 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiAKPll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:41:41 -0500
IronPort-SDR: hG1PM904GB6asTvTIAPqJ9vnSVyNwGeLgj4UcdzpDwjnjsGBKK1otmlh6AHKEQz3i22VbvPX42
 KW6lVyUhGq7HrvLYGDHZAMQsdklIPgm8P9lrOAJKMIGNjILytzbQpVt79sX8d6oeinHyvkuhIk
 6h476GzIwnQJ2pFgtB+oGii81ZvcTohL/LTBIkaSEmlMu0Ui4aIBuA78bwPyCspNQrknsTYL49
 m1tvsfl5PW8cIknA+POBA8q8/HpChGAfS1C8CagB1njNrRDX8eakU166mYYEyicULTvmzZ70r/
 AEiI8AYurDrsRyrpy57JY0EV
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208,223";a="70495084"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:41:40 -0800
IronPort-SDR: ORA/ZROzdBZpKBkBei7PHjdvnC5QjIuU1nWtBshiEbnRZanxYz+iUzIHlgtEo2iJKZ6k65Jfww
 iLGgS2U30Ewl3xygovIl7klcSn/XnIkoEm1LDDEbJePmR7l4n5aNNYlicqnrTvFkL05e8gFhP+
 Zm1+9UuwOgETONMnjShh5JinQVBX//EuJYzKxxhKyFQP+jLcPByG7+xqvakqvfZUH/2UOOSYlS
 MsMjyOyCotwLxVN+epICLqvaUPAnZB6lOIf62QjjXOUFDHOUpWHaK5oCOf00dnFwvxSlOzyaf3
 gbE=
Date:   Tue, 11 Jan 2022 10:41:35 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: Re: [PATCH 4.19 stable 4/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2lL+VK0FWqVmI6@cat>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
X-ClientProxiedBy: svr-orw-mbx-11.mgc.mentorg.com (147.34.90.211) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From 791580bd2a8b75daddc0d110582198ab0ac854b2 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 5 Mar 2020 11:15:36 +0100
Subject: [PATCH 4/5] netfilter: nf_tables: fix infinite loop when expr is not
 available

nft will loop forever if the kernel doesn't support an expression:

1. nft_expr_type_get() appends the family specific name to the module list.
2. -EAGAIN is returned to nfnetlink, nfnetlink calls abort path.
3. abort path sets ->done to true and calls request_module for the
   expression.
4. nfnetlink replays the batch, we end up in nft_expr_type_get() again.
5. nft_expr_type_get attempts to append family-specific name. This
   one already exists on the list, so we continue
6. nft_expr_type_get adds the generic expression name to the module
   list. -EAGAIN is returned, nfnetlink calls abort path.
7. abort path encounters the family-specific expression which
   has 'done' set, so it gets removed.
8. abort path requests the generic expression name, sets done to true.
9. batch is replayed.

If the expression could not be loaded, then we will end up back at 1),
because the family-specific name got removed and the cycle starts again.

Note that userspace can SIGKILL the nft process to stop the cycle, but
the desired behaviour is to return an error after the generic expr name
fails to load the expression.

Fixes: eb014de4fd418 ("netfilter: nf_tables: autoload modules from the abort path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 1d305ba40eb8081ff21eeb8ca6ba5c70fd920934)
---
 net/netfilter/nf_tables_api.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6329d23c8b35..54bf2ac44531 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6698,13 +6698,8 @@ static void nf_tables_module_autoload(struct net *net)
 	list_splice_init(&net->nft.module_list, &module_list);
 	mutex_unlock(&net->nft.commit_mutex);
 	list_for_each_entry_safe(req, next, &module_list, list) {
-		if (req->done) {
-			list_del(&req->list);
-			kfree(req);
-		} else {
-			request_module("%s", req->module);
-			req->done = true;
-		}
+		request_module("%s", req->module);
+		req->done = true;
 	}
 	mutex_lock(&net->nft.commit_mutex);
 	list_splice(&module_list, &net->nft.module_list);
@@ -7481,6 +7476,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
+	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
-- 
2.34.1

