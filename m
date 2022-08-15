Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9248594415
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbiHOWXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350058AbiHOWVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:21:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8216124F61;
        Mon, 15 Aug 2022 12:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13A41B80EA7;
        Mon, 15 Aug 2022 19:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B3FC433C1;
        Mon, 15 Aug 2022 19:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592632;
        bh=s0y8jrw/NpxTFVmtaDbYnEuZmzyn1sGmwDxqVD6MMgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOR///Pufx/C5mgXDNZgBsRLLQwiwTxSNh5GKsMga6xe0NZf6yEh8+mJ2mqEHST1z
         VPnLNcsdU+aQ2Hf76jBWEHlL76JgQaU4dhsE6SV8SVEGbklDKr56WHXE5UG72GP6W+
         LQNJNibc7NDMPbBL1Fs/qwq9q5tH7BwvDi02EsX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 0140/1157] netfilter: nf_tables: do not allow SET_ID to refer to another table
Date:   Mon, 15 Aug 2022 19:51:36 +0200
Message-Id: <20220815180445.220401630@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 470ee20e069a6d05ae549f7d0ef2bdbcee6a81b2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3842,6 +3842,7 @@ static struct nft_set *nft_set_lookup_by
 }
 
 static struct nft_set *nft_set_lookup_byid(const struct net *net,
+					   const struct nft_table *table,
 					   const struct nlattr *nla, u8 genmask)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3853,6 +3854,7 @@ static struct nft_set *nft_set_lookup_by
 			struct nft_set *set = nft_trans_set(trans);
 
 			if (id == nft_trans_set_id(trans) &&
+			    set->table == table &&
 			    nft_active_genmask(set, genmask))
 				return set;
 		}
@@ -3873,7 +3875,7 @@ struct nft_set *nft_set_lookup_global(co
 		if (!nla_set_id)
 			return set;
 
-		set = nft_set_lookup_byid(net, nla_set_id, genmask);
+		set = nft_set_lookup_byid(net, table, nla_set_id, genmask);
 	}
 	return set;
 }


