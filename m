Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9EB58DCB9
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbiHIRDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 13:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245543AbiHIRDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 13:03:22 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8D36419;
        Tue,  9 Aug 2022 10:03:19 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id EE7C03FF8B;
        Tue,  9 Aug 2022 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660064598;
        bh=1FKd8/tRO5YMlNLcXeoLkbA2mShkCMgv9jcbuwAARG4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=rkgutzWYdEQfzLbFqbPP2w4BVgVga7uRg1+0uNO8mAptRLwoDcoVOmjZCtChPP8+1
         hZQAsFrZxke9Be40u1hecqtDFsrm7ptQ3OCIww08pdB/CYqRPyUnX9gIUnhbxaW4de
         sKfWmmsknEsdOu1MU4qBKdLWNqIPVpO4f7jg6U3+xGIjp7MHEcc8EF0xRMRL5biXit
         nVAcGW21bWAYk3IUT4SHKCrCoR7RtpsI/Wo0hg5fhO1jJ/BmDyaOrm8pKvqKkOMEfD
         J9QK+g/KpEfnwHUbGcL49IJSxYk60whMhF+ehteQxOi52o1VpCdbkRVgfRfX+oI6HO
         AqUmHNkZNUKtg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] netfilter: nf_tables: do not allow SET_ID to refer to another table
Date:   Tue,  9 Aug 2022 14:01:46 -0300
Message-Id: <20220809170148.164591-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9f976b11d896..86fae065f1d2 100644
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
-- 
2.34.1

