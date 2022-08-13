Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7E591B38
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiHMPLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 11:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiHMPLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 11:11:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DED13CE9
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 08:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D884CB80686
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 15:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF3C433D6;
        Sat, 13 Aug 2022 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660403507;
        bh=cFaUnxmZoEzd309h9uVDbVEKQ8Zj4J24BbUnl7VQp74=;
        h=Subject:To:Cc:From:Date:From;
        b=SOvsSlh31WOC9QULvgNUdrtAlnc5c1vdHUgsZkhiNEcGFWu83HrIestgeCzR4ckvo
         yoIzEatACUiKsATHoKJqouFvZh3YrzDUGLId5ISmhgtKXNMwCCiT9owOkTaHhX4t9I
         kM4sHP+Y4mhCo43aDSdR/RYwiJBnv7+Hxe4VIJZg=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: do not allow SET_ID to refer to another" failed to apply to 4.14-stable tree
To:     cascardo@canonical.com, pablo@netfilter.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 17:11:45 +0200
Message-ID: <166040350599244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 470ee20e069a6d05ae549f7d0ef2bdbcee6a81b2 Mon Sep 17 00:00:00 2001
From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Date: Tue, 9 Aug 2022 14:01:46 -0300
Subject: [PATCH] netfilter: nf_tables: do not allow SET_ID to refer to another
 table

When doing lookups for sets on the same batch by using its ID, a set from a
different table can be used.

Then, when the table is removed, a reference to the set may be kept after
the set is freed, leading to a potential use-after-free.

When looking for sets by ID, use the table that was used for the lookup by
name, and only return sets belonging to that same table.

This fixes CVE-2022-2586, also reported as ZDI-CAN-17470.

Reported-by: Team Orca of Sea Security (@seasecresponse)
Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3b09e13b9b5c..41c529b0001c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3842,6 +3842,7 @@ static struct nft_set *nft_set_lookup_byhandle(const struct nft_table *table,
 }
 
 static struct nft_set *nft_set_lookup_byid(const struct net *net,
+					   const struct nft_table *table,
 					   const struct nlattr *nla, u8 genmask)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3853,6 +3854,7 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
 			struct nft_set *set = nft_trans_set(trans);
 
 			if (id == nft_trans_set_id(trans) &&
+			    set->table == table &&
 			    nft_active_genmask(set, genmask))
 				return set;
 		}
@@ -3873,7 +3875,7 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 		if (!nla_set_id)
 			return set;
 
-		set = nft_set_lookup_byid(net, nla_set_id, genmask);
+		set = nft_set_lookup_byid(net, table, nla_set_id, genmask);
 	}
 	return set;
 }

